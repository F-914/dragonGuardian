--[[--
    TreasureBoxReward.lua
    宝箱奖励
]]
local TreasureBoxReward = class("TreasureBoxReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---TreasureBoxReward.ctor 构造函数
---@param treasureBoxType string 宝箱的类型（这里用的是字符串，暂时的想法是可以根据宝箱的类型来选择不同的函数去执行
---@param rewardAmount    number 宝箱的数量
---@return  Type Description
function TreasureBoxReward:ctor(treasureBoxType, rewardAmount)
    self:setTreasureBoxReward(treasureBoxType, rewardAmount)
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
