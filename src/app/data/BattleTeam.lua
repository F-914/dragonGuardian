--[[--
    BattleTeam.lua
    我方阵营
]]
local BattleTeam = class("BattleTeam", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---BattleTeam.ctor 构造函数
---@param myTeam table 队伍情况
function BattleTeam:ctor(myTeam)
    self:setBattleTeam(myTeam)
    EventManager:doEvent(EventDef.ID.CREATE_BATTLETEAM, self)
end

function BattleTeam:setBattleTeam(myTeam)
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
