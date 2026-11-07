

import 'dart:io';
import 'dart:ui';

import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/StateScript/ConnectPainter.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/NodeGroup.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/SSStorage.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/right_tool_bar.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/Tagger/ATag.dart';
import 'package:battlepus/common/Tagger/TagSet.dart';
import 'package:battlepus/common/ZoomEx.dart';

part 'ScriptInfo.g.dart';

@JsonSerializable()
class ScriptInfo extends SSObjBase{
  String group = "";

  @JsonKey(defaultValue: true)
  bool exportCharp = true;
  @JsonKey(defaultValue: true)
  bool exportLua = true;

  @JsonKey(defaultValue: false)
  bool isModule = false;

  @JsonKey(defaultValue: "default")
  String category = "default";

  @JsonKey(defaultValue: "")
  String behavicAgentGuid = "";

  @JsonKey(defaultValue: false)
  bool pinned = false;

  @JsonKey(ignore: true)
  StateScript? _scriptData;

  @JsonKey(ignore: true)
  Offset? currentPos;

  @JsonKey(ignore: true)
  bool showHelp = false;

  @JsonKey(ignore: true)
  bool debugFocus = false;

  @JsonKey(ignore: true)
  bool stepDebug = false;

  @JsonKey(ignore: true)
  HistoryManager? history;

  @JsonKey(defaultValue: true)
  bool logicOrView = true ;

  // @JsonKey(defaultValue: "")
  // String exportPath = "";
  @JsonKey(defaultValue: "")
  String specialExportPath = "";
  @JsonKey(ignore: true)
  double? canvasPosX;
  @JsonKey(ignore: true)
  double? canvasPosY;
  @JsonKey(ignore: true)
  double zoom = 1.0 ;


  @JsonKey(defaultValue: null)
  TagSet? tagSet; //= TagSet();

  @JsonKey(defaultValue: "")
  String moduleGuid = "";

  void recordCanvasPos(){
    var canvasPos = ZoomState.current.currentCenterPosition();
    canvasPosX = canvasPos.dx;
    canvasPosY = canvasPos.dy;
    zoom = ZoomState.current.getScale();
  }

  void initCanvasPos(){
    if (canvasPosX == null || canvasPosY == null) {
      // ZoomState.current.focusPosition(SSDefines.canvasZeroX, SSDefines.canvasZeroY);
      return;
    }
    // canvasPos = ZoomState.current.currentCenterPosition();
    // zoom = ZoomState.current.getScale();
    // ZoomState.current.changeScale(zoom);
    ZoomState.current.scale = zoom;
    ZoomState.current.focusPosition(canvasPosX, canvasPosY);

  }

  @JsonKey(defaultValue: false)
  bool? isTemplate;
  StateScript? get scriptData  {
    if (_scriptData == null){
      loadScript();
    }
    return _scriptData;
  }

  StateScript? getScriptData(){
    return _scriptData;
  }

  StateScript? setScriptData(StateScript? ss){
    _scriptData = ss;
    return ss;
  }

  void saveScript(){
    if (_scriptData == null) return;
    // StateScriptProject.lockTime = DateTime.now().add(Duration(seconds: StateScriptProject.lockTimeAdd));
    StateScriptProject.cancelWatchProject();
    _scriptData!.clean();
    if (hasTimelineNodes() || StateScriptProject.instance!.forceSaveNodePosition){
      _scriptData!.forceUpdateNodePositions();
    }
    _scriptData!.name = name;
    _scriptData!.alias = alias;

    _scriptData!.storeNewNodePositions();
    _scriptData!.resetInitialPositions();
    SSStorage.saveScriptFile(guid, group , _scriptData , getIOHeadName() , this);
    _scriptData!.resetNewPositions();
    // StateScriptProject.lockTime = DateTime.now().add(Duration(seconds: StateScriptProject.lockTimeAdd));
    StateScriptProject.doWatchProject();
  }

  ScriptInfo();
  //此处与类名一致，由指令自动生成代码
  factory ScriptInfo.fromJson(Map<String, dynamic> json) =>
      _$ScriptInfoFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ScriptInfoToJson(this);


  static String? nextScript ;
  static ScriptInfo? nextListScript ;

  static ScriptInfo? _current;
  static ScriptInfo? get current {
    return _current;
  }

  static set current(ScriptInfo? val) {
    // if ()
    val?.scriptData?.loadSubScripts(val!.guid);
    val?.scriptData?.initConnectionCount();
    _current = val;
  }

  static void setCurrentOnly(ScriptInfo val) {
    _current = val;
  }


  void loadScript(){

    _scriptData = SSStorage.loadOrCreate(guid,group,this);
    // _scriptData.buildValidInterface();

  }

  StateScript justLoadScript(){

    var res = SSStorage.loadOrCreate(guid,group,this);
    // res.buildValidInterface();
    return res;
  }



  void selectAll() {
    for(var node in _scriptData!.nodes){
      node.selected = true;

      for(var sop in node.sops){
        sop.selected = true;
      }
      for(var sop in node.soports){
        sop.selected = true;
      }
    }
  }

  void editAll() {
    for(var node in _scriptData!.nodes){
      node.showHelp = true;
    }
  }

  void uneditAll() {
    for(var node in _scriptData!.nodes){
      node.showHelp = false;
    }
  }

