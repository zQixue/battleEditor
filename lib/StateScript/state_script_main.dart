//@dart=2.11
import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/ExportFunc.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/ConnectAssist.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/ScriptModule.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/right_tool_bar.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/timeline_cursor.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/Tagger/tag_manager_view.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:theme_provider/theme_provider.dart';
import 'package:window_manager/window_manager.dart';
class StateScriptMain extends StatefulWidget {
  StateScriptMain({Key key}) : super(
      key: key);

  @override
  _StateScriptMainState createState() =>
      _StateScriptMainState(
      );
}

class _StateScriptMainState extends State<StateScriptMain> {

  StreamSubscription<ChangeScriptEvent> _lis;


  @override
  void dispose() {
    // windowManager.removeListener(this);
    // TODO: implement dispose
    RunSession.instance.stop();
    _lis?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // windowManager.addListener(this);
    // _init();
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScriptInfo.tryOpenLastScripts();
      BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_open");
      tryAutoExport();
      // BattlePusGlobal.reportLog("open");
      // LogReporter.instance.reportData("muf","StateScript",BattlePusGlobal.deviceId,"1.0.0","im a test event log");
    });


    var key = "${GlobalBoard.getWorkingPath()}/currentSelectedModule";
    StateScriptProject.currentSelectedModule = BattlePusGlobal.prefs.getString(key);

    Transport.instance.start();
    _lis = EventCenter.eventBus.on<ChangeScriptEvent>().listen((event) {
      setState(() {
        // print("event.scriptName");
        // var scriptName = event.scriptName;
        if (event.id != null) {
          var script = StateScriptProject.instance.getScriptByExportId(event.id);
          // if (script == null){
          //   script = StateScriptProject.instance.getScriptByName("Buf_$scriptName");
          // }
          ScriptInfo.current = script;
          ScriptInfo.addOpenScript(script);

          if(script != null ) {
            TimelineCursorInfo.posX = 0;
            TimelineCursorState.send2Unity(TimelineCursorInfo.posX);
          }
        }
        var scriptGuid = event.scriptGuid;
        if (scriptGuid != null) {
          var newLevel = StateScriptProject.instance.getScriptByGuid(scriptGuid);
          if (newLevel != null){
            ScriptInfo.current = newLevel;
            ScriptInfo.addOpenScript(newLevel);
            // Future.delayed(Duration(milliseconds: 100)).then((value){
            //   if(newLevel.hasTimelineNodes()){
            //     EventCenter.eventBus.fire(TimelineCursorInit());
            //   }
            // });

            TimelineCursorInfo.posX = 0;
            TimelineCursorState.send2Unity(TimelineCursorInfo.posX);


          }
          else{
            if (event.createIfNull??false) {
              var newScript = StateScriptProject.instance.addScript();
              newScript.guid = event.scriptGuid;
              newScript.name = "NewScript";
              newScript.saveScript();
              ScriptInfo.current = newScript;

              ScriptInfo.addOpenScript(newScript);
              TimelineCursorInfo.posX = 0;
              TimelineCursorState.send2Unity(TimelineCursorInfo.posX);

              // Future.delayed(Duration(milliseconds: 100)).then((value){
              //   if(newLevel.hasTimelineNodes()){
              //     EventCenter.eventBus.fire(TimelineCursorInit());
              //   }
              // });
            }
          }
        }
      });
    });

    ScriptInfo.current = null;

    SSFieldType.initSystemType();
    SSMainSetting.load();
    StateScriptProject.load();

    if (DartCommon.isDirValid(SSMainSetting.instance.workingPath)) {
      var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
      var pathFile = PathUtil.join(path,"connection_assists.json");
      print(pathFile);
      ConnectAssist.load(pathFile);
    }
    // StateScriptProject.watchProject(context, (){
    //   Navigator.popUntil(context, ModalRoute.withName('/'));
    //   StateScriptProject.clearInstance();
    //   ScriptInfo.openedScripts?.clear();
    //   Navigator.pushNamed(context, "/StateScriptMain");
    // });
    StateScriptProject.instance.registerEnumTypes();
    StateScriptProject.instance.registerBehavicAgentTypes();

    if (StateScriptProject.instance.useObjectTable) {
      Future.delayed(Duration(milliseconds: 10)).then((value){
        ObjectTableSetting.load();

        if (ObjectTableProject.isValid()) {
          if (ObjectTableSetting.instance.workingPath != "") {
            ObjectTableProject.load();
            ObjectTableProject.instance.registerEnumTypes();
            // initExtraType();
            OTGlobalBoard.clear();
          }
        }
      });

    }

    if (ScriptInfo.nextScript != null){
      var scriptInfo = StateScriptProject.instance.findScriptByName(ScriptInfo.nextScript);
      bool bNew = false;
      if (scriptInfo == null){
        scriptInfo = BattlePusGlobal.tryCreateScript(ScriptInfo.nextScript);
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
        }
        else{
          ScriptInfo.nextListScript = scriptInfo;
          Navigator.pushReplacementNamed(CommonUtil.getGlobalContex(), "/ScriptListView");
        }
      }
    }

    CodeBlockyType.registerBlockyTypes();
    StateScriptProject.doWatchProject();
    print("---------------------------------------- main init");
    super.initState();
