--[[--
    游戏内界面
    InGameScene.lua
]]
local InGameScene = class("InGameScene", function()
    return display.newScene("InGameScene")
end)

--local
local InGameBattleView = require("app.ui.InGameBattleView")
--

function InGameScene:ctor()
    self.inGameBattleView_ = InGameBattleView.new()
    self:addChild(self.inGameBattleView_)
end

function InGameScene:onEnter()
    
end

function InGameScene:onExit()
    
end

function InGameScene:update()
    
end



return InGameScene