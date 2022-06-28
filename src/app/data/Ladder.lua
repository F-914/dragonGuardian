--[[--
    Ladder.lua
    天梯奖励
]]
local Ladder = class("Ladder", require("app.data.base.BaseModel"))
local Log    = require("app.utils.Log")

-- local
local ConstDef = require("app.def.ConstDef")
--

---Ladder.ctor 构造函数
---@param ladderList table 天梯奖励列表，里面是各种奖励
---@return  Type Description
function Ladder:ctor(ladderList)
    self:setLadder(ladderList)
end

function Ladder:setLadder(ladderList)
    self.ladderList_ = ladderList
end

function Ladder:sort()
    table.sort(self.ladderList_, _sortByTrophy)
end

function Ladder:unlock(index)
    if index > #(self.ladderList_) or index < 1 then
        Log.e("index out of bound in Ladder:unlock.")
        return
    end
    if self.ladderList_[index].isLocked() == true then
        Log.e("already unlocked in Ladder:unlock.")
    end
    self.ladderList_[index].setLocked(false)
end

function Ladder:receiveReward(index)
    if index > #(self.ladderList_) or index < 1 then
        Log.e("index out of bound in Ladder:receiveReward.")
        return
    end
    if self.ladderList_[index].isReceived() == true then
        Log.e("already received in Ladder:receiveReward")
        return
    end
    self.ladderList_[index].setReceived(true)
end

---奖励排序：按奖杯数量升序排列
---@param ta any
---@param tb any
---@return boolean
function _sortByTrophy(ta, tb)
    return ta.trophyCondition < tb.trophyCondition
end

function Ladder:getLadderList()
    return self.ladderList_
end

return Ladder
