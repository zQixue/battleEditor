//@dart=2.11
import 'dart:async';
import 'dart:convert';
import 'dart:math';
 

import 'package:bot_toast/bot_toast.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';

import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/NodeGroup.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/ScriptModule.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/action_connection_line.dart';
import 'package:battlepus/StateScript/canvas_grid.dart';
import 'package:battlepus/StateScript/connect_line_commands.dart';
import 'package:battlepus/StateScript/connect_line_view.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/group_flag_names_view.dart';
import 'package:battlepus/StateScript/left_side_bar.dart';
import 'package:battlepus/StateScript/log_view.dart';
import 'package:battlepus/StateScript/module_panel.dart';
import 'package:battlepus/StateScript/multi_dragging_view.dart';
import 'package:battlepus/StateScript/node_field_editor_view.dart';
import 'package:battlepus/StateScript/node_group_view.dart';
import 'package:battlepus/StateScript/node_info_view.dart';
import 'package:battlepus/StateScript/node_selector.dart';
import 'package:battlepus/StateScript/right_tool_bar.dart';
import 'package:battlepus/StateScript/s_o_param_view.dart';
import 'package:battlepus/StateScript/s_o_port_view.dart';
import 'package:battlepus/StateScript/module_interface_view.dart';
import 'package:battlepus/StateScript/script_var_runtime_view.dart';
import 'package:battlepus/StateScript/state_script_node_view.dart';
import 'package:battlepus/StateScript/timeline_cursor.dart';
import 'package:battlepus/StateScript/timeline_left_arrow.dart';
import 'package:battlepus/StateScript/timeline_right_arrow.dart';
import 'package:battlepus/StateScript/timelines_viewer.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/ClipBoard.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart' as EVC;
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:theme_provider/theme_provider.dart';
// import 'package:battlepus/protos/transition.pb.dart';
import 'package:uuid/uuid.dart';
class SSCanvasView extends StatefulWidget {
  SSCanvasView({Key key}) : super(
      key: key);

  @override
  SSCanvasViewState createState() =>
      SSCanvasViewState(
      );
}

class SSCanvasViewState extends State<SSCanvasView> {

  StreamSubscription<EVC.GlobalRefreshEvent> _lis3;
  StreamSubscription<EVC.KeyEvent> _lis4;
  StreamSubscription<EVC.FocusCanvasEvent> _lis5;
  StreamSubscription<EVC.NodeRefreshDragOrderEvent> _lis6;

  FocusNode _focusNode;

  double _lastScale;

  bool steppingFlash = false;

  Offset hoverPos;
  //
  // bool _controlDown = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis5?.cancel();

