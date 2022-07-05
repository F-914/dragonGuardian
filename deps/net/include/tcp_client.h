#ifndef  TCP_CLIENT_H_
#define  TCP_CLIENT_H_

#include "net.h"
#include <boost/shared_ptr.hpp>
#include <boost/function.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/enable_shared_from_this.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>

class TCPSession;
class TCPSessionHandler;
class TCPIOThreadManager;
class NetMessageFilterInterface;

// =====================================================================================
//        Class:  TCPClient
//  Description:  TCPClient
// =====================================================================================
class Net_API TCPClient : public boost::enable_shared_from_this<TCPClient>, 
	public boost::noncopyable{
public:
	// ====================  TYPEDEFS      =======================================
	typedef boost::shared_ptr<TCPSession>                     SessionPointer;
	typedef boost::shared_ptr<TCPSessionHandler>              SessionHandlerPointer;
	typedef boost::shared_ptr<NetMessageFilterInterface>      SessionFilterPointer;
	typedef boost::function<SessionFilterPointer ()>          SessionFilterCreator;

	// ====================  LIFECYCLE     =======================================
	TCPClient(TCPIOThreadManager& io_thread_manager,
		const SessionHandlerPointer session_handler_pointer,
		const SessionFilterCreator& session_filter_creator);

	// ====================  ACCESSORS     =======================================
	boost::asio::io_service& io_service();

	// ====================  MUTATORS      =======================================

	// ====================  OPERATIONS    =======================================
	void ConnectServer(const boost::asio::ip::tcp::resolver::query& query);

private:
	void HandleConnect(SessionPointer session, 
		SessionHandlerPointer handler,
		std::string rip,
        unsigned short rport,
		const boost::system::error_code& error);
	// ====================  DATA MEMBERS  =======================================
	boost::asio::ip::tcp::resolver  resolver_;
	TCPIOThreadManager&             io_thread_manager_;
	SessionHandlerPointer			session_handler;
	SessionFilterCreator            session_filter_creator_;
}; // -----  end of class TCPClient  -----

typedef boost::shared_ptr<TCPClient>						  TCPClientPointer;

#endif   // ----- #ifndef TCP_CLIENT_H_  -----
