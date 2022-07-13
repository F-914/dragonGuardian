local BaseLayer=require("src/app/ui/layer/BaseLayer.lua")
local MsgController=require("src/app/msg/MsgSendLayer.lua")
local MsgSendLayer=class("MsgSendLayer",require("src/app/ui/layer/BaseLayer.lua"))
function MsgSendLayer:onEnter()
    MsgController:registerListener(self,handler(self, self.handleMsg))
end
function MsgSendLayer:onExit()
    MsgController:unregisterListener(self)
end
function MsgSendLayer:handleMsg(msg)
    Log.i("MsgSendLayer","handleMsg() msg=",msg)
end
return MsgSendLayer