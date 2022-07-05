#ifndef  TCP_SESSION_H_
#define  TCP_SESSION_H_

#include "net.h"
#include <string>
#include <queue>

#include <boost/asio/ip/tcp.hpp>
#include <boost/date_time/posix_time/ptime.hpp>
#include <boost/enable_shared_from_this.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>

#include "tcp_session_handler.h"
#include "tcp_session_queue.h"
#include "tcp_defs.h"

enum SessionType
{
	session_client = 0,
	session_server,
};

class NetMessageFilterInterface;
class TCPIOThread;

// =====================================================================================
//        Class:  TCPSession
//  Description:  TCPSession, no concerning about client or server, deals with
//  message packing, compression, encryption, sending (from the sender's view) 
//  and vice versa.
// =====================================================================================
class Net_API TCPSession : public boost::enable_shared_from_this<TCPSession>, 
	public boost::noncopyable {
public:
	// ====================  TYPEDEFS      =======================================
	typedef boost::shared_ptr<TCPSessionHandler>          HandlerPointer;
	typedef boost::shared_ptr<NetMessageFilterInterface>  FilterPointer;

	// ====================  LIFECYCLE     =======================================
	TCPSession(TCPIOThreadManager& io_thread_manager, 
		FilterPointer filter, SessionType type);
	~TCPSession();

	// ====================  ACCESSORS     =======================================
	boost::asio::ip::tcp::socket& socket() { return socket_; }
	TCPIOThread& thread() { return thread_; }
	TCPSessionID id() const { return id_; }
	TCPIOThreadID threadid() const { return threadid_; }


private:
	friend class TCPSessionHandler;
	friend class TCPSessionQueue;
	friend class TCPIOThreadManager;
	friend class TCPIOThread;
	// called by TCPIOThreadManager
	void Init(TCPSessionID id, HandlerPointer session_handler_pointer, std::string ip, unsigned short port);
	// connect fail
	void ConnectFail(TCPSessionID id, HandlerPointer session_handler_pointer, std::string rip, unsigned short rport);
	// handles read
	void HandleRead(const boost::system::error_code& error, 
		size_t bytes_transferred);
	// handles write
	void HandleWrite(const boost::system::error_code& error,
		size_t bytes_transferred);
	// handles close
	void HandleClose(bool bforce=false);

	// ====================  DATA MEMBERS  =======================================
	TCPSessionID				id_;
	TCPIOThread&				thread_;
	boost::asio::ip::tcp::socket		socket_;
	FilterPointer				filter_;
	char					buffer_receiving_[kRecvBuffLength];
	int					num_handlers_;
	bool					closed_;
	HandlerPointer				handler_pointer;
	std::string				remote_ip_;
    unsigned short          remote_port_;
	TCPIOThreadID				threadid_;
	char*					buffer_recv_msg_;
	std::queue<char*>			queue_send_msg_;
	SessionType				session_type_;

	void SendMessage(char* message);
	void Close(bool bforce=false);
	void ClearRecvBuff();
	bool CheckMsgLength(size_t len);
}; // -----  end of class TCPSession  -----

//test memory
//extern volatile unsigned long g_recv_buff_count;
//extern volatile unsigned long g_send_buff_count;
//

#endif   // ----- #ifndef TCP_SESSION_H_  -----
