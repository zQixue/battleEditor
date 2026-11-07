
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/protos/transition.pb.dart';


part 'RefSubScript.g.dart';

@JsonSerializable()
class RefSubScript extends SSObjBase {

  @JsonKey(defaultValue: "")
  String? scriptId ;
  @JsonKey(defaultValue: 0)
  double x = 0;
  @JsonKey(defaultValue: 0)
  double y = 0;

  @JsonKey(ignore: true)
  List<StateScriptNode>? subNodes ;

  @JsonKey(ignore: true)
  List<PortConnection>? subPortConnections ;

  @JsonKey(ignore: true)
  List<ParamConnection>? subParamConnections ;

  @JsonKey(ignore: true)
  List<FieldInfo>? subScriptFields ;

  @JsonKey(ignore: true)
  Map<String , bool> subScriptIdsMap = Map<String , bool>();

  @JsonKey(ignore: true)
  String? errorInfo ;

  @JsonKey(ignore: true)
  bool isExpanded = false ;

  @JsonKey(ignore: true)
  List<ModuleInterface> misInScripts = <ModuleInterface>[] ;

  void collectModuleInterfaces(){
    misInScripts.clear();
    for(var n in subNodes!){
      n.initPortYPos();
      if (n.isModuleNode && n.isRootModuleNode) {
        n.moduleInterfaces?.forEach((key, value) {
          value.ownerNode = n;
          misInScripts.add(value);
        });
      }
    }
  }

  // StreamSubscription<SubScriptRefreshEvent> _lis;

  RefSubScript(){
    // _lis = EventCenter.eventBus.on<SubScriptRefreshEvent>().listen((event) {
    // });
  }

  double fullWidth = 0;
  double fullHeight = 0;

  // void dispose(){
  //   _lis?.cancel();
  // }

  void reload(String rootScript){
    subNodes = null;
    load(rootScript);
  }


  //此处与类名一致，由指令自动生成代码
  factory RefSubScript.fromJson(Map<String, dynamic> json) =>
      _$RefSubScriptFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$RefSubScriptToJson(this);


  RefSubScript clone(){
    return RefSubScript()..name = name ..alias = alias;
  }

  void load(String rootScript) {
    if (subNodes != null) return ;
    if (subNodes == null) subNodes = <StateScriptNode>[];
    if (subPortConnections == null) subPortConnections = <PortConnection>[];
    if (subParamConnections == null) subParamConnections = <ParamConnection>[];
    if (subScriptFields == null) subScriptFields = <FieldInfo>[];

    subScriptIdsMap!.clear();
    subNodes!.clear();
    subPortConnections!.clear();
    subParamConnections!.clear();
    subScriptFields!.clear();
    List<String> stk = <String>[];
    stk.add(rootScript);
    loadASubScript(exportId! ,true,guid, Offset(SSDefines.moduleOffX , SSDefines.moduleOffY + SSDefines.moduleHeadHeight), this , subNodes , subPortConnections , subParamConnections , subScriptFields, subScriptIdsMap , stk);

    fullWidth = 0;
    fullHeight = 0;
    double l = double.maxFinite;
    double t = double.maxFinite;
    double r = double.minPositive;
    double b = double.minPositive;
    for(var n in subNodes!){
      var nt = n.getNodeStructType();
      if (nt == null) continue;
      l = min(l,n.oriX);
      t = min(t,n.oriY);
      r = max(r , n.oriX + n.getWidth());
      b = max(b , n.oriY + 80);
    }
    fullWidth = r;//-l;
    fullHeight = b;//-t;

  }

  void buildSortY(){
    if (subNodes == null) return ;
    subNodes!.forEach((element) {
      element.sortY = this.y + element.oriY / fullHeight;
    });
  }

