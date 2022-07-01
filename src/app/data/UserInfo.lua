--[[--
    UserInfo.lua
    用户信息
]]
UserInfo = {}

-- local
local ConstDef = require("app.def.ConstDef")
--

function UserInfo:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function UserInfo:getSingleton()
    if self.instance_ == nil then
        self.instance_ = self:new()
    end
    return self.instance_
end

function UserInfo:setUserInfo(account, nickname, coinAmount, diamondAmount)
    self.instance_.account_ = account
    self.instance_.nickname_ = nickname
    self.instance_.coinAmount_ = coinAmount
    self.instance_.diamondAmount_ = diamondAmount
end

function UserInfo:getAccount()
    return self.instance_.account_
end

function UserInfo:getNickname()
    return self.instance_.nickname_
end

function UserInfo:getCoinAmount()
    return self.instance_.coinAmount_
end

function UserInfo:getDiamondAmount()
    return self.instance_.diamondAmount_
end

return UserInfo