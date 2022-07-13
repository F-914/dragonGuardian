--[[--
    InGameCard.lua
    游戏内防御塔对象
    继承自Card 拥有Card的所有属性
    使用时一定要注意不能修改原有的Card，而是深拷贝或者新建一个Card对象
    可以在这里添加更多的函数
]]
local InGameCard = class("InGameCard", require("app.data.Card"))
-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--
--
function InGameCard:ctor(inGameCardId, cardStar)
    self:setInGameCard(inGameCardId, cardStar)
    EventManager:doEvent(EventDef.ID.CREATE_IN_GAME_CARD, self)
end

function InGameCard:setInGameCard(inGameCardId, cardStar)
    self.inGameCardId_ = inGameCardId
    self.cardStar_ = cardStar
end

function InGameCard:getInGameCardId()
    return self.inGameCardId_
end

function InGameCard:setInGameCard(inGameCardId)
    self.inGameCardId_ = inGameCardId
end

function InGameCard:getCardStar()
    return self.cardStar_
end

function InGameCard:setCardStar(cardStar)
    self.cardStar_ = cardStar
end

return InGameCard
