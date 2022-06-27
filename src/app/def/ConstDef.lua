--[[--
    ConstDef.lua
    常量定义
]]

-- PATH
local PATH_ICON_01 = "src/generic/tower_PATH_ICON/01.png"
local PATH_ICON_02 = "src/generic/tower_PATH_ICON/02.png"
local PATH_ICON_03 = "src/generic/tower_PATH_ICON/03.png"
local PATH_ICON_04 = "src/generic/tower_PATH_ICON/04.png"
local PATH_ICON_05 = "src/generic/tower_PATH_ICON/05.png"
local PATH_ICON_06 = "src/generic/tower_PATH_ICON/06.png"
local PATH_ICON_07 = "src/generic/tower_PATH_ICON/07.png"
local PATH_ICON_08 = "src/generic/tower_PATH_ICON/08.png"
local PATH_ICON_09 = "src/generic/tower_PATH_ICON/09.png"
local PATH_ICON_10 = "src/generic/tower_PATH_ICON/10.png"
local PATH_ICON_11 = "src/generic/tower_PATH_ICON/11.png"
local PATH_ICON_12 = "src/generic/tower_PATH_ICON/12.png"
local PATH_ICON_13 = "src/generic/tower_PATH_ICON/13.png"
local PATH_ICON_14 = "src/generic/tower_PATH_ICON/14.png"
local PATH_ICON_15 = "src/generic/tower_PATH_ICON/15.png"
local PATH_ICON_16 = "src/generic/tower_PATH_ICON/16.png"
local PATH_ICON_17 = "src/generic/tower_PATH_ICON/17.png"
local PATH_ICON_18 = "src/generic/tower_PATH_ICON/18.png"
local PATH_ICON_19 = "src/generic/tower_PATH_ICON/19.png"
local PATH_ICON_20 = "src/generic/tower_PATH_ICON/20.png"
--

local ConstDef = {
    scale_ = 0.9,
    ICON_LIST = { PATH_ICON_01, PATH_ICON_02,
        PATH_ICON_03, PATH_ICON_04,
        PATH_ICON_05, PATH_ICON_06,
        PATH_ICON_07, PATH_ICON_08,
        PATH_ICON_09, PATH_ICON_10,
        PATH_ICON_11, PATH_ICON_12,
        PATH_ICON_13, PATH_ICON_14,
        PATH_ICON_15, PATH_ICON_16,
        PATH_ICON_17, PATH_ICON_18,
        PATH_ICON_19, PATH_ICON_20 },
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
