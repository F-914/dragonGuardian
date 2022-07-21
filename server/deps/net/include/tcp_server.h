#ifndef  TCP_SERVER_H_
#define  TCP_SERVER_H_

#include "net.h"
#include <boost/asio/ip/tcp.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/function.hpp>

class TCPSession;
class TCPSessionHandler;
class TCPIOThreadManager;
class NetMessageFilterInterface;

// =====================================================================================
//        Class:  TCPServer
//  Description:  TCPServer framework
// =====================================================================================
class Net_API TCPServer {
public:
	// ====================  TYPEDEFS      =======================================
	typedef boost::shared_ptr<TCPSession>                     SessionPointer;
	typedef boost::shared_ptr<TCPSessionHandler>              SessionHandlerPointer;
	typedef boost::shared_ptr<NetMessageFilterInterface>      SessionFilterPointer;
	typedef boost::function<SessionFilterPointer ()>          SessionFilterCreator;

	// ====================  LIFECYCLE     =======================================
	TCPServer(const boost::asio::ip::tcp::endpoint& endpoint,
		TCPIOThreadManager& io_thread_manager,
		const SessionHandlerPointer session_handler_pointer,
		const SessionFilterCreator& session_filter_creator);

	// ====================  ACCESSORS     =======================================
	boost::asio::io_service& io_service();

	// ====================  MUTATORS      =======================================

	// ====================  OPERATIONS    =======================================

private:
	void HandleAccept(SessionPointer session, const boost::system::error_code& error);
	// ====================  DATA MEMBERS  =======================================
	boost::asio::ip::tcp::acceptor  acceptor_;
	TCPIOThreadManager&             io_thread_manager_;
	SessionHandlerPointer			session_handler_;
	SessionFilterCreator            session_filter_creator_;
}; // -----  end of class TCPServer  -----


#endif   // ----- #ifndef TCP_SERVER_H_  -----
