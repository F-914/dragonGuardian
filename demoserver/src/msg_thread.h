/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-20
*	Description	:	消息分发线程定义头文件
--------------------------------------------------*/

#ifndef __MSG_THREAD_H__
#define __MSG_THREAD_H__

#include "typedef.h"
#include "base_thread.h"
#include "thread_safe_queue.h"

class MsgThread : public BaseThread {
public:
  MsgThread();
  ~MsgThread();

  virtual bool Init();
  virtual void Destroy();

  void PushMsg(NetMsg* msg);
  void PushMsg(const std::string msg_str) {}
  void GetMsg(std::string& msg_str) {}

protected:
  virtual void Run();

private:
  void Tick(uint32 now);
  void DispatchClientMsg(NetMsg* msg);

private:
  concurrent_queue<NetMsg*> net_msg_;
};

#endif
