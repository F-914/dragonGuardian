--[[--
    BaseModel.lua
    数据对象基类
]]
local BaseModel = class("BaseModel")

---构造函数
---@param myBaseModel BaseModel
---@param x number
---@param y number
---@param width number
---@param height number
---@param isDeath boolean
function BaseModel:ctor(myBaseModel, x, y, width, height, isDeath)
    if myBaseModel == nil then
        self.x_ = x -- 类型：number
        self.y_ = y -- 类型：number
        self.width_ = width -- 类型：number
        self.height_ = height -- 类型：number
        self.isDeath_ = isDeath -- 类型：boolean，是否死亡（销毁）
    else
        self.x_ = myBaseModel.x_
        self.y_ = myBaseModel.y_
        self.width_ = myBaseModel.width_
        self.height_ = myBaseModel.height_
        self.isDeath_ = myBaseModel.isDeath_
    end

    id_ = id_ + 1
    self.id_ = id_ -- 类型：number，唯一id
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
