
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iso/iso.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyList.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeEnum.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/OTGlobalBoard.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/BattlePusGlobal.dart';

import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentProject.dart';
import 'package:battlepus/StateScript/Struct/BreakPointList.dart';
import 'package:battlepus/StateScript/Struct/BreakPointType.dart';
import 'package:battlepus/StateScript/Struct/ConnectAssist.dart';
import 'package:battlepus/StateScript/Struct/ExportConfig.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSScriptVar.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSUnion.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/ResourceList.dart';
import 'package:battlepus/StateScript/Struct/SSAgent.dart';
import 'package:battlepus/StateScript/Struct/SSComponent.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/SSStorage.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/SyncFieldInfo.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Tagger/TagCamp.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:watcher/watcher.dart';
import 'package:process_run/shell.dart';
import 'package:uuid/uuid.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentMethod.dart';

import '../FieldVisibleController.dart';
import 'ScriptModule.dart';
part 'StateScriptProject.g.dart';

@JsonSerializable()
class StateScriptProject{

  static bool openLog = false;
  static List<String> logs = <String>[];

// 将 isShowTips 改为 ValueNotifier
  final ValueNotifier<bool> isShowTipsNotifier = ValueNotifier<bool>(true);
  
  // 保持兼容性的 getter 和 setter
  bool get isShowTips => isShowTipsNotifier.value;
  set isShowTips(bool value) => isShowTipsNotifier.value = value;

  // 线绘制层级：true=上（连线绘在最上层），false=下（连线绘在最下层）。默认下（连线在节点下方）。
  final ValueNotifier<bool> lineLayerOnTopNotifier = ValueNotifier<bool>(false);
  bool get lineLayerOnTop => lineLayerOnTopNotifier.value;
  set lineLayerOnTop(bool value) => lineLayerOnTopNotifier.value = value;

  @JsonKey(ignore:true)
  Map<String,FieldInfo> globalScriptVarMap = Map<String,FieldInfo>();
  // @JsonKey(defaultValue: <NodeStructData>[])
  @JsonKey(ignore:true)
  List<NodeStructData> nodeStructs = <NodeStructData>[];

  @JsonKey(defaultValue: <ScriptInfo>[])
  List<ScriptInfo> scripts = <ScriptInfo>[];

  // @JsonKey(defaultValue: <CBFunction>[])
  @JsonKey(ignore:true)
  List<CBFunction> functions = <CBFunction>[];



  // @JsonKey(defaultValue: <SSEnumType>[])
  @JsonKey(ignore:true)
  List<SSEnumType> enums = <SSEnumType>[];

  // @JsonKey(defaultValue: <SSAgent>[])
  @JsonKey(ignore:true)
  List<SSAgent> agents = <SSAgent>[];

  @JsonKey(defaultValue: <ScriptInfo>[])
  List<ScriptInfo> scriptTemplates = <ScriptInfo>[];

  @JsonKey(defaultValue: false)
  bool hidePort = false;

  @JsonKey(defaultValue: false)
  bool groupSave = false;

  @JsonKey(defaultValue: false)
  bool showScriptId = false;

  @JsonKey(defaultValue: true)
  bool showScriptNameAtLast = true;

  @JsonKey(defaultValue: false)
  bool showAllFields = false;

  @JsonKey(defaultValue: false)
  bool exportTxtInfo = false;

  @JsonKey(defaultValue: false)
  bool useDataCompatible = false;

  @JsonKey(defaultValue: false)
  bool exportAgentFunctionLength = false;

  @JsonKey(defaultValue: false)
  bool exportLuaDataCode = false;

  @JsonKey(defaultValue: false)
  bool useObjectTable = false;

  @JsonKey(defaultValue: false)
  bool addNameToFilePath = false;

  @JsonKey(ignore: true)
  BlockyList? shareCodeBlockyTemplates;

  @JsonKey(defaultValue: false)
  bool useNewExportPathRule = false;

  @JsonKey(defaultValue: false)
  bool forceSaveNodePosition = false;

  @JsonKey(defaultValue: false)
  bool cubicLine = false;

  @JsonKey(defaultValue: false)
  bool storeFunctionInScript = false;

  @JsonKey(defaultValue: false)
  bool exportFixedPoint = false;
  
  @JsonKey(defaultValue: false)
  bool useLuaForFieldVisible = false;
  @JsonKey(defaultValue: null)
  Map<String,ScriptModule>? scriptModules = null;//Map<String,ScriptModule>();

  // @JsonKey(defaultValue: BehavicAgentProject())
  @JsonKey(defaultValue: null)
  BehavicAgentProject? behavicAgentProject;// = BehavicAgentProject();
  @JsonKey(ignore:true)
  static String? currentSelectedModule;

  @JsonKey(defaultValue: <String , FieldInfo>{})
  Map<String , FieldInfo> globalScriptVars = Map<String , FieldInfo>();

  @JsonKey(defaultValue: <String , ResourceList>{})
  Map<String , ResourceList> resourceLists = Map<String , ResourceList>();

  static bool isExportThread = false;



  ResourceList addResourceList(){
    ResourceList res = ResourceList();
    resourceLists[res.guid] = res;
    return res;
  }

  void removeResourceList(String guid){
    resourceLists.remove(guid);
  }

  TagCamp tagCamp = new TagCamp();

  SSAgent addAgent(){
    var agent = SSAgent();
    agents.add(agent);

    return agent;
  }

  @JsonKey(ignore:true)
  Map<String,CBFunction>? _functionsMap ;
  CBFunction? getFunction(var guid){
    if (_functionsMap == null){
      _functionsMap = Map<String,CBFunction>();
      functions.forEach((element) {
        _functionsMap![element.guid] = element;
      });
    }

    return _functionsMap![guid];
  }

  void deleteFunction(var guid){

    if (_functionsMap == null){
      _functionsMap = Map<String,CBFunction>();
      functions.forEach((element) {
        _functionsMap![element.guid] = element;
      });
    }

    var func = _functionsMap![guid];
    if (func == null) return ;
    functions.remove(func);
    if (_functionsMap == null){
      _functionsMap!.remove(guid);
    }

    var dir = SSStorage.getFunctionsStorePath();
    File f = File(PathUtil.join(dir.path , "$guid.json"));
    if (f.existsSync()){
      f.deleteSync();
    }
    // if (_functionsMap == null){
    //   _functionsMap = Map<String,CBFunction>();
    //   functions.forEach((element) {
    //     _functionsMap![element.guid] = element;
    //   });
    // }
    //
    // return _functionsMap![guid];
  }

  void addFunction(CBFunction func){
    if (_functionsMap == null){
      _functionsMap = Map<String,CBFunction>();
      functions.forEach((element) {
        _functionsMap![element.guid] = element;
      });
    }
    functions.add(func);
    _functionsMap![func.guid] = func;
  }

