//@dart=2.11

import 'dart:convert';

import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/protos/transition.pb.dart';

class PackSolver {

  static Map<String , dynamic> transObjects = Map<String , dynamic>();

  // static void registerTransitionObjects(objs){
  //   transObjects.clear();
  //   for(var obj in objs){
  //     transObjects[obj.guid] = obj;
  //   }
  // }

  static void clearTransObjects(){
    transObjects.clear();
  }
  static void registerTransitionObject(obj){
    transObjects[obj.guid] = obj;
  }
  int currentPackGuid = -1;
  void process(OPack pk){
    switch(pk.type){
      case OPackType.U2O_UpdateTransform:
//         print("U2O_UpdateTransform");
        var oi = ObjInfo.fromBuffer(pk.data);
        var obj = transObjects[oi.guid];

        if (obj != null){
          if (obj is StateScriptNode){
            var tp = obj.getNodeStructType();
            tp.setUnityTransformInfo(oi, obj);
            EventCenter.eventBus.fire(TransformUpdateEvent()..guid = oi.guid..objInfo = oi);
          }
          if (obj is AObject){
            // print("AObj");
            var clz = ObjectClazz.getClazz(obj.clazzGuid);
            clz.setUnityTransformInfo(oi, obj);
            // EventCenter.eventBus.fire(TransformUpdateEvent()..guid = oi.guid..objInfo = oi);
          }
        }
        break;
      case OPackType.U2O_DeleteNode:
        // do nothing
        if (ScriptInfo.current == null) return;
        var fo = SimpleNode.fromBuffer(pk.data);
        var obj = ScriptInfo.current.getScriptData().nodeMap[fo.guid];// transObjects[co.copyGuid];
        if (obj != null){
          ScriptInfo.current.scriptData.deleteNode(obj);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
        // print("focus node");

        break;
      case OPackType.U2O_FocusNode:
        var fo = FocusToNode.fromBuffer(pk.data);
        // print("focus node");
        ScriptInfo.current.unselectAll();
        EventCenter.eventBus.fire(FocusNodeUpdateEvent()..guid = fo.guid);
        break;
      case OPackType.U2O_PlayingState:
        var ps = PlayingState.fromBuffer(pk.data);

        if (RunSession.instance.remoteIsPlaying != ps.isPlaying){
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
        RunSession.instance.remoteIsPlaying = ps.isPlaying;
        // print("unity playing : ${RunSession.instance.remoteIsPlaying}");
        // EventCenter.eventBus.fire(FocusNodeUpdateEvent()..guid = fo.guid);
        break;
      // case OPackType.U2O_DeleteNode:
      //   var sn = SimpleNode.fromBuffer(pk.data);
      //   if (sn.)
      //   break;
      case OPackType.U2O_CreateNode:
        if (ScriptInfo.current == null) return;
        var co = CopyObject.fromBuffer(pk.data);
        var obj = ScriptInfo.current.getScriptData().nodeMap[co.copyGuid];// transObjects[co.copyGuid];
        // print("U2O_CreateNode ${obj}");
        StateScriptNode newn;
        if (obj != null) {
          JsonEncoder encoder = new JsonEncoder.withIndent('  ');
          var json = encoder.convert(obj);

          Map userMap = jsonDecode(json);
          newn = StateScriptNode.fromJson(userMap);
          newn.x += 32;
          newn.y += 32;
        }
        else{
          //完全新建
          newn = StateScriptNode();
          // var off = calcLocalPosition(details.offset);// + Offset(BTDefines.nodeTypeWidth/2 , BTDefines.nodeTypeHeight/2));
          // off = fixPosition(off);
          //


          var off = ZoomState.current.currentCenterPosition();
          newn.x = off.dx;
          newn.y = off.dy;



          // var nodeTypeName = co.
          newn.nodeTypeGuid = co.typeGuid;

          var tp = newn.getNodeStructType();
          var prefabField = tp.fields.where((element) => element.name.toLowerCase().trim() == "prefab").toList();
          if (co.prefab != null && prefabField.length>0){
            newn.fieldValues[prefabField[0].guid] = FieldValueHolder()..value = co.prefab .. name = prefabField[0].name;
          }

          // HistoryManager.scriptHistory.appendHistory();
          // setState(() {
          //   ScriptInfo.current.scriptData.addNode(n);
          // });
        }
        newn.guid = co.guid;
        newn.selected = true;
        HistoryManager.scriptHistory.appendHistory();

        ScriptInfo.current.scriptData.addNode(newn);
        PackSolver.registerTransitionObject(newn);

        EventCenter.eventBus.fire(GlobalRefreshEvent());
        break;
      case OPackType.U2O_RuntimeState:
        // print("run session");

        // print("run session ${nodeStates.scriptName}");
        if (!RunSession.instance.isRunning) {
          RunSession.instance.start();
        }
     
        //这里以前说是做了分包处理？但是以前没出问题 ！！！  现在currentPackGuid ==pk.guid == 0
       // if (currentPackGuid >= pk.guid) return ; 
        currentPackGuid = pk.guid;

        // // var nodeStates = ONodeStates.fromBuffer(pk.data);
        // // print("run session ${nodeStates.scriptName}");
        var nodeStates = ONodeStates.fromBuffer(pk.data);

        // print("run session ${nodeStates.scriptName}");

        // if (nodeStates.hashCode
        if (ScriptInfo.current?.exportId != nodeStates.id){
          // print("------------------ runtime focus ${nodeStates.scriptName}");
          EventCenter.eventBus.fire(ChangeScriptEvent()..id = nodeStates.id);
        }
        // if (ScriptInfo.current?.exportId?.toString()??"" != nodeStates.scriptName){
        //   print("------------------ runtime focus ${nodeStates.scriptName}");
        //   EventCenter.eventBus.fire(ChangeScriptEvent()..scriptName = nodeStates.scriptName);
        // }
        // var script = StateScriptProject.instance.getScriptByExportId(nodeStates.id);
        RunSession.instance.receiveData(nodeStates);
        RunSession.instance.isFocusStateMode = true;
        break;
      case OPackType.U2O_RuntimeClear:
        RunSession.instance.isFocusStateMode = false;
        // print("U2O_RuntimeClear");
        currentPackGuid = -1;
        RunSession.instance.prtTriggerCount.clear();
        RunSession.instance.prmTriggerCount.clear();
        RunSession.instance.prtFlashing.clear();
        RunSession.instance.prmFlashing.clear();

        if (RunSession.instance.isRunning) {
          RunSession.instance.stop();
          RunSession.instance.inStepping = false;

        }

        break;

      case OPackType.U2O_ResponceRuntimeSetTime:

        var bi = TimelineTime.fromBuffer(pk.data);
        EventCenter.eventBus.fire(TimelineCursorRefresh()..time = bi.time..isUnityResponce = true);

        break;
      case OPackType.U2O_StepBlocked:
        var bi = DebugBlocked.fromBuffer(pk.data);
        if (RunSession.instance.inStepping != bi.isBlocked || RunSession.instance.currentBreakPoint != bi.breakPointKey){
          print("block updated");
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
        RunSession.instance.inStepping = bi.isBlocked;
        RunSession.instance.currentBreakPoint = bi.breakPointKey;

        break;
      case OPackType.U2O_LevelSelected:
        print("U2O_LevelSelected");
        var lvl = OLevel.fromBuffer(pk.data);
        if (ScriptInfo.current?.name != lvl.levelGuid){
          EventCenter.eventBus.fire(ChangeScriptEvent()..scriptGuid = lvl.levelGuid);
        }
        break;

      case OPackType.U2O_Log:

        var log = OLog.fromBuffer(pk.data);

        var newName = log.message.replaceAllMapped(RegExp(r'(#\d+)'), (match){
          var fieldName = match.group(1);
          // print("match : ${fieldName}");
          // print("match : ${StateScriptProject.instance.globalScriptVarMap}");
          var fi = StateScriptProject.instance.globalScriptVarMap[fieldName];
          if (fi!= null) return fi.name;
          return "";
        });
        // print("${log.type} - ${log.message}");
        StateScriptProject.logs.add("${log.type} - $newName");
        EventCenter.eventBus.fire(LogViewState()..open = true);
        break;
      case OPackType.U2O_OT_TRANSFORM_CHANGED:
        var tr = OT_ObjectTransform.fromBuffer(pk.data);
        var guid = tr.guid;
        var map = TableUtiles.otTransformFieldMap[guid];

        if (map != null) {
          var aObj = ObjectClazz.allObjects[map["mapGuid"]];
          // if (aObj == null) {
          //   aObj = ObjectClazz.allObjects[map["mapGuid"]];
          // }
          if (aObj == null) return ;
          var posField = map["pos"];
          if (!DartCommon.isEmpty(posField)){
            aObj.setFieldValueByName(posField, DartCommon.listToFloatAsFixed([tr.pos.x,tr.pos.y,tr.pos.z],3) , sendEvent: true);
          }
          var rotField = map["rot"];
          if (!DartCommon.isEmpty(posField)){
            aObj.setFieldValueByName(rotField, DartCommon.listToFloatAsFixed([tr.rot.x,tr.rot.y,tr.rot.z],3) , sendEvent: true);
          }
          var scaleField = map["scale"];
          if (!DartCommon.isEmpty(posField)){
            aObj.setFieldValueByName(scaleField, DartCommon.listToFloatAsFixed([tr.scale.x,tr.scale.y,tr.scale.z],3) , sendEvent: true);
          }
          // EventCenter.eventBus.fire(
          //     OTRefreshTransform()..pos = [tr.pos.x,tr.pos.y,tr.pos.z]
          //       ..rot = [tr.rot.x,tr.rot.y,tr.rot.z]
          //       ..scale = [tr.scale.x,tr.scale.y,tr.scale.z]
          //       ..posFieldName = map["pos"]
          //       ..rotFieldName = map["pos"]
          //       ..scaleFieldName = map["pos"]
          // );
        }
        break;
      case OPackType.U2O_OT_SELECT_OBJECT:
        var tr = OT_SelectObject.fromBuffer(pk.data);
        var guid = tr.guid;
        print("focus ot object $guid");
        var obj = ObjectClazz.allObjects[guid];
        if (obj != null){
          EventCenter.eventBus.fire(AObjectShowDetail()..obj = obj);
        }
        // EventCenter.eventBus.fire(FocusOTObject()..guid = guid);
        break;
      default:
        break;
    }
  }


  static bool objectExists(data) {
    return transObjects[data.guid] != null;
  }
}