--[[--
    Enemy.lua
    敌人对象基类
]]
local Enemy = class("Enemy", require("app.data.base.BaseModel"))

-- local
local Log = require("app.utils.Log")
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")

local SPEED = 1
local X_LEFT = display.cx/6
local X_RIGHT = display.width * 17 / 20 - display.cx / 22 + display.cx/6
local Y_DOWN_PLAYER = display.cy/4
local Y_UP_PLAYER = display.cy * 14 / 20 + display.cy/4
--

---Enemy.ctor 构造函数
---@param name        string 敌人名
---@param type          number 敌人种类
---@param hp          number 敌人血量
---@param skills      table 敌人技能
---@param description string 敌人描述
---@return  Type Description

function Enemy:ctor(name, type, hp, skills, description)
    Enemy.super:ctor(display.cx/6, display.cy/4, ConstDef.ENEMY_PLANE_SIZE[type].WIDTH, ConstDef.ENEMY_PLANE_SIZE[type].HEIGHT)

    self.x_ = display.cx/6
    self.y_ = display.cy/4
    self.step_ = 1 --运动步骤（1-3）
    self:setEnemy(name, type, hp, skills, desc)
    EventManager:doEvent(EventDef.ID.CREATE_ENEMY, self)
end

function Enemy:setEnemy(name, type, hp, skills, desc)
    self.name_ = name
    self.type_ = type
    self.hp_ = hp
    self.skills_ = skills
    self.description_ = desc
end

function Enemy:getName()
    return self.name_
end

function Enemy:getHp()
    return self.hp_
end

function Enemy:getSkills()
    return self.skills_
end

function Enemy:getDescription()
    return self.description_
end

function Enemy:getMyX()
    return self.x_
end

function Enemy:getMyY()
    return self.y_
end

--[[--
    设置减少的血量

    @param none

    @return none
]]
function Enemy:setDeHp(hp)
    self.hp_ = self.hp_ - hp
end

--[[--
    销毁

    @param none

    @return none
]]
function Enemy:destory()
    --Log.i("destory")
    self.isDeath_ = true
    EventManager:doEvent(EventDef.ID.DESTORY_ENEMY, self)
end

--[[--
    帧循环

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function Enemy:update(dt)
    if not self.isDeath_ then
        if self.step_ == 1 then
            -- 左下到左上
            if self.y_ + SPEED < Y_UP_PLAYER then
                self.y_ = self.y_ + SPEED
            else
                self.y_ = Y_UP_PLAYER
                self.step_ = 2
            end
        elseif self.step_ == 2 then
            -- 左上到右上
            if self.x_ + SPEED < X_RIGHT then
                self.x_ = self.x_ + SPEED
            else
                self.x_ = X_RIGHT
                self.step_ = 3
            end
        elseif self.step_ == 3 then
            -- 右上到右下
            if self.y_ > Y_DOWN_PLAYER then
                self.y_ = self.y_ - SPEED
            else
                self:destory()
            end
        end
    end

    -- self.y_ = self.y_ - ConstDef.ENEMY_SPEED * dt

    -- if not self.isDeath_ then
    --     if self.y_ < display.bottom - ConstDef.ENEMY_PLANE_SIZE.HEIGHT then
    --         self:destory()
    --     end
    -- end
end

return Enemy
