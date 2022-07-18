--[[--
    图鉴界面的二级界面，用于实现塔的详情
    TowerDetial_2nd.lua
]]
local TowerDetialLayer2nd = class("TowerDetialLayer2nd", function()
    return display.newLayer()
end)
--local
local ConstDef = require("app.def.ConstDef")
local StringDef = require("app.def.StringDef")
local TowerButtonLayer2nd = require("app.ui.layer.TowerButtonLayer2nd")
local Log = require("app.utils.Log")
local OutGameData = require("app.data.OutGameData")
--
--[[--
    @description: 构造方法
    @param none
    @return none
]]
function TowerDetialLayer2nd:ctor(cardId, bag)
    self.use = nil
    self.order = cardId
    self:init(cardId, bag)
end

--[[--
    @description: 初始化方法，由于layer存在向下触摸的问题尚未解决因此出此下策，通过屏蔽下一层中的按钮来屏蔽向下触摸
    @param bag 类型:对应的已收集或者未收集的塔图鉴
    @return none
]]
function TowerDetialLayer2nd:init(cardId, bag)
    local ttf = {}
    ttf.fontFilePath = StringDef.PATH_TTF_BIAOZJW
    ttf.fontSize = 30
    local mask = display.newColorLayer(cc.c4b(0, 0, 0, 360))
    --local mask=display.newSprite(StringDef.PATH_MASK)
    self:add(mask)
    mask:setAnchorPoint(0.5, 0.5)
    mask:setPosition(display.cx, display.cy)
    -- get card
    local card = OutGameData:getUserInfo():getCardList()[cardId]
    --
    local popup = display.newSprite(StringDef.PATH_POPUP)
    mask:add(popup)
    popup:setScale(mask:getContentSize().width / popup:getContentSize().width * 0.8)
    popup:setAnchorPoint(0.5, 0.5)
    popup:setPosition(mask:getContentSize().width * 0.5, mask:getContentSize().height * 0.4)

    local icon=self:createIcon(cardId,popup)--左上角大图
    icon:setAnchorPoint(0.5,0.5)
    icon:setPosition(popup:getContentSize().width*0.70,popup:getContentSize().height*1.63)
   

    local baseSkillIntroducion = display.newSprite(StringDef.PATH_BASE_SKILL_INTRODUCTION)
    popup:add(baseSkillIntroducion)
    baseSkillIntroducion:setAnchorPoint(0.5, 0.5)
    baseSkillIntroducion:setPosition(popup:getContentSize().width * 0.65, popup:getContentSize().height * 0.78)
    local skillIntroduction = display.newSprite(StringDef.PATH_SKILL_INTRODUCTION)
    baseSkillIntroducion:add(skillIntroduction)
    skillIntroduction:setAnchorPoint(0, 1)
    skillIntroduction:setPosition(0, baseSkillIntroducion:getContentSize().height)
    ttf.fontSize = 20
    local skillIntroductionLabel = cc.Label:createWithTTF(ttf, "0")
    baseSkillIntroducion:add(skillIntroductionLabel)
    skillIntroductionLabel:setString("test")
    skillIntroductionLabel:setAnchorPoint(0, 1)
    skillIntroductionLabel:setPosition(0,
        baseSkillIntroducion:getContentSize().height - skillIntroduction:getContentSize().height)

    ttf.fontSize = 50
    local types = display.newSprite(StringDef.PATH_TEXTURE_TYPE_1)
    baseSkillIntroducion:add(types)
    types:setAnchorPoint(0, 1)
    types:setPosition(0, baseSkillIntroducion:getContentSize().height * 1.75)
    local typesLabel = cc.Label:createWithTTF(ttf, "0")
    baseSkillIntroducion:add(typesLabel)
    typesLabel:setAnchorPoint(0, 1)
    typesLabel:setPosition(0, baseSkillIntroducion:getContentSize().height * 1.55)
    typesLabel:setString(ConstDef.STR_TOWER_TYPE[card:getCardType()])
    local ratity = display.newSprite(StringDef.PATH_RATITY)
    baseSkillIntroducion:add(ratity)
    ratity:setAnchorPoint(0, 1)
    ratity:setPosition(baseSkillIntroducion:getContentSize().width * 0.6,
        baseSkillIntroducion:getContentSize().height * 1.75)
    local ratityLabel = cc.Label:createWithTTF(ttf, "0")
    baseSkillIntroducion:add(ratityLabel)
    ratityLabel:setAnchorPoint(0, 1)
    ratityLabel:setPosition(baseSkillIntroducion:getContentSize().width * 0.6,
        baseSkillIntroducion:getContentSize().height * 1.55)
    ratityLabel:setString(ConstDef.STR_TOWER_RARITY[card:getCardRarity()])
    ttf.fontSize = 30

    local defaultLayoutType = display.newSprite(StringDef.PATH_BASE_ATTRIBUTE_DEFAULT)
    popup:add(defaultLayoutType)
    defaultLayoutType:setAnchorPoint(0.5, 0.5)
    defaultLayoutType:setPosition(popup:getContentSize().width * 0.25, popup:getContentSize().height * 0.55)
    local iconType = display.newSprite(StringDef.PATH_ICON_PROPERTY_TYPE)
    defaultLayoutType:add(iconType)
    iconType:setAnchorPoint(0.5, 0.5)
    iconType:setPosition(defaultLayoutType:getContentSize().width * 0.2, defaultLayoutType:getContentSize().height * 0.5)
    local textureType = display.newSprite(StringDef.PATH_TEXTURE_TYPE)
    iconType:add(textureType)
    textureType:setAnchorPoint(0, 0.5)
    textureType:setPosition(iconType:getContentSize().width + 10, iconType:getContentSize().height)
    local ttfType = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutType:add(ttfType)
    ttfType:setAnchorPoint(0, 0.5)
    ttfType:setPosition(defaultLayoutType:getContentSize().width * 0.3, defaultLayoutType:getContentSize().height * 0.35)
    ttfType:setString(ConstDef.STR_TOWER_TYPE[card:getCardType()])

    local defaultLayoutAtk = display.newSprite(StringDef.PATH_BASE_ATTRIBUTE_DEFAULT)
    popup:add(defaultLayoutAtk)
    defaultLayoutAtk:setAnchorPoint(0.5, 0.5)
    defaultLayoutAtk:setPosition(popup:getContentSize().width * 0.75, popup:getContentSize().height * 0.55)
    local iconAtk = display.newSprite(StringDef.PATH_ICON_PROPERTY_ATK)
    defaultLayoutAtk:add(iconAtk)
    iconAtk:setAnchorPoint(0.5, 0.5)
    iconAtk:setPosition(defaultLayoutAtk:getContentSize().width * 0.2, defaultLayoutAtk:getContentSize().height * 0.5)
    local textureAtk = display.newSprite(StringDef.PATH_TEXTURE_ATK)
    iconAtk:add(textureAtk)
    textureAtk:setAnchorPoint(0, 0.5)
    textureAtk:setPosition(iconAtk:getContentSize().width + 10, iconAtk:getContentSize().height)
    local ttfAtk = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutAtk:add(ttfAtk)
    ttfAtk:setAnchorPoint(0, 0.5)
    ttfAtk:setPosition(defaultLayoutAtk:getContentSize().width * 0.3, defaultLayoutAtk:getContentSize().height * 0.35)
    ttfAtk:setString(tostring(card:getCardAtk()))

    local defaultLayoutAtkSpeed = display.newSprite(StringDef.PATH_BASE_ATTRIBUTE_DEFAULT)
    popup:add(defaultLayoutAtkSpeed)
    defaultLayoutAtkSpeed:setAnchorPoint(0.5, 0.5)
    defaultLayoutAtkSpeed:setPosition(popup:getContentSize().width * 0.25,
        popup:getContentSize().height * 0.55 - defaultLayoutAtkSpeed:getContentSize().height * 1.2)
    local iconAtkSpeed = display.newSprite(StringDef.PATH_ICON_PROPERTY_ATK_SPEED)
    defaultLayoutAtkSpeed:add(iconAtkSpeed)
    iconAtkSpeed:setAnchorPoint(0.5, 0.5)
    iconAtkSpeed:setPosition(defaultLayoutAtkSpeed:getContentSize().width * 0.2,
        defaultLayoutAtkSpeed:getContentSize().height * 0.5)
    local textureAtkSpeed = display.newSprite(StringDef.PATH_TEXTURE_ATK_SPEED)
    iconAtkSpeed:add(textureAtkSpeed)
    textureAtkSpeed:setAnchorPoint(0, 0.5)
    textureAtkSpeed:setPosition(iconAtkSpeed:getContentSize().width + 10, iconAtkSpeed:getContentSize().height)
    local ttfAtkSpeed = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutAtkSpeed:add(ttfAtkSpeed)
    ttfAtkSpeed:setAnchorPoint(0, 0.5)
    ttfAtkSpeed:setPosition(defaultLayoutAtkSpeed:getContentSize().width * 0.3,
        defaultLayoutAtkSpeed:getContentSize().height * 0.35)
    ttfAtkSpeed:setString(tostring(card:getCardFireCd()) .. "s")

    local defaultLayoutTarget = display.newSprite(StringDef.PATH_BASE_ATTRIBUTE_DEFAULT)
    popup:add(defaultLayoutTarget)
    defaultLayoutTarget:setAnchorPoint(0.5, 0.5)
    defaultLayoutTarget:setPosition(popup:getContentSize().width * 0.75,
        popup:getContentSize().height * 0.55 - defaultLayoutAtkSpeed:getContentSize().height * 1.2)
    local iconTarget = display.newSprite(StringDef.PATH_ICON_PROPERTY_TARGET)
    defaultLayoutTarget:add(iconTarget)
    iconTarget:setAnchorPoint(0.5, 0.5)
    iconTarget:setPosition(defaultLayoutTarget:getContentSize().width * 0.2,
        defaultLayoutTarget:getContentSize().height * 0.5)
    local textureTarget = display.newSprite(StringDef.PATH_TEXTURE_TARGET)
    iconTarget:add(textureTarget)
    textureTarget:setAnchorPoint(0, 0.5)
    textureTarget:setPosition(iconTarget:getContentSize().width + 10, iconTarget:getContentSize().height)
    local ttfTarget = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutTarget:add(ttfTarget)
    ttfTarget:setAnchorPoint(0, 0.5)
    ttfTarget:setPosition(defaultLayoutTarget:getContentSize().width * 0.3,
        defaultLayoutTarget:getContentSize().height * 0.35)
    ttfTarget:setString(ConstDef.STR_TOWER_ATK_TARGET[card:getCardTarget()])

    local defaultLayoutSkillSlow = display.newSprite(StringDef.PATH_BASE_ATTRIBUTE_DEFAULT)
    popup:add(defaultLayoutSkillSlow)
    defaultLayoutSkillSlow:setAnchorPoint(0.5, 0.5)
    defaultLayoutSkillSlow:setPosition(popup:getContentSize().width * 0.25,
        popup:getContentSize().height * 0.55 - defaultLayoutSkillSlow:getContentSize().height * 2.4)
    local iconSkillSlow = display.newSprite(StringDef.PATH_ICON_PROPERTY_SKILL_SLOW)
    defaultLayoutSkillSlow:add(iconSkillSlow)
    iconSkillSlow:setAnchorPoint(0.5, 0.5)
    iconSkillSlow:setPosition(defaultLayoutSkillSlow:getContentSize().width * 0.2,
        defaultLayoutSkillSlow:getContentSize().height * 0.5)
    local textureSkillSlow = display.newSprite(StringDef.PATH_TEXTURE_SKILL_SLOW)
    iconSkillSlow:add(textureSkillSlow)
    textureSkillSlow:setAnchorPoint(0, 0.5)
    textureSkillSlow:setPosition(iconSkillSlow:getContentSize().width + 10, iconSkillSlow:getContentSize().height)
    local ttfSkillSlow = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutSkillSlow:add(ttfSkillSlow)
    ttfSkillSlow:setAnchorPoint(0, 0.5)
    ttfSkillSlow:setPosition(defaultLayoutSkillSlow:getContentSize().width * 0.3,
        defaultLayoutSkillSlow:getContentSize().height * 0.35)
    ttfSkillSlow:setString("test")

    local defaultLayoutSkillTriggerTime = display.newSprite(StringDef.PATH_BASE_ATTRIBUTE_DEFAULT)
    popup:add(defaultLayoutSkillTriggerTime)
    defaultLayoutSkillTriggerTime:setAnchorPoint(0.5, 0.5)
    defaultLayoutSkillTriggerTime:setPosition(popup:getContentSize().width * 0.75,
        popup:getContentSize().height * 0.55 - defaultLayoutSkillTriggerTime:getContentSize().height * 2.4)
    local iconSkillTriggerTime = display.newSprite(StringDef.PATH_ICON_PROPERTY_SKILL_TRIGGER_TIME)
    defaultLayoutSkillTriggerTime:add(iconSkillTriggerTime)
    iconSkillTriggerTime:setAnchorPoint(0.5, 0.5)
    iconSkillTriggerTime:setPosition(defaultLayoutSkillTriggerTime:getContentSize().width * 0.2,
        defaultLayoutSkillTriggerTime:getContentSize().height * 0.5)
    local textureSkillTriggerTime = display.newSprite(StringDef.PATH_TEXTURE_SKILL_TRIGGER_TIME)
    iconSkillTriggerTime:add(textureSkillTriggerTime)
    textureSkillTriggerTime:setAnchorPoint(0, 0.5)
    textureSkillTriggerTime:setPosition(iconSkillTriggerTime:getContentSize().width + 10,
        iconSkillTriggerTime:getContentSize().height)
    local ttfSkillTriggerTime = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutSkillTriggerTime:add(ttfSkillTriggerTime)
    ttfSkillTriggerTime:setAnchorPoint(0, 0.5)
    ttfSkillTriggerTime:setPosition(defaultLayoutSkillTriggerTime:getContentSize().width * 0.3,
        defaultLayoutSkillTriggerTime:getContentSize().height * 0.35)
    ttfSkillTriggerTime:setString("test")

    local buttonIntensify = ccui.Button:create(StringDef.PATH_BUTTON_INTENSIFY, StringDef.PATH_BUTTON_INTENSIFY)
    popup:add(buttonIntensify)
    buttonIntensify:setAnchorPoint(0.5, 0.5)
    buttonIntensify:setPosition(popup:getContentSize().width * 0.2, popup:getContentSize().height * 0.15)
    buttonIntensify:setPressedActionEnabled(true)
    ttf.fontSize = 30
    local enhanceAtk = cc.Label:createWithTTF(ttf, "0")
    defaultLayoutAtk:add(enhanceAtk)
    enhanceAtk:setVisible(false)
    enhanceAtk:setColor(cc.c3b(200, 200, 0))
    enhanceAtk:setString("+" .. tostring(card:getCardAtkEnhance()))
    enhanceAtk:setAnchorPoint(1, 0.5)
    enhanceAtk:setPosition(defaultLayoutAtk:getContentSize().width, defaultLayoutAtk:getContentSize().height * 0.35)
    buttonIntensify:addTouchEventListener(function(sender, eventType)

        if eventType == 2 then
            enhanceAtk:setVisible(true)
        end
    end)

    local buttonLevelup = ccui.Button:create(StringDef.PATH_BUTTON_LEVELUP, StringDef.PATH_BUTTON_LEVELUP)
    popup:add(buttonLevelup)
    buttonLevelup:setAnchorPoint(0.5, 0.5)
    buttonLevelup:setPosition(popup:getContentSize().width * 0.5, popup:getContentSize().height * 0.15)
    buttonLevelup:setPressedActionEnabled(true)
    local coin = display.newSprite(StringDef.PATH_ICON_COIN)
    buttonLevelup:add(coin)
    coin:setAnchorPoint(0, 0.5)
    coin:setPosition(buttonLevelup:getContentSize().width * 0.2, buttonLevelup:getContentSize().height * 0.35)
    ttf.fontSize = 20
    local ttfLevelup = cc.Label:createWithTTF(ttf, "0")
    buttonLevelup:add(ttfLevelup)
    ttfLevelup:setAnchorPoint(0.5, 0.5)
    ttfLevelup:setPosition(buttonLevelup:getContentSize().width * 0.5, buttonLevelup:getContentSize().height * 0.35)
    ttfLevelup:setString("test")

    local buttonUse = ccui.Button:create(StringDef.PATH_BUTTON_USE, StringDef.PATH_BUTTON_USE)
    popup:add(buttonUse)
    buttonUse:setAnchorPoint(0.5, 0.5)
    buttonUse:setPosition(popup:getContentSize().width * 0.8, popup:getContentSize().height * 0.15)
    buttonUse:setPressedActionEnabled(true)
    self.use = buttonUse

    local buttonCLose = ccui.Button:create(StringDef.PATH_BUTTON_CLOSE, StringDef.PATH_BUTTON_CLOSE)
    popup:add(buttonCLose)
    buttonCLose:setPressedActionEnabled(true)
    buttonCLose:setAnchorPoint(1, 1)
    buttonCLose:setPosition(popup:getContentSize().width, popup:getContentSize().height)
    buttonCLose:addTouchEventListener(function(sender, eventType)

        if eventType == 2 then

            mask:setVisible(false)
            mask:removeFromParent()
            local list_ = bag.list
            --print(table.getn(list_))
            for i = 1, table.getn(list_) do
                list_[i]:setTouchEnabled(true)
            end
        end
    end)
    local ttfYellow = {}
    ttfYellow.fontFilePath = StringDef.PATH_TTF_HZGBJW
    ttfYellow.fontSize = 20
    local nowCriticalHit = cc.Label:createWithTTF(ttfYellow, "0")
    popup:add(nowCriticalHit)
    nowCriticalHit:setAnchorPoint(0.5, 0)
    nowCriticalHit:setPosition(popup:getContentSize().width * 0.48, 20)
    nowCriticalHit:setString("XXX%")
    nowCriticalHit:setColor(cc.c3b(255, 200, 0))

    local afterLevelup = cc.Label:createWithTTF(ttfYellow, "0")
    popup:add(afterLevelup)
    afterLevelup:setAnchorPoint(0.5, 0)
    afterLevelup:setPosition(popup:getContentSize().width * 0.74, 20)
    afterLevelup:setString("XXX%")
    afterLevelup:setColor(cc.c3b(255, 200, 0))
