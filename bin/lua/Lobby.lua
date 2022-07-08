local cjson = require "cjson"
local Timer = require("lua.Timer")
local LogDef = require("lua.LogDef")
local MsgDef = require("lua.MsgDef")
local Player = require("lua.lobby.player")
--local fun=require("F:/server/bin/lua/util/functions.lua")

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
--[[
    @description: 注册函数
    @param msg 类型:json 要求msg必须含有loginName，pid,
    @return none
]]
function playerLogin(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	--init player with db data
	print("get player db data")
	print(data_str)
	if (data_str == nil or data_str == '') then
		local saveData = {}
	    saveData["pid"] = id
		saveData["nick"] = msg["loginName"]
	    data_str = cjson.encode(saveData)
		savePlayerDBData(id, data_str)
		print(data_str)
	end
	local data = cjson.decode(data_str)
	setPid2Sid(data["pid"], msg["sid"])
	newPlayer = Player.new()
	newPlayer:setPid(data["pid"])
	newPlayer:setSid(msg["sid"])
	newPlayer:setNick(data["nick"])
	newPlayer:setLoginName(msg["loginName"])

	local logInfo = tostring(id) .. " login succ"
	print(logInfo)
	qlog(LogDef.CHANNEL.DEBUG, logInfo)

	sendLoginAck2Client(data)
end
--function startGame(msg)
--	print("start game lobby")
--	sendStartGameReq2Game(msg["playerid"], msg["nick"], msg["hp"])
--end
--[[
    @description: 返回注册成功消息的函数
    @param msg 类型:json 要求data必须含有nick，pid,
    @return none
]]
function sendLoginAck2Client(data)
	local ack = {};
	ack["type"] = MsgDef.ACKTYPE.LOBBY.LOGIN
	ack["pid"] = data["pid"]
	ack["nick"] = data["nick"]
	local retMsg = cjson.encode(ack)
	sendMsg2ClientByPid(ack["pid"], retMsg)
end

--function sendStartGameReq2Game(pid, nick, hp)
--	local req = {}
--	req["type"] = MsgDef.REQTYPE.GAME.CREATEGAME
--	req["pid"] = pid
--	req["nick"] = nick
--	req["hp"] = hp
--	local retMsg = cjson.encode(req)
--	sendMsg2Game(retMsg)
--end
function initLobbyModule()
	--init lobby module here
	print("init lobby module succ!!")
	slog("./log/start_info", "init lobby module succ")
end


function processLobbyMsg()
	
	local msgStr = recvLobbyMsg()
	if (msgStr == nil or msgStr == '') then
		return
	end
	--print("send to Lobby")
	local msg = cjson.decode(msgStr)
	--local file=io.open("bin/lua/data.json", "a+")
    --file:write(msgStr)
	--io.close()
	--print(msg["type"])
	--print(MsgDef.REQTYPE.STARTGAME)
	if (msg["type"] == MsgDef.REQTYPE.LOBBY.LOGIN) then
		playerLogin(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE) then
		cardAttributeChange(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.ASSERT_CHANGE) then
		assetsChange(msg)
		
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.CARD_COLLECT) then
        collectCard(msg)
	end
end

function update()
	--main loop
	processLobbyMsg()
	--other logic update
end

function main()
	initLobbyModule()
	local loopTimer = Timer.new()
	loopTimer:beginTimer(50)
	while true do
		if loopTimer:countingTimer() then
			update()
		end
		msSleep(1)
	end
end
--[[
    @description: 修改用户的金币/钻石
    @param msg 类型:json 要求msg必须含有loginName，assert，change，其中assert是钻石或者金币，change是变动的数值，该函数
	                     会回传一个确认消息permission，修改成功或者失败
    @return none
]]
function assetsChange(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("该玩家不存在")
		return
	end
	local data=cjson.decode(data_str)
	if data[msg["assert"]]==nil then
		__G__TRACKBACK__("属性名称错误")
		return
	end


    local assert=data[msg["assert"]]
	local change=msg["change"]
	local back={}
	if(assert+change>=0) then 
		data[msg["asset"]]=assert+change
		back["permission"]="yes"
		
	else
		back["permission"]="no"
	end
	local saveData=cjson.encode(data)
	savePlayerDBData(id,saveData)
    
    back["type"]=MsgDef.ACKTYPE.LOBBY.ASSERT_CHANGE
	back["afterchange"]=data[msg["assert"]]
	back["assert"]=msg["assert"]
	back["pid"]=id
	local backMsg=cjson.encode(back)
    sendMsg2ClientByPid(id, backMsg)
	
end
--[[
    @description: 添加卡牌到已收集的队列中
    @param msg 类型:json 该消息必须含有对象loginName来获取用户资料，必须含有卡牌对象card,
	                     返回type=MsgDef.ACKTYPE.CARD_COLLECT确认消息
    @return none
]]
function collectCard(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("该玩家不存在")
		return
	end

	local data=cjson.decode(data_str)
	if(msg["card"]==nil) then
		__G__TRACKBACK__("卡片信息不存在")
		return
    end
    table.insert(data["COLLECTED"],msg["card"])--此处可根据数据结构修改
	local saveData=cjson.encode(data)
    savePlayerDBData(id,saveData)
    
	local back={}
	back["type"]=MsgDef.ACKTYPE.LOBBY.CARD_COLLECT
    back["confirm"]="suc"
	back["collect"]=data["COLLECTED"]
	back["pid"]=id
	local backMsg=cjson.encode(back)
	sendMsg2ClientByPid(id,backMsg)
end
--[[
    @description: 改变卡牌的属性
    @param msg 类型:json 要求msg必须含有三个成员loginName，order，attribute，change其中order是对应的卡牌序列，
	                attribute是需要修改的属性,change是变化的值
    @return none
]]
function cardAttributeChange(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])
	
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end

	local data=cjson.decode(data_str)
	local order=msg["order"]
	local attribute=msg["attribute"]
	local change=msg["change"]
	if(data["COLLECTED"][order]==nil) then
		__G__TRACKBACK__("CARD UNCOLLECTED")
		return
	elseif (data["COLLECTED"][order][attribute]==nil) then
		__G__TRACKBACK__("ATTRIBUTE NOT EXIST")
		return
	end
	data["COLLECTED"][order][attribute]=change+data["COLLECTED"][order][attribute]

    local saveData=cjson.encode(data)
	savePlayerDBData(id,saveData)
    
	local back={}
	back["pid"]=id
	back["type"]=MsgDef.ACKTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE
	back["order"]=msg["order"]
	back["attribute"]=msg["attribute"]
	back["afterchange"]=data["COLLECTED"][order][attribute]
	local backMsg=cjson.encode(back)
    sendMsg2ClientByPid(id, backMsg)
end

xpcall(main, __G__TRACKBACK__)