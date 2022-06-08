
local Enemy = class("Enemy",function()
    return cc.Sprite:create()
end)


function Enemy:ctor(enemyType)
    --使用图片创建敌方飞机
    enemy1 = cc.Sprite:create("player/small_enemy.png")
    enemy1:setPosition(100,700)
    enemy1:setAnchorPoint(0, 1)
    enemy1:addTo(planeLayer)

    enemy2 = cc.Sprite:create("player/small_enemy.png")
    enemy2:setPosition(220,700)
    enemy2:setAnchorPoint(0, 1)
    enemy2:addTo(planeLayer)

    enemy3 = cc.Sprite:create("player/small_enemy.png")
    enemy3:setPosition(340,700)
    enemy3:setAnchorPoint(0, 1)
    enemy3:addTo(planeLayer)
end

function Enemy:enemyTransform()
    local Y1 = enemy1:getPositionY()
    local Y2 = enemy2:getPositionY()
    local Y3 = enemy3:getPositionY()

    enemyFly1 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--敌机1移动定时器
            function()
                enemy1:setPosition(100,Y1)
                Y1 = Y1-1
            end,1/60,false)

    enemyFly2 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--敌机2移动定时器
            function()
                Y2 = Y2-1
            end,1/60,false)

    enemyFly3 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--敌机3移动定时器
            function()
                enemy3:setPosition(340,Y3)
                Y3 = Y3-1
            end,1/60,false)


end

function Enemy:enemyCreate()
    enemyBorn = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--敌机出生计时器
    function()
        if enemy1:getPositionY() == 900 or 700 then
            print("set")

            enemy1:setPosition(100,700)
            local Y1 = enemy1:getPositionY()
            enemyFly1 = cc.Director:getInstance():getScheduler():scheduleScriptFunc(--敌机1移动定时器
                    function()
                        enemy1:setPosition(100,Y1)
                        Y1 = Y1-1
                    end,1/60,false)


            enemy1:setVisible(true)

        end

        if enemy2:getPositionY() == 900 or 700 then
            enemy2:setPosition(220,700)
        end

        if enemy3:getPositionY() == 900 or 700 then
            enemy3:setPosition(340,700)
        end
end,1,false)
end