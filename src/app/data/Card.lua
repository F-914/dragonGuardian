--[[--
    Card.lua
    防御塔对象
]]
local Card = class("Card", require("app.data.base.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--

---Card.ctor 构造函数
---@param cardId        number 防御塔 ID
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
---@param fatalityRate  number 单次攻击的致命率
---@param star          number 星级
---@return  nil Description
function Card:ctor(cardId, name, rarity, type, atk, atkTarget, atkUpgrade, atkEnhance, fireCd, fireCdEnhance, fireCdUpgrade,
                   skills, extraDamage, fatalityRate, star, location)
    self:setCard(cardId, name, rarity, type, atk, atkTarget, atkUpgrade, atkEnhance, fireCd, fireCdEnhance, fireCdUpgrade, skills
    , extraDamage, fatalityRate, star, location)
    EventManager:doEvent(EventDef.ID.CREATE_CARD, self)
end

function Card:setCard(cardId, name, rarity, type, atk, atkTarget, atkUpgrade, atkEnhance, fireCd, fireCdEnhance, fireCdUpgrade,
                      skills, extraDamage, fatalityRate, star, location)
    self.cardId_ = cardId
    self.cardName_ = name
    self.cardRarity_ = rarity
    self.cardType_ = type
    self.cardSkills = skills

    self.cardAtk_ = atk
    self.cardAtkTarget_ = atkTarget
    self.cardAtkUpgrade_ = atkUpgrade
    self.cardAtkEnhance_ = atkEnhance
    self.cardExtraDamage_ = extraDamage

    self.cardFireCd_ = fireCd
    self.cardFireCdEnhance_ = fireCdEnhance
    self.cardFireCdUpgrade_ = fireCdUpgrade

    self.cardFatalityRate_ = fatalityRate
    self.cardStar_ = star

    self.cardLocation_ = location
end

function Card:getCardId()
    return self.cardId_
end

--- 稀有度
---@return number
function Card:getCardRarity()
    return self.cardRarity_
end

--- 类型
---@return number
function Card:getCardType()
    return self.cardType_
end

-- 攻击目标
function Card:getCardTarget()
    return self.cardAtkTarget_
end

-- 防御塔名称
function Card:getCardName()
    return self.cardName_
end

-- 攻击力
function Card:getCardAtk()
    return self.cardAtk_
end

-- 升级后攻击力变化
function Card:getCardAtkUpgrade()
    return self.cardAtkUpgrade_
end

-- 强化后攻击力变化
function Card:getCardAtkEnhance()
    return self.cardAtkEnhance_
end

-- 攻速
function Card:getCardFireCd()
    return self.cardFireCd_
end

-- 升级后攻速变化
function Card:getCardFireCdUpgrade()
    return self.cardFireCdUpgrade_
end

-- 强化后攻速变化
function Card:getCardFireCdEnhance()
    return self.cardFireCdEnhance_
end

-- 技能 table
function Card:getCardSkills()
    return self.cardSkills_
end

--- 额外伤害
function Card:getCardExtraDamage()
    return self.cardExtraDamage_
end

--- 致死率
function Card:getCardFatalityRate()
    return self.cardFatalityRate_
end

--- 星级
function Card:getCardStar()
    return self.cardStar_
end

return Card
