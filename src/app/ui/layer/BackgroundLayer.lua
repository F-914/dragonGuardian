local BackgroundLayer=class("BackGroundLayer",require("src/app/ui/layer/BaseLayer.lua"))
function BackgroundLayer:ctor()
    BackgroundLayer.super.ctor(self)
    self:initLayer()
end
function BackgroundLayer:initLayer()
    local sprite=display.newSprite("res/home/guide/backgroung_guide.png")
    self:add(sprite)
    sprite:setAnchorPoint(0.5,0.5)
    sprite:setPosition(display.cx,display.cy)
end
return BackgroundLayer