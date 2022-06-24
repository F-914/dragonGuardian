local ConstDef = require("src/app/def/ConstDef.lua")
local LineupLayer = class("LineupLayer", function()
    return display.newLayer()
end)

function LineupLayer:ctor(lineupList)
   self:init(lineupList)
end
function LineupLayer:init(lineupList)
    local layout=ccui.Layout:create()
    layout:setAnchorPoint(0.5,0.5)
    self:add(layout)
    for i = 1, table.getn(lineupList) do
        local sprite = display.newSprite(ConstDef.ICON_LIST[lineupList[i]])
        layout:add(sprite)
        sprite:setScale(ConstDef.scale_)
        sprite:setAnchorPoint(0, 0)
        sprite:setPosition(40 + (i - 1) * 120 * ConstDef.scale_, 0)
    end
   
end

return LineupLayer