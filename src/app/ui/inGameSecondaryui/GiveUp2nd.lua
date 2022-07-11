--[[--
    GiveUp2nd.lua

    描述：Boss信息弹窗
]]
local GiveUp2nd = class("GiveUp2nd", function()
    return display.newLayer()
end)

--local
local ConstDef = require("app.def.ConstDef")
local InGameData = require("app.data.InGameData")
--

function GiveUp2nd:ctor()
    self:init()
end

function GiveUp2nd:init()
    --遮罩层
    local maskLayer = ccui.Layout:create()
    maskLayer:setAnchorPoint(0.5, 0.5)
    maskLayer:setPosition(display.cx, display.cy)
    maskLayer:setContentSize(display.width, display.height)
    maskLayer:setBackGroundColor(cc.c3b(0, 0, 0))
    maskLayer:setBackGroundColorType(1)
    maskLayer:opacity(200)
    maskLayer:addTo(self, -1)
    maskLayer:setTouchEnabled(true)
    maskLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            --self:removeFromParent()
            InGameData:setGameState(ConstDef.GAME_STATE.PLAY)
        end
    end)

    local baseSprite = cc.Sprite:create("battle_in_game/secondary_verify_give_up/basemap_popup.png")
    baseSprite:setAnchorPoint(0.5, 0.5)
    baseSprite:setPosition(display.cx, display.cy*21/20)
    baseSprite:addTo(self)
    local sizeBase = baseSprite:getContentSize()

    --触摸遮挡层
    local interceptLayer = ccui.Layout:create()
    interceptLayer:setAnchorPoint(0.5, 0.5)
    interceptLayer:setPosition(display.cx, display.cy*21/20)
    interceptLayer:setContentSize(sizeBase.width, sizeBase.height)
    interceptLayer:setTouchEnabled(true)
    interceptLayer:addTo(self)

    local tipsTTF = display.newTTFLabel({
        text = "是否认输，放弃该场战斗？",
        font = "font/fzhzgbjw.ttf",
        size = 32
    })
    tipsTTF:setAnchorPoint(0.5, 0.5)
    tipsTTF:setPosition(display.cx, display.cy*21/20 + sizeBase.height/40)
    tipsTTF:setColor(cc.c3b(255,255,255))
    tipsTTF:addTo(self)

    local cancleButton = ccui.Button:create("battle_in_game/secondary_verify_give_up/button_cancel.png")
    cancleButton:setAnchorPoint(0.5, 0.5)
    cancleButton:setPosition(display.cx - sizeBase.width/4, display.cy - sizeBase.height/6 + sizeBase.height/40)
    cancleButton:addTo(self)
    cancleButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            --self:removeFromParent()
            InGameData:setGameState(ConstDef.GAME_STATE.PLAY)
        end
    end)

    local confirmButton = ccui.Button:create("battle_in_game/secondary_verify_give_up/button_confirm.png")
    confirmButton:setAnchorPoint(0.5, 0.5)
    confirmButton:setPosition(display.cx + sizeBase.width/4, display.cy - sizeBase.height/6 + sizeBase.height/40)
    confirmButton:addTo(self)
    confirmButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            --self:removeFromParent()
            InGameData:setGameState(ConstDef.GAME_STATE.PLAY)
        end
    end)

end

return GiveUp2nd