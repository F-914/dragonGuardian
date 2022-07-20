--[[--
    TowerArrayDef.lua

    描述：存放当前游戏中塔编队信息
]]
--local
local StringDef = require("app.def.StringDef")
local TowerDef = require("app.def.TowerDef")
local Log = require("app.utils.Log")
--
local TowerArrayDef = {
    {
        ID = 12,
        ICON_PATH = StringDef.PATH_TOWER_12,
        TYPE = TowerDef[4].TYPE,
        SP = 102,
        LEVEL = 1
    },
    {
        ID = 5,
        ICON_PATH = StringDef.PATH_TOWER_05,
        TYPE = TowerDef[5].TYPE,
        SP = 100,
        LEVEL = 1
    },
    {
        ID = 6,
        ICON_PATH = StringDef.PATH_TOWER_06,
        TYPE = TowerDef[6].TYPE,
        SP = 101,
        LEVEL = 1
    },
    {
        ID = 7,
        ICON_PATH = StringDef.PATH_TOWER_07,
        TYPE = TowerDef[7].TYPE,
        SP = 100,
        LEVEL = 1
    },
    {
        ID = 8,
        ICON_PATH = StringDef.PATH_TOWER_08,
        TYPE = TowerDef[8].TYPE,
        SP = 100,
        LEVEL = 1
    },
}

--[[--
    强化升级设置
]]
function TowerArrayDef:levelUp(id)
    print("TowerArrayDef id", id)
    self[id].LEVEL = self[id].LEVEL + 1
end

--[[--
    强化后修改sp价格
]]
function TowerArrayDef:changeSP(id, sp)
    print("id, sp", id, sp)
    self[id].SP = sp
end

--[[--
    获取塔种类对应名称

    @param number：塔内编号

    @return string：塔种类名称
]]
function TowerArrayDef:getTypeString(num)
    local towerType
    if TowerArrayDef[num].TYPE == 1 then
        towerType = "atk"
    elseif TowerArrayDef[num].TYPE == 2 then
        towerType = "auxiliary"
    elseif TowerArrayDef[num].TYPE == 3 then
        towerType = "control"
    elseif TowerArrayDef[num].TYPE == 4 then
        towerType = "interfere"
    elseif TowerArrayDef[num].TYPE == 5 then
        towerType = "summon"
    end

    return towerType
end

--[[--
    描述：设定编队信息

    @param int, int, int 位置、编号、价格
]]
function TowerArrayDef:setArray(num, id, sp)
    if num < 1 or num > 5 then
        Log.w("The first parameter is incorrect. The value must range from 1 to 5")
    else
        TowerArrayDef[num] = {
            ID = id,
            ICON_PATH = TowerDef[id].ICON_PATH,
            SP = sp
        }
    end
end

return TowerArrayDef