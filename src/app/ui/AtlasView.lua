--[[--
    创建图鉴界面
    AtlasView
]]
local AtlasView = class(
    "AtlasView",
    function()
        return display.newColorLayer(cc.c4b(0, 0, 0, 0))
    end
)
--
local PATH_BASEMAP_TITLE = "res/home/guide/subinterface_current_lineup/base_title.png"
local PATH_BASEMAP_AREA = "res/home/guide/subinterface_current_lineup/base_area.png"
local PATH_NUMBER_1 = "res/home/guide/subinterface_current_lineup/one.png"
local PATH_NUMBER_2 = "res/home/guide/subinterface_current_lineup/two.png"
local PATH_NUMBER_3 = "res/home/guide/subinterface_current_lineup/three.png"
local PATH_TEXTURE_NOWLINEUP = "res/home/guide/subinterface_current_lineup/text_current_lineup.png"
local PATH_BASEMAP_CONNECTION = "res/home/guide/subinterface_current_lineup/base_lineup.png"
local PATH_ICON_CHOOSE = "res/home/guide/subinterface_current_lineup/icon_selected.png"
local PATH_ICON_UNCHOOSE = "res/home/guide/subinterface_current_lineup/icon_unselected.png"
local PATH_BASEMAP_TIP = "res/home/guide/subinterface_tips/base_tips.png"
local PATH_TEXTURE_LONG = "res/home/guide/subinterface_tips/text_tips.png"
local PATH_TEXTURE_SHORT = "res/home/guide/subinterface_tips/text_total_critical_strike_damage.png"
local PATH_SPLITLINE_COLLECTED = "res/home/guide/subinterface_tower_list/split_collected.png"
local PATH_SPLITLINE_UNCOLLECTED = "res/home/guide/subinterface_tower_list/split_not_collected.png"
--
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local MsgController=require("src/app/msg/MsgController.lua")
local EventManager = require("app.manager.EventManager")
local OutGameData = require("app.data.OutGameData")
local MsgDef=require("src/app/def/MsgDef.lua")

--local AnimationLayer=require("src/app/ui/layer/AnimationLayer")
local TowerDetialLayer = require("app.ui.layer.TowerDetialLayer2nd")
local BackgroundLayer = require("app.ui.layer.BackgroundLayer")
local LineupLayer = require("app.ui.layer.LineupLayer")
local BagLayer = require("app.ui.layer.BagLayer")
local PopupLayer = require("app.ui.layer.PopupLayer2nd")
--
local BagList_ = nil --以下6个都是为了实现类的交互而设置的文件内局部变量
local collected_
local uncollected_
local lineup1_
local lineup2_
local lineup3_ --
--[[--
    封装创造checkbox的函数

    @param parents 类型：Any，父节点
    @param number 类型：Any，获取图片的路径

    @return none
]]
local function createCheckbox(parents, number)
    local checkbox = ccui.CheckBox:create(PATH_ICON_UNCHOOSE, PATH_ICON_CHOOSE, PATH_ICON_CHOOSE, PATH_ICON_UNCHOOSE,
        PATH_ICON_UNCHOOSE)
    parents:add(checkbox)
    checkbox:setTouchEnabled(true)
    checkbox:setAnchorPoint(0.5, 0.5)
    local path
    if number == 1 then
        path = PATH_NUMBER_1
    elseif number == 2 then
        path = PATH_NUMBER_2
    elseif number == 3 then
        path = PATH_NUMBER_3
    end

    local spriteNumber = display.newSprite(path)
    checkbox:add(spriteNumber)
    spriteNumber:setAnchorPoint(0.5, 0.5)
    spriteNumber:setPosition(checkbox:getContentSize().width * 0.5, checkbox:getContentSize().height * 0.5)
    return checkbox
end

