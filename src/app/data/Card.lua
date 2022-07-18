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

--# card
--## Now
--cardId
--cardName
--cardRarity
--cardType
--cardSkills
--cardAtk
--cardAtkTarget
--cardATkEnahnce
--cardExtraDamage
--cardFireCd
--cardFireCdEnhance
--cardFireCdUpgrade
--cardFatalityRate
--cardStar
--cardLevel
--cardLocation
--## Both
--cardId -- 卡片的ID 用来标志是20个卡牌中的哪一种
--cardName -- 卡片的名字
--cardRarity -- 卡片的稀有度 不知道在游戏内不同稀有度的卡牌会不会有不同的样子
--cardType -- 卡片的四种类型
--cardSkills -- 卡片的技能 在游戏外需要有查看技能的选项，在游戏内需要使用技能
--cardAtk -- 卡片的攻击力 随着等级或者星级变化而变化
--cardAtkTarget -- 卡片的攻击目标
--cardATkEnahnce -- 强化后的攻击力
--cardAtkUpgrade -- 升级后的攻击力
--cardFireCd -- 卡片的攻速
--cardFireCdEnhance -- 强化后的攻速
--cardFireCdUpgrade -- 升级后的攻速
--cardLocation -- 卡片在小队中的序号
---- 每种卡牌的单独的属性 后续需要再新增
--cardFatalityRate -- 致命率
--cardExtraDamage -- 额外伤害
--## InGame
--cardStar -- 卡片的星级
--卡片合成之类的相关函数
--## OutGame
--cardAtkLevel -- 卡片的等级

---Card.ctor 构造函数
---@param cardId        number 防御塔 ID
---@param name          string 防御塔的名字
---@param rarity        string 稀有度
---@param type          string 类型，四种类型中的某一种
---@param level         number 卡牌等级
---@param cardAmount    number 该种卡牌的数量 当卡牌作为商品时 购买所得到的卡牌数量以Commodity中的Amount为准
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
---@return  nil Description
function Card:ctor(cardId, name, rarity, type, level, cardAmount, atk, atkTarget, atkUpgrade, atkEnhance, fireCd,
                   fireCdEnhance,
                   fireCdUpgrade,
                   skills, extraDamage, fatalityRate, location)
    self:setCard(cardId, name, rarity, type, level, cardAmount, atk, atkTarget, atkUpgrade, atkEnhance, fireCd,
        fireCdEnhance,
        fireCdUpgrade, skills
        , extraDamage, fatalityRate, location)
    EventManager:doEvent(EventDef.ID.CREATE_CARD, self)
end

function Card:setCard(cardId, name, rarity, type, level, cardAmount, atk, atkTarget, atkUpgrade, atkEnhance, fireCd,
                      fireCdEnhance,
                      fireCdUpgrade,
                      skills, extraDamage, fatalityRate, location)
    self.cardId_ = cardId
    self.cardName_ = name
    self.cardRarity_ = rarity
    self.cardType_ = type
    self.cardLevel_ = level
    self.cardAmount_ = cardAmount
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

function Card:getCardLevel()
    return self.cardLevel_
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

---用于增加数量
function Card:addCardAmount(number)
    self.cardAmount_ = self.cardAmount_ + number
end

return Card
