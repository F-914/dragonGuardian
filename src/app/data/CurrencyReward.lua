--[[--
    CurrencyReward.lua
    钻石/金币奖励
]]
local CurrencyReward = class("CurrencyReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---CurrencyReward.ctor 构造函数
---@param rewardName      string 奖励名称
---@param locked          boolean 是否被锁
---@param received        boolean 是否被领取
---@param trophyCondition number 解锁需要的奖杯数量
---@param rewardType      string 奖励的类型，钻石或者金币
---@return  Type Description
function CurrencyReward:ctor(rewardType)
    self:setCurrencyReward(rewardType)
    EventManager:doEvent(EventDef.ID.CREATE_CURRENCYREWARD, self)
end

function CurrencyReward:setCurrencyReward(rewardType)
    self.rewardType_ = rewardType
end

function CurrencyReward:getRewardType()
    return self.rewardType_
end

function CurrencyReward:getRewardAmount()
    return self.rewardAmount_
end

return CurrencyReward