  void loadASubScript(int nodeIdSuffix , bool rootScript , String headId , Offset off , RefSubScript ss , List<StateScriptNode>? outNodes , List<PortConnection>? outPortConnections , List<ParamConnection>? outParamConnections , List<FieldInfo>? outFields ,  Map<String , bool>  idMaps , List<String> stk){


    var scriptInfo = StateScriptProject.instance!.findScriptByGuid((ss?.scriptId??""));//StateScriptProject.instance!.scripts.firstWhere((element) => element.guid == (ss?.scriptId??""));
    if (scriptInfo == null){
      return ;
    }
    errorInfo = null;
    if (stk.contains(scriptInfo.guid)) {
      //循环引用
      errorInfo = "循环引用";
      return;
    }


    if (scriptInfo.scriptData == null) scriptInfo.loadScript();
    // var fp = SSStorage.getScriptFile(ss.scriptId);
    if (scriptInfo.scriptData == null){
      return;
    }

    stk.add(scriptInfo.guid);
    idMaps[ss.scriptId!] = true;
    // Map m = scriptInfo.scriptData.toJson(); //jsonDecode(File(fp).readAsStringSync());
    var jsonStr = jsonEncode(scriptInfo.scriptData);
    Map<String,dynamic> m = jsonDecode(jsonStr);
    var sss = StateScript.fromJson(m);
    double l = double.maxFinite;
    double t = double.maxFinite;

    // double r = double.minPositive;
    // double b = double.minPositive;
    // fullWidth = 0;
    // fullHeight = 0;
    for(var n in sss.nodes){
      n.exportId = (nodeIdSuffix <<SSDefines.nodeCountShift) + n!.exportId!;
      n.isModuleNode = true;
      n.isRootModuleNode = rootScript;
      var nt = n.getNodeStructType();
      if (nt == null) continue;
      l = min(l,n.x);
      t = min(t,n.y);
      // r = max(r , n.x + nt.width);
      // b = max(b , n.y + 240);
      n.guid = "$headId-${n.guid}";

      for(var sop in n.soports){
        sop.guid = "$headId-${sop.guid}";
        l = min(l,sop.x);
        t = min(t,sop.y);
      }

      for(var sop in n.sops){
        sop.guid = "$headId-${sop.guid}";
        l = min(l,sop.x);
        t = min(t,sop.y);
      }
      var allFields = nt.getAllFields();
      for(var fi in allFields){
        if (fi.typeGuid == "___scriptvar___"){
          var fv = n.fieldValues[fi.guid]?.value;
          if (fv != null){
            n.fieldValues[fi.guid]!.value = "$headId-${n.fieldValues[fi.guid]!.value}";
          }
        }
      }
    }

    for(var sbs in sss.subScripts){
      l = min(l,sbs.x);
      t = min(t,sbs.y);
    }

    // fullWidth = r-l;
    // fullHeight = b-t;
    for(var f in sss.scriptFieldVars){
      f.guid = "$headId-${f.guid}";
    }

    for(var n in sss.nodes){
      n.oriX = n.x - l + off.dx;
      n.oriY = n.y - t + off.dy;

      for(var sop in n.soports){
        sop.oriX = sop.x - l + off.dx;
        sop.oriY = sop.y - t + off.dy;
      }

      for(var sop in n.sops){
        sop.oriX = sop.x - l + off.dx;
        sop.oriY = sop.y - t + off.dy;
      }
    }


    for(var c in sss.portConnections){
      c.inNodeGuid = "$headId-${c.inNodeGuid}";
      c.sopGuid = "$headId-${c.sopGuid}";
      c.outNodeGuid = "$headId-${c.outNodeGuid}";
    }

    for(var c in sss.paramConnections){
      c.inNodeGuid = "$headId-${c.inNodeGuid}";
      c.sopGuid = "$headId-${c.sopGuid}";
      c.outNodeGuid = "$headId-${c.outNodeGuid}";
    }

    outNodes!.addAll(sss.nodes);
    outPortConnections!.addAll(sss.portConnections);
    outParamConnections!.addAll(sss.paramConnections);
    outFields!.addAll(sss.scriptFieldVars);

    for(var subS in sss.subScripts){
      var subSuffix = (nodeIdSuffix << SSDefines.moduleShift) + subS.exportId!;
      loadASubScript(subSuffix , false,"$headId-${subS.guid}",off + Offset(subS.x - l , subS.y - t) + Offset(SSDefines.moduleOffX , SSDefines.moduleOffY + SSDefines.moduleHeadHeight), subS , outNodes , outPortConnections , outParamConnections ,outFields, idMaps,stk);
    }


    stk.removeLast(); //.add(scriptInfo.guid);
  }

