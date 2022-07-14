--[[--
	InGameEnemySprite.lua
	游戏内塔按键
]]
local InGameEnemySprite = class("InGameEnemySprite", function(res)
	return display.newSprite()
end)

--local
local Log = require("app.utils.Log")

function InGameEnemySprite:ctor(type, data)	--type=1:小型敌人，type=2:大型敌人
	self.data_ = data
	self.type_ = type

	if self.type_ == 1 then
		--Log.i("create enemy 1")
		self:littleEnemy()
	elseif self.type_ == 2 then
		Log.i("create enemy 2")
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
	self.enemySprite_ = cc.Sprite:create("battle_in_game/battle_view/little_enemy.png")
	self.enemySprite_:setAnchorPoint(0.5, 0.5)
	self.enemySprite_:setPosition(0, 0)
	local sizeEnemySprite = self.enemySprite_:getContentSize()
	self.enemySprite_:addTo(self)

	-- 血量
	self.enemyLifeTTF_ = display.newTTFLabel({
        text = self.data_:getHp(),
        font = "font/fzbiaozjw.ttf",
        size = 20
    })
    self.enemyLifeTTF_:align(display.CENTER, self.enemySprite_:getPositionX(), self.enemySprite_:getPositionY() - sizeEnemySprite.height/3)
    self.enemyLifeTTF_:setColor(cc.c3b(255,255,255))
	self.enemyLifeTTF_:enableOutline(cc.c4b(0,0,0,255), 1)
    self.enemyLifeTTF_:addTo(self)
end

--[[--
	描述：创建大型敌人
]]
function InGameEnemySprite:entireEnemy()
	--小型敌人
	self.enemySprite_ = cc.Sprite:create("battle_in_game/battle_view/elite_enemy.png")
	self.enemySprite_:setAnchorPoint(0.5, 0.5)
	self.enemySprite_:setPosition(0, 0)
	local sizeEnemySprite = self.enemySprite_:getContentSize()
	self.enemySprite_:addTo(self)

	-- 血量
	self.enemyLifeTTF_ = display.newTTFLabel({
        text = "500",
        font = "font/fzbiaozjw.ttf",
        size = 20
    })
    self.enemyLifeTTF_:align(display.CENTER, self.enemySprite_:getPositionX(), self.enemySprite_:getPositionY() - sizeEnemySprite.height/3)
    self.enemyLifeTTF_:setColor(cc.c3b(255,255,255))
	self.enemyLifeTTF_:enableOutline(cc.c4b(0,0,0,255), 1)
    self.enemyLifeTTF_:addTo(self)
end

--[[--
    帧刷新

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function InGameEnemySprite:update(dt)
	self.enemyLifeTTF_:setString(self.data_:getHp())
    self:setPosition(self.data_:getMyX(), self.data_:getMyY())
end

return InGameEnemySprite