--[[--
    Bullet.lua
    子弹数据文件
]]
local Bullet = class("Bullet", require("app.data.Object"))
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")

--[[--
    构造函数

    @param none

    @return none
]]
function Bullet:ctor()
    Bullet.super.ctor(self, 0, 0, ConstDef.BULLET_SIZE.WIDTH, ConstDef.BULLET_SIZE.HEIGHT)

    EventManager:doEvent(EventDef.ID.CREATE_BULLET, self)
end

--[[--
    子弹命中爆炸

    @param none

    @return none
]]
function Bullet:bomb()
    EventManager:doEvent(EventDef.ID.BULLET_BOMB, self)
end

--[[--
    子弹销毁

    @param none

    @return none
]]
function Bullet:destory()
    self.isDeath_ = true 
    EventManager:doEvent(EventDef.ID.DESTORY_BULLET, self)
end

--[[--
    子弹帧刷新

    @param dt 类型：number，时间，秒

    @return none
]]
function Bullet:update(dt)
    self.y_ = self.y_ + ConstDef.BULLET_SPEED * dt

    if not self.isDeath_ then
        if self.y_ > display.top + ConstDef.BULLET_SIZE.HEIGHT then
            self:destory()
        end
    end
end

return Bullet