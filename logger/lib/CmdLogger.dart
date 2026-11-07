//@dart=2.11

import 'package:args/args.dart';
import 'common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;
import 'dart:io';
import 'Logger/LogReporter.dart';

Directory _oldCrtPath ;
void main(List<String> arguments) async{

  var exePath = PathUtil.dirname(Platform.resolvedExecutable);
  GlobalBoard.docDir = Directory(exePath);
  _oldCrtPath = Directory.current;
  ("exe path : $exePath");
  Directory.current = Directory(exePath);
  print(Directory.current.path);
  print("battlepus command line logger tool ");
  print("version : 0.1.0");
  print("\n");

  var parser = ArgParser();
  parser.addOption('project',abbr:"p",
    help: '上报项目',
  );
  parser.addOption('type',abbr:"t",
    help: '上报类型',
  );
  parser.addOption('id',abbr:"i",
    help: '设备ID',
  );
  parser.addOption('version',abbr:"v",
    help: '版本号',
  );
  parser.addOption('msg',abbr:"m",
    help: '上报信息',
  );

  print(arguments);
  if (arguments != null && arguments.length > 0){
    ArgResults res ;
    try{
      res = parser.parse(arguments);
    }
    on Exception{
      printUsage(parser);
      returnApp();
    }

    await process(res);
  }
  else{
    printUsage(parser);
  }

  returnApp(code: 0);

}

void returnApp({int code = -1}){
  if (_oldCrtPath != null && _oldCrtPath.existsSync()){
    Directory.current = _oldCrtPath;
  }
  exit(code);
}

Future process(ArgResults res) async{
  var project  = res['project'];
  var type  = res['type'];
  var id = res['id'];
  var msg = res['msg'];
  var version = res['version'];
  LogReporter l = new LogReporter();
  await l.reportData(project,type,id,version,msg);
}

void printUsage(ArgParser parser){

}