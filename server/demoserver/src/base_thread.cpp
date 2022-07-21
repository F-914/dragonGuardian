/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-19
*	Description	:	工作线程基类定义实现文件
--------------------------------------------------*/

#include "util.h"
#include "base_thread.h"
#include "protocol_def.h"

BaseThread::BaseThread() {
  thread_ptr_ = NULL;
}

BaseThread::~BaseThread() {
}

bool BaseThread::Init() {
  return true;
}

void BaseThread::Destroy() {
  thread_ptr_->join();
  KSafeDelete(thread_ptr_);
}

void BaseThread::Run() {
  while (true) {
    boost::this_thread::sleep(boost::posix_time::milliseconds(1));
  }
}