    _lis3?.cancel();
    _lis4?.cancel();
    _lis6?.cancel();
    _focusNode?.dispose();
  }


  @override
  void initState() {

//    BehaviacTree.current = BehaviacTree();
//    StateScript.current = StateScript();

    // _lis = EventCenter.eventBus.on<RefreshConnectLineEvent>().listen((event) {
    //   setState(() {
    //     // print("---- refresh connect lines");
    //   });
    // });



    FocusManager.instance.addListener(() {
      // print(FocusManager.instance.primaryFocus.toString());
      if (FocusManager.instance.primaryFocus is FocusScopeNode){
        _focusNode.requestFocus();
      }
    });
    _lis5 = EVC.EventCenter.eventBus.on<EVC.FocusCanvasEvent>().listen((event) {
      _focusNode.requestFocus();
    });
    _lis3 = EVC.EventCenter.eventBus.on<EVC.GlobalRefreshEvent>().listen((event) {
      setState(() {
          if(ScriptInfo.current != null){
          bool sc = ScriptInfo.current.scriptData.nodeMap.length > 300;
          if(sc){
             BotToast.showText(text: "当前节点数量超过300", contentColor: Colors.red ,align: const Alignment(0, 0.4),duration: Duration(seconds: 3));
          }
        } 
      });
    });

    _lis6 = EVC.EventCenter.eventBus.on<EVC.NodeRefreshDragOrderEvent>().listen((event) {
      setState(() {

      });
    });

    _lis4 = EVC.EventCenter.eventBus.on<EVC.KeyEvent>().listen((event) async {


      if (FocusManager.instance.primaryFocus != null && FocusManager.instance.primaryFocus != _focusNode){
        // print("hahahaha");
        return;
      }
      // if (!_focusNode.hasPrimaryFocus) return;
      if (event.event.isAltPressed && event.key == LogicalKeyboardKey.arrowRight) {
        // print("equal");
        var step = !event.event.isShiftPressed?10.0:1.0;
        sizeSelected(step);
      }
      if (event.event.isAltPressed && event.key == LogicalKeyboardKey.arrowLeft) {
        // print("minus");
        var step = !event.event.isShiftPressed?-10.0:-1.0;
        sizeSelected(step);
      }

      if (event.event.isControlPressed && event.key == LogicalKeyboardKey.keyS) {

        if (StateScriptProject.instance.useObjectTable) {
          if (ObjectTableProject.isValid()) {
            if (!await BattlePusGlobal.isSubWindowExists("/ObjectTableMain")) {
              ObjectTableProject.instance.save(context: context);
            }
            ObjectTableProject.instance.export();
          }
        }

        StateScriptProject.instance.saveAllScript();
        StateScriptProject.instance.save();

        BotToast.showText(text: "保存完毕" , contentColor: Colors.green);
      }

      if (event.event.isControlPressed && event.key == LogicalKeyboardKey.keyH) {
        if (GlobalBoard.showDescription == null)GlobalBoard.showDescription=false;
        GlobalBoard.showDescription = !GlobalBoard.showDescription;

        if (GlobalBoard.showDescription){
          ScriptInfo.current.editAll();
        }
        else{
          ScriptInfo.current.uneditAll();
        }

        EVC.EventCenter.eventBus.fire(EVC.GlobalRefreshEvent());
      }
      if ((event.event.isControlPressed && event.event.isShiftPressed && event.key == LogicalKeyboardKey.keyA)|| event.key == LogicalKeyboardKey.f4) {
        ScriptInfo.current.unselectAll();
        setState(() {

        });
      }
      else if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyA) || event.key == LogicalKeyboardKey.f3) {
        ScriptInfo.current.selectAll();
        setState(() {

        });
      }
      if (event.key == LogicalKeyboardKey.escape) {
        ScriptInfo.current.unselectAll();
        setState(() {

        });
      }
      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyC)|| event.key == LogicalKeyboardKey.f5) {
        doCopy();
      }

      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyV)|| event.key == LogicalKeyboardKey.f6) {

        doPaste();
      }

      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyD)|| event.key == LogicalKeyboardKey.f7) {
        doCopy();
        doPaste();
      }

      if (event.key == LogicalKeyboardKey.f8 || (event.event.isControlPressed && event.event.isKeyPressed(LogicalKeyboardKey.f8))) {
        // print("f8");
        if (RunSession.instance.remoteIsPlaying&&RunSession.instance.inStepping){
          RunSession.instance.sendDebugForward();

          setState(() {
            steppingFlash = true;

          });
          // BotToast.showText(text:"step over",contentColor: Colors.green);
        }
      }

      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.arrowDown)) {
        //向下移动
        var step = event.event.isShiftPressed?1.0:5.0;
        moveSelected(0,step);
      }
      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.arrowUp)) {
        //向上移动
        var step = event.event.isShiftPressed?1.0:5.0;
        moveSelected(0,-step);
      }
      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.arrowLeft)) {
        //向左移动
        var step = event.event.isShiftPressed?1.0:5.0;
        moveSelected(-step , 0);
      }
      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.arrowRight)) {
        //向右移动
        var step = event.event.isShiftPressed?1.0:5.0;
        moveSelected(step , 0);
      }

      if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyB)) {
        if (ScriptInfo.current.currentPos != null){
          ScriptInfo.current.unselectAll();

          ZoomState.current.focusPosition(ScriptInfo.current.currentPos.dx,ScriptInfo.current.currentPos.dy);
          EVC.EventCenter.eventBus.fire(EVC.GlobalRefreshEvent());
          ScriptInfo.current.currentPos = null;
        }
      }
      if ((event.event.isControlPressed && event.event.isShiftPressed && event.key == LogicalKeyboardKey.keyZ)) {
        // setState(() {
        HistoryManager.scriptHistory.redo();
        // });
      }
      else if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyZ)) {
        // setState(() {
        HistoryManager.scriptHistory.undo();
        // });
      }

      if ((event.event.isControlPressed && event.event.isShiftPressed && event.key == LogicalKeyboardKey.keyG)) {
        // setState(() {
        ScriptInfo.unGroup();
        // });
      }
      else if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyG)) {
        // setState(() {
        ScriptInfo.doGroup();
        // });
      }

      if (event.key == LogicalKeyboardKey.delete) {
//        print("del");
        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
          setState(() {
            // scriptHistory.appendHistory();
            delete();
            EVC.EventCenter.eventBus.fire(EVC.GlobalRefreshEvent());
          });
        });
        KeyEventCenter.clearKey(LogicalKeyboardKey.delete);
      }
    });

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print("canvas lost focus");
      }

    });

    // TODO: implement initState
    super.initState();
  }
  void checkSetHistory(){

    if (ScriptInfo.current == null) return ;
    if (ScriptInfo.current.scriptData == null) return ;

    var record = (){
      var obj = ScriptInfo.current.getScriptData();
      if (obj is StateScript){
        JsonEncoder encoder = new JsonEncoder();
        String json = encoder.convert(obj);
        var full = ZoomState.current.getValues();
        full["data"] = json;
        return full;
      }
    };
    var undo = (m){
      if (m != null){
        JsonDecoder decoder = new JsonDecoder();
        var obj = StateScript.fromJson(decoder.convert(m["data"]));
        if (obj != null) {
          setState(() {
            obj.loadSubScripts(ScriptInfo.current.guid);
            ScriptInfo.current.scriptData.initConnectionCount();
            obj.buildScriptGroupNodes();
            ScriptInfo.current.setScriptData(obj);
            obj.initConnectionCount();
          });
        }

        ZoomState.current.setValues(m);
      }
    };
    if (ScriptInfo.current.history != null){
      ScriptInfo.current.history.setCallback(record , undo );
      HistoryManager.scriptHistory = ScriptInfo.current.history  ;
    }
    else{
      HistoryManager.scriptHistory = HistoryManager(record , undo );
      ScriptInfo.current.history  = HistoryManager.scriptHistory;
    }
  }
  void delete(){
//    print("delete");
    if (ScriptInfo.current == null) return ;

    HistoryManager.scriptHistory.appendHistory();

    var nodes = ScriptInfo.current.scriptData.nodes;
    ClipBoard.clear();
    for(int i = nodes.length-1 ; i>=0 ; --i){
      var n = nodes[i];
      // 721 remove
      if (n.selected) {
        var info = SimpleNode()..guid = n.guid;
        Transport.instance.sendUdpData(OPackType.O2U_MAP_DeleteObject, info);
        ScriptInfo.current.scriptData.deleteNode(n);
      }

      for(int j = n.soports.length-1 ; j>=0 ; --j){
        var p = n.soports[j];
        if (p.selected){
          n.soports.removeAt(j);
        }
      }

      for(int j = n.sops.length-1 ; j>=0 ; --j){
        var p = n.sops[j];
        if (p.selected){
          n.sops.removeAt(j);
        }
      }
    }
  }

  static StateScript copyScript ;
  void doCopy(){
    //        setState(() {
    print("ctrl - c");
    if (ScriptInfo.current == null) return ;
    var nodes = ScriptInfo.current.scriptData.nodes;

    ClipBoard.clear();
    copyScript = ScriptInfo.current.scriptData;
    for(var n in nodes){
      if (n.selected) {
        ClipBoard.copyJsonObj("StateScriptNode", n);
      }
    }
    BotToast.showText(text: "已复制" , contentColor: Colors.green);
//        });
  }

  void doPaste(){
    setState(() {
      print("ctrl - v");

      if (ScriptInfo.current == null) return ;
      HistoryManager.scriptHistory.appendHistory();

      var nodeJsons = ClipBoard.getJsonObj("StateScriptNode");//ScriptInfo.current.scriptData.nodes;
//          ClipBoard.clear();

      if (nodeJsons.length>=1){
        ScriptInfo.current.unselectAll();
      }
      Map<String,StateScriptNode> ori2news = Map<String,StateScriptNode>();
      Map<String,bool> oriGuids = Map<String,bool>();
      Offset center = Offset(0,0);
      StateScriptProject.cancelWatchProject();
      for(var n in nodeJsons){
//            ClipBoard.copyJsonObj("StateScriptNode", n.toJson());
        Map userMap = jsonDecode(n);
        var newn = StateScriptNode.fromJson(userMap);
        // if (newn is SSAgentFunction){
        //   newn.fieldValues.clear();
        // }
        var off = calcLocalPosition(hoverPos??Offset(newn.x + 32,newn.y + 32));
        off = fixPosition(off);

        // newn.x = off.dx;
        // newn.y = off.dy;

        center += Offset(newn.x,newn.y);
        newn.sops.clear();
        newn.soports.clear();
        newn.moduleInterfaces.clear();
        newn.dynamicFieldInParams.clear();
        newn.dynamicFieldOutPorts.clear();
        oriGuids[newn.guid] = true;
        ori2news[newn.guid] = newn;
        newn.guid = Uuid().v4();
        newn.selected = true;


        // ScriptInfo.current.scriptData.buildScriptGroupNodes();
        newn.cloneAgentFunctions(ScriptInfo.current);
        // var tp = newn.getNodeStructType();
        // var funcFields = tp.getFieldsByTypeGuid("___agentfunction___");
        // if (funcFields != null){
        //   for(var funcField in funcFields) {
        //     var fv = newn.fieldValues[funcField.guid]?.value;
        //     if (fv != null) {
        //       newn.fieldValues[funcField.guid].value = "";
        //       var func = StateScriptProject.instance.getFunction(fv);
        //       if (func != null) {
        //         var newfunc = func.clone();
        //         newfunc.rebuildGuid();
        //         print(newfunc.guid);
        //         StateScriptProject.instance.addFunction(newfunc);
        //         newn.fieldValues[funcField.guid].value = newfunc.guid;
        //       }
        //       // StateScriptProject.instance.functions.removeWhere((element) => element.guid == fv);
        //     }
        //   }
        // }

        ScriptInfo.current.scriptData.addNode(newn);

        SyncNodeData info = newn.getSyncData();
        // PackSolver.registerTransitionObject(newn);
        Transport.instance.sendUdpData(OPackType.O2U_MAP_SyncObject, info);

      }

      StateScriptProject.doWatchProject();

      if (ori2news.length >0) {
        center = center / ori2news.length.toDouble();
        var n0 = ori2news.values.toList()[0];
        var off = calcLocalPosition(hoverPos??Offset(n0.x + 32,n0.y + 32));
        off = fixPosition(off);
        Map<String,NodeGroup> groupMaps = Map<String,NodeGroup>();
        ScriptInfo.current.scriptData.nodeGroups?.forEach((element) { groupMaps[element.guid] = element; });

        for(var n in ori2news.values.toList()){
          n.x =  n.x - center.dx  + off.dx;
          n.y =  n.y - center.dy  + off.dy;
          var ng = groupMaps[n.group??""];
          if (ng != null){
            var rect = ng.getRect();
            if (n.x < rect.left || n.x > rect.right || n.y< rect.top || n.y > rect.bottom){
              n.group = null;
            }
          }
        }
        List<PortConnection> cons = List<PortConnection>();
        if (copyScript != null){
          for(var con in copyScript.portConnections){
            if (oriGuids[con.outNodeGuid] != null && oriGuids[con.inNodeGuid] != null){
              Map userMap = con.toJson();
              var newCon = PortConnection.fromJson(userMap);
              newCon.outNodeGuid = ori2news[con.outNodeGuid].guid;
              newCon.inNodeGuid = ori2news[con.inNodeGuid].guid;
              newCon.sopGuid = "";
              // ScriptInfo.current.scriptData.addPortConnection(newCon);
              cons.add(newCon);
            }
          }
        }

        for(var c in cons){
          ScriptInfo.current.scriptData.addPortConnection(c , recordHistory: false);
        }

        List<ParamConnection> pcons = List<ParamConnection>();
        if (copyScript != null){
          for(var con in copyScript.paramConnections){
            if (oriGuids[con.outNodeGuid] != null && oriGuids[con.inNodeGuid] != null){
              Map userMap = con.toJson();
              var newCon = ParamConnection.fromJson(userMap);
              newCon.outNodeGuid = ori2news[con.outNodeGuid].guid;
              newCon.inNodeGuid = ori2news[con.inNodeGuid].guid;
              newCon.sopGuid = "";
              // ScriptInfo.current.scriptData.addParamConnection(newCon);
              pcons.add(newCon);
            }
          }
        }

        for(var c in pcons){
          ScriptInfo.current.scriptData.addParamConnection(c, recordHistory: false);
        }

      }



      ScriptInfo.current.scriptData.buildScriptGroupNodes();

    });
    // BotToast.showText(text: "已粘贴" , contentColor: Colors.green);
  }
  void sizeSelected(double offX){
    if (ScriptInfo.current == null) return ;
    var nodes = ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){

      if (n.selected) {
        var ns = n.getNodeStructType();
        if (ns == null) continue;

        // if (ns.isTimelineNode){
        //   n.tlWidth += offX;
        //   if (n.tlWidth<=0) n.tlWidth = 1;
        //   n.tlWidth = n.tlWidth.toInt().toDouble();
        //   EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n);
        //   EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        // }
        // else{
        {
          ns.width += offX;
          if (ns.width<=0) ns.width = 1;
          ns.width = ns.width.toInt().toDouble();
          EVC.EventCenter.eventBus.fire(EVC.NodeRefreshWithTargetEvent()..nodeType = ns);
          EVC.EventCenter.eventBus.fire(EVC.RefreshAllConnectLineEvent______());
        }
      }

    }
    // widget.node.x = widget.node.downStorePos.dx + off.dx;
    // widget.node.y = widget.node.downStorePos.dy + off.dy;
    EVC.EventCenter.eventBus.fire(EVC.RefreshConnectCommandEvent());
  }
  void moveSelected(double offX , double offY){
    if (ScriptInfo.current == null) return ;
    var nodes = ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){
      if (n.selected) {
        n.x += offX;
        n.y += offY;
        EVC.EventCenter.eventBus.fire(EVC.NodeRefreshWithTargetEvent()..node = n);
      }
      for(var sop in n.soports){
        if (sop.selected){
          sop.x += offX;
          sop.y += offY;
          EVC.EventCenter.eventBus.fire(EVC.SubstituteObjectRefreshEvent()..object = sop);
        }
      }
      for(var sop in n.sops){
        if (sop.selected){
          sop.x += offX;
          sop.y += offY;
          EVC.EventCenter.eventBus.fire(EVC.SubstituteObjectRefreshEvent()..object = sop);
        }
      }
    }
    // widget.node.x = widget.node.downStorePos.dx + off.dx;
    // widget.node.y = widget.node.downStorePos.dy + off.dy;
    EVC.EventCenter.eventBus.fire(EVC.RefreshAllConnectLineEvent______());
    EVC.EventCenter.eventBus.fire(EVC.RefreshConnectCommandEvent());
  }

  void blueSelcect(Rectangle<double> rect){
    if (ScriptInfo.current == null) return ;
    var nodes = ScriptInfo.current.scriptData.nodes;
    bool bAppend = KeyEventCenter.isControlPressed();
    for(var n in nodes){
      var dp = Point(n.x + n.getWidth()/2 , n.y + 16);
      var old = n.selected;
      n.selected = rect.containsPoint(dp) || (bAppend && n.selected);
      if (old!= n.selected) EVC.EventCenter.eventBus.fire(EVC.NodeRefreshWithTargetEvent()..node = n);

      for(var sop in n.soports){
        var dp = Point(sop.x - (sop.width??0)/2 , sop.y + 16);
        var old = sop.selected;
        sop.selected = rect.containsPoint(dp) || (bAppend && sop.selected);
        if (old!= n.selected) EVC.EventCenter.eventBus.fire(EVC.SubstituteObjectRefreshEvent()..object = sop);
      }
      for(var sop in n.sops){
        var dp = Point(sop.x - (sop.width??0)/2 , sop.y + 16);
        var old = sop.selected;
        sop.selected = rect.containsPoint(dp)|| (bAppend && sop.selected);
        if (old!= n.selected) EVC.EventCenter.eventBus.fire(EVC.SubstituteObjectRefreshEvent()..object = sop);
      }
    }
    // widget.node.x = widget.node.downStorePos.dx + off.dx;
    // widget.node.y = widget.node.downStorePos.dy + off.dy;
    EVC.EventCenter.eventBus.fire(EVC.RefreshConnectCommandEvent());
  }
  @override
  Widget build(BuildContext context) {

    print("repaint canvas");
    StateScriptNode.allModuleInterfaces.clear();
    if(ScriptInfo.current == null){

      return Center(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("尚未选择脚本"  , style: TextStyle(fontSize: 48 , color: Colors.grey),),
          SizedBox(height: 48,),
          IconButton(icon: Icon(MaterialCommunityIcons.file_document_box_multiple_outline , color: Colors.blue,),iconSize: 32, color: Colors.white, tooltip:"前往选择脚本",
            onPressed: (){
              var openScr = (){
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
              // if (StateScriptProject.currentSelectedModule == null){
              //   Navigator.pushNamed(context, "/SelectScriptModuleView").then((value){
              //     if (value != null) {
              //       StateScriptProject.currentSelectedModule = value;
              //       var key = "${GlobalBoard.getWorkingPath()}/currentSelectedModule";
              //       BattlePusGlobal.prefs.setString(key,value);
              //       openScr();
              //     }
              //   });
              //   return ;
              // }
              if (StateScriptProject.currentSelectedModule == null){
                if (StateScriptProject.instance?.scriptModules == null){
                  StateScriptProject.instance?.scriptModules = Map<String,ScriptModule>();
                }
                if (StateScriptProject.instance.scriptModules == null || StateScriptProject.instance.scriptModules.length<=0) {
                  StateScriptProject.currentSelectedModule = "";
                  openScr();
                }
                else {
                  Navigator.pushNamed(context, "/SelectScriptModuleView").then((value) {
                    if (value != null) {
                      StateScriptProject.currentSelectedModule = value;
                      var key = "${GlobalBoard.getWorkingPath()}/currentSelectedModule";
                      BattlePusGlobal.prefs.setString(key, value);
                      openScr();
                    }
                  });
                }
                return ;
              }
              openScr();

            },
          )
        ],
      ));
    }
