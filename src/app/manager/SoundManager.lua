--[[--
    SoundManager.lua

    游戏内音效管理
    audio.loadFile("sounds/bgMusic.ogg",function ()
        audio.playBGM("sounds/bgMusic.ogg",true)
    end)
]]
local SoundManager = {}

--local
local audio = require("framework.audio")
local SoundDef = require("app.def.SoundDef")

function SoundManager:ctor()
    audio.setEffectsVolume(0.5)
end

function SoundManager:loadSound()
    for _,s in pairs(SoundDef) do
        audio.loadFile(s,function () end)
    end
end

function SoundManager:playSound(sound)
    if sound == "TOWER_ATK" or sound == "TOWER_ATK_HIT" then
        audio.setEffectVolume(0.5)
    else
        audio.setEffectVolume(1)
    end
    audio.playEffect(SoundDef[sound])
end

function SoundManager:playGameBGM()
    audio.playBGM(SoundDef.GAME_BGM)
end

function SoundManager:stopPlayGameBGM()
    audio.stopBGM()
end

return SoundManager