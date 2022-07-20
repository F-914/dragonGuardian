--[[--
    根据ConstDef中的已收集表COLLECTED创建出五个一行的阵容行列
    LineupLayer.lua
]]

local LineupLayer = class("LineupLayer", function()
    return display.newLayer()
end)
--local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManger = require("app.manager.EventManager")
local OutGameData = require("app.data.OutGameData")
local Log = require("app.utils.Log")
--

--[[--
    @description:构造方法
    @param lineupList 类型:表，用于保存阵容队列中有哪些塔，存储塔的下标
    @return none
]]
function LineupLayer:ctor(lineupList)
    self.popup = nil
    self.button = nil
    self:init(lineupList)
end

--[[--
    @description:初始化方法
    @param lineupList 类型:表，用于保存阵容队列中有哪些塔，存储塔的下标
    @return none
]]
function LineupLayer:init(lineupList)
    local list = {}
    local test = display.newSprite(ConstDef.ICON_LINEUP_LIST[lineupList[1]])
    local layout = ccui.Layout:create()
    layout:setAnchorPoint(0, 0)
    layout:setContentSize(test:getContentSize().width * 5, test:getContentSize().height)
    self:add(layout)
    for i = 1, #(lineupList) do
        local button = ccui.Button:create(ConstDef.ICON_LINEUP_LIST[lineupList[i]],
                ConstDef.ICON_LINEUP_LIST[lineupList[i]])
        layout:add(button)
        button:setAnchorPoint(0, 0)
        button:setPosition(10 + layout:getContentSize().width * 0.2 * (i - 1), 0)
        button:setPressedActionEnabled(true)
        button:setTouchEnabled(false)
        button:addTouchEventListener(function(sender, eventType)
            --注册塔的点击事件，用于替换阵容中的塔，在其他情况下设置为不可点击
            if eventType == 2 then

                -- 先判断一下队伍中是否已经有这个卡牌了
                local team = OutGameData:getUserInfo():getBattleTeam():getIndexTeam(self.lineupOrder)
                local flag = true
                for _, v in pairs(team) do
                    if v == self.order then
                        flag = false
                        break
                    end
                end
                if flag then
                    button:loadTextureNormal(ConstDef.ICON_LINEUP_LIST[self.order], 0)
                    button:loadTexturePressed(ConstDef.ICON_LINEUP_LIST[self.order], 0)
                    team[i] = self.order
                    self.popup:setVisible(false)
                    self.popup:removeFromParent()
                    --OutGameData:getUserInfo():getBattleTeam():setIndexTeamCard(self.lineupOrder,i,self.order)
                    EventManger:doEvent(EventDef.ID.CARD_USE,self.lineupOrder,i,self.order)
                    EventManger:doEvent(EventDef.ID.RESUME_BAG_BUTTON)
                    EventManger:doEvent(EventDef.ID.SHOW_BAG)
                end

            end
        end)
        table.insert(list, button)
    end
    self.button = list
end

function LineupLayer:setPopup(popup)
    self.popup = popup
end

function LineupLayer:setOrder(order)
    self.order = order
end

function LineupLayer:setLineupOrder(lineupOrder)
    self.lineupOrder = lineupOrder
end
function LineupLayer:onEnter()
   
end
function  LineupLayer:onExit()
    
end
return LineupLayer
