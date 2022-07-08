--[[--
    该工具类提供用于将json字符串的转化的表格剔出多余数据，并转化为对象
    同时还提供将对象转化为表格的功能
    TableUtil.lua
]]
local TableUtil = {}

local BattleTeam = require("src/app/data/BattleTeam.lua")
local Card = require("src/app/data/Card.lua")
local Commodity = require("src/app/data/Commodity.lua")
local Currency = require("src/app/data/Currency.lua")
local Enemy = require("src/app/data/Enemy.lua")
local Ladder = require("src/app/data/Ladder.lua")
local Reward = require("src/app/data/Reward.lua")
local Shop = require("src/app/data/Shop.lua")
local Skill = require("src/app/data/Skill.lua")
local TreasureBox = require("src/app/data/TreasureBox.lua")
local UserInfo = require("src/app/data/UserInfo.lua")
--[[--
    @将表格转化为战斗队伍对象，表格需要有目标对象属性的字段，
    字段不包括后缀_(也可以包括，但得统一)，不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toBattleTeam(msg)
    local myTeams = {}
    for i = 1, #msg.myTeam do
        local team = {}
        for j = 1, #msg.myTeam[i] do
            team[j] = self:toCard(msg.myTeam[i][j])
        end
        myTeams[i] = team
    end
    return BattleTeam.new(myTeams, msg.standByTeam)
end
--[[--
    @将表格转化为card对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toCard(msg)
    local skills = {}
    ---skills属性是skill对象构成的表格吗？？？？
    for i = 1, #msg.skills do
        skills[i] = self:toSkill(msg.skills[i])
    end
    return Card.new(msg.cardId, msg.name, msg.rarity,
    msg.type, msg.atk, msg.atkTarget, msg.atkUpgrade,
    msg.atkEnhance, msg.fireCd, msg.fireCdEnhance,
    msg.fireCdUpgrade, skills, msg.extraDamage, msg.fatalityRate,
    msg.star, msg.location)
end
--[[--
    @将表格转化为commodity对象，表格需要有目标对象属性的字段
    不进行错误检查
    这个好像没用
    @param type:table, 表格数据
]]
function TableUtil:toCommodity(msg)
    return Commodity.new(msg.name, msg.type, msg.price,
            msg.priceUnit, msg.amount)
end
--[[--
    @将表格转化为currency对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toCurrency(msg)
    return nil
end
--[[--
    @将表格转化为enemy对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toEnemy(msg)
    local skills = {}
    ---skills属性是skill对象构成的表格吗？？？？
    for i = 1, #msg.skills do
        skills[i] = self:toSkill(msg.skills[i])
    end

    return Enemy.new(msg.name, msg.hp, skills, msg.description)
end
--[[--
    @将表格转化为enemy对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toLadder(msg)
    local ladderList = {}
    for i = 1, #msg.ladderList do
        ladderList[i] = Reward.new(msg.ladderList[i])
    end
    return Ladder.new(ladderList)
end
--[[--
    @将表格转化为reward对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toReward(msg)
    ---这个reward不知道是啥
    return Reward.new(msg.rewardName, msg.rewardType, msg.location,
    self:toBoolean(msg.locked), self:toBoolean(msg.received),
            msg.trophyCondition, msg.amount, nil)
end
--[[--
    @将表格转化为shop对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toShop(msg)
    local commodityList = {}
    for i = 1, #msg.commodityList do
        commodityList[i] = self:toCommodity(msg.commodityList[i])
    end

    return Shop.new(commodityList, msg.freshTime)
end
--[[--
    @将表格转化为skill对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toSkill(msg)
    return Skill.new(msg.skillName, msg.skillVariable, msg.skillValue,
    msg.skillValueUpgrade, msg.skillValueEnhance)
end
--[[--
    @将表格转化为treasureBox对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toTreasureBox(msg)
    ---接收到党的消息也有有、type字段，区分所以用type_
    return TreasureBox.new(msg.name, msg.type_, msg.desc)
end
--[[--
    @将表格转化为enemy对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toUserInfo(msg)
    ---这个由于是单例模式，所以没有返回值
    local cardList = {}
    for i = 1, #msg.cardList do
        cardList[i] = self:toCard(msg.cardList[i])
    end

    local userInfo = UserInfo:getInstance()
    userInfo:setUserInfo(msg.account, msg.avatar, msg.nickname,
    msg.coinAmount, msg.diamondAmount, msg.trophyAmount,
    self:toBattleTeam(msg.battleTeam), self:toLadder(msg.ladder),
    cardList)
end
function TableUtil:toBoolean(string)
    if string == "true"then
        return true
    else
        return false
    end
end
---下面部分是将对象转化为表格数据，用于网络传输
---

--[[--
    @description: 将对象作为消息传递给服务器时，用这个函数去除对象中的方法，
    测试过继承，组合两种常见情况,

    @param obj type:object 对象
    @param 待扩展
    @return type:table 对象去除函数后的数据
]]
function TableUtil:removeTableFunction(obj)
    local res = {}
    for key, value in pairs(obj) do
        --print(type(key)..": ", key, " = "..type(value)..": ", value)
        if key ~= "class" then
            if type(value) == "table" then
                value = self:myJsonTest(value)
            end
            res[key] = value
        end
    end
    return res
end
return TableUtil