  void removeAgent(SSAgent agent){
    agents.remove(agent);
    if (StateScriptProject.instance!.csharpConfig.active){
      StateScriptProject.instance!.switchExportConfig(StateScriptProject.instance!.csharpConfig);
      var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
      var codePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
      var codeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);
      {var fPath = PathUtil.join(codePath , "Agent${agent.name}.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
      {var fPath = PathUtil.join(codeNodePath , "Agent${agent.name}Manual.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
    }
  }

  // @JsonKey(defaultValue: <SSComponent>[])
  @JsonKey(ignore:true)
  List<SSComponent> components = <SSComponent>[];

  SSComponent addComponent(){
    var com = SSComponent();
    components.add(com);
    return com;
  }

  void removeComponent(SSComponent com){
    components.remove(com);
    buildFieldInfos();

    if (StateScriptProject.instance!.csharpConfig.active){
      StateScriptProject.instance!.switchExportConfig(StateScriptProject.instance!.csharpConfig);
      var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
      var codePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
      var codeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);
      {var fPath = PathUtil.join(codePath , "I${com.name}.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
      {var fPath = PathUtil.join(codeNodePath , "I${com.name}Manual.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
    }

  }


  ExportConfig csharpConfig = ExportConfig();
  ExportConfig luaConfig = ExportConfig();

  @JsonKey(defaultValue: <ExportConfig>[])
  List<ExportConfig> exportExtraConfigs = <ExportConfig>[];

  List<ExportConfig> getAllConfigs(){
    List<ExportConfig> res = <ExportConfig>[];
    if (csharpConfig != null && csharpConfig.active) res.add(csharpConfig);

    if (!(StateScriptProject.instance!.useNewExportPathRule??false)) {
      if (luaConfig != null && luaConfig.active) res.add(luaConfig);
    }
    else{
      exportExtraConfigs.forEach((element) {
        if (element != null && element.active) res.add(element);
      });
    }

    return res;
  }

  @JsonKey(ignore: true)
  ExportConfig? currentExportConfig;
  // @JsonKey(defaultValue: "")
  // String nodeCodeExportPath ;
  //
  // @JsonKey(defaultValue: "")
  // String codeExportPath ;
  //
  // @JsonKey(defaultValue: "")
  // String templatePath ;

  @JsonKey(defaultValue: "")
  String? byteExportPath ;

  void registerEnumTypes(){
    for(var e in enums){
      SSFieldType.registerFieldType(e.guid, e..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD..typeGroup = "枚举");
    }
  }

  void registerBehavicAgentTypes(){
    if (behavicAgentProject == null) return ;
    behavicAgentProject!.classes.values.forEach((e) {
      SSFieldType.registerFieldType(e.guid, e..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD..typeGroup = "行为树 agent");
    });
    // for(var e in enums){
    //   SSFieldType.registerFieldType(e.guid, e..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD);
    // }
  }

  SSEnumType addEnum(){
    SSEnumType tmp = new SSEnumType();
    enums.add(tmp);
    SSFieldType.registerFieldType(tmp.guid, tmp..typeGroup = "枚举");
    CBTypeEnum.buildAllEnumMaps();
    return tmp;
  }

  void removeEnum(SSEnumType item){
    enums.remove(item);
    SSFieldType.unregisterFieldType(item.guid);
    CBTypeEnum.buildAllEnumMaps();
  }

  @JsonKey(ignore: true)
  Map<String , NodeStructData>? _structMap;
  Map<String , NodeStructData>? get structMap {
    if (_structMap == null){
      refreshStructMap();
    }
    return _structMap;
  }

  void refreshStructMap(){
    _structMap = new Map<String , NodeStructData>();
    for(var s in nodeStructs){
      _structMap![s.guid] = s;
    }
  }
  /// 脚本
  ///
  Map<String , List<ScriptInfo> > getScriptGroups(){
    var res = Map<String , List<ScriptInfo> >();

    for(var ns in scripts){
      ns.group=ns.group??"";
      var lst = res[ns.group];
      if (lst == null){
        lst = <ScriptInfo>[];

        res[ns.group] = lst;
      }
      lst.add(ns);
    }

    res.forEach((key, value) {
      value.sort((a,b)=>a.name.compareTo(b.name));
    });
    return res;
  }

  ScriptInfo addScript(){
    BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_createScript");
    var n = ScriptInfo();
    scripts.add(n);
    SSObjBase.buildHashExportId(scripts);
    return n;
  }

  ScriptInfo? findScriptByName(String name){
    for(var s in scripts){
      if (s.name ==  name) return s;
    }
    return null;
  }

  ScriptInfo? findScriptByGuid(String guid){
    for(var s in scripts){
      if (s.guid ==  guid) return s;
    }
    return null;
  }

  ScriptInfo addTemplate(){
    var n = ScriptInfo();
    n.isTemplate = true;
    scriptTemplates.add(n);
    return n;
  }

  void deleteScript(ScriptInfo script) {


    if (scripts.contains(script)){
      // selfSave = true;
      // lockTime = DateTime.now().add(Duration(seconds: lockTimeAdd));
      cancelWatchProject();
      if (script.scriptData != null) {
        script.scriptData!.clean();
      }
      // SSStorage.deleteScriptFile(script!.guid);

      SSStorage.deleteScriptFile(script!.guid,script!.group,script! , script.getIOHeadName());
      scripts.remove(script);
      // selfSave = true;
      // lockTime = DateTime.now().add(Duration(seconds: lockTimeAdd));
      doWatchProject();


    }
  }

  void deleteTemplate(ScriptInfo script) {
    if (scriptTemplates.contains(script)){

      if (script.scriptData != null) {
        script.scriptData!.clean();

      }
      SSStorage.deleteScriptFile(script!.guid,script!.group,script! , script.getIOHeadName());

      scriptTemplates.remove(script);
    }
  }

  SSComponent cloneComponent(SSComponent comp) {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(comp);
    JsonDecoder dec = JsonDecoder();
    SSComponent data = SSComponent.fromJson(dec.convert(json));

    data.rebuildGuid();
    for(var f in data.fields){
      f.rebuildGuid();
    }
    if (!DartCommon.isEmpty(comp.name)) {
      data.name = "${comp.name}_clone_";
    }
    if (!DartCommon.isEmpty(comp.alias)) {
      data.alias = "${comp.alias}_clone_";
    }
    if (!DartCommon.isEmpty(comp.group)) {
      data.group = "${comp.group}";
    }

    components.add(data);
    return data;
  }
  SSAgent cloneAgent(SSAgent agent) {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(agent);
    JsonDecoder dec = JsonDecoder();
    SSAgent data = SSAgent.fromJson(dec.convert(json));

    data.guid = Uuid().v4();
    if (!DartCommon.isEmpty(agent.name)) {
      data.name = "${agent.name}_clone_";
    }
    if (!DartCommon.isEmpty(agent.alias)) {
      data.alias = "${agent.alias}_clone_";
    }
    if (!DartCommon.isEmpty(agent.group)) {
      data.group = "${agent.group}";
    }

    agents.add(data);
    return data;
  }



  NodeStructData cloneNodeStruct(NodeStructData struct) {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(struct);
    JsonDecoder dec = JsonDecoder();
    NodeStructData data = NodeStructData.fromJson(dec.convert(json));
    data.rebuildGuid();

    for(var f in data.fields){
      f.rebuildGuid();
    }
    for(var f in data.inPorts){
      f.rebuildGuid();
    }
    for(var f in data.outPorts){
      f.rebuildGuid();
    }
    for(var f in data.inParams){
      f.rebuildGuid();
    }
    for(var f in data.outParams){
      f.rebuildGuid();
    }
    if (!DartCommon.isEmpty(struct.name)) {
      data.name = "${struct.name}_clone_";
    }
    if (!DartCommon.isEmpty(struct.alias)) {
      data.alias = "${struct.alias}_clone_";
    }
    if (!DartCommon.isEmpty(struct.group)) {
      data.group = "${struct.group}";
    }

    data.forceExportGenPath = struct.forceExportGenPath;
    data.forceExportNodePath = struct.forceExportNodePath;

    nodeStructs.add(data);
    refreshStructMap();

    return data;
  }

  ScriptInfo cloneScript(ScriptInfo script) {
    var newScript = ScriptInfo();
    if (!DartCommon.isEmpty(script.name)) {
      newScript.name = "${script.name}_clone_";
    }
    if (!DartCommon.isEmpty(script.alias)) {
      newScript.alias = "${script.alias}_clone_";
    }
    if (!DartCommon.isEmpty(script.group)) {
      newScript.group = "${script.group}";
    }
    newScript.isModule = script.isModule;
    newScript.tagSet = script.tagSet?.clone();
    newScript.cateTag = script.cateTag;
    newScript.category = script.category;
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(script.scriptData);
    JsonDecoder dec = JsonDecoder();
    StateScript data = StateScript.fromJson(dec.convert(json));
    data.loadSubScripts(newScript.guid);
    data.guid = Uuid().v4();
    newScript.specialExportPath = script.specialExportPath;
    newScript.behavicAgentGuid = script.behavicAgentGuid;

    Map<String , List<dynamic>> cbs = Map<String , List<dynamic>>();
    StateScriptProject.cancelWatchProject();
    for(var n in data.nodes){
      n.cloneAgentFunctions(newScript);
      var ns = n.getNodeStructType();
      for(var f in ns!.fields){
        var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
        if (ft is SSScriptVar){
          var oldGuid = n.fieldValues[f.guid]!.value as String;
          if (DartCommon.isEmpty(oldGuid)) continue;
          var lst = cbs[oldGuid];
          if (lst == null) {
            lst = <dynamic>[];
            cbs[oldGuid] = lst;
          }

          lst.add((newGuid){
            n.fieldValues[f.guid]!.value = newGuid;
          });
        }
      }
    }

    StateScriptProject.doWatchProject();

    //脚本变量guid重置
    data.scriptFieldVars.forEach((sf) {
      var lst =  cbs[sf.guid];
      sf.guid = Uuid().v4();
      if (lst != null){
        lst.forEach((element) {
          element.call(sf.guid);
        });
      }
    });
    // for(var sf in data.scriptFields){
    //   var lst =  cbs[sf.guid];
    //   sf.guid = Uuid().v4();
    //   if (lst != null){
    //     lst.forEach((element) {
    //       element.call(sf.guid);
    //     });
    //   }
    // }
    data.initConnectionCount();
    newScript.setScriptData(data);
    data.buildScriptGroupNodes();
    newScript.saveScript();
    newScript.category = script.category;
    scripts.add(newScript);

    SSObjBase.buildHashExportId(scripts);
    return newScript;
  }

  ScriptInfo cloneTemplate(ScriptInfo script) {
    var n = ScriptInfo();
    if (!DartCommon.isEmpty(script.name)) {
      n.name = "${script.name}_clone_";
    }
    if (!DartCommon.isEmpty(script.alias)) {
      n.alias = "${script.alias}_clone_";
    }
    if (!DartCommon.isEmpty(script.group)) {
      n.group = "${script.group}";
    }
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(script.scriptData);
    JsonDecoder dec = JsonDecoder();
    StateScript data = StateScript.fromJson(dec.convert(json));
    data.guid = Uuid().v4();
    data.initConnectionCount();
    n.setScriptData(data);
    n.saveScript();
    n.category = script.category;
    n.isTemplate = true;
    scriptTemplates.add(n);
    return n;
  }

  ScriptInfo scriptToTemplate(ScriptInfo script) {
    var n = ScriptInfo();
    if (!DartCommon.isEmpty(script.name)) {
      n.name = "${script.name}";
    }
    if (!DartCommon.isEmpty(script.alias)) {
      n.alias = "[模板] ${script.alias}";
    }
    if (!DartCommon.isEmpty(script.group)) {
      n.group = "${script.group}";
    }
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(script.scriptData);
    JsonDecoder dec = JsonDecoder();
    StateScript data = StateScript.fromJson(dec.convert(json));
    data.guid = Uuid().v4();
    data.initConnectionCount();
    n.setScriptData(data);
    n.saveScript();
    n.category = script.category;
    n.isTemplate = true;
    scriptTemplates.add(n);
    return n;
  }

  /// 结点
  ///
  Map<String , List<NodeStructData> > getStructGroups(){
    var res = Map<String , List<NodeStructData> >();

    for(var ns in nodeStructs){
      var lst = res[ns.group];
      if (lst == null){
        lst = <NodeStructData>[];
        res[ns.group] = lst;
      }
      lst.add(ns);
    }

    res.forEach((key, value) {
      value.sort((a,b)=>a.name.compareTo(b.name));
    });
    return res;
  }

  NodeStructData addNewNodeType(){
    BattlePusGlobal.reportLog(BattlePusGlobal.state_script,"1_createNode");
    var n = NodeStructData();
    nodeStructs.add(n);
    return n;
  }

  void deleteNodeType(NodeStructData nodeType) {
    if (nodeStructs.contains(nodeType)){
      //TODO , 清理脚本中的引用
      nodeStructs.remove(nodeType);
      if (StateScriptProject.instance!.csharpConfig.active){
        StateScriptProject.instance!.switchExportConfig(StateScriptProject.instance!.csharpConfig);
        var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
        print(basePath);

        {
          var codePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
          var codeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);

          if (codePath != null){
            {var fPath = PathUtil.join(codePath , "${nodeType.name}Data.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codePath , "${nodeType.name}Base.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codePath , "${nodeType.name}ViewBase.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
          }
          if (codeNodePath != null) {
            {var fPath = PathUtil.join(codeNodePath , "${nodeType.name}.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codeNodePath , "${nodeType.name}View.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
          }
        }

        {
          var codePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.logicCodeExportPath , basePath: basePath);
          var codeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.logicNodeCodeExportPath, basePath: basePath);

          if (codePath != null){
            {var fPath = PathUtil.join(codePath , "${nodeType.name}Data.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codePath , "${nodeType.name}Base.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codePath , "${nodeType.name}ViewBase.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
          }
          if (codeNodePath != null) {
            {var fPath = PathUtil.join(codeNodePath , "${nodeType.name}.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codeNodePath , "${nodeType.name}View.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
          }
        }

        {
          var codePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.viewCodeExportPath , basePath: basePath);
          var codeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.viewNodeCodeExportPath, basePath: basePath);

          if (codePath != null){
            {var fPath = PathUtil.join(codePath , "${nodeType.name}Data.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codePath , "${nodeType.name}Base.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codePath , "${nodeType.name}ViewBase.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
          }
          if (codeNodePath != null) {
            {var fPath = PathUtil.join(codeNodePath , "${nodeType.name}.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
            {var fPath = PathUtil.join(codeNodePath , "${nodeType.name}View.cs"); var f = File(fPath); if (f.existsSync()) f.deleteSync(); }
          }
        }
      }
    }
  }


  StateScriptProject(){
    csharpConfig = ExportConfig();
    luaConfig = ExportConfig();
  }
  //此处与类名一致，由指令自动生成代码
  factory StateScriptProject.fromJson(Map<String, dynamic> json) =>
      _$StateScriptProjectFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$StateScriptProjectToJson(this);



  static StateScriptProject? parse(String file){
    var jm = SSStorage.loadJson(file);
    if (jm != null) return StateScriptProject.fromJson(jm);

    return null;
  }

  static int projectVersionHashCode(){
    return 0;
  }

  static final lockTimeAdd = 1;
  void save(){
    // selfSave = true;
    // lockTime = DateTime.now().add(Duration(seconds: lockTimeAdd));
    FocusManager.instance.primaryFocus?.unfocus();
    cancelWatchProject();
    saveAllBehavics();
    saveAllComponents();
    saveAllAgents();
    saveAllNodeStruct();
    saveAllEnums();
    saveFunctionDirName();
    saveAllScriptInfos();
    saveAllScriptVars();

    // 工程更新后，移除序列化
    // components.clear();
    // enums.clear();
    // agents.clear();
    // nodeStructs.clear();
    // behavicAgentProject.classes.clear();

    var oldScripts = scripts;
    var oldGVars = globalScriptVars;
    scripts= [];
    globalScriptVars = {};

    SSStorage.saveJson("state_script_project" , this);

    scripts = oldScripts;
    globalScriptVars = oldGVars;

    saveShareCodeBlockyTemplates();
    // lockTime = DateTime.now().add(Duration(seconds: lockTimeAdd));
    doWatchProject();
  }


  static DirectoryWatcher? _watcher;
  static StreamSubscription<WatchEvent>? _evt ;
  static bool _inRefreshing = false;

  // static DateTime lockTime;
  // static bool selfSave = false;
  static BuildContext? _context;
  static dynamic onWatchOk;
  static void watchProject(BuildContext context , dynamic  onOk) {
    _context = context;
    onWatchOk = onOk;
  }
  static void cancelWatchProject() {
    if (_evt != null) {
      _evt!.cancel();
    }

    _watcher = null;
  }
  static void doWatchProject() {
    if (_evt != null) {
      _evt!.cancel();
    }

    // print("---------------------------------------------------------------------------------------------------------------------------------------------- doWatchProject ${StackTrace.current.toString()}");

    var root = SSMainSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);
    if (path ==null || !Directory(path).existsSync()){
      return ;
    }

    if (_watcher == null) {
      _watcher = DirectoryWatcher(path);
    }


    _evt = _watcher!.events.listen((event) {
      // print(event);
      if (!_inRefreshing && PathUtil.extension(event.path).toLowerCase() == ".json"){
        // if (lockTime!= null && !DateTime.now().isAfter(lockTime)){
        //   return ;
        // }
        _inRefreshing = true;
        // lockTime = DateTime.now().add(Duration(seconds: 3));
        // if (!selfSave){
          Future.delayed(Duration(milliseconds: 10)).then((value){
            // _inRefreshing = true;
            CommonUtil.confirm(_context, "检测到工程发生外部变化!!!\n推荐\n1 复制本地变化后的工程到其他目录\n2 保存工程\n3 关闭工具\n4 使用对比工具合并修改\n5 重新打开工程",ok: "重启", onCancel: (){
              _inRefreshing = false;
              // selfSave = false;
            },onOk: (){
              //重启
              var dirName = PathUtil.dirname(Platform.resolvedExecutable);
              var launcherPath = PathUtil.join(dirName , "restart.exe");
              var workingDirectory = PathUtil.dirname(launcherPath);
              // var exeName = PathUtil.basename(launcherPath);
              Process.start(launcherPath, [], runInShell: false , workingDirectory: workingDirectory ,mode: ProcessStartMode.detached);
            });
          });
        // }
      }
    });
  }

  void clearPath(Directory dir){
    if (dir == null) return ;
    var files = dir.listSync(recursive: true);
    for(var f in files){
      if (f is File) {
        f.deleteSync();
      }
    }
  }
  void saveAllNodeStruct(){
    var path = SSStorage.getNodeStructStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in nodeStructs){
      SSObjBase.buildFieldHashDataIdWithExist(s.fields , s.dataHashs);
      // for(var nt in nodeStructs){
      //   SSObjBase.buildFieldHashDataIdWithExist(nt.fields , nt.dataHashs);
      //   SSObjBase.buildHashDataIdWithExist(nt.inParams , nt.dataHashs);
      //   SSObjBase.buildHashDataIdWithExist(nt.outPorts , nt.dataHashs);
      // }
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      if (StateScriptProject.instance!.groupSave) {
        var group = s.group.trim();
        savePath = DartCommon.isEmpty(group) ? PathUtil.join(path.path, "${s.guid}.json") : PathUtil.join(path.path, group, "${s.guid}.json");
        SSStorage.tryCreateDir(savePath);

      }
      SSStorage.checkDeleteOldPathFile(s.guid, savePath);
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }

  void saveAllBehavics(){
    var path = SSStorage.getBehavicStorePath();
    if (path == null) return ;
    clearPath(path);
    if (behavicAgentProject != null){
      for(var s in behavicAgentProject!.classes.values){
        var savePath = PathUtil.join(path.path, "${s.guid}.json");
        var jm = s.toJson();
        JsonEncoder encoder = new JsonEncoder.withIndent('  ');
        String json = encoder.convert(jm);
        var f = File(savePath);
        f.writeAsStringSync(json);
      }
    }

  }


  void saveAllEnums(){
    var path = SSStorage.getEnumStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in enums){
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      if (StateScriptProject.instance!.groupSave) {
        savePath = DartCommon.isEmpty(s.group) ? PathUtil.join(path.path, "${s.guid}.json") : PathUtil.join(path.path, s.group, "${s.guid}.json");
        SSStorage.tryCreateDir(savePath);

      }
      SSStorage.checkDeleteOldPathFile(s.guid, savePath);
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }

  void saveAllComponents(){
    var path = SSStorage.getComponentStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in components){
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }

  bool checkScriptInfosHave(){
        var path = SSStorage.getScriptInfoStorePath();
    if (path == null) return false;
    var savePath = PathUtil.join(path.path, "${ScriptInfo.current?.guid}.json");
    var f = File(savePath);
    if (f.existsSync()) {
      return true;
    }
    return false;
  }

  void saveAllScriptInfos(){
    var path = SSStorage.getScriptInfoStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in scripts){
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }

  void saveAllScriptVars(){
    var path = SSStorage.getStorePathByName("vars");
    if (path == null) return ;
    clearPath(path);
    globalScriptVars.forEach((key, s) {
    //for(var s in globalScriptVars){
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    });
  }

  void deleteAScriptVar(String guid){
    cancelWatchProject();
    var path = SSStorage.getStorePathByName("vars");
    if (path == null) return ;
    var fullPath = PathUtil.join(path.path, "${guid}.json");
    if (File(fullPath).existsSync()){
      File(fullPath).deleteSync();
    }
    doWatchProject();

    StateScriptProject.instance!.globalScriptVars.remove(guid);
    // clearPath(path);
    // globalScriptVars.forEach((key, s) {
    //   //for(var s in globalScriptVars){
    //   var savePath = PathUtil.join(path.path, "${s.guid}.json");
    //   var jm = s.toJson();
    //   JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    //   String json = encoder.convert(jm);
    //   var f = File(savePath);
    //   f.writeAsStringSync(json);
    // });
  }

  void saveAllAgents(){
    var path = SSStorage.getAgentStorePath();
    if (path == null) return ;
    clearPath(path);
    for(var s in agents){
      var savePath = PathUtil.join(path.path, "${s.guid}.json");
      var jm = s.toJson();
      JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      String json = encoder.convert(jm);
      var f = File(savePath);
      f.writeAsStringSync(json);
    }
  }


  void loadAllNodeStruct(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;

    path = PathUtil.join(path , "structs");
    SSStorage.loadFilePathAt(path);
    if (!Directory(path).existsSync()) return ;
    nodeStructs.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        // print(f.path);
        // print(str);
        Map<String , dynamic> userMap = jsonDecode(str);
        var s = NodeStructData.fromJson(userMap);
        nodeStructs.add(s);
      }
    }
  }

  void loadAllFunctions(String path,{bool bClear = true}){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "functions");
    if (!Directory(path).existsSync()) return ;
    SSStorage.loadFilePathAt(path);

    if (bClear) functions.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json") && !f.path.endsWith("-bin.json")){
        // var str = f.readAsStringSync();
        // Map userMap = jsonDecode(str);
        // var s = NodeStructData.fromJson(userMap);
        // nodeStructs.add(s);

        CBFunction cbf = CBFunction();
        cbf.guid = PathUtil.basenameWithoutExtension(f.path);
        cbf.isAgent = true;
        cbf.isAgent = true;
        functions.add(cbf);
      }
    }
  }

  void loadAllBehavics(String path){
    // var path = SSStorage.getScriptStorePath();
    if (behavicAgentProject == null) behavicAgentProject = new BehavicAgentProject();
    if (path == null) return ;
    path = PathUtil.join(path , "behavics");
    if (!Directory(path).existsSync()) return ;

    behavicAgentProject!.classes.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String, dynamic> userMap = jsonDecode(str);
        var s = BehavicAgentClass.fromJson(userMap);
        behavicAgentProject!.classes[s.guid] = s ;//add(s);
      }
    }
  }

  void loadAllEnums(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "enums");
    if (!Directory(path).existsSync()) return ;

    SSStorage.loadFilePathAt(path);

    enums.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String , dynamic> userMap = jsonDecode(str);
        var s = SSEnumType.fromJson(userMap);
        enums.add(s);
      }
    }
  }

  void loadAllComponents(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "components");
    if (!Directory(path).existsSync()) return ;
    components.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String,dynamic> userMap = jsonDecode(str);
        var s = SSComponent.fromJson(userMap);
        components.add(s);
      }
    }
  }

  void loadAllScriptInfos(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "scriptInfos");
    if (!Directory(path).existsSync()) return ;
    scripts.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String,dynamic> userMap = jsonDecode(str);
        var s = ScriptInfo.fromJson(userMap);
        scripts.add(s);
      }
    }
  }

  void loadAllScriptVars(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "vars");
    if (!Directory(path).existsSync()) return ;
    globalScriptVars.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String,dynamic> userMap = jsonDecode(str);
        var s = FieldInfo.fromJson(userMap);
        // scripts.add(s);
        globalScriptVars[s.guid] = s;
      }
    }
  }

  void loadAllAgents(String path){
    // var path = SSStorage.getScriptStorePath();
    if (path == null) return ;
    path = PathUtil.join(path , "agents");
    if (!Directory(path).existsSync()) return ;
    agents.clear();
    var files = Directory(path).listSync(recursive: true);
    for(var f in files){
      if (f is File && f.path.endsWith(".json")){
        var str = f.readAsStringSync();
        Map<String , dynamic> userMap = jsonDecode(str);
        var s = SSAgent.fromJson(userMap);
        agents.add(s);
      }
    }
  }

  void saveAllScript(){
    // selfSave = true;
    // lockTime = DateTime.now().add(Duration(seconds: lockTimeAdd));
    FocusManager.instance.primaryFocus?.unfocus();
    cancelWatchProject();
    var activeScripts = ScriptInfo.openedScripts; // RightToolBarState.scriptStack.getMap();
    for(var s in scripts){
      var script = s.getScriptData();
      if ( script!= null && activeScripts.contains(s)){
        if (DartCommon.isEmpty(s.guid)){
          s.guid = Uuid().v4();
        }
        s.saveScript();
      }
    }

    // if (StateScriptProject.instance.groupSave??false){
    {
      for(var s in scripts){
        var crtPath = SSStorage.globalGuid2FilePaths[s.guid];
        var newPath = SSStorage.getGroupScriptSavePath(s.guid, s.group , s.getIOHeadName(),s);
        // print("------------ 切换保存路径: $crtPath -> $newPath");

        if (crtPath != null && newPath != null && PathUtil.canonicalize(crtPath) != PathUtil.canonicalize(newPath)){
          var script = s.getScriptData();
          if ( script== null){
            s.loadScript();
            script = s.getScriptData();
          }
          print("------------ 切换保存路径: $crtPath -> $newPath");
          if ( script!= null){

            s.saveScript();
            s.setScriptData (null);
          }
        }
      }
    }

    for(var s in functions){
      if ( s!= null ){
        s.save(null);
      }
    }
    // lockTime = DateTime.now().add(Duration(seconds: lockTimeAdd));
    doWatchProject();
  }

  void checkEmpty(){
//    if (scripts == null){
//      scripts = List<ScriptInfo>();
//    }
//    if (nodeStructs == null) {
//      nodeStructs = List<NodeStructData>();
//    }
    nodeStructs.forEach((element) {element.buildFieldMap();element.buildInParamMap();});
  }

  static void load(){
    _instance = StateScriptProject.parse("state_script_project");//LocalStorage.instance.get("setting") as Setting;
    SSStorage.clearGlobalGuid2FilePaths();

    var root = SSMainSetting.instance!.workingPath;
    var path = GlobalBoard.getCorrectDirectory(root);

    _instance?.loadAllBehavics(path);
    _instance?.loadAllComponents(path);
    _instance?.loadAllEnums(path);
    _instance?.loadAllAgents(path);
    _instance?.loadAllNodeStruct(path);

    _instance?.loadAllFunctions(path);
    StateScriptProject.instance?.scriptModules?.forEach((key, sm) {
      var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
      var fpath = PathUtil.join(basePath, sm.savePath);
      // SSStorage.loadFilePathAt(path);
      _instance?.loadAllFunctions(fpath,bClear: false);
    });

    _instance?.loadAllScriptInfos(path);
    _instance?.loadAllScriptVars(path);
    if (DartCommon.isDirValid(SSMainSetting.instance!.workingPath)) {
      FieldVisibleController.instance.loadAll(path);
    }
    _instance?.checkEmpty();

    SSStorage.loadFilePathAt(SSStorage.getScriptStorePath().path);
    StateScriptProject.instance?.scriptModules?.forEach((key, sm) {
      var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
      var mpath = PathUtil.join(basePath, sm.savePath, "scripts");
      SSStorage.loadFilePathAt(mpath);
    });

    _instance?.loadShareCodeBlockyTemplates();
    if (_instance != null) {
      if (_instance!.behavicAgentProject == null) {
        _instance!.behavicAgentProject = BehavicAgentProject();
      }

      if (_instance!.tagCamp == null){
        _instance!.tagCamp = new TagCamp();
      }
    }

    // _instance.nodeStructs.forEach((element) {
    //   element.isSystemNode = true;
    // });
  }

  static void switchProjectLoad(){
    load();
    StateScriptProject.instance!.registerEnumTypes();
    StateScriptProject.instance!.registerBehavicAgentTypes();

    if (StateScriptProject.instance!.useObjectTable) {
      Future.delayed(Duration(milliseconds: 10)).then((value){
        ObjectTableSetting.load();

        if (ObjectTableProject.isValid()) {
          if (ObjectTableSetting.instance!.workingPath != "") {
            ObjectTableProject.load();
            ObjectTableProject.instance!.registerEnumTypes();
            // initExtraType();
            OTGlobalBoard.clear();
          }
        }
      });

    }

    CodeBlockyType.registerBlockyTypes();
  }


  static StateScriptProject? loadProject( String path){
    SSStorage.bImportOtherProject = true;
    // var ins = StateScriptProject.parse("state_script_project");//LocalStorage.instance.get("setting") as Setting;
    var f = File(path);
    Map<String,dynamic>? jm = null;
    if (f.existsSync()){
      jm = jsonDecode(f.readAsStringSync());
    }
    if (jm == null){return null;}
    // var jm = SSStorage.loadJson(file);
    var ins = StateScriptProject.fromJson(jm);

    var prjPath =PathUtil.dirname(path);

    ins.loadAllBehavics(prjPath);
    ins.loadAllComponents(prjPath);
    ins.loadAllEnums(prjPath);
    ins.loadAllAgents(prjPath);
    ins.loadAllNodeStruct(prjPath);
    ins.loadAllFunctions(prjPath);
    FieldVisibleController.instance.loadAll(path);
    ins?.checkEmpty();

    _instance?.loadShareCodeBlockyTemplates();
    SSStorage.bImportOtherProject = false;
    return ins;
  }

  static StateScriptProject? _instance;
  static void clearInstance(){
    _instance = null;
  }

  static void setInstance(StateScriptProject? ins){
    _instance = ins;
  }

  static StateScriptProject? get instance {
    if (_instance == null) _instance = new StateScriptProject();
    return _instance;
  }

  static bool isValid(){
    return _instance != null;
  }
  @JsonKey(ignore: true)
  bool debugExport = false;

  @JsonKey(ignore: true)
  Map<String,FieldInfo> allScriptVars = Map<String,FieldInfo>();
  void prepareExport(){
    // SSUnion.unionStringHashId2StrMap.clear();
    // scripts.sort((a,b)=>a.guid.compareTo(b.guid));
    SSObjBase.buildHashExportId(scripts);
    buildHashExportIdForEnum(enums);
    saveAllEnums();
    // components.sort((a,b)=>a.guid.compareTo(b.guid));
    SSObjBase.buildHashExportId(components);
    SSObjBase.buildHashExportId(functions);
    SSObjBase.buildHashExportId(agents);

    //为每个field确定id
    for(var nt in nodeStructs){
      SSObjBase.buildFieldHashDataIdWithExist(nt.fields , nt.dataHashs);
      SSObjBase.buildHashDataIdWithExist(nt.inParams , nt.dataHashs);
      SSObjBase.buildHashDataIdWithExist(nt.outPorts , nt.dataHashs);
    }

    // for(var e in enums){
    //   // SSObjBase.buildExportId(e.items);
    //   e.buildItemId();
    // }

    SSObjBase.buildHashExportId(nodeStructs);

    List<BehavicAgentClass> agentClzs = <BehavicAgentClass>[];
    List<BehavicAgentMethod> agentMethods = <BehavicAgentMethod>[];
    List<FieldInfo> agentVars = <FieldInfo>[];
    StateScriptProject.instance!.behavicAgentProject!.classes.values.forEach((element) {
      agentClzs.add(element);
      element.methods.values.forEach((element) {
        agentMethods.add(element);
      });
      element.fields.values.forEach((element) {
        agentVars.add(element);
      });
    });
    SSObjBase.buildHashExportId(agentClzs);
    SSObjBase.buildHashExportId(agentVars);
    SSObjBase.buildHashExportId(agentMethods);

    List<InPort> allInports = <InPort>[];
    for(var n in nodeStructs){
      allInports.addAll(n.inPorts);
    }
    SSObjBase.buildHashExportId(allInports);

    List<OutPort> allOutports = <OutPort>[];
    for(var n in nodeStructs){
      allOutports.addAll(n.outPorts);
    }
    SSObjBase.buildHashExportId(allOutports);


    List<OutParam> alloutparams = <OutParam>[];
    for(var n in nodeStructs){
      alloutparams.addAll(n.outParams);
    }
    SSObjBase.buildHashExportId(alloutparams);

    List<InParam> allinparams = <InParam>[];
    for(var n in nodeStructs){
      allinparams.addAll(n.inParams);
    }
    SSObjBase.buildHashExportId(allinparams);

    //重新加载脚本
    for(var s in scripts) {
      if (s.scriptData == null) {
        s.loadScript();
      }
      // s.scriptData.clearModuleInterface();
    }

    // List<FieldInfo> scriptsFields = List<FieldInfo>();
    allScriptVars.clear();
    for(var s in scripts) {
      if (s.scriptData == null) {
        s.loadScript();
      }
      s.scriptData!.fullScriptsFields?.forEach((key , element) {
        // scriptsFields.add(element);
        allScriptVars[element.guid] =element;
      });
    }
    // SSObjBase.buildExportId(scriptsFields);

    List<SyncFieldInfo> compFields = <SyncFieldInfo>[];
    for(var c in components) {
      c.fields.forEach((element) {
        compFields.add(element);
      });
    }
    SSObjBase.buildHashExportId(compFields);


    for(var s in scripts) {
      if (s.scriptData == null) {
        s.loadScript();
      }
      // SSObjBase.buildExportId(s.scriptData.inPorts);
      // SSObjBase.buildExportId(s.scriptData.outPorts);
      // SSObjBase.buildExportId(s.scriptData.inParams);
      // SSObjBase.buildExportId(s.scriptData.outParams);

      //关键步骤，将动态port param接口的exportid 和 interface exportid 保持一致
      // s.scriptData.syncInterfaceExportId();
    }
    // save();

    List<FieldInfo> fields = <FieldInfo>[];
    List<BehavicAgentMethod> methods = <BehavicAgentMethod>[];
    for(var ag in StateScriptProject.instance!.behavicAgentProject!.classes.values){
      for(var m in ag.methods.values){
        methods.add(m);
      }
      for(var m in ag.fields.values){
        fields.add(m);
      }
    }

    SSObjBase.buildHashExportId(fields);
    SSObjBase.buildHashExportId(methods);


    SSObjBase.buildHashExportId(globalScriptVars.values.toList());

    buildGlobalScriptVarMap();

    buildScriptVarId();
  }

  void buildGlobalScriptVarMap(){
    globalScriptVarMap.clear();
    globalScriptVars.forEach((key, value) {
      var key = "#${value.exportId}";
      globalScriptVarMap[key] = value;
    });
  }

  void centerNodes() {
    for(var s in scripts){
      if (s.scriptData ==null) {
        s.loadScript();
      }

      var ss = s.scriptData;
      var minx = double.maxFinite;
      var miny = double.maxFinite;
      for(var n in ss!.nodes){
        minx = min(minx , n.x);
        miny = min(miny , n.y);
      }
      for(var n in ss.nodes) {
        n.x = SSDefines.canvasZeroX + n.x - minx;
        n.y = SSDefines.canvasZeroY + n.y - miny;
      }

      s.saveScript();
    }

  }

  String getTempExt(String temp){
    return PathUtil.extension(temp.replaceAll(".temp", ""));
  }

  String getTemp2Name(String temp){
    return PathUtil.basename(temp).replaceAll(".temp", "");
  }
  void exportBinaryOnly() async {
    if (currentExportConfig == null || currentExportConfig!.active == false) return;
    prepareExport();

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    GlobalBoard.tryCreateDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
    GlobalBoard.tryCreateDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);
    var tempPath = GlobalBoard.getCorrectDirectory(currentExportConfig!.templatePath, basePath: basePath);
    ExportMappingConfig.load(tempPath,force: true);

    exportBinary(exportBin: currentExportConfig == csharpConfig);

    await exportFunctions(onlySSCS :true);

  }
  Map<String , bool> ignoreTypes = {
    "int" : true,
    "float" : true,
    "double" : true,
    "bool" : true,
    "uint" : true,
    "long" : true,
    "ulong" : true,
    "Vector3" : true,
    "Vector2" : true,
    "Quaternion" : true,
    "Color" : true,
    "Union" : true,
  };

  @JsonKey(ignore:true)
  List<String> fullLogs = <String>[];

  static String _normalizeExportPathForMatch(String? path){
    if (path == null) return "";
    return path.replaceAll("\\", "/").toLowerCase();
  }

  /// 旧版逻辑层节点的 gen 导出路径标记
  static bool isLegacyLogicGenExportPath(String? path){
    return _normalizeExportPathForMatch(path).endsWith("logic/statescript/gen");
  }

  /// 旧版逻辑层节点的 node 导出路径标记
  static bool isLegacyLogicNodeExportPath(String? path){
    return _normalizeExportPathForMatch(path).endsWith("logic/statescript/node");
  }

  String getExportPath(NodeStructData nt , {String? basePath}){
    if (StateScriptProject.instance!.useNewExportPathRule??false) {
      //新版路径
      var baseCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.baseCodeExportPath , basePath: basePath);

      //逻辑层节点统一读取“逻辑层导出目录(gen)”设置
      if (isLegacyLogicGenExportPath(nt.forceExportGenPath)){
        var logicPath = PathUtil.join(baseCodePath , currentExportConfig!.effectiveLogicGenExportPath);
        print("nt name = ${nt.name} , logic epath = $logicPath");
        return logicPath;
      }

      String? fp = nt.forceExportGenPath;
      if (DartCommon.isEmpty(fp)){
        // return GlobalBoard.getCorrectDirectory(currentExportConfig.nodeCodeExportPath , basePath: basePath);
        fp = currentExportConfig!.defaultGenExportPath;
      }
      print("nt name = ${nt.name} , epath = ${ PathUtil.normalize(PathUtil.join(baseCodePath , fp)) }");
      return  PathUtil.join(baseCodePath , fp);
    }

    String? fp = nt.forceExportGenPath;
    if (!DartCommon.isEmpty(fp)){
        var baseCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.baseCodeExportPath , basePath: basePath);
        print("nt name = ${nt.name} , epath = ${ PathUtil.normalize(PathUtil.join(baseCodePath , fp)) }");
        return  PathUtil.join(baseCodePath , fp);
      }

    //TAG path
    var tagGenPath = nt.getTagGenExportPath(currentExportConfig == csharpConfig);
    if (tagGenPath != null){
      var path = GlobalBoard.getCorrectDirectory(tagGenPath , basePath: basePath);
      if (path != null) return path;
    }

    var commonCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
    if (nt.isLogicNode && nt.isViewNode){
      return commonCodePath;
    }

    if (nt.isLogicNode && !DartCommon.isEmpty(currentExportConfig!.logicCodeExportPath)){

      var path = GlobalBoard.getCorrectDirectory(currentExportConfig!.logicCodeExportPath , basePath: basePath);
      if (path != null) return path;
    }

    if (nt.isViewNode && !DartCommon.isEmpty(currentExportConfig!.viewCodeExportPath)){
      var path = GlobalBoard.getCorrectDirectory(currentExportConfig!.viewCodeExportPath , basePath: basePath);
      if (path != null) return path;
    }
    return commonCodePath;
  }

  String getNodeExportPath(NodeStructData nt , {String? basePath}){
    if (StateScriptProject.instance!.useNewExportPathRule??false) {
      var baseCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.baseCodeExportPath , basePath: basePath);

      //逻辑层节点统一读取“逻辑层导出目录(node)”设置
      if (isLegacyLogicNodeExportPath(nt.forceExportNodePath)){
        return PathUtil.join(baseCodePath , currentExportConfig!.effectiveLogicNodeExportPath);
      }

      //节点重写的路径
      String? fp = nt.forceExportNodePath;
      if (DartCommon.isEmpty(fp)){
        fp = currentExportConfig!.defaultNodeExportPath;
      }
      return PathUtil.join(baseCodePath , fp);
    }

    String? fp = nt.forceExportNodePath;
    if(!DartCommon.isEmpty(fp))
    {
      var baseCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.baseCodeExportPath , basePath: basePath);
      return PathUtil.join(baseCodePath , fp);
    }

    //TAG path
    var tagGenPath = nt.getTagNodeExportPath(currentExportConfig == csharpConfig);
    if (tagGenPath != null){
      var path = GlobalBoard.getCorrectDirectory(tagGenPath , basePath: basePath);
      if (path != null) return path;
    }

    var commonCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.nodeCodeExportPath , basePath: basePath);
    if (nt.isLogicNode && nt.isViewNode){
      return commonCodePath;
    }

    if (nt.isLogicNode && !DartCommon.isEmpty(currentExportConfig!.logicNodeCodeExportPath)){
      var path = GlobalBoard.getCorrectDirectory(currentExportConfig!.logicNodeCodeExportPath , basePath: basePath);
      if (path != null) return path;
    }

    if (nt.isViewNode && !DartCommon.isEmpty(currentExportConfig!.viewNodeCodeExportPath)){
      var path = GlobalBoard.getCorrectDirectory(currentExportConfig!.viewNodeCodeExportPath , basePath: basePath);
      if (path != null) return path;
    }
    return commonCodePath;
  }

  bool tryMoveNodeCode(String targetPath){
    var name = PathUtil.basename(targetPath);
    List<String> paths = [];

    if (!DartCommon.isEmpty(currentExportConfig!.nodeCodeExportPath)){
      paths.add(currentExportConfig!.nodeCodeExportPath!);
    }
    if (!DartCommon.isEmpty(currentExportConfig!.logicNodeCodeExportPath)){
      paths.add(currentExportConfig!.logicNodeCodeExportPath!);
    }
    if (!DartCommon.isEmpty(currentExportConfig!.viewNodeCodeExportPath)){
      paths.add(currentExportConfig!.logicNodeCodeExportPath!);
    }
    var tags = tagCamp.tags;
    for(var t in tags.values){
      List<String> nodepaths = [t.commonNodePath,t.logicNodePath,t.viewNodePath];
      for(var path in nodepaths){
        if (DartCommon.isEmpty(path)){
          paths.add(path);
          // var logicCodePath = GlobalBoard.getCorrectDirectory(path , basePath: basePath);
          // if (logicCodePath != null) {
          //   FileUtils.clearDirectoryFiles(logicCodePath);
          // }
        }
      }
    }
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    for(var p in paths){
      var logicCodePath = GlobalBoard.getCorrectDirectory(p , basePath: basePath);
      if (logicCodePath != null) {
        var filePath = PathUtil.join(logicCodePath , name);
        var fileObj = File(filePath);
        if (fileObj.existsSync()){
          fileObj.copySync(targetPath);
          fileObj.deleteSync();
          return true;
        }
      }
    }
    return false;

  }
  static String replaceEmptyLine(String outCode){
    outCode = outCode.replaceAll(new RegExp(r"\r\n(\s*\r\n)+", multiLine: true), "\r\n") +"\r\n";
    return outCode;
  }
  static IsoRunner? exportIso;
  Future export() async{
    SSUnion.lastVarTypeGuid = null;
    if (exportIso!= null){
      exportIso!.send({"process":"导出各种代码"});
    }
    // fullLogs.clear();
    if (currentExportConfig == null || currentExportConfig!.active == false) return;
    prepareExport();

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);


    if (currentExportConfig != csharpConfig) {
      GlobalBoard.tryCreateDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
      GlobalBoard.tryCreateDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);
    }

    // var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    // var codePath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance.templatePath , basePath: basePath);

    String? baseCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.baseCodeExportPath , basePath: basePath);
    if (baseCodePath == null){
      // throw Exception("config ${currentExportConfig.name} : baseCodeExportPath is not exist");
    }
    String? commonCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
    String? commonCodeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);

    if (StateScriptProject.instance!.useNewExportPathRule??false) {
      if (baseCodePath!= null) {
        commonCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.defaultGenExportPath, basePath: baseCodePath);
        commonCodeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.defaultNodeExportPath, basePath: baseCodePath);
      }
      else{
        commonCodePath = null;
        commonCodeNodePath = null;
      }
    }

    if (commonCodePath == null){
      // throw Exception("config ${currentExportConfig.name} : defaultGenExportPath is not exist");
    }
    if (commonCodeNodePath == null){
      // throw Exception("config ${currentExportConfig.name} : defaultNodeExportPath is not exist");
    }


    var relativeCommonCodePath = commonCodePath != null?PathUtil.relative(commonCodePath,from : baseCodePath):"";
    var relativeCommonCodeNodePath = commonCodeNodePath != null?PathUtil.relative(commonCodeNodePath,from : baseCodePath):"";

    if (!(StateScriptProject.instance!.useNewExportPathRule??false)) {
      //老版导出路径机制，对新版机制路径进行填充
      if (currentExportConfig == csharpConfig) {
        csharpConfig.defaultNodeExportPath = relativeCommonCodeNodePath;
        csharpConfig.defaultGenExportPath = relativeCommonCodePath;

        // print("csharpConfig.defaultNodeExportPath = ${csharpConfig.defaultNodeExportPath}");
        // print("csharpConfig.defaultGenExportPath = ${csharpConfig.defaultGenExportPath}");
      }
    }

    var tempPath = GlobalBoard.getCorrectDirectory(currentExportConfig!.templatePath, basePath: basePath);
    ExportMappingConfig.load(tempPath , force: true);
