/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-15
*	Description	:	网络消息辅助拆包类定义
--------------------------------------------------*/

#ifndef  __MESSAGE_FILTER_H__
#define  __MESSAGE_FILTER_H__

#include "net_headers.h"
#include "protocol_def.h"

#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>

using namespace std;
using namespace boost;

class NetMessageFilter : public NetMessageFilterInterface {
public:
  typedef TKCAGHEADER Header;
  static const size_t kHeaderSize = sizeof(Header);

  NetMessageFilter() {
    header_read_ = false;
  }

  static boost::shared_ptr<NetMessageFilter> Create() {
    return boost::make_shared<NetMessageFilter>();
  }

  virtual size_t BytesWannaRead() {
    if (!header_read_)
      return kHeaderSize;
		
    if (header_.msg_length_ == 0) {
      header_read_ = false;
    }

    return header_.msg_length_;
  }

  virtual size_t BytesWannaWrite(char* message) { 
    Header* pHeader = (Header*)message;
    return sizeof(Header) + pHeader->msg_length_;
  }

  virtual bool ReadHead(char* buffer) { 
    if (!header_read_) {
      header_ = *(reinterpret_cast<const Header*>(&buffer[0]));
      header_read_ = true;
    } else {
      header_read_ = false;
    }

    return header_read_;
  }

private:
  bool header_read_;
  Header header_;
};

#endif
