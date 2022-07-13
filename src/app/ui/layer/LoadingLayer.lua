--[[--
    创造进度条的layer
    LoadingLayer.lua
]]
local PATH_PROGRESS_BG="res/loading/progress_base.png"
local PATH_PROGRESS = "res/loading/progress_stretch.png"
--local PATH_TTF_HZGBJW="res/front/fzhzgbjw.ttf"

local LoadingLayer=class("LoadingLayer",require("src/app/ui/layer/BaseLayer.lua"))
local EventDef = require("src/app/def/EventDef.lua")
local EventManager = require("src/app/manager/EventManager.lua")
function LoadingLayer:ctor()
    self:init()
end
function LoadingLayer:init()
   
    local width=cc.Director:getInstance():getWinSize().width
    local progressBg = display.newSprite(PATH_PROGRESS_BG)
    self:add(progressBg)
    progressBg:setAnchorPoint(0.5,0.5)
    progressBg:setPosition(display.cx,display.cy)
    progressBg:setScaleX(width/progressBg:getContentSize().width)
    local progressSprite=display.newSprite(PATH_PROGRESS)
    progressSprite:setScaleX(width/progressSprite:getContentSize().width)
    local progress=cc.ProgressTimer:create(progressSprite)
    progressBg:add(progress)
    progress:setType(display.PROGRESS_TIMER_BAR)
    progress:setMidpoint(cc.p(0,0))
    progress:setBarChangeRate(cc.p(1,0))
    progress:setAnchorPoint(0.5,0.5)
    progress:setPosition(progressBg:getContentSize().width*0.5,progressBg:getContentSize().height*0.5)
    progress:setPercentage(0)
    local percent=0
   
    local function scheduler()
         percent=percent+1
         progress:setPercentage(percent)
         EventManager:doEvent(EventDef.LOGIN.LOADING_PROGRESS)
         if percent==100 then
            self:unscheduleUpdate()
            --可以在此处写入切换主场景的代码，最好有延时
         end
    end
    self:scheduleUpdateWithPriorityLua(scheduler,0)
   

end

return LoadingLayer