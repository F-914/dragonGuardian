--[[--
    Card.lua
    防御塔对象
]]
local Card = class("Card", require("app.data.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---Card.ctor 构造函数
---@param name          string 防御塔的名字
---@param rarity        string 稀有度
---@param type          string 类型，四种类型中的某一种
---@param atk           number 攻击力
---@param atkTarget     string 攻击目标，前方/随机/血量最高
---@param atkUpgrade    number 升级后攻击力变化
---@param atkEnhance    number 强化后攻击力变化
---@param fireCd        number 攻速，单位未知
---@param fireCdEnhance number 强化后攻速变化
---@param fireCdUpgrade number 升级后攻速变化
---@param skills        table 拥有的技能
---@param extraDamage   number 每次攻击带来的额外伤害
---@param fatalityRate  nubmer 单次攻击的致命率
---@param star          number 星级
---@return  Type Description
function Card:ctor(name, rarity, type, atk, atkTarget, atkUpgrade, atkEnhance, fireCd, fireCdEnhance, fireCdUpgrade,
                   skills, extraDamage, fatalityRate, star)
    self:setCard(name, rarity, type, atk, atkTarget, atkUpgrade, atkEnhance, fireCd, fireCdEnhance, fireCdUpgrade, skills
        , extraDamage, fatalityRate, star)
end

function Card:setCard(name, rarity, type, atk, atkTarget, atkUpgrade, atkEnhance, fireCd, fireCdEnhance, fireCdUpgrade,
                      skills, extraDamage, fatalityRate, star)
    self.name_ = name
    self.rarity_ = rarity
    self.type_ = type
    self.skills = skills

    self.atk_ = atk
    self.atkTarget_ = atkTarget
    self.atkUpgrade_ = atkUpgrade
    self.atkEnhance_ = atkEnhance
    self.extraDamage_ = extraDamage

    self.fireCd_ = fireCd
    self.fireCdEnhance_ = fireCdEnhance
    self.fireCdUpgrade_ = fireCdUpgrade

    self.fatalityRate_ = fatalityRate
    self.star_ = star
end

--- 稀有度
---@return number
function Card:getRarity()
    return self.rarity_
end

--- 类型
---@return number
function Card:getType()
    return self.type_
end

-- 攻击目标
function Card:getTarget()
    return self.atkTarget_
end

-- 防御塔名称
function Card:getName()
    return self.name_
end

-- 攻击力
function Card:getAtk()
    return self.atk_
end

-- 升级后攻击力变化
function Card:getAtkUpgrade()
    return self.atkUpgrade_
end

-- 强化后攻击力变化
function Card:getAtkEnhance()
    return self.atkEnhance_
end

-- 攻速
function Card:getFireCd()
    return self.fireCd_
end

-- 升级后攻速变化
function Card:getFireCdUpgrade()
    return self.fireCdUpgrade_
end

-- 强化后攻速变化
function Card:getFireCdEnhance()
    return self.fireCdEnhance_
end

-- 技能 table
function Card:getSkills()
    return self.skills_
end

--- 额外伤害
function Card:getExtraDamage()
    return self.extraDamage_
end

--- 致死率
function Card:getFatalityRate()
    return self.fatalityRate_
end

--- 星级
function Card:getStar()
    return self.star_
end

return Card
