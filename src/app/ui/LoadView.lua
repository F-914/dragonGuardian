--[[--
    加载界面
    LoadView.lua
]]
local LoadView = class("LoadView", function()
    return display.newColorLayer(cc.c4b(0, 0, 0, 0))
end)
--local
local Log = require("app.utils.Log")
require("socket")
<<<<<<< HEAD
--
=======
>>>>>>> origin/dev_xz
local _layer
--

function LoadView:ctor()
    self:initView()
end

--[[--
    描述：延时函数
    使用socket库中select函数，可以传递0.1给n，使得休眠的时间精度达到毫秒级别。
]]
local function sleep(n)
    socket.select(nil, nil, n)
end

function LoadView:initView()
<<<<<<< HEAD

=======
>>>>>>> origin/dev_xz
    _layer = ccui.Layout:create()
    _layer:setAnchorPoint(0.5, 0.5)
    _layer:setContentSize(display.width, display.height)
    _layer:setPosition(display.cx, display.cy)
    _layer:addTo(self)

    local loadBase = ccui.Layout:create()
    loadBase:setBackGroundImage("loading/background.jpg")
    loadBase:setAnchorPoint(0.5, 0.5)
    loadBase:setPosition(display.cx, display.cy)
    loadBase:setContentSize(display.width, display.height)
    loadBase:addTo(_layer)

    -- 遮罩
    local loadBaseMask = ccui.Layout:create()
    loadBaseMask:setAnchorPoint(0.5, 0.5)
    loadBaseMask:setPosition(display.cx, display.cy)
    loadBaseMask:setContentSize(display.width, display.height)
    loadBaseMask:setTouchEnabled(true)
    loadBaseMask:addTo(_layer)

    local tipsLabel = display.newTTFLabel({
        text = "大厅预加载，进行中...",
        font = "font/fzhz.ttf",
        size = 20
    })
    tipsLabel:align(display.CENTER, display.cx, display.cy / 15)
    tipsLabel:setColor(cc.c3b(255, 255, 255))
    tipsLabel:addTo(_layer)

    local num = 0 -- 加载进度
    local loadingLabel = display.newTTFLabel({
        text = num .. "%",
        font = "font/fzhz.ttf",
        size = 20
    })
    loadingLabel:align(display.RIGHT_CENTER, display.width, display.cy / 15)
    loadingLabel:setColor(cc.c3b(253, 239, 117))
    loadingLabel:addTo(_layer)

    ----------------------------------------------------------------------------
    -- 进度条
    local barBaseSprite = display.newScale9Sprite("loading/progress_base.png", 0, 0, cc.size(display.width, 15))
    barBaseSprite:setAnchorPoint(0, 0)
    barBaseSprite:setPosition(0, 0)
    barBaseSprite:addTo(_layer)

    local barSprite = display.newScale9Sprite("loading/progress_stretch.png", 0, 0, cc.size(display.width / 4, 15))
    barSprite:setAnchorPoint(0, 0)
    barSprite:setPosition(0, 0)
    barSprite:setContentSize(0, 15)
    barSprite:addTo(_layer)
    local sizeCurBar = barSprite:getContentSize()

    local headBarSprite = cc.Sprite:create("loading/progress_head.png")
    headBarSprite:setAnchorPoint(0, 0)
    headBarSprite:setPosition(sizeCurBar.width, 0)
    headBarSprite:addTo(_layer)

    local scheduler = cc.Director:getInstance():getScheduler() --路径
    local progress = 0 -- 进度
    local timeSchedule = nil -- 刷新计时器(每0.1秒刷新)
    timeSchedule = scheduler:scheduleScriptFunc(function(dt)
<<<<<<< HEAD
        --Log.i("loading……")
        progress = progress + display.width / 100
        --Log.i(progress .. "")
=======
        Log.i("loading……")
        progress = progress + display.width / 100
        Log.i(progress .. "")
>>>>>>> origin/dev_xz
        barSprite:setContentSize(progress, 15)
        sizeCurBar = barSprite:getContentSize()
        headBarSprite:setPosition(sizeCurBar.width, 0)
        num = progress / display.width * 100
        num = string.format("%d", num + 1) -- 不知道为啥不+1的话会停在99%
        loadingLabel:setString(num .. "%")

        if progress >= display.width then
            scheduler:unscheduleScriptEntry(timeSchedule)
            sleep(1)
            self:quitLoading()
        end
    end, 0.01, false)
end

--[[--
    描述：调用函数关闭加载界面
]]
function LoadView:quitLoading()
    OutGameScene = require "app.scenes.OutGameScene"
    OutGameScene:quitLoading()
end

return LoadView
