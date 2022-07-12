--[[--
    游戏内第二层，包括底部背景及敌人和方格内塔
    InGameDownLayer.lua
]]
local InGameDownLayer = class("InGameDownLayer", function()
    return display.newLayer()
end)

--local
local ConstDef = require("app.def.ConstDef")
local InGameData = require("app.data.InGameData")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local InGameEnemySprite = require("app.ui.node.InGameEnemySprite")
local X_LEFT = 0
local X_RIGHT = display.width*17/20 - display.cx/22
local Y_DOWN_PLAYER = 0
local Y_UP_PLAYER = display.cy*14/20
local schedule = cc.Director:getInstance():getScheduler()	--计时器路径
local timeCreateEnemySchdule = nil  -- 敌人生成计时器
local littleEnemyNum = 5    -- 每五只小怪一只精英怪
--

function InGameDownLayer:ctor()
    --self.bulletMap_ = {} -- 类型：table，Key：bullet， Value：bulletSprite 子弹
    self.enemyMap_ = {}

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
    EventManager:regListener(EventDef.ID.CREATE_ENEMY, self, function(enemy)
        --修改：可变换的敌人类型
        local enemyNode = InGameEnemySprite.new(1, enemy)
        self:addChild(enemyNode)
        self.enemyMap_[enemy] = enemyNode
    end)

    EventManager:regListener(EventDef.ID.DESTORY_ENEMY, self, function(enemy)
        local node = self.enemyMap_[enemy]
        node:removeFromParent()
        self.enemyMap_[enemy] = nil
    end)

end

--[[--
    节点退出

    @param none

    @return none
]]
function InGameDownLayer:onExit()
    EventManager:unRegListener(EventDef.ID.CREATE_ENEMY, self)
    EventManager:unRegListener(EventDef.ID.DESTORY_ENEMY, self)
end


function InGameDownLayer:init()
    local basemapDown = cc.Sprite:create("battle_in_game/battle_view/basemap_down.png")
    basemapDown:setAnchorPoint(0.5, 0.5)
    basemapDown:setPosition(display.cx, display.cy)
    basemapDown:addTo(self)
    --self:createEnemy()

    local enemies = InGameData:getEnemies()
    for i = 1, #enemies do
        local enemy = InGameEnemySprite.new(1, enemies[i])
        self:addChild(enemy)
        self.enemyMap_[enemies[i]] = enemy
    end
end

--[[--
    描述：计时器连续生成敌人
]]
function InGameDownLayer:createEnemy()
    -- 连续生成敌人
    local num = 0
    timeCreateEnemySchdule = schedule:scheduleScriptFunc(function (dt)
        if InGameData:getGameState() == ConstDef.GAME_STATE.PLAY then
            if num < littleEnemyNum then
                num = num + 1
                local enemy = InGameEnemySprite.new(1)
                self:addChild(enemy)
                self:enemyMovePlayer(enemy)
            elseif num == littleEnemyNum then
                num = 0
                local enemy = InGameEnemySprite.new(2)
                self:addChild(enemy)
                self:enemyMovePlayer(enemy)
            end
        end
    end, 0.5, false)
end

--[[--
    描述：停止敌人生成计时器
]]
function InGameDownLayer:stopCreateEnemy()
    schedule:unscheduleScriptEntry(timeCreateEnemySchdule)
end

--[[--
	描述：敌人运动路径(我方)
]]
function InGameDownLayer:enemyMovePlayer(enemy)
	local timeSchedule = nil
	local step = 1	--运动步骤（1-3）
    local curX, curY    --敌人当前位置
    local deltaX = 10
    local deltaY = 10

	timeSchedule = schedule:scheduleScriptFunc(function (dt)
        if InGameData:getGameState() == ConstDef.GAME_STATE.PLAY then
            curX = enemy:getPositionX()
            curY = enemy:getPositionY()

            if step == 1 then
                -- 左下到左上
                if curY + deltaY < Y_UP_PLAYER then
                    enemy:setPosition(curX, curY + deltaY)
                else
                    enemy:setPosition(curX, Y_UP_PLAYER)
                    step = 2
                end
            elseif step == 2 then
                -- 左上到右上
                if curX + deltaX < X_RIGHT then
                    enemy:setPosition(curX + deltaX, curY)
                else
                    enemy:setPosition(X_RIGHT, curY)
                    step = 3
                end
            elseif step == 3 then
                -- 右上到右下
                if curY > Y_DOWN_PLAYER then
                    enemy:setPosition(curX, curY - deltaY)
                else
                    schedule:unscheduleScriptEntry(timeSchedule)
                    enemy:removeFromParent()
                end
            end
		end
	end, 0.05, false)
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
end

return InGameDownLayer