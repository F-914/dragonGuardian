local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)

local priority_ = 0     -- 存储层优先级
local menuTopLayer_
local audio_ = require"framework.audio"

-- 底部栏组件
local curPageSprite_
local sizeTab_
local tabBattle_
local tabShop_
local tabGuide_
local battleTitle_, battleIcon_
local shopTitle_, shopIcon_
local guideTitle_, guideIcon_

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
    audio_.loadFile("sound_ogg/ui_btn_click.ogg",function (dt) end)
end

--[[--
    描述：创建顶部栏

    @param none

    @return layer
]]
function MenuScene:createMenuTop()
    -- 顶部栏
    menuTopLayer_ = ccui.Layout:create()   -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    menuTopLayer_:setPosition(display.width/2, display.height/2)
    menuTopLayer_:setAnchorPoint(0.5, 0.5)
    menuTopLayer_:setContentSize(display.width, display.height)

    local topBase = cc.Sprite:create("home/top_player_info/base_top.png")
    topBase:setAnchorPoint(0.5, 1)
    topBase:setPosition(display.cx, display.height)
    local sizeBase = topBase:getContentSize()
    topBase:addTo(menuTopLayer_)

    -- 头像框按钮
    local avatarButton = ccui.Button:create("home/top_player_info/default_avatar.png")
    avatarButton:setAnchorPoint(0.5, 0.5)
    -- base的高度
    local baseHeight = sizeBase.height * display.width / sizeBase.width
    -- base中心高度
    local baseCY = display.height - baseHeight/2
    avatarButton:setPosition(display.cx / 4, baseCY + 2)
    avatarButton:addTo(menuTopLayer_, 1)
    avatarButton:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
        end
    end)

    -- 菜单按钮
    local menuButton = ccui.Button:create("home/top_player_info/button_menu.png")
    menuButton:setAnchorPoint(0.5, 0.5)
    menuButton:setPosition(display.cx*13/7, baseCY + 2)
    menuButton:addTo(menuTopLayer_)
    menuButton:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            MenuScene:createSecondMenu(menuTopLayer_:getParent())
        end
    end)

    ----------------------------------------------------------------------------
    -- 玩家信息
    local nameBase = cc.Sprite:create("home/top_player_info/base_name.png")
    nameBase:setAnchorPoint(0.5, 0.5)
    nameBase:setPosition(display.width/3 + display.cx/13, baseCY+5)
    nameBase:addTo(menuTopLayer_)
    local sizeNameBase = nameBase:getContentSize()

    local nameText = display.newTTFLabel({
        text = "玩家昵称",
        font = "font/fzzchjw.ttf",
        size = 20
    })
    nameText:align(display.LEFT_CENTER, display.width * 9 / 40, baseCY + 2 + sizeNameBase.height / 4)
    nameText:setColor(cc.c3b(255, 255, 255))
    nameText:addTo(menuTopLayer_)

    local cupSprite = cc.Sprite:create("home/top_player_info/cup.png")
    cupSprite:setAnchorPoint(0, 0.5)
    cupSprite:setPosition(display.width*9/40, baseCY+6 - sizeNameBase.height/4)
    cupSprite:addTo(menuTopLayer_)

    local scoreText = display.newTTFLabel({
        text = "100",
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    scoreText:align(display.LEFT_CENTER, display.width * 23 / 80, baseCY + 5 - sizeNameBase.height / 4)
    scoreText:setColor(cc.c3b(255, 206, 55))
    scoreText:addTo(menuTopLayer_)

    local coinBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    coinBase:setAnchorPoint(0, 1)
    coinBase:setPosition(display.cx*9/7, baseCY + sizeNameBase.height/2)
    coinBase:addTo(menuTopLayer_)

    local coinSprite = cc.Sprite:create("home/top_player_info/coin.png")
    coinSprite:setAnchorPoint(0, 1)
    coinSprite:setPosition(display.cx*9/7 - display.cx/20, baseCY + sizeNameBase.height/2)
    coinSprite:addTo(menuTopLayer_)

    local coinNum = display.newTTFLabel({
        text = "25165",
        font = "font/fzbiaozjw.ttf",
        size = 26
    })
    coinNum:align(display.RIGHT_TOP, display.cx * 8 / 5 + display.cx / 20, baseCY + sizeNameBase.height / 2 - 5)
    coinNum:setColor(cc.c3b(255, 255, 255))
    coinNum:addTo(menuTopLayer_)

    local diaBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    diaBase:setAnchorPoint(0, 0)
    diaBase:setPosition(display.cx*9/7, baseCY - sizeNameBase.height/2)
    diaBase:addTo(menuTopLayer_)

    local diaSprite = cc.Sprite:create("home/top_player_info/diamond.png")
    diaSprite:setAnchorPoint(0, 0)
    diaSprite:setPosition(display.cx*9/7 - display.cx/20, baseCY - sizeNameBase.height/2)
    diaSprite:addTo(menuTopLayer_)

    local diaNum = display.newTTFLabel({
        text = "128645",
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
    curPageSprite_:scale(display.width/3/sizeTab_.width)
    curPageSprite_:addTo(menuBottomLayer, 1)

    ----------------------------------------------------------------------------
    -- 战斗tab
    tabBattle_ = ccui.Button:create("home/bottom_tab_button/tab_unselected_middle.png")
    tabBattle_:setAnchorPoint(0.5, 0)
    tabBattle_:setPosition(display.cx, 0)
    sizeTab_ = tabBattle_:getContentSize()
    tabBattle_:scale(display.width/3/sizeTab_.width)
    tabBattle_:setTouchEnabled(false)
    tabBattle_:addTo(menuBottomLayer)

    battleIcon_ = cc.Sprite:create("home/bottom_tab_button/icon_battle.png")
    battleIcon_:setAnchorPoint(0.5, 0.5)
    battleIcon_:setPosition(display.cx, sizeTab_.height/2 + sizeTab_.height/5)
    battleIcon_:addTo(menuBottomLayer, 2)

    battleTitle_ = cc.Sprite:create("home/bottom_tab_button/title_battle.png")
    battleTitle_:setAnchorPoint(0.5, 1)
    battleTitle_:setPosition(display.cx, sizeTab_.height/3)
    battleTitle_:addTo(menuBottomLayer, 2)
    battleTitle_:setVisible(true)

    tabBattle_:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            local MainScene = require"app.scenes.MainScene"
            MainScene:setPage(1)
        end
    end)

    ----------------------------------------------------------------------------
    -- 商店tab
    tabShop_ = ccui.Button:create("home/bottom_tab_button/tab_unselected_left.png")
    tabShop_:setAnchorPoint(0, 0)
    tabShop_:setPosition(0, 0)
    sizeTab_ = tabShop_:getContentSize()
    tabShop_:scale(display.width/3/sizeTab_.width)
    tabShop_:addTo(menuBottomLayer)


    shopIcon_ = cc.Sprite:create("home/bottom_tab_button/icon_shop.png")
    shopIcon_:setAnchorPoint(0.5, 0.5)
    shopIcon_:setPosition(sizeTab_.width/2, sizeTab_.height/2)
    shopIcon_:addTo(menuBottomLayer, 2)

    shopTitle_ = cc.Sprite:create("home/bottom_tab_button/title_shop.png")
    shopTitle_:setAnchorPoint(0.5, 1)
    shopTitle_:setPosition(sizeTab_.width/2, sizeTab_.height/3)
    shopTitle_:addTo(menuBottomLayer, 2)
    shopTitle_:setVisible(false)

    tabShop_:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            local MainScene = require"app.scenes.MainScene"
            MainScene:setPage(0)
        end
    end)

    ----------------------------------------------------------------------------
    -- 图鉴tab
    tabGuide_ = ccui.Button:create("home/bottom_tab_button/tab_unselected_right.png")
    tabGuide_:setAnchorPoint(1, 0)
    tabGuide_:setPosition(display.width, 0)
    sizeTab_ = tabGuide_:getContentSize()
    tabGuide_:scale(display.width/3/sizeTab_.width)
    tabGuide_:addTo(menuBottomLayer)

    guideIcon_ = cc.Sprite:create("home/bottom_tab_button/icon_guide.png")
    guideIcon_:setAnchorPoint(0.5, 0.5)
    guideIcon_:setPosition(display.width - sizeTab_.width/2, sizeTab_.height/2)
    guideIcon_:addTo(menuBottomLayer, 2)

    guideTitle_ = cc.Sprite:create("home/bottom_tab_button/title_guide.png")
    guideTitle_:setAnchorPoint(0.5, 1)
    guideTitle_:setPosition(display.width - sizeTab_.width/2, sizeTab_.height/3)
    guideTitle_:addTo(menuBottomLayer, 2)
    guideTitle_:setVisible(false)

    tabGuide_:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            local MainScene = require"app.scenes.MainScene"
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
        curPageSprite_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx,0)))
        battleIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab_.height/2 + sizeTab_.height/5)))
        battleTitle_:setVisible(true)
        shopIcon_:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab_.width/2, sizeTab_.height/2)))
        shopTitle_:setVisible(false)
        guideIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab_.width/2, sizeTab_.height/2)))
        guideTitle_:setVisible(false)
    elseif num == 1 then
        print("left-shop")
        tabShop_:setTouchEnabled(false)
        tabBattle_:setTouchEnabled(true)
        tabGuide_:setTouchEnabled(true)
        curPageSprite_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx/3,0)))
        battleIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab_.height/2)))
        battleTitle_:setVisible(false)
        shopIcon_:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab_.width/2, sizeTab_.height/2 + sizeTab_.height/5)))
        shopTitle_:setVisible(true)
        guideIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab_.width/2, sizeTab_.height/2)))
        guideTitle_:setVisible(false)
    elseif num == 3 then
        print("right-guide")
        tabShop_:setTouchEnabled(true)
        tabBattle_:setTouchEnabled(true)
        tabGuide_:setTouchEnabled(false)
        curPageSprite_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx*5/3,0)))
        battleIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab_.height/2)))
        battleTitle_:setVisible(false)
        shopIcon_:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab_.width/2, sizeTab_.height/2)))
        shopTitle_:setVisible(false)
        guideIcon_:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab_.width/2, sizeTab_.height/2 + sizeTab_.height/5)))
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
    secMenuLayer:setBackGroundColor(cc.c4b(0,0,0,100))
    secMenuLayer:setBackGroundColorType(1)
    secMenuLayer:opacity(200)
    secMenuLayer:setAnchorPoint(0.5, 0.5)
    secMenuLayer:setPosition(display.cx, display.cy)
    secMenuLayer:setContentSize(display.width, display.height)
    secMenuLayer:addTo(layer, priority_ + 1)
    -- 设置层可触摸屏蔽下方按键
    secMenuLayer:setTouchEnabled(true)
    secMenuLayer:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secMenuLayer:removeFromParent()
        end
    end)

    local secMenuBase = cc.Sprite:create("home/top_player_info/second_menu/base_menu.png")
    secMenuBase:setAnchorPoint(1, 1)
    secMenuBase:setPosition(display.cx*12/7, display.height - display.height/30)
    secMenuBase:addTo(secMenuLayer)
    -- 计算base宽度高度中心
    local sizeSecMenuBase = secMenuBase:getContentSize()
    local secMenuBaseCX = secMenuBase:getPositionX() - sizeSecMenuBase.width/2
    local secMenuBaseCY = secMenuBase:getPositionY() - sizeSecMenuBase.height/2

    ------------------------------------------------------------------------------------------------
    -- 公告
    local announcButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    announcButton:setAnchorPoint(0.5, 0.5)
    announcButton:setPosition(secMenuBaseCX, secMenuBaseCY + sizeSecMenuBase.height*3/9)
    announcButton:addTo(secMenuLayer)

    local announcTitle = cc.Sprite:create("home/top_player_info/second_menu/text_announcement.png")
    announcTitle:setAnchorPoint(0.5, 0.5)
    announcTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width/20, secMenuBaseCY + sizeSecMenuBase.height*3/9)
    announcTitle:addTo(secMenuLayer)

    local announcIcon = cc.Sprite:create("home/top_player_info/second_menu/button_announcement.png")
    announcIcon:setAnchorPoint(0.5, 0.5)
    announcIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width*7/24, secMenuBaseCY + sizeSecMenuBase.height*3/9)
    announcIcon:addTo(secMenuLayer)

    ------------------------------------------------------------------------------------------------
    -- 邮箱
    local mailButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    mailButton:setAnchorPoint(0.5, 0.5)
    mailButton:setPosition(secMenuBaseCX, secMenuBaseCY + sizeSecMenuBase.height*1/9)
    mailButton:addTo(secMenuLayer)

    local mailTitle = cc.Sprite:create("home/top_player_info/second_menu/text_mail.png")
    mailTitle:setAnchorPoint(0.5, 0.5)
    mailTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width/20, secMenuBaseCY + sizeSecMenuBase.height*1/9)
    mailTitle:addTo(secMenuLayer)

    local mailIcon = cc.Sprite:create("home/top_player_info/second_menu/button_mail.png")
    mailIcon:setAnchorPoint(0.5, 0.5)
    mailIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width*7/24, secMenuBaseCY + sizeSecMenuBase.height*1/9)
    mailIcon:addTo(secMenuLayer)

    ------------------------------------------------------------------------------------------------
    -- 对战记录
    local recordButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    recordButton:setAnchorPoint(0.5, 0.5)
    recordButton:setPosition(secMenuBaseCX, secMenuBaseCY - sizeSecMenuBase.height*1/9)
    recordButton:addTo(secMenuLayer)

    local recordTitle = cc.Sprite:create("home/top_player_info/second_menu/text_record.png")
    recordTitle:setAnchorPoint(0.5, 0.5)
    recordTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width/20, secMenuBaseCY - sizeSecMenuBase.height*1/9)
    recordTitle:addTo(secMenuLayer)

    local recordIcon = cc.Sprite:create("home/top_player_info/second_menu/button_record.png")
    recordIcon:setAnchorPoint(0.5, 0.5)
    recordIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width*7/24, secMenuBaseCY - sizeSecMenuBase.height*1/9)
    recordIcon:addTo(secMenuLayer)

    ------------------------------------------------------------------------------------------------
    -- 设置
    local settingButton = ccui.Button:create("home/top_player_info/second_menu/base_button.png")
    settingButton:setAnchorPoint(0.5, 0.5)
    settingButton:setPosition(secMenuBaseCX, secMenuBaseCY - sizeSecMenuBase.height*3/9)
    settingButton:addTo(secMenuLayer)

    local settingTitle = cc.Sprite:create("home/top_player_info/second_menu/text_setting.png")
    settingTitle:setAnchorPoint(0.5, 0.5)
    settingTitle:setPosition(secMenuBaseCX + sizeSecMenuBase.width/20, secMenuBaseCY - sizeSecMenuBase.height*3/9)
    settingTitle:addTo(secMenuLayer)

    local settingIcon = cc.Sprite:create("home/top_player_info/second_menu/button_setting.png")
    settingIcon:setAnchorPoint(0.5, 0.5)
    settingIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width*7/24, secMenuBaseCY - sizeSecMenuBase.height*3/9)
    settingIcon:addTo(secMenuLayer)

    settingButton:addTouchEventListener(function (sender, eventType)
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
    local secSettingLayer = ccui.Layout:create()
    secSettingLayer:setBackGroundColor(cc.c4b(0,0,0,100))
    secSettingLayer:setBackGroundColorType(1)
    secSettingLayer:opacity(200)
    secSettingLayer:setAnchorPoint(0.5, 0.5)
    secSettingLayer:setPosition(display.cx, display.cy)
    secSettingLayer:setContentSize(display.width, display.height)
    secSettingLayer:addTo(layer, priority_ + 1)
    -- 设置层可触摸屏蔽下方按键
    secSettingLayer:setTouchEnabled(true)
    secSettingLayer:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secSettingLayer:removeFromParent()
        end
    end)

    local setBase = cc.Sprite:create("home/top_player_info/second_setting/base_popup.png")
    setBase:setAnchorPoint(0.5, 0.5)
    setBase:setPosition(display.cx, display.cy)
    setBase:addTo(secSettingLayer)
    local sizeSetBase = setBase:getContentSize()

    local setClose = ccui.Button:create("home/top_player_info/second_setting/button_close.png")
    setClose:setAnchorPoint(0.5, 0.5)
    setClose:setPosition(display.cx + sizeSetBase.width/2 - sizeSetBase.width/17, display.cy + sizeSetBase.height/2 - sizeSetBase.height/10)
    setClose:addTo(secSettingLayer)
    setClose:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
            secSettingLayer:removeFromParent()
        end
    end)

    -- 遮罩，屏蔽点击退出触摸事件
    local baseMaskLayer = ccui.Layout:create()
    baseMaskLayer:setAnchorPoint(0.5, 0.5)
    baseMaskLayer:setPosition(display.cx, display.cy)
    baseMaskLayer:setContentSize(sizeSetBase.width, sizeSetBase.height)
    baseMaskLayer:setTouchEnabled(true)
    baseMaskLayer:addTo(secSettingLayer, -1)

    local setExit = ccui.Button:create("home/top_player_info/second_setting/button_exit.png")
    setExit:setAnchorPoint(0.5, 0.5)
    setExit:setPosition(display.cx, display.cy - sizeSetBase.height*7/24)
    setExit:addTo(secSettingLayer)
    setExit:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio_.playEffect("sound_ogg/ui_btn_click.ogg")
        end
    end)

    local versionText = display.newTTFLabel({
        text = "版本号：xxx.xxx.xxx",
        font = "",
        size = 21
    })
    versionText:align(display.CENTER, display.cx, display.cy - sizeSetBase.height/2 + sizeSetBase.height/14)
    versionText:setColor(cc.c3b(255, 255, 255))
    versionText:opacity(60)
    versionText:addTo(secSettingLayer)

    ------------------------------------------------------------------------------------------------
    -- 音效控制
    local effectTitle = cc.Sprite:create("home/top_player_info/second_setting/title_effect.png")
    effectTitle:setAnchorPoint(0, 0.5)
    effectTitle:setPosition(cc.p(display.width/3 - sizeSetBase.width/10, display.height/2 + sizeSetBase.height/5))
    effectTitle:addTo(secSettingLayer)

    -- 事件回调函数
    local function onChangedCheckBoxEffect(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            audio_.stopEffect()
            --audioBgm.pauseAll()
        elseif eventType == ccui.CheckBoxEventType.unselected then
            --audio.playEffect("sounds/mainMainMusic.ogg")
            --audioBgm.resumeAll()
        end
    end

    --CheckBox音效
    local ckbEffect = ccui.CheckBox:create(
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通状态
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通按下
        "home/top_player_info/second_setting/CheckBox_off.png",    --选中状态
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通禁用
        "home/top_player_info/second_setting/CheckBox_off.png"     --选中禁用
    )
    ckbEffect:setPosition(cc.p(display.width/2 - sizeSetBase.width/15, display.height/2 + sizeSetBase.height/5))
    ckbEffect:setAnchorPoint(0,0.5)
    -- 添加事件监听器
    ckbEffect:addEventListener(onChangedCheckBoxEffect)
    ckbEffect:addTo(secSettingLayer)

    ------------------------------------------------------------------------------------------------
    -- 音乐控制
    local effectTitle = cc.Sprite:create("home/top_player_info/second_setting/title_music.png")
    effectTitle:setAnchorPoint(0, 0.5)
    effectTitle:setPosition(cc.p(display.width/3 - sizeSetBase.width/10, display.height/2 + sizeSetBase.height/15))
    effectTitle:addTo(secSettingLayer)

    -- 事件回调函数
    local function onChangedCheckBoxBgm(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            audio_.stopBGM()
        elseif eventType == ccui.CheckBoxEventType.unselected then
            --audio_.playBGM("sounds/mainMainMusic.ogg")
        end
    end 

    --CheckBox音乐
    local ckbBgm = ccui.CheckBox:create(
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通状态
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通按下
        "home/top_player_info/second_setting/CheckBox_off.png",    --选中状态
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通禁用
        "home/top_player_info/second_setting/CheckBox_off.png"     --选中禁用
    )
    ckbBgm:setPosition(cc.p(display.width/2 - sizeSetBase.width/15, display.height/2 + sizeSetBase.height/15))
    ckbBgm:setAnchorPoint(0,0.5)
    -- 添加事件监听器
    ckbBgm:addEventListener(onChangedCheckBoxBgm)
    ckbBgm:addTo(secSettingLayer)

    ------------------------------------------------------------------------------------------------
    -- 技能介绍控制
    local introduceTitle = cc.Sprite:create("home/top_player_info/second_setting/title_skill_introduce.png")
    introduceTitle:setAnchorPoint(0, 0.5)
    introduceTitle:setPosition(cc.p(display.width/3 - sizeSetBase.width/10, display.height/2 - sizeSetBase.height/15))
    introduceTitle:addTo(secSettingLayer)

    -- 事件回调函数
    local function onChangedCheckBoxIntroduce(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            --audio_.stopBGM()
        elseif eventType == ccui.CheckBoxEventType.unselected then
            --audio_.playBGM("sounds/mainMainMusic.ogg")
        end
    end 

    --CheckBox音乐
    local ckbBgm = ccui.CheckBox:create(
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通状态
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通按下
        "home/top_player_info/second_setting/CheckBox_off.png",    --选中状态
        "home/top_player_info/second_setting/CheckBox_on.png",    --普通禁用
        "home/top_player_info/second_setting/CheckBox_off.png"     --选中禁用
    )
    ckbBgm:setPosition(cc.p(display.width/2 - sizeSetBase.width/15, display.height/2 - sizeSetBase.height/15))
    ckbBgm:setAnchorPoint(0,0.5)
    -- 添加事件监听器
    ckbBgm:addEventListener(onChangedCheckBoxIntroduce)
    ckbBgm:addTo(secSettingLayer)



end


return MenuScene