//    NodeCamp.load();
  }


  // 脚本查找同款按钮：深色半透明底 + 彩色边框框住文字，不带图标
  Widget barBtn(String label, {Color color = Colors.grey, VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 34,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(160, 30, 30, 30),
          border: Border.all(color: CommonUtil.scaleColor(color, 0.8), width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(label, maxLines: 1, overflow: TextOverflow.clip, style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 228, 223, 223), fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("autoexprotscirpt " + BattlePusGlobal.autoExportStateScript.toString());

    // if (SSMainSetting.instance.workingPath == null || SSMainSetting.instance.workingPath.isEmpty){
    if (!DartCommon.isDirValid(SSMainSetting.instance.workingPath)){
      return Scaffold(
        body: Center(child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("请选择工程文件夹,或者创建新工程"  , style: TextStyle(fontSize: 48 , color: Colors.grey),),
            SizedBox(height: 48,),
            IconButton(icon: Icon(MaterialCommunityIcons.folder_open , color: Colors.blue,),iconSize: 48, color: Colors.white, tooltip:"打开工程",
              onPressed: () async {
                var path = await FileUtils.pickPath();
                if (path == null) return ;
                var filePath = PathUtil.join(path,"state_script_project.json");
                if (File(filePath).existsSync()){
                  SSMainSetting.instance.workingPath = PathUtil.relative(path , from:GlobalBoard.getWorkingPath());
                  if (SSMainSetting.instance.workingPath != null){
                    setState(() {
                      StateScriptProject.load();
                      StateScriptProject.instance.save();
                    });
                  }
                }
                else{
                  setState(() {
                    BotToast.showText(text: "不是有效的工程目录" , contentColor: Colors.redAccent);
                  });
                }

                SSMainSetting.instance.save();
              },
            ),
            IconButton(icon: Icon(MaterialCommunityIcons.file_document_box_plus_outline , color: Colors.blue,),iconSize: 48, color: Colors.white, tooltip:"新建工程",
              onPressed: () async {
                var path = await FileUtils.pickPath();
                if (path == null) return ;
                var filePath = PathUtil.join(path,"state_script_project.json");
                if (!File(filePath).existsSync()){
                  SSMainSetting.instance.workingPath = PathUtil.relative(path , from:GlobalBoard.getWorkingPath());
                  if (SSMainSetting.instance.workingPath != null){
                    setState(() {
                      StateScriptProject.load();
                      StateScriptProject.instance.save();
                    });
                  }
                }
                else{
                  setState(() {
                    BotToast.showText(text: "存在工程，忽略创建，直接加载", contentColor: Colors.redAccent);
                    SSMainSetting.instance.workingPath = PathUtil.relative(path , from:GlobalBoard.getWorkingPath());
                    if (SSMainSetting.instance.workingPath != null){
                      StateScriptProject.load();
                      StateScriptProject.instance.save();
                    }
                  });
                }

                SSMainSetting.instance.save();
              },
            )
          ],
        ))
      );
    }

    return Scaffold(
        // 按钮行移到画布左上角顶部一整行；「锁定中心」等原有按钮往下移一行
        body: Stack(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: StateScriptProject.instance.isShowTipsNotifier,
              builder: (context, isShowTips, child) {
                return TooltipVisibility(
                  visible: isShowTips,
                  child: SSCanvasView(),
                );
              },
            ),
            Positioned(
              left: 8,
              top: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

            barBtn("选择脚本",
              onPressed: (){
                var openCB = (){
                  var old = ScriptInfo.current;
                  Navigator.pushNamed(context, "/ScriptListView").then((value){
                    if (value != null){

                      setState(() {
                        ScriptInfo.tryOpenScripts(value);

                        ScriptInfo.current.initCanvasPos();
                        StateScriptNode.clearSelectedNodesMap();
                      });

                      return;
                    }

                    if (ScriptInfo.current != old){

                      ScriptInfo.addOpenScript(ScriptInfo.current);
                      ScriptInfo.current.initCanvasPos();
                      StateScriptNode.clearSelectedNodesMap();
                      setState(() {

                      });
                    }
                  });
                };

                if (StateScriptProject.currentSelectedModule == null){
                  if (StateScriptProject.instance?.scriptModules == null){
                    StateScriptProject.instance?.scriptModules = Map<String,ScriptModule>();
                  }
                  if (StateScriptProject.instance.scriptModules == null || StateScriptProject.instance.scriptModules.length<=0) {
                    StateScriptProject.currentSelectedModule = "";
                    openCB();
                  }
                  else {
                    Navigator.pushNamed(context, "/SelectScriptModuleView").then((value) {
                      if (value != null) {
                        StateScriptProject.currentSelectedModule = value;
                        var key = "${GlobalBoard.getWorkingPath()}/currentSelectedModule";
                        BattlePusGlobal.prefs.setString(key, value);
                        openCB();
                      }
                    });
                  }
                  return ;
                }

                openCB();
              },
            ),
            barBtn(SSUserData.instance.debugMode ? "全量导出(debug模式)" : "全量导出",
              color: SSUserData.instance.debugMode ? Colors.redAccent : Colors.grey,
              onPressed: () {export();},
            ),
            if (ScriptInfo.current != null) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                barBtn(SSUserData.instance.debugMode ? "精简加速导出(debug模式)" : "导出所有打开脚本",
                    color: SSUserData.instance.debugMode ? Colors.redAccent : Colors.grey,
                    onPressed: (){

                      if (StateScriptProject.instance.useObjectTable) {
                        if (ObjectTableProject.isValid()) {
                          var exists = SSObjBase.buildHashExportId(StateScriptProject.instance.enums);
                          ObjectTableProject.instance.prepareExport(enumExistsHashs: exists);
                        }
                      }

                      // BotToast.showText(text : "开始导出");
                      var startTime = DateTime.now();
                      StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
                      StateScriptProject.instance.prepareExport();

                      
                      // StateScriptProject.instance.save();
                      StateScriptProject.instance.saveAllScript();

                      ScriptInfo.openedScripts.forEach((element) {
                        StateScriptProject.instance.exportScriptBinary(element);
                      });
                      var endTime = DateTime.now();
                      var duration = endTime.difference(startTime);
                      BotToast.showText(text : "${ScriptInfo.current.name} 导出结束，耗时: ${duration.inMilliseconds}ms" , contentColor: Colors.green);
                      BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_exportOpenScriptsFast_${duration.inMilliseconds}");
                    }),
                barBtn(SSUserData.instance.debugMode ? "精简加速单脚本导出(debug模式)" : "当前脚本导出",
                    color: SSUserData.instance.debugMode ? Colors.redAccent : Colors.grey,
                    onPressed: (){

                      if (StateScriptProject.instance.useObjectTable) {
                        if (ObjectTableProject.isValid()) {
                          var exists = SSObjBase.buildHashExportId(StateScriptProject.instance.enums);
                          ObjectTableProject.instance.prepareExport(enumExistsHashs: exists);
                        }
                      }

                      // BotToast.showText(text : "开始导出");
                      var startTime = DateTime.now();
                      StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
                      StateScriptProject.instance.prepareExport();

                      StateScriptProject.instance.saveAllScript();

                      if(!StateScriptProject.instance.checkScriptInfosHave())
                        StateScriptProject.instance.save();
                      
                      StateScriptProject.instance.exportScriptBinary(ScriptInfo.current);
                      var endTime = DateTime.now();
                      var duration = endTime.difference(startTime);
                      BotToast.showText(text : "${ScriptInfo.current.name} 导出结束，耗时: ${duration.inMilliseconds}ms" , contentColor: Colors.green);
                      BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_exportSingleScriptsFast_${duration.inMilliseconds}");
                    }),

              ],

            ),
            // if (ScriptInfo.current != null) IconButton(icon: Icon(MaterialCommunityIcons.export),iconSize: 36,
            // color: SSUserData.instance.debugMode ? Colors.red:Colors.white,
            // tooltip:SSUserData.instance.debugMode ? "单独导出(debug模式)":"单独导出",
            // onPressed: (){
            //
            //   if (StateScriptProject.instance.useObjectTable) {
            //     if (ObjectTableProject.isValid()) {
            //       var exists = SSObjBase.buildHashExportId(StateScriptProject.instance.enums);
            //       ObjectTableProject.instance.prepareExport(enumExistsHashs: exists);
            //     }
            //   }
            //
            //   // BotToast.showText(text : "开始导出");
            //   StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
            //   StateScriptProject.instance.prepareExport();
            //
            //   StateScriptProject.instance.save();
            //   StateScriptProject.instance.saveAllScript();
            //
            //   StateScriptProject.instance.exportScriptBinary(ScriptInfo.current);
            //   BotToast.showText(text : "${ScriptInfo.current.name} 导出结束" , contentColor: Colors.green);
            // }),

            if (ScriptInfo.current != null) barBtn("运行",
                onPressed: (){
                  //添加导出
                  StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
                  StateScriptProject.instance.prepareExport();
                  StateScriptProject.instance.save();
                  StateScriptProject.instance.saveAllScript();
                  StateScriptProject.instance.exportScriptBinary(ScriptInfo.current);


                  RunScript po = RunScript();
                  po.scriptName = ScriptInfo.current.name;
                  po.group = ScriptInfo.current.group;
                  po.tags.addAll(ScriptInfo.current.tagSet.getTagNames());

                  Transport.instance.sendUdpData(OPackType.O2U_RunWithScript, po);
                  BotToast.showText(text : "运行脚本: ${ScriptInfo.current.name} " , contentColor: Colors.green);
                  // // BotToast.showText(text : "开始导出");
                  // StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
                  // StateScriptProject.instance.prepareExport();
                  //
                  // StateScriptProject.instance.save();
                  // StateScriptProject.instance.saveAllScript();
                  //
                  // StateScriptProject.instance.exportScriptBinary(ScriptInfo.current);
                  // BotToast.showText(text : "${ScriptInfo.current.name} 导出结束" , contentColor: Colors.green);
                }),

//            IconButton(icon: Icon(MaterialCommunityIcons.image_filter_center_focus),iconSize: 32, color: Colors.white, tooltip:"居中内容",
//              onPressed: (){
//                StateScriptProject.instance.saveAllScript();
//                StateScriptProject.instance.centerNodes();
//                BotToast.showSimpleNotification(title: "居中完毕");
//              },
//            ),
            barBtn("保存",
              onPressed: () async {

              if(ScriptInfo.current != null && ScriptInfo.current.hasTimelineNodes()){
                if (ScriptInfo.current != null) {
                  ScriptInfo.current.scriptData.forceUpdateNodePositions();
                }

                BotToast.showText(text : "开始保存");
                if (StateScriptProject.instance.useObjectTable) {
                  if (ObjectTableProject.isValid()) {
                    if (!await BattlePusGlobal.isSubWindowExists("/ObjectTableMain")) {
                      ObjectTableProject.instance.save(context: context);
                    }
                  }
                }
                StateScriptProject.instance.saveAllScript();
                StateScriptProject.instance.save();
                BotToast.showText(text : "保存完毕" ,contentColor: Colors.green);
              }else{

                if (StateScriptProject.instance.forceSaveNodePosition){
                  if (ScriptInfo.current != null) {
                    ScriptInfo.current.scriptData.forceUpdateNodePositions();
                  }

                  BotToast.showText(text : "开始保存");
                  if (StateScriptProject.instance.useObjectTable) {
                    if (ObjectTableProject.isValid()) {
                      if (!await BattlePusGlobal.isSubWindowExists("/ObjectTableMain")) {
                        ObjectTableProject.instance.save(context: context);
                      }
                    }
                  }
                  StateScriptProject.instance.saveAllScript();
                  StateScriptProject.instance.save();
                  BotToast.showText(text : "保存完毕" ,contentColor: Colors.green);
                }
                else{

                  CommonUtil.confirm(context, "是否保存结点位置变动?" , ok:"保存" , cancel: "不保存", onOk: () async {
                    if (ScriptInfo.current != null) {
                      ScriptInfo.current.scriptData.forceUpdateNodePositions();
                    }

                    BotToast.showText(text : "开始保存");
                    if (StateScriptProject.instance.useObjectTable) {
                      if (ObjectTableProject.isValid()) {
                        if (!await BattlePusGlobal.isSubWindowExists("/ObjectTableMain")) {
                          ObjectTableProject.instance.save(context: context);
                        }
                      }
                    }
                    StateScriptProject.instance.saveAllScript();
                    StateScriptProject.instance.save();
                    BotToast.showText(text : "保存完毕" ,contentColor: Colors.green);
                  },
                      onCancel:() async {
                        BotToast.showText(text : "开始保存");
                        if (StateScriptProject.instance.useObjectTable) {
                          if (ObjectTableProject.isValid()) {
                            if (!await BattlePusGlobal.isSubWindowExists("/ObjectTableMain")) {
                              ObjectTableProject.instance.save(context: context);
                            }
                          }
                        }
                        StateScriptProject.instance.saveAllScript();
                        StateScriptProject.instance.save();
                        BotToast.showText(text : "保存完毕" ,contentColor: Colors.green);
                      });

                }

              }




              },
            ),
//            Expanded(child:Container()),
            barBtn("结点定义",
              onPressed: (){
                Navigator.pushNamed(context, "/NodeDefinePage").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
              },
            ),
            barBtn("枚举定义",
              onPressed: (){
                Navigator.pushNamed(context, "/EnumTypePage").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
              },
            ),
            barBtn("标签管理",
              onPressed: (){
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    var child = ThemeCenter.area(width:800 ,height:600, child: TagManagerView(camp: StateScriptProject.instance.tagCamp,));
                    return ThemeConsumer(child:Dialog(child: child));
                  },
                );
              },
            ),
            barBtn("行为树设定",
              onPressed: (){
                Navigator.pushNamed(context, "/BehavicAgentTypeView").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
              },
            ),
