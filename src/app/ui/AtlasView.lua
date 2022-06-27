local ConstDef = require("src/app/def/ConstDef.lua")
local BASEMAP_TITLE = "res/home/guide/subinterface_current_lineup/base_title.png"
local BASEMAP_AREA = "res/home/guide/subinterface_current_lineup/base_area.png"
local NUMBER_1 = "res/home/guide/subinterface_current_lineup/one.png"
local NUMBER_2 = "res/home/guide/subinterface_current_lineup/two.png"
local NUMBER_3 = "res/home/guide/subinterface_current_lineup/three.png"
local TEXTURE_NOWLINEUP = "res/home/guide/subinterface_current_lineup/text_current_lineup.png"
local BASEMAP_CONNECTION = "res/home/guide/subinterface_current_lineup/base_lineup.png"
local ICON_CHOOSE = "res/home/guide/subinterface_current_lineup/icon_selected.png"
local ICON_UNCHOOSE = "res/home/guide/subinterface_current_lineup/icon_unselected.png"
local BASEMAP_TIP = "res/home/guide/subinterface_tips/base_tips.png"
local TEXTURE_LONG = "res/home/guide/subinterface_tips/text_tips.png"
local TEXTURE_SHORT = "res/home/guide/subinterface_tips/text_total_critical_strike_damage.png"
local SPLITLINE_COLLECTED = "res/home/guide/subinterface_tower_list/split_collected.png"
local SPLITLINE_UNCOLLECTED = "res/home/guide/subinterface_tower_list/split_not_collected.png"
local AtlasView =
    class(
    "AtlasView",
    function()
        return display.newColorLayer(cc.c4b(0, 0, 0, 0))
    end
)
local BackgroundLayer = require("src/app/ui/layer/BackgroundLayer.lua")
local LineupLayer=require("src/app/ui/layer/LineupLayer.lua")
local BagLayer=require("src/app/ui/layer/BagLayer.lua")
local function createCheckbox(parents,number)
    local checkbox = ccui.CheckBox:create(ICON_UNCHOOSE, ICON_CHOOSE, ICON_CHOOSE, ICON_UNCHOOSE, ICON_UNCHOOSE)
    parents:add(checkbox)
    checkbox:setTouchEnabled(true)
    checkbox:setAnchorPoint(0.5, 0.5)
    local path
    if number==1 then 
       path=NUMBER_1
       elseif number==2 then
        path=NUMBER_2
          elseif number==3 then
            path=NUMBER_3
          end
            -- body
    local spriteNumber = display.newSprite(path)
    checkbox:add(spriteNumber)
    spriteNumber:setAnchorPoint(0.5, 0.5)
    spriteNumber:setPosition(checkbox:getContentSize().width * 0.5, checkbox:getContentSize().height * 0.5)
    return checkbox
end
function AtlasView:ctor()
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
end
function AtlasView:initView()
    self.backgourndLayer_ = BackgroundLayer.new()
    self:add(self.backgourndLayer_)
    self.containerForLineup_ = nil
end

