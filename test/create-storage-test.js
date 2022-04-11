const { expect } = require("chai");
const hre = require("hardhat");
const ethers = hre.ethers;


describe("Test create new contract with StorageFactory", async function () {

    let storageFactory;
    let newStorageAddress;
    let storageOwner;
    let otherPerson;
    const INITIAL_NUMBER = 99;

    before(async function () {

        const StorageFactory = await ethers.getContractFactory("StorageFactory");
        storageFactory = await StorageFactory.deploy();
        await storageFactory.deployed();
        [otherPerson, storageOwner] = await ethers.getSigners();

    })

    it("Should return initizalized base Storage address", async function () {
        const baseStorageAddress = await storageFactory.getBaseStorage();
        console.log("Base Storage address:", baseStorageAddress);
        expect(baseStorageAddress).is.not.equal(ethers.constants.AddressZero);
    })

    it("Should create new Storage", async function () {
        const createTx = await storageFactory.connect(storageOwner).createStorage(INITIAL_NUMBER);
        const receiptTx = await createTx.wait();
        newStorageAddress = receiptTx.events[0].args.storageAddress;
        console.log("New created Storage address:", newStorageAddress);
        expect(newStorageAddress).is.not.equal(ethers.constants.AddressZero);
    })

    it("Created Storage should work well", async function () {

        const Storage = await ethers.getContractFactory("Storage");
        const storage = Storage.attach(newStorageAddress);
        const currentNumber = await storage.getNumber();
        expect(currentNumber).to.be.equal(INITIAL_NUMBER);

        const NEW_NUMBER = 88;
        await expect(storage.connect(otherPerson).setNumber(NEW_NUMBER))
            .to.be.revertedWith("Only owner can call!");
        const setNumberTx = await storage.connect(storageOwner).setNumber(NEW_NUMBER);
        await setNumberTx.wait();
        const newStoragedNumber = await storage.getNumber();
        expect(newStoragedNumber).to.be.equal(NEW_NUMBER);

    })

})