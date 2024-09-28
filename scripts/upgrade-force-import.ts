import { ethers, upgrades } from "hardhat";
import { contracts } from './contracts';
    
const forceImportForUpgrade = async () => {
  console.log('Starting force import for SgaLock...');
  await upgrades.forceImport(contracts.SgaLock, await ethers.getContractFactory("SgaLock"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for PlayEarnLock...');
  await upgrades.forceImport(contracts.PlayEarnLock, await ethers.getContractFactory("PlayEarnLock"), { timeout: 0 });
  console.log('Force import ended.');
      
  console.log('Starting force import for Buyback...');
  await upgrades.forceImport(contracts.Buyback, await ethers.getContractFactory("Buyback"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for NftSale...');
  await upgrades.forceImport(contracts.NftSale, await ethers.getContractFactory("NftSale"), { timeout: 0 });
  console.log('Force import ended.');
      
  console.log('Starting force import for RocketPool...');
  await upgrades.forceImport(contracts.RocketPool, await ethers.getContractFactory("RocketPool"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for TINFTMetaView...');
  await upgrades.forceImport(contracts.TINFTMetaView, await ethers.getContractFactory("TINFTMetaView"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for TINFTFactory...');
  await upgrades.forceImport(contracts.TINFTFactory, await ethers.getContractFactory("TINFTFactory"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for TINFT...');
  await upgrades.forceImport(contracts.TINFT, await ethers.getContractFactory("TINFT"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for RewardsPool...');
  await upgrades.forceImport(contracts.RewardsPool, await ethers.getContractFactory("RewardsPool"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for StakeMine...');
  await upgrades.forceImport(contracts.StakeMine, await ethers.getContractFactory("StakeMine"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for TIPetNFTMetaView...');
  await upgrades.forceImport(contracts.TIPetNFTMetaView, await ethers.getContractFactory("TIPetNFTMetaView"), { timeout: 0 });
  console.log('Force import ended.');
      
  console.log('Starting force import for TIPetNFTFactory...');
  await upgrades.forceImport(contracts.TIPetNFTFactory, await ethers.getContractFactory("TIPetNFTFactory"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for TIPetNFT...');
  await upgrades.forceImport(contracts.TIPetNFT, await ethers.getContractFactory("TIPetNFT"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for Marketplace...');
  await upgrades.forceImport(contracts.Marketplace, await ethers.getContractFactory("Marketplace"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for TIGame...');
  await upgrades.forceImport(contracts.TIGame, await ethers.getContractFactory("TIGame"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for StakeTicFarm...');
  await upgrades.forceImport(contracts.StakeTicFarm, await ethers.getContractFactory("StakeTicFarm"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for CofLock...');
  await upgrades.forceImport(contracts.CofLock, await ethers.getContractFactory("CofLock"), { timeout: 0 });
  console.log('Force import ended.');

  console.log('Starting force import for BurnTic...');
  await upgrades.forceImport(contracts.BurnTic, await ethers.getContractFactory("BurnTic"), { timeout: 0 });
  console.log('Force import ended.');
};

(async () => {
  await forceImportForUpgrade();
})();