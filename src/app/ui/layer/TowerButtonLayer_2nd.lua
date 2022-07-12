--[[--
    图鉴界面的二级界面，用于实现塔的详情
    TowerButtonLayer_2nd.lua
]]
local TowerButtonLayer_2nd = class("TowerButtonLayer_2nd", require("src/app/ui/layer/BaseLayer.lua"))
local PATH_PROGRESS_BASE = "res/home/guide/subinterface_tower_list/progress_base_fragments_number.png"
local PATH_PROGRESS = "res/home/guide/subinterface_tower_list/progress_progress_fragments_number.png"
local PATH_TTF = "res/front/fzhzgbjw.ttf"
local ConstDef = require("src/app/test/ConstDef.lua")
local PATH_LEVEL={
 "res/home/guide/subinterface_current_lineup/level/Lv.1.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.2.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.3.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.4.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.5.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.6.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.7.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.8.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.9.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.10.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.11.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.12.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.13.png",
}
function TowerButtonLayer_2nd:ctor(card)
    self:init(card)
end
function TowerButtonLayer_2nd:init(card)
    local ttf = {}
    ttf.fontFilePath = PATH_TTF
    ttf.fontSize = 20
    local button = ccui.Button:create(ConstDef.ICON_LIST[card.order], ConstDef.ICON_LIST[card.order])
    button:setScale(0.8)
    self:add(button)
    --button:setAnchorPoint(0.5,0.5)
    --button:setPosition(display.cx,display.cy)
    local level = display.newSprite(PATH_LEVEL[1])
    button:add(level)
    level:setAnchorPoint(0.5, 0.5)
    level:setPosition(button:getContentSize().width * 0.5, button:getContentSize().height * 0.4)

    local progressBg = display.newSprite(PATH_PROGRESS_BASE)
    button:add(progressBg)
    progressBg:setAnchorPoint(0.5, 0.5)
    progressBg:setPosition(button:getContentSize().width * 0.5, button:getContentSize().height * 0.2)
    local progressSprite = display.newSprite(PATH_PROGRESS)
    local progressBar = cc.ProgressTimer:create(progressSprite)
    progressBg:add(progressBar)
    progressBar:setType(display.PROGRESS_TIMER_BAR)
    progressBar:setMidpoint(cc.p(0, 0))
    progressBar:setBarChangeRate(cc.p(1, 0))
    progressBar:setAnchorPoint(0.5, 0.5)
    progressBar:setPosition(progressBg:getContentSize().width * 0.5, progressBg:getContentSize().height * 0.5)

    local progressNumber = cc.Label:createWithTTF(ttf, "0")
    progressBg:add(progressNumber)
    progressNumber:setAnchorPoint(0.5, 0.5)
    progressNumber:setPosition(progressBg:getContentSize().width * 0.5, progressBg:getContentSize().height * 0.5)
    local upgradeNumber = card.upgradeNumber
     --升级需要的卡片数量
    local ownedNumber = card.ownedNumber
     --拥有的卡片数量
    progressNumber:setString(ownedNumber .. "/" .. upgradeNumber)

    progressBar:setPercentage(100 * (ownedNumber / upgradeNumber))
end
return TowerButtonLayer_2nd
