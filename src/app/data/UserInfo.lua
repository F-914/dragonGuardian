--[[--
    UserInfo.lua
    用户信息
]]
UserInfo = class("UserInfo")
UserInfo.instance_ = nil

-- local
local ConstDef = require("app.def.ConstDef")
local StringDef = require("app.def.StringDef")
local TestDataFactory = require("app.test.TestDataFactory")
local BattleTeam = require("app.data.BattleTeam")
local Card = require("app.data.Card")
local Log = require("app.utils.Log")
local Ladder = require("app.data.Ladder")
local Reward = require("app.data.Reward")
local Currency = require("app.data.Currency")
--

function UserInfo:ctor(account, avatar, nickname, coinAmount, diamondAmount, trophyAmount, battleTeam, ladderList,
                       cardList)
    self:setUserInfo(account, avatar, nickname, coinAmount, diamondAmount, trophyAmount, battleTeam, ladderList, cardList)
end

function UserInfo:getInstance()
    Log.i("UserInfo:getInstance: " .. tostring(self.instance_ == nil))
    if self.instance_ == nil then
        self.instance_ = UserInfo.new()
        Log.i("getInstance: " .. tostring(self.instance_ == nil))
        self.instance_:initData()
    end
    return self.instance_
end

function UserInfo:setUserInfo(account, avatar, nickname, coinAmount, diamondAmount, trophyAmount, battleTeam, ladder,
                              cardList)
    self.userInfoAccount_ = account
    self.userInfoAvatar_ = avatar
    self.userInfoNickname_ = nickname
    self.userInfoCoinAmount_ = coinAmount
    self.userInfoDiamondAmount_ = diamondAmount
    self.userInfoTrophyAmount_ = trophyAmount
    self.userInfoBattleTeam_ = battleTeam
    self.userInfoLadder_ = ladder
    self.userInfoCardList_ = cardList
end

function UserInfo:initData()
    --self:testData()
end

--test
function UserInfo:testData()
    self.userInfoAccount_ = "123456"
    self.userInfoAvatar_ = StringDef.PATH_DEFAULT_AVATAR
    self.userInfoNickname_ = "黑山老妖12138"
    self.userInfoCoinAmount_ = 123456
    self.userInfoDiamondAmount_ = 789999
    self.userInfoTrophyAmount_ = 200
    self.userInfoBattleTeam_ = TestDataFactory:getTeamDataTest()
    self.userInfoLadder_ = TestDataFactory:getLadderTest()
    self.userInfoCardList_ = TestDataFactory:getCardListTest()
end

function UserInfo:update(dt)
    --nothing
end

function UserInfo:getAccount()
    return self.userInfoAccount_
end

function UserInfo:getNickname()
    return self.userInfoNickname_
end

function UserInfo:getCoinAmount()
    return self.userInfoCoinAmount_
end

function UserInfo:getDiamondAmount()
    return self.userInfoDiamondAmount_
end

function UserInfo:getAvatar()
    return self.userInfoAvatar_
end

function UserInfo:getTrophyAmount()
    return self.userInfoTrophyAmount_
end

function UserInfo:getBattleTeam()
    return self.userInfoBattleTeam_
end

function UserInfo:setAvatar(avatar)
    self.userInfoAvatar_ = avatar
end

function UserInfo:setUserInfoLadder(ladder)
    self.userInfoLadder_ = ladder
end

function UserInfo:getUserInfoLadder()
    return self.userInfoLadder_
end

function UserInfo:setUserInfoDiamondAmount(diamondAmount)
    self.userInfoDiamondAmount_ = diamondAmount
end

function UserInfo:setUserInfoCoinAmount(coinAmount)
    self.userInfoCoinAmount_ = coinAmount
end

function UserInfo:setUserInfoTrophyAmount(trophyAmount)
    self.userInfoTrophyAmount_ = trophyAmount
end

function UserInfo:getUserInfoCardList()
    return self:getCardList()
end

function UserInfo:getCardList()
    if self.userInfoCardList_ == nil then
        self.userInfoCardList_ = {}
    end
    return self.userInfoCardList_
end

function UserInfo:setUserInfoBattleTeam(battleTeam)
    self.battleTeam_ = battleTeam
end

function UserInfo:getCollectedList()
    local cardList = self:getCardList()
    local list = {}
    local set = {}
    if cardList == nil then
        return list
    end
    for i = 1, #cardList do
        local id = cardList[i]:getCardId()
        if set[id] then
            -- nothing
        else
            set[id] = true
            table.insert(list, id)
        end
    end
    return list
end

function UserInfo:getUnCollectedList()
    local cardList = self:getCardList()
    local list = {}
    local set = {}
    for id = 1, 20 do
        set[id] = true
    end
    if cardList == nil then
        for id = 1, 20 do
            table.insert(list, id)
        end
        return list
    end
    for i = 1, #cardList do
        local id = cardList[i]:getCardId()
        if set[id] then
            set[id] = false
        end
    end
    for k, v in pairs(set) do
        if v == true then
            table.insert(list, k)
        end
    end
    return list
end

return UserInfo
