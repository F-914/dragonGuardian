--[[--
    主界面
    OutGameScene.lua
]]
local OutGameScene = class("OutGameScene", function()
    return display.newScene("OutGameScene")
end)

-- local
local LoadView = require("app.ui.LoadView")
local StringDef = require("app.def.StringDef")
local AtlasView = require("app.ui.AtlasView")
--local GameData = require("app.test.GameData")
local MainUIBattleView = require("app.ui.MainUIBattleView")
local MenuView = require("app.ui.MenuView")
local ShopView = require("app.ui.ShopView")
local Log = require("app.utils.Log")
local MenuConfig = require("app.test.MenuConfig")
local OutGameData = require("app.data.OutGameData")
--
local pageView
local loadView
--
---GameData我这里至少是没用了
function OutGameScene:ctor()
    loadView = LoadView.new()
    loadView:addTo(self, 3)
    --test
    --OutGameData:init()
    ---在这里我随便写了个
    OutGameData:init("scsacasca")
    self.mainUIBattleView_ = MainUIBattleView.new()
    self.atlasView_ = AtlasView.new()
    self.shopView_ = ShopView.new()

    MenuView.new(self, 1)
    self:sliderView()

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
    self:performWithDelay(function()
        self:scheduleUpdate()
    end, 1)
end

function OutGameScene:onEnter()

    -- 主界面默认音乐播放
    if MenuConfig.IS_PLAY_BGM then
        Log.i("主界面音乐播放")
        local audio = require("framework.audio")
        audio.loadFile(StringDef.PATH_LOBBY_BGM_120BPM, function()
            audio.playBGM(StringDef.PATH_LOBBY_BGM_120BPM, true)
        end)
    end

end

function OutGameScene:update(dt)
    --GameData:update(dt)
    OutGameData:update(dt)
    self.mainUIBattleView_:update(dt)
end

function OutGameScene:onExit()
end

--[[--
    描述：删除加载界面
]]
function OutGameScene:quitLoading()
    if loadView ~= nil then
        Log.i("loadingView", loadView)
        loadView:removeFromParent()
    end
end

--[[--
    描述：滑动窗口

    @param none

    @return none
]]
function OutGameScene:setPage(num)
    Log.i("setPage")
    pageView:scrollToPage(num)
end

function OutGameScene:sliderView()
    -- PageView
    pageView = ccui.PageView:create()
    -- 设置PageView容器尺寸
    pageView:setBackGroundColor(cc.c3b(200, 200, 255))
    pageView:setBackGroundColorType(1)
    pageView:setContentSize(display.width, display.height)
    pageView:setTouchEnabled(true) -- 设置可触摸 若设置为false 则不能响应触摸事件
    pageView:setAnchorPoint(0.5, 0.5)
    pageView:setPosition(display.cx, display.cy)

    -- 这里创建page
    local layerTable = {
        self.shopView_,
        self.mainUIBattleView_,
        self.atlasView_,
    }
    for i = 1, 3 do
        -- 以层作为载体传入pageview
        local layer = ccui.Layout:create()
        layer:setAnchorPoint(0, 0)
        layer:setPosition(0, 0)
        layer:setContentSize(display.width, display.height)
        -- ShopScene.new(layer, 0)
        layerTable[i]:addTo(layer, 0)
        pageView:addPage(layer)
        -- pageView:addPage(layerTable[i])
    end

    -- 触摸回调
    local function PageViewCallBack(sender, event)
        -- 翻页时
        if event == ccui.PageViewEventType.turning then
            -- getCurrentPageIndex() 获取当前翻到的页码 打印
            Log.i("当前页码是" .. pageView:getCurPageIndex() + 1)
            MenuView:bottomMenuControl(pageView:getCurPageIndex() + 1)
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

return OutGameScene