end

--[[--
    @description: 创造左上角的图标
    @param card 类型:卡牌类型
           parents 类型:生成图标的父对象
    @return icon
]]
function TowerDetialLayer2nd:createIcon(cardId, parents)
    local icon = TowerButtonLayer2nd.new(cardId)
    parents:add(icon)
    icon:setAnchorPoint(0.5, 0.5)
    icon:setPosition(parents:getContentSize().width * 0.65, parents:getContentSize().height * 1.42)
    --icon:setPosition(100, 10)
    return icon
end

function TowerDetialLayer2nd:createLayout(parents, base, icon, texture, label)
    local ttf = {}
    ttf.fontFilePath = StringDef.PATH_TTF_BIAOZJW
    ttf.fontSize = 30

    local defaultLayout = display.newSprite(base)
    parents:add(defaultLayout)
    defaultLayout:setAnchorPoint(0.5, 0.5)
    --defaultLayout:setPosition(parents:getContentSize().width*0.25,parents:getContentSize().height*0.55)
    local icon_ = display.newSprite(icon)
    defaultLayout:add(icon_)
    icon_:setAnchorPoint(0.5, 0.5)
    icon_:setPosition(defaultLayout:getContentSize().width * 0.2, defaultLayout:getContentSize().height * 0.5)
    local texture_ = display.newSprite(texture)
    icon_:add(texture_)
    texture_:setAnchorPoint(0, 0.5)
    texture_:setPosition(icon_:getContentSize().width + 10, icon_:getContentSize().height)
    local ttf_ = cc.Label:createWithTTF(ttf, "0")
    defaultLayout:add(ttf)
    ttf_:setAnchorPoint(0, 0.5)
    ttf_:setPosition(defaultLayout:getContentSize().width * 0.3, defaultLayout:getContentSize().height * 0.35)
    ttf_:setString(label)
end

return TowerDetialLayer2nd