//    RenderBox getBox = context.findRenderObject();
    checkSetHistory();
    var dragTarget = DragTarget<NodeStructData>(
      builder: onBuildDragTarget,

      onAcceptWithDetails: onAcceptWithDetails,
      onWillAccept: onWillAccept,
      onLeave: onLeave,
    );

      //Group层单独拆出来
    var dragGroupTarget = DragTarget<NodeStructData>(
      builder: onBuildDragGroupTarget,

      onAcceptWithDetails: onAcceptWithDetails,
      onWillAccept: onWillAccept,
      onLeave: onLeave,
    );


//    var dragTarget = getAllNodes();
    bool isStepping = RunSession.instance.inStepping && RunSession.instance.remoteIsPlaying;


    _focusNode.requestFocus();


    return LayoutBuilder(

      builder:(BuildContext context, BoxConstraints constraints){
//        print("build 2");
        var minScale = ZoomState.current != null && ZoomState.current.getScale()<0.4;
        checkTimelineMode();
        var zm = Zoom(
          onHover: (pos){
            // print(event);
            hoverPos = pos;
          },
          zoomList: [0.10,0.25, 0.50, 0.75, 1.0  , 1.5 , 2 , 2.5 , 3.0 , 3.5 , 4.0 , 5.0 , 6.0],
          initZoomindex: 4,
          width: SSDefines.canvasWidth,
          height: SSDefines.canvasHeight,
          initPosX:SSDefines.canvasZeroX ,
          initPosY:SSDefines.canvasZeroY ,
          onPointDown: (off){
            // print("left down : $off");

            var offLocal = calcLocalPosition(off);
            // print("left down : $off");

            if (off.dy<=180) {
              TimelineCursorInfo.posX = (offLocal.dx - SSDefines.canvasZeroX).floorToDouble();
            }
          },
          onBlueUpdate: (rect){
            blueSelcect(rect);
          },
          onRightPointDown:(off){
            if (ScriptInfo.current == null) return ;
            bool bAppend = KeyEventCenter.isControlPressed();
            if (!bAppend) {
              var count = ScriptInfo.current.unselectAll();
              EVC.EventCenter.eventBus.fire(EVC.NodeTypeListRefreshEvent()..bShow = false);
              // if (count>0) {
              //   setState(() {});
              // }
              EVC.EventCenter.eventBus.fire(EVC.RefreshConnectCommandEvent()..openedPortConnection = null..openChanged = true);
              EVC.EventCenter.eventBus.fire(EVC.RefreshAllConnectLineEvent______());
              EVC.EventCenter.eventBus.fire(EVC.PortClickEvent()..node = null);
            }


          },
          onRightPointUp: (pos){
            var tmpPos = Offset(pos.dx , pos.dy);
            tmpPos = calcLocalPosition(tmpPos);
            tmpPos = fixPosition(tmpPos);

            RenderBox getBox = context.findRenderObject();
            var local = getBox.globalToLocal(pos);

            EVC.EventCenter.eventBus.fire(EVC.NodeTypeListRefreshEvent()..bShow = true..x = tmpPos.dx ..y = tmpPos.dy .. showListX = local.dx ..showListY = local.dy);
          },
          onScaleUpdate: (scale,zoom){
            // print("aaaaa");
            EVC.EventCenter.eventBus.fire(EVC.LocationFlagEvent()..scale = scale);
            EVC.EventCenter.eventBus.fire(EVC.NodeTypeListRefreshEvent()..bShow = false);

            EVC.EventCenter.eventBus.fire(EVC.TimelineCursorRefresh());
            // if (_lastScale != null) {
            //   if (scale < 0.4 || (_lastScale ?? 0) < 0.4) {
            //     // setState(() {
            //     //
            //     // });
            //     EventCenter.eventBus.fire(LocationFlagEvent());
            //   }
            // }
            // _lastScale = scale;

          },
          scrollWeight: 11.0,
          canvasColor: (isStepping && !steppingFlash)?CommonUtil.changeColorLightness(Color(0xFF336633), 0.2): Color(SSMainSetting.instance.canvasColor),
          colorScrollBars: Colors.indigo,
//        onPositionUpdate: (position){
//            viewX=position.dx;
//            viewY=position.dy;
//            print("---- view pos : $viewX , $viewY , $viewZoom");
//        },
//        onScaleUpdate: (scale,zoom){
//            viewZoom =scale;
//            print("---- view pos : $viewX , $viewY , $viewZoom");
//        },

          child: GlobalBoard.showDescription == true?
          Center(child:Stack(
            children: [
              RepaintBoundary(child:IgnorePointer(
                child: CanvasGrid(
                  lineColor: Color.fromARGB(70, 200, 200, 200),
                  axisColor: Color(0x6F66FF66),
                  xStep: SSDefines.fixPowerX,yStep: SSDefines.fixPowerY,),
              )),

              if (!StateScriptProject.instance.lineLayerOnTop)
                RepaintBoundary(child:IgnorePointer(
                  child: ConnectLineView(),
                )),

              //先绘制Group
              RepaintBoundary(child: dragGroupTarget,),

              RepaintBoundary(child:dragTarget,),
              // dragTarget,
              RepaintBoundary(child:GroupFlagNamesView(script: ScriptInfo.current,scale : ZoomState.current?.getScale()??1),),
          
              ConnectLineCommands(graph: this,),
              RepaintBoundary(child:MultiDraggingView()),
              if (StateScriptNode.withTimelineNode??false)IgnorePointer(child:TimelinesViewer(width : constraints.maxWidth , height :constraints.maxHeight)),
              if (StateScriptNode.withTimelineNode??false)TimelineCursor(height: constraints.maxHeight,graph: this),

              if (StateScriptProject.instance.lineLayerOnTop)
                RepaintBoundary(child:IgnorePointer(
                  child: ConnectLineView(),
                )),
              // ContextMenuOverlay(
              //   // getTag : "main",
              //   blockPointer: false,
              //   // child: Container(),
              // ),
            ],
          )):
          Center(child:Stack(
            children: [

              RepaintBoundary(child:IgnorePointer(
                child: CanvasGrid(
                  lineColor: Color.fromARGB(70, 200, 200, 200),
                  axisColor: Color(0x6F66FF66),
                  xStep: SSDefines.fixPowerX,yStep: SSDefines.fixPowerY,),
              )),
              
              //先绘制Group
              RepaintBoundary(child: dragGroupTarget,),
              RepaintBoundary(child:dragTarget,),
              // dragTarget,


              RepaintBoundary(child:GroupFlagNamesView(script: ScriptInfo.current,scale : ZoomState.current?.getScale()??1),),
              //
          
              // ConnectLineView(),
              ConnectLineCommands(graph: this,),
              RepaintBoundary(child:MultiDraggingView()),
              if (StateScriptNode.withTimelineNode??false)IgnorePointer(child:TimelinesViewer(width : constraints.maxWidth , height :constraints.maxHeight)),
              if (StateScriptNode.withTimelineNode??false)TimelineCursor(height: constraints.maxHeight,graph: this),

              RepaintBoundary(child:IgnorePointer(
                child: ConnectLineView(),
              )),

              // HelpLine(),
              // getAllNodeHelps(),
              // ContextMenuOverlay(
              //   // getTag : "main",
              //   blockPointer: false,
              //   // child: Container(),
              // ),
            ],
          )),
        );

        steppingFlash = false;
        var mc = Container(
          padding: EdgeInsets.all(0),
          color: Colors.grey,
          child: zm,
        );
        return RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _handleKeyEvent,

          child:Stack(
            children: [
              mc,
              RightToolBar(),
              // Container(
              //   height: 80,
              //   // width: 800,
              //   color: Colors.white,
              //   child: RightToolBar(),
              // ),
              LeftSideBar(width : constraints.maxWidth , height :constraints.maxHeight, graph: this,),

              NodeSelector(key:UniqueKey(), containerWidth: constraints.maxWidth , containerHeight :constraints.maxHeight),

              // CanvasToolBar(width : constraints.maxWidth , height :constraints.maxHeight),
              // NodeIndicatorView(width : constraints.maxWidth , height :constraints.maxHeight),
              // 已按要求去除「定义参数」入口按钮，不再挂载参数定义面板
              // if (!RunSession.instance.remoteIsPlaying) ThemeConsumer(child :ScriptFieldsView(width : constraints.maxWidth , height :constraints.maxHeight , fields: ScriptInfo.current.scriptData.scriptFieldVars,)),
              if (RunSession.instance.remoteIsPlaying) ThemeConsumer(child :ScriptVarRuntimeView(width : constraints.maxWidth , height :constraints.maxHeight , visible: RunSession.instance.isShowVars)),
              ActionConnectionLine(),

              NodeInfoView(key:UniqueKey(), containerWidth: constraints.maxWidth , containerHeight :constraints.maxHeight),
              LogView(key:UniqueKey(), containerWidth: constraints.maxWidth , containerHeight :constraints.maxHeight),
              Positioned(bottom :0 , left :0 ,child: getScriptsTab()),

              ContextMenuOverlay(
                // getTag : "main",
                blockPointer: false,
                // child: Container(),
              ),
            ],
          ),
        );
      },
    );

  }

  Widget getScriptsTab(){

    // return WindowBase(
    //   windows: [
    //     Window(title: 'Segunda janela 1',),
    //     Window(title: 'Segunda janela 2',),
    //     Window(title: 'Segunda janela 3',),
    //     Window(title: 'Segunda janela 4',),
    //     Window(title: 'Segunda janela 5',),
    //     // Window(
    //     //     menuButtons: true,
    //     //     borderColor: Colors.yellow,
    //     //     child: ListView.builder...
    //     // ),
    //   ],
    // );
    List<Widget> wdgs = List<Widget>();
    // print(ScriptInfo.openedScripts);
    ScriptInfo.openedScripts.forEach((element) {
      if (element != null) {
        var name = element.name;
        var tab = ThemeCenter.area(
          padding: EdgeInsets.fromLTRB(10,0,10,0),
          panelColor: ScriptInfo.current == element ? CommonUtil.alphaColorD(Colors.greenAccent, 0.85) : Colors.black12,
          child: Row(
            children: [
              Text(name , style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: ScriptInfo.current == element ? Colors.black : Colors.grey),),
              if (!element.pinned) Padding(
                padding: EdgeInsets.only(left: 4),
                child: ThemeCenter.iconBtn(MaterialCommunityIcons.close_box,
                  color: Colors.redAccent,
                  width: 26,height: 26,
                  tooltip: "关闭",
                  onPressed: (){

                    if ((element.history?.undoList?.length??0)>0){
                      CommonUtil.confirm2(context, "关闭前是否保存修改内容?",
                        btn1: "保存",
                        btn2: "不保存",
                        btn3: "取消",
                        onResult1: (){
                          setState(() {
                            element.saveScript();
                            element.history.clear();

                            ScriptInfo.openedScripts.remove(element);
                            ScriptInfo.saveOpenedScriptToLocal();

                            if (ScriptInfo.openedScripts.length>0){
                              ScriptInfo.current = ScriptInfo.openedScripts.last;
                            }
                            else{
                              ScriptInfo.current = null;
                            }


                          });
                        },
                        onResult2: (){
                          setState(() {
                            element.history.clear();
                            ScriptInfo.openedScripts.remove(element);
                            ScriptInfo.saveOpenedScriptToLocal();

                            if (ScriptInfo.openedScripts.length>0){
                              ScriptInfo.current = ScriptInfo.openedScripts.last;
                            }
                            else{
                              ScriptInfo.current = null;
                            }
                          });

                        },
                        // onResult3: (){
                        //   ScriptInfo.openedScripts.remove(element);
                        //   if (ScriptInfo.openedScripts.length>0){
                        //     ScriptInfo.current = ScriptInfo.openedScripts.last;
                        //   }
                        //   else{
                        //     ScriptInfo.current = null;
                        //   }
                        // },
                      );
                    }
                    else{
                      setState(() {
                        element.history?.clear();
                        ScriptInfo.openedScripts.remove(element);
                        if (ScriptInfo.openedScripts.length>0){
                          ScriptInfo.current = ScriptInfo.openedScripts.last;
                        }
                        else{
                          ScriptInfo.current = null;
                        }

                        ScriptInfo.saveOpenedScriptToLocal();
                      });
                    }
                    // setState(() {
                    //   ScriptInfo.openedScripts.remove(element);
                    //   if (ScriptInfo.openedScripts.length>0){
                    //     ScriptInfo.current = ScriptInfo.openedScripts.last;
                    //   }
                    //   else{
                    //     ScriptInfo.current = null;
                    //   }
                    // });


                  }


                ),
              ),
            ],
          ),
        );
        var ink = GestureDetector(
          onTap: (){
            if (ScriptInfo.current != element){
              var focusState = RunSession.instance.isFocusStateMode;
              if (ScriptInfo.current != null){
                ScriptInfo.current.recordCanvasPos();
                 //如果当前脚本是聚焦状态则取消聚焦
                 if(focusState){
                  //必须事先重置状态 不然图标刷新会不及时
                      if (RunSession.instance.isRunning) {
                        RunSession.instance.stop();
                        RunSession.instance.inStepping = false;
                      }
                    RunSession.instance.sendEmptyDebugInfoData();
                    
                 }
              }
              ScriptInfo.current = element;
              ScriptInfo.current.initCanvasPos();
              // ScriptInfo.addOpenScript(ScriptInfo.current);
              StateScriptNode.clearSelectedNodesMap();
              //如果是聚焦状态从新通知Unity聚焦当前脚本
              if(focusState){
                Future(() =>{RunSession.instance.sendDebugInfoData()});  
              }

              setState(() {

              });
            }
          },
          onSecondaryTap: (){
            CmoC.getShow(getContextMenu(element));
          },
          child: tab,
        );
        // var ink = InkWell(
        //   child: tab,
        //   onTap: (){
        //     if (ScriptInfo.current != element){
        //       if (ScriptInfo.current != null){
        //         ScriptInfo.current.recordCanvasPos();
        //       }
        //       ScriptInfo.current = element;
        //       ScriptInfo.current.initCanvasPos();
        //       // ScriptInfo.addOpenScript(ScriptInfo.current);
        //       StateScriptNode.clearSelectedNodesMap();
        //       setState(() {
        //
        //       });
        //     }
        //   },
        // );
        wdgs.add(ink);
        wdgs.add(Container(width: 6,));
      }
    });

    return Container(
      // color: Colors.indigo,
        color : Color.fromARGB(255, 60, 63, 65),
        padding: EdgeInsets.fromLTRB(6,0,6,0),
        alignment: Alignment.center,
        height: 44,
        child: SingleChildScrollView(
          child: Container(
            child: Row(
              children: wdgs,
            ),
          ),
        )
    );
  }

  Widget getContextMenuButton(String text) {
    var txtStlye = TextStyle(color: Colors.white , fontSize: 15);
    return Row(
      children: [
        Expanded(child: Text(text,style: txtStlye,)),
      ],
    );
  }
  Widget getContextMenu(ScriptInfo element) {
    List<Widget> rows = <Widget>[];

    rows.add(Container(alignment: Alignment.center, child:TextButton(onPressed: (){
      setState(() {
        element.history?.clear();
        ScriptInfo.openedScripts.remove(element);
        if (ScriptInfo.openedScripts.length>0){
          ScriptInfo.current = ScriptInfo.openedScripts.last;
        }
        else{
          ScriptInfo.current = null;
        }

        ScriptInfo.saveOpenedScriptToLocal();
        CmoC.getHide();
      });
    }, child: getContextMenuButton("关闭"))));
    rows.add(TextButton(onPressed: (){
      setState(() {
        element.history?.clear();
        List<ScriptInfo> dels = [];dels.addAll(ScriptInfo.openedScripts);
        dels..forEach((e1) {
          if (e1 != element) {
            ScriptInfo.openedScripts.remove(e1);
          }
        });

        if (ScriptInfo.openedScripts.length>0){
          ScriptInfo.current = ScriptInfo.openedScripts.last;
        }
        else{
          ScriptInfo.current = null;
        }

        ScriptInfo.saveOpenedScriptToLocal();
        CmoC.getHide();
      });
    }, child: getContextMenuButton("关闭其他")));
    rows.add(TextButton(onPressed: (){
      setState(() {
        element.history?.clear();
        List<ScriptInfo> dels = [];dels.addAll(ScriptInfo.openedScripts);
        dels..forEach((e1) {
          ScriptInfo.openedScripts.remove(e1);
        });

        if (ScriptInfo.openedScripts.length>0){
          ScriptInfo.current = ScriptInfo.openedScripts.last;
        }
        else{
          ScriptInfo.current = null;
        }

        ScriptInfo.saveOpenedScriptToLocal();
        CmoC.getHide();
      });
    }, child: getContextMenuButton("关闭全部")));

    rows.add(TextButton(onPressed: (){
      setState(() {
        element.pinned = !element.pinned;
      });
      CmoC.getHide();

    }, child: getContextMenuButton(element.pinned?"取消固定":"固定")));
    rows.add(TextButton(onPressed: (){
      setState(() {
        element.history?.clear();
        List<ScriptInfo> dels = [];dels.addAll(ScriptInfo.openedScripts);
        dels.forEach((e1) {
          if (!e1.pinned){
            ScriptInfo.openedScripts.remove(e1);
          }
        });

        if (ScriptInfo.openedScripts.length>0){
          ScriptInfo.current = ScriptInfo.openedScripts.last;
        }
        else{
          ScriptInfo.current = null;
        }

        ScriptInfo.saveOpenedScriptToLocal();
        CmoC.getHide();
      });
    }, child: getContextMenuButton("除固定全部关闭")));
    // getDirSvnCommands(dirPath,rows);
    // getDirGitCommands(dirPath,rows);
    // getDirCommands(dirPath,rows);
    // getFileSysCommands(dirPath,rows ,manager: stateManager);
    // getOtherCommands(dirPath,rows,);
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: rows,
          ),
        )
    );
  }

  // RawKeyEvent keyEvent;
  void _handleKeyEvent(RawKeyEvent value) {
//    print("key " + value.data.keyLabel.toString());
//    print("shift " + value.logicalKey.toString());
//    GlobalBoard.updateKeyState(keyEvent);
//     print("key update ${value.isControlPressed}");
    KeyEventCenter.updateKeyState(value);


  }

  Widget onBuildDragGroupTarget(BuildContext context, List candidateData, List rejectedData) {
    var nodes = List<Widget>();

    nodes.addAll(getAllGroups());
     return Stack(
      children: nodes
    );
  }

  Widget onBuildDragTarget(BuildContext context, List candidateData, List rejectedData) {
    return getAllNodes();
  }

  void checkTimelineMode(){
    StateScriptNode.withTimelineNode = false;
    for(var n in ScriptInfo.current.scriptData.nodes){
      var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
      if (nodeType != null) {
        if (nodeType.getIsTimelineNode()){StateScriptNode.withTimelineNode = true;return;}

      }
    }
    for(var ss in ScriptInfo.current.scriptData.subScripts){
      if (ss.subNodes == null) continue;
      for(var n in ss.subNodes){
        var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
        if (nodeType != null) {
          if (nodeType.getIsTimelineNode()){StateScriptNode.withTimelineNode = true;return;}
        }
      }
    }
  }
  Widget getAllNodes(){
    var nodes = List<Widget>();

    //nodes.addAll(getAllGroups());


    // nodes.addAll(getAllNodeHelps());

    List<StateScriptNodeView> allNodes = List<StateScriptNodeView>();
    // StateScriptNode.withTimelineNode = false;
    for(var n in ScriptInfo.current.scriptData.nodes){
      var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
      if (nodeType != null) {
        // if (nodeType.isTimelineNode)StateScriptNode.withTimelineNode = true;
        var nv = StateScriptNodeView(key: ValueKey(n.guid),node: n, graph: this);
        // StateScriptNode.allModuleInterfaces.forEach((element) {
        //   element.ownerNode = n;
        //   StateScriptNode.allModuleInterfaces.add(n.moduleInterfaces);
        // });

        n.moduleInterfaces.forEach((key, value) {
          value.ownerNode = n;
          StateScriptNode.allModuleInterfaces.add(value);
        });

        // StateScriptNode.allModuleInterfaces.addAll(n.moduleInterfaces.values);
        allNodes.add(nv);
      }
    }

    for(var ss in ScriptInfo.current.scriptData.subScripts){
      if (ss.subNodes == null) continue;
      if (ss.isExpanded == false){
        //搜集所有mi
        ss.collectModuleInterfaces();
        continue;
      }
      for(var n in ss.subNodes){
        n.x = ss.x + n.oriX;
        n.y = ss.y + n.oriY;
        var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
        if (nodeType != null) {
          // if (nodeType.isTimelineNode)StateScriptNode.withTimelineNode = true;
          var nv = StateScriptNodeView(key: ValueKey(n.guid) , node: n, graph: this);
          allNodes.add(nv);
        }
      }
    }

    if (!SSDefines.isInDagging) allNodes.sort((a,b){
      var aInEditting = a.node.inEditting ? 0 : 1;
      var bInEditting = b.node.inEditting ? 0 : 1;

      // 先按展开状态排序：展开的在前(0)，没展开的在后(1)
      if (aInEditting != bInEditting) {
        return  bInEditting -aInEditting;
      }

      // 在相同展开状态下，按y坐标排序：y坐标低的在前
      return (a.node.y ?? 0).compareTo(b.node.y ?? 0);
    });


    nodes.addAll(getAllNodeSOPorts());
    nodes.addAll(getAllNodeSOPs());
    nodes.addAll(allNodes);


    nodes.addAll(getAllSubScripts());


    nodes.addAll(getAllModuleInterfaces());

    nodes.addAll(getAllTimelineRightArrow());

    return Stack(
      children: nodes
    );
    // return Container(
    //   child:Stack(
    //       children: nodes
    //   ),
    // );
  }
