--[[--
    宝箱开启确认界面
    OpenTreasure2nd
]]
local OpenTreasureChest2nd = class("OpenTreasureChest2nd", function()
    return ccui.Layout:create()
end)

local Factory = require("app.utils.Factory")
local ChestRewardGet2nd = require("app.ui.secondaryui.ChestRewardGet2nd")
local TestDataFactory = require("app.test.TestDataFactory")
local StringDef = require("app.def.StringDef")
local OutGameData = require("app.data.OutGameData")

local MsgDef = require("app.def.MsgDef")
local OutGameMsgController = require("app.network.OutGameMsgController")
local TableUtil = require("app.utils.TableUtil")
--[[--
    @description: 构造函数
    @param treasureData type:table, 宝箱中的数据
    @return none
]]
function OpenTreasureChest2nd:ctor(treasureBox, coinChange,
                                   diamondChange, isTrophy,
                                    trophyAmount)

    self.data_ = treasureBox --表示奖励宝箱
    self.diamondChange_ = diamondChange
    self.coinChange_ = coinChange
    ---一共两个地方获取宝箱，一个是购买，一个是天梯，上面两个数据用于购买时，使用
    ---下面就是判断
    self.isTrophy_ = isTrophy
    ---当是天梯时这个有用
    self.trophyAmount_ = trophyAmount
    self:init()

end

--[[--
    @description: 初始化，设置界面属性和子节点
    @param none
    @reutnr none
]]
function OpenTreasureChest2nd:init()
    --处理界面背景黑化
    self:setBackGroundColor(cc.c4b(0, 0, 0, 0))
    self:setBackGroundColorType(1)
    self:setContentSize(display.width, display.height)
    self:setBackGroundColorOpacity(150)
    self:setPosition(0, 0)

    local backSprite = display.newSprite(StringDef.PATH_SECOND_OPEN_BASE_POPUP)
    backSprite:setPosition(display.width * .5, display.height * .5)
    backSprite:addTo(self)
    backSprite:setScale(.9)
    local size = backSprite:getContentSize()

    local chestSprite = Factory:createRewardSprite(self.data_.treasureBoxType_)
    chestSprite:setPosition(size.width * .5, size.height * 1.2)
    chestSprite:setScale(.9)
    chestSprite:addTo(backSprite)

    local fontSprite = Factory:createChestFontSprite(self.data_.treasureBoxType_)
    fontSprite:setPosition(size.width * .5, size.height * .9)
    fontSprite:addTo(backSprite)

    local closeButton = ccui.Button:create(StringDef.PATH_SECOND_OPEN_BUTTON_CLOSE)
    closeButton:setPosition(size.width * .93, size.height * .89)
    closeButton:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            self:removeSelf()
        end
    end)
    closeButton:addTo(backSprite)
    local openButton = ccui.Button:create(StringDef.PATH_SECOND_OPEN_BUTTON_OPEN)
    openButton:setPosition(size.width * .5, 0)
    openButton:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            local cardDatas = OutGameData:openTreasureBox(self.data_:getTreasureBoxType())
            local msgUserInfo = {}
            local userInfo = OutGameData:getUserInfo()
            msgUserInfo.userInfoCoinAmount = userInfo:getCoinAmount()
                    + cardDatas.coinNum + self.coinChange_
            msgUserInfo.userInfoDiamondAmount = userInfo:getDiamondAmount()
                    + self.diamondChange_
            local tp = cardDatas.coinNum
            cardDatas.coinNum = nil
            msgUserInfo.userInfoCardList = cardDatas
            if self.isTrophy_ then
                msgUserInfo.userInfoLadder = {}
                msgUserInfo.userInfoLadder.ladderList = {}
                msgUserInfo.userInfoLadder.ladderList[1] = {
                    trophyCondition = self.trophyAmount_
                }
                local msg = TableUtil:encapsulateAsMsg(MsgDef.REQTYPE.LOBBY
                        .RECEIVE_REWARD, userInfo:getAccount(),
                        "userInfo", msgUserInfo)
                OutGameMsgController:sendMsg(msg)
            else
                local msg = TableUtil:encapsulateAsMsg(MsgDef.REQTYPE.LOBBY
                        .PURCHASE_COMMODITY, userInfo:getAccount(),
                        "userInfo", msgUserInfo)

                OutGameMsgController:sendMsg(msg)
            end
            cardDatas.coinNum = tp
            local newView = ChestRewardGet2nd.new(cardDatas)
            newView:addTo(display.getRunningScene(), 2)
            self:removeSelf()
        end
    end)
    openButton:addTo(backSprite)

    local chestInforPane = Factory:createChestRewardPane(OutGameData
            :getTreasureBoxRewardWinningRate()[self.data_.treasureBoxType_])
    chestInforPane:setPosition(display.width * .5, display.height * .5)
    chestInforPane:addTo(self)

    --屏蔽点击
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)
    self:setTouchEnabled(true)
end

--[[--
    @description: 用于播放宝箱开启的骨骼动画
    @remark: 版本不兼容暂时不能用
]]
function OpenTreasureChest2nd:playOpenChestAnimation()
    local spine = sp.SkeletonAnimation:createWithJsonFile(
        StringDef.PATH_ANIMATION_OPEN_TREASURE_BOX_JSON,
        StringDef.PATH_ANIMATION_OPEN_TREASURE_BOX_ATLAS
    )
    spine:setPosition(display.width * .5, display.height * .5)
    spine:setAnimation(0, "legend", false)
end

return OpenTreasureChest2nd
