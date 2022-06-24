--[[--
    BaseModel.lua
    数据对象基类
]]
local BaseModel = class("BaseModel")

--[[--
    构造函数

    @param myBaseModel 类型：BaseModel 用于从数据库中读取数据后来初始化BaseModel，很有可能用不到，但是先放着
    @param x 类型：number
    @param y 类型：number
    @param width 类型：number
    @param height 类型：number
    @param isDeath 类型：boolean

    @return none
]]
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

function BaseModel:update(dt)
    -- body
end

return BaseModel
