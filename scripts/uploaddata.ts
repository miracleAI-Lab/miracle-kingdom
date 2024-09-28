import { ethers } from "hardhat";
import { contracts } from "./contracts";
import {
  BoxPriceArray,
  BoxRarityArray
} from "../json_data/box.ts";

import {
  EquipmentArray
} from "../json_data/equipment.ts";

import {
  Prop,
  PropArray
} from "../json_data/prop.ts";

import {
  Skill,
  SkillArray
} from "../json_data/skill.ts";

import {
  UpgradeExperienceArray
} from "../json_data/hero.ts";

const main = async () => {
  const [owner] = await ethers.getSigners();
  //////////////////////////////////////////////
  //upload data
  const GameDB2 = await ethers.getContractFactory("GameDB2");
  const contractGameDB2 = GameDB2.attach(contracts.GameDB2);

  let tx = await contractGameDB2.setUpgradeExperiences(UpgradeExperienceArray);
  await tx.wait()
  console.log("==========setUpgradeExperience finish=========")

  // 背包
  const BackpackFactory = await ethers.getContractFactory("BackpackFactory");
  const contractBackpackFactory = BackpackFactory.attach(contracts.BackpackFactory);
  await (await contractBackpackFactory.setupCallers([owner.address])).wait()
  await (await contractBackpackFactory.addBalance(Prop.DIVINE_FRAGMENTS, owner.address, 1)).wait();
  await (await contractBackpackFactory.subBalance(Prop.DIVINE_FRAGMENTS, owner.address, 1)).wait();
  console.log("==========addBalance finish=========")

  console.log("==========addEquipments start=========")
  let pageNum = EquipmentArray.length / 5;
  if(EquipmentArray.length % 5 > 0) {
    // 有余数
    pageNum++;
  }
  console.log('addEquipments pageNum', pageNum);
  for (let page = 0; page < pageNum; page++) {
    let start = page * 5;
    let end = start + 5;
    console.log(`addEquipments start: ${start}, end: ${end}`);
    let records = [] as any;
    for (let j = start; j < end; j++) {
      if (j > EquipmentArray.length - 1) break;
      let r = EquipmentArray[j];
      records.push(r);
    }

    let tx = await contractGameDB2.addEquipments(records);
    await tx.wait()
    console.log(`===============addEquipments page: ${page} finish===============`)
  }

  console.log("==========addProps=========")
  let limit = 10;
  pageNum = PropArray.length / limit;
  if(PropArray.length % limit > 0) {
    // 有余数
    pageNum++;
  }
  console.log('addProps pageNum', pageNum);
  for (let page = 0; page < pageNum; page++) {
    let start = page * limit;
    let end = start + limit;
    console.log(`addProps start: ${start}, end: ${end}`);
    let records = [] as any;
    for (let j = start; j < end; j++) {
      if (j > PropArray.length - 1) break;
      let r = PropArray[j];
      records.push(r);
    }

    let tx = await contractGameDB2.addProps(records);
    await tx.wait()
    console.log(`===============addProps page: ${page} finish===============`)
  }

  limit = 10;
  pageNum = SkillArray.length / limit;
  console.log('SkillArray', SkillArray.length);
  if(SkillArray.length % limit > 0) {
    // 有余数
    pageNum++;
  }
  console.log('addSkills pageNum', pageNum);
  for (let page = 0; page < pageNum; page++) {
    let start = page * limit;
    let end = start + limit;
    console.log(`addSkills start: ${start}, end: ${end}`);
    let records = [] as any;
    for (let j = start; j < end; j++) {
      if (j > SkillArray.length - 1) break;
      let r = SkillArray[j];
      records.push(r);
    }

    let tx = await contractGameDB2.setSkills(records);
    await tx.wait()
    console.log(`===============addSkills page: ${page} finish===============`)
  }

  let result = await contractGameDB2.getEquipments()
  console.log("getEquipments:", result.length, result[1])

  result = await contractGameDB2.getProps()
  console.log("getProps:", result.length, result[1])

  result = await contractGameDB2.getUpgradeExperiences()
  console.log("upgradeExperiences.len:", result.length)

  result = await contractGameDB2.getSkills()
  console.log("getSkills.len:", result.length)
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
