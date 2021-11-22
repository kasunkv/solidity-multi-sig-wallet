// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

contract Ownable {
    mapping(address => bool) internal owners;
    
    event OwnershipAssigned(address indexed owner);
    
    modifier onlyOwners {
        require(owners[msg.sender], "You are not one of the wallet owners");
        _;
    }
    
    constructor(address[] memory _owners) {
        owners[msg.sender] = true;
        emit OwnershipAssigned(msg.sender);
        
        for(uint i = 0; i < _owners.length; i++) {
            owners[_owners[i]] = true;
            emit OwnershipAssigned(_owners[i]);
        }
    }
}