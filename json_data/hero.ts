// 体力值
const LevelMaxStrengthArray = [
  100, 200, 300, 400, 500, 600, 700, 800, 900, 1000,
];

const UpgradeExperienceArray = [
  {
    "fee": "10000000000000000000",
    "experience": 1020
  },
  {
    "fee": "18000000000000000000",
    "experience": 1786
  },
  {
    "fee": "28000000000000000000",
    "experience": 2811
  },
  {
    "fee": "41000000000000000000",
    "experience": 4116
  },
  {
    "fee": "57000000000000000000",
    "experience": 5720
  },
  {
    "fee": "76000000000000000000",
    "experience": 7644
  },
  {
    "fee": "99000000000000000000",
    "experience": 9909
  },
  {
    "fee": "125000000000000000000",
    "experience": 12536
  },
  {
    "fee": "155000000000000000000",
    "experience": 15548
  },
  {
    "fee": "190000000000000000000",
    "experience": 18966
  },
  {
    "fee": "228000000000000000000",
    "experience": 22814
  },
  {
    "fee": "271000000000000000000",
    "experience": 27115
  },
  {
    "fee": "319000000000000000000",
    "experience": 31893
  },
  {
    "fee": "372000000000000000000",
    "experience": 37172
  },
  {
    "fee": "430000000000000000000",
    "experience": 42978
  },
  {
    "fee": "493000000000000000000",
    "experience": 49335
  },
  {
    "fee": "563000000000000000000",
    "experience": 56269
  },
  {
    "fee": "638000000000000000000",
    "experience": 63807
  },
  {
    "fee": "720000000000000000000",
    "experience": 71975
  },
  {
    "fee": "808000000000000000000",
    "experience": 80801
  },
  {
    "fee": "941000000000000000000",
    "experience": 94075
  },
  {
    "fee": "1246000000000000000000",
    "experience": 124632
  },
  {
    "fee": "1599000000000000000000",
    "experience": 159943
  },
  {
    "fee": "2004000000000000000000",
    "experience": 200392
  },
  {
    "fee": "2464000000000000000000",
    "experience": 246375
  },
  {
    "fee": "2983000000000000000000",
    "experience": 298300
  },
  {
    "fee": "3566000000000000000000",
    "experience": 356587
  },
  {
    "fee": "4217000000000000000000",
    "experience": 421668
  },
  {
    "fee": "4940000000000000000000",
    "experience": 493987
  },
  {
    "fee": "5740000000000000000000",
    "experience": 574000
  }
];

enum Career {
  SOLDIER = 1, // 战士
  MASTER, // 法师
  ASSASSIN, // 刺客
  KNIGHT, // 骑士
  PRIEST, // 牧师
  WARLOCK, // 术士
}

export {
  Career,
  LevelMaxStrengthArray,
  UpgradeExperienceArray
};
