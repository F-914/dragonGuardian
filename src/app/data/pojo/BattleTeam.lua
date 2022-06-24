--[[--
    BattleTeam.lua
    我方阵营
]]
local BattleTeam = class("BattleTeam")

-- local
local ConstDef = require("app.def.ConstDef")
--

---BattleTeam.ctor 构造函数
---@param myTeam table 队伍情况
function BattleTeam:ctor(myTeam)
    if myTeam == nil then
        myTeam = {}
    end
    self.team_ = myTeam
end

---BattleTeam.getTeamSize 获取队伍中队员数量
---@return  number 返回队员数量
function BattleTeam:getTeamSize()
    if self.team_ == nil then
        return 0
    end
    return #(self.team_)
end

return BattleTeam
