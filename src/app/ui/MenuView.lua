--[[--
    上下边栏
    MenuView.lua
]]
local MenuView = class(
        "MenuView",
        function()
            return display.newColorLayer(cc.c4b(0, 0, 0, 0))
        end
)
-- local
local audio = require "framework.audio"
local MenuConfig = require "app.test.MenuConfig"
local TowerDef = require "app.def.TowerDef"
local Log = require "app.utils.Log"
local UserInfo = require("app.data.UserInfo")
local StringDef = require("app.def.StringDef")
local OutGameData = require("app.data.OutGameData")
local ConstDef = require("app.def.ConstDef")
--
local _priority = 0 -- 存储层优先级
local _menuTopLayer
local _avatarButton
-- 底部栏组件
local _curPageSprite
local _sizeTab
local _tabBattle
local _tabShop
local _tabGuide
local _battleTitle, _battleIcon
local _shopTitle, _shopIcon
local _guideTitle, _guideIcon
--

--[[--
    描述：构造函数

    @param none

    @return none
]]
function MenuView:ctor(layer, num)
    _priority = num
    self:loadMusic()
    local menuTop = self:createMenuTop()
    local menuBottom = self:createMenuBottom()
    print(layer.addChild)
    menuTop:addTo(layer, _priority)
    menuBottom:addTo(layer, _priority)
end

--[[--
    描述：音乐音效加载

    @param none

    @return none
]]
function MenuView:loadMusic()
    audio.loadFile("sound_ogg/ui_btn_click.ogg", function(dt)
    end)
end

