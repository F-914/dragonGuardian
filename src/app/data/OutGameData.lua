---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Zoybzo.
--- DateTime: 2022-07-05 16:18
---
local OutGameData = {}
--local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local UserInfo = require("app.data.UserInfo")
local Shop = require("app.data.Shop")
local TestDataFactory = require("app.test.TestDataFactory")
--网络部分
local OutGameMsgController = require("src/app/network/OutGameMsgController.lua")
local MsgDef = require("src/app/def/MsgDef.lua")
local TableUtil = require("src/app/utils/TableUtil.lua")

--
local _userInfo
local _coinShop
local _diamondShop
local _treasureBoxRewardWinningRate
local _isAlive
--

function OutGameData:init()
    --连接到服务器
    OutGameMsgController:connect()
    self:register()

    _userInfo = UserInfo.getInstance()
    self:initCoinShop()
    self:initDiamondShop()
    self:initTreasureBoxRewardWinningRate()

    ---这个传递的表格暂时这样
    ---每一个传递的msg都应该有type类型
    --OutGameMsgController:sendMsg({
    --    type = MsgDef.INIT_USERINFO,
    --    account = _userInfo.account,
    --})
end

-- function OutGameData:init()
--     _userInfo = UserInfo:getInstance()
--     self:initCoinShop()
--     self:initDiamondShop()
--     self:initTreasureBoxRewardWinningRate()
--     --_coinShop = Shop.new()
--     --_diamondShop = Shop.new()
-- end

-- function OutGameData:update(dt)

-- end

-- 调用 OutGameData:getTreasureBoxRewardWinningRate()[ConstDef.TREASUREBOX_RARITY.R][ConstDef.TREASUREBOX_REWARD.R]
function OutGameData:getTreasureBoxRewardWinningRate()
    if _treasureBoxRewardWinningRate == nil then
        self:initTreasureBoxRewardWinningRate()
    end
    return _treasureBoxRewardWinningRate
end

function OutGameData:initTreasureBoxRewardWinningRate()
    -- TODO 感觉这个数据可能很少会发生变动，但是也不排除后续更新的可能
    _treasureBoxRewardWinningRate = {
        {
            -- 普通宝箱的没有找到
            { {}, {} },
            { {}, {} },
            { {}, {} },
            { {}, {} },
            { {}, {} }
        },
        {
            { { 130 }, { 130 } },
            { { 40 }, { 40 } },
            { { 7 }, { 7 } },
            { { 0 }, { 1 } },
            { { 1230 }, { 1230 } }
        },
        {
            { { 139 }, { 139 } },
            { { 36 }, { 36 } },
            { { 7 }, { 7 } },
            { { 0 }, { 1 } },
            { { 1280 }, { 1280 } }
        },
        {
            { { 187 }, { 187 } },
            { { 51 }, { 51 } },
            { { 21 }, { 21 } },
            { { 1 }, { 1 } },
            { { 3040 }, { 3040 } }
        }
    }
end

function OutGameData:initDiamondShop()
    -- TODO 从服务器读数据
    _diamondShop = TestDataFactory:getTestDiamondShop()
end

function OutGameData:initCoinShop()
    _coinShop = TestDataFactory:getTestCoinShop()
end

function OutGameData:initUserInfo()

end

function OutGameData:register()

    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.USERINFO_INIT, handler(self, self.initUserInfo))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.DIAMONDSHOP_INIT, handler(self, self.initDiamondShop))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.COINSHOP_INIT, handler(self, self.initCoinShop))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.USERINFO_DS, handler(self, self.userInfoDS))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.DIAMONDSHOP_DS, handler(self, self.diamondShopDS))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.COINSHOP_DS, handler(self, self.coinShopDS))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.CARD_COLLECT, handler(self, self.addCard))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE,
        handler(self, self.changeCardAttribute))
    OutGameMsgController:registerListener(MsgDef.ACKTYPE.LOBBY.ASSERT_CHANGE, handler(self, self.assertChange))
end

--[[--
    @description 本地同步来自服务器userinfo的数据
    @param msg type:table, 由服务器发送的消息
]]
function OutGameData:userInfoDS(msg)
    ---不能这么写
    --TableUtil:toUserInfo(msg)
end

--[[--
    @description 本地同步来自服务器userinfo的数据
    每一次同步都会弃用原来的数据,会造成资源浪费
    @param msg type:table, 由服务器发送的消息
]]
function OutGameData:coinShopDS(msg)
    --_coinShop = TableUtil:toShop(msg)
end

--[[--
    @description 本地同步来自服务器userinfo的数据
    每一次同步都会弃用原来的数据,会造成资源浪费
    @param msg type:table, 由服务器发送的消息
]]
function OutGameData:diamondShopDS(msg)
    --_diamondShop = TableUtil:toShop(msg)
end

function OutGameData:update(dt)
    ---在这里,进行计时，每隔一段时间进行发送消息进行数据同步
    ---同时隔一段事件发送心跳消息，确认在线
end

function OutGameData:initDiamondShop(msg)

end

function OutGameData:initCoinShop(msg)

end

function OutGameData:initUserInfo(msg)

end

--[[--
    @description 接受来自服务器的消息，确定新增的卡片,并将数据同步至本地数据
    这样一次性会发送比较多的数据吧，可能需要修改
    @msg, type:table 来自服务器的消息
    @return none
]]
function OutGameData:addCard(msg)

end

--[[--
    @description 确认来自服务器的消息，将数据同步至本地数据
    @msg type:table 来自服务器的消息
]]
function OutGameData:changeCardAttribute(msg)

end

--[[--
    @description 将购买的商品的数据同步至本地
    这是用户购买的卡片的列表

    msg中需要由userInfo属性，userInfo中需要有coinAmount和diamondAmount
    以及cardList属性

    以开宝箱为例， 在用户购买宝箱后，将开出的奖励和金币钻石的变化后的值传给服务器，服务器将数据确认保存后
    再将数据传回本地，确保本地数据和服务器统一
    另一方面，这个函数的运行要再奖励显示界面之前，不能显示奖励之后再传递消息给服务器

    其他同理

    @msg type:table 来自服务器的数据
]]
function OutGameData:purchaseCommodity(msg)
    _userInfo:setUserInfoCoinAmount(msg.userInfo.coinAmount)
    _userInfo:setUserInfoDiamondAmount(msg.userInfo.diamondAmount)

    --将卡片数据合并至userInfo中
    local msgCards = msg.userInfo.cardList
    for i = 1, #msgCards do
        local card = TableUtil:toCard(msgCards[i])
        table.insert(_userInfo:getUserInfoCardList(), card)
    end

end

--[[--
    @description 将金币和钻石的变化后的数据同步至本地
    msg中需要有userInfo属性，userInfo属性中必须有coinAmount和diamondAmount
    @msg type：table 来自服务器的数据
]]
function OutGameData:assertChange(msg)
    _userInfo:setUserInfoCoinAmount(msg.userInfo.coinAmount)
    _userInfo:setUserInfoDiamondAmount(msg.userInfo.diamondAmount)
end

-- 不太确定函数返回的是引用还是复制的值，所以调用的时候还是先调用这个再用别的
function OutGameData:getUserInfo()
    if _userInfo == nil then
        self:initUserInfo()
    end
    return _userInfo
end

function OutGameData:getCoinShop()
    if _coinShop == nil then
        self:initCoinShop()
    end
    return _coinShop
end

function OutGameData:getDiamondShop()
    if _diamondShop == nil then
        self:initDiamondShop()
    end
    return _diamondShop
end

return OutGameData
