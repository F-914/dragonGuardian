--[[--
    CurrencyCommodity.lua
    货币商品
]]
local CurrencyCommodity = class("CurrencyCommodity", require("app.data.Commodity"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---CurrencyCommodity.ctor 构造函数
---@param currencyType string 货币类型
---@return  Type Description
function CurrencyCommodity:ctor(currencyType)
    self:setCurrencyCommodity(currencyType)
end

function CurrencyCommodity:setCurrencyCommodity(currencyType)
    self.currencyType_ = currencyType
end

return CurrencyCommodity
