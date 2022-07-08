---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Zoybzo.
--- DateTime: 2022-07-05 16:08
---
local CoinShopLayer = class("CoinShopLayer", require("app.ui.layer.BaseLayer"))
--local
local StringDef = require("app.def.StringDef")
local OutGameData = require("app.data.OutGameData")
local ConstDef = require("app.def.ConstDef")
local CurrencyCommodityNode = require("app.ui.node.CurrencyCommodityNode")
local TowerCommodityNode = require("app.ui.node.TowerCommodityNode")
--
--local _userInfo -- 本来是想着拿个单例，但是不确定拿过来之后是引用还是拷贝 就没有用这个
--
function CoinShopLayer:ctor()
    CoinShopLayer.super.ctor(self)
    --
    self:initView()
end

function CoinShopLayer:initView()
    local itemWidth, itemHeight = ConstDef.SHOP_ITEM_WIDTH, ConstDef.SHOP_ITEM_HEIGHT
    -- 标题 “金币商店”
    local titleLayer = ccui.Layout:create():addTo(self)
    titleLayer:setContentSize(display.width, itemHeight * 3 / 4)
    -- 金币商店
    local coinTitleBase = cc.Sprite:create(StringDef.PATH_COIN_SHOP_BASE_TITLE):addTo(titleLayer)
    coinTitleBase:setPosition(display.cx, itemHeight / 8)
    coinTitleBase:setAnchorPoint(0.5, 0.5)
    --coinTitleBase:scale(display.width / 720)

    local coinTitle = cc.Sprite:create(StringDef.PATH_COIN_SHOP_STORE_TITLE):addTo(titleLayer)
    coinTitle:setPosition(display.cx, itemHeight / 8)
    coinTitle:setAnchorPoint(0.5, 0.5)
    --coinTitle:scale(display.width / 720)

    -- 刷新提示
    local freshLayer = ccui.Layout:create():addTo(self)
    freshLayer:setContentSize(display.width, itemHeight * 5 / 12)
    -- 商品刷新提示
    local refreshBase = cc.Sprite:create(StringDef.PATH_COIN_SHOP_BASE_REFRESH)
    refreshBase:setPosition(display.cx, itemHeight / 5)
    refreshBase:setAnchorPoint(0.5, 0.5)
    --refreshBase:scale(display.width / 720)
    refreshBase:addTo(freshLayer)

    local refreshTitle = cc.Sprite:create(StringDef.PATH_COIN_SHOP_TIP_REFRESH)
    refreshTitle:setPosition(display.cx * 8 / 7, itemHeight / 5)
    refreshTitle:setAnchorPoint(1, 0.5)
    --refreshTitle:scale(display.width / 720)
    refreshTitle:addTo(freshLayer)
    -- TODO 这块能不能来个EventManager
    local refreshText = display.newTTFLabel({
        text = OutGameData:getCoinShopRefreshTime(),
        font = StringDef.PATH_FONT_FZBIAOZJW,
        size = 30,
    })
    refreshText:setAnchorPoint(0, 0.5)
    refreshText:setPosition(display.cx * 11 / 9, itemHeight / 5)
    refreshText:setColor(cc.c3b(255, 206, 55))
    refreshText:enableOutline(cc.c4b(0, 0, 0, 255), 1)
    refreshText:addTo(freshLayer)
    -- 商品
    -- 滑动区域
    local rowViewDragon
    -- 本来打算做成一个CommodityNode，然后把商品放进去就行，但是不同的商品类型视图差距过大，所以还是做成一种商品一个样子吧
    local list = OutGameData:getCoinShop():getCommodityList()
    for i = 1, #(list) do
        if i % ConstDef.ROW_COMMODITY_NUMBER == 1 then
            rowViewDragon = ccui.ListView:create()
            rowViewDragon:setContentSize(itemWidth * 13 / 3, itemHeight + 20) -- 滑动区域大小
            rowViewDragon:setAnchorPoint(0.5, 0.5)
            rowViewDragon:setPosition(display.cx, itemHeight / 2)
            rowViewDragon:setDirection(2) -- 水平
            rowViewDragon:addTo(self)
        end
        local node
        if list[i]:getCommodityType() == ConstDef.COMMODITY_TYPE.CURRENCY then
            node = CurrencyCommodityNode.new(list[i])
        elseif list[i]:getCommodityType() == ConstDef.COMMODITY_TYPE.TOWER then
            node = TowerCommodityNode.new(list[i])
        else
            -- 出错了
            Log.e("Error Commodity Type in CommodityNode:initView()")
            exit()
        end
        node:addTo(rowViewDragon)
    end
end

function CoinShopLayer:onEnter()

end

function CoinShopLayer:onExit()

end

return CoinShopLayer