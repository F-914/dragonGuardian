--[[--
    GirdLocation.lua

    描述：存放游戏内塔生成表格位置
]]
local GirdLocation = {
    PLAYER = {},
    ENEMY = {}
}

--local
local rowSpacing = display.cy * 17 / 100 --行间距(y)
local colSpacing = display.cx * 55 / 200 --列间距(x)
local playerX = display.cx * 99 / 100 --(1,3)
local playerY = display.cy * 80 / 100
local enemyX = display.cx * 98 / 100 --(1,3)
local enemyY = display.cy * 171 / 100

GirdLocation.PLAYER = { --3行5列
    {
        {
            X = playerX - colSpacing * 2,
            Y = playerY,
            IS_USED = false
        },
        {
            X = playerX - colSpacing,
            Y = playerY,
            IS_USED = false
        },
        {
            X = playerX,
            Y = playerY,
            IS_USED = false
        },
        {
            X = playerX + colSpacing,
            Y = playerY,
            IS_USED = false
        },
        {
            X = playerX + colSpacing * 2,
            Y = playerY,
            IS_USED = false
        },
    },
    {
        {
            X = playerX - colSpacing * 2,
            Y = playerY - rowSpacing,
            IS_USED = false
        },
        {
            X = playerX - colSpacing,
            Y = playerY - rowSpacing,
            IS_USED = false
        },
        {
            X = playerX,
            Y = playerY - rowSpacing,
            IS_USED = false
        },
        {
            X = playerX + colSpacing,
            Y = playerY - rowSpacing,
            IS_USED = false },
        {
            X = playerX + colSpacing * 2,
            Y = playerY - rowSpacing,
            IS_USED = false },
    },
    {
        {
            X = playerX - colSpacing * 2,
            Y = playerY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = playerX - colSpacing,
            Y = playerY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = playerX,
            Y = playerY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = playerX + colSpacing,
            Y = playerY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = playerX + colSpacing * 2,
            Y = playerY - rowSpacing * 2,
            IS_USED = false
        },
    }
}

GirdLocation.ENEMY = { --3行5列
    {
        {
            X = enemyX - colSpacing * 2,
            Y = enemyY,
            IS_USED = false
        },
        {
            X = enemyX - colSpacing,
            Y = enemyY,
            IS_USED = false
        },
        {
            X = enemyX,
            Y = enemyY,
            IS_USED = false
        },
        {
            X = enemyX + colSpacing,
            Y = enemyY,
            IS_USED = false
        },
        {
            X = enemyX + colSpacing * 2,
            Y = enemyY,
            IS_USED = false
        },
    },
    {
        {
            X = enemyX - colSpacing * 2,
            Y = enemyY - rowSpacing,
            IS_USED = false
        },
        {
            X = enemyX - colSpacing,
            Y = enemyY - rowSpacing,
            IS_USED = false
        },
        {
            X = enemyX,
            Y = enemyY - rowSpacing,
            IS_USED = false
        },
        {
            X = enemyX + colSpacing,
            Y = enemyY - rowSpacing,
            IS_USED = false },
        {
            X = enemyX + colSpacing * 2,
            Y = enemyY - rowSpacing,
            IS_USED = false },
    },
    {
        {
            X = enemyX - colSpacing * 2,
            Y = enemyY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = enemyX - colSpacing,
            Y = enemyY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = enemyX,
            Y = enemyY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = enemyX + colSpacing,
            Y = enemyY - rowSpacing * 2,
            IS_USED = false
        },
        {
            X = enemyX + colSpacing * 2,
            Y = enemyY - rowSpacing * 2,
            IS_USED = false
        },
    }
}

return GirdLocation
