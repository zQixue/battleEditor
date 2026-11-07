

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:lua_dardo/lua.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/lua/LuaVm.dart';
import 'package:lua_dardo/src/state/lua_state_impl.dart';
import 'package:path/path.dart' as PathUtil;


class FullFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}


class AutoFiller {
  LuaVm _vm = LuaVm.newVm();


  var logger = Logger(
    filter: FullFilter(),
    output: OutPutListener(64),
    printer: PrettyPrinter(),
  );

  AutoFiller(){
    _initVM();
     // LogConsole.init(bufferSize: 256);
  }

  // Map<>
  // static void loadAllPlugins(){
  //
  // }

  void _initVM(){

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
    _vm.registerDartFunction("setField", setField);
    _vm.registerDartFunction("clearField", clearField);
    _vm.registerDartFunction("appendToListField", appendToListField);
    _vm.registerDartFunction("appendToMapField", appendToMapField);
    _vm.registerDartFunction("loadJson", loadJson);
    _vm.registerDartFunction("loadJsonFromDir", loadJsonFromDir);
    // _vm.registerDartFunction("appendDynamicName", appendDynamicName);

  }
  static StateScriptNode? _targetFillNode ;

  int loadJsonFromDir(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var name = args[0] as String;
    var dirPath = args[1] as String;
    var re = args[2] as bool;

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var path = GlobalBoard.getCorrectDirectory(dirPath, basePath: basePath);
    if (path == null) {
      logger.w("Lua : loadJsonFromDir : 文件夹 $dirPath 不存在");
      return 0;
    }
    List out = [];
    var fis = Directory(path).listSync(recursive: re);
    fis.forEach((fi) {
      if (fi is File && PathUtil.basename(fi.path) == "$name"){
        var str = fi.readAsStringSync();
        var m = json.decode(str);
        m["_file_path"] = fi.path;
        out.add(m);
      }
    });

    LuaVm.pushList2Stack(ls, out);

    return 1;
  }

  int loadJson(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var fPath = args[0];
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var path = GlobalBoard.getCorrectFile(fPath, basePath: basePath);
    if (path == null) {
      logger.w("Lua : loadJson : 文件 $fPath 不存在");
      return 0;
    }
    var str = File(path).readAsStringSync();
    var m = json.decode(str);
    LuaVm.pushTable2Stack(ls, m);
    return 1;
  }

