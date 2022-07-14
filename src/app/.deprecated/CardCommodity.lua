--[[--
    CardCommodity.lua
    卡牌商品
]]
local CardCommodity = class("CardCommodity", require("app.data.Commodity"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---CardCommodity.ctor 构造函数
---@param cardName string 卡牌上的龙的类型，应该就是那二十种中的某一个
---@return  none
function CardCommodity:ctor(cardName)
    self:setCardCommodity(cardName)
    EventManager:doEvent(EventDef.ID.CREATE_CARDCOMMODITY, self)
end

function CardCommodity:setCardCommodity(cardName)
    self.cardName_ = cardName
end

return CardCommodity