  void helpAll() {
    // for(var node in _scriptData.nodes){
    //   node.showHelp = true;
    // }
    showHelp = true;
  }

  void unHelpAll() {
    // for(var node in _scriptData.nodes){
    //   node.showHelp = false;
    // }
    showHelp = false;
  }

  bool hasTimelineNodes(){
    bool bhas = false;
    for(var node in _scriptData!.nodes){
      if(node.getNodeStructType()?.isTimelineNode??false == true){
        bhas =true;
        break;
      }
    }
    return bhas;
  }

  int unselectAll() {
    var res = 0;
    // print("unselectAll ${StackTrace.current}");
    ConnectPainter.currentSelectTimelineClipNode = null;
    for(var node in _scriptData!.nodes){
      if(node.selected??false) {
        node.selected = false;
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent().node = node);
        res++;
      }

      for(var sop in node.sops){
        if (sop.selected??false) {
          sop.selected = false;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent().object = sop);
          res++;
        }
      }
      for(var sop in node.soports){
        if (sop.selected??false) {
          sop.selected = false;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent().object = sop);
          res++;
        }
      }
    }
    return res;
  }

  bool hasPortConnection(InPort inPort) {
    return false;
  }

  static void unGroup() {
    if (ScriptInfo.current != null){
      bool bModified = false ;
      var nodes = ScriptInfo.current!.scriptData!.nodes;
      for(var n in nodes) {
        if (n.selected) {
          if (n.group != "" && !bModified){
            HistoryManager.scriptHistory.appendHistory();
          }
          n.group = "";
          bModified = true;
        }
      }
      ScriptInfo.current!.scriptData!.buildScriptGroupNodes();
    }
    EventCenter.eventBus.fire(GlobalRefreshEvent());
  }
  static void doGroup(){
    if (ScriptInfo.current != null){
      var nodes = ScriptInfo.current!.scriptData!.nodes;
      String? crtGroup ;
      for(var n in nodes) {
        if (n.selected) {
          if (n.group != null && n.group.trim() != "") {
            crtGroup = n.group;
            break;
          }
        }
      }
      if (crtGroup == null){
        NodeGroup ng = NodeGroup();
        ScriptInfo.current!.scriptData!.nodeGroups.add(ng);
        crtGroup = ng.guid;
      }
      bool bModified = false ;
      for(var n in nodes) {
        if (n.selected) {
          if (n.group != crtGroup &&!bModified ){
            HistoryManager.scriptHistory.appendHistory();
            bModified = true;
          }
          n.group = crtGroup;
        }
      }

      ScriptInfo.current!.scriptData!.buildScriptGroupNodes();
    }
    EventCenter.eventBus.fire(GlobalRefreshEvent());
  }

  static List<ScriptInfo> openedScripts =  <ScriptInfo>[];
  static void addOpenScript(ScriptInfo sri) {
    // print(sri);
    openedScripts.remove(sri);
    if (openedScripts.length>12){
      openedScripts.removeAt(0);
    }
    openedScripts.add(sri);
    saveOpenedScriptToLocal();
    EventCenter.eventBus.fire(ChangeScriptEvent());
  }

  static void saveOpenedScriptToLocal(){
    var id = "opened_scripts_${Platform.resolvedExecutable}";
    List<String> lst = [];
    openedScripts.forEach((element) {
      lst.add(element.guid);
    });
    BattlePusGlobal.prefs!.setStringList(id, lst);
  }

  static void tryOpenLastScripts(){
    var id = "opened_scripts_${Platform.resolvedExecutable}";
    var lst = BattlePusGlobal.prefs!.getStringList(id);
    if (lst == null) return ;
    lst.forEach((element) {
      var si = StateScriptProject.instance!.getScriptByGuid(element);
      if (si == null) return ;

      RightToolBarState.scriptStack.push(element);

      ScriptInfo.current = si;
      ScriptInfo.addOpenScript(si);
      // ZoomState.current.centered();
      EventCenter.eventBus.fire(GlobalRefreshEvent());

    });
  }

  static void tryOpenScripts(List<ScriptInfo> scripts){

    scripts.forEach((si) {
      // var si = StateScriptProject.instance!.getScriptByGuid(element);
      // if (si == null) return ;

      RightToolBarState.scriptStack.push(si.guid);

      ScriptInfo.current = si;
      ScriptInfo.addOpenScript(si);
      // ZoomState.current.centered();
      EventCenter.eventBus.fire(GlobalRefreshEvent());

    });
  }

  int getIDFlag() {
    if (!DartCommon.isEmpty(moduleGuid)){
      var sm = StateScriptProject.instance?.scriptModules?[moduleGuid];
      if (sm != null){
        var tagSet = sm.tagSet;
        if (tagSet == null || tagSet!.tagGuids.length <= 0) return ATag.tagCommonFlag;
        return tagSet!.getIDFlag() | ATag.tagCommonFlag;
      }
    }
    if (tagSet == null || tagSet!.tagGuids.length <= 0) return ATag.tagCommonFlag;
    return tagSet!.getIDFlag() | ATag.tagCommonFlag;
  }

  String getIOHeadName() {
    return "${name??"NoName"}_[${alias??""}]".replaceAll("\\", "_").replaceAll("/", "_");
  }
}