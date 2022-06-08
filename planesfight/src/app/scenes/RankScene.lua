
local RankScene = class("RankScene", function()
    return display.newScene("RankScene")
end)

function RankScene:ctor()
    --主界面背景图
    display.newSprite("bg_menu.jpg")
           :pos(display.cx,display.cy)
           :addTo(self)
    self:backPanel()
    self:rankingPanel()

end

--[[
    函数用途：返回按钮
    --]]
function RankScene:backPanel()
    --按钮：返回主菜单
    local backButton = ccui.Button:create("ui/back_peek0.png","ui/back_peek1.png")
    backButton:setScale(1,1)
    backButton:pos(80 , 690)
    backButton:setAnchorPoint(0.5,0.5)
    backButton:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then--场景跳转回主菜单
            local mainScene = import("app.scenes.MainScene"):new()
            display.replaceScene(mainScene,"turnOffTiles",0.5)
            print(transform)
        end
    end)
    backButton:addTo(self)
end

function RankScene:rankingPanel()
    --层：显示排行榜
    local rankingLayer = ccui.Layout:create()
    rankingLayer:setBackGroundColor(cc.c3b(100, 0, 0))--设置为红色
    rankingLayer:setBackGroundColorOpacity(180)--设置为透明
    rankingLayer:setBackGroundColorType(1)
    rankingLayer:setContentSize(300, 480)
    rankingLayer:setPosition(90, display.top - 100)
    rankingLayer:setAnchorPoint(0, 1)
    rankingLayer:addTo(self)
end


function RankScene:onEnter()

end

function RankScene:onExit()
end

return RankScene
