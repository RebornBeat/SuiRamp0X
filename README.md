# SuiRampX
SuiRampX is a decentralized platform on the Sui blockchain that facilitates peer-to-peer (P2P) transactions involving both cryptocurrencies and fiat currencies. The platform integrates non-custodial smart contracts for cryptocurrency escrows and collaborates with third-party decentralized escrow services to handle fiat transactions, including cash, PayPal, and bank transfers. SuiRampX ensures that all transactions are secure, transparent, and compliant with international regulations, all while maintaining a no-KYC (Know Your Customer) policy.


---

Table of Contents

1. Features


2. Architecture


3. Getting Started


4. Smart Contract Overview


5. Legal Compliance


6. FAQs


7. Privacy Policy


8. Terms of Service




---

Features

Non-Custodial Crypto Escrow: Utilizes Sui smart contracts to facilitate secure and trustless cryptocurrency transactions.

Third-Party Fiat Escrow Integration: Collaborates with decentralized escrow services to manage fiat transactions without taking custody of funds.

Multi-Payment Support: Supports various payment methods, including cash, PayPal, and bank transfers.

No KYC Required: Maintains user privacy by not requiring personal identification verification.

Global Compliance: Adheres to international regulations to ensure legal operation across multiple jurisdictions.



---

Architecture

1. Crypto Escrow (On-Chain)

Smart Contracts: Deploys non-custodial smart contracts on the Sui blockchain to manage cryptocurrency escrows.

Automation: Automatically releases funds upon fulfillment of predefined conditions, ensuring trustless transactions.


2. Fiat Escrow (Off-Chain)

Third-Party Decentralized Escrow Services: Integrates with services that handle fiat transactions, such as cash, PayPal, and bank transfers, without taking custody of funds.

User Choice: Allows users to select their preferred escrow service based on payment method and jurisdiction.


3. Hybrid Settlement Layer

Transaction Matching: Matches users for P2P trades involving both crypto and fiat currencies.

Dispute Resolution: Provides mechanisms for resolving disputes through smart contract logic and third-party services.



---

Getting Started

Prerequisites

Sui Wallet: Install and set up a Sui-compatible wallet.

Node.js: Ensure Node.js is installed for running the web interface.


Installation

1. Clone the Repository:

git clone https://github.com/your-org/SuiRampX.git
cd SuiRampX


2. Deploy Smart Contracts:

sui move build
sui move publish --gas-budget 50000


3. Run the Web Interface:

npm install
npm start




---

Smart Contract Overview

CryptoEscrow.move: Manages non-custodial escrows for cryptocurrency transactions.

FiatEscrowAdapter.move: Interfaces with third-party decentralized escrow services for fiat transactions.



---

Legal Compliance

SuiRampX operates within the legal frameworks of multiple jurisdictions by adhering to the following principles:

Decentralization: By not taking custody of funds and utilizing decentralized escrow services, SuiRampX minimizes regulatory burdens associated with custodial services.

No KYC Policy: While SuiRampX does not require KYC, users must ensure they comply with their local laws regarding cryptocurrency and fiat transactions.

Third-Party Compliance: Partnered escrow services are responsible for adhering to their respective regulatory requirements, including Anti-Money Laundering (AML) and Counter-Terrorist Financing (CTF) obligations.


For a comprehensive overview of cryptocurrency regulations by country, please refer to the Cryptocurrency Regulation Tracker by the Atlantic Council.


---

FAQs

Q1: How does SuiRampX ensure the security of my transactions?

A1: SuiRampX employs non-custodial smart contracts on the Sui blockchain for cryptocurrency transactions, ensuring that funds are only released when predefined conditions are met. For fiat transactions, we integrate with reputable decentralized escrow services that manage the escrow process without taking custody of funds.

Q2: Do I need to complete KYC to use SuiRampX?

A2: No, SuiRampX does not require users to complete KYC procedures. However, users are responsible for complying with their local laws and regulations regarding cryptocurrency and fiat transactions.

Q3: What payment methods are supported for fiat transactions?

A3: SuiRampX supports various payment methods for fiat transactions, including cash, PayPal, and bank transfers, through our integrated third-party decentralized escrow services.

Q4: How are disputes handled on SuiRampX?

A4: Disputes are managed through a combination of smart contract logic and the dispute resolution mechanisms provided by our partnered escrow services. This ensures a fair and transparent resolution process.

Q5: Is SuiRampX available worldwide?

A5: Yes, SuiRampX is a decentralized platform accessible globally. However, users should ensure they comply with their local laws and regulations when using the platform.


---

Privacy Policy

Effective Date: 02/13/2025

1. Introduction

SuiRampX ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our platform.

2. Information Collection

As a decentralized platform, SuiRampX does not collect personal information from its users. All transactions are conducted through smart contracts and third-party escrow services, ensuring privacy and security. However, users should be aware that third-party escrow providers may have their own data collection policies.

3. Use of Information
Since SuiRampX does not collect personal information, we do not store or use user data for any purpose. Any data processed through smart contracts remains on-chain and cannot be altered.

4. Third-Party Services
Users may choose to interact with third-party escrow services for fiat transactions. These services operate independently and are responsible for their own privacy policies and compliance with applicable regulations.

5. Security
SuiRampX employs blockchain-based smart contracts to facilitate secure transactions. Users should exercise caution when engaging in transactions and ensure they use trusted escrow providers for fiat transactions.

6. User Responsibilities
Users are responsible for complying with their local laws regarding cryptocurrency and fiat transactions. SuiRampX does not provide legal advice, and users should conduct their own due diligence before engaging in transactions.

7. Changes to this Privacy Policy
We reserve the right to update this Privacy Policy at any time. Changes will be reflected on this page.

8. Contact Information
For any questions regarding this Privacy Policy, please contact us via our decentralized governance forum.


---

Terms of Service (ToS)

Effective Date: 02/13/2025

1. Introduction

Welcome to SuiRampX, a decentralized, non-custodial platform facilitating peer-to-peer (P2P) transactions involving both cryptocurrencies and fiat currencies. By using our platform, you agree to the following terms.

2. Eligibility

By using SuiRampX, you confirm that you are legally allowed to engage in cryptocurrency and fiat transactions in your jurisdiction.

3. Decentralization & No Custody

SuiRampX does not hold user funds.

Cryptocurrency transactions occur via on-chain smart contracts.

Fiat transactions are facilitated through third-party escrow services.


4. No KYC Requirement

Users are not required to complete KYC verification.

Third-party escrow providers may impose their own KYC policies, which users must review independently.


5. Risks

Users acknowledge the risks associated with P2P trading.

SuiRampX is not responsible for disputes arising from transactions.


6. Dispute Resolution

Crypto disputes are managed via smart contracts.

Fiat transaction disputes are handled by the chosen escrow service.


7. Compliance & Legal Obligations

Users must comply with their local regulations regarding cryptocurrency and fiat trading.

SuiRampX is a decentralized platform and does not offer financial or legal advice.


8. Limitation of Liability

SuiRampX, its developers, and affiliates are not liable for losses, damages, or regulatory actions arising from the use of the platform.

9. Amendments

These terms may be updated periodically. Continued use of the platform constitutes acceptance of any revised terms.


---

Legal Compliance: Laws & Regulations by Country

SuiRampX operates in a decentralized manner, ensuring that it aligns with cryptocurrency and financial laws across multiple jurisdictions.

---

Final Notes

SuiRampX is a truly decentralized, permissionless platform that bridges the gap between fiat and crypto transactions while ensuring legal compliance through third-party integrations.


