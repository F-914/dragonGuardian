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
local Log = require("app.utils.Log")
local TowerArrayDef = require("app.def.TowerArrayDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local BossMessage2nd = require("app.ui.inGameSecondaryui.BossMessage2nd")
local EnemyTowerInfo2nd = require("app.ui.inGameSecondaryui.EnemyTowerInfo2nd")
local spBuildTTF    --生成所需能量
local spNumTTF      --当前拥有能量
local scheduler = cc.Director:getInstance():getScheduler() --路径
local timeSchedule = nil
--

function InGameUpLayer:ctor()
    self.playerLive_ = {}
    self.enemyLife_ = {}
    self:init()
    self:onEnter()

    --测试敌方塔生成
    local testButton = ccui.Button:create("battle_in_game/battle_view/elite_enemy.png")
    testButton:setAnchorPoint(0.5, 0.5)
    testButton:setPosition(display.cx/4, display.cy*16/15)
    testButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            if not InGameData:enemyMerge() then
                local sp = InGameData:getSpEnemy()
                local spCost = InGameData:getSpCreateEnemyTower()
                if sp >= spCost then
                    InGameData:createEnemyCard(1)   --默认生成一级塔
                    local changeSp = InGameData:getSpCreateEnemyTower()
                    InGameData:changeSpEnemy(-changeSp)
                    InGameData:changeSpCreateEnemyTower(10)
                end
            end
        end
    end)
    self:addChild(testButton, 5)
end

--[[--
    定时器敌人塔自动操作
]]
function InGameUpLayer:autoEnemyTower()
    timeSchedule = scheduler:scheduleScriptFunc(function(dt)
        if InGameData:getGameState() == ConstDef.GAME_STATE.PLAY then
            if not InGameData:enemyMerge() then
                local sp = InGameData:getSpEnemy()
                local spCost = InGameData:getSpCreateEnemyTower()
                if sp >= spCost then
                    InGameData:createEnemyCard(1)   --默认生成一级塔
                    local changeSp = InGameData:getSpCreateEnemyTower()
                    InGameData:changeSpEnemy(-changeSp)
                    InGameData:changeSpCreateEnemyTower(10)
                end
            end
        end
    end, 2, false)
end

--[[--
    停止定时器敌人塔自动操作
]]
function InGameUpLayer:stopAutoEnemyTower()
    scheduler:unscheduleScriptEntry(timeSchedule)
end

