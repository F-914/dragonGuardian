--[[--
    子弹节点
    InGameBulletSprite.lua
]]
local InGameBulletSprite = class("InGameBulletSprite", function(res)
    return display.newSprite(res)
end)

--local
local bulletSprite_
--

--[[--
    构造函数

    @param type 类型：number，图片资源序号
    @param data 类型：Bullet，子弹数据

    @return none
]]
function InGameBulletSprite:ctor(type, data)
    self.data_ = data -- 类型：Bullet，子弹数据
    print("type", type)
    self:init(type)
    --self:setPosition(self.data_:getMyX(), self.data_:getMyY())
end

function InGameBulletSprite:init(type)
    bulletSprite_ = cc.Sprite:create("battle_in_game/battle_view/bullet/"..type..".png")
    bulletSprite_:setPosition(display.cx, display.cy)
    bulletSprite_:setAnchorPoint(0.5, 0.5)
    bulletSprite_:addTo(self)
end



--[[--
    帧刷新

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function InGameBulletSprite:update(dt)
    self:setPosition(self.data_:getMyX(), self.data_:getMyY())
end

return InGameBulletSprite

