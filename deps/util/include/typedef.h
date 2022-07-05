#ifndef __BASETYPE_H__
#define __BASETYPE_H__

#include <stdio.h>
#include <math.h>

#if defined(WIN32)
#pragma warning(disable:4786)
#pragma warning(disable:4018)
#pragma warning(disable:4996) //全部关掉
//#pragma warning(once:4996) //仅显示一个
#endif


typedef unsigned char        uchar;
typedef char                 int8;
typedef uchar                uint8;
typedef unsigned short       uint16;
typedef short                int16;
typedef unsigned int         uint32;
typedef int                  int32;
typedef double               float64;

#if defined(WIN32)
typedef unsigned long        DWORD;
#else
typedef uint32       DWORD;
#endif

//typedef uint32       time_t;
typedef unsigned short       WORD;
typedef unsigned long long   ULONGLONG;
#if defined(WIN32)
typedef unsigned long        TID;
typedef unsigned __int64     uint64;
typedef __int64              int64;
#else
typedef unsigned long long   uint64;
typedef long long            int64;
typedef unsigned long        TID;
#endif
typedef unsigned long        IP_t;
typedef uint16               MSG_ID;
typedef int32                BOOL;
typedef unsigned char        BYTE;
typedef int64                LONGLONG;
typedef uint64               UINT64;
typedef unsigned int         UINT;
typedef unsigned long long   Key_ID;
typedef uint64               guid64;

#ifndef TRUE
#define TRUE	1
#endif
#ifndef FALSE
#define FALSE	0
#endif
#ifndef _MAX_PATH
#define _MAX_PATH	260
#endif

#endif
