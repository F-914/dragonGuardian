--[[--
    该类仅用于测试
    MainScene.lua
]]
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local GameData = require("src/app/data/GameData.lua")
local MainUIBattle = require("src/app/ui/MainUIBattleView.lua")

function MainScene:ctor()
    GameData:init()

    self.mainUIBattle_ = MainUIBattle.new()
    self:addChild(self.mainUIBattle_)

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
    self:performWithDelay(function()
        self:scheduleUpdate()
    end, 1)

end

function MainScene:update(dt)
    GameData:update(dt)
    self.mainUIBattle_:update(dt)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
