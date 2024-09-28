const { ethers } = require('hardhat');

import {
  deployUpgardeableContract,
  deployContract,
} from './deploy_libs';

import { contracts } from './contracts';

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner: ", owner.address);

  // const StakeFarmV2 = await deployContract(
  //   "StakeFarmV2",
  // );

  const StakeFarmV2 = await ethers.getContractFactory("StakeFarmV2");
  const contractStakeFarmV2 = StakeFarmV2.attach(contracts.StakeFarmV2);

  let tx = await contractStakeFarmV2.claimAllYield();
  await tx.wait();

  const balance = await contractStakeFarmV2.getBalance();
  console.log("balance: ", balance);

  const rewardsPool = await contractStakeFarmV2.rewardsPool();
  console.log("rewardsPool: ", rewardsPool);

  tx = await contractStakeFarmV2.withdraw();
  await tx.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
