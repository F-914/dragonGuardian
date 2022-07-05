/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-15
*	Description	:	网络消息接收类实现
--------------------------------------------------*/

#include "log.h"
#include "demo_service.h"
#include "base_func-inl.h"
#include "client_msg_handler.h"

ClientMsgHandler::ClientMsgHandler() {
}

ClientMsgHandler::~ClientMsgHandler() {
}

void ClientMsgHandler::OnConnect(
    uint32 sid, 
    const char* ip, 
    unsigned short port) {
  gtk_demo_service->RecvClientConnected(sid);
  //temp code for debug
  //TestLoginReq(sid);
  /*TestStartGameReq(sid);
  TestRefreshHP(sid);*/
  //
}

void ClientMsgHandler::OnMessage(uint32 sid, char* msg) {
  //TempParseClientMsg(sid, msg);
  gtk_demo_service->RecvClientMsg(sid, msg);
}

void ClientMsgHandler::OnClose(
    uint32 sid, 
    std::string ip, 
    unsigned short port) {
  gtk_demo_service->RecvClientClosed(sid);
}

//temp code for debug
#include "json_writer.h"
#include "protocol_def.h"
void ClientMsgHandler::TestLoginReq(uint32 sid) {
  std::string login_msg("{\"type\":5, \"loginname\":\"dadada8\"}");
  int total = sizeof(TKCAGHEADER) + login_msg.length();
  TKCAGHEADER* header = (TKCAGHEADER*)malloc(total);
  header->msg_length_ = login_msg.length();
  memcpy(header + 1, login_msg.c_str(), login_msg.length());
  gtk_demo_service->RecvClientMsg(sid, (char*)header);
}

void ClientMsgHandler::TestStartGameReq(uint32 sid) {
  std::string start_game_msg(
      "{\"type\":1, \"playerid\":100000, \"nick\":\"zuohushi\", \"hp\":0}");
  int total = sizeof(TKCAGHEADER) + start_game_msg.length();
  TKCAGHEADER* header = (TKCAGHEADER*)malloc(total);
  header->msg_length_ = start_game_msg.length();
  memcpy(header + 1, start_game_msg.c_str(), start_game_msg.length());
  gtk_demo_service->RecvClientMsg(sid, (char*)header);
}

void ClientMsgHandler::TestRefreshHP(uint32 sid) {
  std::string start_game_msg(
      "{\"type\":2, \"playerid\":100000, \"hp\":0}");
  int total = sizeof(TKCAGHEADER) + start_game_msg.length();
  TKCAGHEADER* header = (TKCAGHEADER*)malloc(total);
  header->msg_length_ = start_game_msg.length();
  memcpy(header + 1, start_game_msg.c_str(), start_game_msg.length());
  gtk_demo_service->RecvClientMsg(sid, (char*)header);
}

void ClientMsgHandler::TempParseClientMsg(uint32 sid, char* msg) {
  TKCAGHEADER* header = (TKCAGHEADER*)msg;
  std::string msg_str((char*)(header+1), header->msg_length_);
  Json::Reader reader;
  Json::Value root;
  if (!reader.parse(msg_str, root)) {
    QLOG(LOG_ERROR, "parse json protocol fail");
    return;
  }
  if (root["type"].isNull() || !root["type"].isInt()) {
    QLOG(LOG_ERROR, "parse type field fail");
    return;
  }

  uint32 type = root["type"].asUInt();
  switch (type) {
    case tk_req + 1:
      TempParseStartGame(sid, root);
      break;
    case tk_req + 2:
      TempParseUploadHP(sid, root);
      break;
    case tk_req + 3:
      TempParseUploadScore(sid, root);
      break;
    case tk_req + 4:
      TempParseHeartbeat(sid, root);
      break;
    default:
      break;
  }
}

void ClientMsgHandler::TempParseStartGame(
    uint32 sid, 
    const Json::Value& root) {
  uint32 player_id = root["playerid"].asUInt();
  std::string nick = root["nick"].asString();
  uint32 hp = root["hp"].asUInt();
  uint32 ret_hp = 10;
  if (hp != 0)
    ret_hp = hp;
  
  Json::Value res;
  Json::FastWriter writer;
  res["type"] = tk_ack + 1;
  res["playerid"] = player_id;
  res["maxhp"] = ret_hp;

  gtk_demo_service->AddPlayer(player_id, nick);
  gtk_demo_service->SendMsg2Client(sid, writer.write(res).c_str());
}

void ClientMsgHandler::TempParseUploadHP(
    uint32 sid, 
    const Json::Value& root) {
  uint32 player_id = root["playerid"].asUInt();
  uint32 hp = root["hp"].asUInt();
  if (hp != 0) return;
  
  Json::Value res;
  Json::FastWriter writer;
  res["type"] = tk_ack + 2;
  res["playerid"] = player_id;
  gtk_demo_service->SendMsg2Client(sid, writer.write(res).c_str());
}

void ClientMsgHandler::TempParseUploadScore(
    uint32 sid, 
    const Json::Value& root) {
  uint32 player_id = root["playerid"].asUInt();
  uint32 score = root["score"].asUInt();
  gtk_demo_service->RefreshRanklist(player_id, score);
  gtk_demo_service->PushRanklist(sid, player_id);
}

void ClientMsgHandler::TempParseHeartbeat(
    uint32 sid, 
    const Json::Value& root) {
  uint32 player_id = root["playerid"].asUInt();
  uint32 serial = root["serial"].asUInt();

  Json::Value res;
  Json::FastWriter writer;
  res["type"] = tk_ack + 4;
  res["playerid"] = player_id;
  res["serial"] = serial;
  gtk_demo_service->SendMsg2Client(sid, writer.write(res).c_str());
}
//
