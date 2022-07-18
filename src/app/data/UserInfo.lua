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
    self.userInfoAccount_ = "123456"
    self.userInfoAvatar_ = StringDef.PATH_DEFAULT_AVATAR
    self.userInfoNickname_ = "黑山老妖12138"
    self.userInfoCoinAmount_ = 123456
    self.userInfoDiamondAmount_ = 789999
    self.userInfoTrophyAmount_ = 101
    self.userInfoBattleTeam_ = BattleTeam.new(
            {
                { 1, 2, 3, 4, 5 },
                { 6, 7, 8, 9, 10 },
                { 1, 3, 5, 7, 9 }
            },
            1
    )
    self.userInfoLadder_ = Ladder.new(
            { Reward.new(
                    "随便什么名字",
                    ConstDef.REWARD_TYPE.CURRENCY,
                    1,
                    true,
                    false,
                    500,
                    1000,
                    Currency.new(
                            ConstDef.CURRENCY_TYPE.COIN,
                            0
                    )
            ) }
    )
    self.userInfoCardList_ = {
        [1] = Card.new(
                1,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.R,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                3,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [2] = Card.new(
                2,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.R,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                3,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [3] = Card.new(
                3,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.R,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                99,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [4] = Card.new(
                4,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.UR,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                45,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [5] = Card.new(
                5,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.SSR,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                56,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [6] = Card.new(
                6,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.SR,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                123,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [7] = Card.new(
                7,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.R,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                500,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [8] = Card.new(
                8,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.SSR,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                90,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [9] = Card.new(
                9,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.UR,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                1,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
        [10] = Card.new(
                10,
                "平平无奇防御塔",
                ConstDef.TOWER_RARITY.SR,
                ConstDef.TOWER_TYPE.ATTACK,
                math.random(10),
                32,
                math.random(100),
                ConstDef.TOWER_ATK_TARGET.BACK,
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                math.random(100),
                {},
                math.random(100),
                0.00,
                2,
                1
        ),
    }

    --local collected = self:getCollectedList()
    --Log.i("Collected: " .. tostring(#(collected)))
    --for i = 1, #(collected) do
    --    Log.i("" .. tostring(collected[i]))
    --end
    ----
    --local uncollected = self:getUnCollectedList()
    --Log.i("Uncollected")
    --for i = 1, #(uncollected) do
    --    Log.i("" .. tostring(uncollected[i]))
    --end
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

function UserInfo:getCoinAmount()
    return self.userInfoCoinAmount_
end

function UserInfo:getDiamondAmount()
    return self.userInfoDiamondAmount_
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
    for i = 1, #(cardList) do
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
    for i = 1, #(cardList) do
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
