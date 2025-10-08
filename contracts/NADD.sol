// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/governance/TimelockControllerUpgradeable.sol";

/// @title Namibia Digital Dollar (NADD)
/// @notice Enterprise-grade upgradeable ERC20 stablecoin pegged 1:1 to Namibia Dollar (NAD)
/// @author Simon Kapenda
contract NADD is ERC20Upgradeable, PausableUpgradeable, AccessControlEnumerableUpgradeable, UUPSUpgradeable, ReentrancyGuardUpgradeable {
    // Roles
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    /// @notice Governance threshold for large mints (adjustable)
    uint256 public GOVERNANCE_THRESHOLD;

    /// @notice Governance approvals required for large mints
    uint256 public GOVERNANCE_APPROVALS_REQUIRED;

    mapping(bytes32 => MintApproval) private approvedMints;
    mapping(bytes32 => bool) public executedMints;
    uint256 private mintRequestNonce;

    struct MintApproval {
        uint256 approvals;
        mapping(address => bool) approvedBy;
    }

    TimelockControllerUpgradeable public timelock;

    // Events
    event MintRequested(address indexed to, uint256 amount, uint256 indexed nonce, address indexed requester);
    event MintApproved(bytes32 indexed mintId, address indexed approver, uint256 approvals);
    event MintExecuted(bytes32 indexed mintId, address indexed to, uint256 amount, address indexed executedBy);
    event MintRevoked(bytes32 indexed mintId, address indexed revoker);
    event Burned(address indexed from, uint256 amount, address indexed by);
    event UpgradedImplementation(address indexed newImplementation);
    event TimelockUpdated(address indexed timelockAddress);
    event GovernanceApprovalsRequiredUpdated(uint256 newThreshold);
    event GovernanceThresholdUpdated(uint256 newThreshold);
    event VersionUpdated(string newVersion);

    string public constant VERSION = "1.0.1";

/// @custom:oz-upgrades-unsafe-allow constructor
constructor() {
    _disableInitializers();
}

    function initialize(
        string memory name_,
        string memory symbol_,
        address admin,
        address timelockAddress
    ) public initializer {
        __ERC20_init(name_, symbol_);
        __Pausable_init();
        __AccessControlEnumerable_init();
        __UUPSUpgradeable_init();
        __ReentrancyGuard_init();

        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setupRole(MINTER_ROLE, admin);
        _setupRole(BURNER_ROLE, admin);
        _setupRole(PAUSER_ROLE, admin);
        _setupRole(UPGRADER_ROLE, admin);
        _setupRole(GOVERNANCE_ROLE, admin);

        timelock = TimelockControllerUpgradeable(payable(timelockAddress));
        emit TimelockUpdated(address(timelock));
    }

    function _setGovernanceApprovalsRequired(uint256 newThreshold) internal {
        require(newThreshold >= 2 && newThreshold <= 10, "NADD: threshold out of range");
        GOVERNANCE_APPROVALS_REQUIRED = newThreshold;
        emit GovernanceApprovalsRequiredUpdated(newThreshold);
    }

    function setGovernanceApprovalsRequired(uint256 newThreshold) external onlyRole(GOVERNANCE_ROLE) {
        _setGovernanceApprovalsRequired(newThreshold);
    }

    function _setGovernanceThreshold(uint256 newThreshold) internal {
        require(newThreshold > 0, "NADD: threshold must be >0");
        GOVERNANCE_THRESHOLD = newThreshold;
        emit GovernanceThresholdUpdated(newThreshold);
    }

    function setGovernanceThreshold(uint256 newThreshold) external onlyRole(GOVERNANCE_ROLE) {
        _setGovernanceThreshold(newThreshold);
    }

    function setTimelock(address _timelock) external onlyRole(GOVERNANCE_ROLE) {
        timelock = TimelockControllerUpgradeable(payable(_timelock));
        emit TimelockUpdated(_timelock);
    }

    function requestMint(address to, uint256 amount) external onlyRole(MINTER_ROLE) whenNotPaused nonReentrant {
        require(to != address(0), "NADD: invalid recipient");
        require(amount > 0, "NADD: amount zero");

        bytes32 mintId = keccak256(abi.encode(to, amount, mintRequestNonce));
        emit MintRequested(to, amount, mintRequestNonce, msg.sender);

        if (amount > GOVERNANCE_THRESHOLD) {
            mintRequestNonce++;
            return;
        }

        require(!executedMints[mintId], "NADD: mint already executed");
        executedMints[mintId] = true;

        _mint(to, amount);
        emit MintExecuted(mintId, to, amount, msg.sender);
        mintRequestNonce++;
    }

    function approveLargeMint(address to, uint256 amount, uint256 nonce) external onlyRole(GOVERNANCE_ROLE) nonReentrant {
        bytes32 mintId = keccak256(abi.encode(to, amount, nonce));
        require(!executedMints[mintId], "NADD: mint already executed");

        MintApproval storage approval = approvedMints[mintId];
        require(!approval.approvedBy[msg.sender], "NADD: already approved");

        approval.approvedBy[msg.sender] = true;
        approval.approvals++;

        emit MintApproved(mintId, msg.sender, approval.approvals);

        if (approval.approvals >= GOVERNANCE_APPROVALS_REQUIRED) {
            executedMints[mintId] = true;
            _mint(to, amount);
            emit MintExecuted(mintId, to, amount, msg.sender);
            delete approvedMints[mintId];
        }
    }

    function getMintApprovals(address to, uint256 amount, uint256 nonce) external view returns (uint256 approvals) {
        bytes32 mintId = keccak256(abi.encode(to, amount, nonce));
        return approvedMints[mintId].approvals;
    }

    function revokeLargeMint(address to, uint256 amount, uint256 nonce) external onlyRole(GOVERNANCE_ROLE) nonReentrant {
        bytes32 mintId = keccak256(abi.encode(to, amount, nonce));
        MintApproval storage approval = approvedMints[mintId];

        require(approval.approvedBy[msg.sender], "NADD: not approved yet");

        approval.approvedBy[msg.sender] = false;
        approval.approvals--;

        emit MintRevoked(mintId, msg.sender);
    }

    function burn(address from, uint256 amount) external onlyRole(BURNER_ROLE) whenNotPaused nonReentrant {
        require(amount > 0, "NADD: amount zero");
        _burn(from, amount);
        emit Burned(from, amount, msg.sender);
    }

    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {
        require(msg.sender == address(timelock), "NADD: upgrade only via timelock");
        emit UpgradedImplementation(newImplementation);
    }

    function creator() external pure returns (string memory) {
        return "Simon Kapenda";
    }

    function version() external pure returns (string memory) {
        return VERSION;
    }

    uint256[48] private __gap; // Adjusted for extra storage variables
}
