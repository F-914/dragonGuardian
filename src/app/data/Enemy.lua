--[[--
    Enemy.lua
    敌人对象基类
]]
local Enemy = class("Enemy", require("app.data.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

function Enemy:ctor(name, hp, skills, description)
    self.name_ = name
    self.hp_ = hp
    self.skills_ = skills
    self.description_ = description
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
