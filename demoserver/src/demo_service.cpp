/*--------------------------------------------------
*	Copyright	:	www.jj.cn 2021
*	Author		:	
*	Date		:	2021-05-15
*	Description	:	服务器定义实现文件
--------------------------------------------------*/

#include "ini.h"
#include "log.h"
#include "util.h"
#include <fstream>
#include "timesystem.h"
#include "msg_thread.h"
#include "lobby_thread.h"
#include "game_thread.h"
#include "demo_service.h"
#include "message_filter.h"

DemoService* gtk_demo_service = NULL;

DemoService::DemoService() {
  client_listen_port_ = 33333;
  client_io_thread_num_ = 1;
  client_io_thread_ = NULL;
  client_io_thread_manager_ = NULL;
  max_player_id_ = 10000;
  debug_msg_ = false;
}

DemoService::~DemoService() {
}

bool DemoService::Init() {
  bool ret = LoadConfig();
  if (!ret) {
    SLOG(STARTUP_ERROR, "load config info fail");
    return false;
  }

  ret = LoadPlayerDBData();
  if (!ret) {
    SLOG(STARTUP_ERROR, "load player db data fail");
    return false;
  }

  client_msg_handler_ = boost::make_shared<ClientMsgHandler>();
  if (client_msg_handler_.get() == NULL) {
    SLOG(STARTUP_ERROR, "new client msg handler fail");
    return false;
  }

  client_io_thread_ = new(std::nothrow) boost::thread(
      &DemoService::StartClientIOThreadManager, 
      this);
  if (client_io_thread_ == NULL) {
    SLOG(STARTUP_ERROR, "new client io thread manager fail");
    return false;
  }

  ret = InitLogicThread();
  if (!ret) {
    SLOG(STARTUP_ERROR, "new logic thread fail");
    return false;
  }

  InitSaveDiskTimer();

  //temp code for debug
  InitRanklist();
  //
  return true;
}

void DemoService::Run() {
  while (true) {
    uint32 now = GET_TIME().TickCount();
    CheckSaveDisk(now);
    boost::this_thread::sleep(boost::posix_time::milliseconds(100));
  }
}

void DemoService::Destroy() {
  KSafeDelete(client_io_thread_);
  KSafeDelete(client_io_thread_manager_);
}

bool DemoService::LoadConfig() {
  Ini ini;
  if (ini.Open("cag_demo.ini") != TRUE) {
    SLOG(STARTUP_ERROR, "open config file fail");
    return false;
  }
  client_listen_port_ = ini.GetInt("Net", "ListenPort", 33333);
  client_io_thread_num_ = ini.GetInt("Net", "IOThreadNum", 1);
  debug_msg_ = (ini.GetInt("Net", "Log", 0) == 1);
  return true;
}

void DemoService::StartClientIOThreadManager() {
  client_io_thread_manager_ = 
      new(std::nothrow) TCPIOThreadManager(client_io_thread_num_);
  if (client_io_thread_manager_ != NULL) {
    boost::asio::ip::tcp::endpoint end_point(
        boost::asio::ip::tcp::v4(), 
        client_listen_port_);
    TCPServer server(
        end_point, 
        *client_io_thread_manager_, 
        client_msg_handler_, 
        &NetMessageFilter::Create);
    client_io_thread_manager_->Run();
    QLOG(LOG_INFO, "start client io thread manager succ");
  } else {
    QLOG(LOG_ERROR, "new client io thread manager fail");
  }
}

bool DemoService::InitLogicThread() {
  BaseThread* thread_ptr = new(std::nothrow) MsgThread;
  if (thread_ptr == NULL) {
    SLOG(STARTUP_ERROR, "new msg thread fail");
    return false;
  }
  bool ret = thread_ptr->Init();
  if (!ret) {
    SLOG(STARTUP_ERROR, "init msg thread fail");
    return false;
  }
  logic_threads_.insert(std::make_pair(thread_type_msg, thread_ptr));

  thread_ptr = new(std::nothrow) LobbyThread;
  if (thread_ptr == NULL) {
    SLOG(STARTUP_ERROR, "new lobby thread fail");
    return false;
  }
  ret = thread_ptr->Init();
  if (!ret) {
    SLOG(STARTUP_ERROR, "init lobby thread fail");
    return false;
  }
  logic_threads_.insert(std::make_pair(thread_type_lobby, thread_ptr));

  thread_ptr = new(std::nothrow) GameThread;
  if (thread_ptr == NULL) {
    SLOG(STARTUP_ERROR, "new game thread fail");
    return false;
  }
  ret = thread_ptr->Init();
  if (!ret) {
    SLOG(STARTUP_ERROR, "init game thread fail");
    return false;
  }
  logic_threads_.insert(std::make_pair(thread_type_game, thread_ptr));

  return true;
}

void DemoService::InitSaveDiskTimer() {
  uint32 now = GET_TIME().TickCount();
  save_disk_timer_.BeginTimer(3*60*1000, now);
}

