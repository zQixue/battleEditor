//@dart=2.11
import 'dart:io';

import 'package:iso/iso.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart' as PathUtil;


void exportProject2(IsoRunner iso) async {

  var prms = DartCommon.getIsolateParams(iso);
  // StateScriptProject.setInstance(prms["project"]);
  // SSMainSetting.setInstance(prms["setting"]);

  SSFieldType.initSystemType();
  SSMainSetting.load();
  StateScriptProject.load();
  StateScriptProject.isExportThread = true;
  StateScriptProject.instance.registerEnumTypes();
  StateScriptProject.instance.registerBehavicAgentTypes();

  if (StateScriptProject.instance.useObjectTable) {
    ObjectTableSetting.load();

    if (ObjectTableProject.isValid()) {
      if (ObjectTableSetting.instance.workingPath != "") {
        ObjectTableProject.loadSync();
        ObjectTableProject.instance.registerEnumTypes();
        // initExtraType();
        OTGlobalBoard.clear();
      }
    }
  }

  CodeBlockyType.registerBlockyTypes();

  if (StateScriptProject.instance.useObjectTable) {
    if (ObjectTableProject.isValid()) {
      ObjectTableProject.instance.export();
    }
  }
  StateScriptProject.exportIso = iso;
  try{

    StateScriptProject.instance.debugExport = prms["mode"];
    StateScriptProject.instance.registerEnumTypes();
    StateScriptProject.instance.registerBehavicAgentTypes();
    StateScriptProject.instance.fullLogs.clear();



    var cfgs = StateScriptProject.instance.getAllConfigs();
    for(int i=0;i<cfgs.length ;++i){
      StateScriptProject.instance.switchExportConfig(cfgs[i]);
      await StateScriptProject.instance.export();
    }


    var logs = StateScriptProject.instance.fullLogs;

    // print("logs == $logs" );
    if (logs.length>0){

      var fullStr = logs.join("\n");
      var root = SSMainSetting.instance.workingPath;
      var path = GlobalBoard.getCorrectDirectory(root);

      var savePath = PathUtil.join(path , "log.txt");
      File(savePath).writeAsStringSync(fullStr);

      iso?.send({"error":"导出过程中出现错误，请参看Log文件 $savePath" , "savePath":savePath ,"errstr":fullStr});
      if(iso == null) DartCommon.launchURL(savePath);
      iso?.receive();
      return ;
    }
  }
  catch(e,s){
    iso?.send({"error":"导出出错:${e.toString()}\n${s.toString()}","errstr":""});
    print(e);
    print(s);
    iso?.receive();
    return;
  }
  iso?.send({"export_done":true , "project":StateScriptProject.instance});
  iso?.receive();
}

