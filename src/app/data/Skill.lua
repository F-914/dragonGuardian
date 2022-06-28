--[[--
    Skill.lua
    技能基类
]]
local Skill = class("Skill", require("app.data.Skill"))

---Skill.ctor 构造函数
---@param skillName         string 技能名
---@param skillVariable     string 影响的变量
---@param skillValue        number 影响的值
---@param skillValueUpgrade number 升级后技能数值的变化
---@param skillValueEnhance number 强化后技能数值的变化
---@return  Type Description
function Skill:ctor(skillName, skillVariable, skillValue, skillValueUpgrade, skillValueEnhance)
    self:setSkill(skillName, skillVariable, skillValue, skillValueUpgrade, skillValueEnhance)
end

function Skill:setSkill(skillName, skillVariable, skillValue, skillValueUpgrade, skillValueEnhance)
    self.skillName_ = skillName
    self.skillVariable_ = skillVariable -- TODO 这个……该怎么去判断影响哪个变量…… 难道要遍历嘛QAQ
    self.skillValue_ = skillValue
    self.skillValueUpgrade_ = skillValueUpgrade
    self.skillValueEnhance_ = skillValueEnhance
end

function Skill:getSkillVariable()
    return self.skillVariable_
end

function Skill:getSkillName()
    return self.skillName_
end

function Skill:getSkillValue()
    return self.skillValue_
end

function Skill:getSkillValueUpgrade()
    return self.skillValueUpgrade_
end

function Skill:getSkillValueEnhance()
    return self.skillValueEnhance_
end

return Skill
