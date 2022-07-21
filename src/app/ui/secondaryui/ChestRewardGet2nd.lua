--[[--
    ChestRewardGet2nd.lua
    宝箱奖励获取界面
]]
local ChestRewardGet2nd = class("ChestRewardGet2nd", function()
    return ccui.Layout:create()
end)

local StringDef = require("app.def.StringDef")
local Factory = require("app.utils.Factory")
--[[--
    @description: 构造函数
    @param data type:table 奖励的数据
    @return　none
]]
function ChestRewardGet2nd:ctor(data)
    self.data_ = data -- type:table ,具体奖励的表单

    self:init()
end

--[[--
    @description:初始化函数
    @param none
    @return none
]]
function ChestRewardGet2nd:init()
    self:setBackGroundColor(cc.c4b(0, 0, 0, 0))
    self:setBackGroundColorType(1)
    self:setContentSize(display.width, display.height)
    self:setBackGroundColorOpacity(150)
    self:setPosition(0, 0)

    local backSprite = display.newSprite(StringDef.PATH_SECOND_BASE_POPUP)
    backSprite:setPosition(display.width * .5, display.height * .5)
    backSprite:addTo(self)

    local size = backSprite:getContentSize()

    local layout = ccui.Layout:create()
    layout:setContentSize(size.width, size.height + 100)
    layout:setAnchorPoint(.5, .5)
    layout:setPosition(display.width * .5, display.height * .5)
    layout:addTo(self)

    local towerArr = Factory:createChestRewardTower(self.data_)
    for i = 1, #towerArr do
        local xIncre = (i - 1) % 4
        local yIncre = math.floor((i - 1) / 4)
        local towerReward = towerArr[i]
        towerReward:setScale(.8)
        towerReward:setPosition(size.width * .2 + size.width * .2 * xIncre,
                size.height * .8 - size.height * .4 * yIncre
        )
        towerReward:addTo(layout)
    end

    local coinSprite = display.newSprite(StringDef.PATH_SECOND_ICON_COIN)
    coinSprite:setPosition(size.width * .43, size.height * .06)
    coinSprite:addTo(layout)

    local quantityTTF = display.newTTFLabel({
        text = tostring(self.data_.coinNum),
        font = "res/font/fzbiaozjw.ttf",
        size = 30,
        color = cc.c3b(255, 255, 255)
    })
    quantityTTF:enableOutline(cc.c4b(20, 20, 66, 255), 2)
    quantityTTF:setPosition(size.width * .53, size.height * .06)
    quantityTTF:addTo(layout)

    local button = ccui.Button:create(StringDef.PATH_SECOND_BUTTON_CONFIRM)
    button:setPosition(display.width * .5, display.height * .25)
    button:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            self:removeSelf()
        end
    end)
    button:addTo(self)


    --屏蔽点击
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)
    self:setTouchEnabled(true)
end

--其他函数，暂时不写

return ChestRewardGet2nd
