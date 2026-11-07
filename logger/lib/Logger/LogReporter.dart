import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:date_format/date_format.dart';
import '../common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;

class LogReporter {

  String localLogPath = "";
  String localLog = "";
  String localFileName = "LocalLog.json";
  int maxCount = 5;

  //初始化,检查有没有历史需要上报的内容
  Future init([String? path]) async {
    if(path != null){
      localLogPath = path;
    }else{
      localLogPath = GlobalBoard.getWorkingPath()!;
    }

    var savePath = PathUtil.join(localLogPath, localFileName);
    var file = File(savePath);
    if (file.existsSync()) {
      List logs = await openLocalLog(file);
      file.deleteSync(recursive: true);
      if (logs.length > 0) {
        for (int i = 0; i < logs.length; ++i) {
          await reportUrl(logs[i]["reportMsg"]);
        }
      }
    }
  }

  Future<List> openLocalLog(File file) async{
    List logs = [];
    if(file.existsSync()){
      var str = file.readAsStringSync();
      var jm  = json.decoder.convert(str);
      if (jm is List) {
        var minIndex = -1;
        if(jm.length > maxCount){
          minIndex = jm.length - maxCount;
        }
        for(int i = 0 ; i < jm.length ; ++i){
          if(minIndex == -1 || i > minIndex){
            var log = jm[i];
            logs.add(log);
          }
        }
      }
    }
    return logs;
  }


  Future reportData(String project,String type,String id,String version,String msg) async{
    Map data = {
      "type" : "event",
      "data": {
        "proj" : project,
        "act_type" : type,
        "username" : id,
        "version" : version,
        "log_time" : formatDate(DateTime.now(), [yyyy, "-", mm, "-", dd, " ",HH, ":",nn,":",ss]),
        "msg" : msg ,
      }
    };

    var je = json.encoder;
    var reportMsg = je.convert(data);
    print(reportMsg);
    await reportUrl(reportMsg);
  }

  Future reportUrl(reportMsg) async{

    var dio = new Dio();
    var value = await dio.post(
      'https://api.mobilelegends.com/r',
      data: {'v2': reportMsg},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    if(value.statusCode == 200){
      // JsonDecoder decoder = new JsonDecoder();
      // var m = decoder.convert(value.data);
      //print("上报成功");
    }else{
      //上报失败，记录在本地文件内
      saveLocalReport(reportMsg,value.statusCode,value.statusMessage);
    }
  }

  Future saveLocalReport(reportMsg,statusCode,statusMessage) async{
    var savePath = PathUtil.join(localLogPath, localFileName);
    var file = File(savePath);
    List logs = [];
    if (file.existsSync()) {
      logs = await openLocalLog(file);
    }
    // else{
    //   logs = [];
    // }
    Map log = {
      "reportMsg" : reportMsg,
      "statusCode" : statusCode,
      "statusMessage" : statusMessage,
    };

    logs.add(log);

    var je = json.encoder;
    var logsStr = je.convert(logs);

    file.writeAsStringSync(logsStr);
  }


  static LogReporter? _instance;
  static LogReporter get instance {
    _instance ??= LogReporter()..init();
    return _instance!;
  }

}