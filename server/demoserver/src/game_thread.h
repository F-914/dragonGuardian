/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-20
*	Description	:	game线程定义头文件
--------------------------------------------------*/

#ifndef __GAME_THREAD_H__
#define __GAME_THREAD_H__

#include "typedef.h"
#include "base_thread.h"
#include "thread_safe_queue.h"

class GameThread : public BaseThread {
public:
  GameThread();
  ~GameThread();

  virtual bool Init();

  void PushMsg(NetMsg* msg) {}
  void PushMsg(const std::string msg_str);
  void GetMsg(std::string& msg_str);

protected:
  virtual void RunLua();

private:
  concurrent_queue<std::string> str_msg_;
};

#endif
