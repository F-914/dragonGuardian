--[[--
    Commodity.lua
    商城物品对象基类
]]
local Commodity = class("Commodity", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---Commodity.ctor 构造函数
---@param name      string 商品名
---@param price     number 商品价格
---@param priceUnit string 价格单位
---@param amount    number 该商品目前的数量
---@return  Type Description
function Commodity:ctor(name, price, priceUnit, amount)
    self:setCommodity(name, price, priceUnit, amount)
end

function Commodity:setCommodity(name, price, priceUnit, amount)
    self.name_ = name
    self.price_ = price
    self.priceUnit_ = priceUnit
    self.amount_ = amount
end

function Commodity:getCommodityName()
    return self.name_
end

function Commodity:getPirce()
    return self.price_
end

function Commodity:getPriceUnit()
    return self.priceUnit_
end

function Commodity:getAmount()
    return self.amount_
end

return Commodity
