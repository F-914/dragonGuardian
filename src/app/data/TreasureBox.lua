--[[--
    TreasureBox.lua
    宝箱对象
]]
local TreasureBox = class("TreasureBox", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---TreasureBox.ctor 构造函数
---@param name string 宝箱名
---@param type string 宝箱类型
---@param desc string 宝箱描述
---@return  Type Description
function TreasureBox:ctor(name, type, desc)
    self:setTreasureBox(name, type, desc)
    EventManager:doEvent(EventDef.ID.CREATE_TREASUREBOX, self)
end

function TreasureBox:setTreasureBox(name, type, desc)
    self.name_ = name
    self.type_ = type
    self.description_ = desc
end

function TreasureBox:getName()
    return self.name_
end

function TreasureBox:getType()
    return self.type_
end

function TreasureBox:getDescription()
    return self.description_
end

function TreasureBox:openIt()
    --- 宝箱的奖励
end

return TreasureBox
