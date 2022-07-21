/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-20
*	Description	:	消息分发线程定义实现文件
--------------------------------------------------*/

#include "log.h"
#include "json.h"
#include "timesystem.h"
#include "msg_thread.h"
#include "json_writer.h"
#include "demo_service.h"
#include "protocol_def.h"

MsgThread::MsgThread() {
}

MsgThread::~MsgThread() {
}

bool MsgThread::Init() {
  thread_ptr_ = new(std::nothrow) boost::thread(&MsgThread::Run, this);
  if (thread_ptr_ == NULL) {
    SLOG(STARTUP_ERROR, "start msg thread fail");
    return false;
  }
  return true;
}

void MsgThread::Destroy() {
  BaseThread::Destroy();
  NetMsg* msg = NULL;
  while(net_msg_.try_pop(msg)) {
    KSafeFree(msg->msg_);
    KSafeDelete(msg);
  }
}

void MsgThread::Run() {
  while (true) {
    uint32 now = GET_TIME().TickCount();
    Tick(now);
    boost::this_thread::sleep(boost::posix_time::milliseconds(1));
  }
}

void MsgThread::Tick(uint32 now) {
  NetMsg* msg = NULL;
  while(net_msg_.try_pop(msg)) {
    DispatchClientMsg(msg);
    KSafeFree(msg->msg_);
    KSafeDelete(msg);
  }
}

void MsgThread::PushMsg(NetMsg* msg) {
  net_msg_.push(msg);
}

void MsgThread::DispatchClientMsg(NetMsg* msg) {
  TKCAGHEADER* header = (TKCAGHEADER*)(msg->msg_);
  std::string msg_str((char*)(header + 1), header->msg_length_);
  Json::Reader reader;
  Json::FastWriter writer;
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
  root["sid"] = msg->net_sid_;
  std::string new_msg(writer.write(root).c_str());
  if (type <= (tk_req + 1000))
    gtk_demo_service->PushMsg2Lobby(new_msg);
  else
    gtk_demo_service->PushMsg2Game(new_msg);
}
