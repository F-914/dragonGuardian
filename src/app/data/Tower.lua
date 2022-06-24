--[[--
    Tower.lua
    防御塔对象
]]
local Tower = class("Tower", require("app.data.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---构造函数
---@param myTower Tower
---@param x number
---@param y number
---@param width number
---@param height number
---@param isDeath boolean
---@param name string
---@param rarity number
---@param type number
---@param atk number
---@param atkTarget number
---@param atkUpgrade number
---@param atkEnhance number
---@param fireCd number
---@param fireCdEnhance number
---@param fireCdUpgrade number
---@param skills table
---@param extraDamage number
---@param fatalityRate number
-- TODO 属性应该还得增加
function Tower:ctor(
    myTower,
    x,
    y,
    width,
    height,
    isDeath,
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
    fatalityRate)
    if myTower == nil then
        Tower.super.ctor(self, nil, x, y, width, height, isDeath)
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
    else
        Tower:setData(myTower)
    end
end

---setData
---@param myTower Tower
function Tower:setData(myTower)
    Tower.super.ctor(
        self,
        nil,
        myTower:getMyX(),
        myTower:getMyY(),
        myTower:getMyWidth(),
        myTower:getMyHeight(),
        myTower:isDeath()
    )
    self.name_ = myTower:getName()
    self.rarity_ = myTower:getRarity()
    self.type_ = myTower:getType()
    self.skills_ = myTower:getSkills()

    self.atk_ = myTower:getAtk()
    self.atkTarget_ = myTower:getTarget()
    self.atkUpgrade_ = myTower:getAtkUpgrade()
    self.atkEnhance_ = myTower:getAtkEnhance()
    self.extraDamage_ = myTower:getExtraDamage()
    self.fatalityRate_ = myTower:getFatalityRate()

    self.fireCd_ = myTower:getFireCd()
    self.fireCdEnhance_ = myTower:getFireCdEnhance()
    self.fireCdUpgrade_ = myTower:getFireCdUpgrade()
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

return Tower