//    var nodeDataTemplateFile = PathUtil.join(tempPath , "node_data.temp");
//    var templateData = File(nodeDataTemplateFile).readAsStringSync();
//
//    var nodeTemplateFile = PathUtil.join(tempPath , "node_gen.temp");
//    var templateNode = File(nodeTemplateFile).readAsStringSync();
//
//    var nodeActionTemplateFile = PathUtil.join(tempPath , "node.temp");
//    var templateActionNode = File(nodeActionTemplateFile).readAsStringSync();

    bool nodePathExists = commonCodeNodePath != null && Directory(commonCodeNodePath).existsSync();
    print("node path exists: $nodePathExists");
    if (!nodePathExists){
      // BotToast.showSimpleNotification(title: "node 代码导出路径没有设置，进行策划模式导出，只导出二进制文件");
    }
    if (nodePathExists) {
      // var codePath = commonCodePath;
      //清理tag特殊路径
      if (!(StateScriptProject.instance!.useNewExportPathRule??false)) {
        //清理路径
        tagCamp.clearExportGenPath(currentExportConfig == csharpConfig);

        FileUtils.clearDirectoryFiles(commonCodePath);
        if (!DartCommon.isEmpty(currentExportConfig!.logicCodeExportPath)) {
          var logicCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.logicCodeExportPath, basePath: basePath);
          if (logicCodePath != null) {
            FileUtils.clearDirectoryFiles(logicCodePath);
          }
        }
        if (!DartCommon.isEmpty(currentExportConfig!.viewCodeExportPath)) {
          var viewCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.viewCodeExportPath, basePath: basePath);
          if (viewCodePath != null) {
            FileUtils.clearDirectoryFiles(viewCodePath);
          }
        }
      }
      else{
        //清理路径
        for (var n in nodeStructs) {
          if (DartCommon.isEmpty((n.name))) continue;
          var codePath = getExportPath(n , basePath:basePath);
          if (codePath != null && Directory(codePath).existsSync()){
            FileUtils.clearDirectoryFiles(codePath);
          }
        }
      }

      var shell = Shell(throwOnError : false  , verbose : false ,commandVerbose : false , commentVerbose : false , stdoutEncoding : utf8 , stderrEncoding : utf8);
      var coolFormat = PathUtil.join(GlobalBoard.getWorkingPath() , "CoolFormat.exe");

      final context = Context.create();

      context.variables['namespace'] = ExportMappingConfig.instance!.namespace;
      context.variables['namespace_array'] = ExportMappingConfig.instance!.namespace.split(".").toList();
      context.variables['useDataCompatible'] = useDataCompatible;
      context.variables['object_table_namespace'] = ExportMappingConfig.instance!.otnamespace;

      context.variables['exportAgentFunctionLength'] = exportAgentFunctionLength;

      // var allParamTypes = [];
      var expNodes = [];
      int iExtraTypeCount = 0;
      for (var n in nodeStructs) {

        //不需要把动态节点展开
        if(currentExportConfig!.expandExport == false){  
           if (n.getIsExportDynamicData() && n.getDynamicExportType() != n){
            var ei = n.exportInfo();
            expNodes.add(ei);
            continue;
          }
        }
       
        if (DartCommon.isEmpty((n.name))) continue;
        var codePath = getExportPath(n , basePath:basePath);
        var relativeForceGenPath = PathUtil.relative(codePath , from: baseCodePath);
        
        var ei = n.exportInfo();
        if(currentExportConfig!.expandExport){
          if(ei["isExportDynamicData"] != null && ei["isExportDynamicData"]){
            ei["isExportDynamicData"]  = false;
          }
        }
        
        expNodes.add(ei);
        context.filters["cppNs"] = (i,a){
          return i.toString().replaceAll(".", "::");
        };
        /// 类型数据
        context.variables['clz'] = ei;
        {
          var tempDir = PathUtil.join(tempPath, "node_data");
          var dir = Directory(tempDir);
          if (dir.existsSync()) {
            var files = dir.listSync();
            for (var f in files) {
              if (f is File && f.path.endsWith(".temp")) {
                var templateData = f.readAsStringSync();
                final template = Template.parse(context, Source.fromString(templateData));
                var outCode = (template.render(context));
                outCode = replaceEmptyLine(outCode);//outCode.replaceAll(new RegExp(r"\r\n(\s*\r\n)+", multiLine: true), "\r\n") +"\r\n";
                var savePath = PathUtil.join(codePath, "${n.name}Data${getTempExt(f.path)}");
                Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                File(savePath).writeAsStringSync(outCode);

                // var cmd2 = '"$coolFormat" -f "${savePath.replaceAll("\\", "/")}"';
                // await shell.run(cmd2);
              }
            }
          }
        }
        {
          var tempDir = PathUtil.join(tempPath, "node_gen");
          print("========================================== $tempDir");
          var dir = Directory(tempDir);
          if (dir.existsSync()) {

            var files = dir.listSync();
            for (var f in files) {
              if (f is File && f.path.endsWith(".temp")) {
                var templateData = f.readAsStringSync();
                final template = Template.parse(context, Source.fromString(templateData));
                var outCode = (template.render(context));
                outCode = replaceEmptyLine(outCode);//outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                var savePath = PathUtil.join(codePath, "${n.name}Base${getTempExt(f.path)}");
                Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                // print("gen code : $outCode");
                File(savePath).writeAsStringSync(outCode);

                // var cmd2 = '"$coolFormat" -f "${savePath.replaceAll("\\", "/")}"';
                // await shell.run(cmd2);
              }
            }
          }
        }
        if (n.withViewNode) {
          var tempDir = PathUtil.join(tempPath, "viewnode_gen");
          var dir = Directory(tempDir);
          if (dir.existsSync()) {
            var files = dir.listSync();
            for (var f in files) {
              if (f is File && f.path.endsWith(".temp")) {
                var templateData = f.readAsStringSync();
                final template = Template.parse(context, Source.fromString(templateData));
                var outCode = (template.render(context));
                outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                var savePath = PathUtil.join(codePath, "${n.name}ViewBase${getTempExt(f.path)}");
                Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                File(savePath).writeAsStringSync(outCode);

                // var cmd2 = '"$coolFormat" -f "${savePath.replaceAll("\\", "/")}"';
                // await shell.run(cmd2);
              }
            }
          }
        }
        var codeNodePath = getNodeExportPath(n,basePath: basePath);

        if (!(StateScriptProject.instance!.useNewExportPathRule??false)) {
          //老版导出路径机制，对新版机制路径进行填充
          if (currentExportConfig == csharpConfig) {
            var relativeForceNodePath = PathUtil.relative(codeNodePath, from: baseCodePath);
            print("node struct : ${n.name} >>> $relativeForceGenPath >>> $relativeForceNodePath");
            if (relativeCommonCodePath != relativeForceGenPath) {
              n.forceExportGenPath = relativeForceGenPath;
            }
            else {
              n.forceExportGenPath = "";
            }

            if (relativeCommonCodeNodePath != relativeForceNodePath) {
              n.forceExportNodePath = relativeForceNodePath;
            }
            else {
              n.forceExportNodePath = "";
            }
          }
        }
        /// 结点代码
        {

          // var codeNodePath = getNodeExportPath(n,basePath: basePath);
          var tempDir = PathUtil.join(tempPath, "node");
          var dir = Directory(tempDir);
          if (dir.existsSync()) {
            var files = dir.listSync();
            for (var f in files) {
              if (f is File && f.path.endsWith(".temp")) {
                var savePath = PathUtil.join(codeNodePath, "${n.name}${getTempExt(f.path)}");
                if (!File(savePath).existsSync()) {
                  bool withMoveCode = tryMoveNodeCode(savePath);
                  if (!withMoveCode) {
                    var templateData = f.readAsStringSync();
                    final template = Template.parse(context, Source.fromString(templateData));
                    var outCode = (template.render(context));
                    outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                    Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                    File(savePath).writeAsStringSync(outCode);
                  }
                }
              }
            }
          }
        }
        if (n.withViewNode) {
          var tempDir = PathUtil.join(tempPath, "viewnode");
          var dir = Directory(tempDir);
          if (dir.existsSync()) {
            var files = dir.listSync();
            for (var f in files) {
              if (f is File && f.path.endsWith(".temp")) {
                var savePath = PathUtil.join(
                    codeNodePath, "${n.name}View${getTempExt(f.path)}");
                if (!File(savePath).existsSync()) {
                  var templateData = f.readAsStringSync();
                  final template = Template.parse(
                      context, Source.fromString(templateData));
                  var outCode = (template.render(context));
                  outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                  Directory(PathUtil.dirname(savePath)).createSync(
                      recursive: true);
                  File(savePath).writeAsStringSync(outCode);
                }
              }
            }
          }
        }
      }
      context.variables.clear();
      context.variables['namespace'] = ExportMappingConfig.instance!.namespace;
      context.variables['nodes'] = expNodes;
      context.variables['namespace_array'] = ExportMappingConfig.instance!.namespace.split(".").toList();
      context.variables['exportAgentFunctionLength'] = exportAgentFunctionLength;
      var expScripts = [];
      for (var s in scripts) {
        var sfs = [];
        s.scriptData!.fullScriptsFields?.forEach((key , sf){
          // sfs["${s.name}_${sf.name}"] = sf.guid.hashCode;
          sfs.add({
            "name" : "${s.name}_${sf.name}",
            "code" : sf.guid.hashCode,
            "id":sf.exportId,
          });
        });

        // for(var sf in s.scriptData.scriptFields){
        //   // sfs["${s.name}_${sf.name}"] = sf.guid.hashCode;
        //   sfs.add({
        //     "name" : "${s.name}_${sf.name}",
        //     "code" : sf.guid.hashCode,
        //     "id":sf.exportId,
        //   });
        // }
        var sinfo = {
          'name': s.name,
          'id': s.exportId,
          'upperName': s.name.toUpperCase(),
          'hash': s.guid.hashCode,
          'fields':sfs
        };
        expScripts.add(sinfo);
      }
      context.variables['scripts'] = expScripts;


      var expEnums = [];
      Map<String , Map> enumMap = Map<String , Map>();
      // bool bNeedSave = false;
      for (var e in enums) {
//      var en = {'name' : e.name};
        var items = [];
        int iMaxId = - (1<<31);
        List<int> useValues = <int>[];
        for (var i in e.items) {
          if (i.enumValue != null){
            useValues.add(i.enumValue!);
            i.exportId = null;
          }
        }
        for (var i in e.items) {
          if (i.enumValue == null && i.exportId != null){
            if (useValues.contains(i.exportId )) {
              i.exportId = null;
            }
            else {
              useValues.add(i.exportId!);
            }
          }
        }
        int iIndex = 0;
        for (var i in e.items) {
          var cid = i.enumValue ?? i.exportId;//??i.exportId??0;
          if (cid == null){
            while(useValues.contains(iIndex)) ++iIndex;
            cid = iIndex++;
            // bNeedSave = true;
            i.exportId = cid;
          }
          iMaxId = max(iMaxId , cid);
          items.add({'name': i.name, 'id': cid , "alias" : i.alias});
        }
        // items.add({'name': 'MAX', 'id': iMaxId});
        var name = e.name;
        var ns = e.namespace;
        if (e.name.indexOf(".")>=0){
          var last = e.name.lastIndexOf(".");
          name = e.name.substring(last+1);
          ns = e.name.substring(0,last);
        }

        context.variables['enumnamespace'] =ExportMappingConfig.instance!.enumnamespace;

        if (DartCommon.isEmpty(ns)){
          ns = ExportMappingConfig.instance!.enumnamespace;   //默认设置的命名空间
        }
        var en = {
          'name': name,
          'nameFixed': name.replaceAll(".", "_") ,
          "needExport": e.needExport??true,
          "hasCustomNameSpace":!isNullOrEmpty(e.namespace),
          "namespace": isNullOrEmpty(e.namespace) ? ns :e.namespace,
          "namespace_array": ns.split(".").toList(),
          'exportSolver': e.exportSolver,
          'solveCompName': e.solveCompName,
          'staticDataName': e.staticDataName,
          'items': items
        };
        expEnums.add(en);
        enumMap[e.guid] = en;
      }
      // if (bNeedSave) {
      //   StateScriptProject.instance?.saveAllEnums();
      // }
      context.variables['enums'] = expEnums;

      var expAgents = [];
      for (var a in agents) {
        // expAgents.add({ 'id' : a.exportId , 'name' : a.name , 'upperName' : a.name.toUpperCase()});
        expAgents.add(a.exportInfo());
      }
      context.variables['agents'] = expAgents;
      var expComps = [];
      for (var comp in components) {
        expComps.add(comp.exportInfo());
      }
      context.variables['components'] = expComps;

      List agentClzs = [];


      StateScriptProject.instance!.behavicAgentProject!.classes.values.forEach((element) {
        agentClzs.add(element.getExportInfo());
      });

      String codePath = commonCodePath!;
      String codeNodePath = commonCodeNodePath!;

      context.variables['agentClzs'] = agentClzs;
      // context.variables['allParamTypes'] = allParamTypes;
      {
        var tempDir = PathUtil.join(tempPath, "object_creater");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codePath, "${getTemp2Name(f.path)}");
              Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
              File(savePath).writeAsStringSync(outCode);
            }
          }
        }
      }
      {
        var tempDir = PathUtil.join(tempPath, "define");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codePath, "${getTemp2Name(f.path)}");
              Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
              File(savePath).writeAsStringSync(outCode);
            }
          }
        }
      }

      {
        var tempDir = PathUtil.join(tempPath, "enum");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var fpath = PathUtil.join(tempDir, "base_gen.cs.temp");
          var f = File(fpath);
          if (f.existsSync()) {
            var templateData = f.readAsStringSync();
            final template = Template.parse(context, Source.fromString(templateData));
            var outCode = (template.render(context));
            outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
            var savePath = PathUtil.join(codePath, "EnumSolvers.cs");
            Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
            File(savePath).writeAsStringSync(outCode);
          }
        }
      }

      {
        var tempDir = PathUtil.join(tempPath, "enum/define");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            // var fpath = PathUtil.join(tempDir, "enum_.cs.temp");
            // var f = File(fp);
            if (f.existsSync() && f is File) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              for (var e in enums) {
                context.variables['enum'] = enumMap[e.guid];
                // context.variables['enumItem'] = {'name': ei.name};

                var outCode = (template.render(context));
                outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                var savePath = PathUtil.join(codePath, "${e.name}${getTempExt(f.path)}");
                Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                File(savePath).writeAsStringSync(outCode);
              }
            }
          }
        }
      }

      {
        var tempDir = PathUtil.join(tempPath, "enum");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var fpath = PathUtil.join(tempDir, "sub_gen.cs.temp");
          var f = File(fpath);
          if (f.existsSync()) {
            var templateData = f.readAsStringSync();
            final template = Template.parse(context, Source.fromString(templateData));
            for (var e in enums) {
              if (!e.exportSolver) continue;
              for (var ei in e.items) {
                context.variables['enum'] = {
                  'name': e.name,
                  'exportSolver': e.exportSolver,
                  'solveCompName': e.solveCompName,
                  'staticDataName': e.staticDataName,
                };
                context.variables['enumItem'] = {'name': ei.name};

                var outCode = (template.render(context));
                outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                var savePath = PathUtil.join(codePath, "${e.name}${ei.name}.cs");
                Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                File(savePath).writeAsStringSync(outCode);
              }
            }
          }
        }
      }
      {
        var tempDir = PathUtil.join(tempPath, "enum");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var fpath = PathUtil.join(tempDir, "base.cs.temp");
          var f = File(fpath);
          if (f.existsSync()) {
            var templateData = f.readAsStringSync();
            final template = Template.parse(
                context, Source.fromString(templateData));
            for (var e in enums) {
              if (!e.exportSolver) continue;
              for (var ei in e.items) {
                context.variables['enum'] = {
                  'name': e.name,
                  'exportSolver': e.exportSolver,
                  'solveCompName': e.solveCompName,
                  'staticDataName': e.staticDataName,
                };
                context.variables['enumItem'] = {'name': ei.name};

                var outCode = (template.render(context));
                outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
                var subPath = PathUtil.join(codeNodePath, "${e.name}");
                var subPathDir = Directory(subPath);
                if (!subPathDir.existsSync()) subPathDir.createSync(recursive: true);
                var savePath = PathUtil.join(subPathDir.path, "${e.name}Base.cs");
                if (File(savePath).existsSync()) continue;
                Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
                File(savePath).writeAsStringSync(outCode);
              }
            }
          }
        }
      }
      {
        var tempDir = PathUtil.join(tempPath, "enum");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var fpath = PathUtil.join(tempDir, "sub.cs.temp");
          var f = File(fpath);
          if (f.existsSync()) {
            var templateData = f.readAsStringSync();
            final template = Template.parse(
                context, Source.fromString(templateData));
            for (var e in enums) {
              if (!e.exportSolver) continue;
              for (var ei in e.items) {
                context.variables['enum'] = {
                  'name': e.name,
                  'exportSolver': e.exportSolver,
                  'solveCompName': e.solveCompName,
                  'staticDataName': e.staticDataName,
                };
                context.variables['enumItem'] = {'name': ei.name};

                var outCode = (template.render(context));
                outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");

                var subPath = PathUtil.join(codeNodePath, "${e.name}");
                var subPathDir = Directory(subPath);
                if (!subPathDir.existsSync()) subPathDir.createSync(recursive: true);


                var savePath = PathUtil.join(
                    subPathDir.path, "${e.name}${ei.name}.cs");
                Directory(PathUtil.dirname(savePath)).createSync(
                    recursive: true);
                if (File(savePath).existsSync()) continue;
                File(savePath).writeAsStringSync(outCode);
              }
            }
          }
        }
      }
      context.variables.clear();
      context.variables['namespace'] = ExportMappingConfig.instance!.namespace;
