--[[--
    当金币或者钻石以及奖杯或者其他货币数量不足时，调用该界面
    NotEnoughNotifi2nd
]]
local NotEnoughNotifi2nd = class("NotEnoughNotifi2nd", function()
    return ccui.Layout:create()
end)

local Log = require("src/app/utils/Log.lua")
--[[--
    @description: 构造函数
    @param type type:number 可选值1 代表 "coin", 2 代表 "diamond",
    3 代表 "trophy"
    @return none
]]
function NotEnoughNotifi2nd:ctor(infoType)
    if infoType > 3 or infoType < 1 then
        Log.e("unknown infoType:" .. infoType)
        return
    end
    self.type_ = infoType --type:string, 用来表明缺少的那种类型
    self:init()
end
--[[--
    @description: 进行控件和属性的初始化
    @param none
    @return none
]]
function NotEnoughNotifi2nd:init()
    self:setBackGroundColor(cc.c4b(0, 0, 0, 0))
    self:setBackGroundColorType(1)
    self:setContentSize(display.width, display.height)
    self:setBackGroundColorOpacity(150)
    self:setPosition(0, 0)

    local backSprite = display.newSprite("res/home/general/second_general_popup/base_popup.png")
    backSprite:setPosition(display.width * .5, display.height * .5)
    backSprite:addTo(self)

    local inforSprite = self:createInforSprite()
    inforSprite:setPosition(display.width * .5, display.height * .5)
    inforSprite:addTo(self)

    local confirmBtn = ccui.Button:create("res/home/general/second_general_popup/button_confirm.png")
    confirmBtn:setPosition(display.width * .5, display.height * .37)
    confirmBtn:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            self:removeSelf()
        end
    end)
    confirmBtn:addTo(self)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        end
    end)
    self:setTouchEnabled(true)
end
function NotEnoughNotifi2nd:createInforSprite()
    local tips = {
        [1] = "tips_coin",
        [2] = "tips_diamond",
        [3] = "tips_cup"
    }
    return display.newSprite("res/home/general/second_general_popup/"
            ..tips[self.type_]
            ..".png")
end

return NotEnoughNotifi2nd