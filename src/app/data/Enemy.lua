--[[--
    Enemy.lua
    敌人对象基类
]]
local Enemy = class("Enemy", require("app.data.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---Enemy.ctor 构造函数
---@param name        string 敌人名
---@param hp          number 敌人血量
---@param skills      table 敌人技能
---@param description string 敌人描述
---@return  Type Description
function Enemy:ctor(name, hp, skills, description)
    self:setEnemy(name, hp, skills, desc)
end

function Enemy:setEnemy(name, hp, skills, desc)
    self.name_ = name
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

return Enemy
