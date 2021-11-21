// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

contract Ownable {
    mapping(address => bool) owners;
    
    event OwnershipAssigned(address[3] indexed owners);
    
    modifier onlyOwners {
        require(owners[msg.sender], "You are not one of the wallet owners");
        _;
    }
    
    constructor(address owner2, address owner3) {
        owners[msg.sender] = true;
        owners[owner2] = true;
        owners[owner3] = true;
        
        emit OwnershipAssigned([msg.sender, owner2, owner3]);
    }
}