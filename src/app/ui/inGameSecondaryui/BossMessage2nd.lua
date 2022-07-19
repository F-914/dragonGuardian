--[[--
    BossMessage2nd.lua

    描述：Boss信息弹窗
]]
local BossMessage2nd = class("BossMessage2nd", function()
    return display.newLayer()
end)

<<<<<<< HEAD
--local
local BossDef = require("app.def.BossDef")
local InGameData = require("app.data.InGameData")

function BossMessage2nd:ctor()
    self.bossId_ = InGameData:getCurBoss()
=======
function BossMessage2nd:ctor()
>>>>>>> dev_xz
    self:BossInfo()
end

function BossMessage2nd:BossInfo()
    --遮罩层
    local maskLayer = ccui.Layout:create()
    maskLayer:setAnchorPoint(0.5, 0.5)
    maskLayer:setPosition(display.cx, display.cy)
    maskLayer:setContentSize(display.width, display.height)
    maskLayer:setBackGroundColor(cc.c3b(0, 0, 0))
    maskLayer:setBackGroundColorType(1)
    maskLayer:opacity(200)
    maskLayer:addTo(self, -1)
    maskLayer:setTouchEnabled(true)
    maskLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            self:removeFromParent()
        end
    end)

    local infoBase = cc.Sprite:create("battle_in_game/secondary_boss_info/basemap_popup.png")
    infoBase:setAnchorPoint(0.5, 0.5)
    infoBase:setPosition(display.cx, display.cy*59/40)
    infoBase:addTo(self)
    local sizeBase = infoBase:getContentSize()

    --触摸遮挡层
    local interceptLayer = ccui.Layout:create()
    interceptLayer:setAnchorPoint(0.5, 0.5)
    interceptLayer:setPosition(display.cx, display.cy*59/40)
    interceptLayer:setContentSize(sizeBase.width, sizeBase.height)
    interceptLayer:setTouchEnabled(true)
    interceptLayer:addTo(self)

<<<<<<< HEAD
    local bossSprite = cc.Sprite:create(BossDef[self.bossId_].ICON_PATH)
=======
    local bossSprite = cc.Sprite:create("battle_in_game/secondary_boss_info/boss-1.png")
>>>>>>> dev_xz
    bossSprite:setAnchorPoint(0.5, 0.5)
    bossSprite:setPosition(display.cx - sizeBase.width*29/100, display.cy*59/40)
    bossSprite:addTo(self)

    local bossName = display.newTTFLabel({
<<<<<<< HEAD
        text = BossDef[self.bossId_].NAME,
=======
        text = "Boss 1",
>>>>>>> dev_xz
        font = "font/fzzdhjw.ttf",
        size = 34
    })
    bossName:setAnchorPoint(0, 0.5)
    bossName:setPosition(display.cx - sizeBase.width*9/100, display.cy*59/40 + sizeBase.height*6/25)
    bossName:setColor(cc.c3b(255,255,255))
    bossName:enableOutline(cc.c4b(14,14,42,255), 2)
    bossName:addTo(self)

    local skillInfo = display.newTTFLabel({
<<<<<<< HEAD
        text = BossDef[self.bossId_].SKILL_INTRODUCE,
=======
        text = "技能介绍文本",
>>>>>>> dev_xz
        font = "font/fzlthjw.ttf",
        size = 22
    })
    skillInfo:setAnchorPoint(0, 0.5)
    skillInfo:setPosition(display.cx - sizeBase.width*9/100, display.cy*59/40 - sizeBase.height*1/25)
    skillInfo:setColor(cc.c3b(255,255,255))
    skillInfo:enableOutline(cc.c4b(12,6,24,255), 1)
    skillInfo:addTo(self)

end


return BossMessage2nd