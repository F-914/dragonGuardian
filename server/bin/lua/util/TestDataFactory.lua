--[[--
    这个就是个生成测试数据的
    TestDataFactory.lua
]]
local TestDataFactory = {}
function TestDataFactory:createUserInfo(loginName)
    return {
        userInfoAccount = loginName,
        userInfoAvatar = "home/top_player_info/default_avatar.png",
        userInfoNickName = "黑山老妖12138",
        userInfoCoinAmount = 123456,
        userInfoDiamondAmount = 78000,
        userInfoTrophyAmount = 201,
        userInfoBattleTeam = {
            team = {
                {1, 2, 3, 4, 5},
                {1, 2, 3, 4, 5},
                {1, 2, 3, 4, 5}
            },
            standByTeam = 1,
        },
        userInfoLadder = {
            ladderList = {
                [1] = {
                    rewardName = "cjb", rewardType = 1, rewardLocation = 1,
                    locked = false, received = false, trophyCondition = 50,
                    rewardAmount = 1, reward = {
                        currencyType = 1,
                        currencyAmount = 1200,
                    }
                },
                [2] = {
                    rewardName = "cjb", rewardType = 2, rewardLocation = 2,
                    locked = false, received = false, trophyCondition = 100,
                    rewardAmount = 1, reward = {
                        cardId = 1, cardName = "cjb", cardRarity = 1,
                        cardType = 1, cardLevel = 2, cardAmount = 12,
                        cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                        cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                        cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                        cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                        cardLocation = nil
                    }
                },
                [3] = {
                    rewardName = "cjb", rewardType = 3, rewardLocation = 3,
                    locked = false, received = false, trophyCondition = 150,
                    rewardAmount = 1, reward = {
                        treasureBoxName = "cjb",
                        treasureBoxType = 3,
                        treasureBoxDescription = "cjb",
                    }
                },
                [4] = {
                    rewardName = "cjb", rewardType = 3, rewardLocation = 4,
                    locked = false, received = false, trophyCondition = 200,
                    rewardAmount = 1, reward = {
                        treasureBoxName = "cjb",
                        treasureBoxType = 4,
                        treasureBoxDescription = "cjb",
                    }
                },
                [5] = {
                    rewardName = "cjb", rewardType = 1, rewardLocation = 5,
                    locked = true, received = false, trophyCondition = 250,
                    rewardAmount = 1, reward = {
                        currencyType = 1,
                        currencyAmount = 10000,
                    }
                },
                [6] = {
                    rewardName = "cjb", rewardType = 2, rewardLocation = 6,
                    locked = true, received = false, trophyCondition = 300,
                    rewardAmount = 1, reward = {
                        cardId = 3, cardName = "cjb", cardRarity = 3,
                        cardType = 1, cardLevel = 2, cardAmount = 12,
                        cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                        cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                        cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                        cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                        cardLocation = nil
                    }
                },
                [7] = {
                    rewardName = "cjb", rewardType = 3, rewardLocation = 7,
                    locked = true, received = false, trophyCondition = 350,
                    rewardAmount = 1, reward = {
                        treasureBoxName = "cjb",
                        treasureBoxType = 3,
                        treasureBoxDescription = "cjb",
                    }
                },
                [8] = {
                    rewardName = "cjb", rewardType = 3, rewardLocation = 8,
                    locked = true, received = false, trophyCondition = 400,
                    rewardAmount = 1, reward = {
                        treasureBoxName = "cjb",
                        treasureBoxType = 4,
                        treasureBoxDescription = "cjb",
                    }
                },
                [9] = {
                    rewardName = "cjb", rewardType = 1, rewardLocation = 9,
                    locked = true, received = false, trophyCondition = 450,
                    rewardAmount = 1, reward = {
                        currencyType = 2,
                        currencyAmount = 1200,
                    }
                },
                [10] = {
                    rewardName = "cjb", rewardType = 2, rewardLocation = 10,
                    locked = false, received = false, trophyCondition = 500,
                    rewardAmount = 1, reward = {
                        cardId = 5, cardName = "cjb", cardRarity = 3,
                        cardType = 1, cardLevel = 2, cardAmount = 12,
                        cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                        cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                        cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                        cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                        cardLocation = nil
                    }
                },
            }
        },
        userInfoCardList = {
            [1] = {
                cardId = 1, cardName = "cjb", cardRarity = 1,
                cardType = 1, cardLevel = 1, cardAmount = 12,
                cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                cardLocation = nil
            },
            [2] = {
                cardId = 2, cardName = "cjb", cardRarity = 1,
                cardType = 1, cardLevel = 6, cardAmount = 12,
                cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                cardLocation = nil
            },
            [3] = {
                cardId = 3, cardName = "cjb", cardRarity = 1,
                cardType = 1, cardLevel = 6, cardAmount = 12,
                cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                cardLocation = nil
            },
            [4] = {
                cardId = 4, cardName = "cjb", cardRarity = 1,
                cardType = 1, cardLevel = 7, cardAmount = 12,
                cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                cardLocation = nil
            },
            [5] = {
                cardId = 5, cardName = "cjb", cardRarity = 1,
                cardType = 1, cardLevel = 8, cardAmount = 12,
                cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                cardLocation = nil
            },
            [6] = {
                cardId = 6, cardName = "cjb", cardRarity = 1,
                cardType = 1, cardLevel = 9, cardAmount = 12,
                cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                cardLocation = nil
            },
        }
    }
