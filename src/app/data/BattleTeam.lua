--[[--
    BattleTeam.lua
    我方阵营
]]
local BattleTeam = class("BattleTeam", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local Log = require("app.utils.Log")
--

---BattleTeam.ctor 构造函数
---@param myTeam table 队伍情况 注意：table格式为 {{id1, id2, id3, id4, id5}, {}, {}}
---table 中只记录卡牌的id，之后通过UserInfo的cardList找到对应id的卡牌，避免复制带来的重复信息
function BattleTeam:ctor(myTeam, StandbyTeam)
    self:setBattleTeam(myTeam, StandbyTeam)
    EventManager:doEvent(EventDef.ID.CREATE_BATTLETEAM, self)
end

function BattleTeam:setBattleTeam(myTeam, standbyTeam)
    if myTeam == nil then
        myTeam = {}
    end
    if standbyTeam > #(myTeam) then
        Log.e("Array out of bounds in BattleTeam:setBattleTeam()")
        exit()
    end
    self.team_ = myTeam
    self.standbyTeam_ = standbyTeam
    Log.i("StandbyTeam: " .. tostring(standbyTeam))
end

function BattleTeam:setStandbyTeam(index)
    if index > #(self.team_) then
        Log.e("Array out of bounds in BattleTeam:setStandbyTeam()")
        return
    end
    self.standbyTeam_ = index
end

function BattleTeam:getStandbyTeam()
    return self.standbyTeam_
end

---BattleTeam.getTeamSize 获取队伍中队员数量
---@return  number 返回队员数量
function BattleTeam:getTeamSize()
    if self.team_ == nil then
        return 0
    end
    return #(self.team_)
end

--[[--
    @description: 获取当前出战的队伍
]]
function BattleTeam:getCurrentBattleTeam()
    Log.i("StandbyTeam: " .. tostring(self.standbyTeam_))
    return self.team_[self.standbyTeam_]
end

function BattleTeam:getIndexTeam(index)
    if self.team_ == nil then
        self.team_ = {}
    end
    if index > #(self.team_) then
        return {}
    end
    return self.team_[index]
end

function BattleTeam:setIndexTeamCard(teamIndex, cardIndex, newCardId)
    if teamIndex > #(self.team_) then
        return
    end
    local team = self:getIndexTeam(teamIndex)
    if cardIndex > #(team) then
        return
    end
    team[cardIndex] = newCardId
end

return BattleTeam
