--[[--
    CurrencyReward.lua
    钻石/金币奖励
]]
local CurrencyReward = class("CurrencyReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
--

function CurrencyReward:ctor(rewardName, locked, received, trophyCondition, rewardType, rewardAmount)
    CurrencyReward.super.ctor(rewardName, locked, received, trophyCondition)
    self.rewardType_ = rewardType
    self.rewardAmount_ = rewardAmount
end

function CurrencyReward:getRewardType()
    return self.rewardType_
end

function CurrencyReward:getRewardAmount()
    return self.rewardAmount_
end

return CurrencyReward