--[[--
    描述：创建顶部栏

    @param none

    @return layer
]]
function MenuView:createMenuTop()
    -- 顶部栏
    _menuTopLayer = ccui.Layout:create() -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    _menuTopLayer:setPosition(display.width / 2, display.height / 2)
    _menuTopLayer:setAnchorPoint(0.5, 0.5)
    _menuTopLayer:setContentSize(display.width, display.height)

    local topBase = cc.Sprite:create("home/top_player_info/base_top.png")
    topBase:setAnchorPoint(0.5, 1)
    topBase:setPosition(display.cx, display.height)
    local sizeBase = topBase:getContentSize()
    topBase:addTo(_menuTopLayer)

    -- 头像框按钮
    _avatarButton = ccui.Button:create(OutGameData:getUserInfo():getAvatar())
    _avatarButton:setAnchorPoint(0.5, 0.5)
    -- base的高度
    local baseHeight = sizeBase.height * display.width / sizeBase.width
    -- base中心高度
    local baseCY = display.height - baseHeight / 2
    _avatarButton:setPosition(display.cx / 4, baseCY + 2)
    _avatarButton:addTo(_menuTopLayer, 1)
    _avatarButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            MenuView:createAvatarSelection(_menuTopLayer:getParent())
        end
    end)

    -- 菜单按钮
    local menuButton = ccui.Button:create("home/top_player_info/button_menu.png")
    menuButton:setAnchorPoint(0.5, 0.5)
    menuButton:setPosition(display.cx * 13 / 7, baseCY + 2)
    menuButton:addTo(_menuTopLayer)
    menuButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            MenuView:createSecondMenu(_menuTopLayer:getParent())
        end
    end)

    ----------------------------------------------------------------------------
    -- 玩家信息
    local nameBase = cc.Sprite:create("home/top_player_info/base_name.png")
    nameBase:setAnchorPoint(0.5, 0.5)
    nameBase:setPosition(display.width / 3 + display.cx / 13, baseCY + 5)
    nameBase:addTo(_menuTopLayer)
    local sizeNameBase = nameBase:getContentSize()

    local nameText = display.newTTFLabel({
        text = OutGameData:getUserInfo():getNickname(),
        font = StringDef.PATH_FONT_FZZCHJW,
        size = 20
    })
    nameText:align(display.LEFT_CENTER, display.width * 9 / 40, baseCY + 2 + sizeNameBase.height / 4)
    nameText:setColor(cc.c3b(255, 255, 255))
    nameText:addTo(_menuTopLayer)

    local cupSprite = cc.Sprite:create("home/top_player_info/cup.png")
    cupSprite:setAnchorPoint(0, 0.5)
    cupSprite:setPosition(display.width * 9 / 40, baseCY + 6 - sizeNameBase.height / 4)
    cupSprite:addTo(_menuTopLayer)

    local scoreText = display.newTTFLabel({
        text = OutGameData:getUserInfo():getTrophyAmount(),
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    scoreText:align(display.LEFT_CENTER, display.width * 23 / 80, baseCY + 5 - sizeNameBase.height / 4)
    scoreText:setColor(cc.c3b(255, 206, 55))
    scoreText:addTo(_menuTopLayer)

    local coinBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    coinBase:setAnchorPoint(0, 1)
    coinBase:setPosition(display.cx * 9 / 7, baseCY + sizeNameBase.height / 2)
    coinBase:addTo(_menuTopLayer)

    local coinSprite = cc.Sprite:create("home/top_player_info/coin.png")
    coinSprite:setAnchorPoint(0, 1)
    coinSprite:setPosition(display.cx * 9 / 7 - display.cx / 20, baseCY + sizeNameBase.height / 2)
    coinSprite:addTo(_menuTopLayer)

    local coinNum = display.newTTFLabel({
        text = OutGameData:getUserInfo():getCoinAmount(),
        font = StringDef.PATH_FONT_FZBIAOZJW,
        size = 26
    })
    coinNum:align(display.RIGHT_TOP, display.cx * 8 / 5 + display.cx / 20, baseCY + sizeNameBase.height / 2 - 5)
    coinNum:setColor(cc.c3b(255, 255, 255))
    coinNum:addTo(_menuTopLayer)

    local diaBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    diaBase:setAnchorPoint(0, 0)
    diaBase:setPosition(display.cx * 9 / 7, baseCY - sizeNameBase.height / 2)
    diaBase:addTo(_menuTopLayer)

    local diaSprite = cc.Sprite:create("home/top_player_info/diamond.png")
    diaSprite:setAnchorPoint(0, 0)
    diaSprite:setPosition(display.cx * 9 / 7 - display.cx / 20, baseCY - sizeNameBase.height / 2)
    diaSprite:addTo(_menuTopLayer)

    local diaNum = display.newTTFLabel({
        text = OutGameData:getUserInfo():getDiamondAmount(),
        font = StringDef.PATH_FONT_FZBIAOZJW,
        size = 26
    })
    diaNum:align(display.RIGHT_BOTTOM, display.cx * 8 / 5 + display.cx / 20, baseCY - sizeNameBase.height / 2 + 5)
    diaNum:setColor(cc.c3b(255, 255, 255))
    diaNum:addTo(_menuTopLayer)

    return _menuTopLayer
end

--[[--
    描述：创建底部栏

    @param none

    @return layer
]]
function MenuView:createMenuBottom()
    local menuBottomLayer = ccui.Layout:create() -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    menuBottomLayer:setPosition(display.width / 2, display.height / 2)
    menuBottomLayer:setAnchorPoint(0.5, 0.5)
    menuBottomLayer:setContentSize(display.width, display.height)

    _curPageSprite = cc.Sprite:create("home/bottom_tab_button/tab_selected.png")
    _curPageSprite:setAnchorPoint(0.5, 0)
    _curPageSprite:setPosition(display.cx, 0)
    _sizeTab = _curPageSprite:getContentSize()
    _curPageSprite:scale(display.width / 3 / _sizeTab.width)
    _curPageSprite:addTo(menuBottomLayer, 1)

    ----------------------------------------------------------------------------
    -- 战斗tab
    _tabBattle = ccui.Button:create("home/bottom_tab_button/tab_unselected_middle.png")
    _tabBattle:setAnchorPoint(0.5, 0)
    _tabBattle:setPosition(display.cx, 0)
    _sizeTab = _tabBattle:getContentSize()
    _tabBattle:scale(display.width / 3 / _sizeTab.width)
    _tabBattle:setTouchEnabled(false)
    _tabBattle:addTo(menuBottomLayer)

    _battleIcon = cc.Sprite:create("home/bottom_tab_button/icon_battle.png")
    _battleIcon:setAnchorPoint(0.5, 0.5)
    _battleIcon:setPosition(display.cx, _sizeTab.height / 2 + _sizeTab.height / 5)
    _battleIcon:addTo(menuBottomLayer, 2)

    _battleTitle = cc.Sprite:create("home/bottom_tab_button/title_battle.png")
    _battleTitle:setAnchorPoint(0.5, 1)
    _battleTitle:setPosition(display.cx, _sizeTab.height / 3)
    _battleTitle:addTo(menuBottomLayer, 2)
    _battleTitle:setVisible(true)

    _tabBattle:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            local OutGameScene = require "app.scenes.OutGameScene"
            OutGameScene:setPage(1)
        end
    end)

    ----------------------------------------------------------------------------
    -- 商店tab
    _tabShop = ccui.Button:create("home/bottom_tab_button/tab_unselected_left.png")
    _tabShop:setAnchorPoint(0, 0)
    _tabShop:setPosition(0, 0)
    _sizeTab = _tabShop:getContentSize()
    _tabShop:scale(display.width / 3 / _sizeTab.width)
    _tabShop:addTo(menuBottomLayer)

    _shopIcon = cc.Sprite:create("home/bottom_tab_button/icon_shop.png")
    _shopIcon:setAnchorPoint(0.5, 0.5)
    _shopIcon:setPosition(_sizeTab.width / 2, _sizeTab.height / 2)
    _shopIcon:addTo(menuBottomLayer, 2)

    _shopTitle = cc.Sprite:create("home/bottom_tab_button/title_shop.png")
    _shopTitle:setAnchorPoint(0.5, 1)
    _shopTitle:setPosition(_sizeTab.width / 2, _sizeTab.height / 3)
    _shopTitle:addTo(menuBottomLayer, 2)
    _shopTitle:setVisible(false)

    _tabShop:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            local OutGameScene = require "app.scenes.OutGameScene"
            OutGameScene:setPage(0)
        end
    end)

    ----------------------------------------------------------------------------
    -- 图鉴tab
    _tabGuide = ccui.Button:create("home/bottom_tab_button/tab_unselected_right.png")
    _tabGuide:setAnchorPoint(1, 0)
    _tabGuide:setPosition(display.width, 0)
    _sizeTab = _tabGuide:getContentSize()
    _tabGuide:scale(display.width / 3 / _sizeTab.width)
    _tabGuide:addTo(menuBottomLayer)

    _guideIcon = cc.Sprite:create("home/bottom_tab_button/icon_guide.png")
    _guideIcon:setAnchorPoint(0.5, 0.5)
    _guideIcon:setPosition(display.width - _sizeTab.width / 2, _sizeTab.height / 2)
    _guideIcon:addTo(menuBottomLayer, 2)

    _guideTitle = cc.Sprite:create("home/bottom_tab_button/title_guide.png")
    _guideTitle:setAnchorPoint(0.5, 1)
    _guideTitle:setPosition(display.width - _sizeTab.width / 2, _sizeTab.height / 3)
    _guideTitle:addTo(menuBottomLayer, 2)
    _guideTitle:setVisible(false)

    _tabGuide:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            local OutGameScene = require "app.scenes.OutGameScene"
            OutGameScene:setPage(2)
        end
    end)

    return menuBottomLayer
