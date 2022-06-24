local MenuScene = require"app.scenes.MenuScene"
local ShopScene = require"app.scenes.ShopScene"

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
end

function MainScene:onEnter()
    MenuScene.new(self, 1)
    --ShopScene.new(self, 0)
    self:sliderView()
end

function MainScene:onExit()
end

--[[--
    描述：滑动窗口

    @param none

    @return none
]]
local pageView
function MainScene:setPage(num)
    print("setPage")
    pageView:scrollToPage(num)
end

function MainScene:sliderView()
    -- PageView
    pageView = ccui.PageView:create()
    -- 设置PageView容器尺寸
    pageView:setBackGroundColor(cc.c3b(200,200,255))
    pageView:setBackGroundColorType(1)
    pageView:setContentSize(display.width, display.height)
    pageView:setTouchEnabled(true)    -- 设置可触摸 若设置为false 则不能响应触摸事件
    pageView:setAnchorPoint(0.5, 0.5)
    pageView:setPosition(display.cx, display.cy)

    -- 这里创建page
    for i = 1,3 do
        -- 以层作为载体传入pageview
        local layer = ccui.Layout:create()
        layer:setAnchorPoint(0, 0)
        layer:setPosition(0, 0)
        layer:setContentSize(display.width, display.height)
        ShopScene.new(layer, 0)
        pageView:addPage(layer)
    end

    -- 触摸回调
    local function PageViewCallBack(sender,event)
        -- 翻页时
        if event==ccui.PageViewEventType.turning then
        -- getCurrentPageIndex() 获取当前翻到的页码 打印
            print("当前页码是"..pageView:getCurPageIndex() + 1)
            MenuScene:bottomMenuControl(pageView:getCurPageIndex() + 1)
        end
    end
    pageView:addEventListener(PageViewCallBack)

    -- 翻到第2页(从0开始算)
    pageView:scrollToPage(1)

    -- 水平翻页
    -- pageView:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)

    -- 垂直翻页
    -- pageView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)

    self:addChild(pageView, 0)

    --return sliderLayer
end

return MainScene
