// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Storage.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract StorageFactory {

    address private baseStorageAddress;
    uint256 private counter;
    mapping(uint256 => address[]) private idToStorage;
    event CreateStorage(address storageAddress, address owner, uint256 number, uint256 storageId);

    constructor() {
        Storage base = new Storage();
        baseStorageAddress = address(base);
        counter = 0;
    }

    function createStorage(uint256 number)  public returns (address newStorage) {
        newStorage = Clones.clone(baseStorageAddress);
        Storage(newStorage).initialize(msg.sender, number);
        counter += 1;
        emit CreateStorage(newStorage, msg.sender, number, counter);
        idToStorage[counter].push(newStorage);
    }

    function getStorage(uint256 id) public view returns (address[] memory) {
        return idToStorage[id];
    }

    function getBaseStorage() public view returns (address) {
        return baseStorageAddress;
    }


}