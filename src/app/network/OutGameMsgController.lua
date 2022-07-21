--[[--
    消息控制器
    OutGameMsgController.lua
]]
local OutGameMsgController = {}
local SimpleTCP = require("framework.SimpleTCP")
local json = require("framework.json")
local ByteArray = require("app.network.ByteArray")
local Log = require("app.utils.Log")

local TAG = "OutGameMsgController"
local handleMessage
local socket_
local listenerMap_ = {}
local isConnected_ = false
--[[--
    @description: 初始化函数
    @param serviceIP type:string ip地址
    @param servicePort type:number, 端口
    @param heartBeatInterval type:number 心脏跳动间隔
]]
function OutGameMsgController:init(serviceIP, servicePort, heartBeatInterval)
    self.serviceIP_ = serviceIP
    self.servicePort_ = servicePort
    self.heartBeatInterval_ = heartBeatInterval
end

--[[--
    @description: 连接至服务器

]]
function OutGameMsgController:connect()
    if isConnected_ or socket_ then
        Log.w(TAG, "already connected")
        return
    end
    Log.i("IP: " .. tostring(self.serviceIP_))
    socket_ = SimpleTCP.new(self.serviceIP_, self.servicePort_, handleMessage)
    socket_:connect()
end

--[[--
    @description: 断开连接
]]
function OutGameMsgController:disConnect()
    if not isConnected_ or not socket_ then
        return
    end
    socket_:close()
    socket_ = nil
    isConnected_ = false
end

--[[--
    @description: 确认连接状态
]]
function OutGameMsgController:isConnect()
    return isConnected_
end

--[[--
    @description: 发送消息到服务器
    @param msg type:table 需要发送的数据
    @return type: bool, 发送消息成功或者失败
]]
function OutGameMsgController:sendMsg(msg)
    if not isConnected_ or not socket_ then
        Log.w(TAG, "socket is not connect")
        return false
    end

    local js = json.encode(msg or {})
    local ba = ByteArray.new()
    ba:setPos(1)
    ba:writeInt(#js)
    ba:writeStringBytes(js)
    socket_:send(ba:getPack())
    return true
end

--[[--
    @description:接受消息，分发事件
    @param event type:string 消息的类型
    @param data type:bool[], 返回的数据的二进制文件，如果该数据没有key关键字
    则无法分发事件,所以需要确保接受的数据有key
]]
function handleMessage(event, data)
    if event == SimpleTCP.EVENT_CONNECTING then
        Log.w(TAG, "connecting")
    elseif event == SimpleTCP.EVENT_CONNECTED then
        Log.w(TAG, "connected")
        isConnected_ = true
        require("app.data.OutGameData"):eventTriggerInit()
    elseif event == SimpleTCP.EVENT_FAILED then
        Log.w(TAG, "connect failed")
        isConnected_ = false
    elseif event == SimpleTCP.EVENT_CLOSED then
        Log.w(TAG, "connect closed")
        isConnected_ = false
    elseif event == SimpleTCP.EVENT_DATA then
        if data then
            local ba = ByteArray.new()
            ba:writeBuf(data)
            ba:setPos(1)
            local len = ba:readInt()
            local msg = json.decode(ba:readStringBytes(len))
            if msg.type and listenerMap_[msg.type] then
                listenerMap_[msg.type](msg)
            end
        end
    else
        Log.e(TAG, "error ")
    end

end

--[[--
    @description: 注册监听
    @param key type: 表示接收到的消息的类型，是常量，在MsgDef中定义
    @param listener type:function, 事件
]]
function OutGameMsgController:registerListener(key, listener)
    if not key or not listener then
        Log.e(TAG, "key or listener may be nullptr")
        return
    end
    if listenerMap_[key] then
        Log.w(TAG, "key already exist")
        return
    end
    listenerMap_[key] = listener
end

--[[--
    @description: 注销事件
    @param key type: 表示接收到的消息的类型，是常量，在MsgDef中定义
]]
function OutGameMsgController:unRegisterListener(key)
    if not key then
        Log.w(TAG, "key is nil")
        return
    end
    listenerMap_[key] = nil
end

return OutGameMsgController
