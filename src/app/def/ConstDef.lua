local PATH_ICON_01,PATH_ICON_LINEUP_01,PATH_ICON_UNCOLLECTED_01="res/collected/1.png","res/icon_lineup/1.png","res/uncollected/1.png"
local PATH_ICON_02,PATH_ICON_LINEUP_02,PATH_ICON_UNCOLLECTED_02="res/collected/2.png","res/icon_lineup/2.png","res/uncollected/2.png"
local PATH_ICON_03,PATH_ICON_LINEUP_03,PATH_ICON_UNCOLLECTED_03="res/collected/3.png","res/icon_lineup/3.png","res/uncollected/3.png"
local PATH_ICON_04,PATH_ICON_LINEUP_04,PATH_ICON_UNCOLLECTED_04="res/collected/4.png","res/icon_lineup/4.png","res/uncollected/4.png"
local PATH_ICON_05,PATH_ICON_LINEUP_05,PATH_ICON_UNCOLLECTED_05="res/collected/5.png","res/icon_lineup/5.png","res/uncollected/5.png"
local PATH_ICON_06,PATH_ICON_LINEUP_06,PATH_ICON_UNCOLLECTED_06="res/collected/7.png","res/icon_lineup/6.png","res/uncollected/6.png"
local PATH_ICON_07,PATH_ICON_LINEUP_07,PATH_ICON_UNCOLLECTED_07="res/collected/7.png","res/icon_lineup/7.png","res/uncollected/7.png"
local PATH_ICON_08,PATH_ICON_LINEUP_08,PATH_ICON_UNCOLLECTED_08="res/collected/8.png","res/icon_lineup/8.png","res/uncollected/8.png"
local PATH_ICON_09,PATH_ICON_LINEUP_09,PATH_ICON_UNCOLLECTED_09="res/collected/9.png","res/icon_lineup/9.png","res/uncollected/9.png"
local PATH_ICON_10,PATH_ICON_LINEUP_10,PATH_ICON_UNCOLLECTED_10="res/collected/10.png","res/icon_lineup/10.png","res/uncollected/10.png"
local PATH_ICON_11,PATH_ICON_LINEUP_11,PATH_ICON_UNCOLLECTED_11="res/collected/11.png","res/icon_lineup/11.png","res/uncollected/11.png"
local PATH_ICON_12,PATH_ICON_LINEUP_12,PATH_ICON_UNCOLLECTED_12="res/collected/12.png","res/icon_lineup/12.png","res/uncollected/12.png"
local PATH_ICON_13,PATH_ICON_LINEUP_13,PATH_ICON_UNCOLLECTED_13="res/collected/13.png","res/icon_lineup/13.png","res/uncollected/13.png"
local PATH_ICON_14,PATH_ICON_LINEUP_14,PATH_ICON_UNCOLLECTED_14="res/collected/14.png","res/icon_lineup/14.png","res/uncollected/14.png"
local PATH_ICON_15,PATH_ICON_LINEUP_15,PATH_ICON_UNCOLLECTED_15="res/collected/15.png","res/icon_lineup/15.png","res/uncollected/15.png"
local PATH_ICON_16,PATH_ICON_LINEUP_16,PATH_ICON_UNCOLLECTED_16="res/collected/16.png","res/icon_lineup/16.png","res/uncollected/16.png"
local PATH_ICON_17,PATH_ICON_LINEUP_17,PATH_ICON_UNCOLLECTED_17="res/collected/17.png","res/icon_lineup/17.png","res/uncollected/17.png"
local PATH_ICON_18,PATH_ICON_LINEUP_18,PATH_ICON_UNCOLLECTED_18="res/collected/18.png","res/icon_lineup/18.png","res/uncollected/18.png"
local PATH_ICON_19,PATH_ICON_LINEUP_19,PATH_ICON_UNCOLLECTED_19="res/collected/19.png","res/icon_lineup/19.png","res/uncollected/19.png"
local PATH_ICON_20,PATH_ICON_LINEUP_20,PATH_ICON_UNCOLLECTED_20="res/collected/20.png","res/icon_lineup/20.png","res/uncollected/20.png"
local ConstDef={
    scale_=0.7,
    ICON_LIST={PATH_ICON_01,PATH_ICON_02,
               PATH_ICON_03,PATH_ICON_04,
               PATH_ICON_05,PATH_ICON_06,
               PATH_ICON_07,PATH_ICON_08,
               PATH_ICON_09,PATH_ICON_10,
               PATH_ICON_11,PATH_ICON_12,
               PATH_ICON_13,PATH_ICON_14,
               PATH_ICON_15,PATH_ICON_16,
               PATH_ICON_17,PATH_ICON_18,
               PATH_ICON_19,PATH_ICON_20},

    ICON_LINEUP_LIST={PATH_ICON_LINEUP_01,PATH_ICON_LINEUP_02,
                      PATH_ICON_LINEUP_03,PATH_ICON_LINEUP_04,
                      PATH_ICON_LINEUP_05,PATH_ICON_LINEUP_06,
                      PATH_ICON_LINEUP_07,PATH_ICON_LINEUP_08,
                      PATH_ICON_LINEUP_09,PATH_ICON_LINEUP_10,
                      PATH_ICON_LINEUP_11,PATH_ICON_LINEUP_12,
                      PATH_ICON_LINEUP_13,PATH_ICON_LINEUP_14,
                      PATH_ICON_LINEUP_15,PATH_ICON_LINEUP_16,
                      PATH_ICON_LINEUP_17,PATH_ICON_LINEUP_18,
                      PATH_ICON_LINEUP_19,PATH_ICON_LINEUP_20 },
    ICON_UNCOLLECTED_LIST={PATH_ICON_UNCOLLECTED_01,PATH_ICON_UNCOLLECTED_02,
                           PATH_ICON_UNCOLLECTED_03,PATH_ICON_UNCOLLECTED_04,
                           PATH_ICON_UNCOLLECTED_05,PATH_ICON_UNCOLLECTED_06,
                           PATH_ICON_UNCOLLECTED_07,PATH_ICON_UNCOLLECTED_08,
                           PATH_ICON_UNCOLLECTED_09,PATH_ICON_UNCOLLECTED_10,
                           PATH_ICON_UNCOLLECTED_11,PATH_ICON_UNCOLLECTED_12,
                           PATH_ICON_UNCOLLECTED_13,PATH_ICON_UNCOLLECTED_14,
                           PATH_ICON_UNCOLLECTED_15,PATH_ICON_UNCOLLECTED_16,
                           PATH_ICON_UNCOLLECTED_17,PATH_ICON_UNCOLLECTED_18,
                           PATH_ICON_UNCOLLECTED_19,PATH_ICON_UNCOLLECTED_20,},

    LINEUP_LIST = {
                lineupOne = {1, 1, 1, 1, 1},
                lineupTwo = {2, 2, 2, 2, 2},
                lineupThree = {3, 3, 3, 3, 3}
            },
    BUTTON_CLICK={},
    COLLECTED = {},
    POPUP={},
    UNCOLLECTED = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}
}
return ConstDef