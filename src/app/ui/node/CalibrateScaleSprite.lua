---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Asus.
--- DateTime: 2022/6/23 9:59
---
--[[--
    刻度尺的精灵
    CalibrateScaleSprite.lua
]]

local CalibrateScaleSprite = class("CalibrateScaleSprite", function(res)
    return display.newSprite(res)
end)

-- local
local StringDef = require("app.def.StringDef")
local GameData = require("app.test.GameData")
-- require的方式不一样好像会导致OutGameData被引入的不一样 比如下面这种被注释的情况就会导致OutGameData没有初始化过
--local OutGameData = require("src.app.data.OutGameData")
local OutGameData = require("app.data.OutGameData")
local Log = require("app.utils.Log")
--

--[[--
    @description: 构造方法
    @param res type: string 纹理
    @param userKeyQuantity: number ,用户当前的要是数量
    @return none
]]
function CalibrateScaleSprite:ctor(res)
    self.trophyAmount_ = nil --记录当前钥匙数量，用于帧刷新和创建进度条
    self.rewordNodeData_ = nil --用于访问奖励数据

    self.yellowScale_ = nil --用于帧刷新
    self.decorateBar_ = nil --用于帧刷新

    self:init()
end

--[[--
    @description:初始化，构造纹理
    @param none
    @return none
]]
function CalibrateScaleSprite:init()
    ---数据源
    self.trophyAmount_ = OutGameData
        :getUserInfo()
        :getTrophyAmount()
    self.rewordNodeData_ = OutGameData
        :getUserInfo()
        :getUserInfoLadder()
        :getLadderList()
    Log.i("TrophyAmount_: " .. tostring(self.trophyAmount_))

    self:setScale(3, 1)

    local yellowScale = display.newSprite(StringDef.PATH_HIGH_LADDER_CALIBRATED_SCALE_CUTOFF)
    yellowScale:setAnchorPoint(1, 0)
    yellowScale:setScale(3, .8)
    yellowScale:setPosition(26.5 + (self.trophyAmount_ / 50 - 1) * 40.1, 9)
    yellowScale:addTo(self)

    local spriteDecorate = display.newSprite(StringDef.PATH_HIGH_LADDER_DECORATE_BAR)
    spriteDecorate:setAnchorPoint(1, 0)
    spriteDecorate:setScale(.5, .8)
    spriteDecorate:setPosition(28.5 + (self.trophyAmount_ / 50 - 1) * 40.1, 7)
    spriteDecorate:addTo(self)

    ---获取进度条的指针，用于后续的刷新
    self.yellowScale_ = yellowScale
    self.decorateBar_ = spriteDecorate

    for i = 1, #self.rewordNodeData_ do
        local num = self.rewordNodeData_[i].trophyCondition_
        local quantityTTF = display.newTTFLabel({
            text = tostring(num),
            font = StringDef.PATH_FONT_FZBIAOZJW,
            size = 18,
            color = cc.c3b(168, 176, 225)
        })
        quantityTTF:setPosition(26 + (i - 1) * 40.1, -10)
        quantityTTF:setScale(0.3, 0.9)
        quantityTTF:addTo(self)

        local cutoffScale = nil
        if num < self.trophyAmount_ then
            cutoffScale = display.newSprite(StringDef.PATH_HIGH_LADDER_CALIBRATED_SCALE_CUTOFF_SCALE)
        else
            cutoffScale = display.newSprite(StringDef.PATH_HIGH_LADDER_CALIBRATED_SCALE_SCALE)
        end

        cutoffScale:setScale(0.5, 1)
        cutoffScale:setPosition(26 + (i - 1) * 40.1, 13)
        cutoffScale:addTo(self)
    end
end

--[[--
    @description: 帧刷新
    @param dt type:number 帧间隔
    @return none
]]
function CalibrateScaleSprite:update(dt)
    --监听到用户的钥匙数量发生变化
    if not self.trophyAmount_ ~= GameData.trophyAmount_ then
        self.trophyAmount_ = GameData.trophyAmount_
        self.decorateBar_:setPosition(28.5 + (self.trophyAmount_ / 50 - 1) * 40.1, 7)
        self.yellowScale_:setPosition(26.5 + (self.trophyAmount_ / 50 - 1) * 40.1, 9)
    end
end

return CalibrateScaleSprite