//    context.variables['nodes'] = expNodes;
      //interface
      for (var comp in components) {
        context.variables['component'] = comp.exportInfo();
        var tempDir = PathUtil.join(tempPath, "component");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(
                  context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codePath, "I${comp.name}${getTempExt(f.path)}");
              Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
              File(savePath).writeAsStringSync(outCode);
            }
          }
        }
        context.variables['component'] = comp.exportInfo();
        tempDir = PathUtil.join(tempPath, "component_manual");
        dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codeNodePath, "I${comp.name}Manual${getTempExt(f.path)}");
              if (!File(savePath).existsSync()) {
                Directory(PathUtil.dirname(savePath)).createSync(
                    recursive: true);
                File(savePath).writeAsStringSync(outCode);
              }
            }
          }
        }
      }
      context.variables.clear();
      context.variables['namespace'] = ExportMappingConfig.instance!.namespace;
      for (var agent in agents) {
        context.variables['agent'] = agent.exportInfo();
        var tempDir = PathUtil.join(tempPath, "agent");
        var dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codePath, "Agent${agent.name}${getTempExt(f.path)}");
              Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
              File(savePath).writeAsStringSync(outCode);
            }
          }
        }

        tempDir = PathUtil.join(tempPath, "agent_manual");
        dir = Directory(tempDir);
        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(
                  context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codeNodePath,
                  "Agent${agent.name}Manual${getTempExt(f.path)}");
              if (!File(savePath).existsSync()) {
                Directory(PathUtil.dirname(savePath)).createSync(
                    recursive: true);
                File(savePath).writeAsStringSync(outCode);
              }
            }
          }
        }

