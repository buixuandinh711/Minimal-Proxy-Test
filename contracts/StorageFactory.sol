// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Storage.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract StorageFactory {

    address private baseStorageAddress;
    mapping (address => address[]) ownerToStorages;
    event CreateStorage(address storageAddress, address owner, uint256 number);

    constructor() {
        Storage base = new Storage();
        baseStorageAddress = address(base);
    }

    function createStorage(uint256 number)  public returns (address newStorage) {
        newStorage = Clones.clone(baseStorageAddress);
        Storage(newStorage).initialize(msg.sender, number);
        emit CreateStorage(newStorage, msg.sender, number);
        ownerToStorages[msg.sender].push(newStorage);
    }

    function getStorage(address owner) public view returns (address[] memory) {
        return ownerToStorages[owner];
    }


}