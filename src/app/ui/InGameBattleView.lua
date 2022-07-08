--[[--
    InGameBattleView.lua

    描述：游戏内战斗界面，分两层：底层背景、敌人--> 上层背景、顶部UI、格子中的塔
]]
local InGameBattleView = class("InGameBattleView", function()
    return display.newColorLayer(cc.c4b(0, 0, 0, 0))
end)

local InGameDownLayer = require("app.ui.layer.InGameDownLayer")
local InGameUpLayer = require("app.ui.layer.InGameUpLayer")

function InGameBattleView:ctor()
    self.inGameDownLayer_ = nil    -- type:layer，游戏内UI第二层
    self.inGameUpLayer_ = nil    -- type:layer，游戏内UI第一层
    self:init()
end

function InGameBattleView:init()
    self.inGameDownLayer_ = InGameDownLayer.new()
    self:addChild(self.inGameDownLayer_, 0)
    self.inGameUpLayer_ = InGameUpLayer.new()
    self:addChild(self.inGameUpLayer_, 1)
end


return InGameBattleView