//      context.variables['agent'] = agent.exportInfo();
//      var templateFile = PathUtil.join(tempPath , "agent.temp");
//      var templateCode = File(templateFile).readAsStringSync();
//      final template = Template.parse(context, Source.fromString(templateCode));
//      var outCode = (template.render(context));
//      var savePath = PathUtil.join(codePath, "Agent${agent.name}.${ExportMappingConfig.instance.extension}");
//      Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
//      File(savePath).writeAsStringSync(outCode);
      }
    }

    // await exportFunctions(onlySSCS: !nodePathExists);
    exportVMCode();
    ///导出二进制数据
    await exportBinary(exportBin : currentExportConfig == csharpConfig || csharpConfig.active == false);
  }

  Future exportScriptBinary(ScriptInfo script) async {
    SSUnion.lastVarTypeGuid = null;
    if (exportIso!= null){
      // exportIso.send({"process":"导出各种代码"});
    }
    prepareExport();
    await exportBinary(exportBin : true , target: script);
  }

  Future exportFakeCode(ScriptInfo script) async{
    var shell = Shell(throwOnError : false  , verbose : false ,commandVerbose : false , commentVerbose : false , stdoutEncoding : utf8 , stderrEncoding : utf8);
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var tempPath = GlobalBoard.getCorrectDirectory(currentExportConfig!.templatePath, basePath: basePath);
    ExportMappingConfig.load(tempPath , force: true);
    var coolFormat = PathUtil.join(GlobalBoard.getWorkingPath() , "CoolFormat.exe");
    final context = Context.create();
    var bep = byteExportPath;
    GlobalBoard.tryCreateDirectory(bep, basePath: basePath);
    var bytePath = GlobalBoard.getCorrectDirectory(bep, basePath: basePath);

    FileUtils.tryCreateDirectory(bytePath);
    List<dynamic> lst = <dynamic>[];
    for (var n in script.scriptData!.nodes) {
      var nType = n.getNodeStructType();
      var funcFields = nType!.getFieldsByTypeGuid("___agentfunction___");
      if (funcFields != null) {
        for (var funcField in funcFields) {
          var afi = n.fieldValues[funcField.guid];
          if (afi == null) continue;
          var fv = afi?.value;
          if (fv != null) {
            // n.fieldValues[funcField.guid].value = "";
            var func = StateScriptProject.instance!.getFunction(fv);
            if (func != null) {
              lst.add({
                "nodeId" : n.exportId,
                "funcName" : funcField.name,
                "fakeCode" : func.getBlockBehavicCode(),
              });
            }
          }
        }
      }
    }
    if (lst.length <=0) return ;
    context.variables["scriptName"] = script.name;
    context.variables["funcs"] = lst;

    List<dynamic> nodes = <dynamic>[];
    for(var n in script.scriptData!.nodes){
      nodes.add(n.exportFakeCode(script.scriptData!));
    }
    context.variables["nodes"] = nodes;

    List<dynamic> ssfields = <dynamic>[];
    StateScriptProject.instance!.globalScriptVars.forEach((key, value) {
      var f = value.exportInfo();
      ssfields.add(f);
    });

    context.variables["sfields"] = ssfields;
    var tempDir = PathUtil.join(tempPath, "fake_code");
    var dir = Directory(tempDir);
    if (dir.existsSync()) {
      var files = dir.listSync();
      for (var f in files) {
        if (f is File && f.path.endsWith(".temp")) {
          var templateData = f.readAsStringSync();
          final template = Template.parse(context, Source.fromString(templateData));
          var outCode = (template.render(context));
          outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
          var fpath = PathUtil.join(bytePath, "${script.name}.cs");
          if (!Directory(bytePath).existsSync()){
            Directory(bytePath).createSync(recursive: true);
          }
          if (!DartCommon.isEmpty(script.specialExportPath)){

            var exPath = PathUtil.canonicalize(PathUtil.join(basePath ,  script.specialExportPath));//GlobalBoard.getCorrectDirectory(s.specialExportPath, basePath: basePath);
            // print("basePath = $basePath , specialExportPath = ${s.specialExportPath} ->$exPath");
            fpath = PathUtil.join(exPath ,  "${script.name}.cs");
            // var exPath = PathUtil.join(bytePath, s.exportPath);
            if (!Directory(exPath).existsSync()){
              Directory(exPath).createSync(recursive: true);
            }
          }

          // if (!File(savePath).existsSync()) {
          //   Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
          //   File(savePath).writeAsStringSync(outCode);
          // }
          File(fpath).writeAsStringSync(outCode);
          var cmd2 = '"$coolFormat" -f "${fpath.replaceAll("\\", "/")}"';
          await shell.run(cmd2);
          print("---- fake code: ${fpath}");
          File(fpath).renameSync(fpath.replaceAll(".cs", ".fakecs"));
        }
      }
    }
  }

  void runtimeExportFunctions(){
    //TODO add lua
    //cs
    if (csharpConfig.active){
      StateScriptProject.instance!.currentExportConfig = csharpConfig;
      final context = Context.create();
      var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
      var tempPath = GlobalBoard.getCorrectDirectory(csharpConfig.templatePath, basePath: basePath);
      ExportMappingConfig.load(tempPath , force: true);

      var tempDir = PathUtil.join(tempPath , "funccode");

      var dir = Directory(tempDir);
      if (dir.existsSync()) {
        var files = dir.listSync();
        for (var f in files) {
          if (f is File && f.path.endsWith(".temp")&& PathUtil.basename(f.path).startsWith("Functions")) {
            var templateData = f.readAsStringSync();

            context.variables['namespace'] = ExportMappingConfig.instance!.namespace;
            var functions = [];
            for(var func in StateScriptProject.instance!.functions){
              if (func.isAgent || !func.active) continue;
              // func.load();
              CodeBlocky.curentFunction = func;
              var fields = [];
              for(var f in func.localFields){
                var tp = SSFieldType.getFieldType(f.typeGuid);
                var expVal = ExportMappingConfig.instance!.mappingFieldValue(tp!.name, tp.parseValue(f.defaultValue) , {});
                fields.add({ "name" : f.name , "type":tp?.cname??"int","default": expVal });
              }
              var blkList = func.getBlockiesList();
              var code = blkList!.getExportCode();
              var afunc = {"name" :func.name , "code":code , "hash" : func.guid.hashCode , "fields" :fields, "guid": func.guid};
              if (func.active){
                functions.add(afunc);
              }
            }
            context.variables["functions"] = functions;
            final template = Template.parse(context, Source.fromString(templateData));
            var outCode = (template.render(context));
            outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n",multiLine:true), "");
            //outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n",multiLine:true), "");
            var codePath = PathUtil.join(GlobalBoard.docDir.path , "battlepus" ,"state_script");// //GlobalBoard.getCorrectDirectory(currentExportConfig.codeExportPath , basePath: basePath);
            if (!Directory(codePath).existsSync()){
              Directory(codePath).createSync(recursive: true);
            }

            var savePath = PathUtil.join(codePath, "Functions.sscs");
            outCode = outCode.replaceAll("#if", "//#if");
            outCode = outCode.replaceAll("#endif", "//#endif");
            // print("out code = $outCode");
            File(savePath).writeAsStringSync(outCode);
            // return savePath;
          }
        }
      }
    }

    // return null;
  }

  Future exportFunctions({bool onlySSCS = false}) async{
    final context = Context.create();
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var tempPath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance!.currentExportConfig!.templatePath, basePath: basePath);

    var shell = Shell(throwOnError : false  , verbose : false ,commandVerbose : false , commentVerbose : false , stdoutEncoding : utf8 , stderrEncoding : utf8);
    var coolFormat = PathUtil.join(GlobalBoard.getWorkingPath() , "CoolFormat.exe");

    var tempDir = PathUtil.join(tempPath , "funccode");

    var dir = Directory(tempDir);
    if (dir.existsSync()) {
      var files = dir.listSync();
      for (var f in files) {
        if (f is File && f.path.endsWith(".temp")&& PathUtil.basename(f.path).startsWith("Functions")) {
          var templateData = f.readAsStringSync();

          context.variables['namespace'] = ExportMappingConfig.instance!.namespace;
          var functions = [];
          for(var func in StateScriptProject.instance!.functions){
            if (func.isAgent || !func.active) continue;
            // func.load();
            CodeBlocky.curentFunction = func;
            var fields = [];
            for(var f in func.localFields){
              var tp = SSFieldType.getFieldType(f.typeGuid);
              var expVal = ExportMappingConfig.instance!.mappingFieldValue(tp!.name, tp!.parseValue(f.defaultValue) , {});
              fields.add({ "name" : f.name , "type":tp?.cname??"int","default": expVal });
            }
            var blkList = func.getBlockiesList();
            var code = blkList!.getExportCode();
            var afunc = {"name" :func.name , "code":code , "hash" : func.guid.hashCode , "fields" :fields , "guid": func.guid};
            if (func.active){
              functions.add(afunc);
            }
          }
          context.variables["functions"] = functions;
          final template = Template.parse(context, Source.fromString(templateData));
          var outCode = (template.render(context));
          outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n",multiLine:true), "");
          //outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n",multiLine:true), "");
          var codePath = PathUtil.join(basePath ,"outTemp" );
          if (!Directory(codePath).existsSync()){
            Directory(codePath).createSync(recursive: true);
          }
          if (onlySSCS){
            var savePath = PathUtil.join(codePath, "Functions.sscs");
            outCode = outCode.replaceAll("#if", "//#if");
            outCode = outCode.replaceAll("#endif", "//#endif");
            // print("out code = $outCode");
            File(savePath).writeAsStringSync(outCode);
            return ;
          }
          // var savePath = PathUtil.join(codePath, "Functions.cs");
          // print("out code = $outCode");
          var csCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
          if (!Directory(csCodePath).existsSync()){
            Directory(csCodePath).createSync(recursive: true);
          }
          var savePath = PathUtil.join(csCodePath, "${getTemp2Name(f.path)}");
          File(savePath).writeAsStringSync(outCode);

          var cmd2 = '"$coolFormat" -f "${savePath.replaceAll("\\", "/")}"';
          await shell.run(cmd2);

          savePath = PathUtil.join(codePath, "Functions.sscs");
          outCode = outCode.replaceAll("#if", "//#if");
          outCode = outCode.replaceAll("#endif", "//#endif");
          File(savePath).writeAsStringSync(outCode);
        }
      }
    }


  }

  void exportVMCode(){
    var shell = Shell(throwOnError : false  , verbose : false ,commandVerbose : false , commentVerbose : false , stdoutEncoding : utf8 , stderrEncoding : utf8);
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var tempPath = GlobalBoard.getCorrectDirectory(currentExportConfig!.templatePath, basePath: basePath);
    ExportMappingConfig.load(tempPath , force: true);
    var coolFormat = PathUtil.join(GlobalBoard.getWorkingPath() , "CoolFormat.exe");
    final context = Context.create();
    context.variables['namespace'] = ExportMappingConfig.instance!.namespace;

    List<FieldInfo> fields = <FieldInfo>[];
    List<BehavicAgentMethod> methods = <BehavicAgentMethod>[];
    for(var ag in StateScriptProject.instance!.behavicAgentProject!.classes.values){
      for(var m in ag.methods.values){
        methods.add(m);
      }
      for(var m in ag.fields.values){
        fields.add(m);
      }
    }

    SSObjBase.buildHashExportId(fields);
    SSObjBase.buildHashExportId(methods);

    List clzs = [];

    for(var ag in StateScriptProject.instance!.behavicAgentProject!.classes.values){
      var clz = ag.exportInfo();
      clzs.add(clz);
    }

    List ops = [];
    List sops = [];
    for(var opkey in  CodeBlockyType.ovmOperands.keys){

      var n = {
        "operate":opkey,
        "operate_val":CodeBlockyType.ovmOperates[opkey] ,
      };
      sops.add(n);
      var oprds = CodeBlockyType.ovmOperands[opkey];
      List tmp = [];
      for (var oprd in oprds!){
        var m = {
          "operate":opkey,
          "operand": oprd,
          "operate_val":CodeBlockyType.ovmOperates[opkey] ,
          "operand_val": CodeBlocky.operateExtras[oprd],
          "id": CodeBlockyType.ovmOperates[opkey]! + CodeBlocky.operateExtras[oprd]!,
        };
        tmp.add(m);
      }
      if(tmp.length <=0){
        tmp.add({
          "operate":opkey,
          "operand": 0,
          "operate_val":CodeBlockyType.ovmOperates[opkey] ,
          "operand_val": 0,
          "id": CodeBlockyType.ovmOperates[opkey],
        });
      }
      ops.add(tmp);

    }
    context.variables['OVMOPS'] = ops;
    context.variables['OVMSOPS'] = sops;
    List agentClzs = [];
    StateScriptProject.instance!.behavicAgentProject!.classes.values.forEach((element) {
      agentClzs.add(element.getExportInfo());
    });

    context.variables['agentClzs'] = agentClzs;

    SSObjBase.buildHashExportId(globalScriptVars.values.toList());
    List scriptVars = [];
    globalScriptVars.values.forEach((element) {
      scriptVars.add(element.exportInfo());
    });


    context.variables['scriptVars'] = scriptVars;

    // var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    // var iPath = currentExportConfig!.codeExportPath;
    // iPath = PathUtil.canonicalize(PathUtil.join(basePath , iPath));

    var fp = currentExportConfig!.defaultGenExportPath;
    var baseCodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.baseCodeExportPath , basePath: basePath);
    if (baseCodePath == null) return ;
    var iPath = PathUtil.join(baseCodePath , fp);
    if (!Directory(iPath).existsSync()) {
      print( "------------------------------------------------------------ 路径 $iPath 不存在");
      return ;
    }
    {
      var tempDir = PathUtil.join(tempPath, "behavic_codes");
      var dir = Directory(tempDir);
      if (dir.existsSync()) {
        var files = dir.listSync();
        for (var f in files) {
          if (f is File && f.path.endsWith(".temp")) {
            var savePath = PathUtil.join(iPath, "${getTemp2Name(f.path)}");

            context.variables['clazzes'] = clzs;
            var templateData = f.readAsStringSync();
            final template = Template.parse(context, Source.fromString(templateData));
            var outCode = (template.render(context));
            outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");

            Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
            File(savePath).writeAsStringSync(outCode);

            var cmd2 = '"$coolFormat" -f "${savePath.replaceAll("\\", "/")}"';
            shell.run(cmd2);
            // DartCommon.launchURL(savePath);
          }
        }
      }
    }


  }

  int? binaryVersionCode = 0;
  void generateVersionCode(String runtimeCodePath , String genCodePath){
    bool runtimeExists = runtimeCodePath != null && Directory(runtimeCodePath).existsSync();
    if (!runtimeExists){
      // BotToast.showText(text: "runtime 路径没有指定，无法创建二进制版本号",contentColor: Colors.redAccent);
      throw Exception("runtime 路径没有指定，无法创建二进制版本号");
    }

    bool genExists = genCodePath != null && Directory(genCodePath).existsSync();
    if (!genExists){
      // BotToast.showText(text: "gen 路径没有指定，无法创建二进制版本号",contentColor: Colors.redAccent);
      throw Exception("gen 路径没有指定，无法创建二进制版本号");
    }

    List<File> targetFiles = <File>[];
    // var runtimeFiles = Directory(runtimeCodePath).listSync(recursive: true);
    // for(var f in runtimeFiles){
    //   if (f is File && f.path.endsWith(".cs")){
    //     targetFiles.add(f);
    //   }
    // }

    var genFiles = Directory(genCodePath).listSync(recursive: true);
    for(var f in genFiles){
      if (f is File && f.path.endsWith("Data.cs")){
        targetFiles.add(f);
      }
    }

    targetFiles.sort((a,b)=>a.path.compareTo(b.path));

    StringBuffer sb = StringBuffer();
    for(var f in targetFiles){
      var str = f.readAsStringSync();
      var md5 = DartCommon.getMD5(str);
      sb.write(md5);
    }

    var finalMd5 = DartCommon.getMD5(sb.toString());
    binaryVersionCode = finalMd5.hashCode;
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var savePath = PathUtil.join(basePath, "BinaryVersionCode.txt");
    Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
    File(savePath).writeAsStringSync(binaryVersionCode.toString());
  }
  static var allScriptFieldsMap = Map<String,FieldInfo>();

  void buildScriptVarId(){
    var tnMap = Map<String , List<FieldInfo>>();
    for(var s in scripts) {
      s.scriptData!.scriptFieldVars.forEach((element) {

        var key = "${element.typeGuid}_${element.name}";
        var lst = tnMap[key];
        if (lst == null){
          lst = <FieldInfo>[];
          tnMap[key] = lst;
        }
        lst.add(element);

        allScriptFieldsMap[element.guid] = element;
      });
    }
    tnMap.forEach((key, lst) {
      var exid ;
      for(var f in lst){
        if (f.exportId != null){
          exid = f.exportId;
          break;
        }
      }

      lst.forEach((element) {
        element.exportId = exid;
      });
    });

    List<FieldInfo> dxLst = <FieldInfo>[];
    tnMap.forEach((key, lst) {
      dxLst.add(lst[0]);
    });
    SSObjBase.buildHashExportId(dxLst);
    dxLst.forEach((element) {
      var key = "${element.typeGuid}_${element.name}";
      var lst = tnMap[key];
      lst!.forEach((f) {
        f.exportId = element.exportId;
      });
    });
  }

  void exportGlobalInit(){
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var bep = byteExportPath;
    var bytePath = GlobalBoard.getCorrectDirectory(bep, basePath: basePath);
    ByteDataWriter bw = ByteDataWriter();

    //首先填写 Binary Version Code
    bw.writeUint32(binaryVersionCode , "binary version code : $binaryVersionCode");

    var fpath = PathUtil.join(bytePath, "ssinit.bytes");
    File(fpath).writeAsBytesSync(bw.toBytes());

    if (StateScriptProject.instance!.exportTxtInfo) {
      var fDebugPath = PathUtil.join(bytePath, "ssinit.txt");
      File(fDebugPath).writeAsStringSync(bw.debugOut.join("\n"));
    }
  }
  // var logger = Logger(
  //   printer: PrettyPrinter(
  //       methodCount: 0, // number of method calls to be displayed
  //       errorMethodCount: 8, // number of method calls if stacktrace is provided
  //       lineLength: 120, // width of the output
  //       colors: true, // Colorful log messages
  //       printEmojis: true, // Print an emoji for each log message
  //       printTime: false, // Should each log print contain a timestamp
  //       // noBoxingByDefault:true,
  //   ),
  // );

  Future exportBinary({bool exportBin = false , ScriptInfo? target}) async{
    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var bep =  byteExportPath;
    GlobalBoard.tryCreateDirectory(bep, basePath: basePath);
    var bytePath = GlobalBoard.getCorrectDirectory(bep, basePath: basePath);
    if (exportBin) {
      FileUtils.tryCreateDirectory(bytePath);
    }
    final context = Context.create();
    context.variables['namespace'] = ExportMappingConfig.instance!.namespace;


    var codePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.codeExportPath , basePath: basePath);
    var tempPath = GlobalBoard.getCorrectDirectory(currentExportConfig!.templatePath, basePath: basePath);


    // List<PortConnection> allPortConnections = List<PortConnection>();
    // List<ParamConnection> allParamConnections = List<ParamConnection>();

    // for(var s in scripts) {
    //   if (s.scriptData == null) {
    //     s.loadScript();
    //   }
    //   s.scriptData.name = s.name;
    //   s.scriptData.exportId = s.exportId;
    //
    //   allPortConnections.addAll(s.scriptData.portConnections);
    //   allParamConnections.addAll(s.scriptData.paramConnections);
    //
    //   // s.scriptData.prepareBinaryExport();
    //
    //
    // }
    //
    // SSObjBase.buildExportId(allPortConnections);
    // SSObjBase.buildExportId(allParamConnections);

    // connectionIdMap.clear();
    // allPortConnections.forEach((element) { connectionIdMap[element.guid] = element.exportId;});
    // allParamConnections.forEach((element) { connectionIdMap[element.guid] = element.exportId;});

    for(var s in scripts) {
      if (target != null && target != s){
        continue;
      }
      s.scriptData!.subScripts?.forEach((element) {
        element.buildSortY();
      });

      s.scriptData!.prepareBinaryExport();
    }


    exportGlobalInit();

    buildScriptVarId();
    var crtScript = ScriptInfo.current;
    for(var s in scripts){
      if (target != null && target != s){
        continue;
      }
      if (exportIso!= null){
        exportIso!.send({"process":"${s.name} ${s.alias}"});
      }
      print("------- export script guid : ${s.guid} , name : ${s.name}");
      // logger.i("------- export script guid : ${s.guid} , name : ${s.name} , ");
      // if (s.scriptData ==null) {
      //   s.loadScript();
      // }
      // s.scriptData.name = s.name;
      // s.scriptData.exportId = s.exportId;
      // s.scriptData.prepareBinaryExport();
      // if (s.scriptData.fullScriptsFields == null )s.scriptData.fullScriptsFields = Map<String , FieldInfo>();
      if (exportBin) {

        var codeNodePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.nodeCodeExportPath, basePath: basePath);
        bool nodePathExists = codeNodePath != null && Directory(codeNodePath).existsSync();
        if (nodePathExists){
          //程序侧，生成 VersionCode
          var runtimePath = GlobalBoard.getCorrectDirectory(currentExportConfig!.runtimeCodePath, basePath: basePath);
          // 不再生成
          // generateVersionCode(runtimePath,codePath);
        }
        else{
          //直接读取
          var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
          var savePath = PathUtil.join(basePath, "BinaryVersionCode.txt");
          // Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
          if(File(savePath).existsSync()){
            var code = File(savePath).readAsStringSync();
            binaryVersionCode = int.tryParse(code);

            if (binaryVersionCode == null){
              // BotToast.showText(text: "BinaryVersionCode.txt 读取失败，请联系程序解决",contentColor: Colors.redAccent);
              throw Exception("BinaryVersionCode.txt 读取失败，请联系程序解决");
              return;
            }
          }
          else{
            // BotToast.showText(text: "无法找到 BinaryVersionCode.txt ，请联系程序解决",contentColor: Colors.redAccent);
            throw Exception("无法找到 BinaryVersionCode.txt ，请联系程序解决");

            return;
          }
          // File(savePath).writeAsStringSync(binaryVersionCode.toString());
        }


        ByteDataWriter bw = ByteDataWriter();

        //首先填写 Binary Version Code
        bw.writeUint32(binaryVersionCode , "binary version code : $binaryVersionCode");

        var bagent = StateScriptProject.instance!.behavicAgentProject!.classes[s.behavicAgentGuid];
        // bw.writeInt32(bagent?.exportId??-1, "ba agent");
        ScriptInfo.setCurrentOnly(s);
        s.scriptData!.exportId = s.exportId;
        s.scriptData!.export(bw , hash : s.exportId!);

        var fpath = PathUtil.join(bytePath, "${s.name}.bytes");
        if (!DartCommon.isEmpty(s.specialExportPath)){

          var exPath = PathUtil.canonicalize(PathUtil.join(basePath ,  s.specialExportPath));//GlobalBoard.getCorrectDirectory(s.specialExportPath, basePath: basePath);
          print("basePath = $basePath , specialExportPath = ${s.specialExportPath} ->$exPath");
          fpath = PathUtil.join(exPath ,  "${s.name}.bytes");
          // var exPath = PathUtil.join(bytePath, s.exportPath);
          if (!Directory(exPath).existsSync()){
            Directory(exPath).createSync(recursive: true);
          }
        }
        File(fpath).writeAsBytesSync(bw.toBytes());

        if (StateScriptProject.instance!.exportTxtInfo) {
          var fDebugPath = PathUtil.join(bytePath, "${s.name}.txt");
          if (!DartCommon.isEmpty(s.specialExportPath)) {
            var exPath = PathUtil.canonicalize(PathUtil.join(basePath, s.specialExportPath));
            fDebugPath = PathUtil.join(exPath, "${s.name}.txt");
          }

          File(fDebugPath).writeAsStringSync(bw.debugOut.join("\n"));
        }
      }


        ScriptInfo.setCurrentOnly(s);
        StateScript.exportingScript = s.scriptData;
      var tempDir = PathUtil.join(tempPath, "code_data");
      var dir = Directory(tempDir);
      if (exportLuaDataCode && dir.existsSync()) {
        var data = s.scriptData!.exportCodeData(hash:s.exportId);
  //      print(data);
        context.variables['data'] = data;

        if (dir.existsSync()) {
          var files = dir.listSync();
          for (var f in files) {
            if (f is File && f.path.endsWith(".temp")) {
              var templateData = f.readAsStringSync();
              final template = Template.parse(context, Source.fromString(templateData));
              var outCode = (template.render(context));
              outCode =  replaceEmptyLine(outCode);//// outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\r\n", multiLine: true), "");
              var savePath = PathUtil.join(codePath, "${s.name}${getTempExt(f.path)}");
              Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
              File(savePath).writeAsStringSync(outCode);
            }
          }
        }
      }

      await exportFakeCode(s);
    }
    ScriptInfo.current = crtScript;

    EventCenter.eventBus.fire(GlobalRefreshEvent());
  }

  SSComponent? getComponent(String guid) {
    for(var c in components){
      if (c.guid == guid) return c;
    }

    return null;
  }

