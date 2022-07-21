#ifndef __INI_H__
#define __INI_H__

#include <string>
#include <fstream>
#include <map>

#include "headers.h"

typedef std::map<std::string,int>							ConfigerValueHashMap;
typedef std::map<std::string,ConfigerValueHashMap* >		ConfigerSectionHashMap;


#define CONFIGER_BUF_SIZE		1024
#define CONFIGER_NOTE			(';')

#ifdef _DEBUG
#define Assert(exp, message) \
{ \
if (!(exp)) \
{ \
exit(EXIT_FAILURE); \
} \
}
#else
#define Assert(exp, message)
#endif

class Ini {
public:
  Ini();
  Ini(const char* filename);
  virtual ~Ini();

  BOOL Open(const char* filename);
  void Close();

  int32 GetInt(char *section, char *key, int32 nDefault=0);
  BOOL GetIntIfExist(char *section, char *key, int32& nResult);
  float GetFloat(char *section, char *key, float fDefault=0.0f);
  BOOL GetFloatIfExist(char *section, char *key, float& fResult);
  BOOL GetText(char *section, char *key, char *str, int32 size, const char* strDefault="");
  BOOL GetTextIfExist(char *section, char *key, char *str, int32 size);

private:
  BOOL _GetInt(char *section, char *key, int32& nResult);
  BOOL _GetFloat(char *section, char *key, float& fResult);
  BOOL _GetText(char *section, char *key, char *str, int32 size);
  void _TrimString(char* buf);
  BOOL _ParseSection(char* buf, char** pSection);
  BOOL _ParseKey(char* buf, char** sKey, char** sValue);
  void _ResizeBuf();
  char* _GetBufString(int32 nPos);
  int32 _AddBufString(char* str);

private:
  std::ifstream m_ifile;
  char m_szFileName[MAX_FILE_PATH];
  ConfigerSectionHashMap m_SectionData;
  ConfigerValueHashMap* m_pCurSection;
  char* m_pBuf;
  int32 m_nBufLen;
  int32 m_nBufMaxLen;
};

#endif

