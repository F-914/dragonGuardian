local cjson = require "cjson"
local Timer = require("lua.Timer")
local LogDef = require("lua.LogDef")
local MsgDef = require("lua.MsgDef")
local GameEntity = require("lua.game.GameEntity")
local Player=require("lua.game.Player")
local gameingList_={}
local gameWaitList_={}
local function traceback()
    local retstr = "\r\n"
    local level = 3
    while true do
        local info = debug.getinfo(level, "Sln")
        if not info then break end
        if info.what == "C" then -- is a C function?
            retstr = retstr .. string.format("level: %s C function '%s'\r\n", tostring(level), tostring(info.name))
        else -- a Lua function
            retstr = retstr .. string.format("[%s]:%s  in function '%s'\r\n",
                tostring(info.source), tostring(info.currentline), tostring(info.name))
        end
        level = level + 1
    end

    return retstr
end

function __G__TRACKBACK__(errorMessage)
    local log = "LUA ERROR: " .. tostring(errorMessage) .. debug.traceback("", 2)
            .. "\r\nFull Path:" .. traceback()
    print(log)
end

function initGameModule()
	--init game module here
	print("init game module succ!!!")
end

local gameSerial = 0
--[[
    @description: 创造游戏体的函数，返回type=匹配中的确认消息
    @param msg 类型:json 要求msg必须含有pid,nick,hp,score，其中socre是玩家对应的战斗力评分
    @return none
]]
function createGameEntity(msg)
	
	gameSerial = gameSerial + 1
	newGame = GameEntity.new()
	newGame:init(gameSerial, msg)
	
	local players={}
	local player = Player.new()
	player:init(msg["pid"], msg["nick"],msg["hp"] ,msg["score"])
	table.insert(players,player)
	local group={}
	group["players"]=players
	group["game"]=newGame
	table.insert(gameWaitList_, group)
	
	--print("gameWaitList_..Length.."..table.getn(gameWaitList_))
	--print("gameWaitList_[1]"..gameWaitList_[1])
	local ack={}
	ack["type"]=nil--此处应是 匹配中 对应的类型
	ack["pid"]=msg["pid"]
	ack["serialNumber"]=gameSerial
	local msgBack=cjson.encode(ack)
	sendMsg2ClientByPid(pid, msgBack)
    
end
--[[
    @description: 匹配函数，匹配成功会向客户端发送type=MsgDef.ACKTYPE.GAME.STARTGAME的确认消息
    @param msg 类型:json 要求msg必须含有pid,nick,hp,score，
    @return none
]]
function matching(msg)
	local serial=nil
	if(table.getn(gameWaitList_)==0) then
		createGameEntity(msg)
		--print("msg.."..msg["pid"])
	else
			local matching=nil
			for v,k in ipairs(gameWaitList_) do
				if(math.abs(k.players[1].score-msg["score"])<=50) then
					  
					  matching=v
					  serial=k.game.serialNumber
					  break
					 
				end
			end
			if matching==nil then
				createGameEntity(msg)
			else
				local player=Player:init(msg["pid"], msg["nick"], msg["hp"],msg["score"])
				table.insert(gameWaitList_[matching].players,player)
                
				local matchSuc1={}
                matchSuc1["pid"]=gameWaitList_[matching].players[1].pid
				matchSuc1["hp"]=gameWaitList_[matching].players[1].hp
				matchSuc1["nick"]=gameWaitList_[matching].players[1].nick
                matchSuc1["type"]=MsgDef.ACKTYPE.GAME.STARTGAME
				matchSuc1["serial"]=gameWaitList_[matching].game.serialNumber
                local str1=cjson.encode(matchSuc1)
				sendMsg2ClientByPid(matchSuc1["pid"], str1)
                
				local matchSuc2={}
                matchSuc2["pid"]=gameWaitList_[matching].players[2].pid
				matchSuc1["hp"]=gameWaitList_[matching].players[2].hp
				matchSuc1["nick"]=gameWaitList_[matching].players[2].nick
                matchSuc2["type"]=MsgDef.ACKTYPE.GAME.STARTGAME
				matchSuc2["serial"]=gameWaitList_[matching].game.serialNumber
                local str2=cjson.encode(matchSuc2)
				sendMsg2ClientByPid(matchSuc2["pid"], str2)
                
				--print("gameWaitList_..Length.."..table.getn(gameWaitList_))
				--print("matching.."..matching)
			
				table.insert(gameingList_, gameWaitList_[matching])
                table.remove(gameWaitList_,matching)
				--print("gameingList_..Length.."..table.getn(gameingList_))
		    end
	end
	print("gameingList_..Length"..table.getn(gameingList_))
	print("gameWaitList_..Length"..table.getn(gameWaitList_))
end
function processGameMsg()
	local msgStr = recvGameMsg()
	
	if (msgStr == nil or msgStr == '') then
		return
	end

	local msg = cjson.decode(msgStr)
    --print("sid.."..msg["sid"])
	if (msg["type"] == MsgDef.REQTYPE.GAME.CREATEGAME) then
		matching(msg)
	elseif msg["type"]==MsgDef.REQTYPE.GAME.REFRESHHP then
        hpChange(msg)
	elseif msg["type"] ==MsgDef.REQTYPE.GAME.GAMEOVER then
		gameOver(msg)
	elseif mag["type"]==MsgDef.REQTYPE.GAME.ENEMY_CREATE then
		enemy(msg)
	elseif mag["type"]==MsgDef.REQTYPE.GAME.ENEMY_MOVE then
		enemy(msg)
    elseif mag["type"]==MsgDef.REQTYPE.GAME.ENEMY_DESTORY then
        enemy(msg)
	elseif mag["type"]==MsgDef.REQTYPE.GAME.BULLET_CREATE then
		bullet(msg)
	elseif mag["type"]==MsgDef.REQTYPE.GAME.BULLET_MOVE then
		bullet(msg)
	elseif mag["type"]==MsgDef.REQTYPE.GAME.BULLET_DESTORY then
		bullet(msg)
	elseif mag["type"]==MsgDef.REQTYPE.GAME.TOWER_ADD then
        towerAdd(msg)
	end
