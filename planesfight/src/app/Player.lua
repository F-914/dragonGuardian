--local size = cc.Director:setInstance():setWinSize()
--local defaults = cc.UserDefault:setInstance()
--[[
local Player = class("Player",function()
    return cc.Sprite:create()
end)

function Player:ctor()
    --self:planeCreate()
    local scheduler = require("framework.scheduler")
end

function Player:planeCreate()

    --飞机层
    local planeLayer = ccui.Layout:create()
    --planeLayer:setBackGroundColor(cc.c3b(128, 128, 128))--设置为白色
    planeLayer:setBackGroundColorOpacity(180)--设置为透明
    --planeLayer:setBackGroundColorType(1)
    planeLayer:setContentSize(480, 720)--占满全屏
    planeLayer:setPosition(0, display.top)--左上角
    planeLayer:setAnchorPoint(0, 1)
    planeLayer:addTo(self)

    --使用图片创建飞机精灵
    local plane = cc.Sprite:create("player/red_plane.png")
    plane:setPosition(200,100)
    plane:setAnchorPoint(0, 1)
    plane:addTo(planeLayer)

    --飞机拖尾粒子
    local ps = cc.ParticleSystemQuad:create("particle/fire.plist")
    ps:setRotation(180)
    ps:setPosition(plane:getPositionX()+25,plane:getPositionY()-50)
    ps:addTo(planeLayer)

    --子弹精灵定时器，定时新增子弹，子弹定时向上移动
    bulletBorn = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--定时新增子弹，
            function()
                local bullet = cc.Sprite:create("player/blue_bullet.png")
                local X = plane:getPositionX()+25
                bullet:setPosition(plane:getPositionX()+25,plane:getPositionY()+20)--子弹出生点
                bulletFly = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--子弹定时向上移动
                        function()
                            bullet:setPosition(X,bullet:getPositionY()+20)
                        end,
                        1/60,false)
                bullet:addTo(planeLayer)
            end,
            1/10,false)

    --屏幕触摸：处理飞机和拖尾粒子的位移
    local listener = cc.EventListenerTouchOneByOne:create()
    local function onTouchBegan(touch, event)
        local target = event:getCurrentTarget()
        local size = target:getContentSize()
        local rect = cc.rect(0, 0, size.width, size.height)
        local p = touch:getLocation()
        p = target:convertTouchToNodeSpace(touch)
        if cc.rectContainsPoint(rect, p) then
            return true
        end
        return false
    end

    local function onTouchMoved(touch, event)
        local location = touch:getStartLocationInView()
        local x1 = location["x"] or 0
        print(x1 )
        --local y1 = location["y"] or 0
        --print(y1)
        local location2 = touch:getLocationInView()
        local x2 = location2["x"] or 0
        print(x2)
        --local y2 = location2["y"] or 0
        --print(y2)
        if x1<x2 then
            if x2<430 then
                plane:setPosition(x2,plane:getPositionY())
                ps:setPosition(x2+25,plane:getPositionY()-50)
            end
        elseif x1>x2 then
            if x2>0 then
                plane:setPosition(x2,plane:getPositionY())
                ps:setPosition(x2+25,plane:getPositionY()-50)
            end
        end
        print("move")
    end
    local function onTouchEnded(touch, event)
        print("触摸事件")
    end

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, plane)


    return planeLayer
end

--]]