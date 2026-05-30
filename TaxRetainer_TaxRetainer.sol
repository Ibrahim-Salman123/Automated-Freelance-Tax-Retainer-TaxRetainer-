// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TaxRetainer
 * @notice Automatically splits independent income into dedicated tax and disposable income pools.
 */
contract TaxRetainer {
    address public freelancer;
    address public taxAuthority;
    uint256 public taxRate; // In percentage basis (e.g., 15 means 15%)
    uint256 public accumulatedTax;

    event PaymentReceived(address indexed client, uint256 totalAmount, uint256 taxWithheld, uint256 freelancerShare);
    event TaxPaid(address indexed authority, uint256 amount);
    event TaxRateUpdated(uint256 newRate);

    modifier onlyFreelancer() {
        require(msg.sender == freelancer, "Only the freelancer can execute this action");
        _;
    }

    constructor(address _taxAuthority, uint256 _taxRate) {
        freelancer = msg.sender;
        taxAuthority = _taxAuthority;
        require(_taxRate <= 50, "Tax rate cannot exceed 50% limit");
        taxRate = _taxRate;
    }

    /**
     * @notice Receives payment from clients and automatically segregates tax percentage from freelancer payout.
     */
    function receiveFreelancePayment() external payable {
        require(msg.value > 0, "Payment must be greater than zero");

        uint256 taxAmount = (msg.value * taxRate) / 100;
        uint256 freelancerAmount = msg.value - taxAmount;

        accumulatedTax += taxAmount;
        
        // Instant distribution of disposable earnings to the freelancer's wallet
        payable(freelancer).transfer(freelancerAmount);

        emit PaymentReceived(msg.sender, msg.value, taxAmount, freelancerAmount);
    }

    /**
     * @notice Releases accumulated tax funds directly to the verified regulatory tax body account.
     */
    function payTaxToAuthority() external {
        require(msg.sender == freelancer || msg.sender == taxAuthority, "Unauthorized execution");
        require(accumulatedTax > 0, "No accumulated tax reserves available");

        uint256 amountToSend = accumulatedTax;
        accumulatedTax = 0;
        
        payable(taxAuthority).transfer(amountToSend);

        emit TaxPaid(taxAuthority, amountToSend);
    }

    function updateTaxRate(uint256 _newRate) external onlyFreelancer {
        require(_newRate <= 50, "Tax rate cannot exceed 50% limit");
        taxRate = _newRate;
        emit TaxRateUpdated(_newRate);
    }
}