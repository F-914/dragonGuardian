--[[--
    CardReward.lua
    钻石/金币奖励
]]
local CardReward = class("CardReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

function CardReward:ctor(cardType)
    self:setCardReward(cardType)
    EventManager:doEvent(EventDef.ID.CREATE_CARDREWARD, self)
end

function CardReward:setCardReward(cardType)
    self.cardType_ = cardType
end

function CardReward:getCardType()
    return self.cardType_
end

return CardReward
