# Security Policy

### Supported Versions
The Namibia Digital Dollar (NADD) project is in **active development**. Only the latest version of the codebase in this repository is officially supported. Older versions should not be relied upon for deployment.

| Version        | Supported          |
|----------------|--------------------|
| Latest (main)  | ✅ Supported        |
| Older branches | ❌ Not supported    |

---

## Reporting a Vulnerability
We take security vulnerabilities very seriously.  

If you discover a security issue related to the NADD smart contracts, infrastructure, or supporting tools:

1. **Do not** open a public GitHub issue.  
2. **Do not** disclose the issue publicly until it has been addressed.  
3. Instead, please email the development team directly at:  

📧 **security@nadd.io**

Please include:
- A clear description of the issue  
- Steps to reproduce the vulnerability  
- Affected components (e.g., contracts, scripts, configs)  
- Potential impact and risk assessment  

---

## Security Practices
- All smart contracts use **OpenZeppelin libraries** and follow industry best practices.  
- Contracts are deployed with **role-based access controls** to prevent unauthorized minting, burning, or pausing.  
- The NADD contracts undergo **internal audits** before major deployments.  
- **Third-party audits** may be commissioned prior to mainnet release.  
- Testnet deployments are used for sandbox and integration testing before production launch.  
- Regular **dependency and package updates** are applied to reduce supply chain risks.  
- Sensitive information such as private keys, API keys, and environment variables is never stored in this repository.  

---

## Responsible Disclosure
We request that researchers and users practice **responsible disclosure** by:
- Giving the development team reasonable time to fix issues before publicizing them.  
- Avoiding exploitation of any discovered vulnerabilities.  
- Coordinating with us on timing for public disclosure.  

---

## Compliance Considerations
Since NADD is a **regulated stablecoin project**, all vulnerabilities or incidents that may affect users, reserves, or compliance will be reviewed with regulators and sandbox authorities (Bank of Namibia) as necessary.  

---

## Acknowledgements
We thank all security researchers, auditors, and community members who contribute to making NADD secure, transparent, and reliable.  

---
