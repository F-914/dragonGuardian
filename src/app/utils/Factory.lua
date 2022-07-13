--[[--
    工厂模式的工厂实现
    之所以创建这个工具类，是因为能够避免大量重复代码的编写
    Factory.lua
]]
local Factory = {}
--local
local TypeConvert = require("app.utils.TypeConvert")
local OutGameData = require("app.data.OutGameData")
local ConstDef = require("app.def.ConstDef")
--
--[[--
    @description: 创建用于宝箱奖励的贴图
    @data type:table, 奖励的数据
    @return type:Array, 返回一个由精灵组成的数组
]]
function Factory:createChestRewardTower(data)
    local arr = {}
    local count = 1
    for _, ele in ipairs(data) do
        local sprite = display.newSprite("res/home/general/second_open_treasure_popup/icon_tower/" .. ele.name .. ".png")
        local spSize = sprite:getContentSize()
        local rarityTTF = display.newTTFLabel({
            text = ele.rarity,
            font = "res/font/fzhzgbjw.ttf",
            size = 21,
            color = cc.c3b(255, 255, 255)
        })
        rarityTTF:enableOutline(cc.c4b(20, 20, 66, 255), 2)
        rarityTTF:setPosition(spSize.width * .5, 0 - spSize.height * .2)
        rarityTTF:addTo(sprite)

        local numberTTF = display.newTTFLabel({
            text = "x" .. tostring(ele.number),
            font = "res/font/fzzchjw.ttf",
            size = 21,
            color = cc.c3b(255, 255, 255)
        })
        numberTTF:enableOutline(cc.c4b(0, 0, 0, 255), 4)
        numberTTF:setPosition(spSize.width * .9, spSize.height * .9)
        numberTTF:addTo(sprite)

        arr[count] = sprite
        count = count + 1
    end
    return arr
end

--[[--
    @description: 用于从精灵列表创建一个队伍精灵
    @param teamData type: table 用于创建精灵的数组
    @return type:map key = towerData value = TowerSprite 精灵构成的列表
]]
function Factory:createTeamSprite(teamData)
    local mapSprites = {}
    for i = 1, #teamData do
        local cardId = teamData[i]
        local cardData = OutGameData:getUserInfo():getCardList()[cardId]
        --解决循环嵌套
        local towerSprite = require("src/app/ui/node/TowerSprite.lua").new("res/home/general/icon_tower/" ..
                TypeConvert.Integer2StringLeadingZero(cardId, 2) .. ".png", cardData)
        mapSprites[cardData] = towerSprite
    end
    return mapSprites
end

--[[--
    @description: 从名称创建一个代表塔类型的精灵
    @param type:string 塔类型的名称
    @return type:Sprite, 代表塔类型的精灵
]]
function Factory:createTowerType(name)
    local sprite = display.newSprite(ConstDef.ICON_SUBINSTANCE_TOWER_LIST_TYPE[name])
    return sprite
end

--[[--
    @description: 从等级信息创建一个代表塔等级的精灵
    @param type:string 代表塔等级的字符串
    @return type:Sprite 表示塔等级的精灵
]]
function Factory:createTowerLevel(level)
    local sprite = display.newSprite("res/home/guide/subinterface_tower_list/level/Lv." .. level .. ".png")
    return sprite
end

--[[--
    @description: 根据解锁状态确定边框
    @param none
    @return none
]]
function Factory:createBorder(rewardData)
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
function Factory:createBorderStateSprite(locked, received)
    if locked then
        local unlockSp = display.newSprite("res/home/battle/high_ladder/locked.png")
        return unlockSp
    else
        if received then
            local lockSp = display.newSprite("res/home/battle/high_ladder/130.png")
            return lockSp
        else
            return nil
        end
    end
end

--[[--
    @description: 赶回一个奖品列表对应的按钮或者精灵列表
    @param type:table 奖励的列表
    @return type:map key rewardData, value rewardSprite
]]
function Factory:createRewardList(ladderList)
    local rewardsMap = {}
    for i = 1, #ladderList do
        local rewardData = ladderList[i]
        local rewardSprite = self:createBorder(rewardData)
        rewardsMap[rewardData] = rewardSprite
    end
    return rewardsMap
end

