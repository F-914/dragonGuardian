--[[--
    InGameBattleView.lua

    描述：游戏内战斗界面，分两层：底层背景、敌人--> 上层背景、顶部UI、格子中的塔
]]
local InGameBattleView = class("InGameBattleView", function()
    return display.newColorLayer(cc.c4b(0, 0, 0, 0))
end)

--local
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local InGameData = require("app.data.InGameData")
local EventManager = require("app.manager.EventManager")
local SoundManager = require("app.manager.SoundManager")
local InGameDownLayer = require("app.ui.layer.InGameDownLayer")
local InGameUpLayer = require("app.ui.layer.InGameUpLayer")
local GiveUp2nd = require("app.ui.inGameSecondaryui.GiveUp2nd")
local BossSelect2nd = require("app.ui.inGameSecondaryui.BossSelect2nd")
local InGameSettle2nd = require("app.ui.secondaryui.InGameSettle2nd")

function InGameBattleView:ctor()
    self.inGameDownLayer_ = nil -- type:layer，游戏内UI第二层
    self.inGameUpLayer_ = nil -- type:layer，游戏内UI第一层
    self.bossSelect2nd_ = nil -- type:layer，进入游戏的随机Boss弹窗
    self:init()
end

function InGameBattleView:init()
    local boss = math.random(1, 4)
    print("随机boss：", boss)
    InGameData:setCurBoss(boss)

    self.inGameDownLayer_ = InGameDownLayer.new()
    self:addChild(self.inGameDownLayer_, 0)
    self.inGameUpLayer_ = InGameUpLayer.new()
    self:addChild(self.inGameUpLayer_, 1)

    self.bossSelect2nd_ = BossSelect2nd.new(boss)
    self:addChild(self.bossSelect2nd_, 2)

    self.giveup2nd_ = GiveUp2nd.new()
    self:addChild(self.giveup2nd_, 3)
    self.giveup2nd_:setVisible(false)

    self.inGameSettle2nd_ = InGameSettle2nd.new(true)
    self:addChild(self.inGameSettle2nd_, 4)
    self.inGameSettle2nd_:setVisible(false)

    self:onEnter()
    InGameUpLayer:autoEnemyTower()
end

--[[--
    节点进入

    @param none

    @return none
]]
function InGameBattleView:onEnter()
    EventManager:regListener(EventDef.ID.GAMESTATE_CHANGE, self, function(state)
        if state == ConstDef.GAME_STATE.PLAY then
            --self.inGameDownLayer_:createEnemy()
            print("进入背景音乐")
            SoundManager:playGameBGM()
            self.giveup2nd_:setVisible(false)
        elseif state == ConstDef.GAME_STATE.PAUSE then
            self.giveup2nd_:setVisible(true)
        elseif state == ConstDef.GAME_STATE.RESULT then
            --游戏结束才删除自动生成敌人塔的计时器
            InGameUpLayer:stopAutoEnemyTower()
            SoundManager:stopPlayGameBGM()
            print("游戏结束，弹出结算页面")
            self.inGameSettle2nd_:setVisible(true)
        end
    end)
end

--[[--
    节点退出

    @param none

    @return none
]]
function InGameBattleView:onExit()
    EventManager:unRegListener(EventDef.ID.GAMESTATE_CHANGE, self)
end

--[[--
    帧刷新

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function InGameBattleView:update(dt)
    self.inGameDownLayer_:update(dt)
end

return InGameBattleView
