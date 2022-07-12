--[[--
    游戏内界面
    InGameScene.lua
]]
local InGameScene = class("InGameScene", function()
    return display.newScene("InGameScene")
end)

--local
local InGameData = require("app.data.InGameData")
local InGameBattleView = require("app.ui.InGameBattleView")
--

function InGameScene:ctor()
    self.inGameBattleView_ = InGameBattleView.new()
    self:addChild(self.inGameBattleView_)

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
    self:performWithDelay(function() 
        self:scheduleUpdate()
    end, 1)
end

function InGameScene:onEnter()
    InGameData:createEnemyInterval()
end

function InGameScene:onExit()
    
end

function InGameScene:update(dt)
    InGameData:update(dt)

    if InGameData:isPlaying() then
        self.inGameBattleView_:update(dt)
    end
end



return InGameScene