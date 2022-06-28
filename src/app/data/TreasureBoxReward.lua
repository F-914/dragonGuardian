--[[--
    TreasureBoxReward.lua
    宝箱奖励
]]
local TreasureBoxReward = class("TreasureBoxReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
--

function TreasureBoxReward:ctor(rewardName, locked, received, trophyCondition, treasureBoxType, rewardAmount)
    TreasureBoxReward.super.ctor(rewardName, locked, received, trophyCondition)
    self.treasureBoxType_ = treasureBoxType
    self.rewardAmount_ = rewardAmount
end

function TreasureBoxReward:setTreasureBoxReward(rewardName, locked, received, trophyCondition, treasureBoxType,
                                                rewardAmount)
    TreasureBoxReward.super.ctor(rewardName, locked, received, trophyCondition)
    self.treasureBoxType_ = treasureBoxType
    self.rewardAmount_ = rewardAmount
end

function TreasureBoxReward:getTreasureBoxType()
    return self.treasureBoxType_
end

function TreasureBoxReward:getRewardAmount()
    return self.rewardAmount_
end

return CurrencyReward
