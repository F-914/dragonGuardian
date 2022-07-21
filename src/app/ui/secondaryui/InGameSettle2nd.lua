--[[--
    游戏内结算画面
    InGameSettle2nd
]]
local InGameSettle2nd = class("InGameSettle2nd", function()
    return ccui.Layout:create()
end)

local Factory = require("src/app/utils/Factory.lua")
local StringDef = require("src/app/def/StringDef.lua")
--[[--
    @description: 构造函数
    @param ... 暂时不知道游戏内数据
    @return none
]]
function InGameSettle2nd:ctor(...)
    self.isWinner_ = true --我方是否胜利，由传递的参数确定
    self.myTeamMap_ = nil --我方的队伍和精灵的map
    self.enemyTeamMap_ = nil --敌方的队伍和精灵的map
    self.settleData_ = nil --奖励的数据，这个也是由传递的参数决定的，
    self.myTrophyAmount_ = nil --这个也由传递的参数决定，这个应该是未结算前的奖杯数
                            --，之所以不直接访问GameData的数据，因为真正的结
                            --算奖励的时候是在游戏结束的瞬间，这个界面只负责显示，
                            --如果直接访问，访问到的就是结算后的数据
    self.enemyTrophyAmount_ = nil --同上
    self.myUserName_ = nil --我方用户名，直接访问GameData获取
    self.enemyUserName_ = nil --同上，敌方的用户名
end
--[[--
    @description: 初始化界面元素
]]
function InGameSettle2nd:init(...)
    --处理界面背景黑化
    self:setBackGroundColor(cc.c4b(0, 0, 0, 0))
    self:setBackGroundColorType(1)
    self:setContentSize(display.width, display.height)
    self:setBackGroundColorOpacity(150)
    self:setPosition(0, 0)

    if self.isWinner_ then
        self:victory()
    else
        self:failure()
    end
    local openButton = ccui.Button:create("res/battle_in_game/settlement/button_confirm.png")
    openButton:setPosition(display.width * .5, display.height * .2)
    openButton:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            --[[--
                这里应该控制退出当前场景，返回游戏外场景
            ]]
        end
    end)
    openButton:addTo(self)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)
    self:setTouchEnabled(true)
end
--[[--
    @description:胜利时创建的画面
]]
function InGameSettle2nd:victory(...)
    self.myTeamMap_ = Factory:createTeamSprite() --这里的参数暂时没有
    local myLayout = self:createTeamPane(self.myTeamMap_, self.myUserName_,
            self.myTrophyAmount_)
    myLayout:setAnchorPoint(.5, .5)
    myLayout:setPosition(display.width * .5, display.height * .7)
    myLayout:addTo(self)

    local myReward = self:createSettleReward()
    myReward:setAnchorPoint(.5, .5)
    myReward:setPosition(display.width * .5, display.height * .4)
end
--[[--
    @description:失败时创建的画面
]]
function InGameSettle2nd:failure(...)
    self.myTeamMap_ = Factory:createTeamSprite() --这里的参数暂时没有
    self.enemyTeamMap_ = Factory:createTeamSprite() -- 同理
    local myLayout = self:createTeamPane(self.myTeamMap_, self.myUserName_,
            self.myTrophyAmount_)
    local enemyLayout = self:createTeamPane(self.enemyTeamMap_, self.enemyUserName_,
            self.enemyTrophyAmount_)
    myLayout:setAnchorPoint(.5, .5)
    myLayout:setPosition(display.width * .5, display.height * .4)
    myLayout:addTo(self)

    enemyLayout:setAnchorPoint(.5, .5)
    enemyLayout:setPosition(display.width * .5, display.height * .7)
    enemyLayout:addTo(self)
