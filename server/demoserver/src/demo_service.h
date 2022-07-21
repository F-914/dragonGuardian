/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-15
*	Description	:	服务器定义头文件
--------------------------------------------------*/

#ifndef __DEMO_SERVICE_H__
#define __DEMO_SERVICE_H__

#include "lock.h"
#include "struct_def.h"
#include "client_msg_handler.h"

#include <map>
#include <boost/shared_ptr.hpp>
#include <boost/make_shared.hpp>

typedef boost::shared_ptr<ClientMsgHandler>  ClientMsgHandlerPointer;

struct NetMsg;
class BaseThread;
class DemoService {
public:
  DemoService();
  virtual ~DemoService();

  bool Init();
  void Run();
  void Destroy();

  BaseThread* GetThread(EnThreadType type);
  void RecvClientConnected(uint32 sid);
  void RecvClientClosed(uint32 sid);
  void RecvClientMsg(uint32 sid, char* msg);
  void PushMsg2Lobby(const std::string& msg);
  void PushMsg2Game(const std::string& msg);
  void RecvLobbyMsg(std::string& msg_str);
  void RecvGameMsg(std::string& msg_str);
  bool SendMsg2Client(uint32 sid, const std::string& msg);
  bool SendMsg2ClientByPid(uint32 pid, const std::string& msg);
  void SetPid2Sid(uint32 pid, uint32 sid);
  uint32 Pid2Sid(uint32 pid);
  bool RequestPlayerDBData(
      const std::string& login_name, 
      uint32& player_id, 
      std::string& data);
  bool SavePlayerDBData(uint32 pid, const std::string& data);

  //temp code for debug
  void InitRanklist();
  void AddPlayer(uint32 player_id, const std::string& nick);
  void RefreshRanklist(uint32 player_id, uint32 score);
  void PushRanklist(uint32 sid, uint32 player_id);
  uint32 GetRank(uint32 player_id);
  //

private:
  bool LoadConfig();
  bool LoadPlayerDBData();
  bool LoadAccountTable();
  bool LoadPlayerAccountInfo();
  void StartClientIOThreadManager();
  bool InitLogicThread();
  void InitSaveDiskTimer();
  void CheckSaveDisk(uint32 now);
  void SaveDisk();

private:
  uint16 client_listen_port_;
  uint32 client_io_thread_num_;
  boost::thread* client_io_thread_;
  ClientMsgHandlerPointer client_msg_handler_;
  TCPIOThreadManager* client_io_thread_manager_;
  std::map<EnThreadType, BaseThread*> logic_threads_;

  Lock pid_2_sid_lock_;
  std::set<uint32> all_sids_;
  std::map<uint32, uint32> pid_2_sid_;

  uint32 max_player_id_;
  Lock player_db_data_lock_;
  CTinyTimer save_disk_timer_;
  std::map<std::string, uint32> login_name_2_pid_;
  std::map<uint32, std::string> player_db_data_;

  bool debug_msg_;

  //temp code for debug
  std::map<uint32, std::string> player_info_;
  std::multimap<uint32, uint32> rank_list_;
  //
};

extern DemoService* gtk_demo_service;

#endif
