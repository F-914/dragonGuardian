#ifndef  TIMER_H_
#define  TIMER_H_

#include    <boost/asio/deadline_timer.hpp>
#include    <boost/function.hpp>
#include    <boost/bind.hpp>

// =====================================================================================
//        Class:  Timer
//  Description:  Wrapper of asio::deadline_timer, ignores error_code and calls
//                handler repeatitively.
// =====================================================================================
class Net_API Timer : private boost::asio::deadline_timer {
public:
	// ====================  TYPEDEFS      =======================================
	typedef boost::asio::deadline_timer Base;
	typedef boost::function<void ()>    Handler;
	using Base::time_type;
	using Base::duration_type;

	// ====================  LIFECYCLE     =======================================
	Timer(boost::asio::io_service& service) : Base(service) {}

	// ====================  ACCESSORS     =======================================

	// ====================  MUTATORS      =======================================

	// ====================  OPERATIONS    =======================================
	void Cancel() { cancel(); }

	void Wait(const Handler& handler, const duration_type& duration) {
		cancel();
		handler_ = handler;
		expires_from_now(duration);
		expiry_time_ = expires_from_now();
		async_wait(boost::bind(&Timer::OnTimeout, this, _1));
	}

	void Wait(const Handler& handler, unsigned int millisec) {
		Wait(handler, boost::posix_time::millisec(millisec));
	}

	void Reset(const duration_type& duration) {
		Wait(handler_, duration);
	}

	void Reset(unsigned int millisec) {
		Wait(handler_, millisec);
	}

private:
	void OnTimeout(const boost::system::error_code& e) {
		if (!e) {
			expires_at(expires_at() + expiry_time_);
			async_wait(boost::bind(&Timer::OnTimeout, this, _1));
			handler_();
		}
	}

	Handler handler_;
	duration_type expiry_time_;
}; // -----  end of class Timer  -----

// =====================================================================================
//        Class:  DeadlineTimer
//  Description:  Wrapper of asio::deadline_timer, ignores error_code
// =====================================================================================
class DeadlineTimer : private boost::asio::deadline_timer {
public:
	// ====================  TYPEDEFS      =======================================
	typedef boost::asio::deadline_timer Base;
	typedef boost::function<void ()>    Handler;

	// ====================  LIFECYCLE     =======================================
	DeadlineTimer(boost::asio::io_service& service) : Base(service) {}

	// ====================  ACCESSORS     =======================================

	// ====================  MUTATORS      =======================================

	// ====================  OPERATIONS    =======================================
	void Cancel() { cancel(); }

	void Wait(const Handler& handler, const duration_type& duration) {
		cancel();
		handler_ = handler;
		expires_from_now(duration);
		async_wait(boost::bind(&DeadlineTimer::OnTimeout, this, _1));
	}

	void Wait(const Handler& handler, const time_type& time) {
		cancel();
		handler_ = handler;
		expires_at(time);
		async_wait(boost::bind(&DeadlineTimer::OnTimeout, this, _1));
	}

	void Wait(const Handler& handler, unsigned int millisec) {
		Wait(handler, boost::posix_time::millisec(millisec));
	}

	void Reset(const duration_type& duration) {
		Wait(handler_, duration);
	}

	void Reset(unsigned int millisec) {
		Wait(handler_, millisec);
	}

	void Reset(const time_type& time) {
		Wait(handler_, time);
	}

private:
	void OnTimeout(const boost::system::error_code& e) {
		if (!e) {
			handler_();
		}
	}
	Handler handler_;
}; // -----  end of class DeadlineTimer  -----


#endif   // ----- #ifndef TIMER_H_  -----
