/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-19
*	Description	:	工作线程基类定义头文件
--------------------------------------------------*/

#ifndef __BASE_THREAD_H__
#define __BASE_THREAD_H__

#include <boost/thread.hpp>
#include <string>

struct NetMsg;
class BaseThread {
public:
  BaseThread();
  virtual ~BaseThread();

  virtual bool Init();
  virtual void Destroy();

  virtual void PushMsg(NetMsg* msg) = 0;
  virtual void PushMsg(const std::string msg_str) = 0;
  virtual void GetMsg(std::string& msg_str) = 0;

protected:
  virtual void Run();

protected:
  boost::thread* thread_ptr_;
};

#endif
