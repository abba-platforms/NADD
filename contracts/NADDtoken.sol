// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title NADDToken
 * @dev Namibia Digital Dollar (NADD) stablecoin
 *      - ERC20 standard
 *      - Role-based access control
 *      - Minting, burning, pausing, and auditing features
 *      - Designed by Simon Kapenda for Namibia Bank Sandbox integration
 */
contract NADDToken is ERC20, AccessControl, Pausable, ERC20Burnable {
    // Role definitions
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant CUSTODIAN_ROLE = keccak256("CUSTODIAN_ROLE");

    /**
     * @dev Constructor that gives msg.sender the default admin role and mints initial supply if needed.
     * @param initialSupply The initial supply to mint (optional: can be 0 for fully controlled minting)
     */
    constructor(uint256 initialSupply) ERC20("Namibia Digital Dollar", "NADD") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);

        // Assign roles to admin by default
        _setupRole(MINTER_ROLE, msg.sender);
        _setupRole(BURNER_ROLE, msg.sender);
        _setupRole(PAUSER_ROLE, msg.sender);
        _setupRole(AUDITOR_ROLE, msg.sender);
        _setupRole(CUSTODIAN_ROLE, msg.sender);

        if (initialSupply > 0) {
            _mint(msg.sender, initialSupply);
        }
    }

    /**
     * @dev Mint new tokens to a specific account
     * @param to Address to receive minted tokens
     * @param amount Amount of tokens to mint
     */
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    /**
     * @dev Burn tokens from a specific account (must have BURNER_ROLE)
     * @param from Address from which tokens will be burned
     * @param amount Amount to burn
     */
    function burnFrom(address from, uint256 amount) public override onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }

    /**
     * @dev Pause all token transfers
     */
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /**
     * @dev Unpause token transfers
     */
    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /**
     * @dev Hook that checks for paused state before transfers
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Audit function: returns current balances of addresses
     *      Only accessible by AUDITOR_ROLE
     */
    function auditBalance(address account) external view onlyRole(AUDITOR_ROLE) returns (uint256) {
        return balanceOf(account);
    }

    /**
     * @dev Custodian function: placeholder for integration with bank reserves
     *      Only accessible by CUSTODIAN_ROLE
     */
    function updateReserve(address reserveAccount, uint256 amount) external onlyRole(CUSTODIAN_ROLE) {
        // Implementation depends on integration with Bank Sandbox
        // This could trigger minting, burning, or off-chain verification
    }
}
