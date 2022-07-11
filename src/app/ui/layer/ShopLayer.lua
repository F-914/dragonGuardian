---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Zoybzo.
--- DateTime: 2022-07-05 15:00
---
local ShopLayer = class("ShopLayer", require("app.ui.layer.BaseLayer"))
--local
local StringDef = require("app.def.StringDef")
local CoinShopLayer = require("app.ui.layer.CoinShopLayer")
local DiamondShopLayer = require("app.ui.layer.DiamondShopLayer")
--
--

function ShopLayer:ctor()
    ShopLayer.super.ctor(self)
    --
    self.coinShopLayer_ = nil
    self.diamondShopLayer_ = nil
    --
    self:initView()
end

function ShopLayer:initView()
    local listView = ccui.ListView:create()
    listView:setContentSize(display.width, display.height * 7 / 8) -- 滑动区域大小
    listView:setAnchorPoint(0.5, 0.5)
    listView:setPosition(display.cx, display.cy)
    listView:setDirection(1) -- 垂直
    listView:addTo(self)

    self.coinShopLayer_ = CoinShopLayer.new()
    listView:addChild(self.coinShopLayer_)

    --self.diamondShopLayer_ = DiamondShopLayer.new()
    --listView:addChild(self.diamondShopLayer_)
end

function ShopLayer:onEnter()

end

function ShopLayer:onExit()

end

return ShopLayer
