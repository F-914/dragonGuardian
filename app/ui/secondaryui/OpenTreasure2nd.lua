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
--[[--
    @description: 构造函数
    @param treasureData type:table, 宝箱中的数据
    @return none
]]
function OpenTreasureChest2nd:ctor(treasureData, node)

    self.treasureData_ = treasureData --这个treasureData并不是宝箱的奖励,而
                                      --是宝箱可能的奖励,仅用于显示
    self.node_ = node
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

    local chestSprite = Factory:createRewardSprite(self.treasureData_.name)
    chestSprite:setPosition(size.width * .5, size.height * 1.2)
    chestSprite:setScale(.9)
    chestSprite:addTo(backSprite)

    local fontSprite = Factory:createChestFontSprite(self.treasureData_.name)
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
            --[[--
                这里用于调用outGameData的打开宝箱的函数
                这个函数需要生成随机奖励,并将数据上传服务器,并同步
                最后返回宝箱的奖励信息
                下面暂时用假数据替代
            ]]
            --self:playOpenChestAnimation()
            local newView = ChestRewardGet2nd.new(TestDataFactory:getOpenChestItemData())
            self.node_:get()

            newView:addTo(self:getParent())
            self:removeSelf()
        end
    end)
    openButton:addTo(backSprite)
    --接下来部分暂时没有数据，所以随便填写数据
    local chestInforPane = Factory:createChestRewardPane(self.treasureData_)
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