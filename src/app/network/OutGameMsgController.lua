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
    self.socket_ = nil
    self.isConnected_ = false
    self.listenerMap_ = {}
end

--[[--
    @description: 连接至服务器

]]
function OutGameMsgController:connect()
    if self.isConnected_ or self.socket_ then
        Log.w(TAG, "already connected")
        return
    end
    Log.i("IP: " .. tostring(self.serviceIP_))
    self.socket_ = SimpleTCP.new(self.serviceIP_, self.servicePort_, self.handleMessage)
    self.socket_:connect()
    self.isConnected_ = true
end

--[[--
    @description: 断开连接
]]
function OutGameMsgController:disConnect()
    if not self.isConnected_ or not self.socket_ then
        return
    end
    self.socket_:close()
    self.socket_ = nil
    self.isConnected_ = false
end

--[[--
    @description: 确认连接状态
]]
function OutGameMsgController:isConnect()
    return self.isConnected_
end

--[[--
    @description: 发送消息到服务器
    @param msg type:table 需要发送的数据
    @return type: bool, 发送消息成功或者失败
]]
function OutGameMsgController:sendMsg(msg)
    if not self.isConnected_ or not self.socket_ then
        Log.w(TAG, "socket is not connect")
        return false
    end

    local js = json.encode(msg or {})
    local ba = ByteArray.new()
    ba:setPos(1)
    ba:writeInt(#js)
    ba:writeStringBytes(js)
    self.socket_:send(ba:getPack())
    return true
end

--[[--
    @description:接受消息，分发事件
    @param event type:string 消息的类型
    @param data type:bool[], 返回的数据的二进制文件，如果该数据没有key关键字
    则无法分发事件,所以需要确保接受的数据有key
]]
function OutGameMsgController:handleMessage(event, data)
    if event == SimpleTCP.EVENT_CONNECTING then
        Log.w(TAG, "connecting")
    elseif event == SimpleTCP.EVENT_CONNECTED then
        Log.w(TAG, "connected")
    elseif event == SimpleTCP.EVENT_FAILED then
        Log.w(TAG, "connect failed")
    elseif event == SimpleTCP.EVENT_CLOSED then
        Log.w(TAG, "connect closed")
    elseif event == SimpleTCP.EVENT_DATA then
        if data then
            local ba = ByteArray.new()
            ba:writeBuf(data)
            ba:setPos(1)
            local len = ba:readInt()
            local msg = json.decode(ba:readStringBytes(len))

            ---每一个返回的消息应该有type(可能与属性重复们可以改成其他的)字段,用于回调函数
            if msg.type and self.listenerMap_[msg.type] then
                self.listenerMap_[msg.type](msg)
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
    if self.listenerMap_[key] then
        Log.w(TAG, "key already exist")
        return
    end
    self.listenerMap_[key] = listener
end

--[[--
    @description: 注销事件
    @param key type: 表示接收到的消息的类型，是常量，在MsgDef中定义
]]
function OutGameMsgController:unRegisterListener(key)
    if not key then
        Log.w(TAG, "key is nil")
    end
    self.listenerMap_[key] = nil
end

return OutGameMsgController
