enum PropType {
  COIN = 1, // 代币
  STONE, // 矿石
  GEM_STONE, // 宝石
  SCORE, // 积分
  POTION, // 药水
  HIDE, // 兽皮
  BUSHMEAT, // 兽肉
  CLOTH, // 布料
  WOOD, // 木材
  FRAGMENTS, // 碎片
}

enum Prop {
  GOLD_COIN = 1, // 金币
  USDT_COIN = 2, // usdt
  CORE_TOKEN = 3, // 治理token

  // 矿石
  GOLD_ORE = 4, // 金矿石
  SILVER_ORE = 5, // 银矿石
  COPPER_ORE = 6, // 铜矿石
  BLACK_IRON_STONE = 7, // 黑铁石
  GOLD_SILVE_STONE = 8, // 秘银矿

  // 宝石
  RED_GEM_STONE = 9, // 红宝石
  BLUE_GEM_STONE = 10, // 蓝宝石
  YELLOW_GEM_STONE = 11, // 黄宝石
  ENERGY_STONE = 12, // 能量石
  LUCKY_STONE = 13, // 幸运石
  CRYSTAL = 14, // 水晶
  DIAMOND = 15, // 钻石

  // 积分
  BRAVE_POINTS = 16, // 勇者积分
  HONOR_VALUE = 17, // 荣誉值

  // 药水
  LUCKY_POTION = 18, // 幸运药水

  // 兽皮
  HIDE_LOW = 19, // 普通兽皮
  HIDE_MIDDLE = 20, // 坚韧兽皮
  HIDE_HIGH = 21, // 魔化兽皮
  HIDE_SUPER = 22, // 神性兽皮
  HIDE_SUPER_SUPER = 23, // 五色龙鳞

  // 兽肉
  BUSHMEAT_LOW = 24, // 劣质兽肉
  BUSHMEAT_MIDDLE = 25, // 普通兽肉
  BUSHMEAT_HIGH = 26, // 优质兽肉

  // 布料
  CLOTH_LOW = 27, // 粗布
  CLOTH_MIDDLE = 28, // 细布
  CLOTH_HIGH = 29, // 锦布
  CLOTH_SUPER = 30, // 绸缎
  CLOTH_SUPER_SUPER = 31, // 神纱

  // 木材
  WOOD_LOW = 32, // 杨木
  WOOD_MIDDLE = 33, // 柏木
  WOOD_HIGH = 34, // 橡木
  WOOD_SUPER = 35, // 雷霆木
  WOOD_SUPER_SUPER = 36, // 凤凰木

  // 碎片
  RULE_FRAGMENTS = 37, // 法则碎片
  SOUL_FRAGMENTS = 38, // 灵魂碎片
  DIVINE_FRAGMENTS = 39, // 神性碎片
}

enum ValueType {
  Null, // 0无
  Attack, // 1伤害
  Defenses, // 2防御
  GroupAttack, // 3群攻
  Evasion, // 4躲避伤害
  RecoveryHealth, // 5回复生命
  RecoveryHealthAndNegativeEffects, // 6回复生命+驱除负面效果
  Resurrection, // 7复活队友
  ContinueRecoveryHealth, // 8被动技能每回合恢复队友生命
  AbsorptionLife, // 9吸取生命
  Rigidity, // 10所有对手本回合僵直
  MonitorRecoveryHealth, // 11生命降至阈值触发恢复
}

enum Unit {
  Null = 0, // 0无
  Fixed = 1, // 1固定
  Percentage = 2 // 2百分比
}

enum EffectRange {
  Null = 0, // 0无
  Monomer = 1, // 1单体
  Group = 2, // 2群体
}

