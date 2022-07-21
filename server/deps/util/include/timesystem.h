#ifndef __TIMESYSTEM_H__
#define __TIMESYSTEM_H__

#include "typedef.h"
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <math.h>
#include <stdarg.h>
#include <stdlib.h>
#include <memory>

#ifdef WIN32
#include <time.h>
#pragma warning(disable : 4996)
#else
#include <sys/time.h>
#endif

class TimeSystem {
  TimeSystem(void);
  ~TimeSystem(void);

public:
  static TimeSystem &instance(void);
  BOOL Init();

public:
  uint32 TickCount();
  uint32 NowSavedTime() const { return m_Now; }
  uint32 OrigineTime() const { return m_Begin; }
  void Update() const;
  uint32 GetCTime() const;
  uint32 RefixANSITimeByTimeZone(uint32 uTime) const;

public:
  int32 year() const { return m_TM.tm_year + 1900; }
  int32 month() const { return m_TM.tm_mon + 1; }
  int32 day() const { return m_TM.tm_mday; }
  int32 hour() const { return m_TM.tm_hour; }
  int32 minute() const { return m_TM.tm_min; }
  int32 second() const { return m_TM.tm_sec; }
  uint32 week() const { return m_TM.tm_wday; }
  uint32 Time2DWORD() const;
  uint32 CurrentDate() const;
  uint32 DiffTime(uint32 Date1, uint32 Date2) const;
  void ConvertUT(uint32 Date, tm *TM) const;
  void ConvertTU(tm *TM, uint32 &Date) const;
  uint32 GetDayTime();
  uint32 GetYMD(time_t time_t_param);
  void CovertToTM(tm& TM, time_t time_t_param);
  void GetCurTM(tm& TM);
  int32 GetIndexWeek(const tm& curTM);
  int32 GetIndexWeek(time_t curTM);
  int32 GetCurrentMonthDays(time_t time_t_param);

private:
  uint32 m_Begin;
  mutable uint32 m_Now;
  mutable time_t m_TimeT;
  mutable tm m_TM;

#ifdef __LINUX__
  struct timeval _tstart;
  //struct timeval _tend;
  //struct timezone tz;
#endif

  uint32 _CurrentTime();
};

#define INIT_TIMESYSTEM() TimeSystem::instance().Init()
#define GET_TIME() TimeSystem::instance()

#endif
