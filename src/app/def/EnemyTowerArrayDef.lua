--[[--
    TowerArrayDef.lua

    描述：存放当前游戏中塔编队信息
]]
--local
local StringDef = require("app.def.StringDef")
local TowerDef = require("app.def.TowerDef")
local Log = require("app.utils.Log")
--
local EnemyTowerArrayDef = {
    {
        ID = 1,
        ICON_PATH = StringDef.PATH_TOWER_01,
        RARITY = TowerDef[1].RARITY,
        TYPE = TowerDef[1].TYPE,
        SP = 100
    },
    {
        ID = 2,
        ICON_PATH = StringDef.PATH_TOWER_02,
        RARITY = TowerDef[2].RARITY,
        TYPE = TowerDef[2].TYPE,
        SP = 100
    },
    {
        ID = 3,
        ICON_PATH = StringDef.PATH_TOWER_03,
        RARITY = TowerDef[3].RARITY,
        TYPE = TowerDef[3].TYPE,
        SP = 100
    },
    {
        ID = 17,
        ICON_PATH = StringDef.PATH_TOWER_17,
        RARITY = TowerDef[17].RARITY,
        TYPE = TowerDef[17].TYPE,
        SP = 100
    },
    {
        ID = 14,
        ICON_PATH = StringDef.PATH_TOWER_14,
        RARITY = TowerDef[14].RARITY,
        TYPE = TowerDef[14].TYPE,
        SP = 100
    },
}

--[[--
    获取塔种类对应名称

    @param number：塔内编号

    @return string：塔种类名称
]]
function EnemyTowerArrayDef:getTypeString(num)
    local towerType
    if EnemyTowerArrayDef[num].TYPE == 1 then
        towerType = "atk"
    elseif EnemyTowerArrayDef[num].TYPE == 2 then
        towerType = "auxiliary"
    elseif EnemyTowerArrayDef[num].TYPE == 3 then
        towerType = "control"
    elseif EnemyTowerArrayDef[num].TYPE == 4 then
        towerType = "interfere"
    elseif EnemyTowerArrayDef[num].TYPE == 5 then
        towerType = "summon"
    end

    return towerType
end

--[[--
    描述：设定编队信息

    @param int, int, int 位置、编号、价格
]]
function EnemyTowerArrayDef:setArray(num, id, sp)
    if num < 1 or num > 5 then
        Log.w("The first parameter is incorrect. The value must range from 1 to 5")
    else
        EnemyTowerArrayDef[num] = {
            ID = id,
            ICON_PATH = TowerDef[id].ICON_PATH,
            RARITY = TowerDef[id].RARITY,
            TYPE = TowerDef[id].TYPE,
            SP = sp
        }
    end
end

return EnemyTowerArrayDef