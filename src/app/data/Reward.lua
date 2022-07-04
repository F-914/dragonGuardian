--[[--
    Reward.lua
    奖励/宝箱对象基类
]]
local Reward = class("Reward", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---Reward.ctor 构造函数
---@param rewardName      string 奖励名称
---@param locked          boolean 是否被锁
---@param received        boolean 是否被领取
---@param trophyCondition number 解锁需要的奖杯数量
---@param amount          number 奖励的数量
---@return  Type Description
function Reward:ctor(rewardName, locked, received, trophyCondition, amount)
    self:setReward(rewardName, locked, received, trophyCondition, amount)
    EventManager:doEvent(EventDef.ID.CREATE_REWARD, self)
end

function Reward:setReward(rewardName, locked, received, trophyCondition, amount)
    self.rewardName_ = rewardName
    self.locked_ = locked
    self.received_ = received
    self.trophyCondition_ = trophyCondition
    self.amount_ = amount
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

function Reward:gettrophyCondition()
    return self.trophyCondition_
end

return Reward
