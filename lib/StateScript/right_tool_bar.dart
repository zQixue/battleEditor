//@dart=2.11
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ListStatck.dart';


class RightToolBar extends StatefulWidget {
  RightToolBar({Key key}) : super(key: key);

  @override
  RightToolBarState createState() => RightToolBarState();
}

class RightToolBarState extends State<RightToolBar> {

  static ListStack<String> scriptStack = ListStack();

  String searchVar;
  List<StateScriptNode> foundNodes = List<StateScriptNode>();
  int foundIndex = 0;


  Future saveAndExport() async{

//    CommonUtil.showLoading(context);

    StateScriptProject.instance.saveAllScript();
    try{

      // StateScriptProject.instance.exportBinaryOnly();

      StateScriptProject.instance.getAllConfigs().forEach((element) async {
        StateScriptProject.instance.switchExportConfig(element);
        await StateScriptProject.instance.exportBinaryOnly();
      });

      // if (StateScriptProject.instance.csharpConfig.active){
      //   StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
      //   StateScriptProject.instance.exportBinaryOnly();
      // }
      // if (StateScriptProject.instance.luaConfig.active){
      //   StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.luaConfig);
      //   StateScriptProject.instance.exportBinaryOnly();
      // }
    }
    catch(e,s){
      BotToast.showText(text: "导出出错:${e.toString()}\n${s.toString()}" ,contentColor: Colors.redAccent ,duration : const Duration(seconds: 100),clickClose:true);
      print(e);
      print(s);
//      Navigator.pop(context);
      return;
    }
//    Navigator.pop(context);
    BotToast.showSimpleNotification(title: "导出完毕");
  }

