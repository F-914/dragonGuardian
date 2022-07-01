--[[--
    根据数据创建出每行四个图标的图鉴版块，分为已收集和未收集
    BagLayer.lua
]]
local BagLayer =
class(
    "BagLayer",
    function()
        return display.newLayer()
    end
)
--local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
--
local list_ = {}
--
function BagLayer:ctor(lineupList, types)
    self.list = nil
    self:init(lineupList, types)
    self.list = list_
end

function BagLayer:init(lineupList, types)
    local height --计算需要多少行
    if #(lineupList) == 0 then
        height = 1
    elseif #(lineupList) % 4 == 0 then
        height = #(lineupList) / 4
    elseif #(lineupList) % 4 ~= 0 then
        height = math.floor(#(lineupList) / 4) + 1
    end

    local test = display.newSprite(ConstDef.ICON_LIST[1]) --获取每个图标的contentsize
    local TotalLayout = ccui.Layout:create()
    self:add(TotalLayout)
    TotalLayout:setAnchorPoint(0.5, 1)
    TotalLayout:setContentSize(cc.Director:getInstance():getWinSize().width,
        test:getContentSize().height * ConstDef.scale_ * height +
        (height - 1) * test:getContentSize().height * 0.2 * ConstDef.scale_)

    if types == "uncollected" then --根据已收集和未收集从不同的地址获取图片
        for i = 1, #(lineupList), 4 do
            local layout = ccui.Layout:create()
            TotalLayout:add(layout)
            layout:setAnchorPoint(0.5, 1)
            layout:setContentSize(TotalLayout:getContentSize().width, test:getContentSize().height * ConstDef.scale_)
            layout:setPosition(
                TotalLayout:getContentSize().width * 0.5,
                TotalLayout:getContentSize().height - test:getContentSize().height * ConstDef.scale_ * math.floor(i / 4)
                - math.floor(i / 4) * test:getContentSize().height * 0.1 * ConstDef.scale_
            )
            for j = 0, 3 do
                if lineupList[i + j] == nil then
                    break
                end
                local sprite = display.newSprite(ConstDef.ICON_UNCOLLECTED_LIST[ lineupList[j + i] ])
                layout:add(sprite)
                sprite:setScale(ConstDef.scale_)
                sprite:setAnchorPoint(0, 1)
                sprite:setPosition(layout:getContentSize().width * j * 0.25 + 20, 0)
                sprite:setContentSize(sprite:getContentSize().width * ConstDef.scale_,
                    sprite:getContentSize().height * ConstDef.scale_)

            end
        end
    elseif types == "collected" then --根据已收集和未收集从不同的地址获取图片
        for i = 1, #(lineupList), 4 do
            local layout = ccui.Layout:create()
            TotalLayout:add(layout)
            layout:setAnchorPoint(0.5, 1)
            layout:setContentSize(TotalLayout:getContentSize().width, test:getContentSize().height * ConstDef.scale_)
            layout:setPosition(
                TotalLayout:getContentSize().width * 0.5,
                TotalLayout:getContentSize().height * 1 + 100 -
                test:getContentSize().height * ConstDef.scale_ * math.floor(i / 4) -
                math.floor(i / 4) * test:getContentSize().height * 0.1 * ConstDef.scale_
            )
            for j = 0, 3 do

                if lineupList[i + j] == nil then

                    break
                end
                local button = ccui.Button:create(ConstDef.ICON_LIST[lineupList[j + i].order],
                    ConstDef.ICON_LIST[lineupList[j + i].order])
                layout:add(button)
                button:setAnchorPoint(0, 1)
                button:setScale(ConstDef.scale_)
                button:setPressedActionEnabled(true)
                button:setTouchEnabled(true)
                button:setPosition(layout:getContentSize().width * j * 0.25 + 20, 0)
                button:addTouchEventListener(function(sender, eventType)
                    if eventType == 2 then
                        table.insert(ConstDef.BUTTON_CLICK, i + j)
                    end
                end)
                table.insert(list_, button)
            end
        end

    end

end

return BagLayer
