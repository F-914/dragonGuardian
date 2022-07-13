--[[--
    InInGameData.lua
    游戏内数据
]]
local InGameData = {}
local Log = require("app.utils.Log")
local Bullet = require("app.data.Bullet")
local Enemy = require("app.data.Enemy")
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")

-- TODO 这里可能得存两份，一份自己的，一份敌人的
local cards_ = {}
local enemies_ = {}
local bullets_ = {}
local schedule = cc.Director:getInstance():getScheduler()	--计时器路径
local timeCreateEnemySchdule = nil  -- 敌人生成计时器
local littleEnemyNum = 5    -- 每五只小怪一只精英怪


local SHOOT_INTERVAL = 0.2 -- 类型：number，射击间隔

--[[--
    初始化数据

    @param none

    @return none
]]
function InGameData:init()
    self.life_ = 100 -- 类型：number，生命值
    self.score_ = 0 -- 类型：number，得分
    self.shoot_ = 0 -- 类型：number，开炮时间tick

    -- 类型：number，历史最高
    -- self.history_ = cc.UserDefault:getInstance():getIntegerForKey("history", 0)

    -- 类型：number，游戏状态
    self.gameState_ = ConstDef.GAME_STATE.INIT

end

--[[--
    获取生命值

    @param none

    @return number
]]
function InGameData:getLife()
    return self.life_
end

--[[--
    获取分数

    @param none

    @return number
]]
function InGameData:getScore()
    return self.score_
end

--[[--
    获取历史最高

    @param none

    @return number
]]
function InGameData:getHistory()
    return self.history_
end

--[[--
    获取所有子弹

    @param none

    @return table
]]
function InGameData:getBullets()
    return bullets_
end

--[[--
    是否游戏中

    @param none

    @return boolean
]]
function InGameData:isPlaying()
    return self.gameState_ == ConstDef.GAME_STATE.PLAY
end

--[[--
    设置游戏状态

    @param state 类型：number，游戏状态

    @return none
]]
function InGameData:setGameState(state)
    self.gameState_ = state
    EventManager:doEvent(EventDef.ID.GAMESTATE_CHANGE, state)
end

--[[--
    获取游戏状态

    @param none

    @return number
]]
function InGameData:getGameState()
    return self.gameState_
end

--[[--
    获取怪物信息

    @param none

    @return table
]]
function InGameData:getEnemies()
    return enemies_
end

--[[--
    帧刷新

    @param dt 类型：number，帧间隔，单位秒

    @return none
]]
function InGameData:update(dt)
    if self.gameState_ ~= ConstDef.GAME_STATE.PLAY then
        return
    end

    local destoryEnemys = {}

    for i = 1, #enemies_ do
        enemies_[i]:update(dt)
        if not enemies_[i]:isDeath() then
            --self:checkCollider(enemies_[i], bullets_, allies_)
        else
            destoryEnemys[#destoryEnemys + 1] = enemies_[i]
        end
    end

    self:shoot(dt)

    local destoryBullets = {}
    for i = 1, #bullets_ do
        local bullet = bullets_[i]
        bullet:update(dt)
        -- if bullet:isDeath() then
        --     destoryBullets[#destoryBullets + 1] = bullet
        -- end
    end

    -- for i = 1, #enemies_ do
    --     enemies_[i]:update(dt)
    --     if not enemies_[i]:isDeath() then
    --         self:checkCollider(enemies_[i], bullets_, allies_)
    --     else
    --         destoryPlanes[#destoryPlanes + 1] = enemies_[i]
    --     end
    -- end

    -- for i = 1, #allies_ do
    --     allies_[i]:update(dt)
    -- end

    -- -- 清理失效子弹
    -- for i = #destoryBullets, 1, -1 do
    --     for j = #bullets_, 1, -1 do
    --         if bullets_[j] == destoryBullets[i] then
    --             table.remove(bullets_, j)
    --         end
    --     end
    -- end

    -- -- 清理失效敌机
    -- for i = #destoryPlanes, 1, -1 do
    --     for j = #enemies_, 1, -1 do
    --         if enemies_[j] == destoryPlanes[i] then
    --             table.remove(enemies_, j)
    --         end
    --     end
    -- end

    -- -- 生命值小于0，结算
    -- if self.life_ <= 0 then
    --     self:setGameState(ConstDef.GAME_STATE.RESULT)
    -- end
end

--[[--
    命中敌人

    @param plane 类型：EnemyPlane，敌机
    @param bullet 类型：Bullet，子弹

    @return none
]]
function InGameData:hitEnemy(enemy, bullet)
    -- self.score_ = self.score_ + plane:getScore()
    -- if self.score_ > self.history_ then
    --     self.history_ = self.score_
    -- end
    -- bullet:bomb()
    -- bullet:destory()
    -- plane:destory()
end

--[[--
    开炮

    @param dt 类型：number，时间间隔，单位秒

    @return none
]]
function InGameData:shoot(dt)
    if self.shoot_ == nil then
        self.shoot_ = 0
    end
    self.shoot_ = self.shoot_ + dt
    if self.shoot_ > SHOOT_INTERVAL then
        self.shoot_ = self.shoot_ - SHOOT_INTERVAL

        -- 产生子弹
        local bullet = Bullet.new(2)
        bullets_[#bullets_ + 1] = bullet

        -- for i = 1, #allies_ do
        --     local bullet = Bullet.new()
        --     bullets_[#bullets_ + 1] = bullet
        --     bullet:setX(allies_[i]:getX())
        --     bullet:setY(allies_[i]:getY() + 30)
        -- end
    end
end

--[[--
    产生敌人

    @param num 类型：number，敌人类型

    @return none
]]
function InGameData:createEnemy(num)
    local enemy = Enemy.new("name", num, 300)  --调出create状态
    enemies_[#enemies_+1] = enemy

    -- self.enemyTick_ = self.enemyTick_ + dt
    -- if self.enemyTick_ > ENEMY_INTERVAL then
    --     self.enemyTick_ = self.enemyTick_ - ENEMY_INTERVAL
    --     local enemy = EnemyPlane.new()
    --     enemy:setX(math.random(display.left + 20, display.right - 20))
    --     enemy:setY(display.top)
    --     enemies_[#enemies_ + 1] = enemy
    -- end
end

--[[--
    描述：计时器连续生成敌人
]]
function InGameData:createEnemyInterval()
    -- 连续生成敌人
    -- local num = 0
    timeCreateEnemySchdule = schedule:scheduleScriptFunc(function (dt)
        if InGameData:getGameState() == ConstDef.GAME_STATE.PLAY then
            -- if num < littleEnemyNum then
            --     num = num + 1
                self:createEnemy(1)
            -- elseif num == littleEnemyNum then
            --     num = 0
            --     local enemy = InGameEnemySprite.new(2)
            --     self:addChild(enemy)
            --     self:enemyMovePlayer(enemy)
            -- end
        end
    end, 0.5, false)
end

--[[--
    描述：停止敌人生成计时器
]]
function InGameData:stopCreateEnemy()
    schedule:unscheduleScriptEntry(timeCreateEnemySchdule)
end


return InGameData
