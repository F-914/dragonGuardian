#ifndef  TCP_SESSION_HANDLER_H_
#define  TCP_SESSION_HANDLER_H_

#include "net.h"
#include <boost/noncopyable.hpp>
#include <boost/enable_shared_from_this.hpp>

#include "tcp_defs.h"

class TCPIOThread;
class TCPIOThreadManager;

// =====================================================================================
//        Class:  TCPSessionHandler
//  Description:  Handles TCPSession
// =====================================================================================
class Net_API TCPSessionHandler : public boost::enable_shared_from_this<TCPSessionHandler>,
	public boost::noncopyable {
		friend class TCPIOThreadManager;
public:
	// ====================  TYPEDEFS      =======================================

	// ====================  LIFECYCLE     =======================================
	TCPSessionHandler();
	virtual ~TCPSessionHandler();

public:
	// ====================  OPERATIONS    =======================================
	// call when connection complete
	virtual void OnConnect(TCPSessionID sid, const char* ip, unsigned short port) = 0;

	// call when NetMessage received
	virtual void OnMessage(TCPSessionID sid, char* message) = 0;

	// call when TCPSession is closed.After call,this object will be deleted.
	virtual void OnClose(TCPSessionID sid, std::string ip, unsigned short port) = 0;
}; // -----  end of class TCPSessionHandler  -----


#endif   // ----- #ifndef TCP_SESSION_HANDLER_H_  -----
