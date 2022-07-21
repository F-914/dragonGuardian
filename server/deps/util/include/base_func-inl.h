/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2017
*	Author		:	chi.w
*	Date		:	2017-09-05
*	Description	:	基础内联函数文件
--------------------------------------------------*/

#ifndef __BASE_FUNC_INL_H__
#define __BASE_FUNC_INL_H__

#include "log.h"

inline void TKWriteOutOfMemory(const char* file, int line) {
  QLOG(LOG_ERROR, "malloc memory fail,%s %d", file, line);
}

inline void TKPromptNullPointer(const char* file, int line) {
  QLOG(LOG_ERROR, "null pointer,%s %d", file, line);
}

#endif
