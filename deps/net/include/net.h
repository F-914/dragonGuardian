#ifndef __crazygamer_net_h__
#define __crazygamer_net_h__

#if defined(_WIN32)
#define Net_API __declspec(dllexport)
#pragma warning(disable : 4275)
#pragma warning(disable : 4251)
#endif

#if !defined(Net_API)
#define Net_API
#endif



#endif

