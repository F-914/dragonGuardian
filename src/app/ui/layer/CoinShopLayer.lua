---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Zoybzo.
--- DateTime: 2022-07-05 16:08
---
local CoinShopLayer = class("CoinShopLayer",
        require("app.ui.layer.BaseLayer")
        --function()
        --    return ccui.Layout:create()
        --end
)
--local
local StringDef = require("app.def.StringDef")
local OutGameData = require("app.data.OutGameData")
local ConstDef = require("app.def.ConstDef")
local CurrencyCommodityNode = require("app.ui.node.CurrencyCommodityNode")
local TowerCommodityNode = require("app.ui.node.TowerCommodityNode")
local Log = require("app.utils.Log")
--
--local _userInfo -- 本来是想着拿个单例，但是不确定拿过来之后是引用还是拷贝 就没有用这个
--
function CoinShopLayer:ctor()
    CoinShopLayer.super.ctor(self)
    --
    self:initView()
end

function CoinShopLayer:initView()
    --local itemWidth, itemHeight = ConstDef.SHOP_ITEM_WIDTH, ConstDef.SHOP_ITEM_HEIGHT
    local coinShopLayer = cc.CSLoader:getInstance():createNodeWithFlatBuffersFile("CoinShopLayer.csb"):addTo(self)
    -- 刷新时间倒计时
    local freshLayer = tolua.cast(ccui.Helper:seekWidgetByName(coinShopLayer, "freshTime"), "ccui.Layout")
    -- TODO 这块能不能来个EventManager
    local refreshText = display.newTTFLabel({

        text = OutGameData
                :getCoinShop()
                :getCoinShopRefreshTime(),

        text = OutGameData:getCoinShop():getCoinShopRefreshTime(),

        text = OutGameData
                :getCoinShop()
                :getCoinShopRefreshTime(),

        text = OutGameData:getCoinShop():getCoinShopRefreshTime(),

        text = OutGameData
            :getCoinShop()
            :getCoinShopRefreshTime(),

        font = StringDef.PATH_FONT_FZBIAOZJW,
        size = 30,
    })
    refreshText:setAnchorPoint(0, -0.35)
    refreshText:setContentSize(freshLayer:getContentSize())
    Log.i("freshLayer Position: " .. freshLayer:getPositionX() .. ' ' .. freshLayer:getPositionY())
    refreshText:setColor(cc.c3b(255, 206, 55))
    refreshText:enableOutline(cc.c4b(0, 0, 0, 255), 1)
    refreshText:addTo(freshLayer)
    -- 商品
    local storeRows = {
        tolua.cast(ccui.Helper:seekWidgetByName(coinShopLayer, "rowListView1"), "ccui.ListView"),
        tolua.cast(ccui.Helper:seekWidgetByName(coinShopLayer, "rowListView2"), "ccui.ListView")
    }
    local list = OutGameData:getCoinShop():getCommodityList()
    for i = 1, #(list) do
        local node
        if list[i]:getCommodityType() == ConstDef.COMMODITY_TYPE.CURRENCY then
            Log.i("node: currency")
            node = CurrencyCommodityNode.new(list[i])
        elseif list[i]:getCommodityType() == ConstDef.COMMODITY_TYPE.TOWER then
            Log.i("node: tower")
            node = TowerCommodityNode.new(list[i])
        else
            -- 出错了
            Log.e("Error Commodity Type in CommodityNode:initView()")
            exit()
        end
        local index = 1
        if i > ConstDef.ROW_COMMODITY_NUMBER then
            index = 2
        end
        --node:addTo(storeRows[index])
        storeRows[index]:pushBackCustomItem(node)
    end
end

function CoinShopLayer:onEnter()

end

function CoinShopLayer:onExit()

end

return CoinShopLayer
