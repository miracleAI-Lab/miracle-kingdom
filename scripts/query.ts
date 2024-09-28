const { ethers } = require('hardhat');
import { contracts } from './contracts';

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner: ", owner.address);

  const _HeroNFT = await ethers.getContractFactory("HeroNFT");
  const contractHeroNFT = _HeroNFT.attach(contracts.HeroNFT);

    let data = await contractHeroNFT.getOwnerHeroMetas("0xD98Ea43293Df9205C570FD071cE42a7b69b19919");
    console.log("data: ", data);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
