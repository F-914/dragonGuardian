--[[--
    Reward.lua
    奖励/宝箱对象基类
]]
local Reward = class("Reward", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

function Reward:ctor(rewardName, locked, received, trophyCondition)
    self.rewardName_ = rewardName
    self.locked_ = locked
    self.received_ = received
    self.trophyCondition_ = trophyCondition
end

function Reward:setReward(rewardName, locked, received, trophyCondition)
    self.rewardName_ = rewardName
    self.locked_ = locked
    self.received_ = received
    self.trophyCondition_ = trophyCondition
end

function Reward:getRewardName()
    return self.rewardName_
end

function Reward:isLocked()
    return self.locked_
end

function Reward:isReceived()
    return self.received_
end

function Reward:gettrophyCondition()
    return self.trophyCondition_
end

return Reward