  void expandModule(StateScript scriptData) {
    Map<String , String> guidMap = Map<String , String>();
    for(var sbn in subNodes!){
      var json = jsonEncode(sbn);
      Map<String , dynamic> userMap = jsonDecode(json);
      var newn = StateScriptNode.fromJson(userMap);
      var old = newn.guid;
      newn.rebuildGuid();
      newn.moduleInterfaces.clear();
      guidMap[old] = newn.guid;
      for(var sp in newn.soports){
        var old = sp.guid;
        sp.rebuildGuid();
        guidMap[old] = sp.guid;
      }

      for(var sp in newn.sops){
        var old = sp.guid;
        sp.rebuildGuid();
        guidMap[old] = sp.guid;
      }

      scriptData.addNode(newn);
      SyncNodeData? info = newn!.getSyncData();
      // PackSolver.registerTransitionObject(newn);
      Transport.instance.sendUdpData(OPackType.O2U_MAP_SyncObject, info);

      var allFields = newn.getNodeStructType()!.getAllFields();

      // Map<String,FieldInfo> newScriptFields = Map<String,FieldInfo>();
      allFields.forEach((element) {
        var fi = newn.fieldValues[element.guid];
        if (element.typeGuid == "___scriptvar___"){
          //模块脚本变量
          var svarGuid = fi!.value.toString();
          var moduleVar = scriptData.fullScriptsFields![svarGuid];
          if (moduleVar == null) return;
          var oldVar = scriptData.scriptFieldVars.firstWhere((element) => element.name == moduleVar.name && element.typeGuid == moduleVar.typeGuid);
          if (oldVar == null){
            scriptData.scriptFieldVars.add(moduleVar);
          }
          else{
            fi.value = oldVar.guid;
          }
        }
      });
    }

    for(var sbn in subPortConnections!){
      var json = jsonEncode(sbn);
      Map<String , dynamic> userMap = jsonDecode(json);
      var newn = PortConnection.fromJson(userMap);
      newn.rebuildGuid();
      newn.inNodeGuid = guidMap[newn.inNodeGuid]??"";
      newn.outNodeGuid = guidMap[newn.outNodeGuid]??"";
      if (newn.sopGuid != null) newn.sopGuid = guidMap[newn.sopGuid]??"";

      if (newn.inNodeGuid != null && newn.outNodeGuid != null) {
        scriptData.addPortConnection(newn, recordHistory: false);
      }
    }

    for(var sbn in subParamConnections!){
      var json = jsonEncode(sbn);
      Map<String , dynamic> userMap = jsonDecode(json);
      var newn = ParamConnection.fromJson(userMap);
      newn.rebuildGuid();
      newn.inNodeGuid = guidMap[newn.inNodeGuid]??"";
      newn.outNodeGuid = guidMap[newn.outNodeGuid]??"";
      if (newn.sopGuid != null) newn.sopGuid = guidMap[newn.sopGuid]??"";

      if (newn.inNodeGuid != null && newn.outNodeGuid != null) {
        scriptData.addParamConnection(newn, recordHistory: false);
      }
    }

    for(var cn in scriptData.portConnections){
      if (guidMap[cn.inNodeGuid] != null){
        cn.inNodeGuid = guidMap[cn.inNodeGuid]??"";
      }
      if (guidMap[cn.outNodeGuid] != null){
        cn.outNodeGuid = guidMap[cn.outNodeGuid]??"";
      }
    }

    for(var cn in scriptData.paramConnections){
      if (guidMap[cn.inNodeGuid] != null){
        cn.inNodeGuid = guidMap[cn.inNodeGuid]??"";
      }
      if (guidMap[cn.outNodeGuid] != null){
        cn.outNodeGuid = guidMap[cn.outNodeGuid]??"";
      }
    }



  }
}
