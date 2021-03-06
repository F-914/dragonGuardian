--[[--
    显示用户奖励进度以及奖励领取信息的层
    TrophyRewardsLayer.lua
]]
local TrophyRewardsLayer = class("TrophyRewardsLayer", function()
    return display.newLayer()
end)

--local
local CalibrateScaleSprite = require("app.ui.node.CalibrateScaleSprite")
local Log = require("app.utils.Log")
local Factory = require("app.utils.Factory")
local StringDef = require("app.def.StringDef")
local TestDataFactory = require("app.test.TestDataFactory")
local OpenTreasureChest2nd = require("app.ui.secondaryui.OpenTreasure2nd")
local OutGameData = require("app.data.OutGameData")
local ConstDef = require("app.def.ConstDef")
local NotEnoughNotifi2nd = require("app.ui.secondaryui.NotEnoughNotifi2nd")
--
local MsgDef = require("app.def.MsgDef")
local TableUtil = require("app.utils.TableUtil")
local OutMsgController = require("app.network.OutGameMsgController")
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

    --各项属性初始化，暂时保持这样，后面可能会因为需求变化
    --self.rewardsMap_ = Factory:createRewardList(GameData.rewards_)
    self.rewardsMap_ = Factory:createRewardList(OutGameData
            :getUserInfo()
            :getUserInfoLadder()
            :getLadderList())

    local spriteBG = display.newSprite(StringDef.PATH_HIGH_LADDER_BACKGROUND)
    --给的资源就不对称
    spriteBG:setPosition(display.width * .515, display.height * 0.75)
    spriteBG:setScale(1, .7)
    spriteBG:setContentSize(display.width - 20, display.height * .20)
    spriteBG:addTo(self)

    local leftButton = ccui.Button:create(StringDef.PATH_HIGH_LADDER_ICON_SLIDE_LEFT)
    leftButton:setPosition(50, display.height * .8)
    leftButton:addTouchEventListener(function(sender, eventType)
        Log.i("test left button")
    end)
    leftButton:addTo(self)

    local rightButton = ccui.Button:create(StringDef.PATH_HIGH_LADDER_ICON_SLIDE_RIGHT)
    rightButton:setPosition(display.width - 50, display.height * .8)
    rightButton:addTouchEventListener(function(sender, eventType)
        Log.i("test right button")
    end)
    rightButton:addTo(self)
    --构建天梯列表
    local highLadderView = ccui.ListView:create()
    highLadderView:setPosition(70, display.height * .69)
    highLadderView:setAnchorPoint(0, 0)
    highLadderView:setContentSize(display.width - 140, display.height * .18)
    highLadderView:setDirection(2)
    highLadderView:addTo(self)
    --构建进度条

    local calibrateScale = CalibrateScaleSprite.new(StringDef.PATH_HIGH_LADDER_CALIBRATED_SCALE)

    calibrateScale:setAnchorPoint(0, 0)
    calibrateScale:setPosition(0, 15)
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
        itemLayer:setContentSize(120, 120)
        itemLayer:addTo(highLadderView)
        itemLayers[count] = itemLayer
        count = count + 1
    end
    ---多加一个多余的layer，防止遮挡
    local itemLayer = ccui.Layout:create()
    itemLayer:setBackGroundColorType(3)
    itemLayer:setAnchorPoint(.5, .5)
    itemLayer:setContentSize(120, 120)
    itemLayer:addTo(highLadderView)

    for data, node in pairs(self.rewardsMap_) do
        node:setPosition(spSize.width * .5, spSize.height * .4)
        node:setScale(0.66)

        local itemLayer = itemLayers[data:getRewardLocation()]
        node.button_:addTouchEventListener(function(sender, eventType)
            if eventType == 2 then
                if data:isLocked() then
                    local notifiUi = NotEnoughNotifi2nd.new(3)
                    notifiUi:addTo(display.getRunningScene(), 2)
                elseif not data:isReceived() then
                    local rewardName = data:getRewardName()
                    local rewardType = data:getRewardType()
                    if rewardType == ConstDef.REWARD_TYPE.TREASUREBOX then
                        ---将reward类里面的实际奖励传递给二级界面
                        local twoLevelUi = OpenTreasureChest2nd.new(data.reward_, 0, 0, true, data.trophyCondition_)
                        twoLevelUi:addTo(display.getRunningScene(), 2)
                    elseif rewardType == ConstDef.REWARD_TYPE.CARD then
                        local msgUserInfo = {}
                        local userInfo = OutGameData.getUserInfo()
                        msgUserInfo.userInfoCoinAmount = userInfo:getCoinAmount()
                        msgUserInfo.userInfoDiamondAmount = userInfo:getDiamondAmount()
                        msgUserInfo.userInfoCardList = {}
                        msgUserInfo.userInfoLadder = {}
                        msgUserInfo.userInfoLadder.ladderList = {}
                        msgUserInfo.userInfoLadder.ladderList[1] = {
                            trophyCondition = data:getTrophyCondition()
                        }
                        table.insert(msgUserInfo.userInfoCardList, TableUtil:removeTableFunction(data.reward_))
                        local msg = TableUtil:encapsulateAsMsg(MsgDef.REQTYPE
                                                                     .LOBBY.RECEIVE_REWARD, userInfo:getAccount(),
                                "userInfo", msgUserInfo)
                        OutMsgController:sendMsg(msg)
                    elseif rewardType == ConstDef.REWARD_TYPE.RANDOM then
                        --[[--
                            这是什么玩意儿我也不知道
                            随机奖励 不过看来用不到了 乐
                        ]]
                    elseif rewardType == ConstDef.REWARD_TYPE.CURRENCY then
                        local msgUserInfo = {}
                        local userInfo = OutGameData:getUserInfo()
                        local currency = data:getRewardReward()
                        if currency.currencyType_ == ConstDef.CURRENCY_TYPE.COIN then
                            msgUserInfo.userInfoCoinAmount = userInfo:getCoinAmount() +
                                    currency:getCurrencyAmount()
                            msgUserInfo.userInfoDiamondAmount = userInfo:getDiamondAmount()
                        elseif currency.currencyType_ == ConstDef.CURRENCY_TYPE.DIAMOND then
                            msgUserInfo.userInfoCoinAmount = userInfo:getCoinAmount()
                            msgUserInfo.userInfoDiamondAmount = userInfo:getDiamondAmount() +
                                    currency:getCurrencyAmount()
                        else
                            msgUserInfo.userInfoCoinAmount = userInfo:getCoinAmount()
                            msgUserInfo.userInfoDiamondAmount = userInfo:getDiamondAmount()
                        end
                        msgUserInfo.userInfoCardList = {}
                        msgUserInfo.userInfoLadder = {}
                        msgUserInfo.userInfoLadder.ladderList = {}
                        msgUserInfo.userInfoLadder.ladderList[1] = {
                            trophyCondition = data:getTrophyCondition()
                        }
                        local msg = TableUtil:encapsulateAsMsg(MsgDef.REQTYPE
                                                                     .LOBBY.RECEIVE_REWARD, userInfo:getAccount(),
                                "userInfo", msgUserInfo)
                        OutMsgController:sendMsg(msg)
                    end
                end
            end
        end)
        Log.i("itemLayer is nullptr ? " .. tostring(itemLayer == nil))
        node:addTo(itemLayer)
    end
    --构建钥匙
    local keySprite = display.newSprite(StringDef.PATH_HIGH_LADDER_CALIBRATED_SCALE_KEY)
    keySprite:setPosition(7, 35)
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
