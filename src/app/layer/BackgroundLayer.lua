local BackgroundLayer = class("BackGroundLayer", require("app.ui.layer.BaseLayer"))
--local
local StringDef = require("app.def.StringDef")
--
function BackgroundLayer:ctor()
    BackgroundLayer.super.ctor(self)
    self:initLayer()
end

function BackgroundLayer:initLayer()
    local sprite = display.newSprite(StringDef.PATH_BACKGROUND_GUIDE)
    self:add(sprite)
    sprite:setAnchorPoint(0.5, 0.5)
    sprite:setPosition(display.cx, display.cy)
end

return BackgroundLayer
