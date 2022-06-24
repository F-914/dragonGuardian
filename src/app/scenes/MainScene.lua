local AtlasView=require("src/app/ui/AtlasView.lua")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
   local atalasView=AtlasView.new()
   self:add(atalasView)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
