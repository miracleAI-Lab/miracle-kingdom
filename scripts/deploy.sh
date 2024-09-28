#!/bin/bash

npx hardhat clean && npx hardhat compile

npx hardhat clear-abi && npx hardhat export-abi

npx hardhat run scripts/deploy_base.ts  --network localhost
npx hardhat run scripts/uploaddata.ts  --network localhost
npx hardhat run scripts/deploy_usdt.ts  --network localhost

npx hardhat run scripts/deploy_blast.ts  --network BlastSepolia
npx hardhat run scripts/deploy_base.ts  --network BlastSepolia
npx hardhat run scripts/uploaddata.ts  --network BlastSepolia
npx hardhat run scripts/set_values.ts  --network BlastSepolia
npx hardhat run scripts/query.ts  --network BlastSepolia
npx hardhat run scripts/deploy_upgrade.ts  --network BlastSepolia



