

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/CodeDataExporter.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/NodeGroup.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/RefSubScript.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutParam.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutPort.dart';
import 'package:battlepus/StateScript/state_script_node_view.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/StateScript/Struct/BinaryExportExtension.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/protos/transition.pb.dart';

part 'StateScript.g.dart';

@JsonSerializable()
class StateScript extends SSObjBase implements BinaryExporter , CodeDataExporter {

  List<StateScriptNode> nodes = <StateScriptNode>[];

  @JsonKey(defaultValue: <PortConnection>[])
  List<PortConnection> portConnections = <PortConnection>[];

  @JsonKey(defaultValue: <ParamConnection>[])
  List<ParamConnection> paramConnections = <ParamConnection>[];

  @JsonKey(defaultValue: <FieldInfo>[] , name:"scriptFields")
  List<FieldInfo> scriptFieldVars = <FieldInfo>[];

  @JsonKey(defaultValue: <NodeGroup>[])
  List<NodeGroup> nodeGroups = <NodeGroup>[];

  @JsonKey(defaultValue: <RefSubScript>[])
  List<RefSubScript> subScripts = <RefSubScript>[];

  // @JsonKey(defaultValue: null)
  // Map<String,CBFunction>? functions = null;

  CBFunction? getFunction(String fid){
    // if (StateScriptProject.instance?.storeFunctionInScript??false){
    //   if (functions != null) {
    //     var func = functions![fid];
    //     if (func != null) return func;
    //   }
    // }
    // 默认从脚本拿
    // if (functions != null) {
    //   var func = functions![fid];
    //   if (func != null) {
    //     if (!(StateScriptProject.instance?.storeFunctionInScript??false)){
    //       //保存到root
    //       StateScriptProject.instance!.addFunction(func);
    //       //从脚本移除
    //       functions?.remove(fid);
    //     }
    //     return func;
    //   }
    // }
    var func =  StateScriptProject.instance!.getFunction(fid);
    // if (func != null && (StateScriptProject.instance?.storeFunctionInScript??false)){
    //   //保存在脚本
    //   if (functions == null) functions = Map<String,CBFunction>();
    //   functions![fid] = func;
    //   //从root移除，直接删除文件
    //   StateScriptProject.instance?.deleteFunction(fid);
    // }
    return func;
  }

  void removeFunction(String fid){
    // if (functions != null) {
    //   functions!.remove(fid);
    // }
    StateScriptProject.instance?.deleteFunction(fid);
  }

  CBFunction? addFunction(){
    var func = CBFunction();
    func.isAgent = true;

    // StateScriptProject.instance.addFunction(scriptInfo);

    // if (StateScriptProject.instance?.storeFunctionInScript??false){
    //   if (functions == null) functions = Map<String,CBFunction>();
    //   functions![func.guid] = func;
    //   return func;
    // }
    StateScriptProject.instance!.addFunction(func);
    return func;
  }


  Map<String , FieldInfo>? _fullScriptsFields ;


  @JsonKey(defaultValue: <String , dynamic>{})
  Map<String , FieldValueHolder> overrideFieldValues = Map<String , FieldValueHolder>();
  @JsonKey(ignore: true)
  bool nodeAddDelete = false;

  @JsonKey(ignore : true)
  Map<String , FieldInfo>? get fullScriptsFields{
    return _fullScriptsFields;
  }


  void buildScriptFieldsMap(){
    if (_fullScriptsFields == null) _fullScriptsFields = Map<String , FieldInfo>();
    _fullScriptsFields!.clear();

    for(var f in scriptFieldVars){
      _fullScriptsFields![f.guid] = f;
    }

    for(var sbs in subScripts){
      for(var f in sbs.subScriptFields!){
        _fullScriptsFields![f.guid] = f;
      }
    }
  }


  // //脚本模块接口
  // @JsonKey(defaultValue: <ModuleInterface>[])
  // List<ModuleInterface> inPorts = List<ModuleInterface>();
  // @JsonKey(defaultValue: <ModuleInterface>[])
  // List<ModuleInterface> outPorts = List<ModuleInterface>();
  // @JsonKey(defaultValue: <ModuleInterface>[])
  // List<ModuleInterface> inParams = List<ModuleInterface>();
  // @JsonKey(defaultValue: <ModuleInterface>[])
  // List<ModuleInterface> outParams = List<ModuleInterface>();



  // Map<String, dynamic> _interfaceMapping = Map<String, dynamic>();

  // void buildValidInterface() {
  //
  //   inPorts?.sort((a, b) => (a.prio ?? 512) - (b.prio ?? 512));
  //   outPorts?.sort((a, b) => (a.prio ?? 512) - (b.prio ?? 512));
  //   inParams?.sort((a, b) => (a.prio ?? 512) - (b.prio ?? 512));
  //   outParams?.sort((a, b) => (a.prio ?? 512) - (b.prio ?? 512));
  //
  //   _interfaceMapping.clear();
  //   for (int i = 0; i < inPorts.length; ++i) {
  //     var p = getInPortInterfaceTarget(i);
  //     var iid = inPorts[i].guid;
  //     if (p != null) _interfaceMapping[iid] = p.clone()
  //       ..guid = iid;
  //   }
  //   for (int i = 0; i < outPorts.length; ++i) {
  //     var p = getOutPortInterfaceTarget(i);
  //     var iid = outPorts[i].guid;
  //     if (p != null) _interfaceMapping[iid] = p.clone()
  //       ..guid = iid;
  //   }
  //   for (int i = 0; i < inParams.length; ++i) {
  //     var p = getInParamInterfaceTarget(i);
  //     var iid = inParams[i].guid;
  //     if (p != null) _interfaceMapping[iid] = p.clone()
  //       ..guid = iid;
  //   }
  //   for (int i = 0; i < outParams.length; ++i) {
  //     var p = getOutParamInterfaceTarget(i);
  //     var iid = outParams[i].guid;
  //     if (p != null) _interfaceMapping[iid] = p.clone()
  //       ..guid = iid;
  //   }
  // }

  void buildScriptGroupNodes() {
    // if (ScriptInfo.current == null) return ;
    // var sd = ScriptInfo.current.getScriptData();
    var sd = this;
    if (sd == null) return;
    Map<String, NodeGroup> groupMaps = Map<String, NodeGroup>();
    sd.nodeGroups.forEach((element) {
      groupMaps[element.guid] = element;
      element.nodes?.clear();
    });
    sd.nodes.forEach((node) {
      var groupId = node.group;
      var g = groupMaps[groupId];
      if (g != null) {
        if (g.nodes == null) g.nodes = <StateScriptNode>[];
        g.nodes!.add(node);
      }
    });
  }

  @JsonKey(ignore: true)
  Map<String, Offset> _storedPositions = Map<String, Offset>();

  void buildNodePositions() {
    _storedPositions.clear();
    for (var n in nodes) {
      var off = Offset(n.x, n.y);
      _storedPositions[n.guid] = off;
    }
  }

  @JsonKey(ignore: true)
  Map<String, Offset> _storedNewPositions = Map<String, Offset>();

  void storeNewNodePositions() {
    _storedNewPositions.clear();
    for (var n in nodes) {
      var off = Offset(n.x, n.y);
      _storedNewPositions[n.guid] = off;
    }
  }

  void forceUpdateNodePositions() {
    buildNodePositions();
  }

  void resetInitialPositions() {
    for (var n in nodes) {
      var off = _storedPositions[n.guid];
      if (off != null) {
        n.x = off.dx;
        n.y = off.dy;
      }
    }
  }

  void resetNewPositions() {
    for (var n in nodes) {
      var off = _storedNewPositions[n.guid];
      if (off != null) {
        n.x = off.dx;
        n.y = off.dy;
      }
    }
  }


