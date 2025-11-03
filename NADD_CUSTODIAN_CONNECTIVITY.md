# Custodian Bank Connectivity for NADD

## Overview

To ensure transparency and verifiable asset backing for the Namibia Digital Dollar (NADD), **NADD Labs Ltd** implements a **hybrid reserve model** combining both **fiat reserves** (held with licensed custodian banks) and **on-ledger tokenized reserves** (backed by blockchain-based assets).

Custodian banks form the foundation of NADD’s off-chain backing. They hold equivalent Namibian Dollar (NAD) fiat deposits that mirror the total circulating NADD supply. This design enables NADD to maintain a 1:1 parity with the Namibian Dollar while enabling programmable financial systems on-chain.

## Hybrid Reserve Structure

| Reserve Type | Description | Example |
|---------------|--------------|----------|
| **Fiat Reserves** | Actual NAD funds deposited with the licensed custodian bank(s). These accounts are audited and reconciled regularly. | A local commercial bank |
| **On-Ledger Reserves** | Tokenized representations of assets or digital vault accounts verifiable on-chain. Managed via the `ReserveManager` smart contract. | BNB Smart Chain, Ethereum Mainnet |

The **hybrid reserve model** allows NADD to function with both **real-world fiat liquidity** and **digital programmability**, enabling scalability while ensuring accountability and compliance.

## Technical Connectivity

Once a custodian bank is appointed, it connects to NADD’s blockchain infrastructure via secure API and on-ledger attestation mechanisms.

### Core Components

1. **Custodian API Gateway**
   - Enables real-time synchronization between off-chain fiat holdings and on-chain reserve records.
   - Provides deposit/withdrawal reconciliation endpoints.
   - Supports encrypted communication and periodic hash-based proofs.

2. **ReserveManager Smart Contract**
   - Tracks on-ledger reserves and associates them with specific custodian accounts.
   - Handles minting/burning operations based on verified reserve changes.
   - Ensures that total NADD supply never exceeds total verified reserves.

3. **Attestation Registry**
   - A public ledger where the custodian (or third-party auditor) submits cryptographic proofs of reserves.
   - Updates automatically via API or manual reporting cycles.

### Minting and Redemption Flow

1. **Fiat Deposit:**  
   The user deposits NAD into a custodian bank account under NADD Labs Ltd.

2. **Verification:**  
   The custodian confirms receipt of funds and issues a signed attestation.

3. **Minting:**  
   NADD Labs invokes the `mint()` function, issuing NADD tokens equal to the verified fiat amount.

4. **Redemption:**  
   When a user wishes to redeem, NADD tokens are burned, and the equivalent fiat NAD is released from the custodian account.

## Smart Contract Enforcement

NADD’s reserve logic ensures absolute parity and prevents over-issuance. The totalReserves() function aggregates both fiat and on-ledger holdings — ensuring NADD’s supply never exceeds total verified reserves.

If fiat or on-chain reserves fall below circulating supply, the system automatically halts new minting operations until parity is restored.

## Audit and Transparency

- **Real-Time Dashboard:** Displays current fiat and on-ledger reserves.
- **Attestation Updates:** Submitted by custodians or auditors at defined intervals.
- **Public Smart Contract View:** Anyone can verify on-chain reserves through blockchain explorers.

## Security and Compliance

- All custodian integrations follow ISO 20022 messaging standards for financial data exchange.
- Fiat accounts are protected under Namibian banking law and managed through regulated financial institutions.
- NADD Labs Ltd conducts regular external audits to ensure full transparency and compliance.

## Summary

The NADD custodian integration ensures a transparent and verifiable bridge between fiat banking systems and blockchain infrastructure.  
By combining fiat reserves and on-ledger reserves, NADD maintains a stable, compliant, and programmable financial ecosystem — setting a new standard for digital currency issuance in Africa.
