//@dart=2.11

import 'dart:io';


import 'package:lua_dardo/lua.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Logger.dart';
import 'package:battlepus/common/lua/LuaVm.dart';
import 'package:lua_dardo/src/state/lua_state_impl.dart';
import 'package:path/path.dart' as PathUtil;

class TableImporter{

  // static var logger = Logger();
  // static var errLogger = Logger();
  static Logger logger = Logger();

  static void initVM(LuaVm vm){
    TableImporter.logger.reset();
    LuaStateImpl.fileLoadErrorCallback = (e){
      TableImporter.logger.appendLog(LogType.error,"${e.toString()}\n${vm.getError()}");
    };

    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var tempPath = PathUtil.join(basePath , "plugins").replaceAll("\\", "/");
    vm.run("package.path = '$tempPath/?.lua;;'");
    TableUtiles.initName2Clazzes();

    var errLog=(LuaState ls){
      var args = LuaVm.getArgs(ls, 1);
      var msg = args[0];
      // print("Lua : !!! ERROR !!! :     ${msg}");
      TableImporter.logger.appendLog(LogType.error,"Lua : ${msg}\n------------------- lua ------------------\n${vm.getError()}");
      return 0 ;//TableManager.getTable(filaPath);
    };
    var warningLog = (LuaState ls){
      var args = LuaVm.getArgs(ls, 1);
      var msg = args[0];
      // print("Lua : !!! WARNING !!! :     ${msg}");
      TableImporter.logger.appendLog(LogType.warning,"Lua : ${msg}" , printTrace: false);
      return 0 ;//TableManager.getTable(filaPath);
    };
    var log = (LuaState ls){
      var args = LuaVm.getArgs(ls, 1);
      var msg = args[0];
      // print("Lua : ${msg}");
      TableImporter.logger.appendLog(LogType.info,"Lua : ${msg}", printTrace: false);
      return 0 ;//TableManager.getTable(filaPath);
    };

    var getLoggerInfo = (LuaState ls){
      // var args = LuaVm.getArgs(ls, 1);
      // var msg = args[0];
      // print("Lua : ${msg}");
      LuaVm.pushTable2Stack(ls, {
        "errorCount" : logger.iErrorCount,
        "warningCount" : logger.iWarningCount,
        "logCount" : logger.iLogCount,
      });
      return 1 ;//TableManager.getTable(filaPath);
    };

    var resetLog = (LuaState ls){
      // var args = LuaVm.getArgs(ls, 1);
      // var msg = args[0];
      // print("Lua : ${msg}");
      logger.reset();
      return 0 ;//TableManager.getTable(filaPath);
    };

    vm.registerDartFunction("resetLog" , resetLog);
    vm.registerDartFunction("getLoggerInfo" , getLoggerInfo);

    vm.registerDartFunction("ErrLog", errLog);
    vm.registerDartFunction("Log", log);
    vm.registerDartFunction("WarningLog", warningLog);

    vm.registerDartFunction("setNamespace" , TableUtiles.setNamespace);
    vm.registerDartFunction("readCsvTable" , TableUtiles.readCsvTable);
    vm.registerDartFunction("importCsvTable" , TableUtiles.importCsvTable);
    vm.registerDartFunction("printTable" , TableUtiles.printTable);
    vm.registerDartFunction("setRootPath" , TableUtiles.setRootPath);
    vm.registerDartFunction("setSearchPath" , TableUtiles.setSearchPath);
    vm.registerDartFunction("loadXml" , TableUtiles.loadXml);
    vm.registerDartFunction("loadOrCreateXml" , TableUtiles.loadOrCreateXml);
    vm.registerDartFunction("createObject" , TableUtiles.createObject);
    vm.registerDartFunction("createObjectWithUniqueId" , TableUtiles.createObjectWithUniqueId);
    vm.registerDartFunction("setObjectAField" , TableUtiles.setObjectAField);
    vm.registerDartFunction("setObjectFields" , TableUtiles.setObjectFields);
    vm.registerDartFunction("setObjectAlias" , TableUtiles.setObjectAlias);
    vm.registerDartFunction("clearAllObjects" , TableUtiles.clearAllObjects);
    vm.registerDartFunction("appendToObjectList" , TableUtiles.appendToObjectList);
    vm.registerDartFunction("getObjectsMap" , TableUtiles.getObjectsMap);
    vm.registerDartFunction("getObjectsList" , TableUtiles.getObjectsList);
    vm.registerDartFunction("getObjectByGuid" , TableUtiles.getObjectByGuid);
    vm.registerDartFunction("buildMap" , TableUtiles.buildMap);
    vm.registerDartFunction("setObjectComment" , TableUtiles.setObjectComment);
    vm.registerDartFunction("setGroupFromPath" , TableUtiles.setGroupFromPath);
    vm.registerDartFunction("saveXml" , TableUtiles.saveXml);
    vm.registerDartFunction("getXmlObjectFieldNames" , TableUtiles.getXmlObjectFieldNames);
    vm.registerDartFunction("getClassObjectDefaultValue" , TableUtiles.getClassObjectDefaultValue);
    vm.registerDartFunction("searchFiles" , TableUtiles.searchFiles);
    vm.registerDartFunction("o2u_SceneClear" , TableUtiles.o2u_SceneClear);
    vm.registerDartFunction("o2u_LoadScene" , TableUtiles.o2u_LoadScene);
    vm.registerDartFunction("o2u_GetCurrentFocusObject" , TableUtiles.o2u_getCurrentFocusObject);
    vm.registerDartFunction("o2u_CreateObject" , TableUtiles.o2u_CreateObject);

    vm.registerDartFunction("o2u_RefreshScene" , TableUtiles.o2u_RefreshScene);
    vm.registerDartFunction("o2u_CreateMap" , TableUtiles.o2u_CreateMap);
    vm.registerDartFunction("u2o_BindPosition" , TableUtiles.u2o_BindPosition);
    vm.registerDartFunction("u2o_BindRotation" , TableUtiles.u2o_BindRotation);
    vm.registerDartFunction("exportCsvTable" , TableUtiles.exportCsvTable);
    vm.registerDartFunction("updateCsvObject" , TableUtiles.updateCsvObject);
    vm.registerDartFunction("saveCsvTable" , TableUtiles.saveCsvTable);
    vm.registerDartFunction("exportObjectsToCsvTable" , TableUtiles.exportObjectsToCsvTable);
    vm.registerDartFunction("sendProgressInfo" , TableUtiles.sendProgressInfo);
    vm.registerDartFunction("setTableRefable" , TableUtiles.setTableRefable);









  }

