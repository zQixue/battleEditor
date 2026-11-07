//@dart=2.11


enum LogType{
  info,
  warning,
  error
}

class ALog{
  LogType type = LogType.info;
  String message = "";
}
class Logger{
  List<ALog> logs = List<ALog>();
  int iLogCount =0;
  int iWarningCount =0;
  int iErrorCount =0;
  void reset(){
    logs.clear();
    iLogCount = 0;
    iWarningCount = 0;
    iErrorCount = 0;
  }

  void appendLog(LogType tp , String message , {bool consolePrint = true , bool printTrace = true}){
    if (consolePrint){
      var pMsg = (tp == LogType.error?"!!!ERROR!!!  ":(tp == LogType.warning?"!!!WARNING!!!  ":"  ")) + message;
      print(pMsg);
      if (printTrace){
        print(StackTrace.current.toString());
      }
    }
    var log = ALog()..type = tp..message = message;
    logs.add(log);

    if (tp == LogType.error) ++iErrorCount;
    else if (tp == LogType.warning) ++iWarningCount;
    else if (tp == LogType.info) ++iLogCount;
  }
}