---该方法待重写,暂时不能用
--[[--
    @description: 通过奖励的数据返回对应的按钮
    @param rewardData type:table 奖励的信息
    @return type: Button 返回一个按钮
]]
function Factory:createRewardButton(rewardName, rewardType)
    --local button = ccui.Button:create(ConstDef.ICON_REWARD[rewardType])
    if rewardName == "gold" then
        local button = ccui.Button:create("res/home/battle/high_ladder/coin.png")
        return button
    elseif rewardName == "diamond" then
        local button = ccui.Button:create("res/home/battle/high_ladder/diamond.png")
        return button
    elseif rewardName == "ordinary treasure chest" then
        local button = ccui.Button:create("res/home/general/second_open_confirm_popup/icon_box_normal.png")
        button:setScale(0.5)
        return button
    elseif rewardName == "rare treasure chest" then
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

--[[--
    @description: 通过奖励的名称创建对应的精灵
    @param name type: string 奖励的名称
    @return type:sprite 对应的精灵
]]
function Factory:createRewardSprite(name)
    if name == "gold" then
        local sprite = display.newSprite("res/home/battle/high_ladder/coin.png")
        return sprite
    elseif name == "diamond" then
        local sprite = display.newSprite("res/home/battle/high_ladder/diamond.png")
        return sprite
    elseif name == "ordinary treasure chest" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_box_normal.png")
        sprite:setScale(0.5)
        return sprite
    elseif name == "rare treasure chest" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_box_rare.png")
        sprite:setScale(0.5)
        return sprite
    elseif name == "epic treasure chest" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_box_epic.png")
        sprite:setScale(0.5)
        return sprite
    elseif name == "legendary treasure chest" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_box_legend.png")
        sprite:setScale(0.5)
        return sprite
    elseif name == "ordinary unknown" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_normal.png")
        return sprite
    elseif name == "rare unknown" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_rare.png")
        return sprite
    elseif name == "epic unknown" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_epic.png")
        return sprite
    elseif name == "legendary unknown" then
        local sprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_legend.png")
        return sprite
    end
end

--[[--
    @description 根据宝箱名称创建对应的宝箱名称精灵
    @param name type:name 宝箱名称
    @return type: sprite 代表宝箱名称的精灵
]]
function Factory:createChestFontSprite(name)
    if name == "ordinary treasure chest" then
        local fontSprite = display.newSprite("res/home/general/second_open_confirm_popup/title_box_normal.png")
        return fontSprite
    elseif name == "rare treasure chest" then
        local fontSprite = display.newSprite("res/home/general/second_open_confirm_popup/title_box_rare.png")
        return fontSprite
    elseif name == "epic treasure chest" then
        local fontSprite = display.newSprite("res/home/general/second_open_confirm_popup/title_box_epic.png")
        return fontSprite
    elseif name == "legendary treasure chest" then
        local fontSprite = display.newSprite("res/home/general/second_open_confirm_popup/title_box_legend.png")
        return fontSprite
    else
        return nil
    end
end

--[[--
    @description: 根据宝箱的数据创建宝箱奖励面板
    @param 宝箱奖励数据
    @return type:Layout, 奖励的面板
]]
function Factory:createChestRewardPane(chestRewardData)
    local layout = ccui.Layout:create()
    layout:setBackGroundColorType(3)
    layout:setContentSize(display.width * .66, display.height * .16)
    layout:setAnchorPoint(.5, .5)
    local size = layout:getContentSize()

    local baseCoinContainer = display.newSprite("res/home/general/second_open_confirm_popup/base_coin.png")
    baseCoinContainer:setPosition(size.width * .1, size.height * .45)
    baseCoinContainer:addTo(layout)

    local coinContainerSize = baseCoinContainer:getContentSize()

    local coinSprite = display.newSprite("res/home/general/second_open_confirm_popup/icon_coin.png")
    coinSprite:setPosition(coinContainerSize.width * .5, coinContainerSize.height * .6)
    coinSprite:addTo(baseCoinContainer)

    local coinNumTTF = display.newTTFLabel({
        text = tostring(chestRewardData.coinNum),
        font = "res/font/fzbiaozjw.ttf",
        size = 24,
        color = cc.c3b(165, 237, 255)
    })
    coinNumTTF:setPosition(coinContainerSize.width * .5, coinContainerSize.height * .25)
    coinNumTTF:enableOutline(cc.c4b(0, 0, 0, 0), 1)
    coinNumTTF:addTo(baseCoinContainer)

    local pSize = { width = size.width * .3, height = size.height * .4 }
    local layoutR = self:createChestRewardItem(pSize, chestRewardData.RNumberFloor,
            chestRewardData.RNumberUpper, "ordinary")
    local layoutSR = self:createChestRewardItem(pSize, chestRewardData.SRNumberFloor,
            chestRewardData.SRNumberUpper, "rare")
    local layoutSSR = self:createChestRewardItem(pSize, chestRewardData.SSRNumberFloor,
            chestRewardData.SSRNumberUpper, "epic")
    local layoutUR = self:createChestRewardItem(pSize, chestRewardData.URNumberFloor,
            chestRewardData.URNumberUpper, "legend")
    layoutR:setPosition(size.width * .45, size.height * .65)
    layoutSR:setPosition(size.width * .85, size.height * .65)
    layoutSSR:setPosition(size.width * .45, size.height * .2)
    layoutUR:setPosition(size.width * .85, size.height * .2)
    layoutR:addTo(layout)
    layoutSR:addTo(layout)
    layoutSSR:addTo(layout)
    layoutUR:addTo(layout)
    return layout