BaseThread* DemoService::GetThread(EnThreadType type) {
  BaseThread* thread_ptr = NULL;
  auto iter = logic_threads_.find(type);
  if (iter != logic_threads_.end())
    thread_ptr = iter->second;
  return thread_ptr;
}

void DemoService::RecvClientConnected(uint32 sid) {
  all_sids_.insert(sid);
}

void DemoService::RecvClientClosed(uint32 sid) {
  auto iter = all_sids_.find(sid);
  if (iter != all_sids_.end())
    all_sids_.erase(iter);
}

void DemoService::RecvClientMsg(uint32 sid, char* msg) {
  NetMsg* net_msg = new(std::nothrow) NetMsg(sid, msg);
  MsgThread* thread_ptr = (MsgThread*)GetThread(thread_type_msg);
  if (thread_ptr != NULL) {
    thread_ptr->PushMsg(net_msg);
  }
}

void DemoService::PushMsg2Lobby(const std::string& msg) {
  LobbyThread* thread_ptr = (LobbyThread*)GetThread(thread_type_lobby);
  if (thread_ptr != NULL)
    thread_ptr->PushMsg(msg);
}

void DemoService::PushMsg2Game(const std::string& msg) {
  GameThread* thread_ptr = (GameThread*)GetThread(thread_type_game);
  if (thread_ptr != NULL)
    thread_ptr->PushMsg(msg);
}

void DemoService::RecvLobbyMsg(std::string& msg_str) {
  LobbyThread* thread_ptr = (LobbyThread*)GetThread(thread_type_lobby);
  if (thread_ptr != NULL)
    thread_ptr->GetMsg(msg_str);
}

void DemoService::RecvGameMsg(std::string& msg_str) {
  GameThread* thread_ptr = (GameThread*)GetThread(thread_type_game);
  if (thread_ptr != NULL)
    thread_ptr->GetMsg(msg_str);
}

bool DemoService::SendMsg2Client(
    uint32 sid, 
    const std::string& msg) {
  int len = msg.length();
  int total = sizeof(TKCAGHEADER) + len;
  TKCAGHEADER* new_msg = (TKCAGHEADER*)malloc(total);
  if (new_msg == NULL) {
    return false;
  }
  memset(new_msg, 0, sizeof(TKCAGHEADER));
  new_msg->msg_length_ = len;
  memcpy(new_msg + 1, msg.c_str(), len);
  client_io_thread_manager_->SendMsg2Session(sid, (char*)new_msg);
  if (debug_msg_) {
    QLOG(LOG_TEST, "%u %s", sid, msg.c_str());
  }
  return true;
}

bool DemoService::SendMsg2ClientByPid(
    uint32 pid, 
    const std::string& msg) {
  uint32 sid = Pid2Sid(pid);
  int len = msg.length();
  int total = sizeof(TKCAGHEADER) + len;
  TKCAGHEADER* new_msg = (TKCAGHEADER*)malloc(total);
  if (new_msg == NULL) {
    return false;
  }
  memset(new_msg, 0, sizeof(TKCAGHEADER));
  new_msg->msg_length_ = len;
  memcpy(new_msg + 1, msg.c_str(), len);
  client_io_thread_manager_->SendMsg2Session(sid, (char*)new_msg);
  if (debug_msg_) {
    QLOG(LOG_TEST, "%u %s", pid, msg.c_str());
  }
  return true;
}

void DemoService::SetPid2Sid(uint32 pid, uint32 sid) {
  WLock w_lock(pid_2_sid_lock_);
  pid_2_sid_[pid] = sid;
}

uint32 DemoService::Pid2Sid(uint32 pid) {
  RLock r_lock(pid_2_sid_lock_);
  auto iter = pid_2_sid_.find(pid);
  if (iter != pid_2_sid_.end())
    return iter->second;
  return 0;
}

bool DemoService::LoadPlayerDBData() {
  bool ret = LoadAccountTable();
  if (!ret) {
    SLOG(STARTUP_ERROR, "load account table fail");
    return false;
  }
  
  ret = LoadPlayerAccountInfo();
  if (!ret) {
    SLOG(STARTUP_ERROR, "load player account info fail");
    return false;
  }
  return true;
}

bool DemoService::LoadAccountTable() {
  uint32 pid = 0;
  std::string line;
  std::vector<std::string> vec_str;
  std::ifstream account_file;
  account_file.open("./db/account.dat", ios::out | ios::in);
  while (getline(account_file, line)) {
    vec_str.clear();
    StrSplit(line, ' ', vec_str);
    if (vec_str.size() != 2) {
      SLOG(STARTUP_ERROR, "account format error %s", line.c_str());
      return false;
    }
    pid = atoi(vec_str[1].c_str());
    login_name_2_pid_[vec_str[0]] = pid;
    if (pid > max_player_id_)
      max_player_id_ = pid;
  }
  account_file.close();
  return true;
}

