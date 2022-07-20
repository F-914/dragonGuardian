--[[--
    该类用于创建测试数据，仅用于测试
    TestDataFactory.lua
]]
local TestDataFactory = {}

--local
local ConstDef = require("app.def.ConstDef")
local Card = require("app.data.Card")
local Shop = require("app.data.Shop")
local Commodity = require("app.data.Commodity")
local TreasureBox = require("app.data.TreasureBox")
local Currency = require("app.data.Currency")
local Log = require("app.utils.Log")
--

--[[--
    @description:该函数仅用于测试
    @return 返回一个用于测试的奖品列表
]]
function TestDataFactory:getLadderTest()
    local Ladder = require("src/app/data/Ladder.lua")
    local Reward = require("src/app/data/Reward.lua")
    return Ladder.new({
        Reward.new("cjb", 1, 1, false, false, 50, 1, Currency.new(1, 500)),
        Reward.new("cjb", 2, 2, false, false, 100, 1, Card.new(1, "cjb", 3, 1, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12)),
        Reward.new("cjb", 3, 3, false, false, 150, 1, TreasureBox.new("cjb", 3, "cjb")),
        Reward.new("cjb", 3, 4, false, false, 200, 1, TreasureBox.new("cjb", 4, "cjb")),
        Reward.new("cjb", 1, 5, true, false, 250, 1, Currency.new(1, 10000)),
        Reward.new("cjb", 2, 6, true, false, 300, 1, Card.new(1, "cjb", 4, 2, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12)),
        Reward.new("cjb", 3, 7, true, false, 350, 1, TreasureBox.new("cjb", 4, "cjb")),
        Reward.new("cjb", 3, 8, true, false, 400, 1, TreasureBox.new("cjb", 3, "cjb")),
        Reward.new("cjb", 1, 9, true, false, 450, 1, Currency.new(2, 1500)),
        Reward.new("cjb", 2, 10, true, false, 500, 1, Card.new(1, "cjb", 3, 3, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12)),
    })
end

--[[--
    @description: 用于测试，生成队伍信息
    @param none
    @return type: table 返回一个队伍信息构成的列表
]]
function TestDataFactory:getTeamDataTest()
    local BattleTeam = require("src/app/data/BattleTeam.lua")
    return BattleTeam.new({
        {
            1,2,3,4,5
        },
        {
            1,2,3,4,5
        },
        {
            1,2,3,4,5
        },
    }, 1)
