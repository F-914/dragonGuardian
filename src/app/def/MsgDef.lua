--[[--
    用于注册监听器使用，
    该监听器是msgController接受到消息调用的监听器
    依据不同的消息类型执行不同的事件
]]
local MsgDef = {}
MsgDef.REQTYPE = {
    --请求类型，是客户端发往服务器的

    GAME = {
        REFRESHHP = 1000 + 1,
        --刷新hp
        TOWER_ADD = 1000 + 2,
        --游戏中增加塔
        BULLET_CREATE = 1000 + 3,
        --子弹创造
        BULLET_MOVE = 1000 + 4,
        --子弹移动
        BULLET_DESTORY = 1000 + 5,
        --子弹销毁
        ENEMY_CREATE = 1000 + 6,
        --创造敌人
        ENEMY_MOVE = 1000 + 7,
        --移动敌人
        ENEMY_DESTORY = 1000 + 8,
        --销毁敌人
        CREATEGAME = 1000 + 9,
        --创建游戏(因为存在匹配所以先创造游戏，匹配到了就开始游戏)
        STARTGAME = 1000 + 10,
        --开始游戏
        GAMEOVER = 1000 + 11
        --游戏结束
    },
    LOBBY = {
        UPLOADSCORE = 1,
        --上传分数
        HEARTBEAT = 2,
        --心跳(检测网络连接状态)
        LOGIN = 3,
        --登录
        ASSERT_CHANGE = 4,
        --使用或增加金币/钻石
        CARD_COLLECT = 5,
        --收集塔
        CARD_ATTRIBUTE_CHANGE = 6,
        --游戏改变塔的属性，比如攻击力等，用于升级

        --[[--以下部分来自幸周]]
        ---以下部分均是同步和初始化消息,由调度器定时发送或者来自初始化时发送
        USERINFO_DS = 7,
        --用户信息同步
        DIAMONDSHOP_DS = 8,
        --钻石商店信息同步
        COINSHOP_DS = 9,
        --金币商店信息同步
        USERINFO_INIT = 10,
        --用户信息初始化
        DIAMONDSHOP_INIT = 11,
        --钻石商店信息初始化
        COINSHOP_INIT = 12,
        --金币商店初始化
        ---以下是事件消息
        PURCHASE_COMMODITY = 13,
        --购买商品
        TROPHY_CHANGE = 14,
        --奖杯数改变
        MODIFY_BATTLETEAM = 15,
        --修改战斗队伍信息
        RECEIVE_REWARD = 16,
    }
}

MsgDef.ACKTYPE = {
    --确认类型，是服务器发往客户端的
    RANKLIST = 0x80000 + 3,
    HEARTBEAT = 0x80000 + 4,
    GAME = {
        STARTGAME = 0x80000 + 1,
        GAMEOVER = 0x80000 + 2
    },
    LOBBY = {
        LOGIN = 0x80000 + 5,
        ASSERT_CHANGE = 0x80000 + 6,
        CARD_COLLECT = 0x80000 + 7,
        CARD_ATTRIBUTE_CHANGE = 0x80000 + 8,

        --[[--以下部分来自幸周
            虽然和发送类型的名字一样，但使用情况不同，
            这几个类型主要是客户端同步数据和修改数据函数的注册的类型
            基于不同的类型调用不同的回调函数
        ]]
        ---以下部分均是同步和初始化消息
        USERINFO_DS = 0x80000 + 9,
        --用户信息同步
        DIAMONDSHOP_DS = 0x80000 + 10,
        --钻石商店信息同步
        COINSHOP_DS = 0x80000 + 11,
        --金币商店信息同步
        USERINFO_INIT = 0x80000 + 12,
        --用户信息初始化
        DIAMONDSHOP_INIT = 0x80000 + 13,
        --钻石商店信息初始化
        COINSHOP_INIT = 0x80000 + 14,
        --金币商店初始化
        PURCHASE_COMMODITY = 0x80000 + 15,
        --购买商品
        TROPHY_CHANGE = 0x80000 + 16,
        --奖杯数改变
        MODIFY_BATTLETEAM = 0x80000 + 17,
        --修改战斗队伍信息
        RECEIVE_REWARD = 0x80000 + 18,

    }
}
return MsgDef