local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

local priority_ = 0 -- 存储层优先级
local menuTopLayer_
local audio_ = require "framework.audio"
local avatarButton_
-- 底部栏组件
local curPageSprite_
local sizeTab_
local tabBattle_
local tabShop_
local tabGuide_
local battleTitle_, battleIcon_
local shopTitle_, shopIcon_
local guideTitle_, guideIcon_

local MenuConfig = require "app.test.MenuConfig"
local TowerDef = require "app.def.TowerDef"
local Log = require "app.utils.Log"

--[[--
    描述：构造函数

    @param none

    @return none
]]
function MenuScene:ctor(layer, num)
    priority_ = num
    self:loadMusic()
    local menuTop = self:createMenuTop()
    local menuBottom = self:createMenuBottom()
    menuTop:addTo(layer, priority_)
    menuBottom:addTo(layer, priority_)
end

--[[--
    描述：音乐音效加载

    @param none

    @return none
]]
function MenuScene:loadMusic()
    audio_.loadFile("sound_ogg/ui_btn_click.ogg", function(dt) end)
end

--[[--
    描述：创建顶部栏

    @param none

    @return layer
]]
function MenuScene:createMenuTop()
    -- 顶部栏
    menuTopLayer_ = ccui.Layout:create() -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    menuTopLayer_:setPosition(display.width / 2, display.height / 2)
    menuTopLayer_:setAnchorPoint(0.5, 0.5)
    menuTopLayer_:setContentSize(display.width, display.height)

    local topBase = cc.Sprite:create("home/top_player_info/base_top.png")
    topBase:setAnchorPoint(0.5, 1)
    topBase:setPosition(display.cx, display.height)
    local sizeBase = topBase:getContentSize()
    topBase:addTo(menuTopLayer_)

    -- 头像框按钮
    avatarButton_ = ccui.Button:create(MenuConfig.AVATER.ICON_PATH)
    avatarButton_:setAnchorPoint(0.5, 0.5)
    -- base的高度
    local baseHeight = sizeBase.height * display.width / sizeBase.width
    -- base中心高度
    local baseCY = display.height - baseHeight / 2
    avatarButton_:setPosition(display.cx / 4, baseCY + 2)
    avatarButton_:addTo(menuTopLayer_, 1)
    avatarButton_:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            MenuScene:createAvatarSelection(menuTopLayer_:getParent())
        end
    end)

    -- 菜单按钮
    local menuButton = ccui.Button:create("home/top_player_info/button_menu.png")
    menuButton:setAnchorPoint(0.5, 0.5)
    menuButton:setPosition(display.cx * 13 / 7, baseCY + 2)
    menuButton:addTo(menuTopLayer_)
    menuButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            MenuScene:createSecondMenu(menuTopLayer_:getParent())
        end
    end)

    ----------------------------------------------------------------------------
    -- 玩家信息
    local nameBase = cc.Sprite:create("home/top_player_info/base_name.png")
    nameBase:setAnchorPoint(0.5, 0.5)
    nameBase:setPosition(display.width / 3 + display.cx / 13, baseCY + 5)
    nameBase:addTo(menuTopLayer_)
    local sizeNameBase = nameBase:getContentSize()

    local nameText = display.newTTFLabel({
        text = MenuConfig.NAME,
        font = "font/fzzchjw.ttf",
        size = 20
    })
    nameText:align(display.LEFT_CENTER, display.width * 9 / 40, baseCY + 2 + sizeNameBase.height / 4)
    nameText:setColor(cc.c3b(255, 255, 255))
    nameText:addTo(menuTopLayer_)

    local cupSprite = cc.Sprite:create("home/top_player_info/cup.png")
    cupSprite:setAnchorPoint(0, 0.5)
    cupSprite:setPosition(display.width * 9 / 40, baseCY + 6 - sizeNameBase.height / 4)
    cupSprite:addTo(menuTopLayer_)

    local scoreText = display.newTTFLabel({
        text = MenuConfig.CUP_NUM,
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    scoreText:align(display.LEFT_CENTER, display.width * 23 / 80, baseCY + 5 - sizeNameBase.height / 4)
    scoreText:setColor(cc.c3b(255, 206, 55))
    scoreText:addTo(menuTopLayer_)

    local coinBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    coinBase:setAnchorPoint(0, 1)
    coinBase:setPosition(display.cx * 9 / 7, baseCY + sizeNameBase.height / 2)
    coinBase:addTo(menuTopLayer_)

    local coinSprite = cc.Sprite:create("home/top_player_info/coin.png")
    coinSprite:setAnchorPoint(0, 1)
    coinSprite:setPosition(display.cx * 9 / 7 - display.cx / 20, baseCY + sizeNameBase.height / 2)
    coinSprite:addTo(menuTopLayer_)

    local coinNum = display.newTTFLabel({
        text = MenuConfig.COIN_NUM,
        font = "font/fzbiaozjw.ttf",
        size = 26
    })
    coinNum:align(display.RIGHT_TOP, display.cx * 8 / 5 + display.cx / 20, baseCY + sizeNameBase.height / 2 - 5)
    coinNum:setColor(cc.c3b(255, 255, 255))
    coinNum:addTo(menuTopLayer_)

    local diaBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    diaBase:setAnchorPoint(0, 0)
    diaBase:setPosition(display.cx * 9 / 7, baseCY - sizeNameBase.height / 2)
    diaBase:addTo(menuTopLayer_)

    local diaSprite = cc.Sprite:create("home/top_player_info/diamond.png")
    diaSprite:setAnchorPoint(0, 0)
    diaSprite:setPosition(display.cx * 9 / 7 - display.cx / 20, baseCY - sizeNameBase.height / 2)
    diaSprite:addTo(menuTopLayer_)

    local diaNum = display.newTTFLabel({
        text = MenuConfig.DIA_NUM,
        font = "font/fzbiaozjw.ttf",
        size = 26
    })
    diaNum:align(display.RIGHT_BOTTOM, display.cx * 8 / 5 + display.cx / 20, baseCY - sizeNameBase.height / 2 + 5)
    diaNum:setColor(cc.c3b(255, 255, 255))
    diaNum:addTo(menuTopLayer_)

    return menuTopLayer_
end

--[[--
    描述：创建底部栏

    @param none

    @return layer
]]
function MenuScene:createMenuBottom()
    local menuBottomLayer = ccui.Layout:create() -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    menuBottomLayer:setPosition(display.width / 2, display.height / 2)
    menuBottomLayer:setAnchorPoint(0.5, 0.5)
    menuBottomLayer:setContentSize(display.width, display.height)

    curPageSprite_ = cc.Sprite:create("home/bottom_tab_button/tab_selected.png")
    curPageSprite_:setAnchorPoint(0.5, 0)
    curPageSprite_:setPosition(display.cx, 0)
    sizeTab_ = curPageSprite_:getContentSize()
    curPageSprite_:scale(display.width / 3 / sizeTab_.width)
    curPageSprite_:addTo(menuBottomLayer, 1)

    ----------------------------------------------------------------------------
    -- 战斗tab
    tabBattle_ = ccui.Button:create("home/bottom_tab_button/tab_unselected_middle.png")
    tabBattle_:setAnchorPoint(0.5, 0)
    tabBattle_:setPosition(display.cx, 0)
    sizeTab_ = tabBattle_:getContentSize()
    tabBattle_:scale(display.width / 3 / sizeTab_.width)
    tabBattle_:setTouchEnabled(false)
    tabBattle_:addTo(menuBottomLayer)

    battleIcon_ = cc.Sprite:create("home/bottom_tab_button/icon_battle.png")
    battleIcon_:setAnchorPoint(0.5, 0.5)
    battleIcon_:setPosition(display.cx, sizeTab_.height / 2 + sizeTab_.height / 5)
    battleIcon_:addTo(menuBottomLayer, 2)

    battleTitle_ = cc.Sprite:create("home/bottom_tab_button/title_battle.png")
    battleTitle_:setAnchorPoint(0.5, 1)
    battleTitle_:setPosition(display.cx, sizeTab_.height / 3)
    battleTitle_:addTo(menuBottomLayer, 2)
    battleTitle_:setVisible(true)

    tabBattle_:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            local MainScene = require "app.scenes.MainScene"
            MainScene:setPage(1)
        end
    end)

    ----------------------------------------------------------------------------
    -- 商店tab
    tabShop_ = ccui.Button:create("home/bottom_tab_button/tab_unselected_left.png")
    tabShop_:setAnchorPoint(0, 0)
    tabShop_:setPosition(0, 0)
    sizeTab_ = tabShop_:getContentSize()
    tabShop_:scale(display.width / 3 / sizeTab_.width)
    tabShop_:addTo(menuBottomLayer)


    shopIcon_ = cc.Sprite:create("home/bottom_tab_button/icon_shop.png")
    shopIcon_:setAnchorPoint(0.5, 0.5)
    shopIcon_:setPosition(sizeTab_.width / 2, sizeTab_.height / 2)
    shopIcon_:addTo(menuBottomLayer, 2)

    shopTitle_ = cc.Sprite:create("home/bottom_tab_button/title_shop.png")
    shopTitle_:setAnchorPoint(0.5, 1)
    shopTitle_:setPosition(sizeTab_.width / 2, sizeTab_.height / 3)
    shopTitle_:addTo(menuBottomLayer, 2)
    shopTitle_:setVisible(false)

    tabShop_:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            local MainScene = require "app.scenes.MainScene"
            MainScene:setPage(0)
        end
    end)

    ----------------------------------------------------------------------------
    -- 图鉴tab
    tabGuide_ = ccui.Button:create("home/bottom_tab_button/tab_unselected_right.png")
    tabGuide_:setAnchorPoint(1, 0)
    tabGuide_:setPosition(display.width, 0)
    sizeTab_ = tabGuide_:getContentSize()
    tabGuide_:scale(display.width / 3 / sizeTab_.width)
    tabGuide_:addTo(menuBottomLayer)

    guideIcon_ = cc.Sprite:create("home/bottom_tab_button/icon_guide.png")
    guideIcon_:setAnchorPoint(0.5, 0.5)
    guideIcon_:setPosition(display.width - sizeTab_.width / 2, sizeTab_.height / 2)
    guideIcon_:addTo(menuBottomLayer, 2)

    guideTitle_ = cc.Sprite:create("home/bottom_tab_button/title_guide.png")
    guideTitle_:setAnchorPoint(0.5, 1)
    guideTitle_:setPosition(display.width - sizeTab_.width / 2, sizeTab_.height / 3)
    guideTitle_:addTo(menuBottomLayer, 2)
    guideTitle_:setVisible(false)

    tabGuide_:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            local MainScene = require "app.scenes.MainScene"
            MainScene:setPage(2)
        end
    end)

    return menuBottomLayer
