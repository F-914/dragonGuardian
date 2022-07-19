--[[--
    EnemyTowerInfo2nd.lua

    描述：Boss信息弹窗
]]
local EnemyTowerInfo2nd = class("EnemyTowerInfo2nd", function()
    return display.newLayer()
end)

<<<<<<< HEAD
--local
local EnemyTowerArrayDef = require("app.def.EnemyTowerArrayDef")

=======
>>>>>>> dev_xz
--[[--
    描述：构造函数

    @param int 敌人塔编队中塔的序号

    @return none
]]
function EnemyTowerInfo2nd:ctor(num)
    self:init()
    self:towerInfo(num)
end

function EnemyTowerInfo2nd:init()
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

    local baseSprite = cc.Sprite:create("battle_in_game/secondary_enemy_tower/basemap_popup.png")
    baseSprite:setAnchorPoint(0.5, 0.5)
    baseSprite:setPosition(display.cx, display.height*41/50)
    baseSprite:addTo(self)
<<<<<<< HEAD
    self.baseSize_ = baseSprite:getContentSize()
=======
    local sizeBase = baseSprite:getContentSize()
>>>>>>> dev_xz

    --触摸遮挡层
    local interceptLayer = ccui.Layout:create()
    interceptLayer:setAnchorPoint(0.5, 0.5)
    interceptLayer:setPosition(display.cx, display.height*41/50)
<<<<<<< HEAD
    interceptLayer:setContentSize(self.baseSize_.width, self.baseSize_.height)
=======
    interceptLayer:setContentSize(sizeBase.width, sizeBase.height)
>>>>>>> dev_xz
    interceptLayer:setTouchEnabled(true)
    interceptLayer:addTo(self)
end

--[[--
    描述：敌方塔信息展示

    @param int 敌人塔编队中塔的序号

    @return none
]]
function EnemyTowerInfo2nd:towerInfo(num)
<<<<<<< HEAD
    local towerSprite = cc.Sprite:create("battle_in_game/battle_view/tower/tower_"..EnemyTowerArrayDef[num].ID..".png")
    towerSprite:setAnchorPoint(0.5, 1)
    towerSprite:setPosition(display.cx/2, display.height*43/50)
    local sizeTowerSprite = towerSprite:getContentSize()
    towerSprite:addTo(self)

    local towerType = EnemyTowerArrayDef:getTypeString(num)
    local towerTypeSprite = cc.Sprite:create("battle_in_game/battle_view/subscript_tower_type/"..towerType..".png")
    towerTypeSprite:setAnchorPoint(1,1)
    towerTypeSprite:setPosition(display.cx/2 + sizeTowerSprite.width/2, display.height*43/50)
    towerTypeSprite:addTo(self)

    local towerName = display.newTTFLabel({
        text = "塔"..num,
        font = "font/fzzdhjw.ttf",
        size = 30
    })
    towerName:align(display.LEFT_CENTER, display.cx*3/4, display.height*43/50)
    towerName:setColor(cc.c3b(255,255,255))
    towerName:enableOutline(cc.c4b(14,14,42,255), 2)
    towerName:addTo(self)

    local rarity
    if EnemyTowerArrayDef[num].RARITY == 1 then
        rarity = "普通"
    elseif EnemyTowerArrayDef[num].RARITY == 2 then
        rarity = "稀有"
    elseif EnemyTowerArrayDef[num].RARITY == 3 then
        rarity = "史诗"
    elseif EnemyTowerArrayDef[num].RARITY ==4 then
        rarity = "传说"
    end
    local towerRare = display.newTTFLabel({
        text = rarity,
        font = "font/fzzdhjw.ttf",
        size = 24
    })
    towerRare:align(display.LEFT_CENTER, display.cx*27/20, display.height*43/50)
    towerRare:setColor(cc.c3b(255,255,255))
    towerRare:enableOutline(cc.c4b(14,14,42,255), 2)
    towerRare:addTo(self)

    local skillIntro = display.newTTFLabel({
        text = "塔"..num.."技能介绍",
        font = "font/fzzdhjw.ttf",
        size = 22
    })
    skillIntro:align(display.LEFT_CENTER, display.cx*3/4, display.height*40/50)
    skillIntro:setColor(cc.c3b(255,255,255))
    skillIntro:enableOutline(cc.c4b(12, 6, 24, 255), 1)
    skillIntro:addTo(self)
=======
    
>>>>>>> dev_xz
end

return EnemyTowerInfo2nd