//            IconButton(icon: Icon(MaterialCommunityIcons.alpha_i_box_outline),iconSize: 36, color: Colors.white, tooltip:"接口定义",
//              onPressed: (){
//                Navigator.pushNamed(context, "/StateScriptSettingPage").then((value) {
//                  setState(() {
//
//                  });
//                });
//              },
//            ),
//             IconButton(icon: Icon(MaterialCommunityIcons.export),iconSize: 36, color: Colors.white, tooltip:"导出预制包",
//               onPressed: (){
//                 Navigator.pushNamed(context, "/ProjectExporterPage").then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
//               },
//             ),
//             IconButton(icon: Icon(MaterialCommunityIcons.import),iconSize: 38, color: Colors.white, tooltip:"导入预制包",
//               onPressed: () async {
//                 var path = await FileUtils.pickFile("json" ,["json"]);
//                 if (path == null) return;
//                 setState(() {
//                   Navigator.pushNamed(context, "/ProjectImportPage" , arguments: path).then((value) => EventCenter.eventBus.fire(GlobalRefreshEvent()));
//                 });
//               },
//             ),
            barBtn("设置",
              onPressed: (){
                Navigator.pushNamed(context, "/StateScriptSettingPage").then((value){
                  setState(() {
                    ///刷新
                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                  });
                });
              },
            ),
            // MultiWindowEntry(),
            // SizedBox(width: 8,)
                  ],
                ),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: Container(
        //   // height: 32,
        //   child: Stack(
        //     children: [
        //       ContextMenuOverlay(
        //         // getTag : "main",
        //         blockPointer: false,
        //         // child: Container(),
        //       ),
        //       getScriptsTab(),
        //     ],
        //   ),
        // ),
        // bottomNavigationBar:getScriptsTab(),
    );

  }


