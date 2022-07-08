--[[--
    用于注册监听器使用，
    该监听器是msgController接受到消息调用的监听器
    依据不同的消息类型执行不同的事件
]]
local MsgDef = {
    --key == number
    --以下事件均为测试用
    TEST_MSG_DEF = -1,
    INIT_USERINFO = 1,
}
return MsgDef