--[[--
    Enemy.lua
    敌人对象基类
]]
local Enemy = class("Enemy", require("app.data.BaseModel"))

-- local
local ConstDef = require("app.def.ConstDef")
--

---构造函数
---@param myEnemy Enemy
---@param x number
---@param y number
---@param width number
---@param height number
---@param isDeath boolean
---TODO 还得加别的
function Enemy:ctor(
    myEnemy,
    x,
    y,
    width,
    height,
    isDeath
)
    if myEnemy == nil then
        Enemy.super.ctor(self, nil, x, y, width, height, isDeath)
    else
        Enemy:setData(myEnemy)
    end
end

---setData
---@param myEnemy Enemy
function Enemy:setData(myEnemy)
    Enemy.super.ctor(
        self,
        nil,
        myEnemy:getMyX(),
        myEnemy:getMyY(),
        myEnemy:getMyWidth(),
        myEnemy:getMyHeight(),
        myEnemy:isDeath()
    )
end

return Enemy