--[[--
    @description:构造方法
    @param none
    @return none
]]
function AtlasView:ctor()
    local function clickListener()
        --注册每0.1秒监听的函数，用于检测点击时间
        local order = ConstDef.BUTTON_CLICK[1]
        if #(ConstDef.BUTTON_CLICK) == 0 then
            return
        else
            local card = nil
            for v, k in ipairs(collectedList) do
                --此处collectedList不能直接使用，需要换为用户拥有的已收集列表
                if k.order == order then
                    card = collectedList[v]
                end
            end

            local tower = TowerDetialLayer.new(card, collected_)
            self:add(tower)
            tower.use:addTouchEventListener(function(sender, eventType)
                --注册塔的详情中，“使用”按钮的点击事件
                if eventType == 2 then
                    local popup = PopupLayer.new(order)
                    self:add(popup)
                    popup:setPosition(0, 0)
                    tower:setVisible(false)
                    tower:removeFromParent()

                    for i = 1, 5 do
                        --将当前阵容队列中的图标设置为可点击
                        lineup1_.button[i]:setTouchEnabled(true)
                        lineup2_.button[i]:setTouchEnabled(true)
                        lineup3_.button[i]:setTouchEnabled(true)
                    end
                    lineup1_:setOrder(order)
                    lineup2_:setOrder(order)
                    lineup3_:setOrder(order)
                    lineup1_:setPopup(popup)
                    lineup2_:setPopup(popup)
                    lineup3_:setPopup(popup)
                    lineup1_:setLineupOrder(1)
                    lineup2_:setLineupOrder(2)
                    lineup3_:setLineupOrder(3)

                    EventManager:doEvent(EventDef.ID.HIDE_BAG)
                    popup.cancel:addTouchEventListener(function(sender, eventType)
                        if eventType == 2 then

                            popup:setVisible(false)
                            popup:removeFromParent()

                            EventManager:doEvent(EventDef.ID.SHOW_BAG)
                            EventManager:doEvent(EventDef.ID.RESUME_BAG_BUTTON)

                        end
                    end)

                    table.remove(ConstDef.BUTTON_CLICK, 1)
                    for i = 1, #(BagList_) do
                        --将图鉴中的塔设置为不可点击
                        BagList_[i]:setTouchEnabled(false)
                    end
                end
            end)
        end
    end

    self:initView()
    self:registerScriptHandler(
        function(event)
            if event == "enter" then
                self:onEnter()
            elseif event == "exit" then
                self:onExit()
            end
        end
    )
    EventManager:regListener(EventDef.ID.RESUME_BAG_BUTTON, self, function()
        --注册恢复图鉴中的塔为可点击
        for i = 1, #(BagList_) do
            BagList_[i]:setTouchEnabled(true)
        end

        for i = 1, 5 do
            lineup1_.button[i]:setTouchEnabled(false)
            lineup2_.button[i]:setTouchEnabled(false)
            lineup3_.button[i]:setTouchEnabled(false)
        end
    end)
    self.clickScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(clickListener, 0.1, false) --通过scheduler监听函数
end

--[[--
    初始化的函数
    @return none
]]
function AtlasView:initView()
    self.backgourndLayer_ = BackgroundLayer.new()
    self:add(self.backgourndLayer_)
    self.containerForLineup_ = nil
end

