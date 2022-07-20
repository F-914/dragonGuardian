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
function Bullet:ctor(camp, type, x, y, damage, star)
    Bullet.super:ctor(x, y, ConstDef.BULLET_SIZE.WIDTH, ConstDef.BULLET_SIZE.HEIGHT)
    self.camp_ = camp
    self.x_ = x
    self.y_ = y
    self.xCos_ = 0  --默认子弹向正上方发射
    self.ySin_ = 1
    self.speed_ = 300
    if damage ~= nil then
        self.damage_ = damage
    else
        self.damage_ = 50
    end
    if star ~= nil then
        self.damage_ = self.damage_ + (star - 1) * 10
    end
    EventManager:doEvent(EventDef.ID.CREATE_BULLET, self, type)
end

function Bullet:getDamage()
    return self.damage_
end

function Bullet:setDamage(damage)
    self.damage_ = damage
end

function Bullet:getMyX()
    return self.x_
end

function Bullet:getMyY()
    return self.y_
end

function Bullet:setSpeed(speed)
    self.speed_ = speed
end

--[[--
    设置发射方向

    @param num, num :目标方向对应xy比例

    @return none
]]
function Bullet:setDirection(xCos, ySin)
    self.xCos_ = xCos
    self.ySin_ = ySin
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
    if self.xCos_ == nil or self.ySin_ == nil then
        return
    end

    self.x_ = self.x_ + self.xCos_ * self.speed_ * dt
    self.y_ = self.y_ + self.ySin_ * self.speed_ * dt

    --子弹显示范围
    if not self.isDeath_ then
        if self.camp_ == 1 then
            if self.y_ > display.cy or self.y_ < display.cy/5 then
                self:destory()
            elseif self.x_ < display.cx/8 or self.x_ > display.cx*15/8 then
                self:destory()
            end
        else
            if self.y_ > display.height*24/25 or self.y_ < display.cy*15/13 then
                self:destory()
            elseif self.x_ < display.cx/8 or self.x_ > display.cx*15/8 then
                self:destory()
            end
        end
    end
end

return Bullet