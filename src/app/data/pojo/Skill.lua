local Skill = class("Skill")

---构造函数
---@param mySkill Skill
---@param skillName string
---@param skillVariable string
---@param skillValue number
---@param skillValueUpgrade number
---@param skillValueEnhance number
function Skill:ctor(mySkill, skillName, skillVariable, skillValue, skillValueUpgrade, skillValueEnhance)
    if mySkill == nil then
        self.skillName_ = skillName
        self.skillVariable_ = skillVariable -- TODO 这个……该怎么去判断影响哪个变量…… 难道要遍历嘛QAQ
        self.skillValue_ = skillValue
        self.skillValueUpgrade_ = skillValueUpgrade
        self.skillValueEnhance_ = skillValueEnhance
    else
        self:setData(mySkill)
    end
end

function Skill:setData(mySkill)
    self.skillName_ = mySkill:getSkillName()
    self.skillVariable_ = mySkill:getSkillVariable()
    self.skillValue_ = mySkill:getSkillValue()
    self.skillValueUpgrade_ = mySkill:getSkillValueUpgrade()
    self.skillValueEnhance_ = mySkill:getSkillValueEnhance()
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
