--[[--
    MsgDef.lua

    描述：消息类型常量定义
]]
local MsgDef = {}

-- 请求消息
MsgDef.REQTYPE = {--请求类型，是客户端发往服务器的
    STARTGAME   =    1,--开始游戏
	REFRESHHP   =    2,--刷新hp
	UPLOADSCORE =    3,--上传分数
	HEARTBEAT   =    4,--心跳(检测网络连接状态)
	LOGIN       =    5,--登录
    --HP_CHANGGE  =    6,
	TOWER_ADD   =    6,--游戏中增加塔
	BULLET_CREATE    =    7,--子弹创造
	BULLET_MOVE =    8,--子弹移动
	BULLET_DESTORY = 9,--子弹销毁
	ENEMY_CREATE  =  10,--创造敌人
	ENEMY_MOVE  =    11,--移动敌人
	ENEMY_DESTORY =  12,--销毁敌人
	ASSERT_CHANGE =  13,--使用金币/钻石
	CARD_COLLECT  =  14,--收集塔
	CARD_ATTRIBUTE_CHANGE = 15,--游戏改变塔的属性，比如攻击力等，用于升级
	CREATEGAME  =   500,--创建游戏(因为存在匹配所以先创造游戏，匹配到了就开始游戏)
}

-- 响应消息
MsgDef.ACKTYPE = {--响应类型，是服务器发往客户端的

}

return MsgDef