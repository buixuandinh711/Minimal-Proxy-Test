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

    function initialize(address _owner, uint256 number) external initializer {
        require(!isBase, "The base contract can't be reinitialized!");
        owner = _owner;
        storagedNumber = number;
    }

    function setNumber(uint256 newNumber) external {
        require(owner != address(0), "Owner is not initialized yet!");
        require(msg.sender == owner, "Only owner can call!");
        storagedNumber = newNumber;
    }

    function getNumber()  public view returns (uint256) {
        return storagedNumber;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

}