end

--[[--
    描述：底部栏状态切换

    @param int: 1--商店、2--战斗、3--图鉴

    @return none
]]
function MenuView:bottomMenuControl(num)
    if num == 2 then
        Log.i("mid-battle")
        _tabShop:setTouchEnabled(true)
        _tabBattle:setTouchEnabled(false)
        _tabGuide:setTouchEnabled(true)
        _curPageSprite:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, 0)))
        _battleIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, _sizeTab.height / 2 + _sizeTab.height / 5)))
        _battleTitle:setVisible(true)
        _shopIcon:runAction(cc.MoveTo:create(0.08, cc.p(_sizeTab.width / 2, _sizeTab.height / 2)))
        _shopTitle:setVisible(false)
        _guideIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.width - _sizeTab.width / 2, _sizeTab.height / 2)))
        _guideTitle:setVisible(false)
    elseif num == 1 then
        Log.i("left-shop")
        _tabShop:setTouchEnabled(false)
        _tabBattle:setTouchEnabled(true)
        _tabGuide:setTouchEnabled(true)
        _curPageSprite:runAction(cc.MoveTo:create(0.08, cc.p(display.cx / 3, 0)))
        _battleIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, _sizeTab.height / 2)))
        _battleTitle:setVisible(false)
        _shopIcon:runAction(cc.MoveTo:create(0.08, cc.p(_sizeTab.width / 2, _sizeTab.height / 2 + _sizeTab.height / 5)))
        _shopTitle:setVisible(true)
        _guideIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.width - _sizeTab.width / 2, _sizeTab.height / 2)))
        _guideTitle:setVisible(false)
    elseif num == 3 then
        Log.i("right-guide")
        _tabShop:setTouchEnabled(true)
        _tabBattle:setTouchEnabled(true)
        _tabGuide:setTouchEnabled(false)
        _curPageSprite:runAction(cc.MoveTo:create(0.08, cc.p(display.cx * 5 / 3, 0)))
        _battleIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, _sizeTab.height / 2)))
        _battleTitle:setVisible(false)
        _shopIcon:runAction(cc.MoveTo:create(0.08, cc.p(_sizeTab.width / 2, _sizeTab.height / 2)))
        _shopTitle:setVisible(false)
        _guideIcon:runAction(cc.MoveTo:create(0.08,
                cc.p(display.width - _sizeTab.width / 2, _sizeTab.height / 2 + _sizeTab.height / 5)))
        _guideTitle:setVisible(true)
    end
