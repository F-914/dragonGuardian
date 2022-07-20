require("config")
require("cocos.init")
require("framework.init")

local AppBase = require("framework.AppBase")
local MyApp = class("MyApp", AppBase)
EnemyBattleTeam_ = nil
EnemyHp_=nil
EnemyNick_=nil
EnemyPid_=nil
Pid_ = nil
Serial_=nil
function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    -- self:enterScene("InGameScene")
    self:enterScene("OutGameScene")
end

return MyApp
