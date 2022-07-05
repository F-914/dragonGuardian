#ifndef __THREAD_H__
#define __THREAD_H__

#include "headers.h"

#if defined(WIN32)
#include "windows.h"
#endif

#define THREAD_CAPS	(512)

class ThreadIndent {
public:
  ThreadIndent();
  ~ThreadIndent();

  void AddThread(TID tid);
  void SetThreadIndent(TID tid, int32 nValue);
  int32 GetThreadIndent(TID tid);

  TID m_ThreadID[THREAD_CAPS];
  int32 m_ThreadIndent[THREAD_CAPS];
};

extern ThreadIndent	g_ThreadIndent;

class FastLock {
private:
#if defined(WIN32)
  CRITICAL_SECTION m_Lock;
#else
  pthread_mutex_t m_Mutex;
#endif

public:
  BOOL mStatus;
  FastLock();
  ~FastLock();
  void Lock();
  void Unlock();
};

template<typename Mutex>
class _lock_guard {
private:
  Mutex &m;
  explicit _lock_guard(_lock_guard &);
  _lock_guard &operator	=(_lock_guard &);
public:
  explicit _lock_guard(Mutex &m_) :
  m(m_) {
    m.Lock();
  }
  ~_lock_guard(void) {
    m.Unlock();
  }
};

///////////////////////////////////////////////////////////////////////////////
// Thread Module
///////////////////////////////////////////////////////////////////////////////
enum ThreadStep {
    ts_0, 
    ts_1, 
    ts_2, 
    ts_3, 
    ts_4, 
    ts_5, 
    ts_6, 
    ts_7, 
    ts_8, 
    ts_9, 
};
class KThread {
public:
  enum RunState {
      THREAD_READY, 
      THREAD_RUNNING, 
      THREAD_EXITING, 
      THREAD_FINISH 
  };

public:
  KThread();
  virtual ~KThread();

public:
  void start();
  virtual void stop();
  void exit(void *retval = NULL);
  virtual void run();

public:
  TID getTID() { return m_TID; }
  RunState getState() { return m_Status; }
  void setState(RunState status) { m_Status = status; }
  int32 getTickCount() { return m_TickCount; }
  int32 getSteps() { return m_Steps; }
  virtual BOOL getInit() {
    return FALSE;
  }

private:
  TID m_TID;
  RunState m_Status;

#if defined(WIN32)
  HANDLE m_hThread;
#endif

protected:
  int32 m_TickCount;
  int32 m_Steps;
};

extern uint32 g_ThreadCount;
extern uint32 g_WaitQuitThreadCount;

#if defined(__LINUX__)
void *ThreadEntry(void *derivedThread);
#elif defined(WIN32)
unsigned long WINAPI ThreadEntry(void *derivedThread);
#endif

TID KGetCurrentTID();
TID GetOrigineThreadID();
uint32 MyGetCurrentPID();

#endif
