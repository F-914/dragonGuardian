--[[--
    时间管理器
    TimeManger.lua
]]
local TimeManger = {}

-- 延时调用
-- @params callback(function) 回调函数
-- @params time(float) 延时时间(s)
-- @return 定时器
function TimeManger:delayDoSomething(callback, time)
    local handle
    handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handle)
        callback()
    end, time, false)

    return handle
end

return TimeManger