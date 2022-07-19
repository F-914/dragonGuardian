--[[--
    该类用于创建奖品列表的精灵
    CreateSpriteUtil.lua
]]
--local TowerSprite = require("src/app/ui/node/TowerSprite.lua")
--local RewardSprite = require("src/app/ui/node/RewardSprite.lua")
--------------
---该类已基本弃用
---如果哪里有使用,请告诉我(幸周)
-------------
local CreateSpriteUtil = {}
--[[--
    @description:该函数仅用于测试
    @return 返回一个用于测试的奖品列表
]]
function CreateSpriteUtil:getRewardDataTest()
    return {
        [1] = {
            name = "gold",
            quantity = 400,
            isGet = true,
            isUnlock = true
        },
        [2] = {
            name = "ordinary treasure chest",
            isGet = true,
            isUnlock = true
        },
        [3] = {
            name = "diamond",
            quantity = 400,
            isGet = false,
            isUnlock = true
        },
        [4] = {
            name = "rare treasure chest",
            isGet = false,
            isUnlock = false
        },
        [5] = {
            name = "ordinary unknown",
            --quantity = 400,
            isGet = false,
            isUnlock = false
        },
        [6] = {
            name = "epic treasure chest",
            isGet = false,
            isUnlock = false
        },
        [7] = {
            name = "rare unknown",
            --quantity = 400,
            isGet = false,
            isUnlock = false
        },
        [8] = {
            name = "legendary treasure chest",
            isGet = false,
            isUnlock = false
        },
        [9] = {
            name = "epic unknown",
            --quantity = 400,
            isGet = false,
            isUnlock = false
        },
        [10] = {
            name = "legendary unknown",
            --quantity = 400,
            isGet = false,
            isUnlock = false
        },
    }
end

--[[--
    @description: 用于测试，生成队伍信息
    @param none
    @return type: table 返回一个队伍信息构成的列表
]]
function CreateSpriteUtil:createTeamTest()
    return {
        [1] = {
            name = "01",
            type = "attack",
            level = "1"
        },
        [2] = {
            name = "02",
            type = "assist",
            level = "2"
        },
        [3] = {
            name = "03",
            type = "control",
            level = "3"
        },
        [4] = {
            name = "04",
            type = "disturb",
            level = "4"
        },
        [5] = {
            name = "05",
            type = "attack",
            level = "5"
        },

    }
end

function CreateSpriteUtil:createRewardNodesTest()
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

--[[--
    @description: 用于从精灵列表创建一个队伍精灵
    @param teamData type: table 用于创建精灵的数组
    @return type:map key = towerData value = TowerSprite 精灵构成的列表
]]
function CreateSpriteUtil:createTeamSprite(teamData)
    local mapSprites = {}
    for i = 1, #teamData do
        local towerData = teamData[i]
        --解决循环嵌套
        local towerSprite = require("src/app/ui/node/TowerSprite.lua").new("res/home/general/icon_tower/" ..
            towerData.name .. ".png", towerData)
        mapSprites[towerData] = towerSprite
    end
    return mapSprites
end

--[[--
    @description: 从名称创建一个塔的精灵，这个应该没用
    @param type:string 名称
    @return type:Sprite 创建的精灵
]]
function CreateSpriteUtil:createTower(name)
    local sprite = display.newSprite("res/home/general/icon_tower/" .. name .. ".png")
    return sprite
end

--[[--
    @description: 从名称创建一个代表塔类型的精灵
    @param type:string 塔类型的名称
    @return type:Sprite, 代表塔类型的精灵
]]
function CreateSpriteUtil:createTowerType(name)
    local sprite = display.newSprite("res/home/guide/subinterface_tower_list/type_" .. name .. ".png")
    return sprite
end

--[[--
    @description: 从等级信息创建一个代表塔等级的精灵
    @param type:string 代表塔等级的字符串
    @return type:Sprite 表示塔等级的精灵
]]
function CreateSpriteUtil:createTowerLevel(level)
    local sprite = display.newSprite("res/home/guide/subinterface_tower_list/level/Lv." .. level .. ".png")
    return sprite
end

--[[--
    @description: 赶回一个奖品列表对应的按钮或者精灵列表
    @param type:table 奖励的列表
    @return type:map key rewardData, value rewardSprite
]]
function CreateSpriteUtil:createRewardList(rewardsData)
    local rewardsMap = {}
    if rewardsData == nil then
        return rewardsMap
    end
    for i = 1, #(rewardsData) do
        local rewardData = rewardsData[i]
        local rewardSprite = self:createBorder(rewardData)
        rewardsMap[rewardData] = rewardSprite
    end
    return rewardsMap
end

--[[--
    @description: 根据解锁状态确定边框
]]
function CreateSpriteUtil:createBorder(rewardData)
    if not rewardData.isUnlock then
        --解决循环嵌套，下同
        local border = require("src/app/ui/node/RewardSprite.lua").new("res/home/battle/high_ladder/locked_blue_border.png"
            , rewardData)
        return border
    else
        if not rewardData.isGet then
            local border = require("src/app/ui/node/RewardSprite.lua").new("res/home/battle/high_ladder/unlocked_unreceived_yellow_border.png"
                , rewardData)
            return border
        else
            local border = require("src/app/ui/node/RewardSprite.lua").new("res/home/battle/high_ladder/can_receive.png"
                , rewardData)
            return border
        end
    end
end

--[[--
    @description:根据领取和解锁状态确定边框是否带有下标
    @param isUnlocked type:bool, 解锁状态
    @param isGet type:isGet, 是否领取
    @return 返回一个表示下标的精灵
]]
function CreateSpriteUtil:getBorderStateSprite(isUnlocked, isGet)
    if not isUnlocked then
        local unlockSp = display.newSprite("res/home/battle/high_ladder/locked.png")
        return unlockSp
    else
        if isGet then
            local lockSp = display.newSprite("res/home/battle/high_ladder/130.png")
            return lockSp
        else
            return nil
        end
    end
end

--[[--
    @description: 通过奖励的数据返回对应的按钮
    @param rewardData type:table 奖励的信息
    @return type: Button 返回一个按钮
]]
function CreateSpriteUtil:createRewardButton(name)
    if name == "gold" then
        local button = ccui.Button:create("res/home/battle/high_ladder/coin.png")
        return button
    elseif name == "diamond" then
        local button = ccui.Button:create("res/home/battle/high_ladder/diamond.png")
        return button
    elseif name == "ordinary treasure chest" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_box_normal.png")
        button:setScale(0.5)
        return button
    elseif name == "rare treasure chest" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_box_rare.png")
        button:setScale(0.5)
        return button
    elseif name == "epic treasure chest" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_box_epic.png")
        button:setScale(0.5)
        return button
    elseif name == "legendary treasure chest" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_box_legend.png")
        button:setScale(0.5)
        return button
    elseif name == "ordinary unknown" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_normal.png")
        return button
    elseif name == "rare unknown" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_rare.png")
        return button
    elseif name == "epic unknown" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_epic.png")
        return button
    elseif name == "legendary unknown" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_legend.png")
        return button
    end
end

return CreateSpriteUtil