function AtlasView:createLineupList()
    local lineupLayout = display.newSprite(BASEMAP_AREA)--------------------------------------------------------------------
    self:add(lineupLayout)
    lineupLayout:setScale(0.8)
    lineupLayout:setAnchorPoint(0.5, 0.5)
    lineupLayout:setPosition(display.cx, display.cy * 1.6)
      local basemapTitle = display.newSprite(BASEMAP_TITLE)
      lineupLayout:add(basemapTitle)
      basemapTitle:setAnchorPoint(0.5, 0.5)
      basemapTitle:setScale(lineupLayout:getContentSize().width / basemapTitle:getContentSize().width)
      basemapTitle:setPosition(lineupLayout:getContentSize().width * 0.5, lineupLayout:getContentSize().height)
        local basemapNowLineup = display.newSprite(TEXTURE_NOWLINEUP)
        basemapTitle:add(basemapNowLineup)
        basemapNowLineup:setAnchorPoint(0.5, 0.5)
        basemapNowLineup:setPosition(basemapTitle:getContentSize().width * 0.3, basemapTitle:getContentSize().height * 0.5)
          local basemapConnection = display.newSprite(BASEMAP_CONNECTION)
          basemapTitle:add(basemapConnection)
          basemapConnection:setAnchorPoint(0.5, 0.5)
          basemapConnection:setPosition(basemapTitle:getContentSize().width * 0.65,basemapTitle:getContentSize().height * 0.5)----------------------------------------------------------------------------------------------------------------------------
    
    local checkbox1=createCheckbox(basemapConnection, 1)
    checkbox1:setPosition(0, basemapConnection:getContentSize().height * 0.5)
    local checkbox2=createCheckbox(basemapConnection, 2)
    checkbox2:setPosition(basemapConnection:getContentSize().width * 0.5, basemapConnection:getContentSize().height * 0.5)
    local checkbox3=createCheckbox(basemapConnection, 3)
    checkbox3:setPosition(basemapConnection:getContentSize().width, basemapConnection:getContentSize().height * 0.5)
    
    local pageView = ccui.PageView:create()
    lineupLayout:add(pageView)
    pageView:setContentSize(lineupLayout:getContentSize().width, 150)
    pageView:setTouchEnabled(true)
    pageView:setAnchorPoint(0, 0)
    pageView:setPosition(15, 25)

    local layout1=ccui.Layout:create()
    local lineup1=LineupLayer.new(ConstDef.LINEUP_LIST.lineupOne)
    layout1:add(lineup1)
    layout1:setContentSize(lineupLayout:getContentSize().width, lineupLayout:getContentSize().height)
    pageView:addPage(layout1)
      local layout2=ccui.Layout:create()
      local lineup2=LineupLayer.new(ConstDef.LINEUP_LIST.lineupTwo)
      layout2:add(lineup2)
      layout2:setContentSize(lineupLayout:getContentSize().width, lineupLayout:getContentSize().height)
      pageView:addPage(layout2)
        local layout3=ccui.Layout:create()
        local lineup3=LineupLayer.new(ConstDef.LINEUP_LIST.lineupThree)
        layout3:add(lineup3)
        layout3:setContentSize(lineupLayout:getContentSize().width, lineupLayout:getContentSize().height)
        pageView:addPage(layout3)

    checkbox1:setSelected(true)
    checkbox1:setTouchEnabled(false)
    checkbox2:setSelected(false)
    checkbox3:setSelected(false)
    local function onChangedCheckbox(sender, eventType)
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
function AtlasView:createBag()

    local listView = ccui.ListView:create()
    self:add(listView)
    listView:setDirection(ccui.ListViewDirection.vertical)
    listView:setBounceEnabled(true)
    listView:setContentSize(display.width,display.cy*1.4)
    listView:setAnchorPoint(0.5, 0.5)
    listView:setPosition(display.cx,display.cy*0.7)
    
    local layoutTexture=ccui.Layout:create()
    listView:add(layoutTexture)
    layoutTexture:setAnchorPoint(0.5,1)
    --layout:setPosition(listView:getContentSize().width*0.5,listView:getContentSize().height)
    layoutTexture:setContentSize(listView:getContentSize().width,80)
    --layoutTexture:setPosition(listView:getContentSize().width*0.5,listView:getContentSize().height)
   
    local tipBackground=display.newSprite(BASEMAP_TIP)
    layoutTexture:add(tipBackground)
    tipBackground:setAnchorPoint(0.5,0)
    tipBackground:setPosition(layoutTexture:getContentSize().width*0.5,0)
    tipBackground:setScale(0.8)
    local textureLong=display.newSprite(TEXTURE_LONG)
    tipBackground:add(textureLong)
    textureLong:setAnchorPoint(0.5,0.5)
    textureLong:setPosition(tipBackground:getContentSize().width*0.5,
                            tipBackground:getContentSize().height*0.25)
    local textureShort=display.newSprite(TEXTURE_SHORT)
    tipBackground:add(textureShort)
    textureShort:setAnchorPoint(0.5,0.5)
    textureShort:setPosition(tipBackground:getContentSize().width*0.4,
                             tipBackground:getContentSize().height*0.75)
    
    local splitLineCollected=display.newSprite(SPLITLINE_COLLECTED)
    layoutTexture:add(splitLineCollected)
    splitLineCollected:setScale(layoutTexture:getContentSize().width/splitLineCollected:getContentSize().width)
    splitLineCollected:setAnchorPoint(0.5,0.5)
    splitLineCollected:setPosition(layoutTexture:getContentSize().width*0.5,layoutTexture:getContentSize().height*0-50)
    
    local heightUncollect,heightCollect
    if table.getn(ConstDef.COLLECTED)%4==0 then
          heightCollect=table.getn(ConstDef.COLLECTED)/4
       elseif table.getn(ConstDef.COLLECTED)%4~=0 then
          heightCollect=table.getn(ConstDef.COLLECTED)/4+1
       end

     if table.getn(ConstDef.UNCOLLECTED)%4==0 then
        heightUncollect=table.getn(ConstDef.UNCOLLECTED)/4
     elseif table.getn(ConstDef.UNCOLLECTED)%4~=0 then
        heightUncollect=table.getn(ConstDef.UNCOLLECTED)/4+1
     end
    
    local layoutCollect = ccui.Layout:create()
    listView:add(layoutCollect)
    layoutCollect:setAnchorPoint(0.5,1)
    layoutCollect:setContentSize(listView:getContentSize().width,heightCollect*100)
    --layoutCollect:setPosition(listView:getContentSize().width*0.5,0)
    local collected=BagLayer.new(ConstDef.COLLECTED)
    layoutCollect:add(collected)
    collected:setPosition(layoutCollect:getContentSize().width*0.5,layoutCollect:getContentSize().height*0.9)

    local layoutUncollect=ccui.Layout:create()
    listView:add(layoutUncollect)
    layoutUncollect:setAnchorPoint(0.5,1)
    --local x,y=layoutCollect:getPosition()
    layoutUncollect:setContentSize(listView:getContentSize().width, heightUncollect*150)
      local splitLineUncollected=display.newSprite(SPLITLINE_UNCOLLECTED)
      
      layoutUncollect:add(splitLineUncollected)
      splitLineUncollected:setAnchorPoint(0.5,0.5)
      splitLineUncollected:setScale(layoutUncollect:getContentSize().width/splitLineUncollected:getContentSize().width)
      
      splitLineUncollected:setPosition(layoutUncollect:getContentSize().width*0.5,layoutUncollect:getContentSize().height*0.8)
    
    local uncollected=BagLayer.new(ConstDef.UNCOLLECTED)
    layoutUncollect:add(uncollected)
    uncollected:setPosition(layoutUncollect:getContentSize().width*0.5,layoutUncollect:getContentSize().height*0.8)

end
function AtlasView:onEnter()
    --print(ConstDef.ICON_LIST[1]:getContentSize())
    self:createLineupList()
    self:createBag()
end
function AtlasView:onExit()
    --cc.Director:getInstance():getScheduler():unscheduleScriptEntry(CHECK_HANDLER)
end

return AtlasView
