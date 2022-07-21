/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-20
*	Description	:	game线程定义实现文件
--------------------------------------------------*/

#include "log.h"
#include "lua_c_func.h"
#include "timesystem.h"
#include "game_thread.h"

extern "C" {
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "lua_cjson.h"
#include "lfs.h"
#include "bit.h"
#include "lua_cjson.h"
}

GameThread::GameThread() {
}

GameThread::~GameThread() {
}

bool GameThread::Init() {
  thread_ptr_ = new(std::nothrow) boost::thread(&GameThread::RunLua, this);
  if (thread_ptr_ == NULL) {
    SLOG(STARTUP_ERROR, "start game thread fail");
    return false;
  }
  return true;
}

void GameThread::PushMsg(const std::string msg_str) {
  str_msg_.push(msg_str);
}

void GameThread::GetMsg(std::string& msg_str) {
  if (!str_msg_.try_pop(msg_str))
    msg_str = "";
}

static const luaL_Reg game_funcs[] = {
  {"sendMsg2ClientBySid", Lua_SendMsg2ClientBySid}, 
  {"sendMsg2ClientByPid", Lua_SendMsg2ClientByPid}, 
  {"recvGameMsg", Lua_RecvGameMsg}, 
  {"sendMsg2Lobby", Lua_SendMsg2Lobby},
  {"getTickCount", Lua_GetTickCount}, 
  {"msSleep", Lua_Sleep}, 
  {"slog", Lua_Slog}, 
  {"qlog", Lua_Qlog}, 
  {NULL, NULL}
};

void GameThread::RunLua() {
  lua_State * state = luaL_newstate();
  luaL_openlibs(state);
  luaopen_cjson_easy(state);
  luaL_register(state, "_G", game_funcs);
  luaL_dofile(state, "./lua/Game.lua");
  /*luaL_loadstring(state, "require 'game'");
  lua_pcall(state, 0, 0, 0);*/
  lua_close(state);
}
