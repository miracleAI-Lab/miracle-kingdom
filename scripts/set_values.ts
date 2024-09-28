const { ethers } = require('hardhat');
import { contracts } from './contracts';

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner: ", owner.address);

  const _BackpackFactory = await ethers.getContractFactory("BackpackFactory");
  const contractBackpackFactory = _BackpackFactory.attach(contracts.BackpackFactory);

  for (let i = 1; i <= 39; i++) {
    let tx = await contractBackpackFactory.addBalance(i, "0xD98Ea43293Df9205C570FD071cE42a7b69b19919", 5000);
    await tx.wait();
    console.log("id: ", i);
  }

  // const _Marketplace = await ethers.getContractFactory("Marketplace");
  // const contractMarketplace = _Marketplace.attach(contracts.Marketplace);
  // let tx = await contractMarketplace.setERC20Token(contracts.MaiToken);
  // await tx.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
