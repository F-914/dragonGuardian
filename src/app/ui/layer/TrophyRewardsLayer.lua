--[[--
    显示用户奖励进度以及奖励领取信息的层
    TrophyRewardsLayer.lua
]]
local TrophyRewardsLayer = class("TrophyRewardsLayer", function()
    return display.newLayer()
end)

--local
local GameData = require("app.test.GameData")
local CalibrateScaleSprite = require("src/app/ui/node/CalibrateScaleSprite.lua")
local Log = require("app.utils.Log")
local Factory = require("src/app/utils/Factory.lua")
local TestDataFactory = require("src/app/test/TestDataFactory.lua")
local OpenTreasureChest2nd = require("src/app/ui/secondaryui/OpenTreasure2nd.lua")
--
--[[--
    @description: 构造方法
    @param none
    @return none
]]
function TrophyRewardsLayer:ctor()
    self.rewardsMap_ = nil -- type: map key = rewardData, value = rewardSprite
    self.calibrateScale_ = nil --type: sprite 用于帧刷新
    self:init()
end

--[[--
    @description:初始化方法
    @param none
    @return none
]]
function TrophyRewardsLayer:init()
    local spriteBG = display.newSprite("res/home/battle/high_ladder/background.png")
    --给的资源就不对称
    spriteBG:setPosition(display.width * .515, display.height * 0.75)
    spriteBG:setScale(1, .7)
    spriteBG:setContentSize(display.width - 20, display.height * .20)
    spriteBG:addTo(self)

    local leftButton = ccui.Button:create("res/home/battle/high_ladder/icon_slide_left.png")
    leftButton:setPosition(50, display.height * .8)
    leftButton:addTouchEventListener(function(sender, eventType)
        print("test left button")
    end)
    leftButton:addTo(self)

    local rightButton = ccui.Button:create("res/home/battle/high_ladder/icon_slide_right.png")
    rightButton:setPosition(display.width - 50, display.height * .8)
    rightButton:addTouchEventListener(function(sender, eventType)
        print("test right button")
    end)
    rightButton:addTo(self)
    --各项属性初始化，暂时保持这样，后面可能会因为需求变化
    self.rewardsMap_ = Factory:createRewardList(GameData.rewards_)
    --构建天梯列表
    local highLadderView = ccui.ListView:create()
    highLadderView:setPosition(70, display.height * .69)
    highLadderView:setAnchorPoint(0, 0)
    highLadderView:setContentSize(display.width - 140, display.height * .18)
    highLadderView:setDirection(2)
    highLadderView:addTo(self)
    --构建进度条
    local calibrateScale = CalibrateScaleSprite.new("res/home/battle/high_ladder/calibrated scale/calibrated_scale.png",
        GameData.userKeyQuantity_)
    Log.i(" userKeyQuantity_ is " .. tostring(GameData.userKeyQuantity_))
    calibrateScale:setAnchorPoint(0, 0)
    calibrateScale:setPosition(12, 15)
    calibrateScale:addTo(highLadderView)
    self.calibrateScale_ = calibrateScale

    local itemLayers = {}
    local spSize = nil
    local count = 1
    for _, node in pairs(self.rewardsMap_) do
        if count == 1 then
            spSize = node:getContentSize()
        end
        local itemLayer = ccui.Layout:create()
        itemLayer:setBackGroundColorType(3)
        itemLayer:setAnchorPoint(.5, .5)
        itemLayer:setContentSize(spSize.width * .8, spSize.height * .8)
        itemLayer:addTo(highLadderView)
        itemLayers[count] = itemLayer
        count = count + 1
    end
    for data, node in pairs(self.rewardsMap_) do
        node:setPosition(spSize.width * .4 + 2.5, spSize.height * .4 + 10)
        node:setScale(0.66)
        print(data.order)
        local itemLayer = itemLayers[data.order]
        node.button_:addTouchEventListener(function(sender, eventType)
            if eventType == 2 then
                local name = data.name
                if name == "ordinary treasure chest"
                        or name == "rare treasure chest"
                        or name == "epic treasure chest"
                        or name == "legendary treasure chest" then

                    local twoLevelUi = OpenTreasureChest2nd.new(TestDataFactory:getChestRewardData())
                    twoLevelUi:addTo(self:getParent())

                end
            end
        end)
        node:addTo(itemLayer)
    end
    --构建钥匙
    local keySprite = display.newSprite("res/home/battle/high_ladder/calibrated scale/key.png")
    keySprite:setPosition(18, 35)
    keySprite:addTo(highLadderView)
end

--[[--
    @description: 帧刷新
    @param dt type:number, 帧间隔
]]
function TrophyRewardsLayer:update(dt)
    for _, node in pairs(self.rewardsMap_) do
        node:update(dt)
    end
    self.calibrateScale_:update(dt)
end

--[[--
    @description: 执行事件的注册
]]
function TrophyRewardsLayer:onEnter()

end

--[[--
    @description: 执行事件的注销
]]
function TrophyRewardsLayer:onExit()

end

return TrophyRewardsLayer