//   var _dc = new BoxDecoration(
// //    shape:BoxShape.circle,
//     boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
//   );
  List<Widget> getAllGroupNames(){
    var nodes = List<Widget>();
    for(var g in ScriptInfo.current.scriptData.nodeGroups){
      var rect = g.currentGroupRect;
      var nv = Positioned(
        left: rect.left - 50,
        top:rect.top - 200,
        child: Container(
          // padding: EdgeInsets.all(32),
          // decoration:_dc ,
          child:Wrap(
            crossAxisAlignment : WrapCrossAlignment.center,
            children: [
              Icon(MaterialCommunityIcons.flag_checkered ,size: 220, color: Colors.redAccent,),
              Text(g.getTypeShowString(),style: TextStyle(fontSize: 100,fontWeight: FontWeight.w600),),
            ],
          ),
        )
      );
      if (nv != null) {
        nodes.add(nv);
      }
    }
    return nodes;
  }


  List<Widget> getAllGroups(){
    var nodes = List<Widget>();
    var groups = ScriptInfo.current.scriptData.nodeGroups;

    for (var i = groups.length-1 ; i>=0; --i){
      if (groups[i].nodes == null || groups[i].nodes.length<=0){
        groups.removeAt(i);
      }
    }

    for(var g in groups){
      var nv = NodeGroupView(group: g, graph: this,);
      if (nv != null) {
        nodes.add(nv);
      }
    }



    return nodes;
  }

  List<Widget> getAllSubScripts(){
    var nodes = List<Widget>();
    var groups = ScriptInfo.current.scriptData.subScripts;

    for(var g in groups){
      print("------- build mp : ${g.guid} ${g.x} ${g.y}");
      var nv = ModulePanel(subScript: g,graph: this,);
      if (nv != null) {
        nodes.add(nv);
      }
    }

    return nodes;
  }

  List<Widget> getAllModuleInterfaces(){
    var nodes = List<Widget>();

    for(var mi in StateScriptNode.allModuleInterfaces){
      if (mi == null) continue;
      var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
      if (node != null) {
        // var pos = node.getInPortPosition(mi.interfaceGuid);
        // if (pos != null){
        var nv = ModuleInterfaceView(node  : node , onGetPosition: ()=>node.getInPortPosition(mi.interfaceGuid), isRight: false, graph: this , interface: mi, onDelete: (mi){
          setState(() {
          });
        },);
        nodes.add(nv);
        // }
      }
    }
    //
    // for(var mi in ScriptInfo.current.scriptData.inPorts){
    //   if (mi == null) continue;
    //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
    //   if (node != null) {
    //     // var pos = node.getInPortPosition(mi.interfaceGuid);
    //     // if (pos != null){
    //       var nv = ModuleInterfaceView(node  : node , onGetPosition: ()=>node.getInPortPosition(mi.interfaceGuid), isRight: false, graph: this , interface: mi, onDelete: (mi){
    //         setState(() {
    //         });
    //       },);
    //       nodes.add(nv);
    //     // }
    //   }
    // }
    // for(var mi in ScriptInfo.current.scriptData.outPorts){
    //   if (mi == null) continue;
    //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
    //   if (node != null) {
    //     // var pos = node.getOutPortPosition(mi.interfaceGuid);
    //     // if (pos != null){
    //       var nv = ModuleInterfaceView(node  : node ,onGetPosition: ()=>node.getOutPortPosition(mi.interfaceGuid), isRight: true, graph: this , interface: mi, onDelete: (mi){
    //         setState(() {
    //         });
    //       },);
    //       nodes.add(nv);
    //     // }
    //   }
    // }
    // for(var mi in ScriptInfo.current.scriptData.inParams){
    //   if (mi == null) continue;
    //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
    //   if (node != null) {
    //     // var pos = node.getInParamPosition(mi.interfaceGuid);
    //     // if (pos != null){
    //       var nv = ModuleInterfaceView(node  : node ,onGetPosition: ()=>node.getInParamPosition(mi.interfaceGuid), isRight: false, graph: this , interface: mi, onDelete: (mi){
    //         setState(() {
    //         });
    //       },);
    //       nodes.add(nv);
    //     // }
    //   }
    // }
    //
    // for(var mi in ScriptInfo.current.scriptData.outParams){
    //   if (mi == null) continue;
    //   var node = ScriptInfo.current.scriptData.nodeMap[mi.nodeGuid];
    //   if (node != null) {
    //     // var pos = node.getOutParamPosition(mi.interfaceGuid);
    //     // if (pos != null){
    //       var nv = ModuleInterfaceView(node  : node ,onGetPosition: ()=>node.getOutParamPosition(mi.interfaceGuid), isRight: true, graph: this , interface: mi, onDelete: (mi){
    //         setState(() {
    //         });
    //       },);
    //       nodes.add(nv);
    //     // }
    //   }
    // }
    return nodes;
  }

  List<Widget> getAllNodeSOPs(){
    var nodes = List<Widget>();
    for(var n in ScriptInfo.current.scriptData.nodes){
      var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
      if (nodeType != null) {
        for(var sop in n.sops) {
          var nv = SOParamView(sop : sop ,node: n, graph: this);
          if (nv != null && nv != emptySOP) {
            nodes.add(nv);
          }
        }
      }
    }

    for(var ss in ScriptInfo.current.scriptData.subScripts){
      if (ss.subNodes == null || !ss.isExpanded) continue;
      for(var n in ss.subNodes){
        var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
        if (nodeType != null) {
          for(var sop in n.sops) {
            sop.x = ss.x + sop.oriX;
            sop.y = ss.y + sop.oriY;
            var nv = SOParamView(sop : sop ,node: n, graph: this);
            if (nv != null && nv != emptySOP) {
              nodes.add(nv);
            }
          }
        }
      }
    }
    return nodes;
  }
  List<Widget> getAllTimelineRightArrow(){
    var nodes = List<Widget>();
    for(var n in ScriptInfo.current.scriptData.nodes){
      var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
      if (nodeType != null && nodeType.getIsTimelineNode()) {
        var nv = TimelineRightArrow(node: n, graph: this);
        if (nv != null) {
          nodes.add(nv);
        }
        var nv2 = TimelineLeftArrow(node: n, graph: this);
        if (nv2 != null) {
          nodes.add(nv2);
        }
      }
    }

    return nodes;
  }
  List<Widget> getAllNodeSOPorts(){
    var nodes = List<Widget>();
    for(var n in ScriptInfo.current.scriptData.nodes){
      var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
      if (nodeType != null) {
        for(var sop in n.soports) {

          var nv = SOPortView(sop : sop ,node: n, graph: this);
          if (nv != null) {
            nodes.add(nv);
          }
        }
      }
    }

    for(var ss in ScriptInfo.current.scriptData.subScripts){
      if (ss.subNodes == null || !ss.isExpanded) continue;
      for(var n in ss.subNodes){
        var nodeType = StateScriptProject.instance.structMap[n.nodeTypeGuid];
        if (nodeType != null) {
          for(var sop in n.soports) {
            sop.x = ss.x + sop.oriX;
            sop.y = ss.y + sop.oriY;
            var nv = SOPortView(sop : sop ,node: n, graph: this);
            if (nv != null) {
              nodes.add(nv);
            }
          }
        }
      }
    }

    return nodes;
  }

  Widget getAllNodeHelps(){
    var nodes = List<Widget>();

      for (var n in ScriptInfo.current.scriptData.nodes) {
        // if (!(GlobalBoard.showDescription) || !n.showHelp) continue;
        // var line = HelpLine(node : n);
        // nodes.add(line);

          var nv = NodeFieldEditorView(node: n, graph: this);
          nodes.add(nv);

      }

    // return nodes;
    return Container(
      child:Stack(
          children: nodes
      ),
    );
  }

  bool onWillAccept(data) {
    return true;
//    print(data);
//    return data is BehaviacNodeType;
  }

  void onLeave(Object data) {
    print("---- onLeave $data");
  }

  void onAcceptWithDetails(DragTargetDetails<NodeStructData> details) {
    print("---- onAccept ${details.data}");
    var n = StateScriptNode();

//    var sizeOff = Offset((BTDefines.nodeTypeWidth - BTDefines.nodeWidth) /2,(BTDefines.nodeTypeHeight - BTDefines.nodeHeight) /2);
    var off = calcLocalPosition(details.offset);// + Offset(BTDefines.nodeTypeWidth/2 , BTDefines.nodeTypeHeight/2));
//    RenderBox getBox = context.findRenderObject();
//    var local = getBox.globalToLocal(details.offset);

    off = fixPosition(off);

    n.x = off.dx;
    n.y = off.dy;
    n.nodeTypeGuid = details.data.guid;
    HistoryManager.scriptHistory.appendHistory();
    setState(() {
      ScriptInfo.current.scriptData.addNode(n);
    });
  }

  Offset calcLocalPosition(Offset offset){
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(offset);
    var off = ZoomState.current.getOff();
    var scale = ZoomState.current.getScale();
    var x = (local.dx + off.dx)/scale;
    var y = (local.dy + off.dy)/scale;
    return Offset(x,y);
  }

  Offset global2LocalDelta(Offset offset){
    var scale = ZoomState.current.getScale();
//    RenderBox getBox = context.findRenderObject();
//    var local = getBox.globalToLocal(offset);
    return offset / scale;
  }

  Offset fixPosition(Offset off) {
    var x = ((off.dx - SSDefines.canvasZeroX) / SSDefines.fixPosX).floor() * SSDefines.fixPosX + SSDefines.canvasZeroX;//- BTDefines.nodeWidth/2 * viewZoom;
    var y  = ((off.dy - SSDefines.canvasZeroY)/ SSDefines.fixPosY ).floor()* SSDefines.fixPosY + SSDefines.canvasZeroY;//- BTDefines.nodeHeight/2 * viewZoom;
    return Offset(x,y);
  }

  void refresh() {
    setState(() {

    });
  }


}