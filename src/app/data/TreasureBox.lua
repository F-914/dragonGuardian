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
---@param type number 宝箱类型
---@param desc string 宝箱描述
---@return  nil Description
function TreasureBox:ctor(name, type, desc)
    self:setTreasureBox(name, type, desc)
    EventManager:doEvent(EventDef.ID.CREATE_TREASUREBOX, self)
end

function TreasureBox:setTreasureBox(name, type, desc)
    self.treasureBoxName_ = name
    self.treasureBoxType_ = type
    self.treasureBoxDescription_ = desc
end

function TreasureBox:getTreasureBoxName()
    return self.treasureBoxName_
end

function TreasureBox:getTreasureBoxType()
    return self.treasureBoxType_
end

function TreasureBox:getDescription()
    return self.treasureBoxDescription_
end

function TreasureBox:openIt()
    --- 宝箱的奖励
end

return TreasureBox
