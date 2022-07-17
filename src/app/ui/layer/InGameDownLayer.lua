--[[--
    游戏内第二层，包括底部背景及敌人和方格内塔
    InGameDownLayer.lua
]]
local InGameDownLayer = class("InGameDownLayer", function()
    return display.newLayer()
end)

--local
local Log = require("app.utils.Log")
local ConstDef = require("app.def.ConstDef")
local InGameData = require("app.data.InGameData")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local InGameUpLayer = require("app.ui.layer.InGameUpLayer")
local InGameEnemySprite = require("app.ui.node.InGameEnemySprite")
local InGameTowerButton = require("app.ui.node.InGameTowerButton")
local InGameBulletSprite = require("app.ui.node.InGameBulletSprite")
--

function InGameDownLayer:ctor()
    self.bulletMap_ = {} -- 类型：table，Key：bullet， Value：bulletSprite 子弹
    self.enemyMap_ = {}
    self.cardMap_ = {}  --存放生成的塔

    self:setContentSize(display.width, display.height)
    self:init()
    self:onEnter()
end

--[[--
    节点进入

    @param none

    @return none
]]
function InGameDownLayer:onEnter()
    --cardId是卡牌编号
    EventManager:regListener(EventDef.ID.CREATE_CARD, self, function(card, cardId)
        --card是InGameData中的Card数据（参考下方init中参数来源），用于传递统一管理的数据
        local tower = InGameTowerButton.new(1,card,cardId)     -- 1指的是在我方生成
        self:addChild(tower, 3)
        self.cardMap_[card] = tower
        InGameData:shoot(1, tower:getCardId(1), tower:getPositionX(), tower:getPositionY(), card:getCardLevel())
    end)

    EventManager:regListener(EventDef.ID.CREATE_ENEMY_CARD, self, function(card, cardId)
        local tower = InGameTowerButton.new(2,card,cardId)     -- 2指的是在敌方生成
        self:addChild(tower, 3)
        self.cardMap_[card] = tower
        InGameData:shoot(2, tower:getCardId(2), tower:getPositionX(), tower:getPositionY(), card:getCardLevel())
    end)

    EventManager:regListener(EventDef.ID.DESTORY_CARD, self, function(card)
        local node = self.cardMap_[card]
        node:removeFromParent()
        self.cardMap_[card] = nil
    end)

    EventManager:regListener(EventDef.ID.CREATE_BULLET, self, function(bullet, type, x, y)
        --print(vardump(bullet))  --查看bullet内容(bullet存放Bullet类名以及它的函数)
        local bulletNode = InGameBulletSprite.new("battle_in_game/battle_view/bullet/"..type..".png", bullet)
        self:addChild(bulletNode)
        self.bulletMap_[bullet] = bulletNode
    end)

    EventManager:regListener(EventDef.ID.DESTORY_BULLET, self, function(bullet)
        local node = self.bulletMap_[bullet]
        node:removeFromParent()
        self.bulletMap_[bullet] = nil
    end)

    EventManager:regListener(EventDef.ID.CREATE_ENEMY, self, function(enemy)
        --在Enemy.lua构造时调用，Enemy在InGameData中创造并利用计时器如update调用
        --（敌人生成自定义计时器在scene调用）
        --修改：可变换的敌人类型(用数字table存储种类顺序？)
        --enemy是InGameData中的数据（参考下方init中参数来源），用于传递统一管理的数据
        local enemyNode = InGameEnemySprite.new(1, enemy)
        self:addChild(enemyNode)
        self.enemyMap_[enemy] = enemyNode
    end)

    EventManager:regListener(EventDef.ID.DESTORY_ENEMY, self, function(enemy)
        local node = self.enemyMap_[enemy]
        node:removeFromParent()
        self.enemyMap_[enemy] = nil
        InGameUpLayer:refreshSp()
    end)

    EventManager:regListener(EventDef.ID.CARD_MERGE, self, function(card)
        local node = self.cardMap_[card]
        node:removeFromParent()
    end)

    EventManager:regListener(EventDef.ID.HIT_ENEMY, self, function(enemy, damage)
        local node = self.enemyMap_[enemy]
        node:hitEnemyTips(damage)
        
    end)

end

--[[--
    节点退出

    @param none

    @return none
]]
function InGameDownLayer:onExit()
    EventManager:unRegListener(EventDef.ID.CREATE_CARD, self)
    EventManager:unRegListener(EventDef.ID.DESTORY_CARD, self)
    EventManager:unRegListener(EventDef.ID.CREATE_BULLET, self)
    EventManager:unRegListener(EventDef.ID.DESTORY_BULLET, self)
    EventManager:unRegListener(EventDef.ID.CREATE_ENEMY, self)
    EventManager:unRegListener(EventDef.ID.DESTORY_ENEMY, self)
    EventManager:unRegListener(EventDef.ID.CARD_MERGE, self)
    EventManager:unRegListener(EventDef.ID.HIT_ENEMY, self)
end


function InGameDownLayer:init()
    local basemapDown = cc.Sprite:create("battle_in_game/battle_view/basemap_down.png")
    basemapDown:setAnchorPoint(0.5, 0.5)
    basemapDown:setPosition(display.cx, display.cy)
    basemapDown:addTo(self)

    local enemies = InGameData:getEnemies()
    for i = 1, #enemies do
        local enemy = InGameEnemySprite.new(1, enemies[i])
        self:addChild(enemy)
        self.enemyMap_[enemies[i]] = enemy
    end
end

--[[--
    帧刷新

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function InGameDownLayer:update(dt)
    for _, node in pairs(self.enemyMap_) do
        node:update(dt)
    end
    for _, node in pairs(self.bulletMap_) do
        node:update(dt)
    end
end

return InGameDownLayer