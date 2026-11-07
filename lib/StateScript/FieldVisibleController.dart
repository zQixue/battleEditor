import 'dart:io';

import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:lua_dardo/lua.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/lua/LuaVm.dart';
import 'package:lua_dardo/src/state/lua_state_impl.dart';
import 'package:path/path.dart' as PathUtil;


import '../common/lua/LuaVm.dart';
class FullFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
class FieldVisibleController {

  LuaVm _vm = LuaVm.newVm();


  var logger = Logger(
    filter: FullFilter(),
    output: OutPutListener(64),
    printer: PrettyPrinter(),
  );

  FieldVisibleController(){
    _initVM();
    // LogConsole.init(bufferSize: 256);
  }

  void _initVM(){
    // var basePath2 = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    // var cons = StateScriptProject.instance!.getAllConfigs();
    // if (cons.length>0){
    //   var tempPath2 = GlobalBoard.getCorrectDirectory(cons[0].templatePath, basePath: basePath2);
    //   ExportMappingConfig.load(tempPath2);
    // }


    LuaStateImpl.fileLoadErrorCallback = (e){
      print("${e.toString()}\n${_vm.getError()}");
      logger.e("${e.toString()}\n${_vm.getError()}");
      // showDialog<void>(
      //   context: CommonUtil.getGlobalContex(),
      //   barrierDismissible: true, // false = user must tap button, true = tap outside dialog
      //   builder: (BuildContext dialogContext) {
      //     return LogConsole(logger :logger ,  dark: true,showCloseButton: true);
      //   },
      // );
    };

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath!);
    var tempPath = PathUtil.join(basePath , "plugins").replaceAll("\\", "/");
    _vm.run("package.path = '$tempPath/?.lua;;'");

    var errLog=(LuaState ls){
      var args = LuaVm.getArgs(ls, 1);
      var msg = args[0];
      // print("Lua : !!! ERROR !!! :     ${msg}");
      // TableImporter.logger.appendLog(LogType.error,"Lua : ${msg}\n------------------- lua ------------------\n${vm.getError()}");
      logger.e("Lua : ${msg}\n------------------- lua ------------------\n${_vm.getError()}");
      return 0 ;//TableManager.getTable(filaPath);
    };
    var warningLog = (LuaState ls){
      var args = LuaVm.getArgs(ls, 1);
      var msg = args[0];
      logger.w("Lua : ${msg}");
      // print("Lua : !!! WARNING !!! :     ${msg}");
      // TableImporter.logger.appendLog(LogType.warning,"Lua : ${msg}" , printTrace: false);
      return 0 ;//TableManager.getTable(filaPath);
    };
    var log = (LuaState ls){
      var args = LuaVm.getArgs(ls, 1);
      var msg = args[0];
      logger.i("Lua : ${msg}");
      // print("Lua : ${msg}");
      // TableImporter.logger.appendLog(LogType.info,"Lua : ${msg}", printTrace: false);
      return 0 ;//TableManager.getTable(filaPath);
    };

