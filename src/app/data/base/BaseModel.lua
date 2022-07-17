--[[--
    BaseModel.lua
    数据对象基类
]]
local BaseModel = class("BaseModel")
local rect1_ = cc.rect(0, 0, 0, 0)
local rect2_ = cc.rect(0, 0, 0, 0)

---构造函数
---@param x number
---@param y number
---@param width number
---@param height number
---@param isDeath boolean
function BaseModel:ctor(x, y, width, height, isDeath)
    self:setBaseModel(x, y, width, height, isDeath)
    self.id_ = ""
end

function BaseModel:setBaseModel(x, y, width, height, isDeath)
    self.x_ = x -- 类型：number
    self.y_ = y -- 类型：number
    self.width_ = width -- 类型：number
    self.height_ = height -- 类型：number
    self.isDeath_ = isDeath -- 类型：boolean，是否死亡（销毁）
end

function BaseModel:setId(id)
    self.id_ = id
end

function BaseModel:setMyX(x)
    self.x_ = x
end

function BaseModel:setMyY(y)
    self.y_ = y
end

function BaseModel:getId()
    return self.id_
end

---直接用 getX 的话可以会覆盖一些自带的函数 可能会在后续导致一些问题
---@return number
function BaseModel:getMyX()
    return self.x_
end

---comment
---@return number
function BaseModel:getMyY()
    return self.y_
end

---comment
---@return number
function BaseModel:getMyWidth()
    return self.width_
end

---comment
---@return number
function BaseModel:getMyHeight()
    return self.height_
end

---comment
---@return boolean
function BaseModel:isDeath()
    return self.isDeath_
end

---update
---@param dt any
function BaseModel:update(dt)
    -- body
end

--[[--
    碰撞判定

    @param obj 类型：Object，待判定对象

    @return boolean
]]
function BaseModel:isCollider(obj)
    rect1_.x = self.x_ - self.width_ * 0.5
    rect1_.y = self.y_ - self.height_ * 0.5
    rect1_.width = self.width_
    rect1_.height = self.height_

    rect2_.x = obj.x_ - obj.width_ * 0.5
    rect2_.y = obj.y_ - obj.height_ * 0.5
    rect2_.width = obj.width_
    rect2_.height = obj.height_

    return cc.rectIntersectsRect(rect1_, rect2_)    --判断两个四边形是否相交
end

return BaseModel
