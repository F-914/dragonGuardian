--[[--
    该类仅用于测试 因为我们可能要测试不同的页面，页面之间暂时没有关联，所以这里暂时都留下来了，然后注释了一下
    可以考虑做成很多个按钮，按哪个出来哪个
    MainScene.lua
]]
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

-- local
local AtlasView = require("src/app/ui/AtlasView.lua")
local GameData = require("src/app/data/GameData.lua")
local MainUIBattle = require("src/app/ui/MainUIBattleView.lua")
--

-- xz
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

--

-- txf
-- function MainScene:ctor()
--     local atalasView = AtlasView.new()
--     self:add(atalasView)
-- end
--

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
