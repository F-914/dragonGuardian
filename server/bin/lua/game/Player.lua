--[[--
    Player.lua
    Game��Player������
]]

Player = {
	pid = 0,
	nick = "",
	hp = 0,
	score=0,
}

Player.__index = Player

Player.new = function()
	local self = {}
	setmetatable(self, Player)
	self.pid = 0
	self.nick = ""
	return self
end

Player.init = function(self, pid, nick, hp,score)
	--local self = {}
	--setmetatable(self, Player)
	self.pid = pid
	self.nick = nick
	self.hp = hp
	self.score=score
	--print(self.pid)
	return self
end

return Player