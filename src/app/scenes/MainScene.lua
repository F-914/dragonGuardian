local MenuScene = require"app.scenes.MenuScene"
local ShopScene = require"app.scenes.ShopScene"

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
end

function MainScene:onEnter()
    MenuScene.new(self)
    ShopScene.new(self)
end

function MainScene:onExit()
end

return MainScene
