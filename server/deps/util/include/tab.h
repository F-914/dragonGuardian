#ifndef __TAB_H__
#define __TAB_H__

#include "typedef.h"
#include <vector>
#ifdef WIN32
#include <hash_map>
#else
#include <ext/hash_map>
#endif

const int kMaxFilePath = 260;

typedef unsigned char uchar;

using namespace std;

class TABFile {
public:
  struct FILE_HEAD {
    uint32 m_Identify;
    int32 m_nFieldsNum;
    int32 m_nRecordsNum;
    int32 m_nStringBlockSize;
  };

  enum FIELD_TYPE { T_INT = 0, T_FLOAT = 1, T_STRING = 2, };

  typedef vector<FIELD_TYPE> FILEDS_TYPE;

  union FIELD {
    float fValue;
    int32 iValue;
    char *pString;

    FIELD() {
    }
    FIELD(int32 value) {
      iValue = value;
    }
    FIELD (float value) {
      fValue = value;
    }
    FIELD (char *value) {
      pString = value;
    }
  };

  typedef vector<FIELD> DATA_BUF;

public:
  //���ļ��д�
  bool OpenFromTXT(const char *szFileName);
  //���ڴ��д�
  bool OpenFromMemory(
      const char *pMemory, 
      const char *pDeadEnd, 
      const char *szFileName = 0);

protected:
  bool OpenFromMemoryImpl_Text(
      const char *pMemory, 
      const char *pDeadEnd, 
      const char *szFileName = 0);

  bool OpenFromMemoryImpl_Binary(
      const char *pMemory, 
      const char *pDeadEnd, 
      const char *szFileName = 0);

public:
  //������������nValue��ֵ�� û���ҵ�����0
  virtual const FIELD *Search_Index_EQU(int32 nValue) const;
  //����ֵ nRecordLine �У�ColumNum ��
  virtual const FIELD *Search_Posistion(
      int32 nRecordLine, 
      int32 nColumNum) const;
  //����nColumnNum�е�һ������value��ֵ�� û���ҵ�����0
  virtual const FIELD *Search_First_Column_Equ(
      int32 nColumnNum, 
      const FIELD &value) const;

public:
  //û���õ�
  uint32 GetID(void) const {
    return m_ID;
  }

  //��
  int32 GetFieldsNum(void) const {
    return m_nFieldsNum;
  }

  //��Ч����
  int32 GetRecordsNum(void) const {
    return m_nRecordsNum;
  }

  //��ĳһ�д���hash������������ҡ�Ĭ���ǰѵ�һ�д���Ϊ����
  void CreateIndex(int32 nColum = 0, const char *szFileName = 0);

protected:
#ifdef __SGI_STL_PORT
  typedef std::hash_map<int32, FIELD *> FIELD_HASHMAP;
#else
#ifdef WIN32
  typedef stdext::hash_map<int32, FIELD *> FIELD_HASHMAP;
#else
  typedef __gnu_cxx::hash_map<int32, FIELD *> FIELD_HASHMAP;
#endif
#endif
  
  uint32 m_ID;
  FILEDS_TYPE m_theType;
  int32 m_nRecordsNum;
  int32 m_nFieldsNum;
  DATA_BUF m_vDataBuf;
  char *m_pStringBuf;
  int32 m_nStringBufSize;
  FIELD_HASHMAP m_hashIndex;
  int32 m_nIndexColum;
  char m_szFileName[kMaxFilePath];

public:
  static int32 _ConvertStringToVector(
      const char *strStrINTgSource, 
      vector<std::string> &vRet, 
      const char *szKey, 
      bool bOneOfKey, 
      bool bIgnoreEmpty);

  static const char *_GetLineFromMemory(
      char *pStringBuf, 
      int32 nBufSize, 
      const char *pMemory,  
      const char *pDeadEnd);

  template<FIELD_TYPE T>
  static bool _FieldEqu(const FIELD & a, const FIELD & b);

public:
  TABFile(uint32 id);
  virtual ~TABFile();
};

#endif