end

--[[--
    描述：菜单栏二级界面

    @param layer

    @return none
]]
function MenuView:createSecondMenu(layer)
    Log.i("second menu")
    local secMenuLayer = ccui.Layout:create()
    secMenuLayer:setBackGroundColor(cc.c4b(0, 0, 0, 100))
    secMenuLayer:setBackGroundColorType(1)
    secMenuLayer:opacity(200)
    secMenuLayer:setAnchorPoint(0.5, 0.5)
    secMenuLayer:setPosition(display.cx, display.cy)
    secMenuLayer:setContentSize(display.width, display.height)
    secMenuLayer:addTo(layer, _priority + 1)
    -- 设置层可触摸屏蔽下方按键
    secMenuLayer:setTouchEnabled(true)
    secMenuLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
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
    announcIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width * 7 / 24,
            secMenuBaseCY + sizeSecMenuBase.height * 3 /
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
    settingIcon:setPosition(secMenuBaseCX - sizeSecMenuBase.width * 7 / 24,
            secMenuBaseCY - sizeSecMenuBase.height * 3 /
                    9)
    settingIcon:addTo(secMenuLayer)

    settingButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            settingButton:setTouchEnabled(false)
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
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
function MenuView:createSecondSetting(layer)
    local secAvatarLayer = ccui.Layout:create()
    secAvatarLayer:setBackGroundColor(cc.c4b(0, 0, 0, 100))
    secAvatarLayer:setBackGroundColorType(1)
    secAvatarLayer:opacity(200)
    secAvatarLayer:setAnchorPoint(0.5, 0.5)
    secAvatarLayer:setPosition(display.cx, display.cy)
    secAvatarLayer:setContentSize(display.width, display.height)
    secAvatarLayer:addTo(layer, _priority + 1)
    -- 设置层可触摸屏蔽下方按键
    secAvatarLayer:setTouchEnabled(true)
    secAvatarLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
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
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
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
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
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
            audio.setEffectVolume(0)
            MenuConfig.IS_PLAY_EFFECT = false
        elseif eventType == ccui.CheckBoxEventType.unselected then
            audio.setEffectVolume(1)
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
            audio.stopBGM()
            MenuConfig.IS_PLAY_BGM = false
        elseif eventType == ccui.CheckBoxEventType.unselected then
            audio.playBGM("sound_ogg/lobby_bgm_120bpm.ogg")
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
            --audio.stopBGM()
        elseif eventType == ccui.CheckBoxEventType.unselected then
            --audio.playBGM("sounds/mainMainMusic.ogg")
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
function MenuView:createAvatarSelection(layer)
    local curAvatarID = 0 -- 当前展示头像id（未存入文件）

    local secAvatarLayer = ccui.Layout:create()
    secAvatarLayer:setBackGroundColor(cc.c4b(0, 0, 0, 100))
    secAvatarLayer:setBackGroundColorType(1)
    secAvatarLayer:opacity(200)
    secAvatarLayer:setAnchorPoint(0.5, 0.5)
    secAvatarLayer:setPosition(display.cx, display.cy)
    secAvatarLayer:setContentSize(display.width, display.height)
    secAvatarLayer:addTo(layer, _priority + 1)
    -- 设置层可触摸屏蔽下方按键
    secAvatarLayer:setTouchEnabled(true)
    secAvatarLayer:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            secAvatarLayer:removeFromParent()
        end
    end)

    local selectionBase = cc.Sprite:create("home/top_player_info/second_avatar_selection/base_popup.png")
    selectionBase:setAnchorPoint(0.5, 0.5)
    selectionBase:setPosition(display.cx, display.cy)
    selectionBase:addTo(secAvatarLayer)
    local sizeSetBase = selectionBase:getContentSize()

    local selectionClose = ccui.Button:create("home/top_player_info/second_avatar_selection/button_close.png")
    selectionClose:setAnchorPoint(0.5, 0.5)
    selectionClose:setPosition(display.cx + sizeSetBase.width / 2 - sizeSetBase.width / 17,
            display.cy + sizeSetBase.height / 2 - sizeSetBase.height / 23)
    selectionClose:addTo(secAvatarLayer)
    selectionClose:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
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

    local avatarConfirm = ccui.Button:create("home/top_player_info/second_avatar_selection/button_confirm.png")
    avatarConfirm:setAnchorPoint(0.5, 0.5)
    avatarConfirm:setPosition(display.cx, display.cy - sizeSetBase.height * 5 / 12)
    avatarConfirm:addTo(secAvatarLayer)
    avatarConfirm:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            --MenuConfig.AVATER.ICON_PATH = TowerDef[curAvatarID].ICON_PATH
            OutGameData:getUserInfo():setAvatar(TowerDef[curAvatarID].ICON_PATH)
            --OutGameData:getUserInfo():setAvatarId(curAvatarID)
            secAvatarLayer:removeFromParent()
            _avatarButton:loadTextures(OutGameData:getUserInfo():getAvatar(), "")
        end
    end)

    ------------------------------------------------------------------------------------------
    -- 当前选中头像展示
    local avatarCur = cc.Sprite:create(OutGameData:getUserInfo():getAvatar())
    avatarCur:setAnchorPoint(0.5, 0.5)
    avatarCur:setPosition(sizeSetBase.width / 3, display.cy + sizeSetBase.height * 8 / 24)
    avatarCur:addTo(secAvatarLayer)

    local avatarText = display.newTTFLabel({
        text = "头像名称",
        font = "font/fzbiaozjw.ttf",
        size = 25
    })
    avatarText:align(display.LEFT_CENTER, sizeSetBase.width * 23 / 49, display.cy + sizeSetBase.height * 18 / 49)
    avatarText:setColor(cc.c3b(255, 255, 255))
    avatarText:addTo(secAvatarLayer)

    local avatarTips = cc.Sprite:create("home/top_player_info/second_avatar_selection/tips.png")
    avatarTips:setAnchorPoint(0, 0.5)
    avatarTips:setPosition(sizeSetBase.width * 11 / 24, display.cy + sizeSetBase.height * 15 / 48)
    avatarTips:addTo(secAvatarLayer)

    ------------------------------------------------------------------------------------------
    -- 滑动区域
    local image = cc.Sprite:create("home/top_player_info/second_avatar_selection/base_slider.png")
    local sizeImage = image:getContentSize()
    local itemWidth, itemHeight = sizeSetBase.width / 5, sizeSetBase.height / 8
    local listView = ccui.ListView:create()
    listView:setAnchorPoint(0.5, 0.5)
    listView:setPosition(display.cx, display.cy - sizeSetBase.height / 25)
    listView:setContentSize(sizeSetBase.width, sizeImage.height)
    listView:setDirection(1) -- 垂直
    listView:addTo(secAvatarLayer)
    listView:setBackGroundImage("home/top_player_info/second_avatar_selection/base_slider.png")

    local avatarNum = 1
    -- 按是否获得将头像分类
    local avatarObtain = {}
    local avatarNotObtain = {}
    local cardList = OutGameData:getUserInfo():getCardList()
    for i = 1, ConstDef.CARD_TOTAL_NUM do
        if cardList[i] == nil then
            table.insert(avatarNotObtain, i)
        else
            if cardList[i]:getCardRarity() == ConstDef.TOWER_RARITY.UR then
                table.insert(avatarObtain, 1, i)
            else
                table.insert(avatarObtain, i)
            end
        end
    end
    Log.i("obtain tower:" .. #(avatarObtain))
    Log.i("not obtain tower:" .. #(avatarNotObtain))

    local iNotObtain = 0 -- 未获得标题层数
    for i = 1, 8 do
        -- 层存放每层数据
        local colLayer = ccui.Layout:create()
        colLayer:setContentSize(sizeSetBase.width, itemHeight)
        colLayer:addTo(listView)

        if i == 1 then
            -- 已获取标题
            colLayer:setContentSize(sizeSetBase.width, itemHeight / 2)
            local avatarTitleBase = cc.Sprite:create("home/top_player_info/second_avatar_selection/division_obtain.png")
            avatarTitleBase:setAnchorPoint(0.5, 0.5)
            avatarTitleBase:setPosition(sizeSetBase.width / 2, itemHeight / 4)
            avatarTitleBase:addTo(colLayer)
        elseif i == iNotObtain then
            -- 未获取标题
            colLayer:setContentSize(sizeSetBase.width, itemHeight / 2)
            local avatarTitleBaseTwo = cc.Sprite:create("home/top_player_info/second_avatar_selection/division_not_obtain.png")
            avatarTitleBaseTwo:setAnchorPoint(0.5, 0.5)
            avatarTitleBaseTwo:setPosition(sizeSetBase.width / 2, itemHeight / 4)
            avatarTitleBaseTwo:addTo(colLayer)
        else
            local avatarList = ccui.ListView:create()
            avatarList:setAnchorPoint(0.5, 0.5)
            avatarList:setPosition(sizeSetBase.width / 2, itemHeight / 2)
            avatarList:setContentSize(sizeSetBase.width * 4 / 5, itemHeight)
            avatarList:setDirection(2) -- 水平
            avatarList:addTo(colLayer)
            --avatarList:setBackGroundColor(cc.c3b(255, math.random(0, 255), 255))
            --avatarList:setBackGroundColorType(1)
            for j = 1, 4 do
                local rowLayer = ccui.Layout:create()
                rowLayer:setContentSize(itemWidth, itemHeight)
                rowLayer:addTo(avatarList)

                if avatarNum <= #avatarObtain then
                    local tower = avatarObtain[avatarNum]
                    if tower == nil then
                        Log.i("obtaon tower is empty")
                    else
                        local avatarButton = ccui.Button:create(ConstDef.ICON_TOWER_LIST[tower])
                        avatarButton:setAnchorPoint(0.5, 0.5)
                        avatarButton:setPosition(itemWidth / 2, itemHeight / 2)
                        avatarButton:addTo(rowLayer)
                        avatarNum = avatarNum + 1
                        avatarButton:addTouchEventListener(function(sender, eventType)
                            if 2 == eventType then
                                -- 更换头像展示
                                local img = cc.Sprite:create(ConstDef.ICON_TOWER_LIST[tower]):getSpriteFrame()
                                avatarCur:setSpriteFrame(img)
                                curAvatarID = tower
                                --OutGameData:getUserInfo():setAvatar(ConstDef.ICON_TOWER_LIST[tower])
                            end
                        end)
                    end
                elseif avatarNum == #avatarObtain + 1 then
                    iNotObtain = i + 1
                    avatarNum = avatarNum + 1
                    break
                else
                    local num = avatarNum - #avatarObtain - 1
                    Log.i("num:", num)
                    local tower = avatarNotObtain[num]
                    if tower == nil then
                        Log.i("not obtain tower is empty")
                    else
                        local avatarButton = ccui.Button:create(ConstDef.ICON_TOWER_GREY_LIST[tower])
                        avatarButton:setAnchorPoint(0.5, 0.5)
                        avatarButton:setPosition(itemWidth / 2, itemHeight / 2)
                        avatarButton:addTo(rowLayer)
                        avatarNum = avatarNum + 1
                    end
                end
            end
        end
    end
end

return MenuView
