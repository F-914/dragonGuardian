--[[--
    CurrencyCommodity.lua
    货币商品
]]
local CurrencyCommodity = class("CurrencyCommodity", require("app.data.Commodity"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---CurrencyCommodity.ctor 构造函数
---@param currencyType string 货币类型
---@return  Type Description
function CurrencyCommodity:ctor(currencyType)
    self:setCurrencyCommodity(currencyType)
    EventManager:doEvent(EventDef.ID.CREATE_CURRENCYCOMMODITY, self)
end

function CurrencyCommodity:setCurrencyCommodity(currencyType)
    self.currencyType_ = currencyType
end

return CurrencyCommodity
