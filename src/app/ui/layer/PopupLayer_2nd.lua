
--[[--
    图鉴界面的二级界面，用于实现塔的详情中的使用弹窗
    PopupLayer_2nd.lua
]]
local PopupLayer_2nd=class("PopupLayer_2nd",require("src/app/ui/layer/BaseLayer.lua"))
local PATH_BASE="res/home/guide/second_use_tower/base.png"
local PATH_BUTTON_CANCEL="res/home/guide/second_use_tower/BT.png"
local ConstDef=require("src/app/def/ConstDef.lua")
--[[--
    @description: 构造方法
    @param order 类型:number , 传递的是要生成详细弹窗的塔的序号(名字)
    @return none
]]
function PopupLayer_2nd:ctor(order)
    self.cancel=nil--将取消按钮暴露在外，便于实现交互
    self:init(order)
end
--[[--
    @description:初始化方法
    @param 类型:number , 传递的是要生成详细弹窗的塔的序号(名字)
    @return none
]]
function PopupLayer_2nd:init(order)
    local bg=display.newSprite(PATH_BASE)
    self:add(bg)
    bg:setAnchorPoint(0.5,1)
    bg:setPosition(display.cx,display.cy*1.2)
    local sprite=display.newSprite(ConstDef.ICON_LINEUP_LIST[order])
    bg:add(sprite)
    sprite:setAnchorPoint(0.5,0.5)
    sprite:setPosition(bg:getContentSize().width*0.5,bg:getContentSize().height*0.5)
    local buttonCancel=ccui.Button:create(PATH_BUTTON_CANCEL,PATH_BUTTON_CANCEL)
    bg:add(buttonCancel)
    buttonCancel:setAnchorPoint(0.5,0.5)
    buttonCancel:setPosition(bg:getContentSize().width*0.5,bg:getContentSize().height*0.1)
    buttonCancel:setPressedActionEnabled(true)
   
    self.cancel=buttonCancel
end
return PopupLayer_2nd