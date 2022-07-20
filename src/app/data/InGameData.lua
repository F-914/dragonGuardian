--[[--
    InInGameData.lua
    游戏内数据
]]
local InGameData = {}
local Log = require("app.utils.Log")
local Card = require("app.data.Card")
local Bullet = require("app.data.Bullet")
local Enemy = require("app.data.Enemy")
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local TowerArrayDef = require("app.def.TowerArrayDef")
local EnemyTowerArrayDef = require("app.def.EnemyTowerArrayDef")
local GirdLocation = require("app.def.GirdLocation")
local EventManager = require("app.manager.EventManager")

-- TODO 这里可能得存两份，一份自己的，一份敌人的
local cards_ = {}
local enemies_ = {}
local bullets_ = {}
local enemyCards_ = {}
local enemyEnemies_ = {}
local enemyBullets_ = {}
local scheduleBullet_ = {}
local scheduleEnemyBullet_ = {}
local schedule = cc.Director:getInstance():getScheduler() --计时器路径
local timeCreateEnemySchdule = nil -- 敌人生成计时器
local ENEMY_INTERVAL = 3    --敌人生成间隔
local SHOOT_INTERVAL = 0.5  -- 类型：number，射击间隔

--[[--
    初始化数据

    @param none

    @return none
]]
function InGameData:init()
    self.sp_ = 100  -- 类型：number，当前玩家拥有的能量
    self.spCreateTower_ = 10    --类型：number，生成塔需要的能量(每生成一次+10)
    self.spEnemy_ = 100  -- 类型：number，当前玩家拥有的能量
    self.spCreateEnemyTower_ = 10    --类型：number，生成塔需要的能量(每生成一次+10)
    self.life_ = 100 -- 类型：number，生命值
    self.score_ = 0 -- 类型：number，得分

    self.boss_ = 0      --类型：number，当前Boss类型
    self.nextBoss_ = 1  --类型：number，即将出现第几个boss

    -- 类型：number，游戏状态
    self.gameState_ = ConstDef.GAME_STATE.INIT
end

--[[--
    设置当前Boss

    @param number：Boss的编号
]]
function InGameData:setCurBoss(boss)
    self.boss_ = boss
end

function InGameData:getCurBoss()
    return self.boss_
end

function InGameData:getSp()
    return self.sp_
end

function InGameData:setSp(sp)
    self.sp_ = sp
end

--[[--
    当前能量值快速加/减操作
]]
function InGameData:changeSp(change)
    self.sp_ = self.sp_ + change
end

function InGameData:getSpCreateTower()
    return self.spCreateTower_
end

--[[--
    当前生成塔消耗的能量值快速加/减操作
]]
function InGameData:changeSpCreateTower(change)
    self.spCreateTower_ = self.spCreateTower_ + change
end

----------------------------------------------------------------------
function InGameData:getSpEnemy()
    return self.spEnemy_
end

function InGameData:setSpEnemy(sp)
    self.spEnemy_ = sp
end

--[[--
    当前能量值快速加/减操作
]]
function InGameData:changeSpEnemy(change)
    self.spEnemy_ = self.spEnemy_ + change
end

function InGameData:getSpCreateEnemyTower()
    return self.spCreateEnemyTower_
end

--[[--
    当前生成塔消耗的能量值快速加/减操作
]]
function InGameData:changeSpCreateEnemyTower(change)
    self.spCreateEnemyTower_ = self.spCreateEnemyTower_ + change
