local MenuScene = class("MenuScene", function()
    return display.newScene("MenuScene")
end)


function MenuScene:ctor(layer)
    self:loadMusic()
    local menuTop = self:createMenuTop()
    local menuBottom = self:createMenuBottom()
    menuTop:addTo(layer, 1)
    menuBottom:addTo(layer, 1)
end

--[[--
    描述：音乐音效加载

    @param none

    @return none
]]
local audio = require"framework.audio"
function MenuScene:loadMusic()
    audio.loadFile("sound_ogg/ui_btn_click.ogg",function (dt) end)
end

--[[--
    描述：创建顶部栏

    @param none

    @return layer
]]
function MenuScene:createMenuTop()
    -- 顶部栏
    local menuTopLayer = ccui.Layout:create()   -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    menuTopLayer:setPosition(display.width/2, display.height/2)
    menuTopLayer:setAnchorPoint(0.5, 0.5)
    menuTopLayer:setContentSize(display.width, display.height)

    local topBase = cc.Sprite:create("home/top_player_info/base_top.png")
    topBase:setAnchorPoint(0.5, 1)
    topBase:setPosition(display.cx, display.height)
    local sizeBase = topBase:getContentSize()
    topBase:addTo(menuTopLayer)

    -- 头像框按钮
    local avatarButton = ccui.Button:create("home/top_player_info/default_avatar.png")
    avatarButton:setAnchorPoint(0.5, 0.5)
    -- base的高度
    local baseHeight = sizeBase.height * display.width / sizeBase.width
    -- base中心高度
    local baseCY = display.height - baseHeight/2
    avatarButton:setPosition(display.cx/4, baseCY + 2)
    avatarButton:addTo(menuTopLayer, 1)
    avatarButton:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
        end
    end)

    -- 菜单按钮
    local menuButton = ccui.Button:create("home/top_player_info/button_menu.png")
    menuButton:setAnchorPoint(0.5, 0.5)
    menuButton:setPosition(display.cx*13/7, baseCY + 2)
    menuButton:addTo(menuTopLayer)
    menuButton:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
        end
    end)

    ----------------------------------------------------------------------------
    -- 玩家信息
    local nameBase = cc.Sprite:create("home/top_player_info/base_name.png")
    nameBase:setAnchorPoint(0.5, 0.5)
    nameBase:setPosition(display.width/3 + display.cx/13, baseCY+5)
    nameBase:addTo(menuTopLayer)
    local sizeNameBase = nameBase:getContentSize()

    local nameText = display.newTTFLabel({
        text = "玩家昵称",
        font = "font/fzzchjw.ttf",
        size = 20
    })
    nameText:align(display.LEFT_CENTER, display.width*9/40, baseCY+2 + sizeNameBase.height/4)
    nameText:setColor(cc.c3b(255, 255, 255))
    nameText:addTo(menuTopLayer)

    local cupSprite = cc.Sprite:create("home/top_player_info/cup.png")
    cupSprite:setAnchorPoint(0, 0.5)
    cupSprite:setPosition(display.width*9/40, baseCY+6 - sizeNameBase.height/4)
    cupSprite:addTo(menuTopLayer)

    local scoreText = display.newTTFLabel({
        text = "100",
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    scoreText:align(display.LEFT_CENTER, display.width*23/80, baseCY+5 - sizeNameBase.height/4)
    scoreText:setColor(cc.c3b(255, 206, 55))
    scoreText:addTo(menuTopLayer)

    local coinBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    coinBase:setAnchorPoint(0, 1)
    coinBase:setPosition(display.cx*9/7, baseCY + sizeNameBase.height/2)
    coinBase:addTo(menuTopLayer)

    local coinSprite = cc.Sprite:create("home/top_player_info/coin.png")
    coinSprite:setAnchorPoint(0, 1)
    coinSprite:setPosition(display.cx*9/7 - display.cx/20, baseCY + sizeNameBase.height/2)
    coinSprite:addTo(menuTopLayer)

    local coinNum = display.newTTFLabel({
        text = "25165",
        font = "font/fzbiaozjw.ttf",
        size = 26
    })
    coinNum:align(display.RIGHT_TOP, display.cx*8/5 + display.cx/20, baseCY + sizeNameBase.height/2 - 5)
    coinNum:setColor(cc.c3b(255, 255, 255))
    coinNum:addTo(menuTopLayer)

    local diaBase = cc.Sprite:create("home/top_player_info/base_diamond_coins.png")
    diaBase:setAnchorPoint(0, 0)
    diaBase:setPosition(display.cx*9/7, baseCY - sizeNameBase.height/2)
    diaBase:addTo(menuTopLayer)

    local diaSprite = cc.Sprite:create("home/top_player_info/diamond.png")
    diaSprite:setAnchorPoint(0, 0)
    diaSprite:setPosition(display.cx*9/7 - display.cx/20, baseCY - sizeNameBase.height/2)
    diaSprite:addTo(menuTopLayer)

    local diaNum = display.newTTFLabel({
        text = "128645",
        font = "font/fzbiaozjw.ttf",
        size = 26
    })
    diaNum:align(display.RIGHT_BOTTOM, display.cx*8/5 + display.cx/20, baseCY - sizeNameBase.height/2 + 5)
    diaNum:setColor(cc.c3b(255, 255, 255))
    diaNum:addTo(menuTopLayer)

    return menuTopLayer
end

--[[--
    描述：创建底部栏

    @param none

    @return layer
]]
function MenuScene:createMenuBottom()
    local menuBottomLayer = ccui.Layout:create()   -- 菜单层
    --menuLayer:setBackGroundImage("home/shop/background_shop.png")
    menuBottomLayer:setPosition(display.width/2, display.height/2)
    menuBottomLayer:setAnchorPoint(0.5, 0.5)
    menuBottomLayer:setContentSize(display.width, display.height)

    -- 底部栏
    local sizeTab
    local tabBattle
    local tabShop
    local tabGuide
    local battleTitle, battleIcon
    local shopTitle, shopIcon
    local guideTitle, guideIcon

    local curPageSprite = cc.Sprite:create("home/bottom_tab_button/tab_selected.png")
    curPageSprite:setAnchorPoint(0.5, 0)
    curPageSprite:setPosition(display.cx, 0)
    sizeTab = curPageSprite:getContentSize()
    curPageSprite:scale(display.width/3/sizeTab.width)
    curPageSprite:addTo(menuBottomLayer, 1)

    ----------------------------------------------------------------------------
    -- 战斗tab
    tabBattle = ccui.Button:create("home/bottom_tab_button/tab_unselected_middle.png")
    tabBattle:setAnchorPoint(0.5, 0)
    tabBattle:setPosition(display.cx, 0)
    sizeTab = tabBattle:getContentSize()
    tabBattle:scale(display.width/3/sizeTab.width)
    tabBattle:setTouchEnabled(false)
    tabBattle:addTo(menuBottomLayer)

    battleIcon = cc.Sprite:create("home/bottom_tab_button/icon_battle.png")
    battleIcon:setAnchorPoint(0.5, 0.5)
    battleIcon:setPosition(display.cx, sizeTab.height/2 + sizeTab.height/5)
    battleIcon:addTo(menuBottomLayer, 2)

    battleTitle = cc.Sprite:create("home/bottom_tab_button/title_battle.png")
    battleTitle:setAnchorPoint(0.5, 1)
    battleTitle:setPosition(display.cx, sizeTab.height/3)
    battleTitle:addTo(menuBottomLayer, 2)
    battleTitle:setVisible(true)

    tabBattle:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            print("mid-battle")
            tabShop:setTouchEnabled(true)
            tabBattle:setTouchEnabled(false)
            tabGuide:setTouchEnabled(true)
            curPageSprite:runAction(cc.MoveTo:create(0.08, cc.p(display.cx,0)))
            battleIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab.height/2 + sizeTab.height/5)))
            battleTitle:setVisible(true)
            shopIcon:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab.width/2, sizeTab.height/2)))
            shopTitle:setVisible(false)
            guideIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab.width/2, sizeTab.height/2)))
            guideTitle:setVisible(false)
        end
    end)

    ----------------------------------------------------------------------------
    -- 商店tab
    tabShop = ccui.Button:create("home/bottom_tab_button/tab_unselected_left.png")
    tabShop:setAnchorPoint(0, 0)
    tabShop:setPosition(0, 0)
    sizeTab = tabShop:getContentSize()
    tabShop:scale(display.width/3/sizeTab.width)
    tabShop:addTo(menuBottomLayer)


    shopIcon = cc.Sprite:create("home/bottom_tab_button/icon_shop.png")
    shopIcon:setAnchorPoint(0.5, 0.5)
    shopIcon:setPosition(sizeTab.width/2, sizeTab.height/2)
    shopIcon:addTo(menuBottomLayer, 2)

    shopTitle = cc.Sprite:create("home/bottom_tab_button/title_shop.png")
    shopTitle:setAnchorPoint(0.5, 1)
    shopTitle:setPosition(sizeTab.width/2, sizeTab.height/3)
    shopTitle:addTo(menuBottomLayer, 2)
    shopTitle:setVisible(false)

    tabShop:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            print("left-shop")
            tabShop:setTouchEnabled(false)
            tabBattle:setTouchEnabled(true)
            tabGuide:setTouchEnabled(true)
            curPageSprite:runAction(cc.MoveTo:create(0.08, cc.p(display.cx/3,0)))
            battleIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab.height/2)))
            battleTitle:setVisible(false)
            shopIcon:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab.width/2, sizeTab.height/2 + sizeTab.height/5)))
            shopTitle:setVisible(true)
            guideIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab.width/2, sizeTab.height/2)))
            guideTitle:setVisible(false)
        end
    end)

    ----------------------------------------------------------------------------
    -- 图鉴tab
    tabGuide = ccui.Button:create("home/bottom_tab_button/tab_unselected_right.png")
    tabGuide:setAnchorPoint(1, 0)
    tabGuide:setPosition(display.width, 0)
    sizeTab = tabGuide:getContentSize()
    tabGuide:scale(display.width/3/sizeTab.width)
    tabGuide:addTo(menuBottomLayer)

    guideIcon = cc.Sprite:create("home/bottom_tab_button/icon_guide.png")
    guideIcon:setAnchorPoint(0.5, 0.5)
    guideIcon:setPosition(display.width - sizeTab.width/2, sizeTab.height/2)
    guideIcon:addTo(menuBottomLayer, 2)

    guideTitle = cc.Sprite:create("home/bottom_tab_button/title_guide.png")
    guideTitle:setAnchorPoint(0.5, 1)
    guideTitle:setPosition(display.width - sizeTab.width/2, sizeTab.height/3)
    guideTitle:addTo(menuBottomLayer, 2)
    guideTitle:setVisible(false)

    tabGuide:addTouchEventListener(function (sender, eventType)
        if 2 == eventType then
            audio.playEffect("sound_ogg/ui_btn_click.ogg")
            print("right-guide")
            tabShop:setTouchEnabled(true)
            tabBattle:setTouchEnabled(true)
            tabGuide:setTouchEnabled(false)
            curPageSprite:runAction(cc.MoveTo:create(0.08, cc.p(display.cx*5/3,0)))
            battleIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.cx, sizeTab.height/2)))
            battleTitle:setVisible(false)
            shopIcon:runAction(cc.MoveTo:create(0.08, cc.p(sizeTab.width/2, sizeTab.height/2)))
            shopTitle:setVisible(false)
            guideIcon:runAction(cc.MoveTo:create(0.08, cc.p(display.width - sizeTab.width/2, sizeTab.height/2 + sizeTab.height/5)))
            guideTitle:setVisible(true)
        end
    end)

    return menuBottomLayer
end

return MenuScene