  // InPort getInPortInterfaceTarget(int index) {
  //   if (index < 0 || index >= inPorts.length) return null;
  //   var interface = inPorts[index];
  //   if (interface == null) return null;
  //   if (nodeMap[interface.nodeGuid] == null) return null;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getInPort(interface.interfaceGuid);
  // }

  // OutPort getOutPortInterfaceTarget(int index) {
  //   if (index < 0 || index >= outPorts.length) return null;
  //   var interface = outPorts[index];
  //   if (interface == null) return null;
  //   if (nodeMap[interface.nodeGuid] == null) return null;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getOutPort(interface.interfaceGuid);
  // }

  // InParam getInParamInterfaceTarget(int index) {
  //   if (index < 0 || index >= inParams.length) return null;
  //   var interface = inParams[index];
  //   if (interface == null) return null;
  //   if (nodeMap[interface.nodeGuid] == null) return null;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getInParam(interface.interfaceGuid);
  // }

  // OutParam getOutParamInterfaceTarget(int index) {
  //   if (index < 0 || index >= outParams.length) return null;
  //   var interface = outParams[index];
  //   if (interface == null) return null;
  //   if (nodeMap[interface.nodeGuid] == null) return null;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getOutParam(interface.interfaceGuid);
  // }

  // ModuleInterface getInPortInterface(int index) {
  //   var interface = inPorts[index];
  //   return interface;
  // }

  // ModuleInterface getOutPortInterface(int index) {
  //   var interface = outPorts[index];
  //   return interface;
  // }

  // ModuleInterface getInParamInterface(int index) {
  //   var interface = inParams[index];
  //   return interface;
  // }

  // ModuleInterface getOutParamInterface(int index) {
  //   var interface = outParams[index];
  //   return interface;
  // }

  // void syncInterfaceExportId() {
  //   //exportId 更新了，_interfaceMapping 的 exportId同步一下
  //   for (int i = 0; i < inPorts.length; ++i) {
  //     var iid = inPorts[i].guid;
  //     _interfaceMapping[iid].exportId = inPorts[i].exportId;
  //   }
  //   for (int i = 0; i < outPorts.length; ++i) {
  //     var iid = outPorts[i].guid;
  //     _interfaceMapping[iid].exportId = outPorts[i].exportId;
  //   }
  //   for (int i = 0; i < inParams.length; ++i) {
  //     var iid = inParams[i].guid;
  //     _interfaceMapping[iid].exportId = inParams[i].exportId;
  //   }
  //
  //   // print("---------------------------------------- sync out param");
  //
  //   for (int i = 0; i < outParams.length; ++i) {
  //     var iid = outParams[i].guid;
  //     // print("---------------------------------------- sync out param exid : ${_interfaceMapping[iid].alias} = ${outParams[i].exportId}");
  //     _interfaceMapping[iid].exportId = outParams[i].exportId;
  //   }
  // }

  // InPort getRealInPortInterface(int index) {
  //   var interface = inPorts[index];
  //   return _interfaceMapping[interface.guid];
  // }

  // OutPort getRealOutPortInterface(int index) {
  //   var interface = outPorts[index];
  //   return _interfaceMapping[interface.guid];
  // }
  //
  // InParam getRealInParamInterface(int index) {
  //   var interface = inParams[index];
  //   return _interfaceMapping[interface.guid];
  // }
  //
  // OutParam getRealOutParamInterface(int index) {
  //   var interface = outParams[index];
  //   return _interfaceMapping[interface.guid];
  // }


  // String getInPortInterfaceName(int index) {
  //   var interface = inPorts[index];
  //
  //   if (interface == null) return "dummy";
  //   if (interface.name != null && interface.name.trim() != "")
  //     return interface.name;
  //   if (nodeMap[interface.nodeGuid] == null) return "dummy";
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getInPort(interface.interfaceGuid)?.getTypeShowString() ?? "dummy";
  // }

  // String getOutPortInterfaceName(int index) {
  //   var interface = outPorts[index];
  //   if (interface == null) return "dummy";
  //   if (interface.name != null && interface.name.trim() != "")
  //     return interface.name;
  //   if (nodeMap[interface.nodeGuid] == null) return "dummy";
  //
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getOutPort(interface.interfaceGuid)?.getTypeShowString() ??
  //       "dummy";
  // }

  // String getInParamInterfaceName(int index) {
  //   var interface = inParams[index];
  //   if (interface == null) return "dummy";
  //   if (interface.name != null && interface.name.trim() != "")
  //     return interface.name;
  //   if (nodeMap[interface.nodeGuid] == null) return "dummy";
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getInParam(interface.interfaceGuid)?.getTypeShowString() ??
  //       "dummy";
  // }

  // String getOutParamInterfaceName(int index) {
  //   var interface = outParams[index];
  //   if (interface == null) return "dummy";
  //   if (interface.name != null && interface.name.trim() != "")
  //     return interface.name;
  //   if (nodeMap[interface.nodeGuid] == null) return "dummy";
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getOutParam(interface.interfaceGuid)?.getTypeShowString() ??
  //       "dummy";
  // }

