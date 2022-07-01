--[[--
    图鉴界面的二级界面，用于实现塔的详情
    TowerDetial_2nd.lua
]]
local ConstDef = require("src/app/test/ConstDef.lua")
local PATH_POPUP="res/home/guide/second_tower_infor_popup/base_popup.png"
local PATH_BASE_SKILL_INTRODUCTION="res/home/guide/second_tower_infor_popup/base_skill_introduction.png"
local PATH_SKILL_INTRODUCTION="res/home/guide/second_tower_infor_popup/text_details/skill_introduction.png"

local PATH_TEXTURE_TYPE_1="res/home/guide/second_tower_infor_popup/text_details/type_1.png"
local PATH_TEXTURE_TYPE= "res/home/guide/second_tower_infor_popup/text_details/type.png"
local PATH_TEXTURE_ATK =  "res/home/guide/second_tower_infor_popup/text_details/atk.png"
local PATH_TEXTURE_ATK_SPEED ="res/home/guide/second_tower_infor_popup/text_details/attack_speed.png"
local PATH_TEXTURE_SKILL_TRIGGER_TIME="res/home/guide/second_tower_infor_popup/text_details/skill_trigger_time.png"
local PATH_TEXTURE_TARGET="res/home/guide/second_tower_infor_popup/text_details/goal.png"
local PATH_TEXTURE_SKILL_SLOW="res/home/guide/second_tower_infor_popup/text_details/skill_slowing_effect.png"

local PATH_ICON_PROPERTY_TYPE="res/home/guide/second_tower_infor_popup/icon_property/type.png"
local PATH_ICON_PROPERTY_ATK="res/home/guide/second_tower_infor_popup/icon_property/atk.png"
local PATH_ICON_PROPERTY_ATK_SPEED="res/home/guide/second_tower_infor_popup/icon_property/atk_speed.png"
local PATH_ICON_PROPERTY_SKILL_TRIGGER_TIME="res/home/guide/second_tower_infor_popup/icon_property/skill_trigger_time.png"
local PATH_ICON_PROPERTY_SKILL_SLOW="res/home/guide/second_tower_infor_popup/icon_property/slow.png"
local PATH_ICON_PROPERTY_TARGET="res/home/guide/second_tower_infor_popup/icon_property/target.png"
local PATH_ICON_COIN="res/home/guide/second_tower_infor_popup/icon_coin.png"

local PATH_BUTTON_INTENSIFY="res/home/guide/second_tower_infor_popup/button_intensify.png"
local PATH_BUTTON_USE="res/home/guide/second_tower_infor_popup/button_use.png"
local PATH_BUTTON_LEVELUP="res/home/guide/second_tower_infor_popup/button_levelup.png"
local PATH_BUTTON_CLOSE="res/home/general/second_open_confirm_popup/button_close.png"

local PATH_RATITY = "res/home/guide/second_tower_infor_popup/text_details/rarity.png"
local PATH_BASE_ATTRIBUTE_DEFAULT="res/home/guide/second_tower_infor_popup/base_attribute_default.png"
local PATH_BASE_ATTRIBUTE_ENHANCED="res/home/guide/second_tower_infor_popup/base_attribute_enhanced.png"
local TowerDetialLayer_2nd = class("TowerDetialLayer_2nd", function()
    return display.newLayer()
end)
--[[--
    @description: 构造方法
    @param none
    @return none
]]
function TowerDetialLayer_2nd:ctor(order,bag)
   
   self.use=nil
   self.order=order
   self:init(bag)
