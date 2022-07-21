#ifndef __UTIL_H__
#define __UTIL_H__

#include "typedef.h"
#include <string>
#include <vector>
#include <map>
#include <set>

#define __PI 3.1415f
#define __HALF_PI __PI / 2
#define __QUARTER_PI __PI / 4

class CTinyTimer {
private:
  uint32 m_uTickTerm;
  uint32 m_uTickOld;
  uint32 m_uTickBegin;
  uint32 m_uLeftTime;

public:
  bool m_bOper;

public:
  CTinyTimer() {
    m_bOper = FALSE;
    Clear();
  }
  bool IsSetTimer() {
    return m_bOper;
  }
  void SetTermTime(uint32 uTerm) {
    m_uTickTerm = uTerm;
  }
  uint32 GetLeftTime(uint32 uNow) {
    uint32 uLefetime = 0;
    uint32 uElapsetime = uNow - m_uTickBegin;
    uLefetime = m_uTickTerm - uElapsetime;
    m_uLeftTime = uLefetime;
    return m_uLeftTime;
  }
  uint32 GetTermTime() {
    return m_uTickTerm;
  }
  uint32 GetTickOldTime() {
    return m_uTickOld;
  }
  void Clear() {
    m_uTickTerm = 0;
    m_bOper = FALSE;
    m_uTickOld = 0;
  }
  void BeginTimer(uint32 uTerm, uint32 uNow) {
    m_bOper = TRUE;
    m_uTickTerm = uTerm;
    m_uTickOld = uNow;
    m_uTickBegin = uNow;
  }
  BOOL CountingTimer(uint32 uNow) {
    if(!m_bOper) return FALSE;
    uint32 uNew = uNow;
    uint32 uDelta = 0;
    if(uNew >= m_uTickOld) {
      uDelta = uNew - m_uTickOld;
    } else {
      if((uNew + 10000) < m_uTickOld) {
        uDelta = ((uint32) 0xFFFFFFFF - m_uTickOld) + uNew;
      } else {
        return FALSE;
      }
    }
    if(uDelta < m_uTickTerm) {
      return FALSE;
    }
    m_uTickOld = uNew;
    m_uTickBegin = uNew;
    return TRUE;
  }
};

#if defined(WIN32)
#define tvsnprintf _vsnprintf
#define tstricmp _stricmp
#define tsnprintf _snprintf
#pragma warning(disable : 4996)
#else
#define tvsnprintf vsnprintf
#define tstricmp strcasecmp
#define tsnprintf snprintf
#endif

#ifndef KSafeDelete
#if defined(WIN32)
#define KSafeDelete(x) \
	if((x) != NULL) \
{ \
	assert(_CrtIsValidHeapPointer(x)); \
	delete(x); \
	(x) = NULL; \
}
#else
#define KSafeDelete(x) \
	if((x) != NULL) \
{ \
	delete(x); \
	(x) = NULL; \
}
#endif
#endif
#ifndef KSafeDelete_ARRAY
#if defined(WIN32)
#define KSafeDelete_ARRAY(x) \
	if((x) != NULL) \
{ \
	assert(_CrtIsValidHeapPointer(x)); \
	delete[](x); \
	(x) = NULL; \
}
#else
#define KSafeDelete_ARRAY(x) \
	if((x) != NULL) \
{ \
	delete[](x); \
	(x) = NULL; \
}
#endif
#endif
#ifndef KSafeFree
#define KSafeFree(x) \
	if((x) != NULL) \
{ \
	free(x); \
	(x) = NULL; \
}
#endif
#ifndef KSafeRelease
#define KSafeRelease(x) \
	if((x) != NULL) \
{ \
	(x)->Release(); \
	(x) = NULL; \
}
#endif
#ifndef Min
#define Min(x, y) ((x) < (y) ? (x) : (y))
#endif
#ifndef Max
#define Max(x, y) ((x) > (y) ? (x) : (y))
#endif

extern char Data2Ascii(char in);
extern char Ascii2Data(char in);

#define GB_ENCODING "gb18030"
#define UTF_ENCODING "utf-8"
extern int code_convert_gbk2utf8(
    const char *inbuf, 
    size_t inlen, 
    char *outbuf, 
    size_t &outlen);
extern int code_convert_utf82gbk(
    const char *inbuf, 
    size_t inlen, 
    char *outbuf, 
    size_t outlen);
extern int code_convert_gbk2utf8(
    const char *inbuf, 
    size_t inlen, 
    char *outbuf, 
    int &outlen);
extern uint32 GetCurrentDate();
extern bool CheckDateValid(int year, int mon, int day);
extern bool CheckTimeValid(int hour, int min, int sec);
extern void StrSplit(
    const std::string& src, 
    char ch, 
    std::vector<std::string>& ret);
extern uint32 GetDayElapseSeconds();
extern uint32 GetDaysThisMonth();
extern bool SameDay(uint32 time1, uint32 time2);
extern bool SameWeek(uint32 time1, uint32 time2);
extern bool SameMonth(uint32 time1, uint32 time2);

//取得本机IP
extern char* TKGetLocalHostIP(char *pszIP);//如果失败返回"0.0.0.0"
//判断是否是系统邮件
extern bool IsSystemEmail(const std::string& email_type);
//从邮件row_key中提取出id
extern std::string GetEmailSenderId(const std::string& email_key);
extern void SplitStr(
    std::vector<std::string> &str_vec,
    const std::string& strData,
    const std::string& strSplit);

extern std::string ToUtf8(const std::string& str);
extern std::string ToUtf8_FromGB18030(const std::string& str);
extern std::string TraceStack();    //获得函数调用堆栈信息

struct Region {
  uint32 lower_limit_;
  uint32 upper_limit_;
  Region() {
    lower_limit_ = 0;
    upper_limit_ = 0;
  }
};

struct TimeInterval {
  int start_time_;
  int end_time_;
  TimeInterval() {
    start_time_ = 0;
    end_time_ = 0;
  }
  TimeInterval(int begin, int end) {
    start_time_ = begin;
    end_time_ = end;
  }
};

extern bool SplitDate(
    const std::string& date_str, 
    std::set<uint32>& all_date);
extern bool SplitDay(
    const std::string& day_str, 
    std::set<uint32>& all_day);
extern bool SplitTime(
    const std::string& time_str, 
    uint32& time);
extern bool SplitDateTime(
    const std::string& time_str, 
    uint32& time);
extern bool SplitKV(
    const std::string& kv_str, 
    std::map<uint32, uint32>& all_kv);
extern bool SplitKVRegion(
    const std::string& kv_str, 
    std::map<uint32, Region>& all_kv);
extern bool GenEffectiveTimeInterval(
    std::vector<TimeInterval>& time_interval, 
    const std::string& time_str);
extern int GenTsWithStr(const std::string& ts_str);

extern std::string UrlEncode(const std::string& str);
extern std::string UrlDecode(const std::string& str);

extern void GenRandomIds(
    std::map<uint32, uint32>& id_weight, 
    uint32 max_count, 
    std::set<uint32>& ids);
extern void GenRandomIds(
    std::vector<uint32>& ids_in, 
    uint32 max_count, 
    std::vector<uint32>& ids_out);

#endif //__UTIL_H__
