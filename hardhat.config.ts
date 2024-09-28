import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import * as dotenv from "dotenv";
import "dotenv/config";
import path from "path"; 
import "@nomiclabs/hardhat-etherscan";

import "hardhat-gas-reporter";
import "solidity-coverage";
import "hardhat-contract-sizer";
import "hardhat-abi-exporter";
var CryptoJS = require("crypto-js");

const configPath = path.resolve(process.cwd(), `.env.${process.env.NODE_ENV}`);
dotenv.config({path:configPath});

console.log(`[CURRENT ENV: ${process.env.NODE_ENV}]`)
console.log(`[CURRENT SERVER_PORT: ${process.env.SERVER_PORT}]`)

const accounts = [process.env.PRIVATE_KEY || ""];

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.11",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.7",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.5.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
    overrides:{
    }
  },
  abiExporter: [
    {
      path: './abi/json',
      format: "json",
    },
    {
      path: './abi/minimal',
      format: "minimal",
    },
    {
      path: './abi/fullName',
      format: "fullName",
    },
  ],
  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths: true,
  },
  networks: {
    localhost: {
      timeout: 3000000,
      url:"http://127.0.0.1:7545",
      accounts: accounts,
      chainId: 1337,
      gasPrice: 10000000000,
      gas: 7000000
    },
    BlastSepolia: {
      timeout: 3000000,
      url:"https://rpc.ankr.com/eth_sepolia",
      accounts: accounts,
      chainId: 168587773,
      gasPrice: 10000000000,
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  defaultNetwork: 'localhost',
};

export default config;
