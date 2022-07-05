/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2018
*	Author		:	chenkp
*	Date		:	2018-10-29
*	Description	:	线程头文件
--------------------------------------------------*/

#ifndef __THREAD_BASE_H__
#define __THREAD_BASE_H__

#include "typedef.h"
#include <boost/thread.hpp>
#include <cassert>

enum ThreadType {
  log_thread, 
  net_thread, 
  job_thread, 
  common_thread, 
};

class ThreadBase {
public:
  ThreadBase(ThreadType type);
  virtual ~ThreadBase();

  bool Init();
  void Run();
  void Destroy();
  
  virtual void Push(char* msg);
  virtual void Push(int type, char* msg);

protected:
  virtual bool OnInit() = 0;
  virtual void Update(uint32 now) = 0;
  virtual void OnDestroy() = 0;

protected:
  ThreadType type_;
  int fixed_frame_time_;
  boost::thread* thread_handle_;
};

#endif //__THREAD_BASE_H__
