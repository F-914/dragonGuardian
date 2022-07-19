---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Asus.
--- DateTime: 2022/6/22 16:05
---
--[[--
    表示奖品的精灵
    RewardSprite
]]
local RewardSprite = class("RewardSprite", function(res)
    return display.newSprite(res)
end)
--local
local Factory = require("app.utils.Factory")
local StringDef = require("app.def.StringDef")
local ConstDef = require("src/app/def/ConstDef.lua")
--[[--
    @description: 构造方法
    @param res type:string, 精灵纹理
    @param data type:Reward, 精灵对应的对象
    @return none
]]
function RewardSprite:ctor(res, data)
    self.data_ = data --type: table, 精灵对应的数据
    self.locked_ = data.locked_
    self.received_ = data.received_
    ---这两个属性用来与data中的属性比较，
    ---如果不同，
    ---就更改纹理，如果相同，就不更改，
    ---之前本来不是想的这种实现方式，
    ---而是采用领取奖励后调用纹理贴图变化的函数，
    ---更改成这种模式的目的，就是减少各个界面和二级界面的耦合，最好达到
    ---界面之间没有任何耦合，界面只负责暂时数据，以及提供控制器

    self.button_ = nil --type: Button,用于按钮事件
    self.size_ = self:getContentSize() --type: table, 当前精灵的大小，用于计算和帧刷新
    local button = Factory:createRewardButton(self.data_)
    self.button_ = button

    local lockSp = Factory:createBorderStateSprite(self.data_.locked, self.data_.received)
    if lockSp then
        lockSp:setPosition(self.size_.width * .5, 3)
        lockSp:addTo(self)
    end

    local quantityTTF = nil
    ---这里改成这样,更符合数据模型
    if self.data_.type == ConstDef.REWARD_TYPE.CURRENCY then
        quantityTTF = display.newTTFLabel({
<<<<<<< HEAD
            -- 这个quanity和amount不知道是哪个对，两个都保留了然后注释了一个
            -- text = tostring(self.data_.quantity),
            -- 这个只对数量不是一的东西生效，比如金币和钻石，所以应该是
            -- amount就行
            text = tostring(self.data_.amount),
=======
            text = tostring(self.data_.reward_.currencyAmount_),
>>>>>>> origin/dev_xz
            font = StringDef.PATH_FONT_FZBIAOZJW,
            size = 18,
            color = cc.c3b(168, 176, 225)
        })
    end
    -- TODO 需要改的有点多 后面再改
    if quantityTTF then
        button:setPosition(self.size_.width * .5, self.size_.height * .5 + 5)
        quantityTTF:setPosition(self.size_.width * .5, self.size_.height * .5 - 30)
        button:addTo(self)
        quantityTTF:addTo(self)
    else
        button:setPosition(self.size_.width * .5, self.size_.height * .5)
        button:addTo(self)
    end
    self.lockSp_ = lockSp --lockSp 用于帧刷新
    self:init()
end

function RewardSprite:init()

end

--[[--
    @description: 当奖励解锁时调用这个方法,需要注册后调用
]]
function RewardSprite:unlocked()
    --去除锁纹理
    local lockSp = self.lockSp_
    lockSp:removeSelf()
    self.lockSp_ = nil

    --更新边框纹理
    --之所以改成这样是因为CCTextureCache这个纹理缓存不能用了，暂时先这样，下同
    --local texture = CCTextureCache:sharedTextureCache():addImage("res/home/battle/high_ladder/unlocked_unreceived_yellow_border.png")
    self:setTexture(StringDef.PATH_HIGH_LADDER_UNLOCKED_UNRECEIVED_YELLOW_BORDER)
end

--[[--
    @description: 该方法用于点击领取按钮后
]]
function RewardSprite:receive()
    --调用

    --加上领取标志
    local lockSp = Factory:createBorderStateSprite(true, true)
    lockSp:setPosition(self.size_.width * .5, 0)
    lockSp:addTo(self)

    --更改纹理
    --local texture = CCTextureCache:sharedTextureCache():addImage("res/home/battle/high_ladder/can_receive.png")
    self:setTexture(StringDef.PATH_HIGH_LADDER_CAN_RECEIVE)
end

--[[--
    @description: 帧刷新，暂无
    @param dt type: number, 帧间隔
    @return none
]]
function RewardSprite:update(dt)
    if self.received_ ~= self.data_.received_
            or self.locked_ ~= self.data_.locked_ then
        self.received_ = self.data_.received_
        self.locked_ = self.data_.locked_
        if self.locked_ == false and self.received_ == false then
            self:unlocked()
        elseif self.locked_ == false and self.received_ == true then
            self:receive()
        end
    end
end

return RewardSprite
