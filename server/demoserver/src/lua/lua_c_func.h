/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-21
*	Description	:	注册到lua中的c函数定义头文件
--------------------------------------------------*/

#ifndef __LUA_C_FUNC_H__
#define __LUA_C_FUNC_H__

extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "lua_cjson.h"
#include "lfs.h"
#include "bit.h"
}

int Lua_RequestPlayerDBData(lua_State* state);
int Lua_SavePlayerDBData(lua_State* state);
int Lua_SendMsg2ClientBySid(lua_State* state);
int Lua_SendMsg2ClientByPid(lua_State* state);
int Lua_RecvLobbyMsg(lua_State* state);
int Lua_RecvGameMsg(lua_State* state);
int Lua_SendMsg2Game(lua_State* state);
int Lua_SendMsg2Lobby(lua_State* state);
int Lua_SetPid2Sid(lua_State* state);
int Lua_GetTickCount(lua_State* state);
int Lua_Sleep(lua_State* state);
int Lua_Qlog(lua_State* state);
int Lua_Slog(lua_State* state);

#define CHECK_LUA_PARAM_NUM(x)\
        if (lua_gettop(state) != (x)) {\
          QLOG(LOG_ERROR,\
              "%s lua param num error",\
              __FUNCTION__);\
        }

#define lua_touint(state, idx)\
        static_cast<uint32>(lua_tonumber((state),(idx)))

#endif
