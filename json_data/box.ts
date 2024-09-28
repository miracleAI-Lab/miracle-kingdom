// 盲盒价格数组，usdt
const BoxPriceArray = [25, 50, 100];

// 盲盒稀有度中各品质的NFT概率的数组
const BoxRarityArray = [
  {
    rarity: [2, 3, 4, 5], // 品质：N、R、SR、SSR
    probability: [45, 33, 17, 3], // 概率：50%，33%，15%，1%
  },
  {
    rarity: [3, 4, 5, 6], // R、SR、SSR、UR
    probability: [45, 33, 17, 3], // 概率：50%，33%，15%，1%
  },
  {
    rarity: [4, 5, 6, 7], // SR、SSR、UR、SP
    probability: [45, 33, 17, 3], // 概率：50%，33%，15%，1%
  }
];

export {
  BoxPriceArray,
  BoxRarityArray,
};
