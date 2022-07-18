--[[--
    图鉴界面的二级界面，用于实现塔的详情
    TowerButtonLayer2nd.lua
]]
local TowerButtonLayer2nd = class("TowerButtonLayer2nd", require("src/app/ui/layer/BaseLayer.lua"))
--local
local ConstDef = require("app.def.ConstDef")
local OutGameData = require("app.data.OutGameData")
local StringDef = require("app.def.StringDef")
local Log = require("app.utils.Log")
--
function TowerButtonLayer2nd:ctor(cardId)
    self:init(cardId)
end

function TowerButtonLayer2nd:init(cardId)
    local ttf = {}
    ttf.fontFilePath = StringDef.PATH_TTF_HZGBJW
    ttf.fontSize = 20
    local button = ccui.Button:create(ConstDef.ICON_LIST[cardId], ConstDef.ICON_LIST[cardId])
    button:setScale(0.8)
    self:add(button)
    --button:setAnchorPoint(0.5,0.5)
    --button:setPosition(display.cx,display.cy)
    --get card
    local card = OutGameData:getUserInfo():getCardList()[cardId]
    --
    local level = display.newSprite(ConstDef.ICON_SUBINTERFACE_TOWER_LINE_UP[card:getCardLevel()])
    button:add(level)
    level:setAnchorPoint(0.5, 0.5)
    level:setPosition(button:getContentSize().width * 0.5, button:getContentSize().height * 0.4)

    local progressBg = display.newSprite(StringDef.PATH_SUBINTERFACE_TOWER_PROGRESS_BASE)
    button:add(progressBg)
    progressBg:setAnchorPoint(0.5, 0.5)
    progressBg:setPosition(button:getContentSize().width * 0.5, button:getContentSize().height * 0.2)
    local progressSprite = display.newSprite(StringDef.PATH_SUBINTERFACE_TOWER_PROGRESS)
    local progressBar = cc.ProgressTimer:create(progressSprite)
    progressBg:add(progressBar)
    progressBar:setType(display.PROGRESS_TIMER_BAR)
    progressBar:setMidpoint(cc.p(0, 0))
    progressBar:setBarChangeRate(cc.p(1, 0))
    progressBar:setAnchorPoint(0.5, 0.5)
    progressBar:setPosition(progressBg:getContentSize().width * 0.5, progressBg:getContentSize().height * 0.5)
    -- 卡牌数量
    local progressNumber = cc.Label:createWithTTF(ttf, tostring(card:getCardAmount()))
    progressBg:add(progressNumber)
    progressNumber:setAnchorPoint(0.5, 0.5)
    progressNumber:setPosition(progressBg:getContentSize().width * 0.5, progressBg:getContentSize().height * 0.5)
    -- 升级需要的卡牌
    -- TODO 同样是升级的问题
    local upgradeNumber = ConstDef.CARD_UPDATE_CONDITION.CARD_CONDITION[card:getCardLevel()].R
    --升级需要的卡片数量
    local ownedNumber = card:getCardAmount()
    --拥有的卡片数量
    progressNumber:setString(ownedNumber .. "/" .. upgradeNumber)
    progressBar:setPercentage(100 * (ownedNumber / upgradeNumber))
end

return TowerButtonLayer2nd