end
function TestDataFactory:createCoinShop()
    return {
        commodityList = {
            [1] = {
                commodityName = "cjb",
                commodityType = 2,
                commodityPrice = 0,
                commodityPriceUnit = "",
                commodityAmount = 1,
                commodityCommodity = {
                    currencyType = 2,
                    currencyAmount = 1200
                }
            },
            [2] = {
                commodityName = "cjb",
                commodityType = 1,
                commodityPrice = 1000,
                commodityPriceUnit = "",
                commodityAmount = 1,
                commodityCommodity = {
                    cardId = 1, cardName = "cjb", cardRarity = 1,
                    cardType = 1, cardLevel = 2, cardAmount = 1,
                    cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                    cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                    cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                    cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                    cardLocation = nil
                }
            },
            [3] = {
                commodityName = "cjb",
                commodityType = 1,
                commodityPrice = 1500,
                commodityPriceUnit = "",
                commodityAmount = 12,
                commodityCommodity = {
                    cardId = 2, cardName = "cjb", cardRarity = 1,
                    cardType = 1, cardLevel = 2, cardAmount = 1,
                    cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                    cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                    cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                    cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                    cardLocation = nil
                }
            },
            [4] = {
                commodityName = "cjb",
                commodityType = 1,
                commodityPrice = 2000,
                commodityPriceUnit = "",
                commodityAmount = 12,
                commodityCommodity = {
                    cardId = 4, cardName = "cjb", cardRarity = 1,
                    cardType = 1, cardLevel = 2, cardAmount = 1,
                    cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                    cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                    cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                    cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                    cardLocation = nil
                }
            },
            [5] = {
                commodityName = "cjb",
                commodityType = 1,
                commodityPrice = 2500,
                commodityPriceUnit = "",
                commodityAmount = 12,
                commodityCommodity = {
                    cardId = 5, cardName = "cjb", cardRarity = 1,
                    cardType = 1, cardLevel = 2, cardAmount = 1,
                    cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                    cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                    cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                    cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                    cardLocation = nil
                }
            },
            [6] = {
                commodityName = "cjb",
                commodityType = 1,
                commodityPrice = 3000,
                commodityPriceUnit = "",
                commodityAmount = 12,
                commodityCommodity = {
                    cardId = 6, cardName = "cjb", cardRarity = 1,
                    cardType = 1, cardLevel = 2, cardAmount = 1,
                    cardSkills = {}, cardAtk = 200, cardAtkTarget = 1,
                    cardAtkUpgrade = 21, cardAtkEnhance = 21, cardExtraDamage = 100,
                    cardFireCd = 0.9, cardFireCdEnhance = 0.01,
                    cardFireCdUpgrade = 0.01, cardFatalityRate = 12,
                    cardLocation = nil
                }
            },
        },
        freshTime = "19:23"
    }
end
function TestDataFactory:createDiamondShop()
    return {
        commodityList = {
            [1] = {
                commodityName = "cjb",
                commodityType = 3,
                commodityPrice = 100,
                commodityPriceUnit = "",
                commodityAmount = 1,
                commodityCommodity = {
                    treasureBoxName = "cjb",
                    treasureBoxType = 1,
                    treasureBoxDescription = "cjb"
                },
            },
            [2] = {
                commodityName = "cjb",
                commodityType = 3,
                commodityPrice = 300,
                commodityPriceUnit = "",
                commodityAmount = 1,
                commodityCommodity = {
                    treasureBoxName = "cjb",
                    treasureBoxType = 2,
                    treasureBoxDescription = "cjb"
                },
            },
            [3] = {
                commodityName = "cjb",
                commodityType = 3,
                commodityPrice = 600,
                commodityPriceUnit = "",
                commodityAmount = 1,
                commodityCommodity = {
                    treasureBoxName = "cjb",
                    treasureBoxType = 3,
                    treasureBoxDescription = "cjb"
                },
            },
            [4] = {
                commodityName = "cjb",
                commodityType = 3,
                commodityPrice = 900,
                commodityPriceUnit = "",
                commodityAmount = 1,
                commodityCommodity = {
                    treasureBoxName = "cjb",
                    treasureBoxType = 4,
                    treasureBoxDescription = "cjb"
                },
            },
        },
        freshTime = "73:23"
    }
end
return TestDataFactory