end
--[[--
    @description: 初始化方法，由于layer存在向下触摸的问题尚未解决因此出此下策，通过屏蔽下一层中的按钮来屏蔽向下触摸
    @param bag 类型:对应的已收集或者未收集的塔图鉴
    @return none
]]
function TowerDetialLayer_2nd:init(bag)
   local mask=display.newColorLayer(cc.c4b(0, 0,0,360))
   self:add(mask)
   mask:setAnchorPoint(0.5,0.5)
   mask:setPosition(display.cx,display.cy)

   local popup=display.newSprite(PATH_POPUP)
   mask:add(popup)
   popup:setScale(mask:getContentSize().width/popup:getContentSize().width*0.8)
   popup:setAnchorPoint(0.5,0.5)
   popup:setPosition(mask:getContentSize().width*0.5,mask:getContentSize().height*0.4)
   
   local baseSkillIntroducion = display.newSprite(PATH_BASE_SKILL_INTRODUCTION)
   popup:add(baseSkillIntroducion)
   baseSkillIntroducion:setAnchorPoint(0.5,0.5)
   baseSkillIntroducion:setPosition(popup:getContentSize().width*0.65,popup:getContentSize().height*0.78)
   local skillIntroduction=display.newSprite(PATH_SKILL_INTRODUCTION)
   baseSkillIntroducion:add(skillIntroduction)
   skillIntroduction:setAnchorPoint(0,1)
   skillIntroduction:setPosition(0,baseSkillIntroducion:getContentSize().height)
   
   local types=display.newSprite(PATH_TEXTURE_TYPE_1)
   baseSkillIntroducion:add(types)
   types:setAnchorPoint(0,1)
   types:setPosition(0,baseSkillIntroducion:getContentSize().height*1.75)
   local ratity=display.newSprite(PATH_RATITY)
   baseSkillIntroducion:add(ratity)
   ratity:setAnchorPoint(0,1)
   ratity:setPosition(baseSkillIntroducion:getContentSize().width*0.6,baseSkillIntroducion:getContentSize().height*1.75)

   local defaultLayoutType=display.newSprite(PATH_BASE_ATTRIBUTE_DEFAULT)
   popup:add(defaultLayoutType)
   defaultLayoutType:setAnchorPoint(0.5,0.5)
   defaultLayoutType:setPosition(popup:getContentSize().width*0.25,popup:getContentSize().height*0.55)
   local iconType=display.newSprite(PATH_ICON_PROPERTY_TYPE)
   defaultLayoutType:add(iconType)
   iconType:setAnchorPoint(0.5,0.5)
   iconType:setPosition(defaultLayoutType:getContentSize().width*0.2,defaultLayoutType:getContentSize().height*0.5)
   local textureType=display.newSprite(PATH_TEXTURE_TYPE)
   iconType:add(textureType)
   textureType:setAnchorPoint(0,0.5)
   textureType:setPosition(iconType:getContentSize().width+10,iconType:getContentSize().height)

   local defaultLayoutAtk=display.newSprite(PATH_BASE_ATTRIBUTE_DEFAULT)
   popup:add(defaultLayoutAtk)
   defaultLayoutAtk:setAnchorPoint(0.5,0.5)
   defaultLayoutAtk:setPosition(popup:getContentSize().width*0.75,popup:getContentSize().height*0.55)
   local iconAtk=display.newSprite(PATH_ICON_PROPERTY_ATK)
   defaultLayoutAtk:add(iconAtk)
   iconAtk:setAnchorPoint(0.5,0.5)
   iconAtk:setPosition(defaultLayoutAtk:getContentSize().width*0.2,defaultLayoutAtk:getContentSize().height*0.5)
   local textureAtk=display.newSprite(PATH_TEXTURE_ATK)
   iconAtk:add(textureAtk)
   textureAtk:setAnchorPoint(0,0.5)
   textureAtk:setPosition(iconAtk:getContentSize().width+10,iconAtk:getContentSize().height)
   
   local defaultLayoutAtkSpeed=display.newSprite(PATH_BASE_ATTRIBUTE_DEFAULT)
   popup:add(defaultLayoutAtkSpeed)
   defaultLayoutAtkSpeed:setAnchorPoint(0.5,0.5)
   defaultLayoutAtkSpeed:setPosition(popup:getContentSize().width*0.25,popup:getContentSize().height*0.55-defaultLayoutAtkSpeed:getContentSize().height*1.2)
   local iconAtkSpeed=display.newSprite(PATH_ICON_PROPERTY_ATK_SPEED)
   defaultLayoutAtkSpeed:add(iconAtkSpeed)
   iconAtkSpeed:setAnchorPoint(0.5,0.5)
   iconAtkSpeed:setPosition(defaultLayoutAtkSpeed:getContentSize().width*0.2,defaultLayoutAtkSpeed:getContentSize().height*0.5)
   local textureAtkSpeed=display.newSprite(PATH_TEXTURE_ATK_SPEED)
   iconAtkSpeed:add(textureAtkSpeed)
   textureAtkSpeed:setAnchorPoint(0,0.5)
   textureAtkSpeed:setPosition(iconAtkSpeed:getContentSize().width+10,iconAtkSpeed:getContentSize().height)

   local defaultLayoutTarget=display.newSprite(PATH_BASE_ATTRIBUTE_DEFAULT)
   popup:add(defaultLayoutTarget)
   defaultLayoutTarget:setAnchorPoint(0.5,0.5)
   defaultLayoutTarget:setPosition(popup:getContentSize().width*0.75,popup:getContentSize().height*0.55-defaultLayoutAtkSpeed:getContentSize().height*1.2)
   local iconTarget=display.newSprite(PATH_ICON_PROPERTY_TARGET)
   defaultLayoutTarget:add(iconTarget)
   iconTarget:setAnchorPoint(0.5,0.5)
   iconTarget:setPosition(defaultLayoutTarget:getContentSize().width*0.2,defaultLayoutTarget:getContentSize().height*0.5)
   local textureTarget=display.newSprite(PATH_TEXTURE_TARGET)
   iconTarget:add(textureTarget)
   textureTarget:setAnchorPoint(0,0.5)
   textureTarget:setPosition(iconTarget:getContentSize().width+10,iconTarget:getContentSize().height)

   local defaultLayoutSkillSlow=display.newSprite(PATH_BASE_ATTRIBUTE_DEFAULT)
   popup:add(defaultLayoutSkillSlow)
   defaultLayoutSkillSlow:setAnchorPoint(0.5,0.5)
   defaultLayoutSkillSlow:setPosition(popup:getContentSize().width*0.25,popup:getContentSize().height*0.55-defaultLayoutSkillSlow:getContentSize().height*2.4)
   local iconSkillSlow=display.newSprite(PATH_ICON_PROPERTY_SKILL_SLOW)
   defaultLayoutSkillSlow:add(iconSkillSlow)
   iconSkillSlow:setAnchorPoint(0.5,0.5)
   iconSkillSlow:setPosition(defaultLayoutSkillSlow:getContentSize().width*0.2,defaultLayoutSkillSlow:getContentSize().height*0.5)
   local textureSkillSlow=display.newSprite(PATH_TEXTURE_SKILL_SLOW)
   iconSkillSlow:add(textureSkillSlow)
   textureSkillSlow:setAnchorPoint(0,0.5)
   textureSkillSlow:setPosition(iconSkillSlow:getContentSize().width+10,iconSkillSlow:getContentSize().height)

   local defaultLayoutSkillTriggerTime=display.newSprite(PATH_BASE_ATTRIBUTE_DEFAULT)
   popup:add(defaultLayoutSkillTriggerTime)
   defaultLayoutSkillTriggerTime:setAnchorPoint(0.5,0.5)
   defaultLayoutSkillTriggerTime:setPosition(popup:getContentSize().width*0.75,
                                             popup:getContentSize().height*0.55-defaultLayoutSkillTriggerTime:getContentSize().height*2.4)
   local iconSkillTriggerTime=display.newSprite(PATH_ICON_PROPERTY_SKILL_TRIGGER_TIME)
   defaultLayoutSkillTriggerTime:add(iconSkillTriggerTime)
   iconSkillTriggerTime:setAnchorPoint(0.5,0.5)
   iconSkillTriggerTime:setPosition(defaultLayoutSkillTriggerTime:getContentSize().width*0.2,defaultLayoutSkillTriggerTime:getContentSize().height*0.5)
   local textureSkillTriggerTime=display.newSprite(PATH_TEXTURE_SKILL_TRIGGER_TIME)
   iconSkillTriggerTime:add(textureSkillTriggerTime)
   textureSkillTriggerTime:setAnchorPoint(0,0.5)
   textureSkillTriggerTime:setPosition(iconSkillTriggerTime:getContentSize().width+10,iconSkillTriggerTime:getContentSize().height)

   local buttonIntensify=ccui.Button:create(PATH_BUTTON_INTENSIFY,PATH_BUTTON_INTENSIFY)
   popup:add(buttonIntensify)
   buttonIntensify:setAnchorPoint(0.5,0.5)
   buttonIntensify:setPosition(popup:getContentSize().width*0.2,popup:getContentSize().height*0.15)
   buttonIntensify:setPressedActionEnabled(true)

   local buttonLevelup=ccui.Button:create(PATH_BUTTON_LEVELUP,PATH_BUTTON_LEVELUP)
   popup:add(buttonLevelup)
   buttonLevelup:setAnchorPoint(0.5,0.5)
   buttonLevelup:setPosition(popup:getContentSize().width*0.5,popup:getContentSize().height*0.15)
   buttonLevelup:setPressedActionEnabled(true)
   local coin = display.newSprite(PATH_ICON_COIN)
   buttonLevelup:add(coin)
   coin:setAnchorPoint(0,0.5)
   coin:setPosition(buttonLevelup:getContentSize().width*0.2,buttonLevelup:getContentSize().height*0.25)

   local buttonUse=ccui.Button:create(PATH_BUTTON_USE,PATH_BUTTON_USE)
   popup:add(buttonUse)
   buttonUse:setAnchorPoint(0.5,0.5)
   buttonUse:setPosition(popup:getContentSize().width*0.8,popup:getContentSize().height*0.15)
   buttonUse:setPressedActionEnabled(true)
   self.use=buttonUse
   
   local buttonCLose=ccui.Button:create(PATH_BUTTON_CLOSE,PATH_BUTTON_CLOSE)
   popup:add(buttonCLose)
   buttonCLose:setPressedActionEnabled(true)
   buttonCLose:setAnchorPoint(1,1)
   buttonCLose:setPosition(popup:getContentSize().width,popup:getContentSize().height)
   buttonCLose:addTouchEventListener(function(sender, eventType)--注册取消按钮的点击事件
                    
      if eventType==2 then
         
         mask:setVisible(false)
         mask:removeFromParent()
         local list_=bag.list
         --print(table.getn(list_))
         for i=1,table.getn(list_) do--使背包中的按钮可以点击
            list_[i]:setTouchEnabled(true)
         end
      end
  end)
end

return TowerDetialLayer_2nd