end

--[[--
    描述：底部栏状态切换

    @param int: 1--商店、2--战斗、3--图鉴

    @return none
]]
function MenuScene:bottomMenuControl(num)
    if num == 2 then
        print("mid-battle")
        tabShop_:setTouchEnabled(true)
        tabBattle_:setTouchEnabled(false)
        tabGuide_:setTouchEnabled(true)
        curPageSprite_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, 0)))
        battleIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab_.height / 2 + sizeTab_.height / 5)))
        battleTitle_:setVisible(true)
        shopIcon_:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab_.width / 2, sizeTab_.height / 2)))
        shopTitle_:setVisible(false)
        guideIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab_.width / 2, sizeTab_.height / 2)))
        guideTitle_:setVisible(false)
    elseif num == 1 then
        print("left-shop")
        tabShop_:setTouchEnabled(false)
        tabBattle_:setTouchEnabled(true)
        tabGuide_:setTouchEnabled(true)
        curPageSprite_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx / 3, 0)))
        battleIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab_.height / 2)))
        battleTitle_:setVisible(false)
        shopIcon_:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab_.width / 2, sizeTab_.height / 2 + sizeTab_.height / 5)))
        shopTitle_:setVisible(true)
        guideIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab_.width / 2, sizeTab_.height / 2)))
        guideTitle_:setVisible(false)
    elseif num == 3 then
        print("right-guide")
        tabShop_:setTouchEnabled(true)
        tabBattle_:setTouchEnabled(true)
        tabGuide_:setTouchEnabled(false)
        curPageSprite_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx * 5 / 3, 0)))
        battleIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab_.height / 2)))
        battleTitle_:setVisible(false)
        shopIcon_:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab_.width / 2, sizeTab_.height / 2)))
        shopTitle_:setVisible(false)
        guideIcon_:runAction(cc.MoveTo:create(0.08,
            cc.p(display.width - sizeTab_.width / 2, sizeTab_.height / 2 + sizeTab_.height / 5)))
        guideTitle_:setVisible(true)
    end
