const hre = require("hardhat")
const { ethers, upgrades } = require('hardhat');
import { setEnv } from "./write_env";

function sleep(delay: any) {
  var start = (new Date()).getTime();
  while ((new Date()).getTime() - start < delay) {
      continue; 
  }
}

const LOG = (...args: any[]) => {
  console.log(...args);
};

const deployCounter = {};
const addCounter = (name: string) => {
  if (!deployCounter[name]) {
    deployCounter[name] = 1;
  } else {
    deployCounter[name] += 1;
  }
}

const deployUpgardeableContract = async (filename: string, ...args: any) => {
  let contract;
  try {
    addCounter(filename); 
    const contractFactory = await ethers.getContractFactory(filename);
    contract = await upgrades.deployProxy(contractFactory, [...args]);
    await contract.deployed();
    LOG(`[${filename}]: `, contract.address);
    sleep(1000);
  } catch (e: any) {
    LOG(`[${filename} error]: `, e);
    sleep(2000);
    if (deployCounter[filename] <= 3) {
      contract = deployUpgardeableContract(filename, ...args);
    }
  }

  setEnv(filename, contract.address);

  return contract;
};

const deployUpgardeableContractV2 = async (name: string, filename: string, ...args: any) => {
  let contract;
  try {
    addCounter(filename); 
    const contractFactory = await ethers.getContractFactory(filename);
    contract = await upgrades.deployProxy(contractFactory, [...args]);
    await contract.deployed();
    LOG(`[${filename}]: `, contract.address);
    sleep(1000);
  } catch (e: any) {
    LOG(`[${filename} error]: `, e);
    sleep(2000);
    if (deployCounter[filename] <= 3) {
      contract = deployUpgardeableContractV2(name, filename, ...args);
    }
  }

  setEnv(name, contract.address);

  return contract;
};

const deployContract = async (filename: string, ...args: any) => {
  let contract;
  try {
    const contractFactory = await ethers.getContractFactory(filename);
    contract = await contractFactory.deploy(...args);
    await contract.deployed();
    LOG(`[${filename}]: `, contract.address);
    sleep(1000);
  } catch (e: any) {
    LOG(`[${filename} error]: `, e);
    sleep(2000);
    if (deployCounter[filename] <= 3) {
      contract = deployContract(filename, ...args);
    }
  }

  setEnv(filename, contract.address);

  return contract;
};

const upgradeUpgardeableContract = async (filename: string, proxy_address: string | undefined) => {
  let contract;
  try {
    const contractFactory = await ethers.getContractFactory(filename);
    contract = await upgrades.upgradeProxy(proxy_address, contractFactory);
    await contract.deployed();
    LOG(`[${filename}]: `, contract.address);
    sleep(1000);
  } catch (e: any) {
    LOG(`[${filename} error]: `, e);
    sleep(2000);
  }

  return contract;
}

const verifyContract = async (filename: string, address: string | undefined, ...args: any) => {
  sleep(2000)
  try {
    await hre.run("verify:verify", {
      address: address,
      contract: `contracts/${filename}.sol:${filename}`,
      constructorArguments: [...args],
    });
  } catch (e) {
    console.log(e);
  }
};

export {
  deployContract,
  deployUpgardeableContract,
  deployUpgardeableContractV2,
  upgradeUpgardeableContract, 
  verifyContract
}