--[[--
    Commodity.lua
    商城物品对象基类
    相当于一个接口，任何东西都可以拿来当商品，nice
]]
local Commodity = class("Commodity", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---Commodity.ctor 构造函数
---@param name      string 商品名
---@param type      string 商品类型
---@param price     number 商品价格
---@param priceUnit string 价格单位
---@param amount    number 该商品目前的数量
function Commodity:ctor(name, type, price, priceUnit, amount, commodity)
    self:setCommodity(name, type, price, priceUnit, amount, commodity)
    EventManager:doEvent(EventDef.ID.CREATE_COMMODITY, self)
end

function Commodity:setCommodity(commodityName, commodityType, commodityPrice, commodityPriceUnit, commodityAmount,
                                commodity)
    self.commodityName_ = commodityName
    self.commodityType_ = commodityType
    self.commodityPrice_ = commodityPrice
    self.commodityPriceUnit_ = commodityPriceUnit
    self.commodityAmount_ = commodityAmount
    self.commodityCommodity_ = commodity
end

function Commodity:getCommodityName()
    return self.commodityName_
end

function Commodity:getCommodityType()
    return self.commodityType_
end

function Commodity:getCommodityPrice()
    return self.commodityPrice_
end

function Commodity:getCommodityPriceUnit()
    return self.commodityPriceUnit_
end

function Commodity:getCommodityAmount()
    return self.commodityAmount_
end

--- 这个名字可能很傻逼 但是为了防止命名撞了不得已只能这样 QAQ
function Commodity:getCommodityCommodity()
    return self.commodityCommodity_
end

return Commodity
