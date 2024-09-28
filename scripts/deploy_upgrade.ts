
import { ethers } from "hardhat";

import {
  upgradeUpgardeableContract
} from './deploy_libs';

import { contracts } from './contracts';

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner: ", owner.address);  

  await upgradeUpgardeableContract("HeroNFT", contracts.HeroNFT);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
