--[[--
    CardReward.lua
    钻石/金币奖励
]]
local CardReward = class("CardReward", require("app.data.pojo.Reward"))

-- local
local ConstDef = require("app.def.ConstDef")
--

function CardReward:ctor(cardType)
    self:setCardReward(cardType)
end

function CardReward:setCardReward(cardType)
    self.cardType_ = cardType
end

function CardReward:getCardType()
    return self.cardType_
end

return CardReward
