/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-20
*	Description	:	lobby线程定义实现文件
--------------------------------------------------*/

#include "log.h"
#include "lua_c_func.h"
#include "timesystem.h"
#include "lobby_thread.h"

extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "lua_cjson.h"
#include "lfs.h"
#include "bit.h"
#include "lua_cjson.h"
}

LobbyThread::LobbyThread() {
}

LobbyThread::~LobbyThread() {
}

bool LobbyThread::Init() {
  thread_ptr_ = new(std::nothrow) boost::thread(&LobbyThread::RunLua, this);
  if (thread_ptr_ == NULL) {
    SLOG(STARTUP_ERROR, "start lobby thread fail");
    return false;
  }
  return true;
}

void LobbyThread::PushMsg(const std::string msg_str) {
  str_msg_.push(msg_str);
}

void LobbyThread::GetMsg(std::string& msg_str) {
  if (!str_msg_.try_pop(msg_str))
    msg_str = "";
}

static const luaL_Reg lobby_funcs[] = {
  {"requestPlayerDBData", Lua_RequestPlayerDBData}, 
  {"savePlayerDBData", Lua_SavePlayerDBData}, 
  {"sendMsg2ClientBySid", Lua_SendMsg2ClientBySid}, 
  {"sendMsg2ClientByPid", Lua_SendMsg2ClientByPid}, 
  {"recvLobbyMsg", Lua_RecvLobbyMsg}, 
  {"sendMsg2Game", Lua_SendMsg2Game}, 
  {"setPid2Sid", Lua_SetPid2Sid}, 
  {"getTickCount", Lua_GetTickCount}, 
  {"msSleep", Lua_Sleep}, 
  {"slog", Lua_Slog}, 
  {"qlog", Lua_Qlog}, 
  {NULL, NULL}
};

void LobbyThread::RunLua() {
  lua_State * state = luaL_newstate();
  luaL_openlibs(state);
  luaopen_cjson_easy(state);
  luaL_register(state, "_G", lobby_funcs);
  luaL_dofile(state, "./lua/Lobby.lua");
  /*luaL_loadstring(state, "require 'lobby'");
  lua_pcall(state, 0, 0, 0);*/
  lua_close(state);
}
