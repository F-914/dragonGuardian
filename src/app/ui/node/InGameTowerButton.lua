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
local InGameData = require("app.data.InGameData")
local TowerArrayDef = require("app.def.TowerArrayDef")
local GirdLocation = require("app.def.GirdLocation")
local Log = require("app.utils.Log")
local towerTypeSprite
local sizeTowerButton

function InGameTowerButton:ctor(type, data, cardId)   -- 塔属于我方type=1，还是对方type=2
    self.data_ = data   --联系InGameData中的数据（还未使用）
    self.data_.cardId_ = cardId

    self:initNum(cardId)   -- 生成第几个塔(队内序号)
    self:buildPlayerTower(self.num_)

    if type == 1 then
        self:touchMove()    -- 我方塔可移动，敌方塔不可移动
    end
end

--[[--
    描述：返回当前塔编号

    @param type     --number，1：我方塔，2：对方塔
]]
function InGameTowerButton:getCardId(type)
    if type == 1 then
        return self.data_.cardId_
    elseif type == 2 then
        return self.data_.cardId_
    end
end

--[[--
    初始化当前塔队内序号
]]
function InGameTowerButton:initNum(id)
    for i = 1,5 do
        if TowerArrayDef[i].ID == id then
            self.num_ = i
        end
    end
end

--[[--
    描述：初始化创建塔

    @param number 塔编号

    @return none
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

    towerTypeSprite = cc.Sprite:create("battle_in_game/battle_view/subscript_level/"..self.data_:getCardLevel()..".png")
    towerTypeSprite:setAnchorPoint(1,1)
    --towerTypeSprite:scale(0.6)
    towerTypeSprite:setPosition(sizeTowerButton.width*0.85, sizeTowerButton.height*0.85)

    self:setLocate(towerButton, self.data_:getMyX(), self.data_:getMyY())

end

--[[--
    描述：设定生成塔位置

    @param node 塔节点
    @param number 生成x位置
    @param number 生成y位置

    @return none
]]
function InGameTowerButton:setLocate(node, x, y)
    self.nodeX_ = x
    self.nodeY_ = y
    self:setPosition(self.nodeX_, self.nodeY_)
    node:addTo(self)
    towerTypeSprite:addTo(self)
end

--------------------------------------------------------------------------------------------
--[[--
    描述：初始化创建敌人塔
    好像随机生成放到InGameData里这里生成没有区别了，确定不需要后可删
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

    self:setLocate(towerButton, self.data_:getMyX(), self.data_:getMyY())

end

------------------------------------------------------------------------------------------------
--[[--
    描述：拖动按钮触摸事件
]]
function InGameTowerButton:touchMove()
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        --dump(event)
        local curX,curY
        if event.name == "began" then
            Log.i("touch")
            return true
        elseif event.name == "moved" then
            self:getParent():reorderChild(self,4)
            Log.i("move")
            curX = event.prevX
            curY = event.prevY
            self:setPosition(curX, curY)
        elseif event.name == "ended" then
            Log.i("ended")
            curX = event.prevX
            curY = event.prevY
            print("curx, cury", curX, curY)
            --判断移动结束位置是否有同类塔，有则合并没有归位
            if InGameData:isMergeCard(self.data_, curX ,curY) then
                Log.i("合并塔，消除当前塔图标")
                --self:mergeCard()
            else
                self:setPosition(self.nodeX_, self.nodeY_)
                self:getParent():reorderChild(self,3)
            end
        end
    end)
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
end

--[[--
    根据位置判断是否可以合并（图标部分）
]]
function InGameTowerButton:mergeCard()
    Log.i("合并塔，消除当前塔图标")
end

return InGameTowerButton