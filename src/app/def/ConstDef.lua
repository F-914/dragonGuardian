--[[--
    ConstDef.lua
    常量定义
]]

--local
local StringDef = require("app.def.StringDef")
--

local ConstDef = {
    scale_ = 0.9,
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
    LINEUP_LIST = {
        lineupOne = { 1, 1, 1, 1, 1 },
        lineupTwo = { 2, 2, 2, 2, 2 },
        lineupThree = { 3, 3, 3, 3, 3 }
    },
    COLLECTED = { 1, 1, 1, 1, 1, 2, 2, 2, 3, 3 },
    UNCOLLECTED = { 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 },
    TOWER_ATK_TARGET = {
        FRONT = 1, -- 前方
        BACK = 2, -- 后方
        LEFT = 3, -- 左方
        RIGHT = 4, -- 右方
        RANDOM = 5, -- 随机
        HP_FIRST = 6, -- 血量优先
    },
    TOWER_RARITY = {
        -- 或许你会说R是Rare，这样做的原因可以参考 中杯大杯 和 大杯超大杯，乐
        R = 1, -- 普通
        SR = 2, -- 稀有
        SSR = 3, -- 史诗
        UR = 4 -- 传奇
    },
    TOWER_TYPE = {
        ATTACK = 1, -- 攻击类别
        DISTURB = 2, -- 干扰类别
        AUXILIARY = 3, -- 辅助类别
        CONTROL = 4, -- 控制类别
    },
    GAME_STATE = {
        INIT = 1, -- 初始状态
        PLAY = 2, -- 游戏状态
        PAUSE = 3, -- 暂停状态
        RESULT = 4 -- 结算状态
    }
}
return ConstDef
