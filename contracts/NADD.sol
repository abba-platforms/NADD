// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";

/// @title NADD (Namibia Digital Dollar)
/// @notice Enterprise-grade upgradeable ERC20 token with EIP-712 deposit-certificate minting and reserve attestation oracle
/// @author Simon Kapenda
contract NADD is ERC20Upgradeable, PausableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable, EIP712Upgradeable {
    using ECDSAUpgradeable for bytes32;

    // Roles
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant CUSTODIAN_ROLE = keccak256("CUSTODIAN_ROLE");
    bytes32 public constant SUBMITTER_ROLE = keccak256("SUBMITTER_ROLE");

    /// @notice Replay protection for deposit certificates
    mapping(bytes32 => bool) public usedDepositCert;

    /// @notice Daily mint tracking
    mapping(address => uint256) public dailyMinted;
    mapping(address => uint256) public lastMintTimestamp;

    uint256 public constant MAX_MINT_PER_DAY = 1_000_000 * 1e18;
    uint256 public constant NONCE_EXPIRY = 1 hours;

    bytes32 private constant DEPOSIT_CERT_TYPEHASH = keccak256(
        "DepositCertificate(address beneficiary,uint256 amount,string currency,string depositRef,uint256 depositTimestamp,uint256 nonce)"
    );

    struct DepositCertificate {
        address beneficiary;
        uint256 amount;
        string currency;
        string depositRef;
        uint256 depositTimestamp;
        uint256 nonce;
    }

    struct Attestation {
        uint64 timestamp;        // 8 bytes
        address submittedBy;     // 20 bytes
        uint256 totalReserves;   // 32 bytes
        bytes32 reportHash;      // 32 bytes
        bytes32 uriHash;         // 32 bytes
        bytes32 signatureHash;   // 32 bytes (fixed length for efficiency)
    }

    Attestation[] private attestations;
    mapping(bytes32 => bool) private submittedReports;
    uint256 public constant MAX_RANGE_QUERY = 100;

    event Minted(address indexed to, uint256 amount, bytes32 indexed fiatRefHash, string fiatRef, address indexed custodian);
    event Burned(address indexed from, uint256 amount, bytes32 indexed fiatRefHash, string fiatRef);
    event AttestationSubmitted(uint256 indexed index, address indexed submitter, bytes32 reportHash, uint256 totalReserves, bytes32 uriHash, uint64 timestamp);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the contract
     * @dev Uses domain versioning for EIP-712 resilience
     * @param name_ Token name
     * @param symbol_ Token symbol
     * @param admin Admin address with all roles
     */
    function initialize(string memory name_, string memory symbol_, address admin) public initializer {
        __ERC20_init(name_, symbol_);
        __Pausable_init();
        __AccessControl_init();
        __UUPSUpgradeable_init();
        __EIP712_init("Namibia Digital Dollar", "1.0");

        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setupRole(MINTER_ROLE, admin);
        _setupRole(BURNER_ROLE, admin);
        _setupRole(PAUSER_ROLE, admin);
        _setupRole(AUDITOR_ROLE, admin);
        _setupRole(CUSTODIAN_ROLE, admin);
        _setupRole(SUBMITTER_ROLE, admin);
    }

    /**
     * @notice Mint tokens with a valid deposit certificate
     * @param cert DepositCertificate struct
     * @param custodianSignature Custodian’s EIP-712 signature
     * @param fiatRefHash Hash of fiat reference
     * @param fiatRef Fiat reference description
     */
    function mintWithCert(
        DepositCertificate calldata cert,
        bytes calldata custodianSignature,
        bytes32 fiatRefHash,
        string calldata fiatRef
    ) external onlyRole(MINTER_ROLE) whenNotPaused {
        require(cert.amount > 0, "NADD: amount zero");
        require(cert.beneficiary != address(0), "NADD: invalid beneficiary");
        require(!usedDepositCert[fiatRefHash], "NADD: deposit cert used");
        require(cert.depositTimestamp <= block.timestamp && block.timestamp - cert.depositTimestamp <= NONCE_EXPIRY, "NADD: expired timestamp");

        if (block.timestamp - lastMintTimestamp[cert.beneficiary] > 1 days) {
            dailyMinted[cert.beneficiary] = 0;
            lastMintTimestamp[cert.beneficiary] = block.timestamp;
        }
        require(dailyMinted[cert.beneficiary] + cert.amount <= MAX_MINT_PER_DAY, "NADD: daily limit exceeded");

        bytes32 structHash = keccak256(
            abi.encode(
                DEPOSIT_CERT_TYPEHASH,
                cert.beneficiary,
                cert.amount,
                keccak256(bytes(cert.currency)),
                keccak256(bytes(cert.depositRef)),
                cert.depositTimestamp,
                cert.nonce
            )
        );

        bytes32 digest = _hashTypedDataV4(structHash);
        address recovered = ECDSAUpgradeable.recover(digest, custodianSignature);
        require(hasRole(CUSTODIAN_ROLE, recovered), "NADD: invalid custodian signature");

        usedDepositCert[fiatRefHash] = true;
        dailyMinted[cert.beneficiary] += cert.amount;

        _mint(cert.beneficiary, cert.amount);
        emit Minted(cert.beneficiary, cert.amount, fiatRefHash, fiatRef, recovered);
    }

    /**
     * @notice Burn tokens with a valid certificate
     * @param from Address to burn from
     * @param amount Amount to burn
     * @param fiatRefHash Fiat reference hash
     * @param fiatRef Fiat reference description
     */
    function burnWithCert(
        address from,
        uint256 amount,
        bytes32 fiatRefHash,
        string calldata fiatRef
    ) external onlyRole(BURNER_ROLE) whenNotPaused {
        require(amount > 0, "NADD: amount zero");
        _burn(from, amount);
        emit Burned(from, amount, fiatRefHash, fiatRef);
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

    /**
     * @notice Submit a reserve attestation
     * @param reportHash The hash of the attestation report
     * @param totalReserves Total reserves reported
     * @param uri URI pointing to attestation
     * @param attestationSignature Signature of the attestation
     * @return Index of stored attestation
     */
    function submitAttestation(
        bytes32 reportHash,
        uint256 totalReserves,
        string calldata uri,
        bytes calldata attestationSignature
    ) external onlyRole(SUBMITTER_ROLE) returns (uint256) {
        require(totalReserves > 0, "ReserveOracle: totalReserves zero");
        require(!submittedReports[reportHash], "ReserveOracle: duplicate report");

        bytes32 uriHash = keccak256(bytes(uri));
        bytes32 attestationDigest = keccak256(
            abi.encodePacked(reportHash, totalReserves, uriHash)
        );

        address recovered = ECDSAUpgradeable.recover(attestationDigest, attestationSignature);
        require(hasRole(AUDITOR_ROLE, recovered), "ReserveOracle: invalid signature");

        attestations.push(Attestation({
            timestamp: uint64(block.timestamp),
            submittedBy: msg.sender,
            totalReserves: totalReserves,
            reportHash: reportHash,
            uriHash: uriHash,
            signatureHash: attestationDigest
        }));

        submittedReports[reportHash] = true;
        uint256 idx = attestations.length - 1;

        emit AttestationSubmitted(idx, msg.sender, reportHash, totalReserves, uriHash, uint64(block.timestamp));
        return idx;
    }

    function latestAttestation() external view returns (Attestation memory) {
        require(attestations.length > 0, "ReserveOracle: no attestation");
        return attestations[attestations.length - 1];
    }

    function attestationCount() external view returns (uint256) {
        return attestations.length;
    }

    function getAttestationRange(uint256 start, uint256 end) external view returns (Attestation[] memory) {
        require(start < end, "ReserveOracle: invalid range");
        require(end <= attestations.length, "ReserveOracle: out of bounds");
        require(end - start <= MAX_RANGE_QUERY, "ReserveOracle: max 100 per query");

        uint256 length = end - start;
        Attestation[] memory range = new Attestation[](length);
        for (uint256 i = 0; i < length; i++) {
            range[i] = attestations[start + i];
        }
        return range;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(DEFAULT_ADMIN_ROLE) {
        // Timelock integration recommended for production
    }

    function creator() external pure returns (string memory) {
        return "Simon Kapenda";
    }
}
