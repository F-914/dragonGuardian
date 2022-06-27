local ConstDef = require("src/app/def/ConstDef.lua")
local BagLayer = class("BagLayer", function()
    return display.newLayer()
end)

function BagLayer:ctor(lineupList)
   self:init(lineupList)
  
end
function BagLayer:init(lineupList)
    --print(cc.Director:getInstance():getWinSize().width)
    local height
    if table.getn(lineupList)%4==0 then
       height=table.getn(lineupList)/4
    elseif table.getn(lineupList)%4~=0 then
        height=table.getn(lineupList)/4+1
    end
    -- body
   
    local TotalLayout=ccui.Layout:create()
    self:add(TotalLayout)
    TotalLayout:setAnchorPoint(0.5,1)
    TotalLayout:setContentSize(cc.Director:getInstance():getWinSize().width, 100*height)
    for i = 1, table.getn(lineupList), 4 do 
        local layout = ccui.Layout:create()
        TotalLayout:add(layout)
        layout:setAnchorPoint(0.5,0.5)
        layout:setContentSize(TotalLayout:getContentSize().width, 100)
        layout:setPosition(TotalLayout:getContentSize().width*0.5,TotalLayout:getContentSize().height-100*(i/4))
        for j = 0, 3 do
            if lineupList[i+j]==nil then
                break
            end
            local sprite = display.newSprite(ConstDef.ICON_LIST[lineupList[j+i]])
            layout:add(sprite)
            sprite:setScale(ConstDef.scale_)
            sprite:setAnchorPoint(0, 1)
            sprite:setPosition(layout:getContentSize().width * j* 0.25+20, 0)
        end
    end
   
end

return BagLayer