--[[--
    主界面中战斗部分
    OutGameBattleLayer.lua
]]
local OutGameBattleLayer = class("OutGameBattleLayer", function()
    return display.newLayer()
end)
--local
local GameData = require("app.test.GameData")
local Matching_2nd = require("app.ui.secondaryui.Matching2nd")
local Factory = require("app.utils.Factory")
local StringDef = require("app.def.StringDef")
local OutGameData = require("app.data.OutGameData")
--
--[[--
    @description: 构造方法
]]
function OutGameBattleLayer:ctor()
    self.teamMap_ = {} --type:Map key = towerData, value = towerSprite
    self.twoLevelUi_ = nil --type: Layout 二级界面，用于帧刷新
    self:init()
end

--[[--
    @description: 初始化方法
]]
function OutGameBattleLayer:init()
    --local cardList = OutGameData:getUserInfo():getUserInfoCardList()
    local teamData = OutGameData:getUserInfo():getBattleTeam():getCurrentBattleTeam()
    --local teamData = {}
    --for i = 1, #teamDataIds do
    --    for j = 1, #cardList do
    --        if cardList[j].cardId_ == teamDataIds[i] then
    --            table.insert(teamData, i, cardList[j])
    --        end
    --    end
    --end
    self.teamMap_ = Factory:createTeamSprite(teamData)

    local teamLayer = display.newLayer()
    teamLayer:setContentSize(display.width, display.height * .17)
    teamLayer:setAnchorPoint(.5, .5)
    teamLayer:setPosition(display.width * .5, display.height * .2)
    teamLayer:addTo(self)

    local selectTeamSprite = display.newSprite(StringDef.PATH_BASE_SELECTED_TEAM)
    selectTeamSprite:setPosition(display.width * .5, display.height * .08)
    selectTeamSprite:addTo(teamLayer)

    for i = 1, #self.teamMap_ do
        local node = self.teamMap_[i][2]
        node:setPosition(-70 + display.width * 0.2 * i, display.height * .075)
        node:setScale(0.8)
        teamLayer:addChild(node)
    end

    local battleButton = ccui.Button:create(StringDef.PATH_BUTTON_BATTLE)
    battleButton:setPosition(display.width * .5, display.height * .48)
    battleButton:addTo(self)
    battleButton:setScale(0.9)
    battleButton:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            local matchingView = Matching_2nd.new(self)
            self.twoLevelUi_ = matchingView
            matchingView:addTo(display.getRunningScene(), 2)
        end
    end)

end

--[[--
    @description: 执行事件的注册
]]
function OutGameBattleLayer:onEnter()

end

--[[--
    @description: 执行事件的注销
]]
function OutGameBattleLayer:onExit()

end

--[[--
    @description: 帧刷新
    @param dt type: number, 帧间隔
    @return none
]]
function OutGameBattleLayer:update(dt)
    for i = 1, #self.teamMap_ do
        self.teamMap_[i][2]:update()
    end
    if self.twoLevelUi_ then
        self.twoLevelUi_:update(dt)
    end
end

return OutGameBattleLayer