// 材料数组
const PropArray = [
  {
    id: Prop.GOLD_COIN, // 金币
    name: 'Gold Coin',
    typeId: PropType.COIN,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.USDT_COIN,
    name: 'Usdt Coin',
    typeId: PropType.COIN,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CORE_TOKEN,
    name: 'Core Token',
    typeId: PropType.COIN,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.GOLD_ORE, // 金矿石
    name: 'Gold Ore', // 金矿石
    typeId: PropType.STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.SILVER_ORE,
    name: 'Silver Ore',
    typeId: PropType.STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.COPPER_ORE,
    name: 'Copper Ore',
    typeId: PropType.STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.BLACK_IRON_STONE,
    name: 'Black Iron Stone',
    typeId: PropType.STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.GOLD_SILVE_STONE, // 秘银矿
    name: 'Gold Silve Stone',
    typeId: PropType.STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.RED_GEM_STONE, // 红宝石
    name: "Red Gem Stone", // 红宝石
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10, // 镶嵌+10 力量
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Fixed,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.BLUE_GEM_STONE,
    name: 'Blue Gem Stone',
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10, // 镶嵌+10 精神
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Fixed,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.YELLOW_GEM_STONE,
    name: 'Yellow Gem Stone',
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10, // 镶嵌+10 敏捷
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Fixed,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.ENERGY_STONE,
    name: 'Energy Stone', // 能量石
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.LUCKY_STONE, // 幸运石
    name: 'Lucky Stone', // 幸运石
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 1,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CRYSTAL,
    name: 'Crystal', // 水晶
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.DIAMOND,
    name: 'Diamond', // 钻石
    typeId: PropType.GEM_STONE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.BRAVE_POINTS,
    name: 'Brave Points', // 勇者积分
    typeId: PropType.SCORE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.HONOR_VALUE,
    name: 'Honor Value', // 荣耀值
    typeId: PropType.SCORE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.LUCKY_POTION, // 幸运药水
    name: 'Lucky Potion', // 幸运药水
    typeId: PropType.POTION,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 1,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.HIDE_LOW, // 普通兽皮
    name: "Hide Low",
    typeId: PropType.HIDE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.HIDE_MIDDLE,
    name: "Hide Middle",
    typeId: PropType.HIDE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.HIDE_HIGH,
    name: "Hide High",
    typeId: PropType.HIDE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.HIDE_SUPER,
    name: "Hide Super",
    typeId: PropType.HIDE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.HIDE_SUPER_SUPER,
    name: "Hide Super Super",
    typeId: PropType.HIDE,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.BUSHMEAT_LOW, // 瘦肉
    name: "Bushmeat Low",
    typeId: PropType.BUSHMEAT,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 5,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.BUSHMEAT_MIDDLE,
    name: "Bushmeat Middle",
    typeId: PropType.BUSHMEAT,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.BUSHMEAT_HIGH,
    name: "Bushmeat High",
    typeId: PropType.BUSHMEAT,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 20,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CLOTH_LOW, // 粗布
    name: "Cloth Low",
    typeId: PropType.CLOTH,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CLOTH_MIDDLE,
    name: "Cloth Middle",
    typeId: PropType.CLOTH,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CLOTH_HIGH,
    name: "Cloth High",
    typeId: PropType.CLOTH,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CLOTH_SUPER,
    name: "Cloth Super",
    typeId: PropType.CLOTH,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.CLOTH_SUPER_SUPER,
    name: "Cloth Super Super",
    typeId: PropType.CLOTH,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.WOOD_LOW, // 杨木
    name: "Wood Low",
    typeId: PropType.WOOD,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.WOOD_MIDDLE, // 柏木
    name: "Wood Middle",
    typeId: PropType.WOOD,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.WOOD_HIGH, // 橡木
    name: "Wood High",
    typeId: PropType.WOOD,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.WOOD_SUPER, // 雷霆木
    name: "Wood Super",
    typeId: PropType.WOOD,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.WOOD_SUPER_SUPER, // 凤凰木
    name: "Wood Super Super",
    typeId: PropType.WOOD,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 0,
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.RULE_FRAGMENTS, // 法则碎片
    name: "Rule Fragments",
    typeId: PropType.FRAGMENTS,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10, // 镶嵌+10暴击
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.SOUL_FRAGMENTS, // 灵魂碎片
    name: "Soul Fragments",
    typeId: PropType.FRAGMENTS,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10, // 镶嵌+10防御
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  },
  {
    id: Prop.DIVINE_FRAGMENTS, // 神性碎片
    name: "Divine Fragments",
    typeId: PropType.FRAGMENTS,
    startId: 0,
    endId: 0,
    minLevel: 0,
    value: 10, // 镶嵌+10躲避
    valueType: ValueType.Null,
    triggerValue: 0,
    unit: Unit.Null,
    effectRange: EffectRange.Null,
  }
];

export { PropArray, Prop, EffectRange, ValueType, Unit };