bool DemoService::LoadPlayerAccountInfo() {
  uint32 pid = 0;
  std::string line;
  char data_file[128];
  auto iter = login_name_2_pid_.begin();
  for (; iter!=login_name_2_pid_.end(); ++iter) {
    pid = iter->second;
    memset(data_file, 0, sizeof(data_file));
    tsnprintf(data_file, sizeof(data_file)-1, "./db/%u.dat", pid);
    std::ifstream db_file;
    db_file.open(data_file, ios::out | ios::in);
    getline(db_file, line);
    player_db_data_[pid] = line;
  }
  return true;
}

bool DemoService::RequestPlayerDBData(
    const std::string& login_name, 
    uint32& player_id, 
    std::string& data) {
  RLock r_lock(player_db_data_lock_);
  auto iter = login_name_2_pid_.find(login_name);
  if (iter != login_name_2_pid_.end()) {
    player_id = iter->second;
    auto iter_d = player_db_data_.find(player_id);
    if (iter_d != player_db_data_.end()) {
      data = iter_d->second;
      return true;
    } else {
      data = "";
      return true;
    }
  } else {
    player_id = ++max_player_id_;
    login_name_2_pid_[login_name] = player_id;
    data = "";
    return true;
  }
  return true;
}

bool DemoService::SavePlayerDBData(
    uint32 pid, 
    const std::string& data) {
  WLock w_lock(player_db_data_lock_);
  player_db_data_[pid] = data;
  return true;
}

void DemoService::CheckSaveDisk(uint32 now) {
  if (save_disk_timer_.CountingTimer(now)) {
    SaveDisk();
  }
}

void DemoService::SaveDisk() {
  std::map<std::string, uint32> temp_login_name_2_pid;
  std::map<uint32, std::string> temp_player_db_data;
  {
    RLock r_lock(player_db_data_lock_);
    temp_login_name_2_pid = login_name_2_pid_;
    temp_player_db_data = player_db_data_;
  }
  ofstream account_file;
  account_file.open("./db/account.dat", ios::out | ios::trunc);
  char account_str[512];
  auto iter = temp_login_name_2_pid.begin();
  for (; iter!=temp_login_name_2_pid.end(); ++iter) {
    memset(account_str, 0, sizeof(account_str));
    tsnprintf(
        account_str, 
        sizeof(account_str) - 1, 
        "%s %u", 
        iter->first.c_str(), 
        iter->second);
    account_file << account_str << endl;
  }
  account_file.close();
  
  char pid_str[64];
  auto iter_d = temp_player_db_data.begin();
  for (; iter_d!=temp_player_db_data.end(); ++iter_d) {
    memset(pid_str, 0, sizeof(pid_str));
    tsnprintf(pid_str, sizeof(pid_str)-1, "./db/%u.dat", iter_d->first);
    ofstream data_file;
    data_file.open(pid_str, ios::out | ios::trunc);
    data_file << iter_d->second << endl;
    data_file.close();
  }
}

//temp code for debug
void DemoService::InitRanklist() {
  uint32 player_id = 0;
  uint32 score = 0;
  char nick[64];
  for (int i=0; i<10; i++) {
    player_id = 10000000 + i;
    memset(nick, 0, sizeof(nick));
    tsnprintf(nick, sizeof(nick)-1, "guest%u", player_id);
    AddPlayer(player_id, nick);
    RefreshRanklist(player_id, ++i);
  }
}

void DemoService::AddPlayer(
    uint32 player_id, 
    const std::string& nick) {
  player_info_[player_id] = nick;
}

void DemoService::RefreshRanklist(
    uint32 player_id, 
    uint32 score) {
  rank_list_.insert(std::make_pair(score, player_id));
}

#include "json_writer.h"
void DemoService::PushRanklist(uint32 sid, uint32 player_id) {
  Json::Value res;
  Json::FastWriter writer;
  res["type"] = tk_ack + 3;
  res["playerid"] = player_id;
  res["rank"] = GetRank(player_id);

  uint32 rank = 0;
  Json::Value list;
  Json::Value item;
  auto iter = rank_list_.rbegin();
  for (; iter!=rank_list_.rend(); ++iter) {
    if (++rank > 10)
      break;
    item["rank"] = rank;
    item["player_id"] = iter->second;
    item["nick"] = player_info_[iter->second];
    item["score"] = iter->first;
    list.append(item);
  }
  res["ranklist"] = list;
  gtk_demo_service->SendMsg2Client(sid, writer.write(res).c_str());
}

uint32 DemoService::GetRank(uint32 player_id) {
  uint32 rank = 0;
  auto iter = rank_list_.rbegin();
  for (; iter!=rank_list_.rend(); ++iter) {
    if (player_id == iter->second)
      break;
    else
      rank++;
  }
  return rank;
}
//