--[[--
    初始化
]]
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
            local sp = InGameData:getSp()
            local spCost = InGameData:getSpCreateTower()
            if sp >= spCost then
                InGameData:createCard(1)    --默认生成等级为1的塔--更新sp
                local changeSp = InGameData:getSpCreateTower()
                InGameData:changeSp(-changeSp)
                InGameData:changeSpCreateTower(10)
                self:refreshSp()
            end
        end
    end)
    buildButton:addTo(self)

    spBuildTTF = display.newTTFLabel({
        text = InGameData:getSpCreateTower(),
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

    spNumTTF = display.newTTFLabel({
        text = InGameData:getSp(),
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
    local playerLifeLeft = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    playerLifeLeft:setAnchorPoint(0.5, 0.5)
    playerLifeLeft:setPosition(display.width*14/17, display.cy + display.cy/19)
    playerLifeLeft:addTo(self)
    self.playerLive_[#self.playerLive_+1] = {
        SPRITE = playerLifeLeft,
        IS_VISIABLE = true
    }

    local playerLifeMid = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    playerLifeMid:setAnchorPoint(0.5, 0.5)
    playerLifeMid:setPosition(display.width*15/17, display.cy + display.cy/19)
    playerLifeMid:addTo(self)
    self.playerLive_[#self.playerLive_+1] = {
        SPRITE = playerLifeMid,
        IS_VISIABLE = true
    }

    local playerLifeRight = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    playerLifeRight:setAnchorPoint(0.5, 0.5)
    playerLifeRight:setPosition(display.width*16/17, display.cy + display.cy/19)
    playerLifeRight:addTo(self)
    self.playerLive_[#self.playerLive_+1] = {
        SPRITE = playerLifeRight,
        IS_VISIABLE = true
    }

    -- 敌方生命
    local enemyLifeRight = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    enemyLifeRight:setAnchorPoint(0.5, 0.5)
    enemyLifeRight:setPosition(display.width*3/17, display.cy + display.cy*2/13)
    enemyLifeRight:addTo(self)
    self.enemyLife_[#self.enemyLife_+1] = {
        SPRITE = enemyLifeRight,
        IS_VISIABLE = true
    }

    local enemyLifeMid = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    enemyLifeMid:setAnchorPoint(0.5, 0.5)
    enemyLifeMid:setPosition(display.width*2/17, display.cy + display.cy*2/13)
    enemyLifeMid:addTo(self)
    self.enemyLife_[#self.enemyLife_+1] = {
        SPRITE = enemyLifeMid,
        IS_VISIABLE = true
    }

    local enemyLifeLeft = cc.Sprite:create("battle_in_game/battle_view/hp_full.png")
    enemyLifeLeft:setAnchorPoint(0.5, 0.5)
    enemyLifeLeft:setPosition(display.width*1/17, display.cy + display.cy*2/13)
    enemyLifeLeft:addTo(self)
    self.enemyLife_[#self.enemyLife_+1] = {
        SPRITE = enemyLifeLeft,
        IS_VISIABLE = true
    }

    -- 认输按钮
    -- 测试阶段点击暂停，实际上是不会暂停的
    local giveUpButton = ccui.Button:create("battle_in_game/battle_view/button_give_up.png")
    giveUpButton:setAnchorPoint(0.5, 0.5)
    giveUpButton:setPosition(display.width*17/20, display.cy + display.cy/8)
    giveUpButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
            -- InGameDownLayer:stopCreateEnemy()
            -- local popup = GiveUp2nd.new()
            -- popup:addTo(self)
            InGameData:setGameState(ConstDef.GAME_STATE.PAUSE)
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
    for j = 1,5 do
        local layer = ccui.Layout:create()
        layer:setContentSize(itemWidth, itemHeight)
        layer:addTo(listView)

        local towerButton = ccui.Button:create("battle_in_game/battle_view/tower/tower_"..TowerArrayDef[j].ID..".png")
        towerButton:setAnchorPoint(0.5, 1)
        towerButton:setPosition(itemWidth/2, itemHeight*19/20)
        local sizeTowerButton = towerButton:getContentSize()
        towerButton:addTouchEventListener(function(sender, eventType)
            if 2 == eventType then
                --塔强化
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
            text = TowerArrayDef[j].SP,
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
    for j = 1,5 do
        local layer = ccui.Layout:create()
        layer:setContentSize(itemWidth, itemHeight)
        layer:addTo(listView)

        local towerButton = ccui.Button:create("battle_in_game/battle_view/tower/tower_"..(j+3)..".png")
        towerButton:setAnchorPoint(0.5, 1)
        towerButton:setPosition(itemWidth/2, itemHeight*19/20)
        towerButton:scale(0.6)
        local sizeTowerButton = towerButton:getContentSize()
        towerButton:addTouchEventListener(function(sender, eventType)
            if 2 == eventType then
                local enemyTowerInfo = EnemyTowerInfo2nd.new(j)
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

--[[--
    更新sp数值显示
]]
function InGameUpLayer:refreshSp()
    spBuildTTF:setString(InGameData:getSpCreateTower())
    spNumTTF:setString(InGameData:getSp())
end

--[[--
    节点进入

    @param none

    @return none
]]
function InGameUpLayer:onEnter()
    EventManager:regListener(EventDef.ID.HURT_PLAYER, self, function(hurt)
        print("hurt", hurt)
        for i = 1, hurt do
            for j = 1,3 do
                if self.playerLive_[j].IS_VISIABLE then
                    self.playerLive_[j].SPRITE:setVisible(false)
                    self.playerLive_[j].IS_VISIABLE = false
                    if j==3 then
                        print("游戏结束1")
                        InGameData:setGameState(ConstDef.GAME_STATE.RESULT)
                    end
                    break
                end
            end
        end
    end)

    EventManager:regListener(EventDef.ID.HURT_ENEMY, self, function(hurt)
        print("hurt", hurt)
        for i = 1, hurt do
            for j = 1,3 do
                if self.enemyLife_[j].IS_VISIABLE then
                    self.enemyLife_[j].SPRITE:setVisible(false)
                    self.enemyLife_[j].IS_VISIABLE = false
                    if j==3 then
                        print("游戏结束1")
                        InGameData:setGameState(ConstDef.GAME_STATE.RESULT)
                    end
                    break
                end
            end
        end
    end)
end

--[[--
    节点退出

    @param none

    @return none
]]
function InGameUpLayer:onExit()
    EventManager:unRegListener(EventDef.ID.HURT_PLAYER, self)
    EventManager:unRegListener(EventDef.ID.HURT_ENEMY, self)
end

return InGameUpLayer