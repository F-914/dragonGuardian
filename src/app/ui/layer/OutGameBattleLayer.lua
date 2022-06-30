--[[--
    主界面中战斗部分
    OutGameBattleLayer.lua
]]
local OutGameBattleLayer = class("OutGameBattleLayer", function()
    return display.newLayer()
end)

local GameData = require("app.test.GameData")
local Matching2nd = require("src/app/ui/secondaryui/Matching2nd.lua")
local Factory = require("src/app/utils/Factory.lua")
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
    local teamData = GameData.currentTeam_
    self.teamMap_ = Factory:createTeamSprite(teamData)

    local teamLayer = display.newLayer()
    teamLayer:setContentSize(display.width, display.height * .17)
    teamLayer:setAnchorPoint(.5, .5)
    teamLayer:setPosition(display.width * .5, display.height * .2)
    teamLayer:addTo(self)

    local selectTeamSprite = display.newSprite("res/home/battle/base_selected_team.png")
    selectTeamSprite:setPosition(display.width * .5, display.height * .08)
    selectTeamSprite:addTo(teamLayer)

    for data, node in pairs(self.teamMap_) do
        node:setPosition(-70 + display.width * 0.2 * data.location, display.height * .075)
        node:setScale(0.8)
        teamLayer:addChild(node)
    end

    local battleButton = ccui.Button:create("res/home/battle/button_battle.png")
    battleButton:setPosition(display.width * .5, display.height * .48)
    battleButton:addTo(self)
    battleButton:setScale(0.9)
    battleButton:addTouchEventListener(function(sender, eventType)
        if eventType == 2 then
            local matchingView = Matching2nd.new(self)
            self.twoLevelUi_ = matchingView
            matchingView:addTo(self:getParent())
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
    for _, node in pairs(self.teamMap_) do
        node:update(dt)
    end
    if self.twoLevelUi_ then
        self.twoLevelUi_:update(dt)
    end
end

return OutGameBattleLayer