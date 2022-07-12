---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Zoybzo.
--- DateTime: 2022-07-07 13:08
---
local TreasureBoxCommodityNode = class("TreasureBoxCommodityNode", function()
    return ccui.Layout:create()
end)
--local
local audio = require("framework.audio")
local ConstDef = require("app.def.ConstDef")
local StringDef = require("app.def.StringDef")
local Commodity = require("app.data.Commodity")
local OutGameData = require("app.data.OutGameData")
--
--
function TreasureBoxCommodityNode:ctor(commodity)
    self.commodity_ = commodity
    --
    self:initView()
end

function TreasureBoxCommodityNode:initView()
    local commodityLayer = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("TreasureBoxLayer.csb")
    commodityLayer:addTo(self)
    -- boxButton
    local boxButton = tolua.cast(ccui.Helper:seekWidgetByName(commodityLayer, "commodityLayer"), "ccui.Button")
    -- bg
    local bgImage = tolua.cast(ccui.Helper:seekWidgetByName(commodityLayer, "bgLayer"), "ccui.Layout")
    bgImage:setBackGroundImage(ConstDef.SHOP_BOX_TYPE_BASE_PATH[self.commodity_:getCommodityCommodity():getTreasureBoxType()])
    -- box
    local boxLayer = tolua.cast(ccui.Helper:seekWidgetByName(commodityLayer, "boxLayer"), "ccui.Layout")
    boxLayer:setBackGroundImage(ConstDef.SHOP_BOX_TYPE_BOX_PATH[self.commodity_:getCommodityCommodity():getTreasureBoxType()])
    -- price
    local priceLayer = tolua.cast(ccui.Helper:seekWidgetByName(commodityLayer, "priceField"), "ccui.Layout")
    local boxPrice = display.newTTFLabel({
        text = tostring(self.commodity_:getCommodityPrice()),
        font = StringDef.PATH_FONT_FZBIAOZJW,
        size = 25
    })
    boxPrice:setAnchorPoint(2.8, 0.5)
    boxPrice:setPosition(priceLayer:getPosition())
    boxPrice:setColor(cc.c3b(255, 255, 255))
    boxPrice:enableOutline(cc.c4b(15, 16, 59, 255), 1)
    boxPrice:enableShadow(cc.c4b(17, 17, 60, 255), cc.size(0, -2), 1)
    boxPrice:addTo(priceLayer)
    -- 点击事件
    boxButton:addTouchEventListener(function(sender, eventType)
        if 0 == eventType then
            boxLayer:scale(0.8)
        end
        if 2 == eventType then
            --boxButton:setTouchEnabled(false)
            audio.playEffect(StringDef.PATH_OPEN_BOX)
            boxLayer:scale(1)
        end
    end)
end

return TreasureBoxCommodityNode