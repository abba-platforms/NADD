# NADD Reserve Setup and Workflow

## Overview

NADD (Namibia Digital Dollar) is a blockchain-native stablecoin pegged 1:1 to the Namibian Dollar (NAD) and backed by hybrid reserves: fiat held in a custodian bank and on-ledger tokenized reserves. This ensures full transparency, compliance, and peg stability.

To bootstrap liquidity, NADD Labs Ltd will deposit an initial **Seed Reserve of NAD 5,000,000** in a secure custodian bank account.

---

## 1. Initial Reserve Deposit

- Amount: NAD 5,000,000 (Seed Reserve)
- Location: Custodian Bank Account (licensed and regulated)
- Purpose: Enable the initial minting of NADD tokens to users while maintaining a 1:1 peg.
- Ownership: NADD Labs Ltd maintains control over the reserve account.

Founder / NADD Labs Ltd ---> deposit **Seed Reserve NAD 5,000,000** ---> Custodian Bank ---> verified backing ---> NADD Smart Contract

---

## 2. User Minting Flow

Users can acquire NADD tokens through one of two primary pathways:

### a) Direct Bank Deposit

1. User deposits NAD into a custodian bank or a partnering local bank account linked to NADD Labs Ltd.
2. The custodian confirms receipt and issues a signed attestation of the deposit.
3. NADD smart contract mints equivalent NADD tokens (1 NADD = 1 NAD) to the user's blockchain wallet.
4. Custodian reserves automatically increase to match circulating NADD tokens.

User ---> deposit NAD X ---> Custodian/Partner Bank ---> attestation ---> NADD Smart Contract ---> mint ---> User Wallet: X NADD in real-time

> Note: The initial Seed Reserve NAD 5,000,000 is included in the total backing to support early minting until user deposits begin.

### b) Centralized Exchange (CEX) Purchase

1. User buys NADD on a CEX using NAD, USDT, or other supported fiat/digital pairs.
2. CEX deposits the equivalent NAD into the custodian reserve account.
3. NADD smart contract mints the corresponding NADD tokens and credits them to the user’s CEX wallet or linked blockchain wallet.
4. Custodian and smart contract records are reconciled to ensure full backing.

User ---> Buy NADD via CEX ---> CEX deposits NAD to Custodian ---> NADD Smart Contract mints ---> User Wallet/CEX Wallet: X NADD in real-time 

---

## 3. Redemption Flow

Users can redeem NADD tokens for NAD using one of two pathways:

### a) Direct Bank Redemption

1. User submits NADD tokens to the smart contract for burning.
2. Smart contract burns the NADD tokens.
3. Custodian or partner bank releases the equivalent NAD to the user’s bank account.

User Wallet: X NADD ---> burn ---> NADD Smart Contract ---> release NAD ---> Custodian/Partner Bank ---> transfer NAD ---> User in real-time 

### b) CEX Redemption

1. User submits NADD tokens for sale or withdrawal on the CEX.
2. CEX initiates smart contract burn of the corresponding NADD.
3. Custodian releases equivalent NAD to the CEX.
4. CEX credits the user’s bank account or other fiat withdrawal method.

User Wallet/CEX Wallet: X NADD ---> burn ---> NADD Smart Contract ---> release NAD ---> Custodian ---> CEX ---> User Bank Account in real-time 

> Note: If reserves exceed minted supply, the Seed Reserve NAD 5,000,000 can be withdrawn back to NADD Labs Ltd.

---

## 4. Supply and Peg Enforcement

- NADD can only be minted if fiat or on-ledger reserves exist to fully back it.
- Smart contract enforces total NADD supply <= total verified reserves.
- If reserves fall below circulating supply, minting is automatically halted until parity is restored.
- Periodic audits and cryptographic attestations ensure transparency and integrity.

---

## 5. Summary

- Initial **Seed Reserve:** NAD 5,000,000 in custodian bank to bootstrap NADD.
- User-Funded Expansion: Additional NADD tokens are minted only when users deposit NAD into the custodian account or via CEX purchases.
- Redemption: NADD burned and equivalent NAD released to users via custodian banks or CEX.
- Peg Security: 1:1 peg maintained through smart contract logic and custodian backing.
- Seed Reserve: NAD 5,000,000 can be withdrawn later if reserves exceed minted supply.
