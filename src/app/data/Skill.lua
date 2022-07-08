-- TODO 这个得超级无敌宇宙大改
--[[--
    Skill.lua
    技能基类
    每一个技能都有一个函数，妙啊
]]
local Skill = class("Skill", require("app.data.base.BaseModel"))

--local
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---Skill.ctor 构造函数
---@param skillName         string 技能名
---@param skillVariable     string 影响的变量
---@param skillValue        number 影响的值
---@param skillValueUpgrade number 升级后技能数值的变化
---@param skillValueEnhance number 强化后技能数值的变化
---@return  Type Description
function Skill:ctor(skillName, skillFun)
    self:setSkill(skillName, skillFun)
    EventManager:doEvent(EventDef.ID.CREATE_SKILL, self)
end

function Skill:setSkill(skillName, skillFun)
    self.skillName_ = skillName
    self:skillFun() = skillFun
end

function Skill:getSkillName()
    return self.skillName_
end

function Skill:skillFun()

end

return Skill
