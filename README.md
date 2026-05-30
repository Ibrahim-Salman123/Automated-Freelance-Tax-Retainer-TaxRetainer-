An on-chain financial compliance and automated tax withholding routing terminal built on Ethereum using Solidity. This contract automatically segregates sovereign tax allocations from independent contractor and freelance invoices at the source.

📌 Overview
The TaxRetainer smart contract provides a programmatic solution for independent workers, digital nomads, and freelance consultants facing complex tax calculations. By acting as an inbound invoicing routing gateway, the code automatically separates client payments into distinct disposable income and tax reserve pools. This layout prevents retroactive calculation oversight, eliminates corporate liquidity crunches at the end of fiscal periods, and optimizes regulatory compliance.

🛠 Features
Source-Side Financial Splitting: Instantly parses incoming client funds upon receipt, dividing resources into pre-calculated retention balances.

Anti-Diversion Liquidity Lock: Safeguards tax reserves by locking them inside a non-divertible ledger, ensuring funds owed to public revenue services are never spent accidentally.

Dual-Trigger Revenue Settlement: Minimizes administration time by allowing either the freelancer or the designated revenue collection office to execute final tax clearances.

Dynamic Retainer Adaptation: Gives freelancers full authority to modify the retention percentage parameters to keep up with changing tax brackets or business scales.

📄 Smart Contract Architecture
State Variables
freelancer: The wallet address of the service provider who routes invoices through the contract and receives immediate post-tax revenue.

taxAuthority: The official wallet destination belonging to the public treasury or regional tax collection agency.

taxRate: An integer indicating the percentage withholding rate (e.g., 20 translates to a 20% withholding deduction).

accumulatedTax: A running counter tracking the total volume of locked Wei currently reserved for tax payments.

⚙️ Core Functions
1. receiveFreelancePayment()
Permission: External Payable (Called by clients paying invoices)

Description: Accepts incoming funds, calculates tax withholdings using the formula (msg.value * taxRate) / 100, adds this value to accumulatedTax, and instantly sends the remaining net balance to the freelancer address.

2. payTaxToAuthority()
Permission: Freelancer or TaxAuthority only

Description: Flushes the entire accumulated tax ledger. To prevent reentrancy attacks, the contract sets accumulatedTax = 0 before executing the external transfer of funds directly to the taxAuthority account.

3. updateTaxRate(uint256 _newRate)
Permission: Only freelancer

Description: Allows the contractor to update the active retention rate. Includes a structural guardrail (require(_newRate <= 50)) to protect against excessive tax rates.

🔔 Events
PaymentReceived(address indexed client, uint256 totalAmount, uint256 taxWithheld, uint256 freelancerShare): Emitted when a client pays an invoice, recording the exact split breakdown on-chain.

TaxPaid(address indexed authority, uint256 amount): Emitted when tax pools are swept and cleared to the government collection wallet.

TaxRateUpdated(uint256 newRate): Emitted when parameters are altered due to fiscal or bracket updates.

🚀 Tech Stack & Setup
Language: Solidity ^0.8.20

Tools: Remix IDE / Hardhat / Foundry

Standard Deploy Instructions: Provide the _taxAuthority public wallet key and target _taxRate integer as parameters during deployment. The wallet deploying the contract is automatically registered as the operational freelancer.
