const { ethers } = require('hardhat');

import {
  deployUpgardeableContract,
  deployContract,
} from './deploy_libs';

import { contracts } from './contracts';

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner: ", owner.address);

  const UsdtToken = await deployContract(
    "UsdtToken",
  );

  let tx = await UsdtToken.setName("abcd");
  await tx.wait();

  console.log("tx: ", tx);

  console.log('deploy base ok');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
