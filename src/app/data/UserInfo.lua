--[[--
    UserInfo.lua
    用户信息
]]
UserInfo = class("UserInfo")
UserInfo.instance_ = nil

-- local
local ConstDef = require("app.def.ConstDef")
local StringDef = require("app.def.StringDef")
local TestDataFactory = require("src/app/test/TestDataFactory.lua")
--

function UserInfo:ctor(account, avatar, nickname, coinAmount, diamondAmount, trophyAmount, battleTeam, ladderList,
                       cardList)
    self:setUserInfo(account, avatar, nickname, coinAmount, diamondAmount, trophyAmount, battleTeam, ladderList, cardList)
end

function UserInfo:getInstance()
    if self.instance_ == nil then
        self.instance_ = UserInfo.new()
        self.instance_:initData()
    end
    return self.instance_
end

function UserInfo:initData()
    self:testData()
end

--test
function UserInfo:testData()
    self.account_ = "123456"
    self.avatar = StringDef.PATH_DEFAULT_AVATAR
    self.nickname_ = "黑山老妖12138"
    self.coinAmount_ = 123456
    self.diamondAmount_ = 789999
    self.trophyAmount_ = 101
    self.battleTeam_ = {}
    self.ladder_ = {}
    self.cardList_ = {}
end

function UserInfo:setUserInfo(account, avatar, nickname, coinAmount, diamondAmount, trophyAmount, battleTeam, ladder,
                              cardList)
    self.account_ = account
    self.avatar_ = avatar
    self.nickname_ = nickname
    self.coinAmount_ = coinAmount
    self.diamondAmount_ = diamondAmount
    self.trophyAmount_ = trophyAmount
    self.battleTeam_ = battleTeam
    self.ladder_ = ladder
    self.cardList_ = cardList
end

function UserInfo:update(dt)
    --nothing
end

function UserInfo:getAccount()
    return self.account_
end

function UserInfo:getNickname()
    return self.nickname_
end

function UserInfo:getCoinAmount()
    return self.coinAmount_
end

function UserInfo:getDiamondAmount()
    return self.diamondAmount_
end

function UserInfo:getAvatar()
    return self.avatar_
end

function UserInfo:getTrophyAmount()
    return self.trophyAmount_
end

function UserInfo:getCoinAmount()
    return self.coinAmount_
end

function UserInfo:getDiamondAmount()
    return self.diamondAmount_
end

function UserInfo:getBattleTeam()
    return self.battleTeam_
end

function UserInfo:setAvatar(avatar)
    self.avatar_ = avatar
end

function UserInfo:getCollected()
    return self.instance_.collected_
end

function UserInfo:getUnCollected()
    return self.instance_.unCollected_
end

return UserInfo
