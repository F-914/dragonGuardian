--[[--
    游戏内第一层，包括顶部背景及顶部UI
    InGameUPLayer.lua
]]
local InGameUpLayer = class("InGameUpLayer", function()
    return display.newLayer()
end)

--local
local ConstDef = require("app.def.ConstDef")
local InGameData = require("app.data.InGameData")
local  Log = require("app.utils.Log")
local TowerArrayDef = require("app.def.TowerArrayDef")
local InGameDownLayer = require("app.ui.layer.InGameDownLayer")
local InGameTowerButton = require("app.ui.node.InGameTowerButton")
local BossMessage2nd = require("app.ui.inGameSecondaryui.BossMessage2nd")
local GiveUp2nd = require("app.ui.inGameSecondaryui.GiveUp2nd")
local EnemyTowerInfo2nd = require("app.ui.inGameSecondaryui.EnemyTowerInfo2nd")
--

function InGameUpLayer:ctor()
    self:init()
end

function InGameUpLayer:init()
    local basemapUp = cc.Sprite:create("battle_in_game/battle_view/basemap_up.png")
    basemapUp:setAnchorPoint(0.5, 0.5)
    basemapUp:setPosition(display.cx, display.cy)
    basemapUp:addTo(self)

    -- 生成按钮
    local buildButton = ccui.Button:create("battle_in_game/battle_view/button_generate.png")
    buildButton:setAnchorPoint(0.5, 0.5)
    buildButton:setPosition(display.cx, display.cy/4 + display.cy/20)
    buildButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            print("生成塔")
            local tower = InGameTowerButton.new(1)
            tower:addTo(self)
        end
    end)
    buildButton:addTo(self)

    local spBuildTTF = display.newTTFLabel({
        text = "40",
        font = "font/fzhzgbjw.ttf",
        size = 24
    })
    spBuildTTF:align(display.CENTER, display.cx, display.cy/4 - display.cy/60)
    spBuildTTF:setColor(cc.c3b(255,255,255))
    spBuildTTF:enableOutline(cc.c4b(0,0,0,255), 1)
    spBuildTTF:addTo(self)

    -- SP点数
    local spBase = cc.Sprite:create("battle_in_game/battle_view/basemap_sp.png")
    spBase:setAnchorPoint(0.5, 0.5)
    spBase:setPosition(display.width/4, display.cy/4 + display.cy/20)
    spBase:addTo(self)

    local spNumTTF = display.newTTFLabel({
        text = "310",
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    spNumTTF:align(display.CENTER, display.width/4 + display.cx/20, display.cy/4 + display.cy/21)
    spNumTTF:setColor(cc.c3b(255,255,255))
    spNumTTF:enableOutline(cc.c4b(0,0,0,255), 1)
    spNumTTF:addTo(self)

    -- 我方标识
    local tagPlayer = cc.Sprite:create("battle_in_game/battle_view/friend_tag.png")
    tagPlayer:setAnchorPoint(0.5, 0.5)
    tagPlayer:setPosition(display.width*3/4, display.cy/4 + display.cy/15)
    tagPlayer:addTo(self)

    local tagPlayerTTF = display.newTTFLabel({
        text = "me",
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    tagPlayerTTF:align(display.CENTER, display.width*3/4, display.cy/4)
    tagPlayerTTF:setColor(cc.c3b(255,255,255))
    tagPlayerTTF:enableOutline(cc.c4b(0,0,0,255), 1)
    tagPlayerTTF:addTo(self)

    -- 敌方标识
    local tagEnemy = cc.Sprite:create("battle_in_game/battle_view/enemy_tag.png")
    tagEnemy:setAnchorPoint(0.5, 0.5)
    tagEnemy:setPosition(display.width/4, display.height-display.cy/12)
    tagEnemy:addTo(self)

    local tagPlayerTTF = display.newTTFLabel({
        text = "robot",
        font = "font/fzbiaozjw.ttf",
        size = 24
    })
    tagPlayerTTF:align(display.CENTER, display.width/4, display.height-display.cy*2/13)
    tagPlayerTTF:setColor(cc.c3b(255,255,255))
    tagPlayerTTF:enableOutline(cc.c4b(0,0,0,255), 1)
    tagPlayerTTF:addTo(self)

    -- 我方生命
    local playerLifeOne = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    playerLifeOne:setAnchorPoint(0.5, 0.5)
    playerLifeOne:setPosition(display.width*16/17, display.cy + display.cy/19)
    playerLifeOne:addTo(self)

    local playerLifeTwo = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    playerLifeTwo:setAnchorPoint(0.5, 0.5)
    playerLifeTwo:setPosition(display.width*15/17, display.cy + display.cy/19)
    playerLifeTwo:addTo(self)

    local playerLifeThree = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    playerLifeThree:setAnchorPoint(0.5, 0.5)
    playerLifeThree:setPosition(display.width*14/17, display.cy + display.cy/19)
    playerLifeThree:addTo(self)

    -- 敌方生命
    local enemyLifeOne = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    enemyLifeOne:setAnchorPoint(0.5, 0.5)
    enemyLifeOne:setPosition(display.width*1/17, display.cy + display.cy*2/13)
    enemyLifeOne:addTo(self)

    local enemyLifeTwo = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    enemyLifeTwo:setAnchorPoint(0.5, 0.5)
    enemyLifeTwo:setPosition(display.width*2/17, display.cy + display.cy*2/13)
    enemyLifeTwo:addTo(self)

    local enemyLifeThree = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    enemyLifeThree:setAnchorPoint(0.5, 0.5)
    enemyLifeThree:setPosition(display.width*3/17, display.cy + display.cy*2/13)
    enemyLifeThree:addTo(self)

    -- 认输按钮
    local giveUpButton = ccui.Button:create("battle_in_game/battle_view/button_give_up.png")
    giveUpButton:setAnchorPoint(0.5, 0.5)
    giveUpButton:setPosition(display.width*17/20, display.cy + display.cy/8)
    giveUpButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            -- InGameDownLayer:stopCreateEnemy()
            -- local popup = GiveUp2nd.new()
            -- popup:addTo(self)
            print("游戏状态：",InGameData:getGameState())
            InGameData:setGameState(ConstDef.GAME_STATE.PAUSE)
            print("游戏状态：",InGameData:getGameState())
        end
    end)
    giveUpButton:addTo(self)

    -- 倒计时
    local timeCountDownTTF = display.newTTFLabel({
        text = "剩余时间 ".."01:11",
        font = "font/fzbiaozjw.ttf",
        size = 30
    })
    timeCountDownTTF:align(display.CENTER, display.cx*41/40, display.cy + display.cy*2/15)
    timeCountDownTTF:setColor(cc.c3b(255,255,255))
    timeCountDownTTF:enableOutline(cc.c4b(0,0,0,255), 1)
    timeCountDownTTF:addTo(self)

    -- Boss图标按钮（点击显示boss介绍）
    local bossButton = ccui.Button:create("battle_in_game/battle_view/button-boss/boss-4.png")
    bossButton:setAnchorPoint(0.5, 0.5)
    bossButton:setPosition(display.cx*5/8, display.cy + display.cy*2/15)
    bossButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            Log.i("boss info 2nd")
            local boss = BossMessage2nd:new()
            boss:addTo(self)
        end
    end)
    bossButton:addTo(self)

    self:playerArray()
    self:enemyArray()
end

--[[--
    描述：我方塔阵容按钮（点击强化对应塔）
]]
function InGameUpLayer:playerArray()
    local itemWidth, itemHeight = display.cx/3, display.cy/5
    local listView = ccui.ListView:create()
    listView:setAnchorPoint(0.5, 0.5)
    listView:setPosition(display.cx, display.cy*2/17)
    listView:setContentSize(itemWidth*5, itemHeight)
    listView:setDirection(2)    -- 1垂直，2水平
    --listView:setBackGroundColor(cc.c3b(200,200,255))
    --listView:setBackGroundColorType(1)
    listView:addTo(self)
    for i = 1,5 do
        local layer = ccui.Layout:create()
        layer:setContentSize(itemWidth, itemHeight)
        layer:addTo(listView)

        local towerButton = ccui.Button:create("battle_in_game/battle_view/tower/tower_"..TowerArrayDef[i].ID..".png")
        towerButton:setAnchorPoint(0.5, 1)
        towerButton:setPosition(itemWidth/2, itemHeight*19/20)
        local sizeTowerButton = towerButton:getContentSize()
        towerButton:addTouchEventListener(function(sender, eventType)
            if 2 == eventType then
                
            end
        end)
        towerButton:addTo(layer)

        local levelSprite = cc.Sprite:create("battle_in_game/battle_view/level/LV.1.png")
        levelSprite:setAnchorPoint(0.5, 0)
        levelSprite:setPosition(itemWidth/2, 0)
        levelSprite:addTo(layer)

        local towerTypeSprite = cc.Sprite:create("battle_in_game/battle_view/subscript_tower_type/atk.png")
        towerTypeSprite:setAnchorPoint(1,1)
        towerTypeSprite:setPosition(itemWidth/2 + sizeTowerButton.width/2, itemHeight*19/20)
        towerTypeSprite:addTo(layer)

        -- SP点数
        local spBase = cc.Sprite:create("battle_in_game/battle_view/basemap_sp.png")
        spBase:setAnchorPoint(0.5, 0.5)
        spBase:setPosition(itemWidth/2, itemHeight*2/7)
        spBase:scale(0.8)
        spBase:addTo(layer)

        local spTTF = display.newTTFLabel({
            text = TowerArrayDef[i].SP,
            font = "font/fzbiaozjw.ttf",
            size = 20
        })
        spTTF:align(display.CENTER, itemWidth*3/5, itemHeight*2/7)
        spTTF:setColor(cc.c3b(255,255,255))
        spTTF:enableOutline(cc.c4b(0,0,0,255), 1)
        spTTF:addTo(layer)

    end
end

--[[--
    描述：敌方塔阵容按钮（点击弹出对方塔信息弹窗）
]]
function InGameUpLayer:enemyArray()
    local itemWidth, itemHeight = display.cx/5, display.cy*2/15
    local listView = ccui.ListView:create()
    listView:setAnchorPoint(0.5, 0.5)
    listView:setPosition(display.width*10/18, display.height*19/20)
    listView:setContentSize(itemWidth*5, itemHeight)
    listView:setDirection(2)    -- 1垂直，2水平
    --listView:setBackGroundColor(cc.c3b(200,200,255))
    --listView:setBackGroundColorType(1)
    listView:addTo(self)
    for i = 1,5 do
        local layer = ccui.Layout:create()
        layer:setContentSize(itemWidth, itemHeight)
        layer:addTo(listView)

        local towerButton = ccui.Button:create("battle_in_game/battle_view/tower/tower_"..(i+3)..".png")
        towerButton:setAnchorPoint(0.5, 1)
        towerButton:setPosition(itemWidth/2, itemHeight*19/20)
        towerButton:scale(0.6)
        local sizeTowerButton = towerButton:getContentSize()
        towerButton:addTouchEventListener(function(sender, eventType)
            if 2 == eventType then
                local enemyTowerInfo = EnemyTowerInfo2nd.new(i)
                enemyTowerInfo:addTo(self)
            end
        end)
        towerButton:addTo(layer)

        local levelSprite = cc.Sprite:create("battle_in_game/battle_view/level/LV.1.png")
        levelSprite:setAnchorPoint(0.5, 0)
        levelSprite:setPosition(itemWidth/2, 0)
        levelSprite:scale(0.8)
        levelSprite:addTo(layer)

        local towerTypeSprite = cc.Sprite:create("battle_in_game/battle_view/subscript_tower_type/atk.png")
        towerTypeSprite:setAnchorPoint(1,1)
        towerTypeSprite:setPosition(itemWidth/2 + sizeTowerButton.width/2*0.6, itemHeight*19/20)
        towerTypeSprite:scale(0.6)
        towerTypeSprite:addTo(layer)

    end
end

return InGameUpLayer