  // bool isValidInPortInterface(ModuleInterface interface){
  //   if (interface == null) return false;
  //   if (nodeMap[interface.nodeGuid] == null) return false;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getInPort(interface.interfaceGuid) != null;
  // }
  // bool isValidOutPortInterface(ModuleInterface interface){
  //   if (interface == null) return false;
  //   if (nodeMap[interface.nodeGuid] == null) return false;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getOutPort(interface.interfaceGuid) != null;
  // }
  // bool isValidInParamInterface(ModuleInterface interface){
  //   if (interface == null) return false;
  //   if (nodeMap[interface.nodeGuid] == null) return false;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getInParam(interface.interfaceGuid) != null;
  // }
  // bool isValidOutParamInterface(ModuleInterface interface){
  //   if (interface == null) return false;
  //   if (nodeMap[interface.nodeGuid] == null) return false;
  //   var td = nodeMap[interface.nodeGuid].getNodeStructType();
  //   return td.getOutParam(interface.interfaceGuid) != null;
  // }
  // bool registerInPortInterface(ModuleInterface interface) {
  //   inPorts = inPorts ?? List<ModuleInterface>();
  //   inPorts.add(interface);
  //   buildValidInterface();
  //   return true;
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (!isValidInPortInterface(inPorts[i])){
  //   //     inPorts[i] = interface;
  //   //     buildValidInterface();
  //   //     return true;
  //   //   }
  //   // }
  //   // return false;
  // }

  // void unregisterInPortInterface(ModuleInterface interface) {
  //   if (inPorts == null) return;
  //   inPorts.remove(interface);
  //   buildValidInterface();
  //   // if (inPorts == null)return;
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (inPorts[i] == interface){
  //   //     inPorts[i] = null;
  //   //   }
  //   // }
  //   // buildValidInterface();
  // }

  // bool registerOutPortInterface(ModuleInterface interface) {
  //   outPorts = outPorts ?? List<ModuleInterface>();
  //   outPorts.add(interface);
  //   buildValidInterface();
  //   return true;
  //   // while (outPorts == null || outPorts.length < SSDefines.interfaceMaxCount){
  //   //   outPorts = outPorts??List<ModuleInterface>();
  //   //   outPorts.add(null);
  //   // }
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (!isValidOutPortInterface(outPorts[i])){
  //   //     outPorts[i] = interface;
  //   //     buildValidInterface();
  //   //     return true;
  //   //   }
  //   // }
  //   // return false;
  // }

  // void unregisterOutPortInterface(ModuleInterface interface) {
  //   if (outPorts == null) return;
  //   outPorts.remove(interface);
  //   buildValidInterface();
  //   // if (outPorts == null)return;
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (outPorts[i] == interface){
  //   //     outPorts[i] = null;
  //   //   }
  //   // }
  // }

  // bool registerInParamInterface(ModuleInterface interface) {
  //   inParams = inParams ?? List<ModuleInterface>();
  //   inParams.add(interface);
  //   buildValidInterface();
  //   return true;
  //   // while (inParams == null || inParams.length < SSDefines.interfaceMaxCount){
  //   //   inParams = inParams??List<ModuleInterface>();
  //   //   inParams.add(null);
  //   // }
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (!isValidInParamInterface(inParams[i])){
  //   //     inParams[i] = interface;
  //   //     buildValidInterface();
  //   //     return true;
  //   //   }
  //   // }
  //   // return false;
  // }

  // void unregisterInParamInterface(ModuleInterface interface) {
  //   if (inParams == null) return;
  //   inParams.remove(interface);
  //   buildValidInterface();
  //   // if (inParams == null)return;
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (inParams[i] == interface){
  //   //     inParams[i] = null;
  //   //   }
  //   // }
  // }

  // bool registerOutParamInterface(ModuleInterface interface) {
  //   outParams = outParams ?? List<ModuleInterface>();
  //   outParams.add(interface);
  //   buildValidInterface();
  //   return true;
  //   // while (outParams == null || outParams.length < SSDefines.interfaceMaxCount){
  //   //   outParams = outParams??List<ModuleInterface>();
  //   //   outParams.add(null);
  //   // }
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (!isValidOutParamInterface(outParams[i])){
  //   //     outParams[i] = interface;
  //   //     buildValidInterface();
  //   //     return true;
  //   //   }
  //   // }
  //   // return false;
  // }

  // void unregisterOutParamInterface(ModuleInterface interface) {
  //   if (outParams == null) return;
  //   outParams.remove(interface);
  //   buildValidInterface();
  //   // if (outParams == null)return;
  //   // for(var i = 0 ; i < SSDefines.interfaceMaxCount ; ++i){
  //   //   if (outParams[i] == interface){
  //   //     outParams[i] = null;
  //   //   }
  //   // }
  // }

  // void clearModuleInterface() {
  //   for (int i = inPorts.length - 1; i >= 0; --i) {
  //     var p = getInPortInterfaceTarget(i);
  //     if (p == null) inPorts.removeAt(i);
  //   }
  //   for (int i = outPorts.length - 1; i >= 0; --i) {
  //     var p = getOutPortInterfaceTarget(i);
  //     if (p == null) outPorts.removeAt(i);
  //   }
  //   for (int i = inParams.length - 1; i >= 0; --i) {
  //     var p = getInParamInterfaceTarget(i);
  //     if (p == null) inParams.removeAt(i);
  //   }
  //   for (int i = outParams.length - 1; i >= 0; --i) {
  //     var p = getOutParamInterfaceTarget(i);
  //     if (p == null) outParams.removeAt(i);
  //   }
  //
  //   buildValidInterface();
  // }

  // void unregisterInterface(ModuleInterface interface) {
  //   unregisterInParamInterface(interface);
  //   unregisterInPortInterface(interface);
  //   unregisterOutParamInterface(interface);
  //   unregisterOutPortInterface(interface);
  //
  //   buildValidInterface();
  // }

  NodeGroup? getGroup(String guid) {
    for (var g in nodeGroups) {
      if (g.guid == guid) {
        return g;
      }
    }
    return null;
  }

  static StateScript? exportingScript;

//  void addField(FieldInfo fi){
//    if (scriptFields.contains(fi)) return ;
//    scriptFields.add(fi);
//  }
  FieldInfo addField() {
    var fi = FieldInfo();
    scriptFieldVars.add(fi);
    buildScriptFieldsMap();
    return fi;
  }

  void removeField(FieldInfo fi) {
    scriptFieldVars.remove(fi);
    buildScriptFieldsMap();
  }

  @JsonKey(ignore: true)
  Map<String, StateScriptNode>? _nodeMap;

  @JsonKey(ignore: true)
  Map<String, int> _connectionCounts = Map<String, int>();

  void addPortConnectionCount(PortConnection pc) {
    {
      var keyOut = "${pc.outNodeGuid}_${pc.outPortGuid}";
      var count = _connectionCounts[keyOut] ?? 0;
      count++;
      _connectionCounts[keyOut] = count;
    }
    {
      var keyIn = "${pc.inNodeGuid}_${pc.inPortGuid}";
      var count = _connectionCounts[keyIn] ?? 0;
      count++;
      _connectionCounts[keyIn] = count;
    }
  }

  void removePortConnectionCount(PortConnection pc) {
    {
      var keyOut = "${pc.outNodeGuid}_${pc.outPortGuid}";
      var count = _connectionCounts[keyOut] ?? 0;
      if (count > 0) {
        count--;
        _connectionCounts[keyOut] = count;
      }
    }
    {
      var keyIn = "${pc.inNodeGuid}_${pc.inPortGuid}";
      var count = _connectionCounts[keyIn] ?? 0;
      if (count > 0) {
        count--;
        _connectionCounts[keyIn] = count;
      }
    }
  }

  void addParamConnectionCount(ParamConnection pc) {
    {
      var keyOut = "${pc.outNodeGuid}_${pc.outParamGuid}";
      var count = _connectionCounts[keyOut] ?? 0;
      count++;
      _connectionCounts[keyOut] = count;
    }
    {
      var keyIn = "${pc.inNodeGuid}_${pc.inParamGuid}";
      var count = _connectionCounts[keyIn] ?? 0;
      count++;
      _connectionCounts[keyIn] = count;
    }
  }

  void removeParamConnectionCount(ParamConnection pc) {
    {
      var keyOut = "${pc.outNodeGuid}_${pc.outParamGuid}";
      var count = _connectionCounts[keyOut] ?? 0;
      if (count > 0) {
        count--;
        _connectionCounts[keyOut] = count;
      }
    }
    {
      var keyIn = "${pc.inNodeGuid}_${pc.inParamGuid}";
      var count = _connectionCounts[keyIn] ?? 0;
      if (count > 0) {
        count--;
        _connectionCounts[keyIn] = count;
      }
    }
  }

  void initConnectionCount() {
    _connectionCounts.clear();
    portConnections.forEach((element) {
      addPortConnectionCount(element);
    });
    paramConnections.forEach((element) {
      addParamConnectionCount(element);
    });


    for(var sb in subScripts){
      if (sb.subPortConnections != null) {
        for (var c in sb.subPortConnections!) {
          addPortConnectionCount(c);
        }
      }
      if (sb.subParamConnections != null) {
        for (var c in sb.subParamConnections!) {
          addParamConnectionCount(c);
        }
      }
    }
    // print(_connectionCounts);
  }

  void refreshNodeMap() {
    _nodeMap = Map<String, StateScriptNode>();
    for (var n in nodes) {
      n.scriptName = name;
      n.scriptId = exportId;
      _nodeMap![n.guid] = n;
    }

    for(var sbs in subScripts){
      if (sbs.subNodes != null) {
        for (var n in sbs.subNodes!) {
          n.scriptName = name;
          n.scriptId = exportId;
          _nodeMap![n.guid] = n;
        }
      }
    }
  }

  void addNode(StateScriptNode node) {
    if (!nodes.contains(node)) {
      nodes.add(node);
    }

    SSObjBase.buildExportId(nodes);

    nodeAddDelete = true;
    refreshNodeMap();
  }

  void deleteNode(StateScriptNode node) {
    nodeAddDelete = true;
    for (int i = paramConnections.length - 1; i >= 0; i--) {
      var c = paramConnections[i];
      var outNode = nodeMap![c.outNodeGuid];
      var inNode = nodeMap![c.inNodeGuid];
      if (outNode == node || inNode == node) {
//        print("remove param $i");
        paramConnections.removeAt(i);
        removeParamConnectionCount(c);
//        removeParamConnection(c);
      }
    }
    for (int i = portConnections.length - 1; i >= 0; i--) {
      var c = portConnections[i];
      var outNode = nodeMap![c.outNodeGuid];
      var inNode = nodeMap![c.inNodeGuid];
      if (outNode == node || inNode == node) {
//        print("remove param $i");
        portConnections.removeAt(i);
        removePortConnectionCount(c);
//        removeParamConnection(c);
      }
    }
    // var tp = node.getNodeStructType();
    // var funcField = tp.getFieldByTypeGuid("___agentfunction___");
    // if (funcField != null){
    //   var fv = node.fieldValues[funcField.guid]?.value;
    //   if (fv != null){
    //     StateScriptProject.instance.functions.removeWhere((element) => element.guid == fv);
    //   }
    // }
    nodes.remove(node);
    refreshNodeMap();
    // buildValidInterface();
  }

  Map<String, StateScriptNode>? get nodeMap {
    if (_nodeMap == null) refreshNodeMap();
    return _nodeMap;
  }

  bool addPortConnection(PortConnection con, {SubstituteOutPort? sop, bool recordHistory = true}) {
    for (var c in portConnections) {
      if (c == con) return false;
      if (c.outPortGuid == con.outPortGuid && c.outNodeGuid == con.outNodeGuid && c.inPortGuid == con.inPortGuid && c.inNodeGuid == con.inNodeGuid) {
        if ((c.sopGuid == null || c.sopGuid.trim() == "" || nodeMap![c.outNodeGuid]!.getSOPort(c.sopGuid) == null) && sop != null) {
          con.buildLongGuid();
          if (recordHistory) HistoryManager.scriptHistory.appendHistory();
          c.sopGuid = sop.guid;
          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          return true;
        }
        return false;
      }
    }

    con.buildLongGuid();
    if (recordHistory) HistoryManager.scriptHistory.appendHistory();
    // con.lineColor = CommonUtil.alphaColor(Colors.blue, 180).value;
    portConnections.add(con);
    addPortConnectionCount(con);
    EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    var n1 = nodeMap![con.outNodeGuid];
    EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n1);
    var n2 = nodeMap![con.inNodeGuid];
    EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n2);
    tryRuntimeRefresh(n1!);
    return true;
  }

  void removePortConnection(PortConnection con) {
    portConnections.remove(con);
    removePortConnectionCount(con);
    EventCenter.eventBus.fire(RefreshConnectCommandEvent()
      ..openChanged = true);
    EventCenter.eventBus.fire(GlobalRefreshEvent());
    var n1 = nodeMap![con.outNodeGuid];
    if (n1 != null) {
      tryRuntimeRefresh(n1);
    }
  }

  bool addParamConnection(ParamConnection con, {SubstituteOutParam? sop, bool recordHistory = true}) {
    for (var c in paramConnections) {
      if (c == con) return false;

      if (nodeMap!.containsKey(c.outNodeGuid) &&
          nodeMap!.containsKey(c.inNodeGuid))
//      if ((c.outParamGuid == con.outParamGuid && c.outNodeGuid == con.outNodeGuid) ||
        if (
        (c.inParamGuid == con.inParamGuid && c.inNodeGuid == con.inNodeGuid)) {
          if ((c.sopGuid == null || c.sopGuid.trim() == "" ||
              nodeMap![c.outNodeGuid]!.getSOP(c.sopGuid) == null) &&
              sop != null) {
            // con.guid = "${con.outParamGuid}_${con.inParamGuid}";
            con.buildLongGuid();
            if (recordHistory) HistoryManager.scriptHistory.appendHistory();
            c.sopGuid = sop.guid;

            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
            return true;
          }

          return false;
        }
    }

    con.buildLongGuid();
    if (recordHistory) HistoryManager.scriptHistory.appendHistory();
    // con.lineColor = CommonUtil.alphaColor(Colors.green, 180).value;
    paramConnections.add(con);
    addParamConnectionCount(con);
    EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
    var n1 = nodeMap![con.outNodeGuid];
    EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()
      ..node = n1);

    var n2 = nodeMap![con.inNodeGuid];
    EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()
      ..node = n2);

    tryRuntimeRefresh(n2!);
    return true;
  }

  void tryRuntimeRefresh(StateScriptNode outNode) {
    //battlepus runtime 实时更新
    // print(RunSession.instance.remoteIsPlaying);
    if (RunSession.instance.remoteIsPlaying) {
      if (ScriptInfo.current != null) {
        var scriptHashCode = ScriptInfo.current!.guid.hashCode;
        var nodeId = outNode.exportId;
        collectPortOut(outNode);

        RunSession.instance.sendRuntimeRefreshScriptData(ScriptInfo.current);

        // RunSession.instance.sendRuntimeRefreshNodeData(
        //     scriptHashCode, nodeId, outNode);
      }
    }
  }


  void removeParamConnection(ParamConnection con) {
    paramConnections.remove(con);
    removeParamConnectionCount(con);
    EventCenter.eventBus.fire(RefreshConnectCommandEvent()
      ..openChanged = true);
    EventCenter.eventBus.fire(GlobalRefreshEvent());

    var n1 = nodeMap![con.inNodeGuid];
    if (n1 != null) {
      tryRuntimeRefresh(n1);
    }
  }

  void replaceConnectGuid() {
    for (var c in portConnections) {
      c.buildLongGuid();
    }
    for (var c in paramConnections) {
      c.buildLongGuid();
    }
  }

  StateScript();

  //此处与类名一致，由指令自动生成代码
  factory StateScript.fromJson(Map<String, dynamic> json) =>
      _$StateScriptFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$StateScriptToJson(this);

  @JsonKey(ignore: true)
  var defaultTypes = {
    "___int___": true,
    "___uint___": true,
    "___float___": true,
    "___double___": true,
    "___string___": true,
    "___bool___": true,

  };

  @override
  void export(ByteDataWriter bw, {int hash = 0}) {
    print("------------------------------------------------ export script : $name");
//    SSObjBase.buildExportId(nodes);
    bw.writeString(name, "script name : ${name}");
    bw.writeUint32(exportId, "script id : ${exportId}");
    bw.writeUint32(hash, "script hash id : $hash");

    //global vars
    int iAgentCount = 0;
    for (var com in StateScriptProject.instance!.components) {
      for (var f in com.fields) {
        var ft = SSFieldType.getFieldType(f.typeGuid);
        if (!defaultTypes.containsKey(ft!.guid)) {
          continue;
        }
        ++iAgentCount;
      }
    }
    bw.writeUint32(iAgentCount, "agent script var count : ${iAgentCount}");
    for (var com in StateScriptProject.instance!.components) {
      for (var f in com.fields) {
        var ft = SSFieldType.getFieldType(f.typeGuid);
        if (!defaultTypes.containsKey(ft!.guid)) {
          continue;
        }
        bw.writeUint32(f.exportId, "agent script var id : ${f.name}");
        // print ("${ft.name} ft.exportId = ${ft.exportId}");
        bw.writeInt8(ft.exportId, "agent var type id : ${ft.exportId}");
        ft.exportFlag = "default value";
        ft.export(bw, f.defaultValue);
      }
    }
    var scriptFields =  scriptFieldVars??<FieldInfo>[];
    bw.writeUint32(scriptFields.length, "script var count : ${scriptFields.length}");
    for (var f in scriptFields) {
      bw.writeUint32(f.exportId, "script var id : ${f.name}");
      var ft = SSFieldType.getFieldType(f.typeGuid);
      print("${ft!.name} ft.exportId = ${ft!.exportId}");
      bw.writeInt8(ft.exportId, "var type id : ${ft.exportId}");
      ft.exportFlag = "default value";
      ft.export(bw, f.defaultValue);
    }


    //模块接口
    // bw.writeUint32(inPorts.length, "inport count id : ${inPorts.length}");
    // for (int i = 0; i < inPorts.length; ++i) {
    //   var p = inPorts[i];
    //   var nodeGuid = p.nodeGuid;
    //   var node = nodeMap[nodeGuid];
    //   var tgt = getInPortInterfaceTarget(i);
    //   bw.writeUint32(p.exportId, "interface id : ${p.exportId}");
    //   bw.writeUint32(tgt.exportId, "inport : interface id : ${tgt.exportId}");
    //   bw.writeUint32(node.exportId, "inport : node id : ${node.exportId}");
    // }

    // bw.writeUint32(outPorts.length, "outport count id : ${outPorts.length}");
    // for (int i = 0; i < outPorts.length; ++i) {
    //   var p = outPorts[i];
    //   var nodeGuid = p.nodeGuid;
    //   var node = nodeMap[nodeGuid];
    //   var tgt = getOutPortInterfaceTarget(i);
    //   bw.writeUint32(p.exportId, "interface id : ${p.exportId}");
    //   bw.writeUint32(tgt.exportId, "outport : interface id : ${tgt.exportId}");
    //   bw.writeUint32(node.exportId, "outport : node id : ${node.exportId}");
    // }

    // bw.writeUint32(inParams.length, "inparam count id : ${inParams.length}");
    // for (int i = 0; i < inParams.length; ++i) {
    //   var p = inParams[i];
    //   var nodeGuid = p.nodeGuid;
    //   var node = nodeMap[nodeGuid];
    //   var tgt = getInParamInterfaceTarget(i);
    //   bw.writeUint32(p.exportId, "interface id : ${p.exportId}");
    //   bw.writeUint32(tgt.exportId, "inparam : interface id : ${tgt.exportId}");
    //   bw.writeUint32(node.exportId, "inparam : node id : ${node.exportId}");
    // }
    // bw.writeUint32(outParams.length, "outparam count id : ${inParams.length}");
    // for (int i = 0; i < outParams.length; ++i) {
    //   var p = outParams[i];
    //   var nodeGuid = p.nodeGuid;
    //   var node = nodeMap[nodeGuid];
    //   var tgt = getOutParamInterfaceTarget(i);
    //   bw.writeUint32(p.exportId, "interface id : ${p.exportId}");
    //   bw.writeUint32(tgt.exportId, "outparam : interface id : ${tgt.exportId}");
    //   bw.writeUint32(node.exportId, "outparam : node id : ${node.exportId}");
    // }

    // print("1 active node count : ${exportNodes.length}");
    var activeNodes = exportNodes!.where((e) {
      if (e.moduleInterfaces.length>0) return true;
      return e.active == true;
    });
    // print("2 active node count : ${activeNodes.length}");
    bw.writeUint32(activeNodes.length, "node count : ${activeNodes.length}");
    for (var n in activeNodes) {
//      bw.writeUint32(n.exportId ,"node id : ${n.exportId}");
//      var nodeStruct = n.getNodeStructType();
//      bw.writeUint32(nodeStruct.exportId ,"node type : ${nodeStruct.exportId}");
      bw.pushIdentLevel();
      print("export node : ${n.exportId} of ${n.getNodeStructType()!.name}");
      exportingScript = this;
      n.export(bw);
      bw.popIdentLevel();
    }
    List<RefSubScript> exportSubScripts = <RefSubScript>[];
    exportSubScripts.addAll(subScripts);
    exportSubScripts.sort((a,b){
      return a.exportId! - b.exportId!;
    });
    bw.writeUint32(exportSubScripts.length, "module count : ${exportSubScripts.length}");
    exportSubScripts.forEach((element) {
      bw.writeUint32(element.exportId, "module id : ${element.exportId}");
      var scriptInfo = null;
      for (var sp in   StateScriptProject.instance!.scripts){
        if(sp.guid == element.scriptId){
          scriptInfo = sp;
          break;
        }
      }
      if (scriptInfo != null){
        // bw.writeUint32(scriptInfo.exportId, "script id : ${scriptInfo.exportId}");
        // print("export module name : ${scriptInfo.name}");
        bw.writeString(scriptInfo.name, "script name : ${scriptInfo.name}");
      }
      else{
        bw.writeString("", "script name : 未指定");
      }
    });
  }


  bool _portConnectionValid(PortConnection c) {
    var outNode = nodeMap![c.outNodeGuid];
    var inNode = nodeMap![c.inNodeGuid];
    if (outNode == null || inNode == null) return false;

    if (outNode.isModuleNode && !inNode.isModuleNode && (!outNode.isRootModuleNode ||!outNode.moduleInterfaces.containsKey(c.outPortGuid))){
      return false;
    }
    if (inNode.isModuleNode && !outNode.isModuleNode && (!inNode.isRootModuleNode ||!inNode.moduleInterfaces.containsKey(c.inPortGuid))){
      return false;
    }

    var pout = outNode.findOutPort(this, c.outPortGuid);
    var pin = inNode.findInPort(this, c.inPortGuid);
    if (pout == null || pin == null ) return false;
    return true;
  }

  bool _paramConnectionValid(ParamConnection c) {
    var outNode = nodeMap![c.outNodeGuid];
    var inNode = nodeMap![c.inNodeGuid];


    if (outNode == null || inNode == null) return false;
    if (outNode.isModuleNode && !inNode.isModuleNode && (!outNode.isRootModuleNode ||!outNode.moduleInterfaces.containsKey(c.outParamGuid))){
      return false;
    }
    if (inNode.isModuleNode && !outNode.isModuleNode && (!inNode.isRootModuleNode ||!inNode.moduleInterfaces.containsKey(c.inParamGuid))){
      return false;
    }
    var pout = outNode.findOutParam(this, c.outParamGuid);
    var pin = inNode.findInParam(this, c.inParamGuid);
    if (pout == null || pin == null || !StateScriptNodeViewState.isTypeCanLink(inNode,pin,pout)) return false;
    return true;
  }

  ///清理野对象
  void clean() {
    // loadSubScripts();

    var allNodes = nodes; //_nodeMap.values.toList();
    var nodeCount = allNodes.length;
    for (int i = nodeCount - 1; i >= 0; --i) {
      var node = allNodes[i];
      // node.exportId = null;
      if (!node.isNodeTypeValid()) {
        ///清理 node
        allNodes.removeAt(i);
        continue;
      }
      var tp = node.getNodeStructType();
      List<String> _invalidFields = <String>[];
      node.fieldValues.forEach((key, value) {
        if (!tp!.hasField(key)) {
          _invalidFields.add(key);
        }
      });

      ///清理字段
      _invalidFields.forEach((key) {
        node.fieldValues.remove(key);
      });
    }
    allNodes.sort((a, b) {
      return a.guid.compareTo(b.guid);
    });

    refreshNodeMap();

    // clearModuleInterface();
    //清理无效连接线
    var portConnectCount = portConnections.length;
    for (int i = portConnectCount - 1; i >= 0; --i) {
      var con = portConnections[i];
      if (!_portConnectionValid(con)) {
        portConnections.removeAt(i);
      }
    }

    portConnections.sort((a, b) {
      return a.guid.compareTo(b.guid);
    });

    var paramConnectCount = paramConnections.length;
    for (int i = paramConnectCount - 1; i >= 0; --i) {
      var con = paramConnections[i];
      if (!_paramConnectionValid(con)) {
        paramConnections.removeAt(i);
      }
    }

    paramConnections.sort((a, b) {
      return a.guid.compareTo(b.guid);
    });
  }

  @JsonKey(ignore:true)
  List<StateScriptNode>? exportNodes ;//= List<StateScriptNode>();
  @JsonKey(ignore:true)
  List<PortConnection> exportPortConnections = <PortConnection>[];
  @JsonKey(ignore:true)
  List<ParamConnection> exportParamConnections = <ParamConnection>[];

  void prepareNodeId(){
    clean();
    exportNodes = _nodeMap!.values.toList();

    for (int i = exportNodes!.length - 1; i >= 0; --i) {
      var node = exportNodes![i];
      // node.exportId = null;
      if (!node.isNodeTypeValid() || (!(StateScriptProject.instance!.debugExport??false) && node.getNodeStructType()!.isDebugNode)) {
        //清理 node
        //如果是 release 模式, debug 节点也移除
        exportNodes!.removeAt(i);
        continue;
      }
      // if (SSUserData.instance.debugMode.is)
      var tp = node.getNodeStructType();
      List<String> _invalidFields = <String>[];
      node.fieldValues.forEach((key, value) {
        if (!tp!.hasField(key)) {
          _invalidFields.add(key);
        }
      });

      ///清理字段
      _invalidFields.forEach((key) {
        node.fieldValues.remove(key);
      });
    }

    for (var i = 0; i < exportNodes!.length; ++i) {
      exportNodes![i].active = false;
    }

    exportPortConnections.clear();
    exportParamConnections.clear();
    exportPortConnections.addAll(portConnections);
    exportParamConnections.addAll(paramConnections);

    Map<String,bool> overrideNodes = Map<String,bool>();
    overrideFieldValues.forEach((key, value) {
      if (key.length<37) return ;
      var nodeKey = key.substring(0,key.length-37);
      var fieldKey = key.substring(key.length-36,key.length);

      // print("---------------------------------------------------------------------------------------------- override field node : $key");
      // print("---------------------------------------------------------------------------------------------- override field node : $nodeKey");
      // print("---------------------------------------------------------------------------------------------- override field node : $fieldKey");
      var node = nodeMap![nodeKey];
      if (node != null){
        var fv = node.fieldValues[fieldKey];
        if (fv?.value != value?.value){
          overrideNodes[nodeKey] = true;
        }
      }
    });

    portConnections.forEach((element) {
      var outNode = nodeMap![element.outNodeGuid];
      if (outNode != null && outNode.isModuleNode){
        overrideNodes[outNode.guid] = true;
      }
    });

    paramConnections.forEach((element) {
      var inNode = nodeMap![element.inNodeGuid];
      if (inNode != null && inNode.isModuleNode){
        overrideNodes[inNode.guid] = true;
      }
    });


    for(var sbs in subScripts){
      if (sbs.subPortConnections != null) exportPortConnections.addAll(sbs.subPortConnections!);
      if (sbs.subParamConnections != null) exportParamConnections.addAll(sbs.subParamConnections!);
    }

    for (var i = exportPortConnections.length-1 ; i>=0 ;--i) {
      var con = exportPortConnections[i];
      var onguid = con.outNodeGuid;
      var node = nodeMap![onguid];
      var nodeIn = nodeMap![con.inNodeGuid];
      if (node == null || nodeIn == null) { exportPortConnections.removeAt(i);continue;}
      node.active = true;
      nodeIn.active = true;
    }

    for (var i = exportParamConnections.length-1 ; i>=0 ;--i) {
      var con = exportParamConnections[i];
      var innode = nodeMap![con.inNodeGuid];
      var outnode = nodeMap![con.outNodeGuid];
      if (innode == null || outnode == null) { exportParamConnections.removeAt(i);continue;}
      innode.active = true;
      outnode.active = true;
    }

    //不再排序
    // exportNodes.sort((a, b) {
    //   var ta = StateScriptProject.instance.structMap[a.nodeTypeGuid];
    //   var tb = StateScriptProject.instance.structMap[b.nodeTypeGuid];
    //   var pa = ta.getWithUpdateLogic() ? 0 : 1024000000000;
    //   var pb = tb.getWithUpdateLogic() ? 0 : 1024000000000;
    //   if (!a.active) pa += 10000000000000;
    //   if (!b.active) pb += 10000000000000;
    //   if (pa == pb) {
    //     return ta.guid.compareTo(tb.guid);
    //   }
    //   return pa - pb;
    // });

    //不再导出模块节点，移除
    //重载过属性的结点，连接过参数，outPort有链接的，导出到父脚本
    for(var i = exportNodes!.length-1 ; i>=0 ; --i){
      if (exportNodes![i].isModuleNode && overrideNodes[exportNodes![i].guid] == null){
        exportNodes!.removeAt(i);
      }
    }

    //必须有，结点ID有可能重复，导出前需要先过一遍ID，然后再次reload模块
    SSObjBase.buildExportId(exportNodes!);
    // print("node count : ${exportNodes.length}");
    for (var i = 0; i < exportNodes!.length; ++i) {
      //不再动态指定ID
      // exportNodes[i].exportId = i;

      exportNodes![i].outPortDatas = null;
      exportNodes![i].inParamDatas = null;

      exportNodes![i].active = false;
    }

    exportPortConnections.sort((a, b) {
      var nodeInA = nodeMap![a.inNodeGuid];
      var nodeInB = nodeMap![b.inNodeGuid];

      return nodeInA!.getSortY().compareTo(nodeInB!.getSortY());
    });

    //connection id , 使用全局 hash id来处理
    //StateScriptProject 外侧已处理
    // SSObjBase.buildHashExportId(exportPortConnections);
    // SSObjBase.buildHashExportId(exportParamConnections);

    // exportPortConnections.forEach((element) {
    //   if (element.exportId != null) return;
    //   element.exportId = StateScriptProject.connectionIdMap[element.guid];
    // });
    // exportParamConnections.forEach((element) {
    //   if (element.exportId != null) return;
    //   element.exportId = StateScriptProject.connectionIdMap[element.guid];
    // });

    //脚本变量定义采用全局设置，每个变量唯一id，不在脚本独立导出，与agent var一起导出ssinit.bytes
    //脚本变量引进 VarPool<int,T> id = StateScript 实例Id << 16 + 变量 id
    // var fields = fullScriptsFields?.values?.toList();
    // if (fields != null){
    //   fields.sort((a,b)=>a.guid.compareTo(b.guid));
    //   int iCountIndex = 0;
    //   fields.forEach((element) {element.exportId = iCountIndex++;});
    // }
  }
  void prepareBinaryExport() {
    prepareNodeId();
    // collectPortOut();
    // ///搜集 outport
    for (var con in exportPortConnections) {
      var onguid = con.outNodeGuid;
      var node = nodeMap![onguid];
      var nodeIn = nodeMap![con.inNodeGuid];
      node!.active = true;
      nodeIn!.active = true;

      if (node.isModuleNode && !nodeIn.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(con.outPortGuid))){
        continue;
      }
      if (nodeIn.isModuleNode && !node.isModuleNode && (!nodeIn.isRootModuleNode ||!nodeIn.moduleInterfaces.containsKey(con.inPortGuid))){
        continue;
      }

      print("active node : ${node.exportId}");
      print("active node : ${nodeIn.exportId}");
      OutPort? outport = node.findOutPort(this, con.outPortGuid);
      InPort? inport = nodeIn.findInPort(this, con.inPortGuid);

      if (outport == null || inport == null) continue;
      node.addOutPortLink(con.outPortGuid, nodeIn.exportId!, inport!.exportId!, node.exportId!, outport!.exportId!, con.exportId , node , nodeIn , outport! , inport!);
    }



    ///搜集 inparam
    for (var con in exportParamConnections) {
      var innode = nodeMap![con.inNodeGuid];
      var outnode = nodeMap![con.outNodeGuid];
      innode!.active = true;
      outnode!.active = true;
      if (outnode.isModuleNode && !innode.isModuleNode && (!outnode.isRootModuleNode ||!outnode.moduleInterfaces.containsKey(con.outParamGuid))){
        continue;
      }
      if (innode.isModuleNode && !outnode.isModuleNode && (!innode.isRootModuleNode ||!innode.moduleInterfaces.containsKey(con.inParamGuid))){
        continue;
      }
      print("active node : ${innode.exportId}");
      print("active node : ${outnode.exportId}");
      OutParam? op = outnode.findOutParam(this, con.outParamGuid);
      InParam? ip = innode.findInParam(this, con.inParamGuid);
      if (op == null || ip == null) continue;
      innode.addInParamLink(con.inParamGuid, outnode.exportId!, op.exportId!, innode.exportId!, ip.exportId!, con.exportId , outnode , innode , op , ip);
    }
  }
//   void prepareBinaryExport2() {
//     clean();
//
//     for (var i = 0; i < nodes.length; ++i) {
//       nodes[i].active = false;
//     }
//
//     for (var con in portConnections) {
//       var onguid = con.outNodeGuid;
//       var node = nodeMap[onguid];
//       var nodeIn = nodeMap[con.inNodeGuid];
//       node.active = true;
//       nodeIn.active = true;
//     }
//     for (var con in paramConnections) {
//       var innode = nodeMap[con.inNodeGuid];
//       var outnode = nodeMap[con.outNodeGuid];
//       innode.active = true;
//       outnode.active = true;
//     }
// //
// //
// //    for(var i = 0 ; i < nodes.length ; ++i){
// //      nodes[i].exportId = i;
// //      nodes[i].outPortDatas = null;
// //      nodes[i].inParamDatas = null;
// //
// //    }
//
//     nodes.sort((a, b) {
//       var ta = StateScriptProject.instance.structMap[a.nodeTypeGuid];
//       var tb = StateScriptProject.instance.structMap[b.nodeTypeGuid];
//       var pa = ta.getWithUpdateLogic() ? 0 : 1024000000000;
//       var pb = tb.getWithUpdateLogic() ? 0 : 1024000000000;
//       if (!a.active) pa += 10000000000000;
//       if (!b.active) pb += 10000000000000;
//       if (pa == pb) {
//         return ta.guid.compareTo(tb.guid);
//       }
//       return pa - pb;
//     });
//
//     for (var i = 0; i < nodes.length; ++i) {
//       nodes[i].exportId = i;
//
//       nodes[i].outPortDatas = null;
//       nodes[i].inParamDatas = null;
//
//       nodes[i].active = false;
//     }
//     portConnections.sort((a, b) {
//       var nodeInA = nodeMap[a.inNodeGuid];
//       var nodeInB = nodeMap[b.inNodeGuid];
//       return nodeInA.y.compareTo(nodeInB.y);
//     });
//     SSObjBase.buildExportId(portConnections);
//     // collectPortOut();
//     // ///搜集 outport
//     for (var con in portConnections) {
//       var onguid = con.outNodeGuid;
//       var node = nodeMap[onguid];
//       var nodeIn = nodeMap[con.inNodeGuid];
//       node.active = true;
//       nodeIn.active = true;
//       OutPort outport = node.findOutPort(this, con.outPortGuid);
//       InPort inport = nodeIn.findInPort(this, con.inPortGuid);
//       node.addOutPortLink(con.outPortGuid, nodeIn.exportId, inport.exportId, node.exportId, outport.exportId, con.exportId);
//     }
//
//     SSObjBase.buildExportId(paramConnections);
//
//     ///搜集 inparam
//     for (var con in paramConnections) {
//       var innode = nodeMap[con.inNodeGuid];
//       var outnode = nodeMap[con.outNodeGuid];
//       innode.active = true;
//       outnode.active = true;
//       OutParam op = outnode.findOutParam(this, con.outParamGuid);
//       InParam ip = innode.findInParam(this, con.inParamGuid);
//       innode.addInParamLink(con.inParamGuid, outnode.exportId, op.exportId, innode.exportId, ip.exportId, con.exportId);
//     }
//   }

  void collectPortOut(StateScriptNode tgtNode) {
    tgtNode.outPortDatas = null;
    tgtNode.inParamDatas = null;
    SSObjBase.buildHashExportId(portConnections);
    for (var con in portConnections) {
      var onguid = con.outNodeGuid;
      var node = nodeMap![onguid];
      if (tgtNode == node) {
        var nodeIn = nodeMap![con.inNodeGuid];
        OutPort? outport = node!.findOutPort(this, con.outPortGuid);
        InPort? inport = nodeIn!.findInPort(this, con.inPortGuid);
        node.addOutPortLink(con.outPortGuid, nodeIn.exportId!, inport!.exportId!, node.exportId!, outport!.exportId!, con.exportId , node , nodeIn , outport! , inport! );
      }
    }
    SSObjBase.buildHashExportId(paramConnections);

    ///搜集 inparam
    for (var con in paramConnections) {
      var innode = nodeMap![con.inNodeGuid];

      if (tgtNode == innode) {
        var outnode = nodeMap![con.outNodeGuid];
        OutParam? op = outnode!.findOutParam(this, con.outParamGuid);
        InParam? ip = innode!.findInParam(this, con.inParamGuid);
        innode.addInParamLink(con.inParamGuid, outnode.exportId!, op!.exportId!, innode.exportId!, ip!.exportId!, con.exportId , outnode , innode , op! , ip! );
      }
    }
  }

  @override
  dynamic exportCodeData({int? hash}) {
    var activeNodes = nodes.where((e) {
      if (e.moduleInterfaces.length>0) return true;
      return e.active == true;
    });
    var outData = { 'name': name, 'scriptId': exportId , "hash" : hash};
    var subnodes = [];
    var updateNodeCount = 0;
    var stateNodeCount = 0;
    for (var n in activeNodes) {
      var nd = n.exportCodeData();

      subnodes.add(nd);
      var struct = n.getNodeStructType();
      if (struct!.getWithUpdateLogic()) {
        updateNodeCount = updateNodeCount + 1;
      }
      if (struct!.getIsSyncNode()) {
        stateNodeCount = stateNodeCount + 1;
      }
    }
    var svars = [];



    // for (var svar in scriptFields) {
    fullScriptsFields?.forEach((key, svar) {
      svars.add(svar.exportInfo());
    });

    // }
    outData['updatableNodeCount'] = updateNodeCount;
    outData['stateNodeCount'] = stateNodeCount;
    outData['nodes'] = subnodes;
    outData['scriptVars'] = svars;

    List<RefSubScript> exportSubScripts = <RefSubScript>[];
    exportSubScripts.addAll(subScripts);
    exportSubScripts.sort((a,b){
      return a.exportId! - b.exportId!;
    });

    List<dynamic> modules = <dynamic>[];
    exportSubScripts.forEach((element) {
      var scriptInfo = StateScriptProject.instance!.scripts.firstWhere((e) => e.guid == element.scriptId);
      modules.add({ "moduleId" : element.exportId ,"scriptName" : scriptInfo == null ?"":scriptInfo.name});
    });

    outData['modules'] = modules;

    // bw.writeUint32(exportSubScripts.length, "module count : ${exportSubScripts.length}");
    // exportSubScripts.forEach((element) {
    //   bw.writeUint32(element.exportId, "module id : ${element.exportId}");
    //   var scriptInfo = StateScriptProject.instance.scripts.firstWhere((e) => e.guid == element.scriptId, orElse:()=>null);
    //   if (scriptInfo != null){
    //     // bw.writeUint32(scriptInfo.exportId, "script id : ${scriptInfo.exportId}");
    //     // print("export module name : ${scriptInfo.name}");
    //     bw.writeString(scriptInfo.name, "script name : ${scriptInfo.name}");
    //   }
    //   else{
    //     bw.writeString("", "script name : 未指定");
    //   }
    // });

    return outData;
  }

  bool hasInPortConnection(StateScriptNode node, InPort inPort) {
    var key = "${node.guid}_${inPort.guid}";
    var count = _connectionCounts[key];
//    print(_connectionCounts);
    return count != null && count > 0;
//    for(var c in portConnections){
//      if (c.inNodeGuid == node.guid && c.inPortGuid == inPort.guid) return true;
//    }
//    return false;
  }

  bool hasOutPortConnection(StateScriptNode node, OutPort outPort) {
    var key = "${node.guid}_${outPort.guid}";
    var count = _connectionCounts[key];
    return count != null && count > 0;
//    for(var c in portConnections){
//      if (c.outNodeGuid == node.guid && c.outPortGuid == outPort.guid) return true;
//    }
//    return false;
  }

  bool hasInParamConnection(StateScriptNode node, InParam inParam) {
    var key = "${node.guid}_${inParam.guid}";
    var count = _connectionCounts[key];
    return count != null && count > 0;
//    for(var c in paramConnections){
//      if (c.inNodeGuid == node.guid && c.inParamGuid == inParam.guid) return true;
//    }
//    return false;
  }

  bool hasOutParamConnection(StateScriptNode node, OutParam outParam) {
    var key = "${node.guid}_${outParam.guid}";
    var count = _connectionCounts[key];
    return count != null && count > 0;
//    for(var c in paramConnections){
//      if (c.outNodeGuid == node.guid && c.outParamGuid == outParam.guid) return true;
//    }
//    return false;
  }

  ObjInfos getAllTransformInfos() {
    ObjInfos infos = ObjInfos();

    for (var node in nodes) {
      node.getTransformInfo(infos.objs);
    }
    // ObjInfo obj = ObjInfo();
    // obj.guid = "test guid";
    // infos.objs.add(obj);
    return infos;
  }

  // dynamic getModuleInterfaceTarget(String inGuid) {
  //   var res = _interfaceMapping[inGuid];
  //   // if (res is OutParam){
  //   //   print("-------------------------------------------- getModuleInterfaceTarget = ${(res as OutParam).alias} ${(res as OutParam).exportId}");
  //   // }
  //   return res;
  // }

  void addSubScript(RefSubScript n) {
    subScripts.add(n);

    SSObjBase.buildExportId(subScripts);
  }

  void loadSubScripts(String rootScript) {
    // subNodes = List<StateScriptNode>();
    // subPortConnections = List<PortConnection>();
    // subParamConnections = List<ParamConnection>();
    SSObjBase.buildExportId(subScripts);
    for(var subS in subScripts){
      print("------------------load sub : ${subS.guid}");
      subS.reload(rootScript);
    }
    refreshNodeMap();
    buildScriptFieldsMap();


    prepareNodeId();
    // for(int i = portConnections.length-1 ; i >=0 ;--i){
    //   var c = portConnections[i];
    //   if (_nodeMap[c.inNodeGuid] == null || _nodeMap[c.outNodeGuid] == null ){
    //     portConnections.removeAt(i);
    //   }
    // }
    // for(int i = paramConnections.length-1 ; i >=0 ;--i){
    //   var c = paramConnections[i];
    //   if (_nodeMap[c.inNodeGuid] == null || _nodeMap[c.outNodeGuid] == null ){
    //     paramConnections.removeAt(i);
    //   }
    // }
  }

  void deleteSubScript(RefSubScript subScript) {
    // subScript?.dispose();
    subScripts.remove(subScript);
  }

  Offset adjustGraphPosition() {
    double l = double.maxFinite,t = double.maxFinite;
    for(var n in nodes){
      l = min(l,n.x);
      t = min(t,n.y);

      for(var sp in n.soports){
        l = min(l,sp.x);
        t = min(t,sp.y);
      }
      for(var sp in n.sops){
        l = min(l,sp.x);
        t = min(t,sp.y);
      }
    }

    for(var n in nodes){
      n.x = n.x - l + SSDefines.canvasZeroX;
      n.y = n.y - t + SSDefines.canvasZeroY;

      for(var sp in n.soports){
        sp.x = sp.x - l + SSDefines.canvasZeroX;
        sp.y = sp.y - t + SSDefines.canvasZeroY;
      }
      for(var sp in n.sops){
        sp.x = sp.x - l + SSDefines.canvasZeroX;
        sp.y = sp.y - t + SSDefines.canvasZeroY;
      }
    }

    return Offset(l,t);
  }

  Map<String , Map<String , String>> collectInParamNameMaps(){
    var res  = Map<String , Map<String , String>> ();
    paramConnections.forEach((element) {
      var inNode = element.inNodeGuid;
      var inparam = element.inParamGuid;

      var outNode = element.outNodeGuid;
      var outparam = element.outParamGuid;

      var innode = nodeMap![inNode];
      var innd = innode!.getNodeStructType();
      var ip = innode.getInParam(inparam);
      if (ip == null) return;
      var node = nodeMap![outNode];
      var nd = node!.getNodeStructType();
      var op = nd!.getOutParam(outparam);
      if (op == null) return;
      var amap = res[inNode];//Map<String , String>();
      if (amap == null){
        amap = Map<String , String>();
        res[inNode] = amap;
      }
      var str = "${DartCommon.isEmpty(nd?.alias)? nd?.name:nd?.alias??""}的${DartCommon.isEmpty(op?.alias)? op?.name:op?.alias??""}";
      if (!DartCommon.isEmpty(ip.name)){
        amap["${ip.name}"] = str;// op?.alias??op?.name??"";
      }
      if (!DartCommon.isEmpty(ip.alias)){
        amap["${ip.alias}"] = str;// op?.alias??op?.name??"";
      }

    });

    return res;
  }

  // void loadASubScript(Offset off , RefSubScript ss , List<StateScriptNode> outNodes , List<PortConnection> outPortConnections , List<ParamConnection> outParamConnections){
  //   var fp = SSStorage.getScriptFile(ss.scriptId);
  //   if (fp == null){
  //     return;
  //   }
  //   Map m = jsonDecode(File(fp).readAsStringSync());
  //   var sss = StateScript.fromJson(m);
  //   double l = double.maxFinite;
  //   double t = double.maxFinite;
  //
  //   for(var n in sss.nodes){
  //     l = min(l,n.x);
  //     t = min(t,n.y);
  //   }
  //
  //   for(var n in sss.nodes){
  //     n.x = n.x - l + off.dx;
  //     n.y = n.y - t + off.dy;
  //   }
  //
  //   outNodes.addAll(sss.nodes);
  //   outPortConnections.addAll(sss.portConnections);
  //   outParamConnections.addAll(sss.paramConnections);
  //
  //   for(var subS in sss.subScripts){
  //     loadASubScript(Offset(ss.x , ss.y), subS , outNodes , outPortConnections , outParamConnections);
  //   }
  // }




//  static StateScript current;
}