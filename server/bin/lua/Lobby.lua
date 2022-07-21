local cjson = require "cjson"
local Timer = require("lua.Timer")
local LogDef = require("lua.LogDef")
local MsgDef = require("lua.MsgDef")
local Player = require("lua.lobby.player")
local TestDataFactory = require("lua.util.TestDataFactory")
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
	local msg = cjson.decode(msgStr)
	print(msg.type)
	if (msg["type"] == MsgDef.REQTYPE.LOBBY.LOGIN) then
		playerLogin(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE) then
		cardAttributeChange(msg)
	elseif (msg["type"] == MsgDef.REQTYPE.LOBBY.ASSERT_CHANGE) then
		assetsChange(msg)
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

	local data = cjson.decode(data_str)
	local userInfo = data["userInfo"]
	userInfo.userInfoCoinAmount = msg.userInfo.userInfoCoinAmount
	userInfo.userInfoDiamondAmount = msg.userInfo.userInfoDiamondAmount
	--用户的数据
	local clientCardList = data.userInfo.userInfoCardList
	--来自消息的数据
	local msgCardList = msg.userInfo.userInfoCardList
	for i = 1, #msgCardList do
		if clientCardList[msgCardList[i].cardId] then
			clientCardList[msgCardList[i].cardId].cardAmount =
			clientCardList[msgCardList[i].cardId].cardAmount +
					msgCardList[i].cardAmount
		else
			table.insert(clientCardList, msgCardList[i].cardId, msgCardList[i])
		end
	end
	local saveData = cjson.encode(data)
	savePlayerDBData(id,saveData)
	msg["type"] = MsgDef.ACKTYPE.LOBBY.PURCHASE_COMMODITY
	sendMsg2ClientByPid(id, cjson.encode(msg))
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
	data.userInfo.userInfoBattleTeam = msg.userInfo.userInfoBattleTeam
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
	userInfo.userInfoCoinAmount = msg.userInfo.userInfoCoinAmount
	userInfo.userInfoDiamondAmount = msg.userInfo.userInfoDiamondAmount
	local clientCardList = data.userInfo.userInfoCardList
	local msgCardList = msg.userInfo.userInfoCardList
	for i = 1, #msgCardList do
		if clientCardList[msgCardList[i].cardId] then
			clientCardList[msgCardList[i].cardId].cardAmount =
			clientCardList[msgCardList[i].cardId].cardAmount +
					msgCardList[i].cardAmount
		else
			table.insert(clientCardList, msgCardList[i].cardId, msgCardList[i])
		end
	end
	local clientLadderList = data.userInfo.userInfoLadder.ladderList
	local msgLadderList = msg.userInfo.userInfoLadder.ladderList
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
	sendMsg2ClientByPid(id, cjson.encode(msg))
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
	local clientLadderList = data.userInfo.userInfoLadder.ladderList
	local trophyAmount = msg.userInfo.userInfoTrophyAmount
	data.userInfo.trophyAmount = trophyAmount
	for i = 1, #clientLadderList do
		if clientLadderList[i].trophyCondition < trophyAmount then
			clientLadderList[i].locked = false
		end
	end
	savePlayerDBData(id, cjson.encode(data))
	msg["type"] = MsgDef.ACKTYPE.LOBBY.TROPHY_CHANGE
	sendMsg2ClientByPid(id, cjson.encode(msg))
end
--[[--
	@description: 初始化用户信息
	以下三个初始化信息因为商店绑定用户的性质，其实可以合并
	三个同步消息同理，但是需要修改outGameData部分
	@param msg type:table, 网络消息
	@return none
]]
function initUserInfo(msg)
	print("enter init userInfo")
	local id, data_str = requestPlayerDBData(msg["loginName"])
	setPid2Sid(id, msg["sid"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		local data = {}
		data.userInfo = TestDataFactory:createUserInfo(msg.loginName)
		data.coinShop = TestDataFactory:createCoinShop()
		data.diamondShop = TestDataFactory:createDiamondShop()
		data.loginName = msg.loginName
		savePlayerDBData(id, cjson.encode(data))
		local back = {}
		back["type"] = MsgDef.ACKTYPE.LOBBY.USERINFO_INIT
		back["userInfo"] = data.userInfo
		sendMsg2ClientByPid(id, cjson.encode(back))
		print(id)
	else
		local data = cjson.decode(data_str)
		local back = {}
		back["type"] = MsgDef.ACKTYPE.LOBBY.USERINFO_INIT
		back["userInfo"] = data.userInfo
		print(id)
		sendMsg2ClientByPid(id, cjson.encode(back))
	end
end
function initCoinShop(msg)

	local id, data_str = requestPlayerDBData(msg["loginName"])
	setPid2Sid(id, msg["sid"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		local data = {}
		data.userInfo = TestDataFactory:createUserInfo(msg.loginName)
		data.coinShop = TestDataFactory:createCoinShop()
		data.diamondShop = TestDataFactory:createDiamondShop()
		data.loginName = msg.loginName
		savePlayerDBData(id, cjson.encode(data))
		local back = {}
		back["type"] = MsgDef.ACKTYPE.LOBBY.USERINFO_INIT
		back["userInfo"] = data.userInfo
		print(id)
		sendMsg2ClientByPid(id, cjson.encode(back))
	else
		local data = cjson.decode(data_str)
		local back = {}
		back["type"] = MsgDef.ACKTYPE.LOBBY.COINSHOP_INIT
		back["coinShop"] = data.coinShop
		print(id)
		sendMsg2ClientByPid(id, cjson.encode(back))
	end
end
function initDiamondShop(msg)
	local id, data_str = requestPlayerDBData(msg["loginName"])
	setPid2Sid(id, msg["sid"])
	if (data_str == nil or data_str == '') then
		__G__TRACKBACK__("PLAYER NOT EXIST")
		local data = {}
		data.userInfo = TestDataFactory:createUserInfo(msg.loginName)
		data.coinShop = TestDataFactory:createCoinShop()
		data.diamondShop = TestDataFactory:createDiamondShop()
		data.loginName = msg.loginName
		savePlayerDBData(id, cjson.encode(data))
		local back = {}
		back["type"] = MsgDef.ACKTYPE.LOBBY.USERINFO_INIT
		back["userInfo"] = data.userInfo
		print(id)
		sendMsg2ClientByPid(id, cjson.encode(back))
	else
		local data = cjson.decode(data_str)
		local back = {}
		back["type"] = MsgDef.ACKTYPE.LOBBY.DIAMONDSHOP_INIT
		back["diamondShop"] = data.diamondShop
		print(id)
		sendMsg2ClientByPid(id, cjson.encode(back))
	end
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