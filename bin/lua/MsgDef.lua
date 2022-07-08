MsgDef = {}

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
        CARD_ATTRIBUTE_CHANGE = 6
        --游戏改变塔的属性，比如攻击力等，用于升级
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
        CARD_ATTRIBUTE_CHANGE = 0x80000 + 8
    }
}

return MsgDef
