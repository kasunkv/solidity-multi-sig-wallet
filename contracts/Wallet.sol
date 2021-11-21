// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import "./Ownable.sol";

contract Wallet is Ownable {
    
    event DepositCompleted(address from, uint amount);
    event TransferRequestCreated(uint txId, uint amount, address recipient, address requestedBy);
    event TransderRequestApproved(uint txId, address approver);
    event TransderRequestCompleted(uint txId, uint amount, address recipient);
    
    uint8 private requiredApprovals;
    uint private txCount;
    
    struct TransferRequest {
        uint txId;
        uint amount;
        address recipient;
        mapping(address => bool) signatures;
        address requestedBy;
        uint8 approvals;
    }
    
    mapping(uint => TransferRequest) public requestedTransfers;
    
    /**
     * @dev _owner1 would be meg.sender during contract deployment
     */
    constructor(address _owner2, address _owner3, uint8 _requiredApprovals)
        Ownable(_owner2, _owner3) {
        requiredApprovals = _requiredApprovals;
    }
    
    /**
     * @dev Deposit function. Along with the fallback function anyone can send funds to the contract
     */
    function deposit() external payable {
        emit DepositCompleted(msg.sender, msg.value);
    }
    
    receive() external payable {
        emit DepositCompleted(msg.sender, msg.value);
    }
    
    /**
     * @dev Requesting the transfer for approval
     */
    function requestTransfer(address _recipient, uint _amount) public onlyOwners returns (uint) {
        require(_amount <= address(this).balance, "Insufficient funds in the contract");
        
        TransferRequest storage txRequest = requestedTransfers[txCount];
        txRequest.txId = txCount;
        txRequest.amount = _amount;
        txRequest.recipient = _recipient;
        txRequest.requestedBy = msg.sender;
        
        emit TransferRequestCreated(txCount, _amount, _recipient, msg.sender);
        return txCount++;
    }
    
    /**
     * @dev Handles the approval of the transfer request. Only the owner of the wallet can approve.
     */
    function approveTransfer(uint _txId) public onlyOwners {
        TransferRequest storage txRequest = requestedTransfers[_txId];
        require(txRequest.requestedBy != msg.sender, "You can't approve your own transfer request");
        require(!txRequest.signatures[msg.sender], "You already approved this transder request");
        
        txRequest.signatures[msg.sender] = true;
        txRequest.approvals++;
        
        emit TransderRequestApproved(txRequest.txId, msg.sender);
        
        if(txRequest.approvals == requiredApprovals) {
           completeTransfer(txRequest.txId);
        }
    }
    
    /**
     * @dev Internal function to complete the requested transfer. This can only be called during the final approval vote
     * or when retrying due to Insufficient funds in the contract
     */
    function completeTransfer(uint _txId) internal {
        TransferRequest storage txRequest = requestedTransfers[_txId];
        require(txRequest.approvals == requiredApprovals, "Transfer not approved by all required parties.");
        require(txRequest.amount <= address(this).balance, "Insufficient funds in the contract");
        
        payable(txRequest.recipient).transfer(txRequest.amount);
        emit TransderRequestCompleted(txRequest.txId, txRequest.amount, txRequest.recipient);
    }
    
}