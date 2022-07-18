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
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.CARD_COLLECT) then
		collectCard(msg)(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.COIN_CHANGE) then
		coinChange(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.DIAMOND_CHANGE) then
		diamondChange(msg)
	
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.CARD_COLLECT) then
        	collectCard(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.USERINFO_DS) then
		userInfoDS(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.COINSHOP_DS)then
		coinShopDS(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.DIAMONDSHOP_DS) then
		diamondShopDS(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.DIAMONDSHOP_INIT) then
		initUserInfo(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.COINSHOP_INIT) then
		initCoinShop(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.USERINFO_INIT) then
		initDiamondShop(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.PURCHASE_COMMODITY) then
		purChaseCommodity(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.TROPHY_CHANGE) then
		trophyChange(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.MODIFY_BATTLETEAM) then
		modifyBattleTeam(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.RECEIVE_REWARD)then
		receiveReward(msg)	
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
    @description: 修改用户的金币
    @param msg 类型:json 要求msg必须含有loginName，userInfo，
	                     会回传一个确认消息permission，修改成功或者失败
    @return none
]]
function coinChange(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data=cjson.decode(data_str)
	if msg["userInfo"]==nil then
		__G__TRACKBACK__("USERINFO NOT EXIST")
		return
	end
    local coinamount=msg["userInfo"]["coinAmount"]
    data["userInfo"]["coinAmount"]=coinamount
	local saveData=cjson.encode(data)
	savePlayerDBData(id,saveData)

    local back={}
	back["permission"]="yes"
    back["type"]=MsgDef.ACKTYPE.LOBBY.COIN_CHANGE
	back["coinAmount"]= data["userInfo"]["coinAmount"]
	back["pid"]=id
	local backMsg=cjson.encode(back)
    sendMsg2ClientByPid(id, backMsg)
	
end
--[[
    @description: 修改用户的钻石
    @param msg 类型:json 要求msg必须含有loginName，userInfo，
	                     会回传一个确认消息permission，修改成功或者失败
    @return none
]]
function diamondChange(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data=cjson.decode(data_str)
	if msg["userInfo"]==nil then
		__G__TRACKBACK__("USERINFO NOT EXIST")
		return
	end
    local diamondamount=msg["userInfo"]["diamondAmount"]
    data["userInfo"]["diamondAmount"]=diamondamount
	local saveData=cjson.encode(data)
	savePlayerDBData(id,saveData)

    local back={}
	back["permission"]="yes"
    back["type"]=MsgDef.ACKTYPE.LOBBY.COIN_CHANGE
	back["diamondAmount"]= data["userInfo"]["diamondAmount"]
	back["pid"]=id
	local backMsg=cjson.encode(back)
    sendMsg2ClientByPid(id, backMsg)
	
end
--[[
    @description: 修改用户的奖杯
    @param msg 类型:json 要求msg必须含有loginName，userInfo，
	                     会回传一个确认消息permission，修改成功或者失败
    @return none
]]
function trophyChange(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data=cjson.decode(data_str)
	if msg["userInfo"]==nil then
		__G__TRACKBACK__("USERINFO NOT EXIST")
		return
	end
    local trophyamount=msg["userInfo"]["trophyAmount"]
    data["userInfo"]["trophyAmount"]=trophyamount
	local saveData=cjson.encode(data)
	savePlayerDBData(id,saveData)

    local back={}
	back["permission"]="yes"
    back["type"]=MsgDef.ACKTYPE.LOBBY.COIN_CHANGE
	back["trophyAmount"]= data["userInfo"]["trophyAmount"]
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
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end

	local data=cjson.decode(data_str)
	if(msg["userInfo"]["card"]==nil) then
		__G__TRACKBACK__("CARD NOT EXIST")
		return
    end
    table.insert(data["userInfo"]["collectedCardList"],msg["userInfo"]["card"])--此处可根据数据结构修改
	local saveData=cjson.encode(data)
    savePlayerDBData(id,saveData)
    
	local back={}
	back["type"]=MsgDef.ACKTYPE.LOBBY.CARD_COLLECT
    back["confirm"]="suc"
	back["collectedCardList"]=data["userInfo"]["collectedCardList"]
	
	local backMsg=cjson.encode(back)
	sendMsg2ClientByPid(id,backMsg)
end
--[[
    @description: 改变卡牌的属性
    @param msg 类型:json 要求msg必须含有三个成员loginName，order，attribute，update其中order是对应的卡牌序列，
	                attribute是需要修改的属性,update是变化后的值
    @return none
]]
function cardAttributeChange(msg)
    local id, data_str = requestPlayerDBData(msg["loginName"])
	
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
    if msg["userInfo"]==nil then
		__G__TRACKBACK__("USERINFO NOT EXIST")
		return
	end
	local data=cjson.decode(data_str)
	local order=msg["userInfo"]["order"]
	local attribute=msg["userInfo"]["attribute"]
	if(data["collectedCardList"][order]==nil) then
		__G__TRACKBACK__("CARD UNCOLLECTED")
		return
	elseif (data["collectedCardList"][order][attribute]==nil) then
		__G__TRACKBACK__("ATTRIBUTE NOT EXIST")
		return
	end
	data["collectedCardList"][order][attribute]=msg["userInfo"]["update"]

    local saveData=cjson.encode(data)
	savePlayerDBData(id,saveData)
    
	local back={}
	local userInfo={}
	userInfo["pid"]=id
	userInfo["type"]=MsgDef.ACKTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE
	userInfo["order"]=msg["order"]
	userInfo["attribute"]=msg["attribute"]
	userInfo["confirm"]=msg["suc"]
	back["userInfo"]=userInfo
	local backMsg=cjson.encode(back)

    sendMsg2ClientByPid(id, backMsg)
end
--[[--
	@description: 购买商品的同步数据部分
	@param msg  类型:table 由json字符串转化出来的字符串
	@return none
]]
function purChaseCommodity(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end

	local data=cjson.decode(data_str)
	local userInfo = data["userInfo"]
	userInfo.coinAmount = msg.userInfo.coinAmount
	userInfo.diamondAmount = msg.userInfo.diamondAmount
	local clientCardList = data.userInfo.cardList
	local msgCardList = msg.userInfo.cardList
	for i = 1, #msgCardList do
		local isExist = false
		for j = 1, #clientCardList do
			if msgCardList[i].cardId == clientCardList[j].cardId then
				isExist = true
				clientCardList[j].cardAmount = clientCardList[j].cardAmount +
						msgCardList[i].cardAmount
				break
			end
		end
		if not isExist then
			table.insert(clientCardList, msgCardList[i])
		end
	end
	local saveData = cjson.encode(data)
	savePlayerDBData(id,saveData)
	msg["type"] = MsgDef.ACKTYPE.LOBBY.PURCHASE_COMMODITY
	local backMsg = cjson.encode(msg)
	sendMsg2ClientByPid(id, backMsg)
end
--[[--
	@description: 修改队伍信息
	@param msg type:table, 网络消息
	@return none
]]
function modifyBattleTeam(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])

	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	data.userInfo.battleTeam = msg.userInfo.battleTeam
	savePlayerDBData(id, cjson.encode(data))
	msg["type"] = MsgDef.ACKTYPE.LOBBY.MODIFY_BATTLETEAM
	sendMsg2ClientByPid(id, cjson.encode(msg))
end
--[[--
	@description: 接受天梯奖励
	@param msg type:table, 网络消息
	@return none
]]
function receiveReward(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local userInfo = data["userInfo"]
	userInfo.coinAmount = msg.userInfo.coinAmount
	userInfo.diamondAmount = msg.userInfo.diamondAmount
	local clientCardList = data.userInfo.cardList
	local msgCardList = msg.userInfo.cardList
	for i = 1, #msgCardList do
		local isExist = false
		for j = 1, #clientCardList do
			if msgCardList[i].cardId == clientCardList[j].cardId then
				isExist = true
				clientCardList[j].cardAmount = clientCardList[j].cardAmount +
						msgCardList[i].cardAmount
				break
			end
		end
		if not isExist then
			table.insert(clientCardList, msgCardList[i])
		end
	end
	local clientLadderList = data.userInfo.ladder.ladderList
	local msgLadderList = data.userInfo.ladder.ladderList
	for i = 1, #msgLadderList do
		for j = 1, #clientLadderList do
			if msgLadderList[i].trophyCondition
					== clientLadderList[j].trophyCondition then
				clientLadderList[j].received = true
				break
			end
		end
	end
	savePlayerDBData(id, cjson.encode(data))
	msg["type"] = MsgDef.ACKTYPE.LOBBY.RECEIVE_REWARD
	sendMsg2ClientByPid(id, msg)
end
--[[--
	@description: 奖杯数量改变
	@param msg type:table, 网络消息
	@return none
]]
function trophyChange(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local clientLadderList = data.userInfo.ladder.ladderList
	local trophyAmount = msg.userInfo.trophyAmount
	data.userInfo.trophyAmount = trophyAmount
	for i = 1, #clientLadderList do
		if clientLadderList[i].trophyCondition > trophyAmount then
			clientLadderList[i].locked = true
		end
	end
	savePlayerDBData(id, cjson.encode(data))
	msg["type"] = MsgDef.ACKTYPE.LOBBY.TROPHY_CHANGE
	sendMsg2ClientByPid(id, msg)
end
--[[--
	@description: 初始化用户信息
	以下三个初始化信息因为商店绑定用户的性质，其实可以合并
	三个同步消息同理，但是需要修改outGameData部分
	@param msg type:table, 网络消息
	@return none
]]
function initUserInfo(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local back = {}
	back["type"] = MsgDef.ACKTYPE.LOBBY.USERINFO_INIT
	back["userInfo"] = data.userInfo
	sendMsg2ClientByPid(id, cjson.encode(back))
end
function initCoinShop(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local back = {}
	back["type"] = MsgDef.ACKTYPE.LOBBY.COINSHOP_INIT
	back["coinShop"] = data.coinShop
	sendMsg2ClientByPid(id, cjson.encode(back))
end
function initDiamondShop(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local back = {}
	back["type"] = MsgDef.ACKTYPE.LOBBY.DIAMONDSHOP_INIT
	back["diamondShop"] = data.diamondShop
	sendMsg2ClientByPid(id, cjson.encode(back))
end
function userInfoDS(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local back = {}
	back["type"] = MsgDef.ACKTYPE.LOBBY.USERINFO_DS
	back["userInfo"] = data.userInfo
	sendMsg2ClientByPid(id, cjson.encode(back))
end
function coinShopDS(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local back = {}
	back["type"] = MsgDef.ACKTYPE.LOBBY.COINSHOP_DS
	back["coinShop"] = data.coinShop
	sendMsg2ClientByPid(id, cjson.encode(back))
end
function diamondShopDS(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		return
	end
	local data = cjson.decode(data_str)
	local back = {}
	back["type"] = MsgDef.ACKTYPE.LOBBY.DIAMONDSHOP_DS
	back["diamondShop"] = data.diamondShop
	sendMsg2ClientByPid(id, cjson.encode(back))
end
xpcall(main, __G__TRACKBACK__)
