--[[--
    StoreList.lua

    描述：商城相关数据
]]
local StoreList = {}

---------------------------------------------------------------------
-- 商店售卖龙的种类编号
StoreList.DRAGON_LIST = {
    {
        id =  1,
        type = "normal",
        number = 36
    },
    {
        id = 4,
        type = "normal",
        number = 36
    },
    {
        id = 9,
        type = "normal",
        number = 36
    },
    {
        id = 10,
        type = "rare",
        number = 6
    },
    {
        id = 12,
        type = "epic",
        number = 1
    }
}

---------------------------------------------------------------------
-- 塔稀有度对应售价
StoreList.TYPE_PRICE = {
    normal = 360,
    rare = 600,
    epic = 1000,
    legend = "--"
}

return StoreList