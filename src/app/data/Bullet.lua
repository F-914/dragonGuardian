--[[--
    Bullet.lua
    子弹数据文件
]]
local Bullet = class("Bullet", require("app.data.base.BaseModel"))
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")

--[[--
    构造函数

    @param none

    @return none
]]
function Bullet:ctor(type, skills)
    self.x_ = 0
    self.y_ = 0
    EventManager:doEvent(EventDef.ID.CREATE_BULLET, self, type)
end

function Bullet:getMyX()
    return self.x_
end

function Bullet:getMyY()
    return self.y_
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
    self.y_ = self.y_ + 100 * dt

    -- if not self.isDeath_ then
    --     if self.y_ > display.height then
    --         self:destory()
    --     end
    -- end
end

return Bullet