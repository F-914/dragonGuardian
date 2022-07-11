--[[--
    BossSelect2nd.lua

    描述：随机Boss弹窗
]]
local BossSelect2nd = class("BossSelect2nd", function()
    return display.newLayer()
end)

--local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local InGameData = require("app.data.InGameData")
local isRun = false    --用于存储boss图标动画是否已执行
--

-- 延时调用
-- @params callback(function) 回调函数
-- @params time(float) 延时时间(s)
-- @return 定时器
local delayDoSomething = function(callback, time)
    local handle
    handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
        callback()
    end, time, false)

    return handle
end

function BossSelect2nd:ctor()
    self:init()
    self.homing_ = false
    self.boss_ = math.random(1, 4)  --选择的boss
    self.delta_ = display.cx/2      --图标之间间隔
    self.line_ = self.delta_*8      --图标总长度
    self:randomBoss(-self.delta_ *4, 1)
    self:randomBoss(-self.delta_ *3, 2)
    self:randomBoss(-self.delta_ *2, 3)
    self:randomBoss(-self.delta_ , 4)
    self:randomBoss(0, 1)
    self:randomBoss(self.delta_ , 2)
    self:randomBoss(self.delta_ *2, 3)
    self:randomBoss(self.delta_ *3, 4)

    self.bossDelta_ = {       --四个boss：-1,0,1,2
        0,
        -self.delta_,
        self.delta_*2,
        self.delta_
    }
end

function BossSelect2nd:init()
    --随机boss时游戏暂停
    InGameData:setGameState(ConstDef.GAME_STATE.PAUSE)
    --遮罩层
    local maskLayer = ccui.Layout:create()
    maskLayer:setAnchorPoint(0.5, 0.5)
    maskLayer:setPosition(display.cx, display.cy)
    maskLayer:setContentSize(display.width, display.height)
    maskLayer:setBackGroundColor(cc.c3b(0, 0, 0))
    maskLayer:setBackGroundColorType(1)
    maskLayer:opacity(200)
    maskLayer:addTo(self, -1)
    maskLayer:setTouchEnabled(true)
    maskLayer:addTouchEventListener(function(sender, eventType) end)

    local baseMap = ccui.Scale9Sprite:create("battle_in_game/secondary_random_boss/basemap_popup.png")
    baseMap:setAnchorPoint(0.5, 0.5)
    baseMap:setPosition(display.cx, display.cy)
    local sizeBaseMap = baseMap:getContentSize()
    baseMap:setContentSize(display.width, sizeBaseMap.height)
    baseMap:addTo(self)

    local baseSelect = cc.Sprite:create("battle_in_game/secondary_random_boss/basemap_select.png")
    baseSelect:setAnchorPoint(0.5, 0.5)
    baseSelect:setPosition(display.cx, display.cy)
    local sizeBaseSelect = baseSelect:getContentSize()
    baseSelect:addTo(self)

    local arrowSprite = cc.Sprite:create("battle_in_game/secondary_random_boss/arrow_gem.png")
    arrowSprite:setAnchorPoint(0.5, 0.5)
    arrowSprite:setPosition(display.cx, display.cy + sizeBaseSelect.height/2)
    arrowSprite:addTo(self)
end

--[[--
    描述：随机boss平移

    @param double, int 图标偏移量，boss编号
]]
function BossSelect2nd:randomBoss(deltaX, num)
    local bossSprite = cc.Sprite:create("battle_in_game/secondary_random_boss/boss-"..num..".png")
    bossSprite:setAnchorPoint(0.5, 0.5)
    bossSprite:setPosition(display.cx + deltaX, display.cy)
    bossSprite:addTo(self)

    local curDelta = 0      --最后减速时的偏移量
    local speed = 50        -- 速度
    local turns = 3         -- 圈数
    local turnsNum = 0      --math.random(3, 5) * (display.width + delta)
    local curX = bossSprite:getPositionX()

    local scheduler = cc.Director:getInstance():getScheduler() --路径
    local timeSchedule = nil -- 刷新计时器(每0.1秒刷新)
    timeSchedule = scheduler:scheduleScriptFunc(function(dt)
        curX = bossSprite:getPositionX()
        if turnsNum < turns  then
            if curX > display.width + self.delta_  then
                bossSprite:setPosition(-self.delta_ *3, display.cy)
                turnsNum = turnsNum + 1
            else
                bossSprite:setPosition(curX + speed, display.cy)
            end
        elseif turnsNum == turns then
            if curX >= deltaX - display.cx/4 then
                local x = display.cx + deltaX + self.bossDelta_[self.boss_]
                bossSprite:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(1,cc.p(x, display.cy))))
                scheduler:unscheduleScriptEntry(timeSchedule)
                delayDoSomething(function ()
                    self:aniSelected()
                    isRun = true
                end, 0.4)
            else
                curDelta = curDelta + curX + speed
                bossSprite:setPosition(curX + speed, display.cy)
            end
        end
    end, 0.01, false)
    print("turns")
end

--[[--
    描述：选中boss后动画
]]
function BossSelect2nd:aniSelected()
    if isRun then
    else
        local bossSprite = cc.Sprite:create("battle_in_game/secondary_random_boss/boss-"..self.boss_..".png")
        bossSprite:setAnchorPoint(0.5, 0.5)
        bossSprite:setPosition(display.cx, display.cy)
        bossSprite:addTo(self)

        bossSprite:runAction(cc.EaseExponentialOut:create(cc.ScaleTo:create(0.5,3)))
        delayDoSomething(function ()
            self:removeFromParent()
            InGameData:setGameState(ConstDef.GAME_STATE.PLAY)
        end, 1)
    end
end

return BossSelect2nd