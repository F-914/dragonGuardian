--[[--
    子弹节点
    InGameBulletSprite.lua
]]
local InGameBulletSprite = class("InGameBulletSprite", function(res)
    return display.newSprite(res)
end)


--[[--
    构造函数

    @param type 类型：number，图片资源序号
    @param data 类型：Bullet，子弹数据

    @return none
]]
function InGameBulletSprite:ctor(res, data)
    self.data_ = data -- 类型：Bullet，子弹数据

    self:setPosition(display.cx, display.cy)
    self:setAnchorPoint(0.5, 0.5)
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

