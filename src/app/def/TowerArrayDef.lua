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
        SP = 102
    },
    {
        ID = 5,
        ICON_PATH = StringDef.PATH_TOWER_05,
        SP = 100
    },
    {
        ID = 6,
        ICON_PATH = StringDef.PATH_TOWER_06,
        SP = 101
    },
    {
        ID = 7,
        ICON_PATH = StringDef.PATH_TOWER_07,
        SP = 100
    },
    {
        ID = 8,
        ICON_PATH = StringDef.PATH_TOWER_08,
        SP = 100
    },
}

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