#ifndef __LOG_THREAD_H__
#define __LOG_THREAD_H__

#include "thread.h"
#include "util.h"
#include "singleton.h"
#include "thread_base.h"

#define STARTUP_ERROR    "./log/startup_error"

enum LogChannelType {
  LOG_DEBUG         = 0, 
  LOG_INFO          = 1, 
  LOG_WARN          = 2, 
  LOG_ERROR         = 3, 
  LOG_FATAL         = 4, 
  LOG_STAT          = 5, 
  LOG_TEST          = 6, 
  LOG_NET           = 7, 
  LOG_PERF          = 8, 
                      
  LOG_USERDEF_START = 9, //其他系统自我扩展的开始编号
};

class LogChannel {
public:
  LogChannel();
  ~LogChannel();
  
  bool Init(
      const char* fixed_path, 
      const char* name, 
      int32 cachesize);

  int32 Push(const char* msg);

  /**
   * @brief: 输出全部缓存的日志
   * @note : exchange_log_为外部提供的动态缓存,用于和Channel本身交互动态缓存
   * @remark : exchenge_log必须为动态缓存,大小为cache_size
   */
  int32 Pop(char*& exchange_log);

  void RefreshFmtPath(bool re_fmt_path) {
    re_fmt_path_ = re_fmt_path;
  }

  char* GetPath(){ return log_path_; }

private:
  bool FmtFixPath(
      const char* fixed_path, 
      const char* name);

  void FmtLogPath();

private:
  char*     cache_log_;
  int32     cache_size_;
  int32     write_pos_;
  char*     fixed_path_;
  char*     log_path_;
  bool      re_fmt_path_;
  FastLock* lock_;
};

class LogSys : public ThreadBase, public MQSingleton<LogSys> {
private:
  friend class MQSingleton<LogSys>;

protected:
  LogSys();

public:
  virtual ~LogSys();

public:
  virtual void  Push(int type, char *msg);

  bool IsExist(int32 type);
  bool Register(int32 type, char* name);

protected:
  virtual bool OnInit();
  virtual void Update(uint32 now);
  virtual void OnDestroy();

private:
  void Save(const char* path);

private:
  int32 cache_size_;
  char* exchange_log_;
  int32 exchange_size_;

  std::map<int32, LogChannel> channels_;
  CTinyTimer refresh_fmt_path_;

public:
  static std::string prefix_name;
};

void QLOG(int32, const char *cszFormat, ...);
void QLOG_NOHEAD(int32, const char *cszFormat, ...);
void SLOG(const char *, const char *cszFormat, ...);

#endif //__LOG_THREAD_H__
