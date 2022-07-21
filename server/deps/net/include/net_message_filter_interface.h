#ifndef  NET_MESSAGE_FILTER_INTERFACE_H_
#define  NET_MESSAGE_FILTER_INTERFACE_H_

#include "net.h"
#include <vector>

// =====================================================================================
//        Class:  NetMessageFilterInterface
//  Description:  filters net messages, encodes/decodes header,
//  compreses/decompresess, encrypts/decrypts, etc.
// =====================================================================================
class Net_API NetMessageFilterInterface {
public:
	typedef std::vector<char> Buffer;
	// ====================  LIFECYCLE     =======================================
	virtual ~NetMessageFilterInterface() {}

	// ====================  OPERATIONS    =======================================
	// queries bytes wanna write as the size of pre-allocated memory, 
	// for the purpose of efficiency.
	virtual size_t BytesWannaWrite(char* message) = 0;
	// queries bytes wanna read, return size_t(-1) means read some.
	virtual size_t BytesWannaRead() = 0; 
	// check read head
	virtual bool ReadHead(char* buffer) = 0;
}; // -----  end of class NetMessageFilterInterface  -----


#endif   // ----- #ifndef NET_MESSAGE_FILTER_INTERFACE_H_  -----
