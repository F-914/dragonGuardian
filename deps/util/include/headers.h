#ifndef __HEADERS_H__
#define __HEADERS_H__

#include "typedef.h"
#include <set>
#include <list>
#include <queue>
#include <memory>
#include <string>
#include <iostream>
#include <numeric>
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/iostreams/stream.hpp>
#include <boost/foreach.hpp>
#include <boost/cstdint.hpp>
#include <boost/crc.hpp>
#include <boost/interprocess/detail/atomic.hpp>

#ifdef WIN32
#include <Windows.h>
#endif
#ifdef __LINUX__
#include <sys/utsname.h>
#include <sys/time.h>
#include <pthread.h>
#endif


#define MAX_FILE_PATH (260)

using namespace std;
using namespace boost;
using namespace boost::iostreams;

#endif
