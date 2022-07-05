/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-21
*	Description	:	注册到lua中的c函数定义实现文件
--------------------------------------------------*/

#include "log.h"
#include "lua_c_func.h"
#include "timesystem.h"
#include "demo_service.h"
#include <string>

int Lua_RequestPlayerDBData(lua_State* state) {
  CHECK_LUA_PARAM_NUM(1);
  std::string login_name = lua_tostring(state, 1);
  uint32 player_id;
  std::string db_data;
  bool ret = gtk_demo_service->RequestPlayerDBData(
      login_name, 
      player_id, 
      db_data);
  lua_pushnumber(state, player_id);
  lua_pushstring(state, db_data.c_str());
  return 2;
}

int Lua_SavePlayerDBData(lua_State* state) {
  CHECK_LUA_PARAM_NUM(2);
  uint32 pid = lua_touint(state, 1);
  std::string db_data = lua_tostring(state, 2);
  gtk_demo_service->SavePlayerDBData(pid, db_data);
  return 0;
}

int Lua_SendMsg2ClientBySid(lua_State* state) {
  CHECK_LUA_PARAM_NUM(2);
  uint32 sid = lua_touint(state, 1);
  std::string msg = lua_tostring(state, 2);
  gtk_demo_service->SendMsg2Client(sid, msg);
  return 0;
}

int Lua_SendMsg2ClientByPid(lua_State* state) {
  CHECK_LUA_PARAM_NUM(2);
  uint32 pid = lua_touint(state, 1);
  std::string msg = lua_tostring(state, 2);
  gtk_demo_service->SendMsg2ClientByPid(pid, msg);
  return 0;
}

int Lua_RecvLobbyMsg(lua_State* state) {
  std::string msg;
  gtk_demo_service->RecvLobbyMsg(msg);
  lua_pushstring(state, msg.c_str());
  return 1;
}

int Lua_RecvGameMsg(lua_State* state) {
  std::string msg;
  gtk_demo_service->RecvGameMsg(msg);
  lua_pushstring(state, msg.c_str());
  return 1;
}

int Lua_SendMsg2Game(lua_State* state) {
  CHECK_LUA_PARAM_NUM(1);
  std::string msg = lua_tostring(state, 1);
  gtk_demo_service->PushMsg2Game(msg.c_str());
  return 0;
}

int Lua_SendMsg2Lobby(lua_State* state) {
  CHECK_LUA_PARAM_NUM(1);
  std::string msg = lua_tostring(state, 1);
  gtk_demo_service->PushMsg2Lobby(msg.c_str());
  return 0;
}

int Lua_SetPid2Sid(lua_State* state) {
  CHECK_LUA_PARAM_NUM(2);
  uint32 pid = lua_touint(state, 1);
  uint32 sid = lua_touint(state, 2);
  gtk_demo_service->SetPid2Sid(pid, sid);
  return 0;
}

int Lua_GetTickCount(lua_State* state) {
  uint32 now = GET_TIME().TickCount();
  lua_pushnumber(state, now);
  return 1;
}

int Lua_Sleep(lua_State* state) {
  CHECK_LUA_PARAM_NUM(1);
  uint32 interval = lua_touint(state, 1);
  boost::this_thread::sleep(
      boost::posix_time::milliseconds(interval));
  return 0;
}

int Lua_Qlog(lua_State* state) {
  CHECK_LUA_PARAM_NUM(2);
  uint32 chan = lua_touint(state, 1);
  std::string log_str = lua_tostring(state, 2);
  QLOG(chan, "%s", log_str.c_str());
  return 0;
}

int Lua_Slog(lua_State* state) {
  CHECK_LUA_PARAM_NUM(2);
  std::string log_file = lua_tostring(state, 1);
  std::string log_str = lua_tostring(state, 2);
  SLOG(log_file.c_str(), "%s", log_str.c_str());
  return 0;
}
