--[[--
    InGameTowerButton.lua

    描述：游戏内生成在格子中的塔图标按钮，每个塔包含右上角的等级标识
]]
--[[--
    游戏内塔按键
    InGameTowerButton
]]
local InGameTowerButton = class("InGameTowerButton", function(res)
    return display.newSprite()
end)

--local
local TowerArrayDef = require("app.def.TowerArrayDef")
local GirdLocation = require("app.def.GirdLocation")
local Log = require("app.utils.Log")
local towerTypeSprite
local sizeTowerButton

function InGameTowerButton:ctor(type)   -- 塔属于我方type=1，还是对方type=2
    if type == 1 then
        self.numPlayer_ = math.random(1, 5)   -- 生成第几个塔
        self:buildPlayerTower(self.numPlayer_)
        self:touchMove()    -- 敌方塔不可移动
    elseif type == 2 then
        self.numEnemy_ = math.random(1, 5)
        self:buildEnemyTower(self.numEnemy_)
    else
        Log.w("The parameter range is 1(player) or 2(enemy)")
    end
end

--[[--
    描述：初始化创建塔
]]
function InGameTowerButton:buildPlayerTower(num)
    local towerButton = ccui.Button:create(TowerArrayDef[num].ICON_PATH)
    towerButton:setAnchorPoint(0, 0)
    towerButton:setPosition(0, 0)
    towerButton:scale(0.85)
    sizeTowerButton = towerButton:getContentSize()
    towerButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
        end
    end)
    towerButton:setSwallowTouches(false)    --不吞噬下层触摸事件

    self:setAnchorPoint(0.5, 0.5)
    self:setContentSize(sizeTowerButton.width*0.85, sizeTowerButton.height*0.85)

    towerTypeSprite = cc.Sprite:create("battle_in_game/battle_view/subscript_level/1.png")
    towerTypeSprite:setAnchorPoint(1,1)
    --towerTypeSprite:scale(0.6)
    towerTypeSprite:setPosition(sizeTowerButton.width*0.85, sizeTowerButton.height*0.85)

    --随机位置
    local x = math.random(1, 3)
    local y = math.random(1, 5)
    Log.i("x,y "..x.." "..y)
    if GirdLocation.PLAYER[x][y].IS_USED == false then
        Log.i("build tower accept")
        self:setPlayerLocate(towerButton, x, y)
        GirdLocation.PLAYER[x][y].IS_USED = true
    else
        -- 若检测到一个已使用位置，遍历判断位置是否已满
        local isFull = true
        for i,v in pairs(GirdLocation.PLAYER) do
            for j,w in pairs(v) do
                if w.IS_USED == false then
                    isFull = false
                    x = i
                    y = j
                    Log.i("build tower accept")
                    self:setPlayerLocate(towerButton, x, y)
                    GirdLocation.PLAYER[x][y].IS_USED = true
                    break
                end
            end
            if isFull == false then
                break
            end
        end
        if isFull then
            Log.i("Tower gird is full")
        end
    end
end

--[[--
    描述：设定生成玩家塔位置
]]
function InGameTowerButton:setPlayerLocate(node, x, y)
    self.nodeX_ = GirdLocation.PLAYER[x][y].X
    self.nodeY_ = GirdLocation.PLAYER[x][y].Y
    self:setPosition(self.nodeX_, self.nodeY_)
    node:addTo(self)
    towerTypeSprite:addTo(self)
end

--------------------------------------------------------------------------------------------
--[[--
    描述：初始化创建敌人塔
]]
function InGameTowerButton:buildEnemyTower(num)
    local towerButton = ccui.Button:create(TowerArrayDef[num].ICON_PATH)
    towerButton:setAnchorPoint(0, 0)
    towerButton:setPosition(0, 0)
    towerButton:scale(0.85)
    sizeTowerButton = towerButton:getContentSize()
    towerButton:addTouchEventListener(function(sender, eventType)
        if 2 == eventType then
        end
    end)
    towerButton:setSwallowTouches(false)    --不吞噬下层触摸事件
    towerButton:setTouchEnabled(false)      --敌方塔不可交互

    self:setAnchorPoint(0.5, 0.5)
    self:setContentSize(sizeTowerButton.width*0.85, sizeTowerButton.height*0.85)

    towerTypeSprite = cc.Sprite:create("battle_in_game/battle_view/subscript_level/1.png")
    towerTypeSprite:setAnchorPoint(1,1)
    towerTypeSprite:setPosition(sizeTowerButton.width*0.85, sizeTowerButton.height*0.85)

    --随机位置
    local x = math.random(1, 3)
    local y = math.random(1, 5)
    Log.i("x,y "..x.." "..y)
    if GirdLocation.ENEMY[x][y].IS_USED == false then
        Log.i("build tower accept")
        self:setEnemyLocate(towerButton, x, y)
        GirdLocation.ENEMY[x][y].IS_USED = true
    else
        -- 若检测到一个已使用位置，遍历判断位置是否已满
        local isFull = true
        for i,v in pairs(GirdLocation.ENEMY) do
            for j,w in pairs(v) do
                if w.IS_USED == false then
                    isFull = false
                    x = i
                    y = j
                    Log.i("build tower accept")
                    self:setEnemyLocate(towerButton, x, y)
                    GirdLocation.ENEMY[x][y].IS_USED = true
                    break
                end
            end
            if isFull == false then
                break
            end
        end
        if isFull then
            Log.i("Tower gird is full")
        end
    end
end

--[[--
    描述：设定生成敌人塔位置
]]
function InGameTowerButton:setEnemyLocate(node, x, y)
    self.nodeX_ = GirdLocation.ENEMY[x][y].X
    self.nodeY_ = GirdLocation.ENEMY[x][y].Y
    self:setPosition(self.nodeX_, self.nodeY_)
    node:addTo(self)
    towerTypeSprite:addTo(self)
end

------------------------------------------------------------------------------------------------
--[[--
    描述：拖动按钮触摸事件
]]
function InGameTowerButton:touchMove()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        dump(event)
        if event.name == "began" then
            print("touch")
            return true
        elseif event.name == "moved" then
            print("move")
            local curX = event.prevX
            local curY = event.prevY
            self:setPosition(curX, curY)
        elseif event.name == "ended" then
            print("ended")
            self:setPosition(self.nodeX_, self.nodeY_)
        end
    end)
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
end

return InGameTowerButton