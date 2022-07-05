#ifndef  TCP_DEFS_H_
#define  TCP_DEFS_H_

#include <boost/cstdint.hpp>

typedef boost::uint32_t TCPSessionID;
typedef boost::uint32_t TCPIOThreadID;
const TCPSessionID kInvalidTCPSessionID = 0;
const TCPIOThreadID kInvalidTCPIOThreadID = -1;
const boost::uint32_t kRecvBuffLength = 1024;
const boost::uint32_t kMaxRecvMsgLength = (1024*100);

#define NET_ERROR	"./log/net_error"

#define safe_free(x) if( (x)!=NULL ) { free((x)); (x)=NULL; }

//debug
#define enterfunc()		try {
#define exitfunc()		} catch(...){ SLOG(NET_ERROR, "exception %s %d", __FILE__, __LINE__); }
//

#endif   // ----- #ifndef TCP_DEFS_H_  -----