//  void importNode(NodeStructData n) {
//    if (n == null) return ;
//    var bt = NodeCamp.instance.getBaseType(n);
//    importNode(bt);
//    var exists = nodeStructs.where((element) => element.guid == n.guid).toList();
//    for(var en in exists){
//      nodeStructs.remove(en);
//    }
//
//    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
//    String json = encoder.convert(n);
//    var node = NodeStructData.fromJson(jsonDecode(json));
//    var code = node.code;
//    node.code = "";
//    nodeStructs.add(node);
//
//    var codePath = nodeCodeExportPath;
//    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
//    GlobalBoard.tryCreateDirectory(codePath, basePath: basePath);
//    var codeNodePath = GlobalBoard.getCorrectDirectory(codePath, basePath: basePath);
//    var nodeCodePath = PathUtil.join(codeNodePath , "${node.name}.cs");
//    File(nodeCodePath).writeAsStringSync(code);
//
//  }
  @JsonKey(ignore: true)
  List<FieldInfo>? fieldInfos;
  void buildFieldInfos(){
    if (fieldInfos == null){
      fieldInfos = <FieldInfo>[];
    }
    fieldInfos!.clear();
    {
      for (var comp in components) {
        // var comp = StateScriptProject.instance.getComponent(c);
        for (var f in comp.fields) {
          f.extraInfo = comp.getTypeShowString();
          f.extraInfo2 = comp.name;
          fieldInfos!.add(f);
        }
      }
    }

  }
  List<FieldInfo>? getAgentFieldInfos(){
    if (fieldInfos == null){
      buildFieldInfos();
    }

    return fieldInfos;
  }

  ScriptInfo? getScriptByName(String scriptName) {
    print(scriptName);
    var ss = scripts.where((element) => element.name == scriptName).toList();
    if (ss.length >=1){
      return ss[0];
    }

    return null;
  }

  ScriptInfo? getScriptByExportId(int eid) {
    var ss = scripts.where((element) => element.exportId == eid).toList();
    if (ss.length >=1){
      return ss[0];
    }

    return null;
  }

  ScriptInfo? getScriptByGuid(String scriptGuid) {
    print(scriptGuid);
    var ss = scripts.where((element) => element.guid == scriptGuid).toList();
    if (ss.length >=1){
      return ss[0];
    }

    return null;
  }

  void switchExportConfig(ExportConfig csharpConfig) {
    currentExportConfig = csharpConfig;
  }
  void clearBreakPoints(){
    for(var s in scripts){
      if (s.scriptData == null) continue;
      for (var n in s.scriptData!.nodes){
        n.enablePortDoneBreakPoint = false;
        n.enableParamDoneBreakPoint = false;
      }

      for (var con in s.scriptData!.portConnections){
        con.enableBreakPoint = false;
      }
      for (var con in s.scriptData!.paramConnections){
        con.enableBreakPoint = false;
      }
    }
  }
  String getBreakPoints(){
    List<String> bps = <String>[];
    for(var s in scripts){
      if (s.scriptData == null) continue;
      for (var n in s.scriptData!.nodes){
        if (n.enablePortDoneBreakPoint){
          var key = "${s.exportId}_${BreakPointType.BPT_PORT_DONE}_${n.exportId}";
          bps.add(key);
        }
        if (n.enableParamDoneBreakPoint){
          var key = "${s.exportId}_${BreakPointType.BPT_PARAM_DONE}_${n.exportId}";
          bps.add(key);
        }
      }

      for (var con in s.scriptData!.portConnections){
        if (con.enableBreakPoint){
          // var key = "${s.exportId}_${BreakPointType.BPT_PORT_CONNECTION}_${con.exportId}";
          var key = "${s.exportId}_${BreakPointType.BPT_PORT_CONNECTION}_${con.getConnectionId(s!.scriptData!)}";
          bps.add(key);
        }
      }
      for (var con in s.scriptData!.paramConnections){
        if (con.enableBreakPoint){
          // var key = "${s.exportId}_${BreakPointType.BPT_PARAM_CONNECTION}_${con.exportId}";
          var key = "${s.exportId}_${BreakPointType.BPT_PARAM_CONNECTION}_${con.getConnectionId(s!.scriptData!)}";
          bps.add(key);
        }
      }
    }
    if (RunSession.instance.isStepMode) bps.add("step_mode");
    return json.encode(BreakPointList()..bps = bps..isBreakPointActive = RunSession.instance.isBreakPointActive??false .. isFocusFrameMode = RunSession.instance.isFocusFrameMode??false);
  }

  void removeUnusfulFuncs() {
      StateScriptProject.cancelWatchProject();
      Map<String , bool> funcIds = Map<String , bool>();

      funcIds["shareTemplates"] = true;

      for(var s in scripts){
        var sd =  s.justLoadScript();
        for(var n in sd.nodes){
          var nType = n.getNodeStructType();
          if (nType == null){
            continue;
          }
          var funcFields = nType.getFieldsByTypeGuid("___agentfunction___");
          if (funcFields != null){
            for(var funcField in funcFields) {
              var afi = n.fieldValues[funcField.guid];
              if (afi == null) continue;
              var fv = afi?.value;
              // print(afi.value);
              if (fv != null) {
                var func = StateScriptProject.instance!.getFunction(fv);
                if (func != null) {
                  func.load();
                  func.isAgent = true;
                  func.active = true;
                  func.save(s.guid);
                }
                funcIds[fv] = true;
                funcIds["$fv-bin"] = true;
              }
            }
          }
          var funcFields2 = nType.getFieldsByTypeGuid("___function___");

          if (funcFields2 != null){
            for(var funcField in funcFields2) {
              var afi = n.fieldValues[funcField.guid];
              if (afi == null) continue;
              var fv = afi?.value;
              // print(afi.value);
              if (fv != null) {
                funcIds[fv] = true;
                funcIds["$fv-bin"] = true;
              }
            }
          }
        }
      }

    var path = SSStorage.getFunctionsStorePath();
    if (path != null){
      var fs = path.listSync(recursive: false);
      for(var s in fs){
        if (s is File) {
          var name = PathUtil.basenameWithoutExtension(s.path);
          // print(name);
          if (funcIds[name] != true){
            print("---- delete ${s.path}");
            s.deleteSync();
          }
        }
      }
    }
    //
    StateScriptProject.instance!.functions.removeWhere((element) => funcIds[element.guid] == null);

    StateScriptProject.doWatchProject();
    //

  }

  void fixFunctionSavePath() {
    StateScriptProject.cancelWatchProject();
    // Map<String , bool> funcIds = Map<String , bool>();
    //
    // funcIds["shareTemplates"] = true;

    for(var s in scripts){
      var sd =  s.justLoadScript();
      for(var n in sd.nodes){
        var nType = n.getNodeStructType();
        if (nType == null){
          continue;
        }
        var funcFields = nType.getFieldsByTypeGuid("___agentfunction___");
        if (funcFields != null){
          for(var funcField in funcFields) {
            var afi = n.fieldValues[funcField.guid];
            if (afi == null) continue;
            var fv = afi?.value;
            // print(afi.value);
            if (fv != null) {
              var func = StateScriptProject.instance!.getFunction(fv);
              if (func != null) {
                func.load();
                // func.isAgent = true;
                // func.active = true;
                func.save(s.guid);
              }
              // funcIds[fv] = true;
              // funcIds["$fv-bin"] = true;
            }
          }
        }
        // var funcFields2 = nType.getFieldsByTypeGuid("___function___");
        //
        // if (funcFields2 != null){
        //   for(var funcField in funcFields2) {
        //     var afi = n.fieldValues[funcField.guid];
        //     if (afi == null) continue;
        //     var fv = afi?.value;
        //     // print(afi.value);
        //     if (fv != null) {
        //       funcIds[fv] = true;
        //       funcIds["$fv-bin"] = true;
        //     }
        //   }
        // }
      }
    }

    // var path = SSStorage.getFunctionsStorePath();
    // if (path != null){
    //   var fs = path.listSync(recursive: false);
    //   for(var s in fs){
    //     if (s is File) {
    //       var name = PathUtil.basenameWithoutExtension(s.path);
    //       // print(name);
    //       if (funcIds[name] != true){
    //         print("---- delete ${s.path}");
    //         s.deleteSync();
    //       }
    //     }
    //   }
    // }
    //
    // StateScriptProject.instance.functions.removeWhere((element) => funcIds[element.guid] == null);

    StateScriptProject.doWatchProject();
    //

  }
  void collectConnectAssist() {
    scripts.forEach((element) {
      element.loadScript();
      var ss = element.scriptData;
      ss!.portConnections.forEach((con) {
        var outNodeGuid = con.outNodeGuid;
        var inNodeGuid = con.inNodeGuid;
        var outGuid = ss.nodeMap![outNodeGuid]?.getNodeStructType()?.guid;
        var inGuid = ss.nodeMap![inNodeGuid]?.getNodeStructType()?.guid;
        if (outGuid == null || inGuid == null) return;

        var m1 = ConnectAssist.instance!.records[outGuid];
        if (m1 == null){
          m1 = Map<String , int>();
          ConnectAssist.instance!.records[outGuid] = m1;
        }
        if (m1.containsKey(inGuid)){
          m1[inGuid] = m1[inGuid]! +1;
        }
        else{
          m1[inGuid] = 1;
        }

        {
          var m1 = ConnectAssist.instance!.records["p_$inGuid"];
          if (m1 == null) {
            m1 = Map<String, int>();
            ConnectAssist.instance!.records["p_$inGuid"] = m1;
          }
          if (m1.containsKey(outGuid)) {
            m1[outGuid] = m1[outGuid]! + 1;
          }
          else {
            m1[outGuid] = 1;
          }
        }

      });

      ss.paramConnections.forEach((con) {
        var outNodeGuid = con.outNodeGuid;
        var inNodeGuid = con.inNodeGuid;
        var outGuid = ss.nodeMap![outNodeGuid]?.getNodeStructType()?.guid;
        var inGuid = ss.nodeMap![inNodeGuid]?.getNodeStructType()?.guid;
        if (outGuid == null || inGuid == null) return;

        var m1 = ConnectAssist.instance!.records["op_$outGuid"];
        if (m1 == null){
          m1 = Map<String , int>();
          ConnectAssist.instance!.records["op_$outGuid"] = m1;
        }
        if (m1.containsKey(inGuid)){
          m1[inGuid] = m1[inGuid]! +1;
        }
        else{
          m1[inGuid] = 1;
        }

        {
          var m1 = ConnectAssist.instance!.records["ip_p_$inGuid"];
          if (m1 == null) {
            m1 = Map<String, int>();
            ConnectAssist.instance!.records["ip_p_$inGuid"] = m1;
          }
          if (m1.containsKey(outGuid)) {
            m1[outGuid] = m1[outGuid]! + 1;
          }
          else {
            m1[outGuid] = 1;
          }
        }

      });
    });

    var path = GlobalBoard.getCorrectDirectory(SSMainSetting.instance!.workingPath);
    var pathFile = PathUtil.join(path,"connection_assists.json");
    ConnectAssist.instance!.saveTo(pathFile);

  }

  void loadShareCodeBlockyTemplates(){

    var dir = SSStorage.getFunctionsStorePath();

    var jmBin = SSStorage.loadJson("shareTemplates" , root: dir.path);
    if (jmBin != null){
      var bd = BlockyList.fromJson(jmBin);
      shareCodeBlockyTemplates = bd;
    }
    else{
      shareCodeBlockyTemplates = BlockyList();
    }


  }

  void saveShareCodeBlockyTemplates(){
    if (shareCodeBlockyTemplates == null) return;
    var dir = SSStorage.getFunctionsStorePath();
    SSStorage.saveJson("shareTemplates" , shareCodeBlockyTemplates , root: dir.path);
  }

  void saveFunctionDirName() {
    scripts.forEach((element) {
      var dir = SSStorage.getFunctionsStorePath();
      var sdir = PathUtil.join(dir.path , element.guid);
      var adir = Directory(sdir);
      if (adir.existsSync()){
        var name = "_${element.exportId}-${element.name}(${element.alias})";
        File(PathUtil.join(sdir ,"$name")).writeAsStringSync("");
      }
    });
  }

  ScriptModule addModule() {
    if (scriptModules == null) {
      scriptModules = Map<String,ScriptModule>();
    }
    ScriptModule m = ScriptModule();
    scriptModules![m.guid] = m;

    SSObjBase.buildExportId(scriptModules!.values.toList());
    return m;
  }

  void deleteModule(ScriptModule sm) {
    if (scriptModules == null) {
      return;
    }
    scriptModules!.remove(sm.guid);
  }

  void buildHashExportIdForEnum(List<SSEnumType> enums) {
    // bool bNeedSave = false;
    for (var e in enums) {
//      var en = {'name' : e.name};

      int iMaxId = - (1<<31);
      List<int> useValues = <int>[];
      for (var i in e.items) {
        if (i.enumValue != null){
          useValues.add(i.enumValue!);
          i.exportId = null;
        }
      }
      for (var i in e.items) {
        if (i.enumValue == null && i.exportId != null){
          if (useValues.contains(i.exportId )) {
            i.exportId = null;
          }
          else {
            useValues.add(i.exportId!);
          }
        }
      }
      int iIndex = 0;
      for (var i in e.items) {
        var cid = i.enumValue ?? i.exportId;//??i.exportId??0;
        if (cid == null){
          while(useValues.contains(iIndex)) ++iIndex;
          cid = iIndex++;
          // bNeedSave = true;
          i.exportId = cid;
        }
        iMaxId = max(iMaxId , cid);
      }
    }

  }

}