  // 锁定中心同款按钮：深色半透明底 + 彩色边框框住文字，不带图标
  Widget textBtn(String label, {Color color = Colors.grey, VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 34,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
    // print(ScriptInfo.current.guid);
    var commands = [
      textBtn("全选中",
        onPressed: (){
          if (ScriptInfo.current != null){
            ScriptInfo.current.selectAll();
            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
        },
      ),
      textBtn("全不选",
        onPressed: (){
          if (ScriptInfo.current != null){
            ScriptInfo.current.unselectAll();
            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
        },
      ),
//        IconButton(
//          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//          icon:Icon(MaterialCommunityIcons.format_color_fill),
//          iconSize: 40,
//          tooltip: "全不选",
//          color: Colors.indigo,
//          onPressed: (){
//          },
//        ),
      textBtn("左对齐",
        onPressed: (){
          if (ScriptInfo.current != null){
            var nodes = ScriptInfo.current.scriptData.nodes;
            var minLeft = double.maxFinite;
            bool bingo = false;
            for(var n in nodes){
              if (n.selected){
                minLeft = min(n.x , minLeft);
                bingo = true;
              }
              for(var sop in n.soports){
                if (sop.selected){
                  minLeft = min(sop.x - sop.width , minLeft);
                  bingo = true;
                }
              }
              for(var sop in n.sops){
                if (sop.selected){
                  minLeft = min(sop.x - sop.width , minLeft);
                  bingo = true;
                }
              }
            }
            if (bingo){
              for(var n in nodes){
                if (n.selected){
                  // maxRight = max(n.x + n.getNodeStructType().width , maxRight);
                  n.x = minLeft;
                }
                for(var sop in n.soports){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    print("sop.width ${sop.width}");
                    sop.x = minLeft + sop.width;
                  }
                }
                for(var sop in n.sops){
                  if (sop.selected){
                    print("sop.width ${sop.width}");
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.x = minLeft+ sop.width;
                  }
                }
              }
            }

            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
        },
      ),
      textBtn("右对齐",
        onPressed: (){
          if (ScriptInfo.current != null){
            var nodes = ScriptInfo.current.scriptData.nodes;
            var maxRight = double.minPositive;
            bool bingo = false;
            for(var n in nodes){
              if (n.selected){
                maxRight = max(n.x + n.getWidth() , maxRight);
                bingo = true;
              }
              for(var sop in n.soports){
                if (sop.selected){
                  maxRight = max(sop.x , maxRight);
                  bingo = true;
                }
              }
              for(var sop in n.sops){
                if (sop.selected){
                  maxRight = max(sop.x , maxRight);
                  bingo = true;
                }
              }
            }
            if (bingo){
              for(var n in nodes){
                if (n.selected){
                  // maxRight = max(n.x + n.getNodeStructType().width , maxRight);
                  n.x = maxRight - n.getWidth();
                }
                for(var sop in n.soports){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.x = maxRight;
                  }
                }
                for(var sop in n.sops){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.x = maxRight;
                  }
                }
              }
            }

            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
        },
      ),
      textBtn("上对齐",
        onPressed: (){
          double sopOffY = 4;
          if (ScriptInfo.current != null){
            var nodes = ScriptInfo.current.scriptData.nodes;
            var minTop = double.maxFinite;
            bool bingo = false;
            for(var n in nodes){
              if (n.selected){
                minTop = min(n.y , minTop);
                bingo = true;
              }
              for(var sop in n.soports){
                if (sop.selected){
                  minTop = min(sop.y , minTop);
                  bingo = true;
                }
              }
              for(var sop in n.sops){
                if (sop.selected){
                  minTop = min(sop.y , minTop);
                  bingo = true;
                }
              }
            }
            if (bingo){
              for(var n in nodes){
                if (n.selected){
                  // maxRight = max(n.x + n.getNodeStructType().width , maxRight);
                  n.y = minTop;
                }
                for(var sop in n.soports){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.y = minTop ;//+ sop.width;
                  }
                }
                for(var sop in n.sops){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.y = minTop ;//+ sop.width;
                  }
                }
              }
            }

            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
        },
      ),

      textBtn("下对齐",
        onPressed: (){
          if (ScriptInfo.current != null){
            double nodeOffY = 5;
            var nodes = ScriptInfo.current.scriptData.nodes;
            var maxBottom = double.minPositive;
            bool bingo = false;
            for(var n in nodes){
              if (n.selected){
                maxBottom = max(n.y + n.totalLineHeight + nodeOffY, maxBottom);
                bingo = true;
              }
              for(var sop in n.soports){
                if (sop.selected){
                  maxBottom = max(sop.y+ SSDefines.sopHeight , maxBottom);
                  bingo = true;
                }
              }
              for(var sop in n.sops){
                if (sop.selected){
                  maxBottom = max(sop.y+ SSDefines.sopHeight , maxBottom);
                  bingo = true;
                }
              }
            }
            if (bingo){
              for(var n in nodes){
                if (n.selected){
                  // maxRight = max(n.x + n.getNodeStructType().width , maxRight);
                  n.y = maxBottom - n.totalLineHeight - nodeOffY;
                }
                for(var sop in n.soports){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.y = maxBottom - SSDefines.sopHeight ;
                  }
                }
                for(var sop in n.sops){
                  if (sop.selected){
                    // maxRight = max(sop.x + SSDefines.sopWidth , maxRight);
                    sop.y = maxBottom- SSDefines.sopHeight ;
                  }
                }
              }
            }

            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
        },
      ),
      textBtn("合并成组",
        onPressed: (){
          ScriptInfo.doGroup();
          // if (ScriptInfo.current != null){
          //   var nodes = ScriptInfo.current.scriptData.nodes;
          //   String crtGroup ;
          //   for(var n in nodes) {
          //     if (n.selected) {
          //       if (n.group != null && n.group.trim() != "") {
          //         crtGroup = n.group;
          //         break;
          //       }
          //     }
          //   }
          //   if (crtGroup == null){
          //     NodeGroup ng = NodeGroup();
          //     ScriptInfo.current.scriptData.nodeGroups.add(ng);
          //     crtGroup = ng.guid;
          //   }
          //   bool bModified = false ;
          //   for(var n in nodes) {
          //     if (n.selected) {
          //       if (n.group != crtGroup &&!bModified ){
          //         HistoryManager.scriptHistory.appendHistory();
          //         bModified = true;
          //       }
          //       n.group = crtGroup;
          //     }
          //   }
          // }
          // EventCenter.eventBus.fire(GlobalRefreshEvent());
        },
      ),
      textBtn("从组拆出",
        onPressed: (){
          ScriptInfo.unGroup();
          // if (ScriptInfo.current != null){
          //   bool bModified = false ;
          //   var nodes = ScriptInfo.current.scriptData.nodes;
          //   for(var n in nodes) {
          //     if (n.selected) {
          //       if (n.group != "" && !bModified){
          //         HistoryManager.scriptHistory.appendHistory();
          //       }
          //       n.group = "";
          //       bModified = true;
          //     }
          //   }
          // }
          // EventCenter.eventBus.fire(GlobalRefreshEvent());
        },
      ),
      // IconButton(
      //   padding: EdgeInsets.all(0),
      //   icon:Icon(MaterialCommunityIcons.group),
      //   iconSize: 36,
      //   tooltip: "合并组",
      //   color: Colors.indigo ,
      //   onPressed: (){
      //     EventCenter.eventBus.fire(GlobalRefreshEvent());
      //   },
      // ),


      textBtn("修改背景颜色",
        onPressed: (){
          setState(() {
            // raise the [showDialog] widget
            showDialog(
              context: context,
              builder:(context)=> AlertDialog(
                title: const Text('选择颜色!'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: Color(SSMainSetting.instance.canvasColor),
                    onColorChanged: (clr){
                      SSMainSetting.instance.canvasColor = clr.value;

                      EventCenter.eventBus.fire(GlobalRefreshEvent());
                    },
                    showLabel: true,
                    pickerAreaHeightPercent: 0.8,
                  ),

                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('确定'),
                    onPressed: () {
                      setState(() {
                        SSMainSetting.instance.save();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );

          });
        },
      ),
      // IconButton(
      //   padding: EdgeInsets.all(0),
      //   icon:Icon(MaterialCommunityIcons.help_box),
      //   iconSize: 36,
      //   tooltip: "Help",
      //   color: GlobalBoard.showDescription? Colors.red : Colors.grey,
      //   onPressed: (){
      //     if (GlobalBoard.showDescription == null)GlobalBoard.showDescription=false;
      //     GlobalBoard.showDescription = !GlobalBoard.showDescription;
      //
      //     // if (GlobalBoard.showDescription){
      //     //   ScriptInfo.current.helpAll();
      //     // }
      //     // else{
      //     //   ScriptInfo.current.unHelpAll();
      //     // }
      //
      //     EventCenter.eventBus.fire(GlobalRefreshEvent());
      //   },
      // ),
      // SizedBox(width: 16,),
      // Container(
      //   width: 200,
      //   height: 36,
      //   padding: EdgeInsets.fromLTRB(4, 0, 4, 4),
      //   color: CommonUtil.alphaColor(Colors.indigo , 32),
      //   alignment: Alignment.bottomCenter,
      //   child: TextField(
      //     onChanged: (v){
      //       searchVar = v;
      //     },
      //   ),
      // ),

      // IconButton(
      //   padding: EdgeInsets.all(0),
      //   icon:Icon(MaterialCommunityIcons.file_find),
      //   iconSize: 36,
      //   tooltip: "查找",
      //   color: Colors.indigo,
      //   onPressed: (){
      //     if (searchVar == null || searchVar.isEmpty){
      //       BotToast.showText(text: "请输入查找字串" , contentColor: Colors.redAccent);
      //       return;
      //     }
      //
      //     foundNodes.clear();
      //     var lower = searchVar.toLowerCase();
      //     for(var n in ScriptInfo.current.scriptData.nodes){
      //       if (n.name.toLowerCase().indexOf(lower) >=0 || n.alias.toLowerCase().indexOf(lower) >=0){
      //         foundNodes.add(n);
      //         continue;
      //       }
      //       var nt = n.getNodeStructType();
      //       if (nt.name.toLowerCase().indexOf(lower) >=0 || nt.alias.toLowerCase().indexOf(lower) >=0){
      //         foundNodes.add(n);
      //         continue;
      //       }
      //     }
      //
      //
      //
      //     if (foundNodes.length <= 0){
      //       BotToast.showText(text: "没有符合条件的结点");
      //     }
      //     else{
      //       foundIndex = 0;
      //       var n = foundNodes[0];
      //       ZoomState.current.focusPosition(n.x,n.y);
      //       EventCenter.eventBus.fire(GlobalRefreshEvent());
      //     }
      //   },
      // ),



    ];



    // if (foundNodes.length > 1){
    //   var left = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon:Icon(MaterialCommunityIcons.arrow_left_bold_box),
    //     iconSize: 36,
    //     tooltip: "前一个",
    //     color: Colors.indigo ,
    //     onPressed: (){
    //       foundIndex = (foundIndex -1 +foundNodes.length)%foundNodes.length;
    //       if (foundIndex <=0){
    //         BotToast.showText(text: "到达最前结点");
    //       }
    //       var n = foundNodes[foundIndex];
    //       ZoomState.current.focusPosition(n.x,n.y);
    //       EventCenter.eventBus.fire(GlobalRefreshEvent());
    //     },
    //   );
    //   commands.add(left);
    //
    //   var right = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon:Icon(MaterialCommunityIcons.arrow_right_bold_box),
    //     iconSize: 36,
    //     tooltip: "后一个",
    //     color: Colors.indigo ,
    //     onPressed: (){
    //       foundIndex = (foundIndex +1)%foundNodes.length;
    //       if (foundIndex >=foundNodes.length-1){
    //         BotToast.showText(text: "到达最后结点");
    //       }
    //       var n = foundNodes[foundIndex];
    //       ZoomState.current.focusPosition(n.x,n.y);
    //       EventCenter.eventBus.fire(GlobalRefreshEvent());
    //     },
    //   );
    //   commands.add(right);
    //
    //
    //
    //
    // }
    // if (ScriptInfo.current!=null) {
    //   var alphaParamLine = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon: Icon(MaterialCommunityIcons.alpha_a_circle, color: StateScriptNode.alphaParamLineColor?Colors.indigo:Colors.grey),
    //     tooltip: "透明化参数连接线",
    //     iconSize: 36,
    //     onPressed: () {
    //       setState(() {
    //         StateScriptNode.alphaParamLineColor = !StateScriptNode.alphaParamLineColor;
    //       });
    //
    //     },
    //   );
    //   commands.add(alphaParamLine);
    // }
    // commands.add(SizedBox(width: 80,));
    // 721 remove
    // if (ScriptInfo.current!=null) {
    //   var sendAll2Unity = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon: Icon(MaterialCommunityIcons.unity, color: Colors.indigo),
    //     tooltip: "在Unity中定位",
    //     iconSize: 36,
    //     onPressed: () {
    //       PackSolver.clearTransObjects();
    //       ObjInfos infos = ScriptInfo.current.scriptData.getAllTransformInfos();
    //       infos.guid = ScriptInfo.current.guid;
    //       // PackSolver.registerTransitionObjects(infos.objs);
    //       Transport.instance.sendUdpData(OPackType.O2U_FullObjects, infos);
    //       BotToast.showText(text: "已发送");
    //     },
    //   );
    //   commands.add(sendAll2Unity);
    // }
    // if (ScriptInfo.current != null) {
    //   var sendAll2Unity = IconButton(
    //     padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
    //     icon: Icon(AntDesign.flag, color: Colors.indigo),
    //     tooltip: "重建变量guid",
    //     iconSize: 30,
    //     onPressed: () {
    //
    //       ScriptInfo.current.scriptData.fullScriptsFields.forEach((key, sf) {
    //         sf.guid = Uuid().v4();
    //       });
    //
    //       // for(var sf in ScriptInfo.current.scriptData.scriptFields){
    //       //   sf.guid = Uuid().v4();
    //       // }
    //       BotToast.showText(text: "完成");
    //     },
    //   );
    //   commands.add(sendAll2Unity);
    // }

    // if (ScriptInfo.current!=null) {
    //   var sendAll2Unity = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon: Icon(MaterialCommunityIcons.transit_connection_variant, color: Colors.indigo),
    //     tooltip: "refresh connection guid",
    //     iconSize: 36,
    //     onPressed: () {
    //       ScriptInfo.current.scriptData.replaceConnectGuid();
    //       BotToast.showText(text: "链接guid已全部刷新");
    //     },
    //   );
    //   commands.add(sendAll2Unity);
    // }
    // var debug = IconButton(
    //   padding: EdgeInsets.all(0),
    //   icon:Icon(RunSession.instance.isRunning?MaterialCommunityIcons.stop_circle:MaterialCommunityIcons.bug , color: RunSession.instance.isRunning? Colors.redAccent : Colors.green),
    //   tooltip: RunSession.instance.isRunning?"停止 debug":"debug",
    //   iconSize: 36,
    //   onPressed: () async {
    //
    //     if (RunSession.instance.isRunning){
    //       RunSession.instance.stop();
    //     }
    //     else{
    //       CommonUtil.showLoading(context);
    //       await Future.delayed(Duration(milliseconds: 1000));
    //       await saveAndExport();
    //       await RunSession.instance.start();
    //       Navigator.pop(context);
    //     }
    //
    //     EventCenter.eventBus.fire(GlobalRefreshEvent());
    //   },
    // );
    // commands.add(debug);



    if (RunSession.instance.isRunning){
      var isEdt = textBtn(RunSession.instance.isEditorMode ? "退出编辑模式" : "进入编辑模式",
        color: RunSession.instance.isEditorMode?Colors.redAccent : Colors.grey,
        onPressed: () {
          RunSession.instance.isEditorMode = !RunSession.instance.isEditorMode;
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        },
      );
      commands.add(isEdt);

      // if (RunSession.instance.isEditorMode){

    }
    {
      var refresh = textBtn("聚焦当前脚本",
        onPressed: () {
          // setState(() {
          //   ScriptInfo.current.debugFocus = !(ScriptInfo.current.debugFocus??false);
          // });

          RunSession.instance.sendDebugInfoData();
          BotToast.showText(text:"Debug信息已发送给Unity",contentColor: Colors.green);
          // if (!RunSession.instance.remoteIsPlaying){
          //   BotToast.showText(text: "Unity 没有处于运行状态",contentColor: Colors.red);
          //   return ;
          // }

          // RunSession.instance.sendRuntimeRefreshScriptData(ScriptInfo.current.guid.hashCode, ScriptInfo.current.scriptData);
          // BotToast.showText(text: ,contentColor: Colors.green);
        },
      );
      commands.add(refresh);
    }

    // commands.add(SizedBox(width:16));
    {
      var refresh = textBtn("取消聚焦",
        onPressed: () {
          // setState(() {
          //   ScriptInfo.current.debugFocus = !(ScriptInfo.current.debugFocus??false);
          // });

          RunSession.instance.sendEmptyDebugInfoData();
          BotToast.showText(text:"取消信息已发送给Unity",contentColor: Colors.green);
          // if (!RunSession.instance.remoteIsPlaying){
          //   BotToast.showText(text: "Unity 没有处于运行状态",contentColor: Colors.red);
          //   return ;
          // }

          // RunSession.instance.sendRuntimeRefreshScriptData(ScriptInfo.current.guid.hashCode, ScriptInfo.current.scriptData);
          // BotToast.showText(text: ,contentColor: Colors.green);
        },
      );
      commands.add(refresh);
    }

    {
      var refresh = textBtn(RunSession.instance.isSaveRunningResult? "保留聚焦":"清除聚焦",
        color: RunSession.instance.isSaveRunningResult?Colors.redAccent: Colors.grey,
        onPressed: () {
          setState(() {
            RunSession.instance.isSaveRunningResult = !RunSession.instance.isSaveRunningResult;
            if(!RunSession.instance.isSaveRunningResult)
              RunSession.instance.clear();
          });
        },
      );
      commands.add(refresh);
    }

    {
      var refresh = textBtn(RunSession.instance.isBreakPointActive? "关闭断点":"激活断点",
        color: RunSession.instance.isBreakPointActive?Colors.redAccent: Colors.grey,
        onPressed: () {
          setState(() {
            RunSession.instance.isBreakPointActive = !(RunSession.instance.isBreakPointActive??false);
            RunSession.instance.sendActiveBreakPoint(RunSession.instance.isBreakPointActive);

            RunSession.instance.isFocusFrameMode = false;
            RunSession.instance.sendFrameMode(RunSession.instance.isFocusFrameMode);
          });
        },
      );
      commands.add(refresh);
    }

    {
      var refresh = textBtn(RunSession.instance.isStepMode? "关闭单步模式":"打开单步模式",
        color: RunSession.instance.isStepMode?Colors.redAccent: Colors.grey,
        onPressed: () {
          setState(() {
            RunSession.instance.isStepMode = !(RunSession.instance.isStepMode??false);
            RunSession.instance.sendStepMode(RunSession.instance.isStepMode);
            if (RunSession.instance.isStepMode){
              RunSession.instance.isBreakPointActive = true;
              RunSession.instance.sendActiveBreakPoint(RunSession.instance.isBreakPointActive);
              RunSession.instance.isFocusFrameMode = false;
              RunSession.instance.sendFrameMode(RunSession.instance.isFocusFrameMode);
            }
          });
        },
      );
      commands.add(refresh);
    }


    if (ScriptInfo.current.hasTimelineNodes())
    {
      var refresh = textBtn(RunSession.instance.isFocusFrameMode? "关闭定位帧模式":"打开定位帧模式",
        color: RunSession.instance.isFocusFrameMode?Colors.redAccent: Colors.grey,
        onPressed: () {
          setState(() {
            RunSession.instance.isFocusFrameMode = !(RunSession.instance.isFocusFrameMode??false);

            if (RunSession.instance.isFocusFrameMode){
              RunSession.instance.isBreakPointActive = false;
              RunSession.instance.isStepMode = false;
              RunSession.instance.sendActiveBreakPoint(RunSession.instance.isBreakPointActive);
              RunSession.instance.sendStepMode(RunSession.instance.isStepMode);
            }
            RunSession.instance.sendFrameMode(RunSession.instance.isFocusFrameMode);
          });
        },
      );
      commands.add(refresh);
    }

    // {
    //   var refresh = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon:Icon(MaterialCommunityIcons.walk),
    //     tooltip: "单步执行",
    //     color: ScriptInfo.current.stepDebug??false?Colors.green: Colors.grey,
    //     iconSize: 36,
    //     onPressed: () {
    //       setState(() {
    //         ScriptInfo.current.stepDebug = !(ScriptInfo.current.stepDebug??false);
    //       });
    //
    //       RunSession.instance.sendDebugInfoData();
    //       BotToast.showText(text:"Debug信息已发送给Unity",contentColor: Colors.green);
    //     },
    //   );
    //   commands.add(refresh);
    // }

    {
      var refresh = textBtn("清除所有断点",
        onPressed: () {
          // setState(() {
          //   for(var si in StateScriptProject.instance.scripts){
          //     si.debugFocus = false;
          //     si.stepDebug = false;
          //   }
          // });
          // if (!RunSession.instance.remoteIsPlaying){
          //   BotToast.showText(text: "Unity 没有处于运行状态",contentColor: Colors.red);
          //   return ;
          // }
          StateScriptProject.instance.clearBreakPoints();
          RunSession.instance.sendClearBreakPoint();
          EventCenter.eventBus.fire(GlobalRefreshEvent());
          BotToast.showText(text:"清理信息已发送给Unity",contentColor: Colors.green);
        },
      );
      commands.add(refresh);
    }

    {// if (RunSession.instance.remoteIsPlaying){
      // 「变量视图」按钮已按要求去除
    }

    // if (RunSession.instance.remoteIsPlaying){
    //   var refresh = IconButton(
    //     padding: EdgeInsets.all(0),
    //     icon:Icon( MaterialCommunityIcons.pause ),
    //     tooltip: RunSession.instance.inStepping?"取消单步执行":"单步执行",
    //     color: RunSession.instance.inStepping??false?Colors.red: Colors.grey,
    //     iconSize: 36,
    //     onPressed: () {
    //       // setState(() {
    //       //   ScriptInfo.current.stepDebug = !(ScriptInfo.current.stepDebug??false);
    //       // });
    //
    //       RunSession.instance.sendDebugMode(!RunSession.instance.inStepping);
    //       BotToast.showText(text:"Debug信息已发送给Unity",contentColor: Colors.green);
    //
    //       // if (!RunSession.instance.remoteIsPlaying){
    //       //   BotToast.showText(text: "Unity 没有处于运行状态",contentColor: Colors.red);
    //       //   return ;
    //       // }
    //
    //       // RunSession.instance.sendRuntimeRefreshScriptData(ScriptInfo.current.guid.hashCode, ScriptInfo.current.scriptData);
    //       // BotToast.showText(text: ,contentColor: Colors.green);
    //     },
    //   );
    //   commands.add(refresh);
    // }

    if (RunSession.instance.remoteIsPlaying && RunSession.instance.inStepping){
      {
        var refresh = textBtn("继续执行",
          onPressed: () {
            if (RunSession.instance.inStepping) {
              RunSession.instance.sendDebugForward();
              BotToast.showText(text: "step over", contentColor: Colors.green);
            }
          },
        );
        commands.add(refresh);
      }

      {
        var refresh = textBtn("停止脚本并继续执行",
          onPressed: () {
            if (RunSession.instance.inStepping) {
              RunSession.instance.sendDebugForwardAndStop();
              BotToast.showText(text: "step over", contentColor: Colors.green);
            }
          },
        );
        commands.add(refresh);
      }
    }

    // 顶部第一行让给主工具按钮行，命令按钮网格整体下移一行：
    // 从「脚本查找」「锁定中心」（第二行）右侧开始，按列填充、往右排列：
    // 上排 1 3 5 7 9 ... 与「脚本查找」「锁定中心」对齐，下排 2 4 6 8 10 ...
    var gridCols = List<Widget>();
    for (int i = 0 ; i < commands.length ; i += 2){
      gridCols.add(Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commands[i],
          const SizedBox(height: 6),
          i + 1 < commands.length ? commands[i + 1] : const SizedBox(width: 0, height: 0),
        ],
      ));
      gridCols.add(const SizedBox(width: 8));
    }
    var commandWrap = Positioned(
      left: 184,
      top: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: gridCols,
      ),
    );

    return commandWrap;
  }
}