
--local
local StringDef = require("app.def.StringDef")

local ConstDef = {
    scale_ = 0.7,
    ROW_COMMODITY_NUMBER = 3,
    CARD_TOTAL_NUM = 20,
    SHOP_ITEM_HEIGHT = display.height / 6,
    SHOP_ITEM_WIDTH = display.width / 5,
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
    ICON_TOWER_LEVEL_LIST = {
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_01,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_02,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_03,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_04,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_05,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_06,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_07,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_08,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_09,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_10,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_11,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_12,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_13,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_14,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_15,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_16,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_17,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_18,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_19,
        StringDef.PATH_SUBINTERFACE_TOWER_LEVEL_20,
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
    ICON_SUBINTERFACE_TOWER_LINE_UP = {
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_01,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_02,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_03,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_04,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_05,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_06,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_07,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_08,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_09,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_10,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_11,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_12,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_13,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_14,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_15,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_16,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_17,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_18,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_19,
        StringDef.PATH_SUBINTERFACE_TOWER_LINE_UP_20,
    },
    ICON_CURRENCY_TYPE = {
        StringDef.PATH_COIN_SHOP_COIN,
        StringDef.PATH_COIN_SHOP_DIAMOND,
    },


    ICON_SUBINSTANCE_TOWER_LIST_TYPE = {
        StringDef.PATH_SUBINTERFACE_TOWER_TYPE_ATTACK,
        StringDef.PATH_SUBINTERFACE_TOWER_TYPE_DISTURB,
        StringDef.PATH_SUBINTERFACE_TOWER_TYPE_AUX,
        StringDef.PATH_SUBINTERFACE_TOWER_TYPE_CONTROL
    },


    LINEUP_LIST = { --图鉴界面中的三个阵容
        lineupOne = { 1, 1, 1, 1, 1 },
        lineupTwo = { 2, 2, 2, 2, 2 },
        lineupThree = { 3, 3, 3, 3, 3 }
    },

    STR_TOWER_TYPE = {
        StringDef.STR_TYPE_ATTACK,
        StringDef.STR_TYPE_DISTURB,
        StringDef.STR_TYPE_AUX,
        StringDef.STR_TYPE_CONTROL,
    },
    STR_TOWER_RARITY = {
        StringDef.STR_RARITY_R,
        StringDef.STR_RARITY_SR,
        StringDef.STR_RARITY_SSR,
        StringDef.STR_RARITY_UR,
    },
    STR_TOWER_ATK_TARGET = {
        StringDef.STR_ATK_TARGET_FRONT,
        StringDef.STR_ATK_TARGET_BACK,
        StringDef.STR_ATK_TARGET_LEFT,
        StringDef.STR_ATK_TARGET_RIGHT,
        StringDef.STR_ATK_TARGET_RANDOM,
        StringDef.STR_ATK_TARGET_HP_FIRST,

    },
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
    TREASUREBOX_REWARD = {
        R = 1,
        SR = 2,
        SSR = 3,
        UR = 4,
        COIN = 5,
    },
    SHOP_BOX_TYPE_BASE_PATH = {
        StringDef.PATH_DIAMOND_SHOP_BASE_NORMAL,
        StringDef.PATH_DIAMOND_SHOP_BASE_RARE,
        StringDef.PATH_DIAMOND_SHOP_BASE_EPIC,
        StringDef.PATH_DIAMOND_SHOP_BASE_LEGEND,
    },
    SHOP_BOX_TYPE_BOX_PATH = {
        StringDef.PATH_DIAMOND_SHOP_BOX_NORMAL,
        StringDef.PATH_DIAMOND_SHOP_BOX_RARE,
        StringDef.PATH_DIAMOND_SHOP_BOX_EPIC,
        StringDef.PATH_DIAMOND_SHOP_BOX_LEGEND,
    },
    CURRENCY_TYPE = {
        COIN = 1,
        DIAMOND = 2,
    },
    COMMODITY_TYPE = {
        TOWER = 1,
        CURRENCY = 2,
        TREASUREBOX = 3,
        UR = 4
        -- 这是个啥……我也不知道这是啥了

    },
    TREASUREBOX_TYPE = {
        R = 1,
        SR = 2,
        SSR = 3,
        UR = 4,

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

    CARD_UPDATE_CONDITION = {
        CARD_CONDITION = {
            -- 这个里面是或者的关系
            {
                R = 2
            },
            {
                R = 4
            },
            {
                R = 10,
                SR = 2,
            },
            {
                R = 20,
                SR = 4,
            },
            { R = 50,
              SR = 10,
              SSR = 2 },
            { R = 100,
              SR = 20,
              SSR = 4 },
            {
                R = 200,
                SR = 50,
                SSR = 10
            },
            { R = 400,
              SR = 100,
              SSR = 20 },
            {
                R = 800,
                SR = 200,
                SSR = 50,
                UR = 2
            },
            { R = 1000,
              SR = 400,
              SSR = 100,
              UR = 4 },
            {
                R = 2000,
                SR = 800,
                SSR = 200,
                UR = 10
            },
            { R = 5000,
              SR = 1000,
              SSR = 400,
              UR = 20 },
        },
        COIN_CONDITION = {
            5,
            20,
            50,
            150,
            400,
            1000,
            2000,
            4000,
            8000,
            20000,
            50000,
            100000
        }
    },
    BULLET_SIZE = {
        WIDTH = 10, --子弹宽度
        HEIGHT = 10 --子弹高度
    },
    ENEMY_SIZE = {
        --种类1，小怪（后续有时间可整体修改标识）
        {
            WIDTH = 43, --宽度
            HEIGHT = 44 --高度
        },
        --种类2，精英怪
        {
            WIDTH = 72, --宽度
            HEIGHT = 74 --高度
        }
    },
    CARD_BUTTON_SIZE = {
        WIDTH = 120 * 0.85,
        HEIGHT = 120 * 0.85
    }

}
return ConstDef