end
--[[--
    @description 创建队伍信息列表
]]
function InGameSettle2nd:createTeamPane(teamMap, userName, trophyAmount)
    local layout = ccui.Layout:create()
    layout:setContentSize(display.width, display.height * .25)
    local size = layout:getContentSize()

    for i = 1, #teamMap do
        local node = teamMap[i][2]
        node:setPosition(-70 + size.width * 0.2 * i, size.height * .3)
        node:setScale(0.8)
        layout:addChild(node)
    end
    local nameBaseMap = display.newScale9Sprite("res/battle_in_game/settlement/basemap_script.png")
    --nameBaseMap:setContentSize() --这个留待调试用
    nameBaseMap:setPosition(size.width * .2, size.height * .8) --暂时先这样，调试时调整位置
    nameBaseMap:addTo(layout)

    local nameTTF = display.newTTFLabel({
        text = userName,
        size = 24, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    nameTTF:setAnchorPoint(0, 0)
    nameTTF:setPosition(0, 0)
    nameTTF:addTo(nameBaseMap)

    local trophyBaseMap = display.newScale9Sprite("res/battle_in_game/settlement/basemap_script.png")
    --nameBaseMap:setContentSize() --这个留待调试用
    trophyBaseMap:setPosition(size.width * .8, size.height * .8) --暂时先这样，调试时调整位置
    trophyBaseMap:addTo(layout)

    local trophyTTF = display.newTTFLabel({
        text = tostring(trophyAmount),
        size = 24, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    trophyTTF:setAnchorPoint(0, 0)
    trophyTTF:setPosition(0, 0)
    trophyTTF:addTo(trophyBaseMap)

    return layout
end

function InGameSettle2nd:createSettleReward()
    local layout = ccui.Layout:create()
    --layout:setContentSize() --留待调试
    local size = layout:getContentSize()

    local baseReward = display.newSprite("res/battle_in_game/settlement/label_base_reward.png")
    baseReward:setPosition(display.width * .25, display.height * .85)
    baseReward:addTo(layout)

    local baseSprite = self:createSettleItem() --参数，待填
    baseSprite:setPosition(display.width * .5, display.height * .85)
    baseSprite:addTo(layout)

    local buffReward = display.newSprite("res/battle_in_game/settlement/label_buff_reward.png")
    buffReward:setPosition(display.width * .25, display.height * .7)
    buffReward:addTo(layout)

    local buffSprite = self:createSettleItem() --参数待填
    buffSprite:setPosition(display.width * .5, display.height * .7)
    buffSprite:addTo(layout)

    local winSprite = display.newSprite("res/battle_in_game/settlement/label_winning_streak_reward.png")
    winSprite:setPosition(display.width * .25, display.height * .55)
    winSprite:addTo(layout)

    local winReward = self:createSettleItem() --参数暂时没有
    winReward:setPosition(display.width * .5, display.height * .55)
    winReward:addTo(layout)

    local sumReward = self:createSettleSum() --参数代填
    sumReward:setPosition(display.width * .5, display.height * .2)
    sumReward:addTo(layout)

    return layout
end

function InGameSettle2nd:createSettleItem(trophyAmount, coinAmount, diamondAmount)
    local backSprite = display.newScale9Sprite("res/battle_in_game/settlement/basemap_reward.png")
    --backSprite:setContentSize()--留待调试调整参数
    local size = backSprite:getContentSize()

    local trophy = display.newSprite("res/battle_in_game/settlement/label_cup.png")
    trophy:setPosition(size.width * .1, size.height * .5)
    trophy:addTo(backSprite)

    local coin = display.newSprite("res/battle_in_game/settlement/label_coin.png")
    coin:setPosition(size.width * .4, size.height * .5)
    coin:addTo(backSprite)

    local trophyTTF = display.newTTFLabel({
        text = "+" .. tostring(trophyAmount),
        size = 24, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    trophyTTF:setPosition(size.width * .2, size.height * .5)
    trophyTTF:addTo(backSprite)

    local coinTTF = display.newTTFLabel({
        text = "+" .. tostring(coinAmount),
        size = 24, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    coinTTF:setPosition(size.width * .5, size.height * .5)
    coinTTF:addTo(backSprite)

    if diamondAmount then
        local diamond = display.newSprite("res/battle_in_game/settlement/label_diamond.png")
        diamond:setPosition(size.width * .7, size.height * .5)
        diamond:addTo(backSprite)

        local diamondTTF = display.newTTFLabel({
            text = "+" .. tostring(diamondAmount),
            size = 24, --sb, 资料里面没给大小说明
            font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
            color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
        })
        diamondTTF:setPosition(size.width * .8, size.height * .5)
        diamondTTF:addTo(backSprite)
    end

    return backSprite
end

function InGameSettle2nd:createSettleSum(trophyAmount, coinAmount, diamondAmount)
    local backSprite = display.newSprite("res/battle_in_game/settlement/basemap_reward_sum.png")
    --backSprite:setContentSize()--留待调试调整参数
    local size = backSprite:getContentSize()

    --local sum = display.newSprite("")--又缺少资源tnnd
    --用ttf代替
    local sumTTF = display.newTTFLabel({
        text = "总计",
        font = StringDef.PATH_FONT_FZBIAOZJW,
        size = 30,
        color = cc.c3b(255, 255, 255)
    })
    sumTTF:setPosition(size.width * .15, size.height * .5)
    sumTTF:addTo(backSprite)

    local trophy = display.newSprite("res/battle_in_game/settlement/label_cup.png")
    trophy:setPosition(size.width * .3, size.height * .5)
    trophy:addTo(backSprite)

    local coin = display.newSprite("res/battle_in_game/settlement/label_coin.png")
    coin:setPosition(size.width * .5, size.height * .5)
    coin:addTo(backSprite)

    local diamond = display.newSprite("res/battle_in_game/settlement/label_diamond.png")
    diamond:setPosition(size.width * .7, size.height * .5)
    diamond:addTo(backSprite)

    local trophyTTF = display.newTTFLabel({
        text = "+" .. tostring(trophyAmount),
        size = 30, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    trophyTTF:setPosition(size.width * .35, size.height * .5)
    trophyTTF:addTo(backSprite)

    local coinTTF = display.newTTFLabel({
        text = "+" .. tostring(coinAmount),
        size = 30, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    coinTTF:setPosition(size.width * .55, size.height * .5)
    coinTTF:addTo(backSprite)

    local diamondTTF = display.newTTFLabel({
        text = "+" .. tostring(diamondAmount),
        size = 30, --sb, 资料里面没给大小说明
        font = StringDef.PATH_FONT_FZBIAOZJW, --sb,也没给字体说明
        color = cc.c3b(255, 255, 255) --前两个都没有，更何况这个
    })
    diamondTTF:setPosition(size.width * .75, size.height * .5)
    diamondTTF:addTo(backSprite)

    return backSprite
end
return InGameSettle2nd