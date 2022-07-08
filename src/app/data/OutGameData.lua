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
--
local _userInfo
local _coinShop
local _diamondShop
--

function OutGameData:init()
    _userInfo = UserInfo.getInstance()
    self:initCoinShop()
    self:initDiamondShop()
    --_coinShop = Shop.new()
    --_diamondShop = Shop.new()
end

function OutGameData:update(dt)

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