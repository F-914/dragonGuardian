--[[--
    Reward.lua
    奖励对象基类
    这个也可以当作一个接口，任何东西都可以作为奖励，nice
]]
local Reward = class("Reward", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---Reward.ctor 构造函数
---这个应该具体写清楚具体有哪些名称和类型吧
---@param rewardName      string 奖励名称
---@param rewardType      number 奖励类型
---@param locked          boolean 是否被锁
---@param received        boolean 是否被领取
---@param trophyCondition number 解锁需要的奖杯数量
---@param amount          number 奖励的数量
function Reward:ctor(rewardName, rewardType, location, locked, received, trophyCondition, amount, reward)
    self:setReward(rewardName, rewardType, location, locked, received, trophyCondition, amount, reward)
    EventManager:doEvent(EventDef.ID.CREATE_REWARD, self)
end

function Reward:setReward(rewardName, rewardType, location, locked, received, trophyCondition, amount, reward)
    self.rewardName_ = rewardName
    self.rewardType_ = rewardType
    self.rewardLocation_ = location
    self.locked_ = locked
    self.received_ = received
    self.trophyCondition_ = trophyCondition
    self.rewardAmount_ = amount
    self.reward_ = reward
end

function Reward:getRewardName()
    return self.rewardName_
end

function Reward:isLocked()
    return self.locked_
end

function Reward:setLocked(val)
    self.locked_ = val
end

function Reward:isReceived()
    return self.received_
end

function Reward:setReceived(val)
    self.received_ = val
end

function Reward:getTrophyCondition()
    return self.trophyCondition_
end

return Reward
