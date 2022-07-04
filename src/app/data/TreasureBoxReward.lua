--[[--
    TreasureBoxReward.lua
    宝箱奖励
]]
local TreasureBoxReward = class("TreasureBoxReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---TreasureBoxReward.ctor 构造函数
---@param treasureBoxType string 宝箱的类型
---@param rewardAmount    number 宝箱的数量
---@return  Type Description
function TreasureBoxReward:ctor(treasureBoxType, rewardAmount)
    self:setTreasureBoxReward(treasureBoxType, rewardAmount)
    EventManager:doEvent(EventDef.ID.CREATE_TREASUREBOXREWARD, self)
end

function TreasureBoxReward:setTreasureBoxReward(treasureBoxType, rewardAmount)
    self.treasureBoxType_ = treasureBoxType
    self.rewardAmount_ = rewardAmount
end

function TreasureBoxReward:getTreasureBoxType()
    return self.treasureBoxType_
end

function TreasureBoxReward:getRewardAmount()
    return self.rewardAmount_
end

return TreasureBoxReward
