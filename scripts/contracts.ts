import * as process from "process";

export const contracts = {
  MultSigAddress: process.env.MultSigAddress || "",
  MarketAddress: process.env.MarketAddress  || "",
  UsdtAddress: process.env.UsdtAddress  || "",
  feeAccount: process.env.feeAccount  || "",
  FeeAccount: process.env.FeeAccount  || "",
  MaiToken: process.env.MaiToken  || "",
  Treasury: process.env.Treasury  || "",
  GameDB: process.env.GameDB  || "",
  BackpackFactory: process.env.BackpackFactory  || "",
  EquipmentNFT: process.env.EquipmentNFT  || "",
  HeroNFT: process.env.HeroNFT  || "",
  TradeMarket: process.env.TradeMarket  || "",
  Player: process.env.Player  || "",
  NftSale: process.env.NftSale  || "",
  Marketplace: process.env.Marketplace || "",
  GameDB2: process.env.GameDB2  || "",
  signAccount: process.env.signAccount  || "",
  GameFight: process.env.GameFight  || "",
  SharePool: process.env.SharePool || "",
  StakeFarmV2: process.env.StakeFarmV2 || "",
  PMaiToken: process.env.PMaiToken  || "",
  StakeMAI3Farm: process.env.StakeMAI3Farm || "",
  BondPool: process.env.BondPool || "",
}