void tryAutoExport()
{
  if (BattlePusGlobal.autoExportStateScript) {
    export(callback: () async {
      print("导出完成 自动关闭");
         try {
              final subWindowIds = await DesktopMultiWindow.getAllSubWindowIds();
              for (final windowId in subWindowIds) {
                WindowController.fromWindowId(windowId).close();
              }
            } catch (e) {}

          Navigator.of(CommonUtil.getGlobalContex()).pop();
          await windowManager.destroy();
      } 
    );
  }
}

  Future export({VoidCallback callback = null} ) async{
    var startTime = DateTime.now();
     BotToast.showText(text : "开始导出");
    StateScriptProject.instance.prepareExport();

    // StateScriptProject.instance.prepareExport();
    if (StateScriptProject.instance.useObjectTable) {
      if (ObjectTableProject.isValid()) {

        var exists = SSObjBase.buildHashExportId(StateScriptProject.instance.enums);
        ObjectTableProject.instance.prepareExport(enumExistsHashs: exists);
        if (!await BattlePusGlobal.isSubWindowExists("/ObjectTableMain")) {
          ObjectTableProject.instance.save();
        }
      }
    }
    StateScriptProject.instance.save();
    StateScriptProject.instance.saveAllScript();
//                StateScriptProject.instance.export();

    var prms = {
      "project": "",
      "setting":"",
      "mode": SSUserData.instance.debugMode??false,
    };
    CommonUtil.showProgress(context);
    StateScriptProject.cancelWatchProject();

    DartCommon.runIsolate(exportProject2 , prms , onDataOut: (data){
      //通信
      if (data["process"] != null){
        EventCenter.eventBus.fire(ProgressEvent()..info = data["process"]);
      }
      if (data["export_done"] == true){
        setState(() {
        });
        Navigator.pop(context);
        BotToast.showText(text: "导出完毕" , contentColor: Colors.green);
        // ThemeCenter.showTextDialog(context, data["log"]);
        StateScriptProject.doWatchProject();
        var income = data["project"] as StateScriptProject;
        Map<String , StateScript> sds = Map<String , StateScript>();
        income.scripts.forEach((element) { sds[element.guid] = element.scriptData;});
        StateScriptProject.instance.scripts.forEach((element) {element.setScriptData(sds[element.guid]);});

        var proj = data["project"] as StateScriptProject;
        Map<String, NodeStructData> nts = Map<String, NodeStructData>();
        proj.nodeStructs.forEach((element) {
          nts[element.guid] = element;
        });

        StateScriptProject.instance.nodeStructs.forEach((element) {
          var inCome = nts[element.guid];
          if (inCome != null){
            element.forceExportGenPath = inCome.forceExportGenPath;
            element.forceExportNodePath = inCome.forceExportNodePath;
          }
        });
        StateScriptProject.instance.csharpConfig.defaultNodeExportPath = proj.csharpConfig.defaultNodeExportPath;
        StateScriptProject.instance.csharpConfig.defaultGenExportPath = proj.csharpConfig.defaultGenExportPath;
        StateScriptProject.instance.csharpConfig.logicGenExportPath = proj.csharpConfig.logicGenExportPath;
        StateScriptProject.instance.csharpConfig.logicNodeExportPath = proj.csharpConfig.logicNodeExportPath;
        callback?.call();
      }

      if (data["error"] != null){
        Navigator.pop(context);
        BotToast.showText(text: data["error"] , contentColor: Colors.redAccent);
        stderr.writeln( data["error"] );
        DartCommon.launchURL(data["savePath"]);
        StateScriptProject.doWatchProject();
        callback?.call();
      }
    });

    var endTime = DateTime.now();
    var duration = endTime.difference(startTime);
    BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_export_${duration.inMilliseconds}");
  }







}
