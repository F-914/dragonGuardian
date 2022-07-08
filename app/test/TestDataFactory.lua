--[[--
    该类用于创建测试数据，仅用于测试
    TestDataFactory.lua
]]
local TestDataFactory = {}

--local
local ConstDef = require("app.def.ConstDef")

local CardReward = require("app.data.CardReward")
local CurrencyReward = require("app.data.CurrencyReward")
local TreasureBoxReward = require("app.data.TreasureBoxReward")

local Card = require("app.data.Card")
--

--[[--
    @description:该函数仅用于测试
    @return 返回一个用于测试的奖品列表
]]
function TestDataFactory:getRewardDataTest()
    local rewardData = {}
    for i = 1, 30 do
        local data = nil
        if i < 10 then
            data = self:getRandomCardReward(i, i * 10)
        elseif i < 20 then
            data = self:getRandomCurrencyReward(i)
        else
            data = self:getRandomTreasureBoxReward(i)
        end
        table.insert(rewardData, data)
    end
    return rewardData

    -- return {
    --     [1] = {
    --         order = 1,
    --         numOfTrophy = 50,
    --         name = "gold",
    --         quantity = 400,
    --         isGet = true,
    --         isUnlock = true
    --     },
    --     [2] = {
    --         order = 2,
    --         numOfTrophy = 100,
    --         name = "ordinary treasure chest",
    --         isGet = true,
    --         isUnlock = true
    --     },
    --     [3] = {
    --         order = 3,
    --         numOfTrophy = 150,
    --         name = "diamond",
    --         quantity = 400,
    --         isGet = false,
    --         isUnlock = true
    --     },
    --     [4] = {
    --         order = 4,
    --         numOfTrophy = 200,
    --         name = "rare treasure chest",
    --         isGet = false,
    --         isUnlock = false
    --     },
    --     [5] = {
    --         order = 5,
    --         numOfTrophy = 250,
    --         name = "ordinary unknown",
    --         isGet = false,
    --         isUnlock = false
    --     },
    --     [6] = {
    --         order = 6,
    --         numOfTrophy = 300,
    --         name = "epic treasure chest",
    --         isGet = false,
    --         isUnlock = false
    --     },
    --     [7] = {
    --         order = 7,
    --         numOfTrophy = 350,
    --         name = "rare unknown",
    --         isGet = false,
    --         isUnlock = false
    --     },
    --     [8] = {
    --         order = 8,
    --         numOfTrophy = 400,
    --         name = "legendary treasure chest",
    --         isGet = false,
    --         isUnlock = false
    --     },
    --     [9] = {
    --         order = 9,
    --         numOfTrophy = 450,
    --         name = "epic unknown",
    --         isGet = false,
    --         isUnlock = false
    --     },
    --     [10] = {
    --         order = 10,
    --         numOfTrophy = 500,
    --         name = "legendary unknown",
    --         isGet = false,
    --         isUnlock = false
    --     },
    -- }
end

--[[--
    @description: 用于测试，生成队伍信息
    @param none
    @return type: table 返回一个队伍信息构成的列表
]]
function TestDataFactory:getTeamDataTest()
    local battleTeam = {}
    for i = 1, 5 do
        table.insert(battleTeam, self:getRandomCard(i))
    end
    return battleTeam
    --return {
    --    [1] = {
    --        name = "01",
    --        type = "attack",
    --        level = "1",
    --        location = 1
    --    },
    --    [2] = {
    --        name = "02",
    --        type = "assist",
    --        level = "2",
    --        location = 2
    --    },
    --    [3] = {
    --        name = "03",
    --        type = "control",
    --        level = "3",
    --        location = 3
    --    },
    --    [4] = {
    --        name = "04",
    --        type = "disturb",
    --        level = "4",
    --        location = 4
    --    },
    --    [5] = {
    --        name = "05",
    --        type = "attack",
    --        level = "5",
    --        location = 5
    --    },
    --
    --}
end

function TestDataFactory:getRewardNodesTest()
    return {
        50,
        100,
        150,
        200,
        250,
        300,
        350,
        400,
        450,
        500,
    }
end

function TestDataFactory:getChestRewardData()
    return {
        name = "rare treasure chest",
        coinNum = 1230,
        RNumberFloor = 130,
        RNumberUpper = 130,
        SRNumberFloor = 40,
        SRNumberUpper = 40,
        SSRNumberFloor = 7,
        SSRNumberUpper = 7,
        URNumberFloor = 0,
        URNumberUpper = 1
    }
end

function TestDataFactory:getOpenChestItemData()
    return {
        coinNum = 3200,
        diamondNum = 1200,
        [1] = {
            name = "1",
            rarity = "普通",
            number = 34,
        },
        [2] = {
            name = "2",
            rarity = "普通",
            number = 21,
        },
        [3] = {
            name = "3",
            rarity = "普通",
            number = 17,
        },
        [4] = {
            name = "5",
            rarity = "普通",
            number = 15,
        },
        [5] = {
            name = "11",
            rarity = "稀有",
            number = 9,
        },
        [6] = {
            name = "12",
            rarity = "稀有",
            number = 6,
        },
        [7] = {
            name = "16",
            rarity = "史诗",
            number = 3,
        },
        [8] = {
            name = "19",
            rarity = "传说",
            number = 1,
        }
    }
end

function TestDataFactory:getRandomInTable(table)
    return table[math.random(#(table))]
end

function TestDataFactory:getRandomCardReward(location, trophyCondition)
    local data = CardReward.new(self:getRandomInTable(ConstDef.TOWER_TYPE))
    data:setReward(
            "randomCard",
            ConstDef.REWARD_TYPE.CARD,
            location,
            math.random(2) and 1,
            math.random(2) and 1,
            trophyCondition,
            math.random(10)
    )
    return data
end

function TestDataFactory:getRandomCurrencyReward(location)
    local data = CurrencyReward.new(self:getRandomInTable(ConstDef.CURRENCY_TYPE))
    data:setReward(
            "randomCurrency",
            ConstDef.REWARD_TYPE.CURRENCY,
            location,
            math.random(2) and 1,
            math.random(2) and 1,
            trophyCondition,
            math.random(999999)
    )
    return data
end

function TestDataFactory:getRandomTreasureBoxReward(location)
    local data = TreasureBoxReward.new(self:getRandomInTable(ConstDef.TREASUREBOX_RARITY))
    data:setReward(
            "randomTreasureBoxReward",
            ConstDef.REWARD_TYPE.TREASUREBOX,
            location,
            math.random(2) and 1,
            math.random(2) and 1,
            trophyCondition,
            1
    )
    return data
end

function TestDataFactory:getRandomCard(location)
    local data = Card.new(
            "randomCard",
            self:getRandomInTable(ConstDef.TOWER_RARITY),
            self:getRandomInTable(ConstDef.TOWER_TYPE),
            math.random(100), --atk
            self:getRandomInTable(ConstDef.TOWER_ATK_TARGET),
            math.random(),
            math.random(),
            math.random(),
            math.random(), -- firecd
            math.random(),
            math.random(),
            {}, --skills
            math.random(),
            math.random(),
            math.random(),
            location
    )
    return data
end

return TestDataFactory