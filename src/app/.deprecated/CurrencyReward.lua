--[[--
    CurrencyReward.lua
    钻石/金币奖励
]]
local CurrencyReward = class("CurrencyReward", require("app.data.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---CurrencyReward.ctor 构造函数
---@param currencyType stirng 货币类型
---@return  Type Description
function CurrencyReward:ctor(currencyType)
    self:setCurrencyReward(currencyType)
    EventManager:doEvent(EventDef.ID.CREATE_CURRENCYREWARD, self)
end

function CurrencyReward:setCurrencyReward(currencyType)
    self.currencyType_ = currencyType
end

function CurrencyReward:getCurrencyType()
    return self.currencyType_
end

return CurrencyReward
