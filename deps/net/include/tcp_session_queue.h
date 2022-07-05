#ifndef  TCP_SESSION_QUEUE_H_
#define  TCP_SESSION_QUEUE_H_

#include "net.h"
#include <deque>

#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>

#include "tcp_defs.h"

class TCPSession;

// =====================================================================================
//        Class:  TCPSessionQueue
//  Description:  TCPSessionQueue, manages TCPSession
// =====================================================================================
class Net_API TCPSessionQueue {
public:
	// ====================  TYPEDEFS      =======================================
	typedef boost::shared_ptr<TCPSession>   SessionPointer;

	// ====================  LIFECYCLE      =======================================
	~TCPSessionQueue();

	// ====================  OPERATIONS    =======================================
	bool Add(SessionPointer session);
	void Remove(SessionPointer session);
	void Remove(TCPSessionID id);
	void Clear();
	void CloseAllSession();
	SessionPointer Get(TCPSessionID id);

private:
	// ====================  DATA MEMBERS  =======================================
	typedef boost::unordered_map<TCPSessionID, SessionPointer> SessionMap;
	SessionMap map_;
}; // -----  end of class TCPSessionQueue  -----


#endif   // ----- #ifndef TCP_SESSION_QUEUE_H_  -----
