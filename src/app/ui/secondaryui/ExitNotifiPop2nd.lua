--[[--
    退出通知的弹窗
    这个怎么调出来暂时未解决
    ExitNotifiPop2nd.lua
]]

local ExitNotifiPop2nd = class("ExitNotifiPop2nd", function()
    return ccui.Layout:create()
end)
--[[--
    @description 构造函数
    @param none
    @return none
]]
function ExitNotifiPop2nd:ctor()

    self:init()
end
--[[--
    @description: 进行控件和属性的初始化
    @param none
    @return none
]]
function ExitNotifiPop2nd:init()
    self:setBackGroundColor(cc.c4b(0, 0, 0, 0))
    self:setBackGroundColorType(1)
    self:setContentSize(display.width, display.height)
    self:setBackGroundColorOpacity(150)
    self:setPosition(0, 0)

    local backSprite = display.newSprite("res/home/general/second_general_popup/base_popup.png")
    backSprite:setPosition(display.width * .5, display.height * .5)
    backSprite:addTo(self)

    local inforSprite = display.newSprite("res/home/general/second_general_popup/text_exit.png")
    inforSprite:setPosition(display.width * .5, display.height * .5)
    inforSprite:addTo(self)

    local confirmBtn = ccui.Button:create("res/home/general/second_general_popup/button_confirm.png")
    confirmBtn:setPosition(display.width * .5, display.height * .4)
    confirmBtn:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            cc.Director:getInstance():endToLua()
        end
    end)
    confirmBtn:addTo(self)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "end" then
            self:removeSelf()
        end
    end)
    self:setTouchEnabled(true)
end


return ExitNotifiPop2nd