/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-15
*	Description	:	网络消息接收类定义
--------------------------------------------------*/

#ifndef __CLIENT_MSG_HANDLER_H__
#define __CLIENT_MSG_HANDLER_H__

#include "json.h"
#include "typedef.h"
#include "net_headers.h"

class ClientMsgHandler : public TCPSessionHandler {
public:
  ClientMsgHandler();
  ~ClientMsgHandler();

  virtual void OnConnect(uint32 sid, const char* ip, unsigned short port);
  virtual void OnMessage(uint32 sid, char* msg);
  virtual void OnClose(uint32 sid, std::string ip, unsigned short port);

  //temp code for debug
  void TempParseClientMsg(uint32 sid, char* msg);
  void TempParseStartGame(uint32 sid, const Json::Value& root);
  void TempParseUploadHP(uint32 sid, const Json::Value& root);
  void TempParseUploadScore(uint32 sid, const Json::Value& root);
  void TempParseHeartbeat(uint32 sid, const Json::Value& root);
  void TestLoginReq(uint32 sid);
  void TestStartGameReq(uint32 sid);
  void TestRefreshHP(uint32 sid);
  //
};

#endif