--[[--
    创造位于图鉴界面上方的可切换阵容队列的函数
    @return none
]]
function AtlasView:createLineupList()
    local lineupLayout = display.newSprite(PATH_BASEMAP_AREA) --创造存放整个板块的layout
    self:add(lineupLayout)
    lineupLayout:setScale(0.8)
    lineupLayout:setAnchorPoint(0.5, 0.5)
    lineupLayout:setPosition(display.cx, display.cy * 1.6)
    local basemapTitle = display.newSprite(PATH_BASEMAP_TITLE)
    lineupLayout:add(basemapTitle)
    basemapTitle:setAnchorPoint(0.5, 0.5)
    basemapTitle:setScale(lineupLayout:getContentSize().width / basemapTitle:getContentSize().width)
    basemapTitle:setPosition(lineupLayout:getContentSize().width * 0.5, lineupLayout:getContentSize().height)
    local basemapNowLineup = display.newSprite(PATH_TEXTURE_NOWLINEUP)
    basemapTitle:add(basemapNowLineup)
    basemapNowLineup:setAnchorPoint(0.5, 0.5)
    basemapNowLineup:setPosition(basemapTitle:getContentSize().width * 0.3, basemapTitle:getContentSize().height * 0.5)
    local basemapConnection = display.newSprite(PATH_BASEMAP_CONNECTION)
    basemapTitle:add(basemapConnection)
    basemapConnection:setAnchorPoint(0.5, 0.5)
    basemapConnection:setPosition(basemapTitle:getContentSize().width * 0.65, basemapTitle:getContentSize().height * 0.5) --

    local checkbox1 = createCheckbox(basemapConnection, 1) --创造三个checkbox用于切换当前阵容
    checkbox1:setPosition(0, basemapConnection:getContentSize().height * 0.5)
    local checkbox2 = createCheckbox(basemapConnection, 2)
    checkbox2:setPosition(basemapConnection:getContentSize().width * 0.5, basemapConnection:getContentSize().height * 0.5)
    local checkbox3 = createCheckbox(basemapConnection, 3)
    checkbox3:setPosition(basemapConnection:getContentSize().width, basemapConnection:getContentSize().height * 0.5)

    local pageView = ccui.PageView:create() --创造pageview
    lineupLayout:add(pageView)
    pageView:setContentSize(lineupLayout:getContentSize().width, 150)
    pageView:setTouchEnabled(false)
    pageView:setAnchorPoint(0, 0)
    pageView:setPosition(lineupLayout:getContentSize().width * 0.025, lineupLayout:getContentSize().height * 0.05)

    local layout1 = ccui.Layout:create() --创造pageview的三个页面
    local lineup1 = LineupLayer.new(ConstDef.LINEUP_LIST.lineupOne)
    lineup1_ = lineup1
    layout1:add(lineup1)
    layout1:setContentSize(lineupLayout:getContentSize().width, lineupLayout:getContentSize().height)
    pageView:addPage(layout1)
    local layout2 = ccui.Layout:create()
    local lineup2 = LineupLayer.new(ConstDef.LINEUP_LIST.lineupTwo)
    lineup2_ = lineup2
    layout2:add(lineup2)
    layout2:setContentSize(lineupLayout:getContentSize().width, lineupLayout:getContentSize().height)
    pageView:addPage(layout2)
    local layout3 = ccui.Layout:create()
    local lineup3 = LineupLayer.new(ConstDef.LINEUP_LIST.lineupThree)
    lineup3_ = lineup3
    layout3:add(lineup3)
    layout3:setContentSize(lineupLayout:getContentSize().width, lineupLayout:getContentSize().height)
    pageView:addPage(layout3)

    checkbox1:setSelected(true) --创造三个checkbox实现阵容切换
    checkbox1:setTouchEnabled(false)
    checkbox2:setSelected(false)
    checkbox3:setSelected(false)
    local function onChangedCheckbox(sender, eventType)
        --使得pageview根据checkbox进行滑动的函数
        if sender == checkbox1 then
            pageView:scrollToPage(0)
            checkbox2:setSelected(false)
            checkbox3:setSelected(false)
            checkbox1:setTouchEnabled(false)
            checkbox2:setTouchEnabled(true)
            checkbox3:setTouchEnabled(true)
        elseif sender == checkbox2 then
            pageView:scrollToPage(1)
            checkbox1:setSelected(false)
            checkbox3:setSelected(false)
            checkbox2:setTouchEnabled(false)
            checkbox1:setTouchEnabled(true)
            checkbox3:setTouchEnabled(true)
        elseif sender == checkbox3 then
            pageView:scrollToPage(2)
            checkbox1:setSelected(false)
            checkbox2:setSelected(false)
            checkbox3:setTouchEnabled(false)
            checkbox1:setTouchEnabled(true)
            checkbox2:setTouchEnabled(true)
        end
    end

    checkbox1:addEventListener(onChangedCheckbox)
    checkbox2:addEventListener(onChangedCheckbox)
    checkbox3:addEventListener(onChangedCheckbox)
end

