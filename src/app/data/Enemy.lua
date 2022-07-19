--[[--
    Enemy.lua
    敌人对象基类

    小怪有三类：1、普通小怪 2、精英怪（血厚） 3、加速怪（速度翻倍血量减半）
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
local Y_UP_PLAYER = display.cy * 19 / 20
local Y_DOWN_ENEMY = display.cy*16/13
local Y_UP_ENEMY = display.cy*16/13 + display.cy * 14/20
--

---Enemy.ctor 构造函数
---@param camp          number 阵营，我方/敌方
---@param name        string 敌人名
---@param type          number 敌人种类
---@param hp          number 敌人血量
---@param skills      table 敌人技能
---@param description string 敌人描述
---@return  Type Description

function Enemy:ctor(camp, name, type, hp, skills, description)
    self.camp_ = camp
    --skills和description还没用上，之后要区分三类怪
    if self.camp_ == 1 then
        self.x_ = X_LEFT
        self.y_ = Y_DOWN_PLAYER
        Enemy.super:ctor(X_LEFT, Y_DOWN_PLAYER, ConstDef.ENEMY_SIZE[type].WIDTH, ConstDef.ENEMY_SIZE[type].HEIGHT)
    elseif self.camp_ == 2 then
        self.x_ = X_LEFT
        self.y_ = Y_UP_ENEMY
        Enemy.super:ctor(X_LEFT, Y_UP_ENEMY, ConstDef.ENEMY_SIZE[type].WIDTH, ConstDef.ENEMY_SIZE[type].HEIGHT)
    end
    self.stepPlayer_ = 1 --运动步骤（1-3）
    self.stepEnemy_ = 1 --运动步骤（1-3）
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

function Enemy:getCamp()
    return self.camp_
end

function Enemy:getType()
    return self.type_
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
    我方敌人运动路径
]]
function Enemy:routePlayer()
    if not self.isDeath_ then
        if self.stepPlayer_ == 1 then
            -- 左下到左上
            if self.y_ + SPEED < Y_UP_PLAYER then
                self.y_ = self.y_ + SPEED
            else
                self.y_ = Y_UP_PLAYER
                self.stepPlayer_ = 2
            end
        elseif self.stepPlayer_ == 2 then
            -- 左上到右上
            if self.x_ + SPEED < X_RIGHT then
                self.x_ = self.x_ + SPEED
            else
                self.x_ = X_RIGHT
                self.stepPlayer_ = 3
            end
        elseif self.stepPlayer_ == 3 then
            -- 右上到右下
            if self.y_ > Y_DOWN_PLAYER then
                self.y_ = self.y_ - SPEED
            else
                print("到头了")
                EventManager:doEvent(EventDef.ID.HURT_PLAYER, self.type_)
                self:destory()
            end
        end
    end
end

--[[--
    敌方敌人运动路径
]]
function Enemy:routeEnemy()
    if not self.isDeath_ then
        if self.stepEnemy_ == 1 then
            -- 左上到左下
            if self.y_ - SPEED > Y_DOWN_ENEMY then
                self.y_ = self.y_ - SPEED
            else
                self.y_ = Y_DOWN_ENEMY
                self.stepEnemy_ = 2
            end
        elseif self.stepEnemy_ == 2 then
            -- 左下到右下
            if self.x_ + SPEED < X_RIGHT then
                self.x_ = self.x_ + SPEED
            else
                self.x_ = X_RIGHT
                self.stepEnemy_ = 3
            end
        elseif self.stepEnemy_ == 3 then
            -- 右下到右上
            if self.y_ < Y_UP_ENEMY then
                self.y_ = self.y_ + SPEED
            else
                print("到头了")
                EventManager:doEvent(EventDef.ID.HURT_ENEMY, self.type_)
                self:destory()
            end
        end
    end
end

--[[--
    帧循环

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function Enemy:update(dt)
    if self.camp_ == 1 then
        self:routePlayer()
    elseif self.camp_ == 2 then
        self:routeEnemy()
    end
    -- self.y_ = self.y_ - ConstDef.ENEMY_SPEED * dt

    -- if not self.isDeath_ then
    --     if self.y_ < display.bottom - ConstDef.ENEMY_PLANE_SIZE.HEIGHT then
    --         self:destory()
    --     end
    -- end
end

return Enemy
