--[[--
    EventDef.lua
    事件ID定义
]]
local EventDef = {}

EventDef.ID = {
    GAMESTATE_CHANGE = 0, --游戏状态变更
    DESTORY_POPUP = 1, --销毁使用弹窗(特定图鉴二级面板)
    SHOW_BAG = 2, --显示图鉴界面中的图鉴
    HIDE_BAG = 3, --隐藏图鉴界面中的图鉴
    RESUME_BAG_BUTTON = 4, --唤醒图鉴界面中的按钮(图标)
    CREATE_BATTLETEAM = 5,
    CREATE_CARD = 6,
    CREATE_CARDCOMMODITY = 7,
    CREATE_CARDREWARD = 8,
    CREATE_COMMODITY = 9,
    CREATE_CURRENCYCOMMODITY = 10,
    CREATE_CURRENCYREWARD = 11,
    CREATE_ENEMY = 12,
    CREATE_LADDER = 13,
    CREATE_REWARD = 14,
    CREATE_SKILL = 15,
    CREATE_TREASUREBOX = 16,
    CREATE_TREASUREBOXREWARD = 17,

    CREATE_BULLET = 18,
    CREATE_IN_GAME_CARD = 19,
    DESTORY_ENEMY = 20,
    DESTORY_BULLET = 21,
    DESTORY_CARD = 22,
    HURT_PLAYER = 23,
    HURT_ENEMY = 24,
    CARD_MERGE = 25,
    CREATE_ENEMY_CARD = 26,
    HIT_ENEMY = 27, --怪物受到攻击
    SEND_LINEUP = 28,
    CARD_LEVEL_UP = 29,
    -- TODO 此处不知道下面这三个是不是要加上 先放在这里 以保证程序运行
    CARD_USE = 30,
    --卡牌使用
    CARD_INTENSIFY = 31,
    --卡牌强化
    CARD_UPGRADE = 32,
    --卡牌升级
    CREATE_NEW_ATLAS_VIEW = 33
}

return EventDef
