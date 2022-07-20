local cjson = require "cjson"
local Timer = require("lua.Timer")
local LogDef = require("lua.LogDef")
local MsgDef = require("lua.MsgDef")
local GameEntity = require("lua.game.GameEntity")
local Player=require("lua.game.Player")
local gameingList_={}
local gameWaitList_={}
local playersForSerialnumber_={}
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
	
	--[[gameSerial = gameSerial + 1
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
	sendMsg2ClientByPid(pid, msgBack)]]
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
	
	local ack={}
	ack["type"]=MsgDef.REQTYPE.GAME.MATCHING--此处应是 匹配中 对应的类型
	ack["pid"]=msg["pid"]
	ack["serialNumber"]=gameSerial
	local msgBack=cjson.encode(ack)
	sendMsg2ClientByPid(MSG["pid"], msgBack)
    --print("msg[loginname]="..msg["loginName"])
	--local test={}
	--test[msg["loginName"]]=1000
	playersForSerialnumber_[msg["loginName"]]=gameSerial
	--print(msg["loginName"])
	--print(playersForSerialnumber_["lisi600"])
	--print(table.getn(playersForSerialnumber_))
    
end
--[[
    @description: 匹配函数，匹配成功会向客户端发送type=MsgDef.REQTYPE.LOBBY.MATCH_SUC的确认消息
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
				playersForSerialnumber_[msg["nick"]]=gameWaitList_[matching].game.serialNumber

                
				local matchSuc1={}
                matchSuc1["pid"]=gameWaitList_[matching].players[1].pid
				matchSuc1["hp"]=gameWaitList_[matching].players[1].hp
				matchSuc1["nick"]=gameWaitList_[matching].players[1].nick
                matchSuc1["type"]=MsgDef.REQTYPE.LOBBY.MATCH_SUC
				matchSuc1["serial"]=gameWaitList_[matching].game.serialNumber
				matchSuc1["otherPid"]=gameWaitList_[matching].players[2].pid--匹配到的玩家id

                local str1=cjson.encode(matchSuc1)
				sendMsg2Lobby(str1)--匹配成功向lobby发送消息，从lobby将每个玩家的battleTeam再打包传送到客户端
                
				local matchSuc2={}
                matchSuc2["pid"]=gameWaitList_[matching].players[2].pid
				matchSuc1["hp"]=gameWaitList_[matching].players[2].hp
				matchSuc1["nick"]=gameWaitList_[matching].players[2].nick
                matchSuc2["type"]=MsgDef.REQTYPE.LOBBY.MATCH_SUC
				matchSuc2["serial"]=gameWaitList_[matching].game.serialNumber
				matchSuc1["otherPid"]=gameWaitList_[matching].players[1].pid--匹配到的玩家id
                local str2=cjson.encode(matchSuc2)
				sendMsg2Lobby(str2)
                
				--print("gameWaitList_..Length.."..table.getn(gameWaitList_))
				--print("matching.."..matching)
			
				table.insert(gameingList_, gameWaitList_[matching])
                table.remove(gameWaitList_,matching)
				--print("gameingList_..Length.."..table.getn(gameingList_))
		    end
	end
	--print("gameingList_..Length"..table.getn(gameingList_))
	--print("gameWaitList_..Length"..table.getn(gameWaitList_))
end
function findOtherPlayer(pid,serialNumber)
    for v,k in ipairs(gameingList_) do
		if k.game.serialNumber==serialNumber then
            if k.players[1].pid==pid then 
				return k.players[2].pid
			end
			if k.players[2].pid==pid then
				return k.players[1].pid
			end
	
	    end
	end
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
	
	elseif msg["type"]==MsgDef.REQTYPE.GAME.TOWER_ADD then
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
    @description: 向对方发送己方增加塔的消息
    @param msg 类型:json msg必须包含pid，serialNumber，塔序号cardId和位置信息location
    @return none
]]
function towerAdd(msg)
	--local serial = msg["serialNumber"]
	for v,k in ipairs(gameingList_) do
		if k.game.serialNumber==msg["serialNumber"] then
           if msg["pid"]==k.players[1].pid then
			  back["pid"]=k.players[2].pid 
		   elseif msg["pid"]==k.players[2].pid then
			  back["pid"]=k.players[1].pid
		   end
		end
	end
	local back={}
	back["location"]=msg["location"]
	back["type"]=MsgDef.ACKTYPE.GAME.TOWER_ADD
	back["cardId"]=msg["cardOrder"]
	back["otherPid"]=findOtherPlayer(msg["pid"], msg["serialNumber"])
	local backStr=cjson.encode(back)
	sendMsg2ClientByPid(back["otherPid"],backStr)
end
--[[
    @description: 改变游戏中hp的函数
    @param msg 类型:json msg必须包含pid,change,serialNumber，其中pid为需要改动hp的玩家id，change为hp的变化值
	                     ，serial为玩家对应的服务器序号
    @return none
]]
function hpChange(msg)
    local id=msg["pid"]
	local change=msg["change"]
	local serial=msg["serialNumber"]
	--local test=nil
	for v,k in ipairs(gameingList_) do
		if(k.game.serialNumber==serial) then
			--test=v
			--print("v.."..v)
			if k.players[1].pid==id then
				k.players[1].hp=k.players[1].hp+change
				local send={}
				send["pid"]=id
				send["hp"]=k.players[1].hp
				if k.players[1].hp<=0 then 
					send["type"]=MsgDef.ACKTYPE.GAME.GAMEOVER
					send["state"]=false--表示存活状态
				else
					send["type"]=MsgDef.ACKTYPE.GAME.REFRESHHP
				end
				local sendStr=cjson.encode(send)
				sendMsg2ClientByPid(k.players[2].pid,sendStr)--向两个对战方都发送消息
				sendMsg2ClientByPid(k.players[1].pid,sendStr)
			elseif k.players[2].pid==id then
                k.players[2].hp=k.players[2].hp+change
				local send={}
				send["pid"]=id
				send["hp"]=k.players[2].hp
				if k.players[2].hp<=0 then 
					send["type"]=MsgDef.ACKTYPE.GAME.GAMEOVER
					send["state"]=false--表示存活状态
				else
					send["type"]=MsgDef.ACKTYPE.GAME.REFRESHHP
				end
				local sendStr=cjson.encode(send)
				sendMsg2ClientByPid(k.players[1].pid,sendStr)
				sendMsg2ClientByPid(k.players[2].pid,sendStr)
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
