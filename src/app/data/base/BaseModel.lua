--[[--
    BaseModel.lua
    数据对象基类
]]
local BaseModel = class("BaseModel")

---构造函数
---@param x number
---@param y number
---@param width number
---@param height number
---@param isDeath boolean
function BaseModel:ctor(x, y, width, height, isDeath)
    self:setBaseModel(x, y, width, height, isDeath)
end

function BaseModel:setBaseModel(x, y, width, height, isDeath)
    self.x_ = x -- 类型：number
    self.y_ = y -- 类型：number
    self.width_ = width -- 类型：number
    self.height_ = height -- 类型：number
    self.isDeath_ = isDeath -- 类型：boolean，是否死亡（销毁）
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

return BaseModel