end

function update()
	--main loop
	processGameMsg()
	--print(2)
	--other logic update
end
--[[
    @description: 增加游戏中的塔的函数 
    @param msg 类型:json msg必须包含pid，serial，和记录塔信息的tower
    @return none
]]
function towerAdd(msg)
	local back={}
	back["tower"]=msg["tower"]
	back["type"]=msg["type"]
	for v,k in ipairs(gameingList_) do
		if k.game.serialNumber==msg["serial"] then
           if msg["pid"]==k.players[1].pid then
			  back["pid"]=k.players[2].pid 
		   elseif msg["pid"]==k.players[2].pid then
			  back["pid"]=k.players[1].pid
		   end
		end
	end
	local backStr=cjson.encode(back)
	sendMsg2ClientByPid(back["pid"],backStr)
end
--[[
    @description: 改变游戏中hp的函数，msg必须包含pid,change,serial  
    @param msg 类型:json msg必须包含pid,change,serial，其中pid为需要改动hp的玩家id，change为hp的变化值
	                     ，serial为玩家对应的服务器序号
    @return none
]]
function hpChange(msg)
    local id=msg["pid"]
	local change=msg["change"]
	local serial=msg["serial"]
	local test=nil
	for v,k in ipairs(gameingList_) do
		if(k.game.serialNumber==serial) then
			test=v
			print("v.."..v)
			if k.players[1].pid==id then
				k.players[1].hp=k.players[1].hp+change
				local send={}
				send["pid"]=id
				send["hp"]=k.players[1].hp
				local sendStr=cjson.encode(send)
				sendMsg2ClientByPid(k.players[2].pid,sendStr)
			elseif k.players[2].pid==id then
                k.players[2].hp=k.players[2].hp+change
				local send={}
				send["pid"]=id
				send["hp"]=k.players[2].hp
				local sendStr=cjson.encode(send)
				sendMsg2ClientByPid(k.players[1].pid,sendStr)
			end
		end

	end
	--print("test.."..test)
    --print("gameingList_..Length.."..table.getn(gameingList_))
	--print("gameingList_[test]..Length.."..table.getn(gameingList_[test]))
	--print("player1..hp.."..gameingList_[test].players[1].hp)
	--print("player2..hp.."..gameingList_[test].players[2].hp)
end
--[[
    @description: 游戏结束的函数，回传type=MsgDef.ACKTYPE.GAMEOVER的消息
    @param msg 类型:json msg必须包含自身的pid,服务器对应的序号order
    @return none
]]
function gameOver(msg)
    local back={}
	back["type"]=MsgDef.ACKTYPE.GAME.GAMEOVER
	back["pid"]=msg["pid"]
	local backStr=encode(msg)
	sendMsg2ClientByPid(back["pid"],backStr)
	msSleep(10)

	local serial=msg["serial"]
	for v,k in ipairs(gameingList_) do
		if k.game.serialNumber==serial then
           table.remove(gameingList_, v)
		   break
		end
	end
end
--[[
    @description: 通过服务器向对方客户端传送敌人的信息,可以自定义类型，包括创造，移动，销毁
    @param msg 类型:json msg必须包含自身的pid,服务器对应的序号order，还有关于敌人用到的表enemy
    @return none
]]
function enemy(msg)
    local back={}
	back["enemy"]=msg["enemy"]
	back["type"]=msg["type"]
	for v,k in ipairs(gameingList_) do
		if k.game.serialNumber==msg["serial"] then
           if msg["pid"]==k.players[1].pid then
			  back["pid"]=k.players[2].pid 
		   elseif msg["pid"]==k.players[2].pid then
			  back["pid"]=k.players[1].pid
		   end
		end
	end
	local backStr=cjson.encode(back)
	sendMsg2ClientByPid(back["pid"],backStr)
end
--[[
    @description: 通过服务器向对方客户端传送子弹的信息,可以自定义类型，包括创造，移动，销毁
    @param msg 类型:json msg必须包含自身的pid,服务器对应的序号order，还有关于子弹用到的表bullet
    @return none
]]
function bullet(msg)
    local back={}
	back["bullet"]=msg["bullet"]
	back["type"]=msg["type"]
	for v,k in ipairs(gameingList_) do
		if k.game.serialNumber==msg["serial"] then
           if msg["pid"]==k.players[1].pid then
			  back["pid"]=k.players[2].pid 
		   elseif msg["pid"]==k.players[2].pid then
			  back["pid"]=k.players[1].pid
		   end
		end
	end
	local backStr=cjson.encode(back)
	sendMsg2ClientByPid(back["pid"],backStr)
end
function main()
	initGameModule()
	local loopTimer = Timer.new()
	loopTimer:beginTimer(50)
	while true do
		if loopTimer:countingTimer() then
			update()
		end
		msSleep(1)
	end
end

xpcall(main, __G__TRACKBACK__)
