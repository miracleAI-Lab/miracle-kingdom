const { ethers } = require('hardhat');

import {
  deployUpgardeableContract,
  deployContract,
} from './deploy_libs';

import { contracts } from './contracts';

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("owner: ", owner.address);

  const MaiToken = await deployContract(
    "MaiToken",
  );

  const PMaiToken = await deployContract(
    "PMaiToken",
  );

  const Treasury = await deployContract(
    "Treasury",
    contracts.MultSigAddress,
    contracts.UsdtAddress,
    MaiToken.address,
  );

  const GameDB = await deployUpgardeableContract(
    "GameDB",
    
  );

  const GameDB2 = await deployUpgardeableContract(
    "GameDB2"
  );

  const BackpackFactory = await deployUpgardeableContract(
    "BackpackFactory",
  );

  const SharePool = await deployContract(
      "SharePool",
      MaiToken.address,
      BackpackFactory.address,
  );

  const FeeAccount = await deployContract(
    "FeeAccount",
    MaiToken.address,
    SharePool.address,
    Treasury.address,
  );

  const HeroNFT = await deployUpgardeableContract(
    "HeroNFT",
    "Miracle Kingdom NFT",
    "HeroNFT",
    FeeAccount.address,
    GameDB.address,
    GameDB2.address,
    BackpackFactory.address,
    PMaiToken.address,
  );

  const EquipmentNFT = await deployUpgardeableContract(
    "EquipmentNFT",
    "Miracle Equipment NFT",
    "EquipmentNFT",
    GameDB.address,
    GameDB2.address,
    BackpackFactory.address,
    PMaiToken.address,
  );

  const TradeMarket = await deployUpgardeableContract(
    "TradeMarket",
    contracts.UsdtAddress,
    MaiToken.address,
    PMaiToken.address,
    Treasury.address,
    GameDB.address,
    GameDB2.address,
    EquipmentNFT.address,
    BackpackFactory.address,
    SharePool.address,
  );

  const Player = await deployUpgardeableContract(
    "Player",
    HeroNFT.address,
    EquipmentNFT.address,
    GameDB.address,
  );

  const Marketplace = await deployUpgardeableContract(
    "Marketplace",
    [HeroNFT.address, EquipmentNFT.address],
    MaiToken.address,
    Treasury.address,
    SharePool.address,
  );

  const GameFight = await deployUpgardeableContract(
    "GameFight",
    GameDB.address,
    BackpackFactory.address,
    FeeAccount.address,
    PMaiToken.address,
    contracts.signAccount,
  );

  const StakeMAI3Farm = await deployContract(
      "StakeMAI3Farm",
      MaiToken.address,
  );

  const BondPool = await deployContract(
      "BondPool",
      MaiToken.address,
      BackpackFactory.address,
  );

  let tx = await HeroNFT.startBuy();
  await tx.wait();

  tx = await HeroNFT.setupCallers([TradeMarket.address, HeroNFT.address, EquipmentNFT.address, GameFight.address]);
  await tx.wait();

  tx = await BackpackFactory.setupCallers([TradeMarket.address, HeroNFT.address, EquipmentNFT.address, GameFight.address, SharePool.address, BondPool.address]);
  await tx.wait();

  let callers = [HeroNFT.address, EquipmentNFT.address, Player.address, GameFight.address];
  tx = await GameDB.setupCallers(callers);
  await tx.wait();

  tx = await GameDB2.setupCallers(callers);
  await tx.wait();

  tx = await EquipmentNFT.setupCallers([TradeMarket.address]);
  await tx.wait();

  // 设置支持的nft合约
  tx = await Marketplace.setSupportNFTType([HeroNFT.address, EquipmentNFT.address], [0, 1])
  await tx.wait();

  tx = await FeeAccount.setupCallers([HeroNFT.address, GameFight.address]);
  await tx.wait();

  tx = await StakeMAI3Farm.setStartStaked(true);
  await tx.wait();

  tx = await SharePool.start()
  await tx.wait()

  console.log('deploy base ok');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