    _vm.registerDartFunction("ErrLog", errLog);
    _vm.registerDartFunction("Log", log);
    _vm.registerDartFunction("WarningLog", warningLog);
    // _vm.registerDartFunction("setField", setField);
    // _vm.registerDartFunction("clearField", clearField);
    // _vm.registerDartFunction("appendToListField", appendToListField);
    // _vm.registerDartFunction("appendToMapField", appendToMapField);
    // _vm.registerDartFunction("loadJson", loadJson);
    // _vm.registerDartFunction("loadJsonFromDir", loadJsonFromDir);
    // _vm.registerDartFunction("appendDynamicName", appendDynamicName);

  }

  void setObjectData(Map m){
    // if (m == null) return ;
    // if (!global) _state.pushString(name);
    m.forEach((key, val) {
      _vm.setGlobal(key, val);
    });
  }

  Map getFieldVisibleMap(StateScriptNode node){
    logger.levelCount.clear();
    var m = node.exportMap();
    setObjectData(m);
    var code = fieldVisibleCodeForStruct[node.getNodeStructType()?.guid??""];
    bool luaRunOk = true;
    if (code != null){
      print(code);
      try {
        // var code = File(filePath).readAsStringSync() + "\n";
        _vm.run(code , filePath: "${node.getNodeStructType()?.name??""}");

      }
      catch (e) {
        // BotToast.showText(text: e.toString(),contentColor: Colors.red);
        // TableImporter.logger.appendLog(LogType.error,"${e.toString()} , ${vm.getError()}");
        logger.e("${e.toString()}");
        luaRunOk = false;
        // LogConsole(dark: true,).
        print(e);
      }

      if ((logger.levelCount[Level.error]??0) > 0 ||(logger.levelCount[Level.warning]??0) > 0 ) {
        // var con = CommonUtil.getGlobalContex();
        if (!StateScriptProject.isExportThread) {
          Future.delayed(const Duration(milliseconds: 1)).then((value){
            showDialog<void>(
              context: CommonUtil.getGlobalContex(),
              barrierDismissible: true, // false = user must tap button, true = tap outside dialog
              builder: (BuildContext dialogContext) {
                return LogConsole(logger: logger, dark: true, showCloseButton: true);
              },
            );
          });
        }
        else{
          (logger.output as OutPutListener).outputEventBuffer.forEach((element) {
            // _renderedBuffer.add(_renderEvent(element));
            StateScriptProject.instance!.fullLogs.add(element.lines.join("\n"));
          });
        }
      }
    }

    if (luaRunOk){
      var res = _vm.getGlobalTable("_res");
      return res;
    }
    return {};
  }

  Map<String , String> fieldVisibleCodeForStruct = {};

  void loadAll(String path){
    fieldVisibleCodeForStruct.clear();
    var rpath = join(path , "plugins","fieldVisible");
    var dir = Directory(rpath);
    if (!dir.existsSync()) return ;
    var files = dir.listSync(recursive: true);
    files.forEach((element) {
      if (element is File && element.path.endsWith(".lua")){
        var guid = basenameWithoutExtension(element.path);
        if(guid.contains("]_")){
            var splits = guid.split("]_"); 
             fieldVisibleCodeForStruct[splits[splits.length -1]] = element.readAsStringSync();
        }
        else
          fieldVisibleCodeForStruct[guid] = element.readAsStringSync();
      } 
    });
  }

  String getOrCreateCodePath(String guid , {String name = "" , String description = ""}) {
    var root = SSMainSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);
    //全局名称
    var fileFullName = name + "_[" + description + "]_" + guid;
    var fileFullPath =  join(path , "plugins","fieldVisible" , "$fileFullName.lua");
    var oldPath = join(path , "plugins","fieldVisible" , "$guid.lua");
    String realPath = fileFullPath;

    if(!File(fileFullPath).existsSync() && !File(oldPath).existsSync())
    {
      File(fileFullPath).createSync(recursive: true);
      File(fileFullPath).writeAsStringSync('-- filed visible code for node type : ${name??guid}'
          '\n_res = {} -- set field visible : _res["field_name"] = true/false'
          '\n_res["FiledShowName"] = {} --set field name: _res["FiledShowName"]["field_name"] = "XXX"');
      realPath = fileFullPath;
    }
    else if(File(oldPath).existsSync())   //这里是为了兼容旧版的未加备注的功能
    {
      realPath = oldPath;
    }
    
    // if (!File(rpath).existsSync()){
    //   File(rpath).createSync(recursive: true);
    //   File(rpath).writeAsStringSync('-- filed visible code for node type : ${name??guid}'
    //       '\n_res = {} -- set field visible : _res["field_name"] = true/false');
    // }
    return realPath ;
  }

  bool isCodeForNodeTypeExists(String guid,{String name = "" , String description = ""}) {
    var root = SSMainSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

     var fileFullName = name + "_[" + description + "]_" + guid;
    var fileFullPath =  join(path , "plugins","fieldVisible" , "$fileFullName.lua");
    var oldPath = join(path , "plugins","fieldVisible" , "$guid.lua");

    bool newExist = File(fileFullPath).existsSync();
    bool oldExist = File(oldPath).existsSync();
    
    if(!newExist) return oldExist;

    return newExist;
  }

  void removeCodeForNodeType(String guid,{String name = "" , String description = ""}) {
    var root = SSMainSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    var fileFullName = name + "_[" + description + "]_" + guid;
    var fileFullPath =  join(path , "plugins","fieldVisible" , "$fileFullName.lua");

    var oldPath = join(path , "plugins","fieldVisible" , "$guid.lua");

    fieldVisibleCodeForStruct.remove(guid);

    if (File(fileFullPath).existsSync()){
      File(fileFullPath).deleteSync(recursive: true);
    }

    if (File(oldPath).existsSync()){
      File(oldPath).deleteSync(recursive: true);
    }

  }

  void loadCodeForNodeType(String guid,{String name = "" , String description = ""}){
    var root = SSMainSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    var fileFullName = name + "_[" + description + "]_" + guid;
    var fileFullPath =  join(path , "plugins","fieldVisible" , "$fileFullName.lua");

    var oldPath = join(path , "plugins","fieldVisible" , "$guid.lua");

    var readPath = "";

    if(!File(oldPath).existsSync() && !File(fileFullPath).existsSync()) return;

    if (File(fileFullPath).existsSync()){
      readPath = fileFullPath;
    }
    else if(File(oldPath).existsSync()){
      readPath = oldPath;
    }
      
    if(!readPath.isEmpty)
      fieldVisibleCodeForStruct[guid] = File(readPath).readAsStringSync();
  }


  static FieldVisibleController? _instance;
  static FieldVisibleController get instance {
    _instance ??= FieldVisibleController().._initVM();
    return _instance!;
  }

}