  // int appendDynamicName(LuaState ls){
  //   var args = LuaVm.getArgs(ls, 3);
  //   var fieldName = args[0];
  //   var val = args[1];
  //   var desc = args[2];
  //   // if (_targetFillNode == null) {
  //   //   return 0;
  //   // }
  //   // //TODO , 废弃
  //   // _targetFillNode!.dynamicTriggerNames["${fieldName}_${val}"] = desc;
  //   // EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = _targetFillNode);
  //   // // }
  //   return 0;
  // }
  int clearField(LuaState ls){
    var args = LuaVm.getArgs(ls, 1);
    var fieldName = args[0];
    if (_targetFillNode == null) {
      return 0;
    }
    var tp = _targetFillNode?.getNodeStructType();
    // if (tp == null){
    //   logger.e("Lua : setField : 字段 $fieldName 不存在");
    //   return 0;
    // }
    var field = tp?.getFieldByName(fieldName);
    if (field != null){
      var valHolder = _targetFillNode?.fieldValues[field.guid];
      if (valHolder == null) valHolder = _targetFillNode?.fieldValues[field.guid] = FieldValueHolder()..name = field.name;
      var ft = SSFieldType.getFieldType(field.typeGuid , fieldInfo: field);
      if (ft == null){
        logger.e("Lua : setField : 字段 $fieldName 不存在");
        return 0;
      }
      var parsedVal =ft!.parseValue("");
      valHolder?.value = parsedVal;
      valHolder?.dtis?.clear();
      EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = _targetFillNode);
    }
    return 0;
  }
  int setField(LuaState ls){
    var args = LuaVm.getArgs(ls, 2);
    var fieldName = args[0];
    var val = args[1];
    if (_targetFillNode == null) {
      return 0;
    }
    var tp = _targetFillNode?.getNodeStructType();
    // if (tp == null){
    //   logger.e("Lua : setField : 字段 $fieldName 不存在");
    //   return 0;
    // }
    var field = tp?.getFieldByName(fieldName);
    if (field != null){
      var valHolder = _targetFillNode?.fieldValues[field.guid];
      if (valHolder == null) valHolder = _targetFillNode?.fieldValues[field.guid] = FieldValueHolder()..name = field.name;
      var ft = SSFieldType.getFieldType(field.typeGuid , fieldInfo: field);
      if (ft == null){
        logger.e("Lua : setField : 字段 $fieldName 不存在");
        return 0;
      }
      var parsedVal =ft!.parseValue(val??"");
      valHolder?.value = parsedVal;
      valHolder?.dtis?.clear();
      EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = _targetFillNode);
    }
    return 0;
  }

  int appendToMapField(LuaState ls){
    var args = LuaVm.getArgs(ls, 3);
    var fieldName = args[0];
    var key = args[1];
    var val = args[2];
    if (_targetFillNode == null) {
      return 0;
    }
    var tp = _targetFillNode?.getNodeStructType();
    var field = tp?.getFieldByName(fieldName);
    if (field != null){
      var valHolder = _targetFillNode?.fieldValues[field.guid];
      if (valHolder == null) valHolder = _targetFillNode?.fieldValues[field.guid] = FieldValueHolder()..name = field.name;
      if (field.typeGuid.indexOf("___map___")!= 0){
        logger.e("Lua : appendToMapField : 字段 $fieldName 不是字典字段");
        return 0;
      }
      var ft = SSFieldType.getFieldType(field.typeGuid , fieldInfo: field);
      if (ft == null){
        logger.e("Lua : appendToMapField : 字段 $fieldName 不存在");
        return 0;
      }
      var valTp = ft?.innerType0;
      var keyTp = ft?.innerType1;
      if (valTp != null && keyTp != null){
        var parsedVal = valTp!.parseValue(val??"");
        var parsedKey = keyTp!.parseValue(key??"");
        valHolder?.value.add({"key": parsedKey , "value":parsedVal});
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = _targetFillNode);
      }

    }
    return 0;
  }

  int appendToListField(LuaState ls){
    var args = LuaVm.getArgs(ls, 4);
    var fieldName = args[0];
    var val = args[1];
    var name = args[2];
    var id = args[3]?.toString();

    if (_targetFillNode == null) {
      return 0;
    }
    var tp = _targetFillNode?.getNodeStructType();
    var field = tp?.getFieldByName(fieldName);
    if (field != null){
      var valHolder = _targetFillNode?.fieldValues[field.guid];
      if (valHolder == null) valHolder = _targetFillNode?.fieldValues[field.guid] = FieldValueHolder()..name = field.name;
      if (field.typeGuid.indexOf("___list___")!= 0){
        logger.e("Lua : appendToListField : 字段 $fieldName 不是数组字段");
        return 0;
      }
      var ft = SSFieldType.getFieldType(field.typeGuid , fieldInfo: field);
      if (ft == null){
        logger.e("Lua : appendToListField : 字段 $fieldName 不存在");
        return 0;
      }
      var valTp = ft?.innerType0;
      if (valTp != null){
        var parsedVal = valTp!.parseValue(val??"");
        valHolder?.value.add(parsedVal);
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = _targetFillNode);
      }
      if (id != null || name != null){
        valHolder?.addDynamicTriggerInfo(id , name);
      }
    }
    return 0;
  }

  static void fill(StateScriptNode node , String byFieldName , dynamic byFieldValue){
    var af = AutoFiller();
    _targetFillNode = node ;
    var tp = node.getNodeStructType();
    af._vm.setGlobal("fillTypeName",tp!.name);
    af._vm.setGlobal("byFieldName", byFieldName);
    af._vm.setGlobal("byFieldValue", byFieldValue);

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath!);
    var tempPath = PathUtil.join(basePath , "plugins").replaceAll("\\", "/");
    var pluginLua = PathUtil.join(tempPath ,  tp!.name , "$byFieldName.lua");
    if (File(pluginLua).existsSync()) {
      try {
        // var code = File(filePath).readAsStringSync() + "\n";
        af._vm.run_file(pluginLua);
      }
      catch (e) {
        // BotToast.showText(text: e.toString(),contentColor: Colors.red);
        // TableImporter.logger.appendLog(LogType.error,"${e.toString()} , ${vm.getError()}");
        af.logger.e("${e.toString()}");
        // LogConsole(dark: true,).
        print(e);
      }

      if ((af.logger.levelCount[Level.error]??0) > 0 ||(af.logger.levelCount[Level.warning]??0) > 0 ) {
        // var con = CommonUtil.getGlobalContex();
        if (!StateScriptProject.isExportThread) {
          showDialog<void>(
            context: CommonUtil.getGlobalContex(),
            barrierDismissible: true, // false = user must tap button, true = tap outside dialog
            builder: (BuildContext dialogContext) {
              return LogConsole(logger: af.logger, dark: true, showCloseButton: true);
            },
          );
        }
        else{
          (af.logger.output as OutPutListener).outputEventBuffer.forEach((element) {
            // _renderedBuffer.add(_renderEvent(element));
            StateScriptProject.instance!.fullLogs.add(element.lines.join("\n"));
          });


        }
      }
      node.rebuildDynamicInParamsMap();
      node.rebuildDynamicOutPortMap();
      node.buildDynamicOutPortId();
      node.buildDynamicInParamId();
      EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    }
  }
}