end
-------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------
--[[--
    创建卡牌（信息）

    @param number：塔等级
    @param number：塔表格位置x
    @param number：塔表格位置y
]]
function InGameData:createCard(level,x,y)
    local num = math.random(1, 5)
    local id = TowerArrayDef[num].ID
    local card
    if x ~= nil and y ~= nil then
        local xPos = GirdLocation.PLAYER[x][y].X
        local yPos =  GirdLocation.PLAYER[x][y].Y
        GirdLocation.PLAYER[x][y].IS_USED = true
        card = Card.new(1, xPos, yPos, x, y, id,_,_,_,level)
    else
        local cx, cy, xLocate, yLocate= self:setCardRandomPosision(1)
        if cx == nil or cy == nil or xLocate == nil or yLocate == nil then
        else
            card = Card.new(1, cx, cy, xLocate, yLocate, id,_,_,_,level)
        end
    end
    cards_[#cards_+1] = card
    --print(vardump(cards_))
end

--[[--
    创建敌方卡牌

    @param number：塔等级
    @param number：塔表格位置x
    @param number：塔表格位置y
]]
function InGameData:createEnemyCard(level,x,y)
    local num = math.random(1, 5)
    local id = EnemyTowerArrayDef[num].ID
    local card
    if x ~= nil and y ~= nil then
        local xPos = GirdLocation.ENEMY[x][y].X
        local yPos = GirdLocation.ENEMY[x][y].Y
        GirdLocation.ENEMY[x][y].IS_USED = true
        print("\nInGameData:createEnemyCard  x,y ",x ,y)
        print("\nInGameData:createEnemyCard  GirdLocation.ENEMY[x][y].y ",GirdLocation.ENEMY[x][y].y)
        print("InGameData:createEnemyCard  xPos, yPos",xPos, yPos)
        card = Card.new(2, xPos, yPos, x, y, id,_,_,_,level)
    else
        local cx, cy ,xLocate , yLocate= self:setCardRandomPosision(2)
        if cx == nil or cy == nil or xLocate == nil or yLocate == nil then
        else
            card = Card.new(2, cx, cy, xLocate, yLocate, id,_,_,_,level)
        end
    end
    enemyCards_[#enemyCards_+1] = card
    --print(vardump(cards_))
end

--[[--
    设置塔随机位置

    @param number：控制生成位置在我方还是敌方

    @return 实际位置和表格位置
]]
function InGameData:setCardRandomPosision(type)
    local girdLocation
    if type == 1 then
        girdLocation = GirdLocation.PLAYER
    elseif type == 2 then
        girdLocation = GirdLocation.ENEMY
    else
        Log.w("The parameter range is 1(player) or 2(enemy)")
    end

    --随机位置
    local x = math.random(1, 3)
    local y = math.random(1, 5)
    local cx, cy
    if girdLocation[x][y].IS_USED == false then
        Log.i("build tower accept")

        --设置位置
        cx = girdLocation[x][y].X
        cy =  girdLocation[x][y].Y

        girdLocation[x][y].IS_USED = true
    else
        -- 若检测到一个已使用位置，遍历判断位置是否已满
        local isFull = true
        for i,v in pairs(girdLocation) do
            for j,w in pairs(v) do
                if w.IS_USED == false then
                    isFull = false
                    x = i
                    y = j
                    Log.i("build tower accept")

                    --设置位置
                    cx = girdLocation[x][y].X
                    cy =  girdLocation[x][y].Y

                    girdLocation[x][y].IS_USED = true
                    break
                end
            end
            if isFull == false then
                break
            end
        end
        if isFull then
            Log.i("Tower gird is full")
            return
        end
    end
    return cx, cy, x, y
end

--[[--
    根据位置判断是否可以合并（数据部分）
    返回是否可合并，图像部分删除按钮图标，在此部分处理数据

    @param table 当前移动的卡数据

    @return bool 是否可合并
]]
function InGameData:isMergeCard(card,curX,curY)
    local delta = display.width
    local targetCard = {}
    local cardNum
            print("curx, cury", curX, curY)

    --遍历当前塔数据寻找位置相近的其他塔
    print(vardump(cards_))
    for i,c in ipairs(cards_) do
        if c == card then --排除塔自身，同时记录当前塔序号
            cardNum = i
        else
            local cx = c:getMyX()
            local cy = c:getMyY()
            print("cx, cy",cx, cy)
            local d = ((cx - curX)^2 + (cy - curY)^2)^0.5
            print("d ",d)
            if d < delta and d > 0 then
                delta = d
                targetCard.c = c
                targetCard.i = i
            end
        end
    end
    print("delta: ",delta)
        print(vardump(scheduleBullet_))

    --合并塔
    if delta < 50 and targetCard.c:getCardLevel() == card:getCardLevel()
                and targetCard.c:getCardId() == card:getCardId() then
        --目标塔位置生成新塔
        local newLevel = targetCard.c:getCardLevel()
        self:createCard(newLevel + 1, targetCard.c:getXLocate(), targetCard.c:getYLocate())

        --当前位置暂用状态修改
        GirdLocation.PLAYER[card:getXLocate()][card:getYLocate()].IS_USED = false

        --当前塔销毁
        targetCard.c:destory()
        card:destory()

        --停止子弹定时器
        self:stopCreateBullet(1, targetCard.i)
        self:stopCreateBullet(1, cardNum)
        return true
    end

    return false
end

--[[--
    敌方自动判断塔合并

    @return bool：是否存在合并
]]
function InGameData:enemyMerge()
    for i = 1, #enemyCards_ do
        for j = i+1,#enemyCards_ do
            --两塔相同类型、等级
            if enemyCards_[i]:getCardId() == enemyCards_[j]:getCardId()
                    and enemyCards_[i]:getCardLevel() == enemyCards_[j]:getCardLevel() then
                --目标塔位置生成新塔
                local newLevel = enemyCards_[i]:getCardLevel()
                print("enemyCards_[i]:getXLocate() enemyCards_[i]:getYLocate()",enemyCards_[i]:getXLocate(),enemyCards_[i]:getYLocate())
                self:createEnemyCard(newLevel + 1, enemyCards_[i]:getXLocate(), enemyCards_[i]:getYLocate())

                --当前位置暂用状态修改
                GirdLocation.ENEMY[enemyCards_[j]:getXLocate()][enemyCards_[j]:getYLocate()].IS_USED = false

                --当前塔销毁
                enemyCards_[i]:destory()
                enemyCards_[j]:destory()

                --停止子弹定时器
                self:stopCreateBullet(2, i)
                self:stopCreateBullet(2, j)
                return true
            end
        end
    end
    return false
end

--[[--
    塔强化
]]
function InGameData:cardEnhance()
    
end
-----------------------------------------------------------------------
--[[--
    命中敌人

    @param enemy 类型：Enemy
    @param bullet 类型：Bullet，子弹

    @return none
]]
function InGameData:hitEnemy(enemy, bullet)
    enemy:setDeHp(bullet:getDamage())
    EventManager:doEvent(EventDef.ID.HIT_ENEMY, enemy, bullet:getDamage())
    if enemy:getHp() <= 0 then
        enemy:destory()
        if enemy:getCamp() == 1 then
            self.sp_ = self.sp_ + 10 * self.nextBoss_
            --消灭己方怪，对方生成怪
            self:createEnemy(2, enemy:getType())
        else
            self.spEnemy_ = self.spEnemy_ + 10 * self.nextBoss_
            --对方消灭怪，己方生成怪
            self:createEnemy(1, enemy:getType())
        end
    end
    bullet:destory()
end

--[[--
    碰撞检测

    @param enemy 类型：Enemy, 敌人
    @param bullet 类型：Bullet数组

    @return none
]]
function InGameData:checkCollider(enemy, bullets)
    for i = 1, #bullets do
        local bullet = bullets[i]
        if not bullet:isDeath() then
            if enemy:isCollider(bullet) then
                self:hitEnemy(enemy, bullet)
                break
            end
        end
    end
end

------------------------------------------------------------------
--[[--
    开炮

    @param number：子弹所属阵营
    @param number：子弹种类(编号）
    @param number：生成位置x(后续可添加参数控制子弹效果)
    @param number：生成位置y
    @param number：所属塔等级

    @return none
]]
function InGameData:shoot(camp, type, x, y, level)
    local timeCreateBulletSchdule = schedule:scheduleScriptFunc(function(dt)
        if self:getGameState() == ConstDef.GAME_STATE.PLAY then
            if self.isHasEnemy_ then
                -- 产生子弹
                local bullet = Bullet.new(camp, type, x, y)
                bullet:setDirection(self:getClosestEnemy(camp, bullet))
                if camp == 1 then
                    bullets_[#bullets_ + 1] = bullet
                else
                    enemyBullets_[#enemyBullets_ + 1] = bullet
                end
            end
        end
    end, SHOOT_INTERVAL/level, false)

    --创建塔紧跟着创建定时器，将定时器存至最新塔下即可对应
    if camp == 1 then
        scheduleBullet_[#cards_ + 1] = {
            schedule = timeCreateBulletSchdule,
            isDeath = false
        }
    else
        scheduleEnemyBullet_[#enemyCards_ + 1] = {
            schedule = timeCreateBulletSchdule,
            isDeath = false
        }
    end
end

--[[--
    描述：停止子弹生成计时器

    @param number 要停止的子弹定时器对应塔在表格中的序号
]]
function InGameData:stopCreateBullet(camp, num)
    if camp == 1 then
        scheduleBullet_[num].isDeath = true
        schedule:unscheduleScriptEntry(scheduleBullet_[num].schedule)
    else
        scheduleEnemyBullet_[num].isDeath = true
        schedule:unscheduleScriptEntry(scheduleEnemyBullet_[num].schedule)
    end
end

--[[--
    获取距离当前子弹最近的敌人的方向
    (用于初始化子弹方向，子弹射出后不改变方向)

    @param table：子弹对象

    @return num, num: 最近敌人的方向
]]
function InGameData:getClosestEnemy(camp, bullet)
    local bX = bullet:getMyX()
    local bY = bullet:getMyY()
    local eX, eY, enemies
    local xCos, ySin
    -- local minDistance = display.width
    -- for i,e in pairs(enemies_) do   --遍历当前存在的敌人
    --     --计算距离
    --     eX = e:getMyX()
    --     eY = e:getMyY()
    --     local distance = ((eX-bX)^2 + (eY-bY)^2)^0.5
    --     if distance < minDistance then
    --         minDistance = distance
    --         xCos = (eX-bX)/distance
    --         ySin = (eY-bY)/distance
    --     else
    --         return xCos, ySin
    --     end
    -- end
    if camp == 1 then
        enemies = enemies_
    else
        enemies = enemyEnemies_
    end
    --对着第一个打
    --计算距离
    for i,e in pairs(enemies) do   --遍历当前存在的敌人
        if e ~= nil then
            eX = e:getMyX()
            eY = e:getMyY()
            local distance = ((eX-bX)^2 + (eY-bY)^2)^0.5
            xCos = (eX-bX)/distance
            ySin = (eY-bY)/distance
            return xCos, ySin
        end
    end

    return xCos, ySin
end

-----------------------------------------------------------------------
--[[--
    产生敌人

    @param num 类型：number，敌人类型

    @return none
]]
function InGameData:createEnemy(camp, type)
    local enemy = Enemy.new(camp, "name", type, 300) --调出create状态
    if camp == 1 then
        enemies_[#enemies_ + 1] = enemy
    else
        enemyEnemies_[#enemyEnemies_+1] = enemy
    end
end

--[[--
    描述：计时器连续生成敌人
]]
function InGameData:createEnemyInterval()
    -- 连续生成敌人
    -- local num = 0
    timeCreateEnemySchdule = schedule:scheduleScriptFunc(function(dt)
        if InGameData:getGameState() == ConstDef.GAME_STATE.PLAY then
            -- if num < littleEnemyNum then
            --     num = num + 1
            self:createEnemy(1, 1)
            self:createEnemy(2, 1)
            -- elseif num == littleEnemyNum then
            --     num = 0
            --     local enemy = InGameEnemySprite.new(2)
            --     self:addChild(enemy)
            --     self:enemyMovePlayer(enemy)
            -- end
        end
    end, ENEMY_INTERVAL, false)
end

--[[--
    描述：停止敌人生成计时器
]]
function InGameData:stopCreateEnemy()
    schedule:unscheduleScriptEntry(timeCreateEnemySchdule)
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

    --刷新判断是否还有敌人
    if enemies_[1] == nil or enemyEnemies_[1] == nil then
        self.isHasEnemy_ = false
    else
        self.isHasEnemy_ = true
    end

    local destoryEnemys = {}
    local destoryBullets = {}
    local destoryCards = {}
    local destoryEnemyCards = {}
    local destoryEnemyEnemies = {}
    local destoryEnemyBullets = {}
    local destorySchedule = {}
    local destoryEnemySchedule = {}

    for i = 1, #enemies_ do
        enemies_[i]:update(dt)
        if not enemies_[i]:isDeath() then
            self:checkCollider(enemies_[i], bullets_)
        else
            destoryEnemys[#destoryEnemys + 1] = enemies_[i]
        end
    end

    for i = 1, #bullets_ do
        local bullet = bullets_[i]
        if self.isHasEnemy_ then   --追踪弹(清空敌人则直线运动)
            bullet:setDirection(self:getClosestEnemy(1, bullet))
        end
        bullet:update(dt)
        if bullet:isDeath() then
            destoryBullets[#destoryBullets + 1] = bullet
        end
    end

    for i = 1, #cards_ do
        if cards_[i]:isDeath() then
            destoryCards[#destoryCards + 1] = cards_[i]
        end
    end

    for i = 1, #enemyCards_ do
        if enemyCards_[i]:isDeath() then
            destoryEnemyCards[#destoryEnemyCards + 1] = enemyCards_[i]
        end
    end

    for i = 1, #enemyEnemies_ do
        enemyEnemies_[i]:update(dt)
        if enemyEnemies_[i]:isDeath() then
            destoryEnemyEnemies[#destoryEnemyEnemies + 1] = enemyEnemies_[i]
        else
            self:checkCollider(enemyEnemies_[i], enemyBullets_)
        end
    end

    for i = 1, #enemyBullets_ do
        local bullet = enemyBullets_[i]
        if self.isHasEnemy_ then   --追踪弹(清空敌人则直线运动)
            bullet:setDirection(self:getClosestEnemy(2, bullet))
        end
        bullet:update(dt)
        if bullet:isDeath() then
            destoryEnemyBullets[#destoryEnemyBullets + 1] = bullet
        end
    end

    for i = 1, #scheduleBullet_ do
        if scheduleBullet_[i].isDeath then
            destorySchedule[#destorySchedule + 1] = scheduleBullet_[i]
        end
    end

    for i = 1, #scheduleEnemyBullet_ do
        if scheduleEnemyBullet_[i].isDeath then
            destoryEnemySchedule[#destoryEnemySchedule + 1] = scheduleEnemyBullet_[i]
        end
    end

    -- 清理失效子弹
    for i = #destoryBullets, 1, -1 do
        for j = #bullets_, 1, -1 do
            if bullets_[j] == destoryBullets[i] then
                table.remove(bullets_, j)
            end
        end
    end

    -- 清理失效敌人
    for i = #destoryEnemys, 1, -1 do
        for j = #enemies_, 1, -1 do
            if enemies_[j] == destoryEnemys[i] then
                table.remove(enemies_, j)
            end
        end
    end

    -- 清理失效塔
    for i = #destoryCards, 1, -1 do
        for j = #cards_, 1, -1 do
            if cards_[j] == destoryCards[i] then
                table.remove(cards_, j)
            end
        end
    end

    -- 清理失效敌方塔
    for i = #destoryEnemyCards, 1, -1 do
        for j = #enemyCards_, 1, -1 do
            if enemyCards_[j] == destoryEnemyCards[i] then
                table.remove(enemyCards_, j)
            end
        end
    end

    -- 清理失效敌方敌人
    for i = #destoryEnemyEnemies, 1, -1 do
        for j = #enemyEnemies_, 1, -1 do
            if enemyEnemies_[j] == destoryEnemyEnemies[i] then
                table.remove(enemyEnemies_, j)
            end
        end
    end

    -- 清理失效敌方子弹
    for i = #destoryEnemyBullets, 1, -1 do
        for j = #enemyBullets_, 1, -1 do
            if enemyBullets_[j] == destoryEnemyBullets[i] then
                table.remove(enemyBullets_, j)
            end
        end
    end

    -- 清理失效子弹计时器
    for i = #destorySchedule, 1, -1 do
        for j = #scheduleBullet_, 1, -1 do
            if scheduleBullet_[j] == destorySchedule[i] then
                table.remove(scheduleBullet_, j)
            end
        end
    end

    -- 清理失效敌人子弹计时器
    for i = #destoryEnemySchedule, 1, -1 do
        for j = #scheduleEnemyBullet_, 1, -1 do
            if scheduleEnemyBullet_[j] == destoryEnemySchedule[i] then
                table.remove(scheduleEnemyBullet_, j)
            end
        end
    end

    -- -- 生命值小于0，结算
    -- if self.life_ <= 0 then
    --     self:setGameState(ConstDef.GAME_STATE.RESULT)
    -- end
end

return InGameData
