--[[--
    根据数据创建出每行四个图标的图鉴版块，分为已收集和未收集
    BagLayer.lua
]]
local ConstDef = require("src/app/def/ConstDef.lua")
local EventDef=require("src/app/def/EventDef.lua")
local EventManager=require("src/app/manager/EventManager.lua")
local PATH_LEVEL={
    "res/home/guide/subinterface_current_lineup/level/Lv.1.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.2.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.3.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.4.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.5.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.6.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.7.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.8.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.9.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.10.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.11.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.12.png",
 "res/home/guide/subinterface_current_lineup/level/Lv.13.png",
}
local PATH_PROGRESS_BASE="res/home/guide/subinterface_tower_list/progress_base_fragments_number.png"
local PATH_PROGRESS="res/home/guide/subinterface_tower_list/progress_progress_fragments_number.png"
local PATH_TTF = "res/front/fzhzgbjw.ttf"
local BagLayer =
    class(
    "BagLayer",
    function()
        return display.newLayer()
    end
)
local list_={}
--[[--
    @description: 构造函数
    @param lineuplist 类型:用户的已收集列表或者是未收集列表
           type 类型:注明lineuplist是未收集还是已收集
    @return none
]]
function BagLayer:ctor(lineupList, types)
    self.list=nil
    self:init(lineupList, types)
    self.list=list_
end
--[[--
    @description: 初始化函数
    @param lineuplist 类型:用户的已收集列表或者是未收集列表
           type 类型:注明lineuplist是未收集还是已收集
    @return none
]]
function BagLayer:init(lineupList, types)
   
    local ttf={}
    ttf.fontFilePath=PATH_TTF
    ttf.fontSize=20
    local height
    if  table.getn(lineupList)==0 then
        height=1
    elseif table.getn(lineupList) % 4 == 0 then
        height = table.getn(lineupList) / 4
    elseif table.getn(lineupList) % 4 ~= 0 then
        height =math.floor(table.getn(lineupList) / 4 )+1
    end
    -- body
    local test = display.newSprite(ConstDef.ICON_LIST[1])
    --print(( test:getContentSize().height))
    local TotalLayout = ccui.Layout:create()
    self:add(TotalLayout)
    TotalLayout:setAnchorPoint(0.5,1)
    TotalLayout:setContentSize(cc.Director:getInstance():getWinSize().width, test:getContentSize().height*ConstDef.scale_* height+(height-1)*test:getContentSize().height*0.2*ConstDef.scale_)
   
    if types == "uncollected" then
        for i = 1, table.getn(lineupList), 4 do
            local layout = ccui.Layout:create()
            TotalLayout:add(layout)
            layout:setAnchorPoint(0.5, 1)
            layout:setContentSize(TotalLayout:getContentSize().width,test:getContentSize().height*ConstDef.scale_)
            layout:setPosition(
                TotalLayout:getContentSize().width * 0.5,
                TotalLayout:getContentSize().height - test:getContentSize().height*ConstDef.scale_* math.floor(i / 4)-math.floor(i / 4)*test:getContentSize().height*0.1*ConstDef.scale_
            )
            for j = 0, 3 do
                if lineupList[i + j] == nil then
                    break
                end
                local sprite = display.newSprite(ConstDef.ICON_UNCOLLECTED_LIST[lineupList[j + i]])
                layout:add(sprite)
                sprite:setScale(ConstDef.scale_)
                sprite:setAnchorPoint(0, 1)
                sprite:setPosition(layout:getContentSize().width * j * 0.25 + 20, 0)
                sprite:setContentSize(sprite:getContentSize().width*ConstDef.scale_,sprite:getContentSize().height*ConstDef.scale_)
            end
        end
    elseif types == "collected" then
        
      
        for i = 1, table.getn(lineupList), 4 do  
            
            local layout = ccui.Layout:create()
            TotalLayout:add(layout)
            layout:setAnchorPoint(0.5, 1)
            layout:setContentSize(TotalLayout:getContentSize().width,  test:getContentSize().height*ConstDef.scale_ )
            layout:setPosition(
                TotalLayout:getContentSize().width * 0.5,
                TotalLayout:getContentSize().height*1+100 - test:getContentSize().height*ConstDef.scale_* math.floor(i/ 4)-math.floor(i / 4)*test:getContentSize().height*0.1*ConstDef.scale_
            )
            
            for j = 0, 3 do
                
                if lineupList[i + j] == nil then
                    
                    break
                end
              
                local button = ccui.Button:create(ConstDef.ICON_LIST[lineupList[j + i].order],ConstDef.ICON_LIST[lineupList[j + i].order])
                layout:add(button)
                button:setAnchorPoint(0, 1)
                button:setScale(ConstDef.scale_)
                button:setPressedActionEnabled(true)
                button:setTouchEnabled(true)
                button:setPosition(layout:getContentSize().width * j * 0.25 + 20, 0)
                
                button:addTouchEventListener(function(sender, eventType)     
                    if eventType==2 then
                        --print(EventDef.ID.CREATE_TOWERDETIAL)
                        table.insert(ConstDef.BUTTON_CLICK, i+j)
                       
                       --EventManager.doEvent(EventDef.ID.CREATE_TOWERDETIAL,i+j)
                    end
                end)
                table.insert(list_, button)
                
                local level=display.newSprite(PATH_LEVEL[1])
                button:add(level)
                level:setAnchorPoint(0.5,0.5)
                level:setPosition(button:getContentSize().width*0.5,button:getContentSize().height*0.4)
                
                local progressBg=display.newSprite(PATH_PROGRESS_BASE)
                button:add(progressBg)
                progressBg:setAnchorPoint(0.5,0.5)
                progressBg:setPosition(button:getContentSize().width*0.5,button:getContentSize().height*0.2)
                local progressSprite=display.newSprite(PATH_PROGRESS)
                local progressBar=cc.ProgressTimer:create(progressSprite)
                progressBg:add(progressBar)
                progressBar:setType(display.PROGRESS_TIMER_BAR)
                progressBar:setMidpoint(cc.p(0,0))
                progressBar:setBarChangeRate(cc.p(1,0))
                progressBar:setAnchorPoint(0.5,0.5)
                progressBar:setPosition(progressBg:getContentSize().width*0.5,progressBg:getContentSize().height*0.5)
                
                local progressNumber=cc.Label:createWithTTF(ttf,"0")
                progressBg:add(progressNumber)
                progressNumber:setAnchorPoint(0.5,0.5)
                progressNumber:setPosition(progressBg:getContentSize().width*0.5,progressBg:getContentSize().height*0.5)
                local upgradeNumber=9--升级需要的卡片数量
                local ownedNumber=0--拥有的卡片数量
                progressNumber:setString(ownedNumber.."/"..upgradeNumber)

                progressBar:setPercentage(100*(ownedNumber/upgradeNumber))
            end
        end
        
    end
    
end
return BagLayer
