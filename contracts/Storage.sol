// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Storage is Initializable{
    
    uint256 private storagedNumber;
    address private owner;

    bool private isBase;

    constructor() {
        isBase = true;
    }

    function initialize(address _owner) external initializer {
        require(!isBase, "The base contract can't be reinitialized!");
        owner = _owner;
    }

    function setNumber(uint256 newNumber) external {
        require(msg.sender == owner, "Only owner can call!");
        storagedNumber = newNumber;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

}