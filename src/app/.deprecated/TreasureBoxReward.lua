--[[--
    TreasureBoxReward.lua
    宝箱奖励
]]
local TreasureBoxReward = class("TreasureBoxReward", require("app.data.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---TreasureBoxReward.ctor 构造函数
---@param treasureBoxType string 宝箱的类型
---@return  nil Description
function TreasureBoxReward:ctor(treasureBoxType)
    self:setTreasureBoxReward(treasureBoxType)
    EventManager:doEvent(EventDef.ID.CREATE_TREASUREBOXREWARD, self)
end

function TreasureBoxReward:setTreasureBoxReward(treasureBoxType)
    self.treasureBoxType_ = treasureBoxType
end

function TreasureBoxReward:getTreasureBoxType()
    return self.treasureBoxType_
end

return TreasureBoxReward
