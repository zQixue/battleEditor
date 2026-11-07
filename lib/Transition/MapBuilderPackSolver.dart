//@dart=2.11


import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/protos/transition.pb.dart';

class MapBuilderPackSolver {

  static Map<String , dynamic> transObjects = Map<String , dynamic>();

  static void clearTransObjects(){
    transObjects.clear();
  }
  static void registerTransitionObject(obj){
    transObjects[obj.guid] = obj;
  }

  void process(OPack pk){
    switch(pk.type){
      case OPackType.U2O_MAP_SelectMap:
        print("U2O_MAP_SelectMap");
        var lvl = OLevel.fromBuffer(pk.data);
        if (ScriptInfo.current?.name != lvl.levelGuid){
          EventCenter.eventBus.fire(ChangeScriptEvent()..scriptGuid = lvl.levelGuid..createIfNull = true);
        }


        break;
      case OPackType.U2O_MAP_DeleteObject:
        print("U2O_MAP_DeleteObject");
        if (ScriptInfo.current == null) return;
        var fo = SimpleNode.fromBuffer(pk.data);
        var obj = ScriptInfo.current.getScriptData().nodeMap[fo.guid];// transObjects[co.copyGuid];
        if (obj != null){
          HistoryManager.scriptHistory.appendHistory();
          ScriptInfo.current.scriptData.deleteNode(obj);
          EventCenter.eventBus.fire(GlobalRefreshEvent());
        }
        break;
      case OPackType.U2O_MAP_FocusNode:
        print("U2O_MAP_FocusNode");
        var fo = FocusToNode.fromBuffer(pk.data);
        ScriptInfo.current.unselectAll();
        EventCenter.eventBus.fire(FocusNodeUpdateEvent()..guid = fo.guid);
        break;
      case OPackType.U2O_MAP_SyncObject:
        print("U2O_MAP_SyncObject");
        var nodeData = SyncNodeData.fromBuffer(pk.data);
        print(nodeData.guid);
        print(nodeData.typeGuid);

        var obj = ScriptInfo.current.getScriptData().nodeMap[nodeData.guid];// transObjects[co.copyGuid];
        if (obj == null){
          //结点不存在，直接创建
          //完全新建
          obj = StateScriptNode();
          var off = ZoomState.current.currentCenterPosition();
          obj.x = off.dx;
          obj.y = off.dy;
          obj.nodeTypeGuid = nodeData.typeGuid;
          obj.guid = nodeData.guid;
          obj.selected = true;
          HistoryManager.scriptHistory.appendHistory();
        }
        ScriptInfo.current.scriptData.addNode(obj);
        obj.syncFromUnity(nodeData);

        EventCenter.eventBus.fire(GlobalRefreshEvent());


        break;
      default:
        break;
    }
  }

  static bool objectExists(data) {
    return transObjects[data.guid] != null;
  }
}