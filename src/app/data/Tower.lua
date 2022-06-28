--[[--
    Tower.lua
    防御塔对象
]]
local Tower = class("Tower", require("app.data.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

function Tower:ctor(
    name,
    rarity,
    type,
    atk,
    atkTarget,
    atkUpgrade,
    atkEnhance,
    fireCd,
    fireCdEnhance,
    fireCdUpgrade,
    skills,
    extraDamage,
    fatalityRate,
    star)
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

function Tower:setTower(name,
                        rarity,
                        type,
                        atk,
                        atkTarget,
                        atkUpgrade,
                        atkEnhance,
                        fireCd,
                        fireCdEnhance,
                        fireCdUpgrade,
                        skills,
                        extraDamage,
                        fatalityRate,
                        star)
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
function Tower:getRarity()
    return self.rarity_
end

--- 类型
---@return number
function Tower:getType()
    return self.type_
end

-- 攻击目标
function Tower:getTarget()
    return self.atkTarget_
end

-- 防御塔名称
function Tower:getName()
    return self.name_
end

-- 攻击力
function Tower:getAtk()
    return self.atk_
end

-- 升级后攻击力变化
function Tower:getAtkUpgrade()
    return self.atkUpgrade_
end

-- 强化后攻击力变化
function Tower:getAtkEnhance()
    return self.atkEnhance_
end

-- 攻速
function Tower:getFireCd()
    return self.fireCd_
end

-- 升级后攻速变化
function Tower:getFireCdUpgrade()
    return self.fireCdUpgrade_
end

-- 强化后攻速变化
function Tower:getFireCdEnhance()
    return self.fireCdEnhance_
end

-- 技能 table
function Tower:getSkills()
    return self.skills_
end

--- 额外伤害
function Tower:getExtraDamage()
    return self.extraDamage_
end

--- 致死率
function Tower:getFatalityRate()
    return self.fatalityRate_
end

--- 星级
function Tower:getStar()
    return self.star_
end

return Tower
