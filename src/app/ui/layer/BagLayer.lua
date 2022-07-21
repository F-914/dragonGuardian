--[[--
    根据数据创建出每行四个图标的图鉴版块，分为已收集和未收集
    BagLayer.lua
]]
local BagLayer = class(
        "BagLayer",
        function()
            return display.newLayer()
        end
)
--local
local StringDef = require("app.def.StringDef")
local ConstDef = require("app.def.ConstDef")
local EventDef = require("app.def.EventDef")
local EventManager = require("app.manager.EventManager")
local Log = require("app.utils.Log")
local OutGameData = require("app.data.OutGameData")
--
local list_ = {}
--
function BagLayer:ctor(lineupList, types)
    self.list = nil
    self:init(lineupList, types)
    self.list = list_
end

--[[--
    @description: 初始化函数
    @param lineuplist 类型:用户的已收集列表或者是未收集列表
           type 类型:注明lineuplist是未收集还是已收集
    @return none
]]
function BagLayer:init(lineupList, types)
    local ttf = {}
    ttf.fontFilePath = StringDef.PATH_TTF_HZGBJW
    ttf.fontSize = 20
    local height
    if #(lineupList) == 0 then
        height = 1
    elseif #(lineupList) % 4 == 0 then
        height = #(lineupList) / 4
    elseif #(lineupList) % 4 ~= 0 then
        height = math.floor(#(lineupList) / 4) + 1
    end
    -- body
    local test = display.newSprite(ConstDef.ICON_LIST[1])
    --print(( test:getContentSize().height))
    local TotalLayout = ccui.Layout:create()
    TotalLayout:addTo(self)
    TotalLayout:setAnchorPoint(0.5, 1)
    TotalLayout:setContentSize(cc.Director:getInstance():getWinSize().width,
            test:getContentSize().height * ConstDef.scale_ * height + (height - 1) * test:getContentSize().height * 0.2 * ConstDef.scale_)
    if types == "uncollected" then
        for i = 1, #(lineupList), 4 do
            local layout = ccui.Layout:create()
            TotalLayout:add(layout)
            layout:setAnchorPoint(0.5, 1)
            layout:setContentSize(TotalLayout:getContentSize().width, test:getContentSize().height * ConstDef.scale_)
            layout:setPosition(
                    TotalLayout:getContentSize().width * 0.5,
                    TotalLayout:getContentSize().height - test:getContentSize().height * ConstDef.scale_ * math.floor(i / 4)
                            - math.floor(i / 4) * test:getContentSize().height * 0.1 * ConstDef.scale_
            )
            for j = 0, 3 do
                local cardId = i + j
                if lineupList[cardId] == nil then
                    break
                end
                local sprite = display.newSprite(ConstDef.ICON_UNCOLLECTED_LIST[lineupList[cardId]])
                layout:add(sprite)
                sprite:setScale(ConstDef.scale_)
                sprite:setAnchorPoint(0, 1)
                sprite:setPosition(layout:getContentSize().width * j * 0.25 + 20, 0)
                sprite:setContentSize(sprite:getContentSize().width * ConstDef.scale_,
                        sprite:getContentSize().height * ConstDef.scale_)
            end
        end
    elseif types == "collected" then
        for i = 1, #(lineupList), 4 do
            local layout = ccui.Layout:create()
            layout:addTo(TotalLayout)
            layout:setAnchorPoint(0.5, 1)
            layout:setContentSize(TotalLayout:getContentSize().width, test:getContentSize().height * ConstDef.scale_)
            layout:setPosition(
                    TotalLayout:getContentSize().width * 0.5,
                    TotalLayout:getContentSize().height * 1 + 100 -
                            test:getContentSize().height * ConstDef.scale_ * math.floor(i / 4) -
                            math.floor(i / 4) * test:getContentSize().height * 0.1 * ConstDef.scale_
            )
            for j = 0, 3 do
                local cardId = i + j
                print(cardId)
                if lineupList[cardId] == nil then
                    break
                end
                local button = ccui.Button:create(ConstDef.ICON_LIST[lineupList[cardId]],
                        ConstDef.ICON_LIST[lineupList[cardId]])
                button:addTo(layout)
                button:setAnchorPoint(0, 1)
                button:setScale(ConstDef.scale_)
                button:setPressedActionEnabled(true)
                button:setTouchEnabled(true)
                button:setPosition(layout:getContentSize().width * j * 0.25 + 20, 0)
                button:addTouchEventListener(function(sender, eventType)
                    if eventType == 2 then
                        --print(EventDef.ID.CREATE_TOWERDETIAL)
                        table.insert(ConstDef.BUTTON_CLICK, i + j)
                        --EventManager.doEvent(EventDef.ID.CREATE_TOWERDETIAL,i+j)
                    end
                end)
                table.insert(list_, button)
                ---太草率了，检测的是lineupList[cardId],还用cardId,而且就不该取名叫cardId
                local card = OutGameData:getUserInfo():getCardList()[lineupList[cardId]]
                -- 卡牌等级
                local level = display.newSprite(ConstDef.ICON_SUBINTERFACE_TOWER_LINE_UP[card:getCardLevel()])
                button:add(level)
                level:setAnchorPoint(0.5, 0.5)
                level:setPosition(button:getContentSize().width * 0.5, button:getContentSize().height * 0.4)
                -- 卡牌数量与升级进度条
                local progressBg = display.newSprite(StringDef.PATH_SUBINTERFACE_TOWER_PROGRESS_BASE)
                button:add(progressBg)
                progressBg:setAnchorPoint(0.5, 0.5)
                progressBg:setPosition(button:getContentSize().width * 0.5, button:getContentSize().height * 0.2)
                local progressSprite = display.newSprite(StringDef.PATH_SUBINTERFACE_TOWER_PROGRESS)
                local progressBar = cc.ProgressTimer:create(progressSprite)
                progressBg:add(progressBar)
                progressBar:setType(display.PROGRESS_TIMER_BAR)
                progressBar:setMidpoint(cc.p(0, 0))
                progressBar:setBarChangeRate(cc.p(1, 0))
                progressBar:setAnchorPoint(0.5, 0.5)
                progressBar:setPosition(progressBg:getContentSize().width * 0.5, progressBg:getContentSize().height * 0.5)
                -- 卡牌数量
                local progressNumber = cc.Label:createWithTTF(ttf, tostring(card:getCardAmount()))
                progressBg:add(progressNumber)
                progressNumber:setAnchorPoint(0.5, 0.5)
                progressNumber:setPosition(progressBg:getContentSize().width * 0.5,
                        progressBg:getContentSize().height * 0.5)
                -- TODO 这块有个问题 按照 游戏策划文档v4.3中 养成方式 部分的卡牌升级的表格，用来升级的卡牌的稀有度会影响所需要的卡牌的数量，那么这里需要的卡牌数量应该是哪一种呢？？
                -- 目前全部按 R稀有度 卡牌整的
                local upgradeNumber = ConstDef.CARD_UPDATE_CONDITION.CARD_CONDITION[card:getCardLevel()].R --升级需要的卡片数量
                local ownedNumber = card:getCardAmount() --拥有的卡片数量
                progressNumber:setString(ownedNumber .. "/" .. upgradeNumber)
                progressBar:setPercentage(100 * (ownedNumber / upgradeNumber))
            end
        end

    end

end

return BagLayer
