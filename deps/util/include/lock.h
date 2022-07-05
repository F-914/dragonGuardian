/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2018
*	Author		:	chi.w
*	Date		:	2018-12-19
*	Description	:	锁定义文件
--------------------------------------------------*/

#ifndef __LOCK_H__
#define __LOCK_H__

#include <boost/thread/locks.hpp>
#include <boost/thread/shared_mutex.hpp>

typedef boost::shared_mutex Lock;      
typedef boost::unique_lock<Lock> WLock;
typedef boost::shared_lock<Lock> RLock;

#endif
