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
local ConstDef = require("src/app/def/ConstDef.lua")
local Log = require("src/app/utils/Log.lua")
--[[--
    @将表格转化为战斗队伍对象，表格需要有目标对象属性的字段，
    字段不包括后缀_(也可以包括，但得统一)，不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toBattleTeam(msg)
    return BattleTeam.new(msg.team, msg.standByTeam)
end
--[[--
    @将表格转化为card对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toCard(msg)
    local skills = {}
    --for i = 1, #msg.cardSkills do
    --    skills[i] = self:toSkill(msg.cardSkills[i])
    --end
    return Card.new(msg.cardId, msg.cardName, msg.cardRarity,
            msg.cardType, msg.cardLevel, msg.cardAmount ,msg.cardAtk,
            msg.cardAtkTarget, msg.cardAtkUpgrade,
            msg.cardAtkEnhance, msg.cardFireCd, msg.cardFireCdEnhance,
            msg.cardFireCdUpgrade, skills, msg.cardExtraDamage, msg.cardFatalityRate,
            nil)
end
--[[--
    @将表格转化为commodity对象，表格需要有目标对象属性的字段
    不进行错误检查
    这个好像没用
    @param type:table, 表格数据
]]
function TableUtil:toCommodity(msg)
    local obj = nil
    if msg.commodityType == ConstDef.COMMODITY_TYPE.CURRENCY then
        obj = self:toCurrency(msg.commodityCommodity)
    elseif msg.commodityType == ConstDef.COMMODITY_TYPE.TOWER then
        obj = self:toCard(msg.commodityCommodity)
    elseif msg.commodityType == ConstDef.COMMODITY_TYPE.TREASUREBOX then
        obj = self:toTreasureBox(msg.commodityCommodity)
    elseif msg.commodityType== ConstDef.COMMODITY_TYPE.UR then
        obj = nil
    else
        Log.e("uncatch this commodity type:", msg.commodityType)
    end

    return Commodity.new(msg.commodityName, msg.commodityType,
            msg.commodityPrice, msg.commodityPriceUnit,
            msg.commodityAmount, obj)
end
--[[--
    @将表格转化为currency对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toCurrency(msg)
    return Currency.new(msg.currencyType, msg.currencyAmount)
end
--[[--
    @将表格转化为enemy对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toEnemy(msg)
    local skills = {}

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
        ladderList[i] = self:toReward(msg.ladderList[i])
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
    local obj = nil
    if msg.rewardType == ConstDef.REWARD_TYPE.CURRENCY then
        obj = self:toCurrency(msg.reward)
    elseif msg.rewardType == ConstDef.REWARD_TYPE.CARD then
        obj = self:toCard(msg.reward)
    elseif msg.rewardType == ConstDef.REWARD_TYPE.TREASUREBOX then
        obj = self:toTreasureBox(msg.reward)
    elseif msg.rewardType == ConstDef.REWARD_TYPE.RANDOM then
        --我也不知道
        obj = nil
    else
        Log.e("uncatch this commodity type:", msg.type)
    end
    return Reward.new(msg.rewardName, msg.rewardType, msg.rewardLocation,
    self:toBoolean(msg.locked), self:toBoolean(msg.received),
            msg.trophyCondition, msg.rewardAmount, obj)
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
    ---这里暂时有一些问题，留待后续完善
    return Skill.new(msg.skillName, nil)

end
--[[--
    @将表格转化为treasureBox对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toTreasureBox(msg)
    return TreasureBox.new(msg.treasureBoxName, msg.treasureBoxType,
            msg.treasureBoxDescription)
end
--[[--
    @将表格转化为enemy对象，表格需要有目标对象属性的字段
    不进行错误检查
    @param type:table, 表格数据
]]
function TableUtil:toUserInfo(msg)
    ---这个由于是单例模式，所以没有返回值
    local cardList = {}
    for i = 1, #msg.userInfoCardList do
        cardList[i] = self:toCard(msg.userInfoCardList[i])
    end

    local userInfo = UserInfo:getInstance()
    userInfo:setUserInfo(msg.userInfoAccount, msg.userInfoAvatar,
            msg.userInfoNickname, msg.userInfoCoinAmount,
            msg.userInfoDiamondAmount, msg.userInfoTrophyAmount,
            self:toBattleTeam(msg.userInfoBattleTeam),
            self:toLadder(msg.userInfoLadder),
    cardList)
    return userInfo
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
    @description: 将对象作为消息传递给服务器时，
    用这个函数去除对象中的方法，同时去除对象中属性后面的_
    测试过继承，组合两种常见情况,

    @param obj type:object 对象
    @param 待扩展
    @return type:table 对象去除函数后的数据
]]
function TableUtil:removeTableFunction(obj)
    local res = {}
    for key, value in pairs(obj) do
        if key ~= "class" then
            if type(value) == "table" then
                value = self:removeTableFunction(value)
            end
            res[string.sub(key, 1, -2)] = value
        end
    end
    return res
end
--[[--
    @description:将之前去除函数的对象数据进一步封装成发送的消息
    @param type type:string, 该消息的类型，
    @param loginName type:string,用户名
    @param ... 参数应该满足第一个时index，第二个data，第三个是index，第四个data
    @return type:table, 经过json打包过后直接可以发送的消息
]]
function TableUtil:encapsulateAsMsg(type, loginName,...)
    local msg = {}
    msg.type = type
    msg.loginName = loginName
    local arg = {...}
    for i = 1, #arg, 2 do
        msg[arg[i]] = arg[i + 1]
    end
    return msg
end
--[[--
    @description: 浅层次克隆一个表格,遇见表格直接放弃
    @param table type：table 源表格
    @return type:table 克隆出来的表格
]]
function TableUtil:clone(table)
    local res = {}
    for key, value in pairs(table) do
        if type(key) ~= "table"
                and type(value) ~= "table" then
            res[key] = value
        end
    end
    return res
end

return TableUtil