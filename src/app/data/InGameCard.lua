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

                        --1, cx, cy, xLocate, yLocate, id, level
function InGameCard:ctor(camp, x, y, xLocate, yLocate, cardId, star, level)
    self:init(camp, x, y, xLocate, yLocate, cardId, star, level)
    if camp == 1 then
        EventManager:doEvent(EventDef.ID.CREATE_CARD, self, cardId)
    elseif camp == 2 then
        EventManager:doEvent(EventDef.ID.CREATE_ENEMY_CARD, self, cardId)
    end
end

function InGameCard:init(camp, x, y, xLocate, yLocate, cardId, star, level)
    self.camp_ = camp
    self.x_ = x
    self.y_ = y
    self.xLocate_ = xLocate
    self.yLocate_ = yLocate
    self.cardId_ = cardId
    self.star_ = star
    if level ~= nil then
        self.level_ = level
    else
        self.level_ = 1
    end
end

--[[--
    销毁

    @param none

    @return none
]]
function InGameCard:destory()
    --Log.i("destory")
    self.isDeath_ = true
    EventManager:doEvent(EventDef.ID.DESTORY_CARD, self)
end

---设置塔等级
function InGameCard:setCardLevel(level)
    self.level_ = level
end

---设置塔星级
function InGameCard:setCardLStar(star)
    self.star_ = star
end

--- 塔表格位置
function InGameCard:getXLocate()
    return self.xLocate_
end

function InGameCard:getYLocate()
    return self.yLocate_
end

function InGameCard:getCardLevel()
    return self.level_
end

function InGameCard:getCardStar()
    return self.star_
end


return InGameCard
