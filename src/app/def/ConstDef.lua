--[[--
    ConstDef.lua
    常量定义
]]
local ConstDef = {
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