end

--[[--
    描述：菜单栏二级界面

    @param layer

    @return none
]]
function MenuScene:createSecondMenu(layer)
    print("second menu")
    local secMenuLayer = ccui.Layout:create()
    secMenuLayer:setBackGroundColor(cc.c4b(0, 0, 0, 100))
    secMenuLayer:setBackGroundColorType(1)
    secMenuLayer:opacity(200)
    secMenuLayer:setAnchorPoint(0.5, 0.5)
    secMenuLayer:setPosition(display.cx, display.cy)
    secMenuLayer:setContentSize(display.width, display.height)
    secMenuLayer:addTo(layer, priority_ + 1)
    -- 设置层可触摸屏蔽下方按键
    secMenuLayer:setTouchEnabled(true)
    secMenuLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secMenuLayer:removeFromParent()
        end
    end)

    local secMenuBase = cc.Sprite:create("home/top_player_info/second_menu/base_menu.png")
    secMenuBase:setAnchorPoint(1, 1)
    secMenuBase:setPosition(display.cx * 12 / 7, display.height - display.height / 30)
    secMenuBase:addTo(secMenuLayer)
    -- 计算base宽度高度中心
    local sizeSecMenuBase = secMenuBase:getContentSize()
    local secMenuBaseCX = secMenuBase:getPositionX() - sizeSecMenuBase.width / 2
    local secMenuBaseCY = secMenuBase:getPositionY() - sizeSecMenuBase.height / 2

    ------------------------------------------------------------------------------------------------
    -- 公告
    local announcButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    announcButton:setAnchorPoint(0.5, 0.5)
    announcButton:setPosition(secMenuBaseCX, secMenuBaseCY + sizeSecMenuBase.height * 3 / 9)
    announcButton:addTo(secMenuLayer)

    local announcTitle = cc.Sprite:create("home/top_player_info/second_menu/text_announcement.png")
    announcTitle:setAnchorPoint(0.5, 0.5)
    announcTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width / 20, secMenuBaseCY + sizeSecMenuBase.height * 3 / 9)
    announcTitle:addTo(secMenuLayer)

    local announcIcon = cc.Sprite:create("home/top_player_info/second_menu/button_announcement.png")
    announcIcon:setAnchorPoint(0.5, 0.5)
    announcIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width * 7 / 24, secMenuBaseCY + sizeSecMenuBase.height * 3 /
        9)
    announcIcon:addTo(secMenuLayer)

    ------------------------------------------------------------------------------------------------
    -- 邮箱
    local mailButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    mailButton:setAnchorPoint(0.5, 0.5)
    mailButton:setPosition(secMenuBaseCX, secMenuBaseCY + sizeSecMenuBase.height * 1 / 9)
    mailButton:addTo(secMenuLayer)

    local mailTitle = cc.Sprite:create("home/top_player_info/second_menu/text_mail.png")
    mailTitle:setAnchorPoint(0.5, 0.5)
    mailTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width / 20, secMenuBaseCY + sizeSecMenuBase.height * 1 / 9)
    mailTitle:addTo(secMenuLayer)

    local mailIcon = cc.Sprite:create("home/top_player_info/second_menu/button_mail.png")
    mailIcon:setAnchorPoint(0.5, 0.5)
    mailIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width * 7 / 24, secMenuBaseCY + sizeSecMenuBase.height * 1 / 9)
    mailIcon:addTo(secMenuLayer)

    ------------------------------------------------------------------------------------------------
    -- 对战记录
    local recordButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    recordButton:setAnchorPoint(0.5, 0.5)
    recordButton:setPosition(secMenuBaseCX, secMenuBaseCY - sizeSecMenuBase.height * 1 / 9)
    recordButton:addTo(secMenuLayer)

    local recordTitle = cc.Sprite:create("home/top_player_info/second_menu/text_record.png")
    recordTitle:setAnchorPoint(0.5, 0.5)
    recordTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width / 20, secMenuBaseCY - sizeSecMenuBase.height * 1 / 9)
    recordTitle:addTo(secMenuLayer)

    local recordIcon = cc.Sprite:create("home/top_player_info/second_menu/button_record.png")
    recordIcon:setAnchorPoint(0.5, 0.5)
    recordIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width * 7 / 24, secMenuBaseCY - sizeSecMenuBase.height * 1 / 9)
    recordIcon:addTo(secMenuLayer)

    ------------------------------------------------------------------------------------------------
    -- 设置
    local settingButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    settingButton:setAnchorPoint(0.5, 0.5)
    settingButton:setPosition(secMenuBaseCX, secMenuBaseCY - sizeSecMenuBase.height * 3 / 9)
    settingButton:addTo(secMenuLayer)

    local settingTitle = cc.Sprite:create("home/top_player_info/second_menu/text_setting.png")
    settingTitle:setAnchorPoint(0.5, 0.5)
    settingTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width / 20, secMenuBaseCY - sizeSecMenuBase.height * 3 / 9)
    settingTitle:addTo(secMenuLayer)

    local settingIcon = cc.Sprite:create("home/top_player_info/second_menu/button_setting.png")
    settingIcon:setAnchorPoint(0.5, 0.5)
    settingIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width * 7 / 24, secMenuBaseCY - sizeSecMenuBase.height * 3 /
        9)
    settingIcon:addTo(secMenuLayer)

    settingButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            settingButton:setTouchEnabled(false)
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            self:createSecondSetting(layer)
            secMenuLayer:removeFromParent()
        end
    end)

