# Namibia Digital Dollar (NADD)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE) 
![Built with Solidity](https://img.shields.io/badge/built%20with-Solidity-363636) 
![ERC-20 Compliant](https://img.shields.io/badge/ERC--20-Compliant-brightgreen) 
[![Security Policy](https://img.shields.io/badge/Security-Policy-blue.svg)](SECURITY.md)

## Deployment & Contract Address

The **Namibia Digital Dollar (NADD)** is currently deployed on **Binance Smart Chain Testnet** for sandbox testing and validation.  

**BSC Testnet Contract Address:** `0x37341372B5D466Fc7381905cCaC683c64580512B`

You can interact with the token using compatible wallets (e.g., MetaMask) and integrate it into the **Abba App** for testing purposes.  

> ⚠️ Note: This is a testnet deployment. NADD is **not yet live on mainnet** and should not be used for real transactions.

----------

## Executive Summary

The **Namibia Digital Dollar (NADD)** is a blockchain-native, 1:1 Namibian Dollar-pegged stablecoin designed to modernize national payments, enable secure real-time transactions, and accelerate financial inclusion. NADD combines regulatory-compliant smart contracts, role-based governance, EIP-712 off-chain authorization, and reserve attestation to provide a transparent, auditable digital currency backed by fiat reserves.

This repository contains the project’s technical artifacts, deployment scripts, whitepaper, economic analysis, and testing scaffolding for sandbox and testnet operations.

----------

## Overview

NADD is built for safety, compliance, and programmability. It integrates with the **Abba App** to deliver mobile-first payments, merchant acceptance, and remittances. NADD is intended to be tested in the **Bank of Namibia Sandbox** before any mainnet deployment. The smart contracts are developed using OpenZeppelin patterns and follow strict role-based controls to limit privileged operations (mint, burn, pause).

----------

## Key Features

-   **1:1 Peg** — Each NADD is intended to be fully backed by NAD reserves.
-   **Role-Based Governance** — DEFAULT_ADMIN, MINTER, BURNER, PAUSER, AUDITOR, CUSTODIAN.
-   **EIP-712 Authorization** — Off-chain deposit certificates signed by custodians to allow gas-efficient minting.
-   **Pausable** — Emergency pause/unpause for safety.
-   **Reserve Attestation Oracle** — On-chain record of attestation reports and reported reserves.
-   **Auditability** — All mint/burn events and attestation records are on-chain for public inspection.
-   **Abba App Integration** — Seamless UX for end-users and merchants.
-   **Sandbox-first** — Designed to operate under Bank of Namibia sandbox rules before any production deployment.

----------

## Technology Stack

-   **Smart Contracts:** Solidity (0.8.x), OpenZeppelin contracts (AccessControl, Pausable, ERC20, EIP-712).
-   **Dev & Test:** Hardhat, ethers.js, mocha/chai tests.
-   **Network Target:** BNB Smart Chain (BSC) Testnet initially; mainnet only after audits and sandbox approval.
-   **Oracles & Attestation:** Simple ReserveAttestationOracle for publishing attestations; off-chain auditors/custodians provide signed reports.
-   **Frontend / Mobile:** Abba App (Android/iOS) for wallet operations and KYC flows.
-   **Storage & Docs:** GitHub repo for source + public docs.

----------

## Token Economics

-   **Peg:** 1 NADD = 1 NAD (aimed).
-   **Minting:** Tokens are minted only when a verified fiat deposit certificate (signed by an authorized custodian) is presented to the contract and executed by a MINTER (multisig recommended).
-   **Burning:** Tokens are burned on redemption requests when custodial processes confirm fiat withdrawal.
-   **Reserve Management:** Custodial bank accounts hold reserves; ReserveAttestationOracle publishes attestations and links to audit reports.
-   **Supply Controls:** No automatic inflation — minting is strictly permissioned and tied to on-chain proofs of off-chain reserves.
-   **Use Cases:** P2P payments, merchant settlement, payroll, remittances, programmable disbursements (social support), and tokenized financial services.

----------

## Security & Compliance

-   **Design Principles:** Minimize attack surface, keep on-chain logic minimal and auditable, keep complex workflows off-chain where appropriate (but always provable).
-   **Libraries:** OpenZeppelin audited libraries used for ERC-20, AccessControl, Pausable, EIP-712 utilities.
-   **Roles & Operational Security:** MINTER/BURNER/CUSTODIAN keys should be held by different multisigs (e.g., Gnosis Safe) and covered by internal processes.
-   **Audits:** Multiple independent audits (internal, external) recommended before any production deployment.
-   **KYC/AML:** Integrated via Abba App; regulatory reporting and compliance logic designed for sandbox review.
-   **Upgradeability:** If upgradeability is required, use a timelock and multisig governance rather than single-key ownership. Prefer minimal upgradable surface and clear governance.

----------

## Roadmap

**Phase 0 – Research & Design**

-   Architecture design, regulatory outreach, partner onboarding (custodians, banks).

**Phase 1 – Dev & Test**

-   Smart contracts implemented; unit & integration tests; testnet deployment (BSC testnet).

**Phase 2 – Sandbox Integration**

-   Onboarding with Bank of Namibia sandbox; integration of custodial flows, KYC, & attestation processes; controlled pilot.

**Phase 3 – Audit & Security**

-   Third-party audits (OpenZeppelin-style recommended), bug bounties, formal verification of critical flows.

**Phase 4 – Production Readiness**

-   Finalize multisig governance, timelock, legal frameworks, insurance & custodial agreements.

**Phase 5 – Mainnet & Scale**

-   Mainnet deployment (post-sandbox & legal sign-off), merchant integrations, cross-border pilots, financial product expansion.

----------

## Risks & Mitigation

-   **Smart contract vulnerabilities** — mitigation: audits, minimal on-chain logic, tests, Slither/Static analysis.
-   **Custody & reserve risk** — mitigation: audited custodians, frequent attestations, public attestation history.
-   **Regulatory risk** — mitigation: sandbox engagement, legal counsel, KYC/AML integration.
-   **Operational compromise** — mitigation: multisig for all privileged roles, separation of duties, monitoring and alerts.
-   **User risk (key loss)** — mitigation: user education, optional custodial services, recovery flows for institutional accounts.

----------

## Governance & Operational Controls

-   Roles are assigned on deployment and must be controlled by secure governance (multi-sig, institutional custody).
-   Admin powers should be restricted; prefer time-locked governance proposals and multi-sig signoffs for major changes.
-   All attestations and mint/burn events are viewable on-chain for auditability.

----------

## Contribution Policy (Important)

NADD is a **regulated stablecoin project** with financial, legal, and operational implications. Therefore:

-   **Public contributions are not accepted** at this time.
-   The repository is published for **transparency and review only**.
-   All changes, audits, and deployments are controlled by the project core team and authorized partners.
-   If external researchers discover vulnerabilities, please follow the `SECURITY.md` disclosure process (see the `SECURITY` section below).

----------

## SECURITY / Responsible Disclosure

If you discover a security issue:

1.  Do not publish details publicly.
2.  Contact the project via the disclosed security channel (create an issue labeled `security` or email the security contact listed in repo).
3.  Provide a clear, reproducible test case.
4.  The team will acknowledge within 48 hours and work to remediate.

(If you want, I can draft a full `SECURITY.md` with contact and PGP key instructions.)

----------

## Repository Structure

-   `contracts/` — Solidity contracts
    -   `NADDtoken.sol` (ERC-20 + EIP-712 deposit certificate verification + role-based control)
    -   `ReserveAttestationOracle.sol` (attestation storage & indexing)
-   `scripts/` — deploy & utility scripts (Hardhat)
    -   `deploy.ts` (deploy contracts, set initial roles)
    -   `sign-and-build-calldata.ts` (helper for producing deposit certs)
-   `./` — unit & integration tests (mocha/chai)
-   `./` — formal docs, diagrams, regulatory artifacts
-   `WHITEPAPER.md` — full whitepaper
-   `ECONOMY_OF_NADD.md` — economic analysis and market study
-   `.env.example` — environment template (do not commit private keys)
-   `hardhat.config.ts` — Hardhat config
-   `LICENSE` — MIT license text and copyright
-   `SECURITY.md` — responsible disclosure instructions (recommended)
-   `.github/workflows/` — CI (optional): compile/test checks

> Keep `artifacts/`, `cache/`, and `node_modules/` in `.gitignore`.

----------

## Getting Started (Developer)

### Prerequisites

-   Node.js (LTS recommended)
-   npm or yarn
-   Git client
-   MetaMask or wallet with testnet funds for deployment

### Installation

Clone and install:

```bash
git clone https://github.com/abba-platforms/NADD.git
cd NADD
npm install

```

Create `.env` from `.env.example` and fill in values (don’t commit `.env`):

```
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
BSCTEST=https://data-seed-prebsc-1-s1.binance.org:8545/
NADD_ADDRESS=0xYourNADDAddress
BENEFICIARY=0xBeneficiaryAddress
AMOUNT=1
DEPOSIT_REF=BANKDEP-TEST-001

```

### Compile Contracts

```bash
npx hardhat compile

```

### Run Tests

```bash
npx hardhat test

```

Note: tests assume sample keys and local/testnet environment. Review tests and modify accounts/roles as needed.

----------

## Deploy (Testnet)

Deploy to BSC Testnet:

```bash
npx hardhat run scripts/deploy.ts --network bsctest

```

The deploy script will:

-   Deploy `NADDtoken` and `ReserveAttestationOracle`
-   Set initial admin roles (for testnet deployer)
-   Optionally grant CUSTODIAN_ROLE to a test key (not for production)

After deploy, copy the deployed contract addresses into `.env` (or the repo README) for reference.

----------

## How Minting Works (High-Level)

1.  Off-chain: Custodian receives fiat deposit and generates a `DepositCertificate` JSON including beneficiary, amount, currency, depositRef, timestamp, and nonce.
2.  Custodian signs the typed-data (`EIP-712`) using its custody key.
3.  Minter (on-chain actor, likely multisig) submits the certificate and the custodian signature to `mintWithCert()` in the `NADDtoken.sol` contract.
4.  Contract verifies signature against `CUSTODIAN_ROLE`, checks for replay (fiatRefHash), mints tokens to beneficiary, and marks certificate used.
5.  Attestation Oracle receives periodic reserve audit reports signed by auditors and publishes them for transparency.

----------

## Reserve Attestation & Oracle

`ReserveAttestationOracle` holds attestations with:

-   timestamp
-   submittedBy (attestor)
-   reportHash (hash of the off-chain audit report)
-   totalReserves (numeric)
-   uri (link to the attestation / report)

Design notes:

-   Oracles are simple on-chain records; heavy report content stays off-chain (IPFS/HTTPS).
-   Attestations are time-stamped to provide an audit trail and public verification.

----------

## Economic & Market Insights (Summary)

See `ECONOMY_OF_NADD.md` for the full analysis. In short:

-   NADD aims to reduce cash handling costs, speed settlement, and increase financial inclusion.
-   It supports remittances, merchant payments, and programmable disbursements (social programs/payments).
-   Reserve transparency (attestations & audits) is key to maintaining confidence in the peg.

----------

## Examples & Developer Tools

-   `scripts/sign-and-build-calldata.ts` — example script to produce an EIP-712 signature for deposit certificates and print ABI-encoded calldata for `mintWithCert`.
-   `test/` contains unit tests demonstrating minting flow (EIP-712 signing via ethers `_signTypedData` in tests), burn flows, pause/unpause, and oracle attestations.

----------

## CI / Quality Gate (Recommended)

-   Use GitHub Actions to:
    -   run `npx hardhat compile`
    -   run `npx hardhat test`
    -   run static analysis (Slither / MythX for deeper checks) on pull requests
-   Require passing checks for any change to contracts or critical scripts.

----------

## License

© 2025 Abba Payments Ltd.  
Simon Kapenda, Creator and Developer

This project is licensed under the **MIT License**. See the `LICENSE` file for full text.

----------

## Regulatory Disclaimer

NADD is a regulated-stablecoin initiative. Nothing in this repository constitutes financial, investment, or legal advice. Use of NADD or any code herein is subject to regulatory approval and local law. This repository is published for transparency and technical review only. Do not rely on this repo for operational funds or production-critical deployments without appropriate legal, regulatory, and technical approvals.

----------

## References

-   EIP-20: ERC-20 Token Standard — [https://eips.ethereum.org/EIPS/eip-20](https://eips.ethereum.org/EIPS/eip-20)
-   EIP-712: Typed Structured Data — [https://eips.ethereum.org/EIPS/eip-712](https://eips.ethereum.org/EIPS/eip-712)
-   OpenZeppelin Contracts — [https://openzeppelin.com/contracts/](https://openzeppelin.com/contracts/)
-   Abba App — [https://www.abbapp.com](https://www.abbapp.com)
-   CillarCoin — [https://cillar.io](https://cillar.io)
-   AFRX — [https://afrx.io](https://afrx.io)

----------

## Author & Creator

**Simon Kapenda**  
Founder & Creator — Abba Payments Ltd., Oshakati, Namibia  
Creator & Developer of: CillarCoin ($CILLAR), AFRX Security Token, $ENGLISH MEMECOIN, and Abba App.  
LinkedIn: [https://linkedin.com/in/simonkapenda](https://linkedin.com/in/simonkapenda)

----------
