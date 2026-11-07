//@dart=2.11
import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyContainer.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/FieldGroup.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/PackageCompare/ZipItem.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/protos/transition.pbserver.dart';

import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';


class EventCenter{
  static EventBus eventBus = EventBus();
}

class AObjectChanged{
  AObject obj;

  bool buildLayout;
}

class OTRefreshTransform {
  List pos;
  String posFieldName;
  List rot;
  String rotFieldName;
  List scale;
  String scaleFieldName;
}


class AObjectForceChanged{
  AObject obj;
  bool bDeleted = false;
}

class AObjectTableCleared{
}

class AObjectShowDetail{
  AObject obj;
  String fieldGuid;
}

class AGroupChanged{
  FieldGroup group;
}

class AObjectClassChanged{
  ObjectClazz clz;
}

class AFieldTransformChanged{
  AObject obj;
  String fieldGuid;
}

class AGroupVisibleChanged{
  dynamic group;
}

class FocusOTObject{
  String guid;
}

// class ADecotationTransformChanged{
//   String guid;
// }

class GlobalRefreshEvent {
}

class FocusCanvasEvent {
}

class FilterRefreshEvent {
}
class AddResWorkPathEvent {
}
class ReLoginEvent {
}

class VarsRefreshEvent {
  bool bShowing = false;
}

class VarsDataRefreshEvent {
  VarData varData;
}


class CompareApkRefreshEvent {
  List<String> apkPaths;
  List<ZipItem> allItems;
  Map<String , Map<String , ZipItem>> zipItemMaps;
}

class PackageRefreshEvent {
}
//state script
class NodeTypeSelectionChangeEvent {
  NodeStructData nodeType;

  NodeTypeSelectionChangeEvent(NodeStructData nt){
    nodeType = nt;
  }
}

class ClazzSelectionChangeEvent {
  ObjectClazz clazz;

  ClazzSelectionChangeEvent(ObjectClazz nt){
    clazz = nt;
  }
}

class NodeTypeListRefreshEvent {
  bool bShow = false;
  double x;
  double y;

  double showListX;
  double showListY;

  String inParamFilter;
  String outParamFilter;
  String paramName;
  String srcNodeId;

  String srcNodeGuid ;
  String srcParamGuid ;
}

class NodeDescriptionEditorEvent {
  StateScriptNode node;
}

class LogViewState {
  bool open = false;
}



class SubScriptRefreshEvent {
  String guid = "";
}

class ScriptSelectionChangeEvent {
  ScriptInfo script;

  ScriptSelectionChangeEvent(ScriptInfo nt){
    script = nt;
  }
}

class ScriptChangeEvent {
  ScriptInfo script;

  ScriptChangeEvent(ScriptInfo nt){
    script = nt;
  }
}

class NodeTypeChangeEvent {
  NodeStructData nodeType;

  NodeTypeChangeEvent(NodeStructData nt){
    nodeType = nt;
  }
}

class ClazzChangeEvent {
  ObjectClazz clazz;

  ClazzChangeEvent(ObjectClazz nt){
    clazz = nt;
  }
}

class NodeRefreshEvent {

}

class NodeRefreshDragOrderEvent {

}

class GroupRefreshEvent {
  String guid;
}

class TagChangedEvent {
}

class NodeRefreshWithTargetEvent {
  StateScriptNode node;
  NodeStructData nodeType ;
  bool posChanged;
  int exportId;
}

class TimelineCursorRefresh {
  double time ;
  bool isUnityResponce = false;
}

class TimelineCursorInit {

}



class ModuleInterfaceRefreshEvent {
  ModuleInterface mi;
  Offset position;
}


class ConnectLineStartEvent {
  Offset start;
  ConnectLineStartEvent(Offset pos){
    start = pos;
  }
}

class ConnectLineMoveEvent {
  Offset end;
  ConnectLineMoveEvent(Offset pos){
    end = pos;
  }
}


class ConnectLineEndEvent {
}

class LocationFlagEvent {
  double scale;
  bool bForce = false;
}

class RefreshConnectCommandEvent {
  dynamic refreshConnection;
  dynamic openedPortConnection;
  bool openChanged;
  StateScriptNode targetNode;
  bool globalRefresh;
}

class NodeSelectStatusChangedEvent {
  StateScriptNode targetNode;
  bool selected;
}

class RefreshAllConnectLineEvent______ {

}

class ChangeConnectLineColorEvent {
  int color;
}

class RefreshMultiDraggingEvent{
  bool bShow;
}


class SubstituteObjectRefreshEvent {
  dynamic object;
  bool posChanged;
}

class NodeDescRefreshEvent {
  StateScriptNode node;
}

class HistoryRefreshEvent {
  HistoryManager manager;
}


class InspectorRefreshEvent {
  AObject object;
  FieldInfo field;
}

class ObjectFocusEvent {
  AObject object;
}

class FullObjectInspectorEvent {
  AObject object;
}

class KeyEvent {
  RawKeyEvent event;
  LogicalKeyboardKey key;
}

class RefreshMarkdownEvent {
}

class TableSliderEvent {
  double value;
}

class TableTopEvent {
}

class ObjectTreeRefreshEvent {
  ObjectClazz clazz;
}

class ThreadProgressEvent {
  int allCount ;
  int current ;
  String message ;
}

class ThreadDoneEvent {
  dynamic object;
}

class BlockContainerRefresh {
  IBlockyContainer container;
}

class TransformUpdateEvent {
  String guid ;
  ObjInfo objInfo;
}

class FocusNodeUpdateEvent {
  String guid ;
}

class ChangeScriptEvent {
  String scriptName;
  String scriptGuid;
  int id;
  bool createIfNull;
}

class ProgressEvent {
  String info;
}

class OTGridCellChange {
  ObjectClazz clazz;
  AObject object;
  FieldInfo fieldInfo;
  int index;
}

class GridRefreshRange {
  double x1;
  double x2;
}

class PortClickEvent {
  StateScriptNode node ;
  String portGuid;
}

class ObjectTableLoadedEvent {
}