end

--[[--
    描述：设置界面弹窗

    @param layer

    @return none
]]
function MenuScene:createSecondSetting(layer)
    local secAvatarLayer = ccui.Layout:create()
    secAvatarLayer:setBackGroundColor(cc.c4b(0, 0, 0, 100))
    secAvatarLayer:setBackGroundColorType(1)
    secAvatarLayer:opacity(200)
    secAvatarLayer:setAnchorPoint(0.5, 0.5)
    secAvatarLayer:setPosition(display.cx, display.cy)
    secAvatarLayer:setContentSize(display.width, display.height)
    secAvatarLayer:addTo(layer, priority_ + 1)
    -- 设置层可触摸屏蔽下方按键
    secAvatarLayer:setTouchEnabled(true)
    secAvatarLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secAvatarLayer:removeFromParent()
        end
    end)

    local setBase = cc.Sprite:create("home/top_player_info/second_setting/base_popup.png")
    setBase:setAnchorPoint(0.5, 0.5)
    setBase:setPosition(display.cx, display.cy)
    setBase:addTo(secAvatarLayer)
    local sizeSetBase = setBase:getContentSize()

    local setClose = ccui.Button:create("home/top_player_info/second_setting/button_close.png")
    setClose:setAnchorPoint(0.5, 0.5)
    setClose:setPosition(display.cx + sizeSetBase.width / 2 - sizeSetBase.width / 17,
        display.cy + sizeSetBase.height / 2 - sizeSetBase.height / 10)
    setClose:addTo(secAvatarLayer)
    setClose:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secAvatarLayer:removeFromParent()
        end
    end)

    -- 遮罩，屏蔽点击退出触摸事件
    local baseMaskLayer = ccui.Layout:create()
    baseMaskLayer:setAnchorPoint(0.5, 0.5)
    baseMaskLayer:setPosition(display.cx, display.cy)
    baseMaskLayer:setContentSize(sizeSetBase.width, sizeSetBase.height)
    baseMaskLayer:setTouchEnabled(true)
    baseMaskLayer:addTo(secAvatarLayer, -1)

    local setExit = ccui.Button:create("home/top_player_info/second_setting/button_exit.png")
    setExit:setAnchorPoint(0.5, 0.5)
    setExit:setPosition(display.cx, display.cy - sizeSetBase.height * 7 / 24)
    setExit:addTo(secAvatarLayer)
    setExit:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
        end
    end)

    local versionText = display.newTTFLabel({
        text = "版本号：xxx.xxx.xxx",
        font = "",
        size = 21
    })
    versionText:align(display.CENTER, display.cx, display.cy - sizeSetBase.height / 2 + sizeSetBase.height / 14)
    versionText:setColor(cc.c3b(255, 255, 255))
    versionText:opacity(60)
    versionText:addTo(secAvatarLayer)

    ------------------------------------------------------------------------------------------------
    -- 音效控制
    local effectTitle = cc.Sprite:create("home/top_player_info/second_setting/title_effect.png")
    effectTitle:setAnchorPoint(0, 0.5)
    effectTitle:setPosition(cc.p(display.width / 3 - sizeSetBase.width / 10, display.height / 2 + sizeSetBase.height / 5))
    effectTitle:addTo(secAvatarLayer)

    -- 事件回调函数
    local function onChangedCheckBoxEffect(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            audio_.setEffectVolume(0)
            MenuConfig.IS_PLAY_EFFECT = false
        elseif eventType == ccui.CheckBoxEventType.unselected then
            audio_.setEffectVolume(1)
            MenuConfig.IS_PLAY_EFFECT = true
        end
    end

    --CheckBox音效
    local ckbEffect = ccui.CheckBox:create(
        "home/top_player_info/second_setting/CheckBox_on.png", --普通状态
        "home/top_player_info/second_setting/CheckBox_on.png", --普通按下
        "home/top_player_info/second_setting/CheckBox_off.png", --选中状态
        "home/top_player_info/second_setting/CheckBox_on.png", --普通禁用
        "home/top_player_info/second_setting/CheckBox_off.png"--选中禁用
    )
    ckbEffect:setPosition(cc.p(display.width / 2 - sizeSetBase.width / 15, display.height / 2 + sizeSetBase.height / 5))
    ckbEffect:setAnchorPoint(0, 0.5)
    -- 按钮选择状态
    if MenuConfig.IS_PLAY_EFFECT then
        ckbEffect:setSelected(false)
    else
        ckbEffect:setSelected(true)
    end
    -- 添加事件监听器
    ckbEffect:addEventListener(onChangedCheckBoxEffect)
    ckbEffect:addTo(secAvatarLayer)

    ------------------------------------------------------------------------------------------------
    -- 音乐控制
    local bgmTitle = cc.Sprite:create("home/top_player_info/second_setting/title_music.png")
    bgmTitle:setAnchorPoint(0, 0.5)
    bgmTitle:setPosition(cc.p(display.width / 3 - sizeSetBase.width / 10, display.height / 2 + sizeSetBase.height / 15))
    bgmTitle:addTo(secAvatarLayer)

    -- 事件回调函数
    local function onChangedCheckBoxBgm(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            audio_.stopBGM()
            MenuConfig.IS_PLAY_BGM = false
        elseif eventType == ccui.CheckBoxEventType.unselected then
            audio_.playBGM("sound_ogg/lobby_bgm_120bpm.ogg")
            MenuConfig.IS_PLAY_BGM = true
        end
    end

    --CheckBox音乐
    local ckbBgm = ccui.CheckBox:create(
        "home/top_player_info/second_setting/CheckBox_on.png", --普通状态
        "home/top_player_info/second_setting/CheckBox_on.png", --普通按下
        "home/top_player_info/second_setting/CheckBox_off.png", --选中状态
        "home/top_player_info/second_setting/CheckBox_on.png", --普通禁用
        "home/top_player_info/second_setting/CheckBox_off.png"--选中禁用
    )
    ckbBgm:setPosition(cc.p(display.width / 2 - sizeSetBase.width / 15, display.height / 2 + sizeSetBase.height / 15))
    ckbBgm:setAnchorPoint(0, 0.5)
    -- 按钮选择状态
    if MenuConfig.IS_PLAY_BGM then
        ckbBgm:setSelected(false)
    else
        ckbBgm:setSelected(true)
    end
    -- 添加事件监听器
    ckbBgm:addEventListener(onChangedCheckBoxBgm)
    ckbBgm:addTo(secAvatarLayer)

    ------------------------------------------------------------------------------------------------
    -- 技能介绍控制
    local introduceTitle = cc.Sprite:create("home/top_player_info/second_setting/title_skill_introduce.png")
    introduceTitle:setAnchorPoint(0, 0.5)
    introduceTitle:setPosition(cc.p(display.width / 3 - sizeSetBase.width / 10, display.height / 2 -
        sizeSetBase.height / 15))
    introduceTitle:addTo(secAvatarLayer)

    -- 事件回调函数
    local function onChangedCheckBoxIntroduce(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            --audio_.stopBGM()
        elseif eventType == ccui.CheckBoxEventType.unselected then
            --audio_.playBGM("sounds/mainMainMusic.ogg")
        end
    end

    --CheckBox技能介绍
    local ckbIntro = ccui.CheckBox:create(
        "home/top_player_info/second_setting/CheckBox_on.png", --普通状态
        "home/top_player_info/second_setting/CheckBox_on.png", --普通按下
        "home/top_player_info/second_setting/CheckBox_off.png", --选中状态
        "home/top_player_info/second_setting/CheckBox_on.png", --普通禁用
        "home/top_player_info/second_setting/CheckBox_off.png"--选中禁用
    )
    ckbIntro:setPosition(cc.p(display.width / 2 - sizeSetBase.width / 15, display.height / 2 - sizeSetBase.height / 15))
    ckbIntro:setAnchorPoint(0, 0.5)
    -- 添加事件监听器
    ckbIntro:addEventListener(onChangedCheckBoxIntroduce)
    ckbIntro:addTo(secAvatarLayer)



end

--[[--
    描述：头像选择界面弹窗

    @param layer

    @return none
]]
function MenuScene:createAvatarSelection(layer)
    local curAvaterID = 0 -- 当前展示头像id（未存入文件）

    local secAvatarLayer = ccui.Layout:create()
    secAvatarLayer:setBackGroundColor(cc.c4b(0, 0, 0, 100))
    secAvatarLayer:setBackGroundColorType(1)
    secAvatarLayer:opacity(200)
    secAvatarLayer:setAnchorPoint(0.5, 0.5)
    secAvatarLayer:setPosition(display.cx, display.cy)
    secAvatarLayer:setContentSize(display.width, display.height)
    secAvatarLayer:addTo(layer, priority_ + 1)
    -- 设置层可触摸屏蔽下方按键
    secAvatarLayer:setTouchEnabled(true)
    secAvatarLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secAvatarLayer:removeFromParent()
        end
    end)

    local selectionBase = cc.Sprite:create("home/top_player_info/second_avater_selection/base_popup.png")
    selectionBase:setAnchorPoint(0.5, 0.5)
    selectionBase:setPosition(display.cx, display.cy)
    selectionBase:addTo(secAvatarLayer)
    local sizeSetBase = selectionBase:getContentSize()

    local selectionClose = ccui.Button:create("home/top_player_info/second_avater_selection/button_close.png")
    selectionClose:setAnchorPoint(0.5, 0.5)
    selectionClose:setPosition(display.cx + sizeSetBase.width / 2 - sizeSetBase.width / 17,
        display.cy + sizeSetBase.height / 2 - sizeSetBase.height / 23)
    selectionClose:addTo(secAvatarLayer)
    selectionClose:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secAvatarLayer:removeFromParent()
        end
    end)

    -- 遮罩，屏蔽点击退出触摸事件
    local baseMaskLayer = ccui.Layout:create()
    baseMaskLayer:setAnchorPoint(0.5, 0.5)
    baseMaskLayer:setPosition(display.cx, display.cy)
    baseMaskLayer:setContentSize(sizeSetBase.width, sizeSetBase.height)
    baseMaskLayer:setTouchEnabled(true)
    baseMaskLayer:addTo(secAvatarLayer, -1)

    local avaterConfirm = ccui.Button:create("home/top_player_info/second_avater_selection/button_confirm.png")
    avaterConfirm:setAnchorPoint(0.5, 0.5)
    avaterConfirm:setPosition(display.cx, display.cy - sizeSetBase.height * 5 / 12)
    avaterConfirm:addTo(secAvatarLayer)
    avaterConfirm:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            MenuConfig.AVATER.ICON_PATH = TowerDef[curAvaterID].ICON_PATH
            MenuConfig.AVATER.ID = curAvaterID
            secAvatarLayer:removeFromParent()
            avatarButton_:loadTextures(MenuConfig.AVATER.ICON_PATH, "")
        end
    end)

    ------------------------------------------------------------------------------------------
    -- 当前选中头像展示
    local avaterCur = cc.Sprite:create(MenuConfig.AVATER.ICON_PATH)
    avaterCur:setAnchorPoint(0.5, 0.5)
    avaterCur:setPosition(sizeSetBase.width / 3, display.cy + sizeSetBase.height * 8 / 24)
    avaterCur:addTo(secAvatarLayer)

    local avaterText = display.newTTFLabel({
        text = "头像名称",
        font = "font/fzbiaozjw.ttf",
        size = 25
    })
    avaterText:align(display.LEFT_CENTER, sizeSetBase.width * 23 / 49, display.cy + sizeSetBase.height * 18 / 49)
    avaterText:setColor(cc.c3b(255, 255, 255))
    avaterText:addTo(secAvatarLayer)

    local avaterTips = cc.Sprite:create("home/top_player_info/second_avater_selection/tips.png")
    avaterTips:setAnchorPoint(0, 0.5)
    avaterTips:setPosition(sizeSetBase.width * 11 / 24, display.cy + sizeSetBase.height * 15 / 48)
    avaterTips:addTo(secAvatarLayer)

    ------------------------------------------------------------------------------------------
    -- 滑动区域
    local image = cc.Sprite:create("home/top_player_info/second_avater_selection/base_slider.png")
    local sizeImage = image:getContentSize()
    local itemWidth, itemHeight = sizeSetBase.width / 5, sizeSetBase.height / 8
    local listView = ccui.ListView:create()
    listView:setAnchorPoint(0.5, 0.5)
    listView:setPosition(display.cx, display.cy - sizeSetBase.height / 25)
    listView:setContentSize(sizeSetBase.width, sizeImage.height)
    listView:setDirection(1) -- 垂直
    listView:addTo(secAvatarLayer)
    listView:setBackGroundImage("home/top_player_info/second_avater_selection/base_slider.png")

    local avaterNum = 1
    -- 按是否获得将头像分类
    local avaterObtain = {}
    local avaterNotObtain = {}
    for id, tower in ipairs(TowerDef) do
        if tower.IS_OBTAIN then
            if tower.RARITY == "legend" then
                table.insert(avaterObtain, 1, tower)
            else
                table.insert(avaterObtain, tower)
            end
        else
            table.insert(avaterNotObtain, tower)
        end
    end
    print("obtain tower:", #avaterObtain)
    print("not obtain tower:", #avaterNotObtain)

    local iNotObtain = 0 -- 未获得标题层数
    for i = 1, 8 do
        -- 层存放每层数据
        local colLayer = ccui.Layout:create()
        colLayer:setContentSize(sizeSetBase.width, itemHeight)
        colLayer:addTo(listView)

        if i == 1 then
            colLayer:setContentSize(sizeSetBase.width, itemHeight / 2)
            local avaterTitleBase = cc.Sprite:create("home/top_player_info/second_avater_selection/division_obtain.png")
            avaterTitleBase:setAnchorPoint(0.5, 0.5)
            avaterTitleBase:setPosition(sizeSetBase.width / 2, itemHeight / 4)
            avaterTitleBase:addTo(colLayer)
        elseif i == iNotObtain then
            print("not obtain")
            colLayer:setContentSize(sizeSetBase.width, itemHeight / 2)
            local avaterTitleBaseTwo = cc.Sprite:create("home/top_player_info/second_avater_selection/division_not_obtain.png")
            avaterTitleBaseTwo:setAnchorPoint(0.5, 0.5)
            avaterTitleBaseTwo:setPosition(sizeSetBase.width / 2, itemHeight / 4)
            avaterTitleBaseTwo:addTo(colLayer)
        else
            local avaterList = ccui.ListView:create()
            avaterList:setAnchorPoint(0.5, 0.5)
            avaterList:setPosition(sizeSetBase.width / 2, itemHeight / 2)
            avaterList:setContentSize(sizeSetBase.width * 4 / 5, itemHeight)
            avaterList:setDirection(2) -- 水平
            avaterList:addTo(colLayer)
            --avaterList:setBackGroundColor(cc.c3b(255, math.random(0, 255), 255))
            --avaterList:setBackGroundColorType(1)
            for j = 1, 4 do
                local rowLayer = ccui.Layout:create()
                rowLayer:setContentSize(itemWidth, itemHeight)
                rowLayer:addTo(avaterList)

                if avaterNum <= #avaterObtain then
                    local tower = avaterObtain[avaterNum]
                    if tower == nil then
                        Log.i("obtaon tower is empty")
                    else
                        local avaterButton = ccui.Button:create(tower.ICON_PATH)
                        avaterButton:setAnchorPoint(0.5, 0.5)
                        avaterButton:setPosition(itemWidth / 2, itemHeight / 2)
                        avaterButton:addTo(rowLayer)
                        avaterNum = avaterNum + 1
                        avaterButton:addTouchEventListener(function(sender, eventType)
                            if 2 == eventType then
                                -- 更换头像展示
                                local img = cc.Sprite:create(tower.ICON_PATH):getSpriteFrame()
                                avaterCur:setSpriteFrame(img)
                                curAvaterID = tower.ID
                            end
                        end)
                    end
                elseif avaterNum == #avaterObtain + 1 then
                    iNotObtain = i + 1
                    avaterNum = avaterNum + 1
                else
                    local num = avaterNum - #avaterObtain - 1
                    print("num:", num)
                    local tower = avaterNotObtain[num]
                    if tower == nil then
                        Log.i("not obtain tower is empty")
                    else
                        local avaterButton = ccui.Button:create(tower.ICON_PATH_GREY)
                        avaterButton:setAnchorPoint(0.5, 0.5)
                        avaterButton:setPosition(itemWidth / 2, itemHeight / 2)
                        avaterButton:addTo(rowLayer)
                        avaterNum = avaterNum + 1
                    end
                end
            end
        end
    end


end

return MenuScene
