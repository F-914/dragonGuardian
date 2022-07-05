/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-15
*	Description	:	通信协议结构定义头文件
--------------------------------------------------*/

#ifndef __PROTOCOL_DEF_H__
#define __PROTOCOL_DEF_H__

#include "typedef.h"

const uint32 kIPLen = 16;

enum MsgFlowType {
  tk_req = 0x00000,
  tk_ack = 0x80000,
};

enum MsgType {
  tk_msg_id_connect = 0, 
  tk_msg_id_close, 
  tk_msg_id_idle, 
  tk_msg_id_game_data, 
};

struct TKCAGHEADER {
  uint32 msg_length_;
};

struct TKNETCONNECTEDACK {
  TKCAGHEADER msg_header_;
  uint32 sid_;
  uint32 port_;
  char peer_ip_[kIPLen];
};

struct TKNETCLOSEDACK {
  TKCAGHEADER msg_header_;
  uint32 sid_;
  uint32 port_;
  char peer_ip_[kIPLen];
};

struct NetMsg {
  uint32 net_sid_;
  char* msg_;
  NetMsg() {
    net_sid_ = 0;
    msg_ = NULL;
  }
  NetMsg(uint32 sid, char* msg) {
    net_sid_ = sid;
    msg_ = msg;
  }
};

#endif
