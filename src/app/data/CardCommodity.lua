--[[--
    CardCommodity.lua
    卡牌商品
]]
local CardCommodity = class("CardCommodity", require("app.data.Commodity"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---CardCommodity.ctor 构造函数
---@param cardName string 卡牌上的龙的类型，应该就是那二十种中的某一个
---@return  none
function CardCommodity:ctor(cardName)
    self:setCardCommodity(cardName)
end

function CardCommodity:setCardCommodity(cardName)
    self.cardName_ = cardName
end

return CardCommodity
