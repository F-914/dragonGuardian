#ifndef _MQ_SINGLETON_H_
#define _MQ_SINGLETON_H_

#include "thread.h"
#include <boost/scoped_ptr.hpp>
#include <boost/atomic.hpp> 


#ifdef _MSC_VER_ // for MSVC
#define forceinline __forceinline
#elif defined __GNUC__ // for gcc on Linux/Apple OS X
#define forceinline __inline__ __attribute__((always_inline))
#else
#define forceinline
#endif

class NonCopyable
{
protected:
	NonCopyable() {}
	~NonCopyable() {}

private:
	// emphasize the following members are private
	NonCopyable(const NonCopyable&);
	const NonCopyable& operator=(const NonCopyable&);
};



/**
	*	通过原子计数实现的快速互斥锁
	*/
class AtomicMutex : private NonCopyable
{
public:
	AtomicMutex() : state_(Unlocked) {}
	~AtomicMutex() {}

	void Lock(){
    while (state_.exchange(Locked, boost::memory_order_acquire) == Locked) {
    }
	}

	void Unlock(){
    state_.store(Unlocked, boost::memory_order_release);
	}

private:
  typedef enum { Locked, Unlocked } LockState;
  boost::atomic<LockState> state_;
};

/**
	*	singleton thread safe
	*/
template<typename T>
class MQSingleton
{
public:
	static T& instance()
	{
		if (!m_instance_ptr)
		{
			// double-checked Locking pattern
			_lock_guard<AtomicMutex> guard(m_mutex);

			if (!m_instance_ptr){
				m_instance_ptr.reset(new T);
			}
		}

		return *m_instance_ptr;
	}

protected:
	MQSingleton(void) {}
	~MQSingleton(void) {}

private:
  // noncopyable
  MQSingleton(const MQSingleton&);
  const MQSingleton& operator=(const MQSingleton&);

private:
  static AtomicMutex				    m_mutex;
  static boost::scoped_ptr<T>		m_instance_ptr;
};

template<typename T> AtomicMutex MQSingleton<T>::m_mutex;
template<typename T> boost::scoped_ptr<T> MQSingleton<T>::m_instance_ptr(NULL);


#endif //_MQ_SINGLETON_H_
