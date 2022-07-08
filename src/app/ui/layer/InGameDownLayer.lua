--[[--
    游戏内第二层，包括底部背景及敌人和方格内塔
    InGameDownLayer.lua
]]
local InGameDownLayer = class("InGameDownLayer", function()
    return display.newLayer()
end)

--local
local InGameEnemySprite = require("app.ui.node.InGameEnemySprite")
local X_LEFT = 0
local X_RIGHT = display.width*17/20 - display.cx/22
local Y_DOWN_PLAYER = 0
local Y_UP_PLAYER = display.cy*14/20
local schedule = cc.Director:getInstance():getScheduler()	--路径
local timeCreateEnemySchdule = nil  -- 敌人生成计时器
local littleEnemyNum = 5    -- 每五只小怪一只精英怪
--

function InGameDownLayer:ctor()
    self:setContentSize(display.width, display.height)
    self:init()
end

function InGameDownLayer:init()
    local basemapDown = cc.Sprite:create("battle_in_game/battle_view/basemap_down.png")
    basemapDown:setAnchorPoint(0.5, 0.5)
    basemapDown:setPosition(display.cx, display.cy)
    basemapDown:addTo(self)

    self:createEnemy()
end

--[[--
    描述：计时器连续生成敌人
]]
function InGameDownLayer:createEnemy()
    -- 连续生成敌人
    local num = 0
    timeCreateEnemySchdule = schedule:scheduleScriptFunc(function (dt)
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
	end, 0.05, false)
end

return InGameDownLayer