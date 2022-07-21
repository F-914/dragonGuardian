#ifndef  TCP_IO_THREAD_MANAGER_H_
#define  TCP_IO_THREAD_MANAGER_H_

#include "net.h"
#include <vector>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/unordered_map.hpp>

#include "tcp_defs.h"
#include "tcp_io_thread.h"
#include "id_generator.h"

class NetMessage;
class TCPSession;
class TCPSessionHandler;

// =====================================================================================
//        Class:  TCPIOThreadManager
//  Description:  Manages TCPIOThreads
// =====================================================================================
class Net_API TCPIOThreadManager : public boost::noncopyable {
public:
	// ====================  CONSTANTS     =======================================
	const static TCPIOThreadID kMainThreadID = 0;

	// ====================  TYPEDEFS      =======================================
	typedef boost::shared_ptr<TCPIOThread>        ThreadPointer;
	typedef boost::shared_ptr<TCPSession>         SessionPointer;
	typedef boost::shared_ptr<TCPSessionHandler>  SessionHandlerPointer;
	typedef boost::unordered_map<TCPSessionID, 
		SessionHandlerPointer>              SessionHandlerMap;
	typedef boost::unordered::unordered_map<TCPSessionID, 
		TCPIOThreadID>			Sid2TidMap;

	// ====================  LIFECYCLE     =======================================
	TCPIOThreadManager(size_t thread_num);
	~TCPIOThreadManager();

	// ====================  ACCESSORS     =======================================
	boost::asio::io_service& io_service() { 
		return threads_[kMainThreadID]->io_service(); 
	}
	// ====================  MUTATORS      =======================================

	// ====================  OPERATIONS    =======================================
	// Gets thread by the specific id
	TCPIOThread& GetThread(TCPIOThreadID id) { return *threads_[id]; }
	// Gets thread by load balancing, under multi-thread curcumstance, never
	// returns the main thread.
	TCPIOThread& GetThread() {
		if (threads_.size() == 1) return *threads_[kMainThreadID]; // single thread
		if (++next_thread_id_ >= threads_.size()) next_thread_id_ = 1;
		return *threads_[next_thread_id_];
	};
	// Gets the main thread
	TCPIOThread& GetMainThread() {
		return *threads_[kMainThreadID];
	}

	// Async call when session is closed.
	void Run();
	void Stop();

	void SendMsg2Session(TCPSessionID sid, char* message);
	void CloseSession(TCPSessionID sid, bool bforce=false);

private:
	friend class TCPSession;
	friend class TCPServer;
	friend class TCPClient;
	// Must be called in the main thread.
	// Adds the session to any thread, don't keep the pointer of session after 
	// this function called.
	void OnSendMsg2Session(TCPSessionID id, char* message);
	void OnSessionClose(TCPSessionID id);
	void OnSessionConnect(SessionPointer session, SessionHandlerPointer handler);
	void OnSessionConnectFail(SessionPointer session, SessionHandlerPointer handler, std::string rip, unsigned short rport);
	void OnCloseSession(TCPSessionID sid, bool bforce=false);
	TCPIOThreadID GetThreadId(TCPSessionID sid);

private:
	// ====================  DATA MEMBERS  =======================================
	typedef IDGenerator<TCPSessionID>       SessionIDGenerator;
	std::vector<ThreadPointer>              threads_;
	SessionIDGenerator                      session_id_generator_;
	TCPIOThreadID                           next_thread_id_;
	Sid2TidMap				map_sid2tid_;
	boost::mutex							sid2tid_mutex_;
}; // -----  end of class TCPIOThreadManager  -----

#endif   // ----- #ifndef TCP_IO_THREAD_MANAGER_H_  -----
