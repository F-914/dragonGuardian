#ifndef JSON_FORWARDS_H_INCLUDED
# define JSON_FORWARDS_H_INCLUDED

# include "json_config.h"

namespace Json {

   // writer.h
   class FastWriter;
   class StyledWriter;

   // reader.h
   class Reader;

   // features.h
   class Features;

   // value.h
   typedef int Int;
   typedef unsigned int UInt;
#if defined(WIN32) // Microsoft Visual Studio
   typedef __int64 Int64;
   typedef unsigned __int64 UInt64;
#elif defined(__LINUX__)
   typedef long long Int64;
   typedef unsigned long long UInt64;
#else                 // if defined(_MSC_VER) // Other platforms, use long long
   typedef int64_t Int64;
   typedef uint64_t UInt64;
#endif // if defined(_MSC_VER)

   class StaticString;
   class Path;
   class PathArgument;
   class Value;
   class ValueIteratorBase;
   class ValueIterator;
   class ValueConstIterator;
#ifdef JSON_VALUE_USE_INTERNAL_MAP
   class ValueAllocator;
   class ValueMapAllocator;
   class ValueInternalLink;
   class ValueInternalArray;
   class ValueInternalMap;
#endif // #ifdef JSON_VALUE_USE_INTERNAL_MAP

} // namespace Json


#endif // JSON_FORWARDS_H_INCLUDED
