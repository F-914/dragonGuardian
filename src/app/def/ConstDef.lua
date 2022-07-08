--[[--
    ConstDef.lua
    常量定义
]]

--local
local StringDef = require("app.def.StringDef")
--

local ConstDef = {
    ROW_COMMODITY_NUMBER = 3,
    SHOP_ITEM_HEIGHT = display.height / 6,
    SHOP_ITEM_WIDTH = display.width / 5,
    scale_ = 0.7, --图鉴界面的缩放系数
    ICON_LIST = { StringDef.PATH_ICON_01, StringDef.PATH_ICON_02,
        StringDef.PATH_ICON_03, StringDef.PATH_ICON_04,
        StringDef.PATH_ICON_05, StringDef.PATH_ICON_06,
        StringDef.PATH_ICON_07, StringDef.PATH_ICON_08,
        StringDef.PATH_ICON_09, StringDef.PATH_ICON_10,
        StringDef.PATH_ICON_11, StringDef.PATH_ICON_12,
        StringDef.PATH_ICON_13, StringDef.PATH_ICON_14,
        StringDef.PATH_ICON_15, StringDef.PATH_ICON_16,
        StringDef.PATH_ICON_17, StringDef.PATH_ICON_18,
        StringDef.PATH_ICON_19, StringDef.PATH_ICON_20 },
    ICON_LINEUP_LIST = { StringDef.PATH_ICON_LINEUP_01, StringDef.PATH_ICON_LINEUP_02,
        StringDef.PATH_ICON_LINEUP_03, StringDef.PATH_ICON_LINEUP_04,
        StringDef.PATH_ICON_LINEUP_05, StringDef.PATH_ICON_LINEUP_06,
        StringDef.PATH_ICON_LINEUP_07, StringDef.PATH_ICON_LINEUP_08,
        StringDef.PATH_ICON_LINEUP_09, StringDef.PATH_ICON_LINEUP_10,
        StringDef.PATH_ICON_LINEUP_11, StringDef.PATH_ICON_LINEUP_12,
        StringDef.PATH_ICON_LINEUP_13, StringDef.PATH_ICON_LINEUP_14,
        StringDef.PATH_ICON_LINEUP_15, StringDef.PATH_ICON_LINEUP_16,
        StringDef.PATH_ICON_LINEUP_17, StringDef.PATH_ICON_LINEUP_18,
        StringDef.PATH_ICON_LINEUP_19, StringDef.PATH_ICON_LINEUP_20
    },
    ICON_UNCOLLECTED_LIST = { StringDef.PATH_ICON_UNCOLLECTED_01, StringDef.PATH_ICON_UNCOLLECTED_02,
        StringDef.PATH_ICON_UNCOLLECTED_03, StringDef.PATH_ICON_UNCOLLECTED_04,
        StringDef.PATH_ICON_UNCOLLECTED_05, StringDef.PATH_ICON_UNCOLLECTED_06,
        StringDef.PATH_ICON_UNCOLLECTED_07, StringDef.PATH_ICON_UNCOLLECTED_08,
        StringDef.PATH_ICON_UNCOLLECTED_09, StringDef.PATH_ICON_UNCOLLECTED_10,
        StringDef.PATH_ICON_UNCOLLECTED_11, StringDef.PATH_ICON_UNCOLLECTED_12,
        StringDef.PATH_ICON_UNCOLLECTED_13, StringDef.PATH_ICON_UNCOLLECTED_14,
        StringDef.PATH_ICON_UNCOLLECTED_15, StringDef.PATH_ICON_UNCOLLECTED_16,
        StringDef.PATH_ICON_UNCOLLECTED_17, StringDef.PATH_ICON_UNCOLLECTED_18,
        StringDef.PATH_ICON_UNCOLLECTED_19, StringDef.PATH_ICON_UNCOLLECTED_20,
    },
    ICON_TOWER_LIST = {
        StringDef.PATH_TOWER_01,
        StringDef.PATH_TOWER_02,
        StringDef.PATH_TOWER_03,
        StringDef.PATH_TOWER_04,
        StringDef.PATH_TOWER_05,
        StringDef.PATH_TOWER_06,
        StringDef.PATH_TOWER_07,
        StringDef.PATH_TOWER_08,
        StringDef.PATH_TOWER_09,
        StringDef.PATH_TOWER_10,
        StringDef.PATH_TOWER_11,
        StringDef.PATH_TOWER_12,
        StringDef.PATH_TOWER_13,
        StringDef.PATH_TOWER_14,
        StringDef.PATH_TOWER_15,
        StringDef.PATH_TOWER_16,
        StringDef.PATH_TOWER_17,
        StringDef.PATH_TOWER_18,
        StringDef.PATH_TOWER_19,
        StringDef.PATH_TOWER_20,
    },
    ICON_TOWER_GREY_LIST = {
        StringDef.PATH_TOWER_GREY_01,
        StringDef.PATH_TOWER_GREY_02,
        StringDef.PATH_TOWER_GREY_03,
        StringDef.PATH_TOWER_GREY_04,
        StringDef.PATH_TOWER_GREY_05,
        StringDef.PATH_TOWER_GREY_06,
        StringDef.PATH_TOWER_GREY_07,
        StringDef.PATH_TOWER_GREY_08,
        StringDef.PATH_TOWER_GREY_09,
        StringDef.PATH_TOWER_GREY_10,
        StringDef.PATH_TOWER_GREY_11,
        StringDef.PATH_TOWER_GREY_12,
        StringDef.PATH_TOWER_GREY_13,
        StringDef.PATH_TOWER_GREY_14,
        StringDef.PATH_TOWER_GREY_15,
        StringDef.PATH_TOWER_GREY_16,
        StringDef.PATH_TOWER_GREY_17,
        StringDef.PATH_TOWER_GREY_18,
        StringDef.PATH_TOWER_GREY_19,
        StringDef.PATH_TOWER_GREY_20,
    },
    ICON_TOWER_FRAGMENT = {
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_01,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_02,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_03,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_04,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_05,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_06,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_07,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_08,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_09,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_10,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_11,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_12,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_13,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_14,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_15,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_16,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_17,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_18,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_19,
        StringDef.PATH_COIN_SHOP_TOWER_FRAGMENT_20,
    },
    LINEUP_LIST = { --图鉴界面中的三个阵容
        lineupOne = { 1, 1, 1, 1, 1 },
        lineupTwo = { 2, 2, 2, 2, 2 },
        lineupThree = { 3, 3, 3, 3, 3 }
    },
    COLLECTED = {}, --已收集的塔，通过塔的序号1-20保存
    UNCOLLECTED = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 }, --未收集的塔，通过塔的序号1-20保存
    TOWER_ATK_TARGET = {
        FRONT = 1, -- 前方
        BACK = 2, -- 后方
        LEFT = 3, -- 左方
        RIGHT = 4, -- 右方
        RANDOM = 5, -- 随机
        HP_FIRST = 6, -- 血量优先
    },
    TOWER_RARITY = {
        R = 1, -- 普通
        SR = 2, -- 稀有
        SSR = 3, -- 史诗
        UR = 4 -- 传奇
    },
    TREASUREBOX_RARITY = {
        R = 1,
        SR = 2,
        SSR = 3,
        UR = 4,
    },
    SHOP_BOX_TYPE_BASE_PATH = {
        StringDef.PATH_DIAMOND_SHOP_BASE_NORMAL,
        StringDef.PATH_DIAMOND_SHOP_BASE_RARE,
        StringDef.PATH_DIAMON_SHOP_BASE_EPIC,
        StringDef.PATH_DIAMOND_SHOP_BASE_LEGEND,
    },
    SHOP_BOX_TYPE_BOX_PATH = {
        StringDef.PATH_DIAMOND_SHOP_BOX_NORMAL,
        StringDef.PATH_DIAMOND_SHOP_BOX_RARE,
        StringDef.PATH_DIAMON_SHOP_BOX_EPIC,
        StringDef.PATH_DIAMOND_SHOP_BOX_LEGEND,
    },
    CURRENCY_TYPE = {
        COIN = "COIN",
        DIAMOND = "DIAMON",
    },
    COMMODITY_TYPE = {
        TOWER = "TOWER",
        CURRENCY = "CURRENCY",
        TREASUREBOX = "TREASUREBOX",
    },
    TOWER_TYPE = {
        ATTACK = 1, -- 攻击类别
        DISTURB = 2, -- 干扰类别
        AUXILIARY = 3, -- 辅助类别
        CONTROL = 4, -- 控制类别
    },
    REWARD_TYPE = {
        CURRENCY = 1,
        CARD = 2,
        TREASUREBOX = 3,
        RANDOM = 4,
    },
    GAME_STATE = {
        INIT = 1, -- 初始状态
        PLAY = 2, -- 游戏状态
        PAUSE = 3, -- 暂停状态
        RESULT = 4 -- 结算状态
    },
    BUTTON_CLICK = {}, --用于实现部分功能的全局变量，希望后期能重写
    POPUP = {}, --用于实现弹窗部分功能的全局变量，希望后期能重写
}
return ConstDef
