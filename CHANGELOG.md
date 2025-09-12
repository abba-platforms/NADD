# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

----------

## [v1.0.4] - 2025-09-12

### Added

-   Detailed NADD Trust Framework (`NADD_TRUST_FRAMEWORK.md`) committed to the repository for technical, governance, and compliance reference
-   Expanded sections on security, compliance, governance, reserve management, economic insights, and lessons from private stablecoins (USDT, USDC)
-   Integration notes for Bank of Namibia sandbox and regulatory alignment added

### Changed

-   README.md updated to reference `NADD_TRUST_FRAMEWORK.md` with link and brief summary of contents

### Fixed

-   No code fixes; purely documentation update

----------

## [v1.0.3] - 2025-09-12

### Added

-   README.md updated to include **NADD Trust Framework (v1.4)** section
-   Link to `NADD_TRUST_FRAMEWORK.md` provided for technical, governance, and compliance reference
-   Summary of Trust Framework contents added: security, compliance, governance, reserves, economic integration, lessons from USDT/USDC, sandbox and regulatory alignment

### Changed

-   Executive Summary and introduction restored to original wording while integrating new Trust Framework section

### Fixed

-   No code fixes; purely documentation and repository structure update

----------

## [v1.0.2] - 2025-09-08

### Added

-   README.md updated to include **Deployment & Testnet Contract Address** for $NADD
-   Binance Smart Chain Testnet contract address: `0x37341372B5D466Fc7381905cCaC683c64580512B`
-   Clarification that NADD is currently on Testnet pending Bank of Namibia sandbox integration

### Changed

-   README.md refined to highlight testnet status and safe interaction guidelines

### Fixed

-   Minor formatting issues in README.md related to badges and headings

----------

## [v1.0.1] - 2025-09-08

-   Initial deployment to BSC Testnet
-   NADD token smart contract (`NADDtoken.sol`) added
-   Deployment script (`deploy.ts`) added
-   Whitepaper (`WHITEPAPER.md`) added
-   ECONOMY_OF_NADD.md added with market and economic analysis
-   Hardhat configuration (`hardhat.config.ts`) added
-   Environment example (`.env.example`) added
-   README.md updated with full documentation
-   LICENSE.md updated with MIT license and copyright
-   SECURITY.md added outlining vulnerability reporting and policy

----------

## [v1.0.0] - 2025-09-08

### Added

-   Full enterprise-grade Whitepaper for NADD
-   Smart contract deployed on BSC Testnet: `0x37341372B5D466Fc7381905cCaC683c64580512B`
-   Scripts for deployment (`deploy.ts`)
-   Tokenomics and market analysis document (`ECONOMY_OF_NADD.md`)
-   Raw markdown copies of contracts and deployment scripts added for transparency
-   README.md and repository structure documentation
-   SECURITY.md for security policy and reporting
-   License file updated for MIT license
-   .env.example template added for configuration
-   Tags and repository topics added for discoverability

### Changed

-   README.md updated to reflect current BSC Testnet deployment and repository files
-   License section updated with proper copyright and MIT reference

### Fixed

-   Hardhat TypeScript configuration errors resolved
-   Smart contract artifact naming conflicts resolved (`NADDToken`)
