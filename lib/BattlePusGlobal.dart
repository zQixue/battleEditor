import 'dart:convert';
import 'dart:io';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loggerReport/Logger/LogReporter.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/right_tool_bar.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'ObjectTable/Struct/ObjectTableProject.dart';
import 'package:path/path.dart' as PathUtil;

class BattlePusGlobal{
  static int windowId = -1 ;
  static WindowController? windowController;


  static Map<String ,int> subWindowIdMap = <String ,int>{};

  static SharedPreferences? prefs;

  static bool isRestart = false;

  // 由外部工具（如 Unity 的 BattlePusTools）启动时带参，直接进入状态脚本编辑界面
  static bool openStateScript = false;

  static String deviceId = "";

  static bool autoExportStateScript = false;

    //版本
  static String version = "1.0.1";
  //项目
  static String project = "战斗编辑器";

  static Future refreshSubWindows() async {
    var subWindowIds = [];
    try{
      subWindowIds = await DesktopMultiWindow.getAllSubWindowIds();
    }
    catch(e){

    }

    var dels = [];
    subWindowIdMap.forEach((key, value) {
      if (!subWindowIds.contains(value)){
        dels.add(key);
      }
    });
    dels.forEach((element) {
      subWindowIdMap.remove(element);
    });
  }
  
  static Future<bool> isSubWindowExists(String route)async{
    await refreshSubWindows();
    return subWindowIdMap.containsKey(route) ;
  }

  static createSubWindow(String title , String route)async{
    if (await isSubWindowExists(route)){
      return ;
    }

    final window = await DesktopMultiWindow.createWindow(jsonEncode({
      'route': route,
    }));
    window
      // ..setFrame(const Offset(0, 0) & const Size(1280, 720))
      ..center()
      ..setTitle(title)
      ..show();

    subWindowIdMap[route] = window.windowId;
  }

  static void initExtraType(){
    SSFieldType.registerFieldType("___objref___" , FTObjectReference()..typeGroup = "对象引用"..name = "ref"..alias = "对象引用"..priority=640..innerTypeCount=1..flag=(SSFieldType.FIELD_FLAG_REF|SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD));
  }

  static Future<dynamic> handleMethodCallback(MethodCall call, int fromWindowId) async {
    if (call.arguments.toString() == "ping") {
      return "pong";
    }

    // if (windowController != null) {
    //   print("${call.method} ${call.arguments}");
    // }
    print("${call.method} ${call.arguments}");
    switch(call.method){
      case "transport":
        {
          Transport.instance.forceSolve(call.arguments["data"]);
          break;
        }
      case "ot_reload":
        {

          SSFieldType.initSystemType();
          initExtraType();
          ObjectTableSetting.load();
          OTGlobalBoard.clear();

          ObjectTableProject.clearObjects();
          ObjectTableProject.load();
          EventCenter.eventBus.fire(AObjectTableCleared());
          break;
        }
      case "open_script":
        {
          var scriptName = call.arguments["name"];
          //.firstWhere((element) => element.name == scriptName , orElse: ()=> );
          if (!StateScriptProject.isValid()){
            // ScriptInfo? scriptInfo = StateScriptProject.instance!.findScriptByName(scriptName);
            // print("goto main");
            ScriptInfo.nextScript = scriptName;
            // tryCreateScript(scriptName);
            Navigator.popUntil(CommonUtil.getGlobalContex(), (route) => route.isFirst);
            Navigator.pushReplacementNamed(CommonUtil.getGlobalContex(), "/StateScriptMain");
            return ;
          }

          ScriptInfo? scriptInfo = StateScriptProject.instance!.findScriptByName(scriptName);
          print("try open script $scriptInfo");
          bool bNew = false;
          if (scriptInfo == null){
            scriptInfo = tryCreateScript(scriptName);
            bNew = true;
          }
          if (scriptInfo != null) {
            if (!bNew) {
              RightToolBarState.scriptStack.push(scriptInfo.guid);
              ScriptInfo.current = scriptInfo;
              ScriptInfo.addOpenScript(scriptInfo);
              if (ZoomState.current != null) {
                ZoomState.current.centered();
              }
              EventCenter.eventBus.fire(GlobalRefreshEvent());
              Navigator.popUntil(CommonUtil.getGlobalContex(), (route) => route.isFirst);
            }
            else{
              Navigator.popUntil(CommonUtil.getGlobalContex(), (route) => route.isFirst);
              ScriptInfo.nextListScript = scriptInfo;
              Navigator.pushReplacementNamed(CommonUtil.getGlobalContex(), "/ScriptListView");
            }
          }
          break;
        }
      case "get_object_space":
        {
          if (TableUtiles.currentObject != null && (TableUtiles.currentObject.getClazz()?.buildSpaceMap??false)){
            return TableUtiles.currentObject.guid;
          }

          return null;
        }
        break;
    }
    // setState(() {
    //   messages.insert(
    //     0,
    //     MessageItem(
    //       from: fromWindowId,
    //       method: call.method,
    //       content: call.arguments,
    //     ),
    //   );
    // });
  }

  static ScriptInfo? tryCreateScript(String name){
    ScriptInfo newScript = StateScriptProject.instance!.addScript();
    newScript.name = name;
    StateScriptProject.instance!.save();
    return newScript;
  }

  static Future broadcast(String method , [dynamic arguments]) async {
    var subWindowIds = [];
    try{
      subWindowIds = await DesktopMultiWindow.getAllSubWindowIds();
    }
    catch(e){
    }

    // print("broadcast $subWindowIds");
    for (final windowId in subWindowIds) {
      DesktopMultiWindow.invokeMethod(
        windowId,
        method,
        // 'Broadcast from main window',
        arguments,
      );
    }
  }

  static Future<String> getObjectSpace() async {
    var subWindowIds = [];
    try{
      subWindowIds = await DesktopMultiWindow.getAllSubWindowIds();
    }
    catch(e){
    }

    // print("broadcast $subWindowIds");
    for (final windowId in subWindowIds) {
      var res = await DesktopMultiWindow.invokeMethod(
        windowId,
        "get_object_space",
        // 'Broadcast from main window',
        null,
      );

      if (res != null){
        return res;
      }
    }

    return "";
  }

  static Future broadcastToMain(String method , [dynamic arguments]) async {
    if (windowController == null) return ;
    DesktopMultiWindow.invokeMethod(
      0,
      method,
      // 'Broadcast from main window',
      arguments,
    );
  }

  static String state_script = "StateScript";

   static String getUserName()  {
    String userName = "Unknown";
    try {
        if(Platform.environment['USERDOMAIN'] != null){
          userName = Platform.environment['USERDOMAIN']!;
        }
        else {
          userName = Platform.environment['USERNAME']!;
        }
      } on PlatformException catch (e) {
        print("Failed to get username: '${e.message}'.");
      }
      
    return userName;
}

  static void reportLog(String type , String msg){
    var fullMsg = msg + "_" + BattlePusGlobal.project;
    var dirName = PathUtil.dirname(Platform.resolvedExecutable);
    var launcherPath = PathUtil.join(dirName , "Logger.exe");
    var file = File(launcherPath);
    if(file.existsSync()) {
        var workingDirectory = PathUtil.dirname(launcherPath);
        Process.start(launcherPath, ["-p","muf","-i","","-t",type,"-v",BattlePusGlobal.version,"-m",fullMsg], runInShell: false , workingDirectory: workingDirectory ,mode: ProcessStartMode.detached);
    }
    else{
      LogReporter.instance.reportData("muf",type,BattlePusGlobal.deviceId,BattlePusGlobal.version,fullMsg);
    }
  }
}