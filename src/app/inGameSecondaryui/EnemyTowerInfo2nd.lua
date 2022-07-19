--[[--
    EnemyTowerInfo2nd.lua

    描述：Boss信息弹窗
]]
local EnemyTowerInfo2nd = class("EnemyTowerInfo2nd", function()
    return display.newLayer()
end)

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
    local sizeBase = baseSprite:getContentSize()

    --触摸遮挡层
    local interceptLayer = ccui.Layout:create()
    interceptLayer:setAnchorPoint(0.5, 0.5)
    interceptLayer:setPosition(display.cx, display.height*41/50)
    interceptLayer:setContentSize(sizeBase.width, sizeBase.height)
    interceptLayer:setTouchEnabled(true)
    interceptLayer:addTo(self)
end

--[[--
    描述：敌方塔信息展示

    @param int 敌人塔编队中塔的序号

    @return none
]]
function EnemyTowerInfo2nd:towerInfo(num)
    
end

return EnemyTowerInfo2nd