  static void import(){
    LuaVm vm = LuaVm.newVm();
    initVM(vm);
    OTDefines.inloading = true;
    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var filePath = PathUtil.join(basePath , "plugins" , "importer.lua");
    if (!File(filePath).existsSync()) return;
    try {
      // var code = File(filePath).readAsStringSync() + "\n";
      vm.run_file(filePath);
    }
    catch(e){
      // BotToast.showText(text: e.toString(),contentColor: Colors.red);
      TableImporter.logger.appendLog(LogType.error,"${e.toString()} , ${vm.getError()}");
    }



    OTDefines.inloading = false;
  }

  static void export() {
    TableUtiles.exportClear();
    LuaVm vm = LuaVm.newVm();
    initVM(vm);
    // OTDefines.inloading = true;
    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var filePath = PathUtil.join(basePath , "plugins" , "exporter.lua");
    if (!File(filePath).existsSync()) return;
    try {
      // var code = File(filePath).readAsStringSync() + "\n";
      // vm.run(code , filePath:  filePath);
      vm.run_file(filePath);
    }
    catch(e){
      // BotToast.showText(text: e.toString(),contentColor: Colors.red);
      TableImporter.logger.appendLog(LogType.error,"${e.toString()} , ${vm.getError()}");
    }
    // OTDefines.inloading = false;
  }

  static bool flushObjectToUnity(AObject obj){
    var clz = obj.getClazz();
    if (clz == null) return false;
    LuaVm vm = LuaVm.newVm();
    initVM(vm);
    // OTDefines.inloading = true;
    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var filePath = PathUtil.join(basePath , "plugins" ,"syncer", "${clz.name}_syncer.lua");
    if (!File(filePath).existsSync()) return false;
    try {
      // var code = File(filePath).readAsStringSync() + "\n";
      // vm.run(code , filePath:  filePath);
      vm.run_file(filePath);
    }
    catch(e){
      // BotToast.showText(text: e.toString(),contentColor: Colors.red);
      TableImporter.logger.appendLog(LogType.error,"${e.toString()} , ${vm.getError()}");
      return false;
    }

    return true;
  }
  // static void checkShowLog(Logger err){
  //   if (err.iErrorCount > 0 || err.iWarningCount > 0){
  //     // var filaPath = saveError("ot_err",err);
  //     showDialog(
  //       context: CommonUtil.getGlobalContex(),
  //       // barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         var child = Container(
  //           padding: EdgeInsets.all(0),
  //           width: 1200,
  //           height: 800,
  //           child:LogListPageView(logger: err,savePath: filaPath,),
  //         );
  //         return Dialog(child: child);
  //       },
  //     );
  //
  //     return ;
  //   }
  // }
}