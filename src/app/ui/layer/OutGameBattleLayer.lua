--[[--
    主界面中战斗部分
    OutGameBattleLayer.lua
]]
local OutGameBattleLayer = class("OutGameBattleLayer", function()
    return display.newLayer()
end)
--local
local Matching_2nd = require("app.ui.secondaryui.Matching2nd")
local Factory = require("app.utils.Factory")
local StringDef = require("app.def.StringDef")
local OutGameData = require("app.data.OutGameData")
local Log = require("app.utils.Log")
local EventManager = require("app.manager.EventManager")
local EventDef = require("app.def.EventDef")
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
    local teamData = OutGameData:getUserInfo():getBattleTeam():getCurrentBattleTeam()

    self.teamMap_ = Factory:createTeamSprite(teamData)

    local teamLayer = display.newLayer()
    teamLayer:setContentSize(display.width, display.height * .17)
    teamLayer:setAnchorPoint(.5, .5)
    teamLayer:setPosition(display.width * .5, display.height * .2)
    teamLayer:addTo(self)

    local selectTeamSprite = display.newSprite(StringDef.PATH_BASE_SELECTED_TEAM)
    selectTeamSprite:setPosition(display.width * .5, display.height * .08)
    selectTeamSprite:addTo(teamLayer)
    -- local cardList = OutGameData:getUserInfo():getCardList()
    -- for i = 1, #(teamData) do
    --     local node = self.teamMap_[ cardList[teamData[i]] ]
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
            --local matchingView = Matching_2nd.new(self)
            --self.twoLevelUi_ = matchingView
            --matchingView:addTo(display.getRunningScene(), 2)
            --EventManager:doEvent(EventDef.ID.SEND_LINEUP, self)
            -- TODO 暂时改成了直接进入单机模式
            local inGameScene = require("app.scenes.InGameScene").new()
            display.replaceScene(inGameScene)
        end
    end)

end

--[[--
    @description: 执行事件的注册
]]
function OutGameBattleLayer:onEnter()
    -- TODO 这块应该更新一下 如果图鉴页面更改了战斗小队的卡牌 那么这里应该更新一下战斗小队的显示
    -- TODO 考虑到这里有等级显示 那么每次升级之后同样需要更新
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