--[[--
    创造位于图鉴界面中下方的已收集塔和未收集塔
    @return none
]]
function AtlasView:createBag()
    local test = display.newSprite(ConstDef.ICON_LIST[1]) --获取单个塔图标，便于获取大小
    local tipBackground = display.newSprite(PATH_BASEMAP_TIP)
    tipBackground:setScale(0.8)
    local layoutTexture = ccui.Layout:create()
    layoutTexture:setContentSize(tipBackground:getContentSize().width, tipBackground:getContentSize().height)
    layoutTexture:setAnchorPoint(0.5, 0.5)
    layoutTexture:add(tipBackground)
    --layoutTexture:setContentSize(listView:getContentSize().width,tipBackground:getContentSize().height*0.8+splitLineCollected:getContentSize().height*(display.cx*2/splitLineCollected:getContentSize().width))
    tipBackground:setAnchorPoint(0.5, 1)
    tipBackground:setPosition(layoutTexture:getContentSize().width * 0.5, layoutTexture:getContentSize().height)
    local textureLong = display.newSprite(PATH_TEXTURE_LONG)
    tipBackground:add(textureLong)
    textureLong:setAnchorPoint(0.5, 0.5)
    textureLong:setPosition(tipBackground:getContentSize().width * 0.5,
        tipBackground:getContentSize().height * 0.25)
    local textureShort = display.newSprite(PATH_TEXTURE_SHORT)
    tipBackground:add(textureShort)
    textureShort:setAnchorPoint(0.5, 0.5)
    textureShort:setPosition(tipBackground:getContentSize().width * 0.4,
        tipBackground:getContentSize().height * 0.75)

    local heightUncollect, heightCollect --计算已收集和未收集分别需要多少行
    if #(ConstDef.COLLECTED) == 0 then
        heightCollect = 1
    elseif #(ConstDef.COLLECTED) % 4 == 0 then
        heightCollect = #(ConstDef.COLLECTED) / 4
    elseif #(ConstDef.COLLECTED) % 4 ~= 0 then
        heightCollect = math.floor(#(ConstDef.COLLECTED) / 4) + 1
    end

    if #(ConstDef.UNCOLLECTED) == 0 then
        heightUncollect = 1
    elseif #(ConstDef.UNCOLLECTED) % 4 == 0 then
        heightUncollect = #(ConstDef.UNCOLLECTED) / 4
    elseif #(ConstDef.UNCOLLECTED) % 4 ~= 0 then
        heightUncollect = math.floor(#(ConstDef.UNCOLLECTED) / 4) + 1
    end

    local splitLineCollected = display.newSprite(PATH_SPLITLINE_COLLECTED) --已收集的分割线
    collected_ = BagLayer.new(ConstDef.COLLECTED, "collected")
    BagList_ = collected_.list
    local layoutCollect = ccui.Layout:create() --将已收集分割线和已收集的塔放在一个layout
    layoutCollect:setPosition(display.cx, display.cy)
    layoutCollect:setAnchorPoint(0.5, 1)
    layoutCollect:setContentSize(display.cx * 2,
        heightCollect * test:getContentSize().height * ConstDef.scale_ +
        heightCollect * test:getContentSize().height * 0.2 * ConstDef.scale_ +
        splitLineCollected:getContentSize().height * (display.cx * 2 / splitLineCollected:getContentSize().width))
    splitLineCollected:setScale(display.cx * 2 / splitLineCollected:getContentSize().width)
    splitLineCollected:setAnchorPoint(0, 1)
    splitLineCollected:setPosition(0, layoutCollect:getContentSize().height)
    layoutCollect:add(collected_)
    collected_:setPosition(layoutCollect:getContentSize().width * 0.5, layoutCollect:getContentSize().height)
    --collected:setContentSize(collected:getContentSize().width,layoutCollect:getContentSize().height)

    layoutCollect:add(splitLineCollected)
    local layoutUncollect = ccui.Layout:create()
    local splitLineUncollected = display.newSprite(PATH_SPLITLINE_UNCOLLECTED) --未收集的分割线
    uncollected_ = BagLayer.new(ConstDef.UNCOLLECTED, "uncollected") --将未收集分割线和未收集的塔放在一个layout
    layoutUncollect:setAnchorPoint(0.5, 1)
    layoutUncollect:setContentSize(display.cx * 2,
        splitLineUncollected:getContentSize().height * (display.cx * 2 / splitLineUncollected:getContentSize().width) +
        heightUncollect * test:getContentSize().height * 0.1 * ConstDef.scale_ +
        splitLineUncollected:getContentSize().height * (display.cx * 2 / splitLineUncollected:getContentSize().width)
        + heightUncollect * test:getContentSize().height * ConstDef.scale_)
    layoutUncollect:add(splitLineUncollected)
    splitLineUncollected:setScale(display.cx * 2 / splitLineUncollected:getContentSize().width)
    splitLineUncollected:setAnchorPoint(0, 1)
    splitLineUncollected:setPosition(0, layoutUncollect:getContentSize().height)
    layoutUncollect:add(uncollected_)
    uncollected_:setPosition(layoutUncollect:getContentSize().width * 0.5, layoutUncollect:getContentSize().height)

    local listView = ccui.ListView:create() --创建listview
    self:add(listView)
    listView:setDirection(ccui.ListViewDirection.vertical)
    listView:setContentSize(display.cx * 2, display.cy * 1.4)
    listView:setAnchorPoint(0.5, 1)
    listView:setPosition(display.cx, display.cy * 1.4)
    listView:add(layoutTexture)
    listView:add(layoutCollect)
    listView:add(layoutUncollect)

    EventManager:regListener(EventDef.ID.HIDE_BAG, self, function()
        --注册隐藏图鉴
        layoutCollect:setVisible(false)
        layoutUncollect:setVisible(false)
    end)
    EventManager:regListener(EventDef.ID.SHOW_BAG, self, function()
        --注册显示图鉴
        layoutCollect:setVisible(true)
        layoutUncollect:setVisible(true)
    end)

end

--[[--
    @description:进入node调用的函数
    @param none
    @return none
]]
function AtlasView:onEnter()
    EventManager:regListener(EventDef.ID.CARD_USE,self,function(index)
        
        local msg={
        loginName=OutGameData:getUserInfo():getNickname(),
        teamIndex=index,
        team=OutGameData:getUserInfo():getBattleTeam():getIndexTeam(index),
        type=MsgDef.REQTYPE.LOBBY.CARD_USE
       }
       MsgController:sendMsg(msg)
    end)
    EventManager:regListener(EventDef.ID.CARD_INTENSIFY,self,function (cardId)
        local msg={
            loginName=OutGameData:getUserInfo():getNickname(),
            card=OutGameData:getUserInfo():getCardList()[cardId],
            type=MsgDef.REQTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE
           }
           MsgController:sendMsg(msg)
    end)
    EventManager:regListener(EventDef.ID.CARD_UPGRADE,self,function (cardId)
        local msg={
            loginName=OutGameData:getUserInfo():getNickname(),
            card=OutGameData:getUserInfo():getCardList()[cardId],
            type=MsgDef.REQTYPE.LOBBY.CARD_ATTRIBUTE_CHANGE
           }
           MsgController:sendMsg(msg)
    end)

    self:createLineupList()
    self:createBag()
end

--[[--
    @description:退出node调用的函数
    @param none
    @return none
]]
function AtlasView:onExit()
    --退出时注销注册的事件
    
    EventManager:unRegListener(EventDef.ID.CARD_USE, self)
    EventManager:unRegListener(EventDef.ID.CARD_INTENSIFY, self)
    EventManager:unRegListener(EventDef.ID.CARD_UPGRADE, self)

    EventManager:unRegListener(EventDef.ID.SHOW_BAG, self)
    EventManager:unRegListener(EventDef.ID.HIDE_BAG, self)
    EventManager:unRegListener(EventDef.ID.RESUME_BAG_BUTTON, self)
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.clickScheduler)
end

return AtlasView
