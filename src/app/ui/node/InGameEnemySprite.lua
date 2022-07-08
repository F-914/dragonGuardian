--[[--
	InGameEnemySprite.lua
	游戏内塔按键
]]
local InGameEnemySprite = class("InGameEnemySprite", function(res)
	return display.newSprite()
end)

--local
local Log = require("app.utils.Log")
local enemySprite_
local enemyLifeTTF_

function InGameEnemySprite:ctor(type)	--type=1:小型敌人，type=2:大型敌人
	if type == 1 then
		self:littleEnemy()
	elseif type == 2 then
		self:entireEnemy()
	else
		Log.w("The parameter range is 1(little enemy) or 2(entire enemy)")
	end
end

--[[--
	描述：创建小型敌人
]]
function InGameEnemySprite:littleEnemy()
	--小型敌人
	enemySprite_ = cc.Sprite:create("battle_in_game/battle_view/little_enemy.png")
	enemySprite_:setAnchorPoint(0.5, 0.5)
	enemySprite_:setPosition(display.cx/6, display.cy/4)
	local sizeEnemySprite = enemySprite_:getContentSize()
	enemySprite_:addTo(self)

	-- 血量
	enemyLifeTTF_ = display.newTTFLabel({
        text = "500",
        font = "font/fzbiaozjw.ttf",
        size = 20
    })
    enemyLifeTTF_:align(display.CENTER, enemySprite_:getPositionX(), enemySprite_:getPositionY() - sizeEnemySprite.height/3)
    enemyLifeTTF_:setColor(cc.c3b(255,255,255))
	enemyLifeTTF_:enableOutline(cc.c4b(0,0,0,255), 1)
    enemyLifeTTF_:addTo(self)
end

--[[--
	描述：创建大型敌人
]]
function InGameEnemySprite:entireEnemy()
	--小型敌人
	enemySprite_ = cc.Sprite:create("battle_in_game/battle_view/elite_enemy.png")
	enemySprite_:setAnchorPoint(0.5, 0.5)
	enemySprite_:setPosition(display.cx/6, display.cy/4)
	local sizeEnemySprite = enemySprite_:getContentSize()
	enemySprite_:addTo(self)

	-- 血量
	enemyLifeTTF_ = display.newTTFLabel({
        text = "500",
        font = "font/fzbiaozjw.ttf",
        size = 20
    })
    enemyLifeTTF_:align(display.CENTER, enemySprite_:getPositionX(), enemySprite_:getPositionY() - sizeEnemySprite.height/3)
    enemyLifeTTF_:setColor(cc.c3b(255,255,255))
	enemyLifeTTF_:enableOutline(cc.c4b(0,0,0,255), 1)
    enemyLifeTTF_:addTo(self)
end

return InGameEnemySprite