end

--[[--
    @description:作为上面函数的辅助，减少代码重复度
    @param size type:table 这部分奖励的所占的区域
    @param numFloor type:number, 奖励数量的下限
    @param numUpper type:number, 奖励数量的上限
    @param rarity type:string, 奖励的品质
    @return type sprite, 返回一个代表奖励的精灵
]]
function Factory:createChestRewardItem(size, numFloor, numUpper, rarity)
    local layout = ccui.Layout:create()
    layout:setBackGroundColorType(3)
    layout:setAnchorPoint(.5, .5)
    layout:setContentSize(size.width, size.height)

    local textureLocation = nil
    local displayRarityFont = nil
    local FontColor = nil
    local displayRewordNumStr = nil
    if rarity == "ordinary" then
        textureLocation = "res/home/general/second_open_confirm_popup/icon_normal.png"
        displayRarityFont = "普通"
        FontColor = {
            r = 214,
            g = 214,
            b = 231
        }
    elseif rarity == "rare" then
        textureLocation = "res/home/general/second_open_confirm_popup/icon_rare.png"
        displayRarityFont = "稀有"
        FontColor = {
            r = 79,
            g = 187,
            b = 245
        }
    elseif rarity == "epic" then
        textureLocation = "res/home/general/second_open_confirm_popup/icon_epic.png"
        displayRarityFont = "史诗"
        FontColor = {
            r = 210,
            g = 102,
            b = 249
        }
    elseif rarity == "legend" then
        textureLocation = "res/home/general/second_open_confirm_popup/icon_legend.png"
        displayRarityFont = "传说"
        FontColor = {
            r = 250,
            g = 198,
            b = 17
        }
    else
        textureLocation = "res/home/general/second_open_confirm_popup/icon_legend.png"
        displayRarityFont = "传说"
        FontColor = {
            r = 250,
            g = 198,
            b = 17
        }
    end
    if numFloor == numUpper then
        displayRewordNumStr = "x " .. numUpper
    else
        displayRewordNumStr = "x " .. numFloor .. "-" .. numUpper
    end

    local itemSprite = display.newSprite(textureLocation)
    itemSprite:setPosition(size.width * .25, size.height * .5)
    itemSprite:addTo(layout)

    local textContainerSpriteUp = display.newSprite("res/home/general/second_open_confirm_popup/base_text.png")
    textContainerSpriteUp:setPosition(size.width * .9, size.height * .7)
    textContainerSpriteUp:addTo(layout)

    local textContainerSpriteDown = display.newSprite("res/home/general/second_open_confirm_popup/base_text.png")
    textContainerSpriteDown:setPosition(size.width * .9, size.height * .3)
    textContainerSpriteDown:addTo(layout)

    local rarityTTF = display.newTTFLabel({
        text = displayRarityFont,
        font = "res/font/fzbiaozjw.ttf",
        size = 20,
        color = cc.c3b(FontColor.r, FontColor.g, FontColor.b)
    })
    rarityTTF:setPosition(size.width * .9, size.height * .72)
    rarityTTF:enableOutline(cc.c4b(20, 20, 66, 255), 2)
    rarityTTF:addTo(layout)

    local numberTTF = display.newTTFLabel({
        text = displayRewordNumStr,
        font = "res/font/fzbiaozjw.ttf",
        size = 20,
        color = cc.c3b(FontColor.r, FontColor.g, FontColor.b)
    })
    numberTTF:setPosition(size.width * .9, size.height * .3)
    numberTTF:enableOutline(cc.c4b(0, 0, 0, 255), 1)
    numberTTF:addTo(layout)
    return layout
end

return Factory
