import { Contract, Transaction } from "ethers";
import { ethers, upgrades, run } from "hardhat";
import fs from "fs";
const path = require('path');

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
const LOG = (...args: any[]) => {
  console.log(new Date(), ":", ...args);
};

const txWatch = (
  name: string = "",
  confirmations?: number,
  timeout?: number
) => {
  LOG(`=====[txWatch init]:[${name}] ================ `);

  return (tx: Transaction) => () => {
    LOG(`\t[txWatch then]: [${name}] ================ `);

    LOG(
      `\t[Wait]`,
      tx.hash,
      "gasLimit:",
      tx.gasLimit,
      "gasPrice:",
      tx.gasPrice
    );
    return ethers.provider
      .waitForTransaction(tx.hash!, confirmations, timeout)
      .then((r) => {
        LOG(
          `\t[Done]`,
          tx.hash,
          "blockHash:",
          r.blockHash,
          "status:",
          r.status,
          "gasUsed:",
          r.gasUsed
        );
        LOG(`\t[txWatch end]: [${name}] ================ `);
        return r;
      });
  };
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

const main = async () => {

  //////////////////////////////////////////////
  //upload data
  const TIPetNFTFactoryFactory = await ethers.getContractFactory("TIPetNFTFactory");
  const contractTIPetNFTFactory = TIPetNFTFactoryFactory.attach(process.env.TIPetNFTFactory || "");
  const TIPetNFTMetaViewFactory = await ethers.getContractFactory("TIPetNFTMetaView");
  const contractTIPetNFTMetaView = TIPetNFTMetaViewFactory.attach(process.env.TIPetNFTMetaView || "");

  // add table data to TIPetNFTFactory
  await addPetTable(contractTIPetNFTFactory);//游戏掉落用到（包括孵化掉落），必须保证添加的配置id不能移除
  await TIPetNFTFactorySetDefaultPet(contractTIPetNFTFactory, 10001);//默认动物配置id，DefaultPetCId

  // 设置动物盲盒概率
  await TIPetNFTFactorySetRarityRates(contractTIPetNFTFactory, [370, 280, 190, 110, 50]);//官网动物稀有度概率
  await TIPetNFTFactorySetElementRates(contractTIPetNFTFactory, [200, 200, 200, 200, 200]);//官网动物元素概率

  // add table data to TIPetNFTMetaView
  await addElementView(contractTIPetNFTMetaView);//用于动物元素名字显示，id相同可重复添加
  await addPetDisplayView(contractTIPetNFTMetaView);//用于动物名字显示，id相同可重复添加
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

////////////////////////////////////////////////////////////////////////////////////////////////////////////

const TIPetNFTFactorySetDefaultPet = async (
  contract: Contract,
  petCId: number
) => {
  try {
    const tx = await contract.setDefaultPetCId(
      petCId
    );
    await tx.wait();

    LOG("TIPetNFTFactorySetDefaultPet: ", tx.hash);
  } catch (error) {
    LOG("ERROR", error);
  }
};

const TIPetNFTFactorySetRarityRates = async (
  contract: Contract,
  rates: number[]
) => {
  try {
    const tx = await contract.setRarityRates(
      rates
    );
    await tx.wait();

    LOG("TIPetNFTFactorySetRarityRates: ", tx.hash);
  } catch (error) {
    LOG("ERROR", error);
  }
};

const TIPetNFTFactorySetElementRates = async (
  contract: Contract,
  rates: number[]
) => {
  try {
    const tx = await contract.setElementRates(
      rates
    );
    await tx.wait();


    LOG("TIPetNFTFactorySetElementRates: ", tx.hash);
  } catch (error) {
    LOG("ERROR", error);
  }
};

const TIPetNFTFactoryAddPetTable = async (
  contract: Contract,
  metaList: any[]
) => {
  try {
    const tx = await contract.addPetTable(
      metaList
    );

    await tx.wait();

    LOG("TIPetNFTFactoryAddPetTable: ", tx.hash);
  } catch (error) {
    LOG("ERROR", error);
  }
};

const TIPetNFTMetaViewAddElementData = async (
  contract: Contract,
  metaList: any[]
) => {
  try {
    const tx = await contract.addElementDisplayName(
      metaList
    );

    await tx.wait();

    LOG("TIPetNFTMetaViewAddElementData: ", tx.hash);
  } catch (error) {
    LOG("ERROR", error);
  }
};

const TIPetNFTMetaViewAddPetDisplayData = async (
  contract: Contract,
  metaList: any[]
) => {
  try {
    const tx = await contract.addPetDisplayData(
      metaList
    );
    await tx.wait();

    LOG("TIPetNFTMetaViewAddPetDisplayData: ", tx.hash);
  } catch (error) {
    LOG("ERROR", error);
  }
};


interface PetTable {
  id: number; //
  rarity: number; //
  element: number;
  petName: string;
}

async function addPetTable(contract:Contract) {

  interface Pet {
    id: number; //
    rarity: number; //
    element: number;
  }

  let filePath = path.resolve(process.cwd(), `json_data/pet_data.json`);
  let jsonStr = fs.readFileSync(filePath).toString().trim();
  let list = JSON.parse(jsonStr) as PetTable[];
  let onceAddItems = list.length;

  try {

    let datas :Pet[] = [];
    for (const element_key in list) {
      let meta :PetTable = list[element_key];

      let pet:Pet = {
        id:meta.id,
        rarity:meta.rarity,
        element:meta.element,
      };

      datas.push(pet);
      if (datas.length == onceAddItems) {
        await TIPetNFTFactoryAddPetTable(contract, datas);
        datas = [];
        LOG(`\t[SEND]: [${contract.address}] addPetTable================ `);
      }
    }

    if (datas.length > 0) {
      await TIPetNFTFactoryAddPetTable(contract, datas);
      datas = [];
      LOG(`\t[SEND]: [${contract.address}] addPetTable================ `);
    }
  
  } catch (error) {
    LOG("ERROR on", error);
  }
}

async function addElementView(contract:Contract) {

  interface ElementDisplayData {
    elementId:number;
    elementName:string;
  }

  let filePath = path.resolve(process.cwd(), `json_data/element_data.json`);
  let jsonStr = fs.readFileSync(filePath).toString().trim();
  let list = JSON.parse(jsonStr) as ElementDisplayData[];
  let onceAddItems = list.length;

  try {

    let datas :ElementDisplayData[] = [];
    for (const element_key in list) {
      let meta :ElementDisplayData = list[element_key];

      datas.push(meta);
      if (datas.length == onceAddItems) {
        await TIPetNFTMetaViewAddElementData(contract, datas);
        datas = [];
        LOG(`\t[SEND]: [${contract.address}] addElementView================ `);
      }
    }

    if (datas.length > 0) {
      await TIPetNFTMetaViewAddElementData(contract, datas);
      datas = [];
    }

  } catch (error) {
    LOG("ERROR on", error);
  }
}

async function addPetDisplayView(contract:Contract) {

  interface PetDisplayData {
    id: number; //
    name: string; //
  }

  let filePath = path.resolve(process.cwd(), `json_data/pet_data.json`);
  let jsonStr = fs.readFileSync(filePath).toString().trim();
  let list = JSON.parse(jsonStr) as PetTable[];
  let onceAddItems = list.length;

  try {
    let datas :PetDisplayData[] = [];
    for (const element_key in list) {
      let meta :PetTable = list[element_key];

      let d:PetDisplayData = {
        id:meta.id,
        name:meta.petName,
      };

      datas.push(d);
      if (datas.length == onceAddItems) {
        await TIPetNFTMetaViewAddPetDisplayData(contract, datas);
        datas = [];
        LOG(`\t[SEND]: [${contract.address}] addPetDisplayView================ `);
      }
    }

    if (datas.length > 0) {
      await TIPetNFTMetaViewAddPetDisplayData(contract, datas);
      datas = [];
    }
  
  } catch (error) {
    LOG("ERROR on", error);
  }
}
