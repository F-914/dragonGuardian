--[[--
    登录界面
    LoginScene.lua
]]
local PATH_BG = "res/loading/background.jpg"
local PATH_EDITBOX_BASE = "res/battle_in_game/settlement/basemap_script.png"
local PATH_BUTTON_LOGIN = "res/home/general/second_general_popup/button_confirm.png"
local PATH_PROGRESS = "res/loading/progress_stretch.png"
local PATH_TTF_HZGBJW = "res/front/fzhzgbjw.ttf"
local MsgController = require("app.msg.MsgController")
local MsgDef = require("src/app/msg/MsgDef.lua")
local EventDef = require("src/app/def/EventDef.lua")
local EventManager = require("src/app/manager/EventManager.lua")
local LoadingLayer = require("src/app/ui/layer/LoadingLayer.lua")

local LoginScene =
    class(
    "LoginScene",
    function()
        return display.newScene("LoginScene")
    end
)
local progressSprite_ = display.newSprite(PATH_PROGRESS)
local TAG = "LoginScene"
local percent_
local ttf_ = {}
local ttfPercent_
local width_ = cc.Director:getInstance():getWinSize().width
function LoginScene:ctor()
    self.spriteWidth=progressSprite_:getContentSize().width
    self.spriteHeight=progressSprite_:getContentSize().height
    self:init()
    --self:createProgress()
end
function LoginScene:init()
    local height = cc.Director:getInstance():getWinSize().height
    local bg = display.newSprite(PATH_BG)
    bg:setScaleX(width_ / bg:getContentSize().width)
    bg:setScaleY(height / bg:getContentSize().height)
    self:add(bg)
    bg:setAnchorPoint(0.5, 0.5)
    bg:setPosition(display.cx, display.cy)

    local editbox = ccui.EditBox:create(cc.size(width_, height * 0.1), PATH_EDITBOX_BASE, 0)
    self:add(editbox)
    editbox:setPlaceHolder("请输入登录昵称")
    editbox:setAnchorPoint(0.5, 0.5)
    editbox:setPosition(width_ * 0.5, height * 0.7)
    editbox:setScale(0.8)
    editbox:setMaxLength(12)
   
    local loginButton = ccui.Button:create(PATH_BUTTON_LOGIN, PATH_BUTTON_LOGIN)
    self:add(loginButton)
    loginButton:setPressedActionEnabled(true)
    loginButton:setAnchorPoint(0.5, 0.5)
    loginButton:setPosition(width_ * 0.5, height * 0.5)
    loginButton:addClickEventListener(
        function(sender, eventType)
            local editboxTexture = editbox:getText()
            print(editboxTexture)
            local msg = {
                type = MsgDef.REQTYPE.LOBBY.LOGIN,
                loginName = editboxTexture
            }
            MsgController:sendMsg(msg)
            
            loginButton:setVisible(false)
            editbox:setVisible(false)
            self:createProgress()
        end
    )
end
--[[--
    描述：创造进度条的数字

    @param none

    @return none
]]
function LoginScene:createPercent()
    percent_ = 0
    ttf_.fontFilePath = PATH_TTF_HZGBJW
    ttf_.fontSize = 20
    ttfPercent_ = cc.Label:createWithTTF(ttf_, "0")

    self:add(ttfPercent_)
    ttfPercent_:setAnchorPoint(1, 0)
    ttfPercent_:setPosition(width_ - 10, 20)
    ttfPercent_:setColor(cc.c3b(255, 200, 0))
    EventManager:regListener(
        EventDef.LOGIN.LOADING_PROGRESS,
        self,
        function()
            percent_ = percent_ + 1
            ttfPercent_:setString(percent_ .. "%")
            if (percent_ == 100) then
                EventManager:unRegListener(EventDef.LOGIN.LOADING_PROGRESS, self)
                 --可以在此处写入切换主场景的代码，最好有延时
            end
        end
    )
end
--[[--
    描述：创造进度条
    @param none

    @return none
]]
function LoginScene:createProgress()
    local progress = LoadingLayer.new()
    self:add(progress)
    progress:setAnchorPoint(0.5, 0)
    print("progressSprite_"..progressSprite_:getContentSize().height)
    progress:setPosition(display.cx, self.spriteHeight * 0.5 - display.cy)
end
function LoginScene:handleMsg(msg)
    Log.i(TAG, "handleMsg() msg=", msg)
end
function LoginScene:onEnter()
end
function LoadingLayer:onExit()
    --EventManager:unRegListener(EventDef.LOGIN.LOADING_PROGRESS, self)
end
return LoginScene