end
function TestDataFactory:getCardListTest()
    return {
        Card.new(1, "cjb", 1,1, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(2, "cjb", 2,2, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(3, "cjb", 3,2, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(4, "cjb", 4,1, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(5, "cjb", 4,2, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(6, "cjb", 4,3, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(7, "cjb", 2,3, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(8, "cjb", 1,4, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(9, "cjb", 2,3, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
        Card.new(10, "cjb", 1,1, 7, 12, 100, "sb",
                10, 10, 10,10,10, {}, 100, 12),
    }
end
--function TestDataFactory:getRandomInTable(table)
--    return table[math.random(#(table))]
--end
--
--function TestDataFactory:getRandomCardReward(location, trophyCondition)
--    local data = CardReward.new(self:getRandomInTable(ConstDef.TOWER_TYPE))
--    data:setReward(
--            "randomCard",
--            ConstDef.REWARD_TYPE.CARD,
--            location,
--            math.random(2) and 1,
--            math.random(2) and 1,
--            trophyCondition,
--            math.random(10)
--    )
--    return data
--end
--
--function TestDataFactory:getRandomCurrencyReward(location)
--    local data = CurrencyReward.new(self:getRandomInTable(ConstDef.CURRENCY_TYPE))
--    data:setReward(
--            "randomCurrency",
--            ConstDef.REWARD_TYPE.CURRENCY,
--            location,
--            math.random(2) and 1,
--            math.random(2) and 1,
--            trophyCondition,
--            math.random(999999)
--    )
--    return data
--end
--
--function TestDataFactory:getRandomTreasureBoxReward(location)
--    local data = TreasureBoxReward.new(self:getRandomInTable(ConstDef.TREASUREBOX_RARITY))
--    data:setReward(
--            "randomTreasureBoxReward",
--            ConstDef.REWARD_TYPE.TREASUREBOX,
--            location,
--            math.random(2) and 1,
--            math.random(2) and 1,
--            trophyCondition,
--            1
--    )
--    return data
--end
--
--function TestDataFactory:getRandomCard(location)
--    local data = Card.new(
--            "randomCard",
--            self:getRandomInTable(ConstDef.TOWER_RARITY),
--            self:getRandomInTable(ConstDef.TOWER_TYPE),
--            math.random(100), --atk
--            self:getRandomInTable(ConstDef.TOWER_ATK_TARGET),
--            math.random(),
--            math.random(),
--            math.random(),
--            math.random(), -- firecd
--            math.random(),
--            math.random(),
--            {}, --skills
--            math.random(),
--            math.random(),
--            math.random(),
--            location
--    )
--    return data
--end

function TestDataFactory:getTestCommodity()

end

function TestDataFactory:getTestCoinShop()
    local commodityList = {
        Commodity.new(
                "免费金币",
                ConstDef.COMMODITY_TYPE.CURRENCY,
                0,
                ConstDef.CURRENCY_TYPE.COIN,
                1000,
                Currency.new(
                        ConstDef.CURRENCY_TYPE.DIAMOND,
                        999
                -- 当货币作为Commodity时，以Commodity中的Amount为准
                )
        ),
        Commodity.new(
                "是龙？是卡？是防御塔？",
                ConstDef.COMMODITY_TYPE.TOWER,
                0,
                ConstDef.CURRENCY_TYPE.COIN,
                35,
                Card.new(
                        math.random(20),
                        "平平无奇防御塔",
                        ConstDef.TOWER_RARITY.R,
                        ConstDef.TOWER_TYPE.ATTACK,
                        math.random(10),
                        0,
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
                )
        ),
        Commodity.new("是龙？是卡？是防御塔？",
                ConstDef.COMMODITY_TYPE.TOWER,
                350,
                ConstDef.CURRENCY_TYPE.COIN,
                135,
                Card.new(
                        math.random(20),
                        "平平无奇防御塔",
                        ConstDef.TOWER_RARITY.R,
                        ConstDef.TOWER_TYPE.ATTACK,
                        math.random(10),
                        0,
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
                )),
        Commodity.new("塔塔开！",
                ConstDef.COMMODITY_TYPE.TOWER,
                999,
                ConstDef.CURRENCY_TYPE.COIN,
                1,
                Card.new(
                        math.random(20),
                        "Alan",
                        ConstDef.TOWER_RARITY.R,
                        ConstDef.TOWER_TYPE.ATTACK,
                        math.random(10),
                        0,
                        math.random(100),
                        ConstDef.TOWER_ATK_TARGET.HP_FIRST,
                        math.random(100),
                        math.random(100),
                        math.random(100),
                        math.random(100),
                        math.random(100),
                        {},
                        math.random(100),
                        0.00,
                        3,
                        2
                )),
        Commodity.new("BT7274",
                ConstDef.COMMODITY_TYPE.TOWER,
                1000,
                ConstDef.CURRENCY_TYPE.COIN,
                1,
                Card.new(
                        math.random(20),
                        "BT7274",
                        ConstDef.TOWER_RARITY.R,
                        ConstDef.TOWER_TYPE.ATTACK,
                        math.random(10),
                        0,
                        math.random(100),
                        ConstDef.TOWER_ATK_TARGET.FRONT,
                        9999,
                        math.random(100),
                        math.random(100),
                        math.random(100),
                        math.random(100),
                        {},
                        math.random(100),
                        0.00,
                        2,
                        3
                )),
        Commodity.new("托尔",
                ConstDef.COMMODITY_TYPE.TOWER,
                350,
                ConstDef.CURRENCY_TYPE.COIN,
                1,
                Card.new(
                        math.random(20),
                        "龙女仆托尔捏",
                        ConstDef.TOWER_RARITY.R,
                        ConstDef.TOWER_TYPE.ATTACK,
                        math.random(10),
                        0,
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
                        5
                )),
    }
    local freshTime = "72:74"
    local coinShop = Shop.new(commodityList, freshTime)
    Log.i("coinShop is nullptr ? " .. tostring(coinShop == nil))
    return coinShop
end

function TestDataFactory:getTestDiamondShop()
    local commodityList = {
        Commodity.new(
                "普通宝箱",
                ConstDef.COMMODITY_TYPE.TREASUREBOX,
                250,
                ConstDef.CURRENCY_TYPE.DIAMOND,
                1,
                TreasureBox.new(
                        "超级无敌普通宝箱",
                        ConstDef.TREASUREBOX_RARITY.R,
                        "只是一个普通宝箱捏"
                )
        ),
        Commodity.new(
                "稀有宝箱",
                ConstDef.COMMODITY_TYPE.TREASUREBOX,
                500,
                ConstDef.CURRENCY_TYPE.DIAMOND,
                1,
                TreasureBox.new(
                        "超级无敌劈里啪啦稀有宝箱",
                        ConstDef.TREASUREBOX_RARITY.SR,
                        "只是一个稀有宝箱捏"
                )
        ),
        Commodity.new(
                "史诗宝箱",
                ConstDef.COMMODITY_TYPE.TREASUREBOX,
                500,
                ConstDef.CURRENCY_TYPE.DIAMOND,
                1,
                TreasureBox.new(
                        "宇宙第一超级无敌劈里啪啦史诗宝箱",
                        ConstDef.TREASUREBOX_RARITY.SSR,
                        "只是一个史诗宝箱捏"
                )
        ),
        Commodity.new(
                "传说宝箱",
                ConstDef.COMMODITY_TYPE.TREASUREBOX,
                500,
                ConstDef.CURRENCY_TYPE.DIAMOND,
                1,
                TreasureBox.new(
                        "%￥……&%……&￥……（*￥……宇宙第一超级无敌劈里啪啦传说宝箱",
                        ConstDef.TREASUREBOX_RARITY.UR,
                        "只是一个传说宝箱捏"
                )
        ),
    }
    -- 刷新时间不能有啊不能有
    local freshTime = nil
    local diamondShop = Shop.new(commodityList, freshTime)
    return diamondShop
end

return TestDataFactory
