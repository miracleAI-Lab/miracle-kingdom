import { Career } from './hero.ts'
import { EffectRange, ValueType, Unit } from './prop.ts'

enum Skill {
  LEAP_ATTACK = 1, // 战士
  LUNGE,
  CROSS_CUTTING,
  RAGE,
  ANGRY_SLASH,
  BLADESTORM,
  SWORD_QI_EXPLOSION,
  BLAZE_THE_PRAIRIE,
  SUPERARMOR,
  FIRE_BALL, // 法师
  WIND_BLADE,
  ICE_SHIELD,
  HELLFIRE,
  LIGHTNING_STRIKE,
  ICE_CONE,
  FIRE_RAIN,
  FORBIDDEN_CURSE,
  PHOENIX,
  STRIKE, // 刺客
  DEATHBLOW,
  PHANTOM,
  SHADOW_ATTACK,
  POISONOUS_STING,
  MOONLIGHT_SLASH,
  CRITICAL_STRIKE,
  POISONOUS_MIST,
  STEALTH,
}

// 技能数组
const SkillArray = [
  {
    "name": "Leap Strike",
    "id": 1,
    "maxLevel": 3,
    "heroReqLevels": [
      1,
      2,
      3
    ],
    "fees": [
      "10000000000000000000",
      "10000000000000000000",
      "10000000000000000000"
    ],
    "career": 1,
    "values": [
      86,
      100,
      143
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Thrust",
    "id": 2,
    "maxLevel": 3,
    "heroReqLevels": [
      3,
      4,
      5
    ],
    "fees": [
      "20000000000000000000",
      "20000000000000000000",
      "20000000000000000000"
    ],
    "career": 1,
    "values": [
      124,
      145,
      207
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Cross Slash",
    "id": 3,
    "maxLevel": 3,
    "heroReqLevels": [
      6,
      7,
      8
    ],
    "fees": [
      "30000000000000000000",
      "30000000000000000000",
      "30000000000000000000"
    ],
    "career": 1,
    "values": [
      162,
      190,
      271
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Shield Bash",
    "id": 4,
    "maxLevel": 3,
    "heroReqLevels": [
      9,
      10,
      11
    ],
    "fees": [
      "40000000000000000000",
      "40000000000000000000",
      "40000000000000000000"
    ],
    "career": 1,
    "values": [
      5,
      8,
      10
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 2,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Frenzy Slash",
    "id": 5,
    "maxLevel": 3,
    "heroReqLevels": [
      12,
      13,
      14
    ],
    "fees": [
      "50000000000000000000",
      "50000000000000000000",
      "50000000000000000000"
    ],
    "career": 1,
    "values": [
      239,
      279,
      399
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Blade Storm",
    "id": 6,
    "maxLevel": 3,
    "heroReqLevels": [
      15,
      16,
      17
    ],
    "fees": [
      "60000000000000000000",
      "60000000000000000000",
      "60000000000000000000"
    ],
    "career": 1,
    "values": [
      278,
      324,
      463
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 2,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Sword Burst",
    "id": 7,
    "maxLevel": 3,
    "heroReqLevels": [
      18,
      19,
      20
    ],
    "fees": [
      "70000000000000000000",
      "70000000000000000000",
      "70000000000000000000"
    ],
    "career": 1,
    "values": [
      316,
      369,
      527
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Rage of Fury",
    "id": 8,
    "maxLevel": 3,
    "heroReqLevels": [
      20,
      20,
      20
    ],
    "fees": [
      "80000000000000000000",
      "80000000000000000000",
      "80000000000000000000"
    ],
    "career": 1,
    "values": [
      342,
      399,
      570
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 2,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Iron Body",
    "id": 9,
    "maxLevel": 3,
    "heroReqLevels": [
      21,
      21,
      21
    ],
    "fees": [
      "90000000000000000000",
      "90000000000000000000",
      "90000000000000000000"
    ],
    "career": 1,
    "values": [
      10,
      15,
      20
    ],
    "valueType": 2,
    "triggerValue": 0,
    "unit": 2,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1000000,
    "calculationType": 1
  },
  {
    "name": "Fireball",
    "id": 10,
    "maxLevel": 3,
    "heroReqLevels": [
      1,
      2,
      3
    ],
    "fees": [
      "10000000000000000000",
      "10000000000000000000",
      "10000000000000000000"
    ],
    "career": 2,
    "values": [
      99,
      116,
      165
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Wind Blade",
    "id": 11,
    "maxLevel": 3,
    "heroReqLevels": [
      3,
      4,
      5
    ],
    "fees": [
      "20000000000000000000",
      "20000000000000000000",
      "20000000000000000000"
    ],
    "career": 2,
    "values": [
      144,
      167,
      239
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Ice Shield",
    "id": 12,
    "maxLevel": 3,
    "heroReqLevels": [
      6,
      7,
      8
    ],
    "fees": [
      "30000000000000000000",
      "30000000000000000000",
      "30000000000000000000"
    ],
    "career": 2,
    "values": [
      5,
      8,
      10
    ],
    "valueType": 2,
    "triggerValue": 0,
    "unit": 2,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1000000,
    "calculationType": 1
  },
  {
    "name": "Inferno",
    "id": 13,
    "maxLevel": 3,
    "heroReqLevels": [
      9,
      10,
      11
    ],
    "fees": [
      "40000000000000000000",
      "40000000000000000000",
      "40000000000000000000"
    ],
    "career": 2,
    "values": [
      233,
      271,
      388
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 2,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Thunder",
    "id": 14,
    "maxLevel": 3,
    "heroReqLevels": [
      12,
      13,
      14
    ],
    "fees": [
      "50000000000000000000",
      "50000000000000000000",
      "50000000000000000000"
    ],
    "career": 2,
    "values": [
      277,
      323,
      462
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Ice Spike",
    "id": 15,
    "maxLevel": 3,
    "heroReqLevels": [
      15,
      16,
      17
    ],
    "fees": [
      "60000000000000000000",
      "60000000000000000000",
      "60000000000000000000"
    ],
    "career": 2,
    "values": [
      322,
      375,
      536
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Fire Rain",
    "id": 16,
    "maxLevel": 3,
    "heroReqLevels": [
      18,
      19,
      20
    ],
    "fees": [
      "70000000000000000000",
      "70000000000000000000",
      "70000000000000000000"
    ],
    "career": 2,
    "values": [
      366,
      427,
      611
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 2,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Forbidden Spell",
    "id": 17,
    "maxLevel": 3,
    "heroReqLevels": [
      20,
      20,
      20
    ],
    "fees": [
      "80000000000000000000",
      "80000000000000000000",
      "80000000000000000000"
    ],
    "career": 2,
    "values": [
      396,
      462,
      660
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 2,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Phoenix Blessing",
    "id": 18,
    "maxLevel": 3,
    "heroReqLevels": [
      21,
      21,
      21
    ],
    "fees": [
      "90000000000000000000",
      "90000000000000000000",
      "90000000000000000000"
    ],
    "career": 2,
    "values": [
      10,
      15,
      20
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 2,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1000000,
    "calculationType": 1
  },
  {
    "name": "Flash Strike",
    "id": 19,
    "maxLevel": 3,
    "heroReqLevels": [
      1,
      2,
      3
    ],
    "fees": [
      "10000000000000000000",
      "10000000000000000000",
      "10000000000000000000"
    ],
    "career": 3,
    "values": [
      162,
      189,
      270
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Deadly Strike",
    "id": 20,
    "maxLevel": 3,
    "heroReqLevels": [
      3,
      4,
      5
    ],
    "fees": [
      "20000000000000000000",
      "20000000000000000000",
      "20000000000000000000"
    ],
    "career": 3,
    "values": [
      235,
      274,
      392
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Phantom",
    "id": 21,
    "maxLevel": 3,
    "heroReqLevels": [
      6,
      7,
      8
    ],
    "fees": [
      "30000000000000000000",
      "30000000000000000000",
      "30000000000000000000"
    ],
    "career": 3,
    "values": [
      5,
      8,
      10
    ],
    "valueType": 4,
    "triggerValue": 0,
    "unit": 2,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1000000,
    "calculationType": 1
  },
  {
    "name": "Shadow Assault",
    "id": 22,
    "maxLevel": 3,
    "heroReqLevels": [
      9,
      10,
      11
    ],
    "fees": [
      "40000000000000000000",
      "40000000000000000000",
      "40000000000000000000"
    ],
    "career": 3,
    "values": [
      381,
      444,
      635
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Poison Spike",
    "id": 23,
    "maxLevel": 3,
    "heroReqLevels": [
      12,
      13,
      14
    ],
    "fees": [
      "50000000000000000000",
      "50000000000000000000",
      "50000000000000000000"
    ],
    "career": 3,
    "values": [
      454,
      529,
      756
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Moonlight Slash",
    "id": 24,
    "maxLevel": 3,
    "heroReqLevels": [
      15,
      16,
      17
    ],
    "fees": [
      "60000000000000000000",
      "60000000000000000000",
      "60000000000000000000"
    ],
    "career": 3,
    "values": [
      527,
      614,
      878
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Instant kill",
    "id": 25,
    "maxLevel": 3,
    "heroReqLevels": [
      18,
      19,
      20
    ],
    "fees": [
      "70000000000000000000",
      "70000000000000000000",
      "70000000000000000000"
    ],
    "career": 3,
    "values": [
      599,
      699,
      999
    ],
    "valueType": 1,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 1,
    "effectDistance": 1,
    "limit": 1,
    "round": 1,
    "calculationType": 1
  },
  {
    "name": "Poison Mist",
    "id": 26,
    "maxLevel": 3,
    "heroReqLevels": [
      20,
      20,
      20
    ],
    "fees": [
      "80000000000000000000",
      "80000000000000000000",
      "80000000000000000000"
    ],
    "career": 3,
    "values": [
      648,
      756,
      1080
    ],
    "valueType": 3,
    "triggerValue": 0,
    "unit": 1,
    "effectRange": 2,
    "effectDistance": 2,
    "limit": 1,
    "round": 1000000,
    "calculationType": 1
  },
  {
    "name": "Stealth",
    "id": 27,
    "maxLevel": 3,
    "heroReqLevels": [
      21,
      21,
      21
    ],
    "fees": [
      "90000000000000000000",
      "90000000000000000000",
      "90000000000000000000"
    ],
    "career": 3,
    "values": [
      10,
      15,
      20
    ],
    "valueType": 12,
    "triggerValue": 0,
    "unit": 2,
    "effectRange": 1,
    "effectDistance": 2,
    "limit": 1,
    "round": 1000000,
    "calculationType": 1
  }
];

export { SkillArray, Skill };
