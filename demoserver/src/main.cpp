#include "log.h"
#include "timesystem.h"
#include "demo_service.h"

int main() {
  //初始化时间管理系统
  INIT_TIMESYSTEM();
  bool ret = LogSys::instance().Init();
  if (!ret) {
    SLOG(STARTUP_ERROR, "init log system fail");
    return -1;
  }
  QLOG(LOG_INFO, "demo service start...");
  gtk_demo_service = new(std::nothrow) DemoService();
  if (gtk_demo_service != NULL) {
    if(gtk_demo_service->Init()) {
      QLOG(LOG_INFO, "demo service init succ");
      gtk_demo_service->Run();
    } else {
      SLOG(STARTUP_ERROR, "demo service init fail");
    }
    gtk_demo_service->Destroy();
    SLOG(STARTUP_ERROR, "demo service destory");
  } else {
    SLOG(STARTUP_ERROR, "demo service malloc fail");
  }
  
  return 0;
}
