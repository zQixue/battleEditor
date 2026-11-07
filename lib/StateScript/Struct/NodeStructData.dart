import 'dart:math';
import 'dart:ui';
 
import 'package:battlepus/ObjectTable/Struct/FieldTypes/FTObjectReference.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/StateScript/AutoFill/AutoFiller.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSAgentFunction.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSList.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSMap.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSUnion.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/SyncFieldInfo.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/Tagger/ATag.dart';
import 'package:battlepus/common/Tagger/TagSet.dart';
import 'package:battlepus/protos/transition.pb.dart';

part 'NodeStructData.g.dart';

class _PortIndexResult{
  int index = 0;
  bool success = false;
}

@JsonSerializable()
class NodeStructData extends SSObjBase implements CodeExporter{

  String baseType = ""; //GUID
  String group = "";
  List<FieldInfo> fields = <FieldInfo>[];

  @JsonKey(defaultValue: <InPort>[])
  List<InPort> inPorts = <InPort>[];
  @JsonKey(defaultValue: <OutPort>[])
  List<OutPort> outPorts = <OutPort>[];

  @JsonKey(defaultValue: <InParam>[])
  List<InParam> inParams = <InParam>[];

  @JsonKey(defaultValue: 180 )
  double width = 180;

  @JsonKey(defaultValue: false )
  bool withViewNode = false;

  @JsonKey(defaultValue: true )
  bool isLogicNode = true;

  @JsonKey(defaultValue: false )
  bool isSystemNode = false;

  @JsonKey(defaultValue: true )
  bool isViewNode = true;

  @JsonKey(defaultValue: "" )
  String? descriptionTemplate;

  @JsonKey(defaultValue: null)
  TagSet? tagSet ;

  @JsonKey(defaultValue: <int>[])
  List<int> dataHashs = <int>[];

  @JsonKey(defaultValue: false )
  bool isExportDynamicData = false;

  @JsonKey(defaultValue: "")
  String forceExportGenPath = "";

  @JsonKey(defaultValue: "")
  String forceExportNodePath = "";

  @JsonKey(defaultValue: false)
  bool needLoadResource = false;


  void buildInterfaces(){
    // inParams.clear();
    // outParams.clear();
    // inPorts.clear();
    // outPorts.clear();
    //
    // for(var i = 0 ; i <SSDefines.interfaceMaxCount ; ++i){
    //   var n = sprintf("%02d" , [i]);
    //   inPorts.add(InPort()..name = "ipt_$n"..guid = "ipt_$n");
    //   outPorts.add(OutPort()..name = "opt_$n"..guid = "opt_$n");
    //   inParams.add(InParam()..name = "ipm_$n"..guid = "ipm_$n"..paramType = "int");
    //   outParams.add(OutParam()..name = "opm_$n"..guid = "opm_$n"..paramType = "int");
    // }
  }

  @JsonKey(ignore: true)
  Map<String,FieldInfo>? _id2Fields;
  Map<String,FieldInfo?>? _id2LastFields;
  void buildFieldMap(){
    if (_id2Fields == null) _id2Fields = Map<String,FieldInfo>();
    if (_id2LastFields == null) _id2LastFields = Map<String,FieldInfo?>();
    _id2Fields!.clear();
    _id2LastFields!.clear();
    // fields.forEach((element) { _id2Fields[element.guid] = element;});
    collectFields(_id2Fields! ,_id2LastFields!, null);
  }

  Map<String,FieldInfo>? getAllFieldMap(){
    if (_id2Fields == null) buildFieldMap();
    return _id2Fields;
  }

  FieldInfo? collectFields(Map<String,FieldInfo> fmaps , Map<String,FieldInfo?> fLastMaps ,FieldInfo? last){
    var bnt = getBaseType();
    if (bnt != null){
      last = bnt.collectFields(fmaps ,fLastMaps, last);
    }

    fields.forEach((element) {
      fmaps[element.guid] = element;
      fLastMaps[element.guid] = last;
      last = element;
    });

    return last;
  }

  FieldInfo? getField(String guid){
    if (_id2Fields == null) buildFieldMap();
    return _id2Fields![guid];
  }

  FieldInfo? getLastField(String guid){
    if (_id2LastFields == null) buildFieldMap();
    return _id2LastFields![guid];
  }

  @JsonKey(ignore: true)
  Map<String,InParam>? _id2InParams;
  List<InParam>? _normalInParams;
  // List<InParam> _bindInParams;
  void buildInParamMap(){
    if (_id2InParams == null) _id2InParams = Map<String,InParam>();
    if (_normalInParams == null) _normalInParams = <InParam>[];
    // if (_bindInParams == null) _bindInParams = List<InParam>();
    _id2InParams!.clear();
    _normalInParams!.clear();
    // _bindInParams.clear();
    inParams.forEach((element) {
      // _id2InParams[element.guid] = element;
      if (_id2Fields != null && _id2Fields!.containsKey(element.bindFieldGuid)){
        // _bindInParams.add(element);
        _id2InParams![element.bindFieldGuid] = element;
      }
      else{
        _normalInParams!.add(element);
      }
    });
  }

  FieldInfo? getFieldByName(String name) {
    var bt = StateScriptProject.instance!.structMap![baseType ?? ""];
    if (bt != null) {
      var f = bt.getFieldByName(name);
      if (f != null) return f;
    }

    for(var f in fields){
      if (f.name == name){
        return f;
      }
    }
    return null;
  }

  FieldInfo? getFieldByAlias(String name) {
    var bt = StateScriptProject.instance!.structMap![baseType ?? ""];
    if (bt != null) {
      var f = bt.getFieldByAlias(name);
      if (f != null) return f;
    }

    for(var f in fields){
      if (f.alias == name){
        return f;
      }
    }
    return null;
  }


  FieldInfo? getFieldByTypeGuid(String typeGuid) {
    var bt = StateScriptProject.instance!.structMap![baseType ?? ""];
    if (bt != null) {
      var f = bt.getFieldByTypeGuid(typeGuid);
      if (f != null) return f;
    }

    for(var f in fields){
      if (f.typeGuid == typeGuid){
        return f;
      }
    }
    return null;
  }

  List<FieldInfo>? getFieldsByTypeGuid(String typeGuid) {

    List<FieldInfo> res = <FieldInfo>[];
    var bt = StateScriptProject.instance!.structMap![baseType ?? ""];
    if (bt != null) {
      var f = bt.getFieldsByTypeGuid(typeGuid);
      if (f != null) res.addAll(f) ;
    }

    for(var f in fields){
      if (f.typeGuid == typeGuid){
        res.add(f);
      }
    }
    return res;
  }
  void _collectFields(List<FieldInfo> res){
    var bt = StateScriptProject.instance!.structMap![baseType ?? ""];
    if (bt != null) {
      bt._collectFields(res);
    }

    res.addAll(fields);
  }
  List<FieldInfo> getAllFields() {

    List<FieldInfo> res = <FieldInfo>[];
    _collectFields(res);
    return res;
  }

  void _collectFieldsMap(Map<String,FieldInfo> res){
    var bt = StateScriptProject.instance!.structMap![baseType ?? ""];
    if (bt != null) {
      bt._collectFieldsMap(res);
    }
    fields.forEach((element) {
      res[element.name] = element;
    });

  }
  Map<String,FieldInfo> getAllFieldsNameMap() {

    Map<String,FieldInfo> res = Map<String,FieldInfo>();
    _collectFieldsMap(res);
    return res;
  }


  int getNormalInParamsCount(){
    if (_normalInParams == null) buildInParamMap();
    return _normalInParams!.length;
  }

  InParam? getNormalInParam(int iIndex){
    if (_normalInParams == null)buildInParamMap();
    if (iIndex<0 || iIndex >= _normalInParams!.length) return null;
    return _normalInParams![iIndex];
  }

  InParam? getBindInParam(String fieldGuid){
    return _id2InParams![fieldGuid];
  }

  @JsonKey(defaultValue: <OutParam>[])
  List<OutParam> outParams = <OutParam>[];

  //状态同步 表现node，remote 对象只需要创建此类node
  @JsonKey(defaultValue: false)
  bool isSyncNode = false;


  @JsonKey(defaultValue: false)
  bool isTimelineNode = false;

  @JsonKey(defaultValue: false)
  bool isFlipParam = false;

  bool getIsFlipParam(){
    if (isFlipParam) return true;
    var p = getBaseType();
    if (p!= null) return p.getIsFlipParam();
    return false;
  }

  bool getSyncTransformNode(){
    if (syncTransform) return true;
    var p = getBaseType();
    if (p!= null) return p.getSyncTransformNode();
    return false;
  }

  @JsonKey(defaultValue: <SyncFieldInfo>[])
  List<SyncFieldInfo> syncFields = <SyncFieldInfo>[];

  @JsonKey(defaultValue: "")
  String description = "";

  @JsonKey(defaultValue: "")
  String code = "";

  @JsonKey(defaultValue: 0xFF7F7F7F)
  int bgColor = 0xFF7F7F7F;

  FieldInfo addSyncField(){
    var f = new SyncFieldInfo();
    syncFields.add(f);
    return f;
  }

  void removeSyncField(FieldInfo f){
    if (syncFields.contains(f)){
      syncFields.remove(f);
    }
  }

  @JsonKey(defaultValue: false)
  bool withUpdateLogic = false;

  @JsonKey(defaultValue: false)
  bool isSystemType = false;

  //是否是debug节点
  @JsonKey(defaultValue: false)
  bool isDebugNode = false;

  FieldInfo addField(){
    FieldInfo f = new FieldInfo();
    fields.add(f);
    buildFieldMap();
    buildInParamMap();
    // SSObjBase.buildHashDataIdWithExist(fields , dataHashs);
    return f;
  }

  void removeField(FieldInfo f){
    if (fields.contains(f)){
      fields.remove(f);
      buildFieldMap();
      buildInParamMap();
    }
  }

  bool getOutPortIndex(String guid , _PortIndexResult res){

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      if (parent.getOutPortIndex(guid,res)){

        return true;
      }
    }
    for(int i = 0 ; i < max(inPorts.length , outPorts.length) ; ++i){
      if (i< outPorts.length) {
        var port = outPorts[i];
        if (port.guid == guid) {
          res.success = true;
          return true;
        }
      }
      res.index++;
    }

    return false;
  }
  Offset? getOutPortLocalOffset(String guid){
    _PortIndexResult res = _PortIndexResult();
    getOutPortIndex(guid,res);

    if (res.success){
      double y = SSDefines.nodePortHeight * res.index + SSDefines.nodePortHeight/2;
      // double x = SSDefines.nodeWidth + SSDefines.portOffX - SSDefines.portSize/2;
      double x = SSDefines.nodeWidth - SSDefines.portSize/2;
      return Offset(x,y);
    }
    return null;
  }
  NodeStructData? getBaseType(){
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    return bt;
  }
  bool getOutParamIndex(String guid , _PortIndexResult res){

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      if (parent.getOutParamIndex(guid,res)){

        return true;
      }
    }
    for(int i = 0 ; i < max(inParams.length , outParams.length) ; ++i){
      if (i< outParams.length) {
        var port = outParams[i];
        if (port.guid == guid) {
          res.success = true;
          return true;
        }
      }
      res.index++;
    }

    return false;
  }
  Offset? getOutParamLocalOffset(String guid){
    _PortIndexResult res = _PortIndexResult();
    getOutParamIndex(guid,res);
    var aph = getAllPortsHeight();
    if (res.success){
      if (!getIsFlipParam()) {
        double y = SSDefines.nodeParamHeight * res.index + SSDefines.nodeParamHeight / 2;
        // double x = SSDefines.nodeWidth + SSDefines.paramOffX - SSDefines.paramSize / 2;
        double x = SSDefines.nodeWidth - SSDefines.paramSize / 2;
        return Offset(x,y + aph);
      }
      else{
        double y = SSDefines.nodeParamHeight * res.index + SSDefines.nodeParamHeight / 2;
        // double x = -SSDefines.paramOffX + SSDefines.paramSize/2;
        double x = SSDefines.paramSize/2;
        return Offset(x,y + aph);
      }

    }
    return null;
  }

  InPort? getInPort(String inportguid){
    buildPortParamMap();
    var op = iportMap![inportguid];
    if (op != null) return op;
    // for(var i in inPorts){
    //   if (i.guid == inportguid) return i;
    // }

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      return parent.getInPort(inportguid);

    }
    return null;
  }

  OutPort? getStaticOutPort(String outportguid){
    buildPortParamMap();
    var op = oportMap![outportguid];
    if (op != null) return op;
    // for(var i in outPorts){
    //   if (i.guid == outportguid) return i;
    // }

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      return parent.getStaticOutPort(outportguid);

    }
    return null;
  }

  bool getInPortIndex(String guid , _PortIndexResult res){

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      if (parent.getInPortIndex(guid,res)){

        return true;
      }
    }
    for(int i = 0 ; i < max(inPorts.length , outPorts.length) ; ++i){
      if (i <inPorts.length) {
        var port = inPorts[i];
        if (port.guid == guid) {
          res.success = true;
          return true;
        }
      }
      res.index++;
    }

    return false;
  }
  Offset? getInPortLocalOffset(String guid){
    _PortIndexResult res = _PortIndexResult();
    getInPortIndex(guid , res);

    if (res.success){
      double y = SSDefines.nodePortHeight * res.index + SSDefines.nodePortHeight/2;
      // double x = - SSDefines.portOffX + SSDefines.portSize/2;
      double x = SSDefines.portSize/2;
      return Offset(x,y);
    }

    return null;
  }

  bool getInParamIndex(String guid , _PortIndexResult res){

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      if (parent.getInParamIndex(guid,res)){

        return true;
      }
    }
    for(int i = 0 ; i < max(inParams.length , outParams.length) ; ++i){
      if (i< inParams.length) {
        var port = inParams[i];
        if (port.guid == guid) {
          res.success = true;
          return true;
        }
      }
      res.index++;
    }

    return false;
  }
  Offset? getInParamLocalOffset(String guid){
    _PortIndexResult res = _PortIndexResult();
    getInParamIndex(guid,res);
    var aph = getAllPortsHeight();
    if (res.success){
      if (!getIsFlipParam()) {
        double y = SSDefines.nodeParamHeight * res.index + SSDefines.nodeParamHeight / 2;
        // double x = -SSDefines.paramOffX + SSDefines.paramSize / 2;
        double x = SSDefines.paramSize / 2;
        return Offset(x,y + aph);
      }
      else{
        double y = SSDefines.nodeParamHeight * res.index + SSDefines.nodeParamHeight / 2;
        // double x = SSDefines.nodeWidth + SSDefines.paramOffX - SSDefines.paramSize / 2;
        double x = SSDefines.nodeWidth- SSDefines.paramSize / 2;
        return Offset(x,y + aph);
      }

    }
    return null;
  }

  void refreshScripts(){
    // for(var s in StateScriptProject.instance.scripts){
    //   if (s.scriptData != null){
    //     s.scriptData.buildValidInterface();
    //   }
    // }
  }
  @JsonKey(ignore: true)
  Map<String,OutPort>? oportMap ;
  @JsonKey(ignore: true)
  Map<String,InPort>? iportMap ;
  @JsonKey(ignore: true)
  Map<String,OutParam>? oparamMap ;
  @JsonKey(ignore: true)
  Map<String,InParam>? iparamMap ;

  void buildPortParamMap(){
    if (oportMap != null){
      return;
    }

    oportMap = Map<String,OutPort>();
    outPorts.forEach((element) { oportMap![element.guid] = element;});
    iportMap = Map<String,InPort>();
    inPorts.forEach((element) { iportMap![element.guid] = element;});
    oparamMap = Map<String,OutParam>();
    outParams.forEach((element) { oparamMap![element.guid] = element;});
    iparamMap = Map<String,InParam>();
    inParams.forEach((element) { iparamMap![element.guid] = element;});

  }

  List<int> getAllOutPortHashes(){
    List<int> res = <int>[];
    var bs = getBaseType();
    if (bs!= null){
      var plst = bs.getAllOutPortHashes();
      res.addAll(plst);
    }

    res.addAll(dataHashs);
    return res;
  }

  OutPort newOutPort(){
    var op = OutPort();
    outPorts.add(op);
    if (oportMap != null) oportMap![op.guid] = op;

    SSObjBase.buildHashDataIdWithExist(outPorts , getAllOutPortHashes());
    return op;
  }

  void removeOutPort(OutPort outPort){
    if (outPorts.contains(outPort)){
      outPorts.remove(outPort);
      if (oportMap != null) oportMap!.remove(outPort.guid);
    }
    refreshScripts();
  }

  OutParam newOutParam(){
    var op = OutParam();
    outParams.add(op);
    if (oparamMap != null) oparamMap![op.guid] = op;
    return op;
  }

  void removeOutParam(OutParam outParam){
    if (outParams.contains(outParam)){
      outParams.remove(outParam);
      if (oparamMap != null) oparamMap!.remove(outParam.guid);
    }
    refreshScripts();
  }

  InPort newInPort(){
    var ip = InPort();
    inPorts.add(ip);
    if (iportMap != null) iportMap![ip.guid] = ip;
    return ip;
  }

  void removeInPort(InPort inPort){
    if (inPorts.contains(inPort)){
      inPorts.remove(inPort);
      if (iportMap != null) iportMap!.remove(inPort.guid);
    }
    refreshScripts();
  }



  InParam newInParam(){
    var op = InParam();
    inParams.add(op);
    buildInParamMap();
    if (iparamMap != null) iparamMap![op.guid] = op;
    SSObjBase.buildHashDataIdWithExist(inParams , dataHashs);
    return op;
  }

  void removeInParam(InParam inParam){
    if (inParams.contains(inParam)){
      inParams.remove(inParam);
      if (iparamMap != null) iparamMap!.remove(inParam.guid);
      buildInParamMap();
    }
    refreshScripts();
  }

  double getAllPortsHeight(){

    double res = 0;
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      res = parent.getAllPortsHeight();
    }

    var inPortHeight = inPorts.length * SSDefines.nodePortHeight;
    var outPortHeight = outPorts.length * SSDefines.nodePortHeight;
    var portHeight = max(inPortHeight , outPortHeight);

    return res + portHeight;
  }

  double getAllParamsHeight(){

    double res = 0;
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      res = parent.getAllParamsHeight();
    }

    var inHeight = inParams.length * SSDefines.nodeParamHeight;
    var outHeight = outParams.length * SSDefines.nodeParamHeight;
    var allHeight = max(inHeight , outHeight);

    return res + allHeight;
  }


  NodeStructData();
  //此处与类名一致，由指令自动生成代码
  factory NodeStructData.fromJson(Map<String, dynamic> json) =>
      _$NodeStructDataFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$NodeStructDataToJson(this);

  bool paramTypeExistInParent(String pt){
    var base = StateScriptProject.instance!.structMap![baseType];
    if (base == null) return false;

    for(var p in base.outParams){
      if (p.paramType.trim() == pt.trim()){
        return true;
      }
    }
    return base.paramTypeExistInParent(pt);
  }

  @override
  dynamic exportInfo() {
    var base = StateScriptProject.instance!.structMap![baseType];
    var baseName = base==null?"":base.name;


    print("type name : ${name}");
    /// 静态字段
    var fieldInfos = [];
    for(var f in fields){
      var fo = f.exportInfo();
      fieldInfos.add(fo);
    }

    /// state 字段
    var syncFieldInfos = [];
    for(var f in syncFields){
      var fo = f.exportInfo();
      syncFieldInfos.add(fo);
    }

    /// out port
    var outInfos = [];
    for(var o in outPorts){
      var fo = o.exportInfo();
      outInfos.add(fo);
    }
    /// out port
    var inInfos = [];
    for(var o in inPorts){
      var fo = o.exportInfo();
      inInfos.add(fo);
    }

    /// 输入参数
    List<dynamic> inParamInfos = [];
    for(var o in inParams){
      var fo = o.exportInfo(fields : fields);

      inParamInfos.add(fo);
    }

    var paramTypes = [];
    /// 输入参数
    var outParamInfos = {};
    for(var o in outParams){
      var fo = o.exportInfo();
      var tp = ExportMappingConfig.instance?.mappingFieldName(o.paramType.trim() , {})??o.paramType.trim();
//      print(o.paramType);
      var lst = outParamInfos[o.paramType.trim()];
      if (lst == null) {
        lst = {
          'paramType' : tp,//o.paramType.trim(),
          'params' :[],
          'parentExist':paramTypeExistInParent(o.paramType)?1:0
        };
//        print("create");
        outParamInfos[o.paramType.trim()] = lst;
      }
      lst['params'].add(fo);

    }
//    print(outParamInfos);
    bool isDynamicExport = getIsExportDynamicData();
    var deType = getDynamicExportType();
    return {
      'name': name,
      'alias': alias,
      'guid': guid,
      'exportId':exportId??-1,
      'base': baseName,
      'fields' : fieldInfos,
      'inPorts' : inInfos.length>0?inInfos:null,
      'outPorts' : outInfos,
      'inParams' : inParamInfos,
      'outParams' : outParamInfos.values.toList(),
      'withUpdate' : getWithUpdateLogic(),
      'isTimelineNode': getIsTimelineNode()??false,
      'isSyncNode' : getIsSyncNode(),
      "isExportDynamicData" : isExportDynamicData??false,
      'withViewNode' : withViewNode??false,
      'baseIsSyncNode' : base != null && base.getIsSyncNode(),
      'syncFields' : syncFieldInfos,
      'isSystem': isSystemNode??false,
      'refTypes': getRefTypes(),
      'isDynamicExport': isDynamicExport,
      // 'dynamicExportAncestor': isDynamicExport?deType!.exportInfo():null,
      'createInstanceName' : isDynamicExport?deType!.name:name,
      "needLoadResource" : needLoadResource??false,
      'id': exportId,
      'isLogic': isLogicNode,
      'isView': isViewNode,
      'upperName': name.toUpperCase()
    };

  }

  bool getWithUpdateLogic(){
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) return bt.getWithUpdateLogic();

    return withUpdateLogic;
  }

  bool getIsTimelineNode(){
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) return bt.getIsTimelineNode();

    return isTimelineNode??false;
  }

  bool getIsExportDynamicData(){
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) return bt.getIsExportDynamicData();

    return isExportDynamicData ??false;
  }

  NodeStructData? getDynamicExportType(){
    if (!getIsExportDynamicData()) return null;

    NodeStructData? res = this;
    while(true){
      var bt = StateScriptProject.instance!.structMap![res!.baseType??""];
      if (bt != null && bt!.getIsExportDynamicData()){
        res = bt;
      }
      else{
        break;
      }
    }

    return res;
  }

  bool getIsSyncNode(){
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) return bt.getIsSyncNode();

    return isSyncNode;
  }

  bool hasField(String key) {
    if (fields.indexWhere((element) => element.guid==key) >=0){
      return true;
    }
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) return bt.hasField(key);

    return false;
  }

  Map exportMap(StateScriptNode node){
    var res = {};
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) bt.exportMap(node);
    var lastVarTypeGuid = null;
    ///字段
    for(var f in fields){
      var v = f.defaultValue;
      var vh = node.fieldValues[f.guid];

      if (vh != null){
        v = vh.value;
      }

      SSUnion.lastVarTypeGuid = null;
      SSUnion.lastVarTypeGuid = vh?.fieldType;
      if (null != lastVarTypeGuid) SSUnion.lastVarTypeGuid = lastVarTypeGuid;
      lastVarTypeGuid = null;

      var ft = SSFieldType.getFieldType(f.typeGuid, fieldInfo: f);
      ft!.exportFlag = f.name;
//      print("${f.guid} ${f.typeGuid}");
//      ft.export(bw , v);
      var expVal = ft!.exportValue(v);
      res[f.name] = expVal;
      if (ft is SSEnumType){
        // var akey = v is String?v:"";
        var item = ft!.findItem(ft.parseValue(v));
        res[f.name] = item?.name??"";
      }
      // expVal = ExportMappingConfig.instance!.mappingFieldValue(ft.name, expVal , {"type" : ft.getExportInfo()});
      // outFields.add({'name' :f.name ,'value':expVal });


      if (ft.guid == "___agentvar___"){
        var guid = ft.parseValue(v);
        var fields = StateScriptProject.instance!.getAgentFieldInfos();
        var field = CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
      if (ft.guid == "___scriptvar___"){
        var guid = ft.parseValue(v);
        // var fields = ScriptInfo.current.scriptData.scriptFields;
        var field = ScriptInfo.current!.scriptData!.fullScriptsFields![guid];//CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
    }
    return res;
  }

  void exportCodeData(List<dynamic> outArray , StateScriptNode node){
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) bt.exportCodeData(outArray , node);

    List<dynamic> outFields = <dynamic>[];
    var lastVarTypeGuid = null;
    ///字段
    for(var f in fields){
      var v = f.defaultValue;
      var vh = node.fieldValues[f.guid];

      if (vh != null){
        v = vh.value;
      }

      SSUnion.lastVarTypeGuid = null;
      SSUnion.lastVarTypeGuid = vh?.fieldType;
      if (null != lastVarTypeGuid) SSUnion.lastVarTypeGuid = lastVarTypeGuid;
      lastVarTypeGuid = null;

      var ft = SSFieldType.getFieldType(f.typeGuid, fieldInfo: f);
      ft!.exportFlag = f.name;
//      print("${f.guid} ${f.typeGuid}");
//      ft.export(bw , v);
      var expVal = ft!.exportValue(v);
      expVal = ExportMappingConfig.instance!.mappingFieldValue(ft.name, expVal , {"type" : ft.getExportInfo()});
      outFields.add({'name' :f.name ,'value':expVal });

      if (ft.guid == "___agentvar___"){
        var guid = ft.parseValue(v);
        var fields = StateScriptProject.instance!.getAgentFieldInfos();
        var field = CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
      if (ft.guid == "___scriptvar___"){
        var guid = ft.parseValue(v);
        // var fields = ScriptInfo.current.scriptData.scriptFields;
        var field = ScriptInfo.current!.scriptData!.fullScriptsFields![guid];//CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
    }
    ///out port
//    print(node.outPortDatas);
    List<dynamic> portDatas = <dynamic>[];
    for(var op in outPorts){
      if (node.outPortDatas == null){
        portDatas.add({'name' : op.name ,"id":op.exportId, 'links' : null});
//        bw.writeInt32(0 , "op $name.${op.name},link count == 0");
        continue;
      }
      var d = node.outPortDatas![op.guid];
      if (d == null){
//        bw.writeInt32(0 ,"op $name.${op.name},link count == 0");
        portDatas.add({'name' : op.name ,"id":op.exportId, 'links' : null});
        continue;
      }

      portDatas.add({'name' : op.name ,"id":op.exportId, 'links' : d.exportCodeData()});
    }
    ///in params
//    print(node.inParamDatas);
    List<dynamic> paramDatas = <dynamic>[];
    for(var op in inParams){
      if (node.inParamDatas == null){
//        bw.writeInt32(-1, "ip $name.${op.name},link count == -1");
//        paramDatas[op.name]
        paramDatas.add ({'name':op.name,"id":op.exportId, 'link' : null});
        continue;
      }
      var d = node.inParamDatas![op.guid];
      if (d == null){
//        bw.writeInt32(-1,"ip $name.${op.name},link count == -1");
        paramDatas.add ({'name':op.name,"id":op.exportId, 'link' : null});
        continue;
      }
      paramDatas.add ({'name':op.name,"id":op.exportId, 'link' :d.exportCodeData()});
    }

    outArray.add({
      'typeName' : name,
      'fields' : outFields,
      'outPorts' : portDatas,
      'inParams' : paramDatas,
    });
  }

  void exportDynamicMode(ByteDataWriter bw, StateScriptNode node) {

    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) {

      bt.export(bw,node);
      bw.writeUint8(1, "后续有子类");
    }


    var lastVarTypeGuid ;
    bw.writeUint32(fields.length, "字段数量: ${fields.length}");
    ///字段
    for(var f in fields){
      var v = f.defaultValue;
      var vh = node.fieldValues[f.guid];

      var overrideGuid = "${node.guid}-${f.guid}";
      var overrideValue = StateScript.exportingScript!.overrideFieldValues[overrideGuid];
      if (overrideValue != null){
        vh = overrideValue;
        // print("-------------------- with or field");
      }
      if (vh != null){
        v = vh.value;
      }
      var ft = SSFieldType.getFieldType(f.typeGuid, fieldInfo: f);
      if (ft == null){
        print("error : ${name}.${f.name}.${f.typeGuid}");
      }
      ft!.exportFlag = f.name;
//      print("${f.guid} ${f.typeGuid}");
      SSUnion.lastVarTypeGuid = null;
      SSUnion.lastVarTypeGuid = vh?.fieldType;
      if (null != lastVarTypeGuid) SSUnion.lastVarTypeGuid = lastVarTypeGuid;
      lastVarTypeGuid = null;
      if (ft is SSAgentFunction){
        String str = ft.parseValue(v);
        var cb = StateScriptProject.instance!.getFunction(str);
        if (cb != null){
          cb.isAgent = true;
          cb.extraParam = f?.extraParam;
        }
      }
      bw.writeString(f.name, "字段名: ${f.name}");
      if (ft is SSEnumType){
        bw.writeInt8(60, "字段类型: 枚举");
      }
      else {
        bw.writeInt8(ft.exportId, "字段类型: ${ft.exportId ?? 0}");
      }
      ft.export(bw , v , prms: {"dynamicMode" : true ,"node" : node , "field": f});


      if (ft.guid == "___agentvar___"){
        var guid = ft.parseValue(v);
        var fields = StateScriptProject.instance!.getAgentFieldInfos();
        var field = CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
      if (ft.guid == "___scriptvar___"){
        var guid = ft.parseValue(v);
        // var fields = ScriptInfo.current.scriptData.scriptFields;
        var field = ScriptInfo.current!.scriptData!.fullScriptsFields![guid];//CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
    }

    SSUnion.lastVarTypeGuid = null;

    bool bIsModule = name == "Module";
    ///out port
//    print(node.outPortDatas);
//     HashSet<String> used = HashSet<String> () ;

    bw.writeUint32(outPorts.length, "出口数量: ${outPorts.length}");
    for(var op in outPorts){

      bw.writeString(op.name, "出口名: ${op.name}");
      op.export(bw, node);
      // bw.writeUint32(op.exportId ,"out port id == ${op.exportId}");
      // if (node.outPortDatas == null){
      //   bw.writeInt32(0 , "op $name.${op.name},link count == 0");
      //   continue;
      // }
      // var d = node.outPortDatas[op.guid];
      // if (d == null){
      //   bw.writeInt32(0 ,"op $name.${op.name},link count == 0");
      //   continue;
      // }
      // // used.add(op.guid);
      // d.export(bw);
    }
    //移除
    // if (node.outPortDatas != null) {
    //   //动态outport
    //   bw.writeUint32(bIsModule ? node.outPortDatas.length - used.length : 0, "dynamic out port data : ${bIsModule ? node.outPortDatas.length - used.length : 0}");
    //   if (bIsModule) {
    //     for (var key in node.outPortDatas.keys) {
    //       if (used.contains(key)) continue;
    //       var d = node.outPortDatas[key];
    //       //outPortId 是模板脚本中实际结点的outPortId
    //       bw.writeUint32(d.links[0].outPortId, "dynamic out port id == ${d.links[0].outPortId}");
    //       d.export(bw);
    //     }
    //   }
    // }
    // else{
    //   bw.writeUint32(0, "dynamic out port data : 0");
    // }

    ///in params
//    print(node.inParamDatas);
//     used.clear();
    bw.writeUint32(inParams.length, "参数入口数量: ${inParams.length}");
    for(var op in inParams){
      bw.writeString(op.name, "参数入口名: ${op.name}");
      op.export(bw, node);

      // bw.writeUint32(op.exportId ,"in param id == ${op.exportId}");
      // if (node.inParamDatas == null){
      //   bw.writeInt32(-1, "ip $name.${op.name},link count == -1");
      //   continue;
      // }
      // var d = node.inParamDatas[op.guid];
      // if (d == null){
      //   bw.writeInt32(-1,"ip $name.${op.name},link count == -1");
      //   continue;
      // }
      // // used.add(op.guid);
      // d.export(bw);
    }

    //移除
    // if (node.inParamDatas != null) {
    //   bw.writeUint32(bIsModule ? node.inParamDatas.length - used.length : 0, "dynamic in param data : ${bIsModule ? node.inParamDatas.length - used.length : 0}");
    //   if (bIsModule) {
    //     for (var key in node.inParamDatas.keys) {
    //       if (used.contains(key)) continue;
    //       var d = node.inParamDatas[key];
    //       bw.writeUint32(d.inParamId, "dynamic in param id == ${d.inParamId}");
    //       d.export(bw);
    //     }
    //   }
    // }
    // else{
    //   bw.writeUint32(0, "dynamic in param data : 0");
    // }
  }
  // static ByteDataWriter fieldBw = ByteDataWriter();
  void export(ByteDataWriter bw, StateScriptNode node) {

    for(var f in fields) {
      if ((f.autoFillTrigger ?? false)) {
        var v = f.defaultValue;
        var vh = node.fieldValues[f.guid];

        var overrideGuid = "${node.guid}-${f.guid}";
        var overrideValue = StateScript.exportingScript!.overrideFieldValues[overrideGuid];
        if (overrideValue != null){
          vh = overrideValue;
          // print("-------------------- with or field");
        }
        if (vh != null){
          v = vh.value;
        }

        print("auto fill ${f.name}");
        AutoFiller.fill(node, f.name, v);
      }
    }

    bool dynamicMode = getIsExportDynamicData();
    if (dynamicMode) {
      exportDynamicMode(bw,node);

      return;
    }
    var bt = StateScriptProject.instance!.structMap![baseType??""];
    if (bt!= null) bt.export(bw,node);


    var lastVarTypeGuid ;
    ///字段
    for(var f in fields){
      var v = f.defaultValue;
      var vh = node.fieldValues[f.guid];

      var overrideGuid = "${node.guid}-${f.guid}";
      var overrideValue = StateScript.exportingScript!.overrideFieldValues[overrideGuid];
      if (overrideValue != null){
        vh = overrideValue;
        // print("-------------------- with or field");
      }
      if (vh != null){
        v = vh.value;
      }
      var ft = SSFieldType.getFieldType(f.typeGuid, fieldInfo: f);
      if (ft == null){
        print("error : ${name}.${f.name}.${f.typeGuid}");
      }
      ft!.exportFlag = f.name;
//      print("${f.guid} ${f.typeGuid}");
      SSUnion.lastVarTypeGuid = null;
      SSUnion.lastVarTypeGuid = vh?.fieldType;
      if (null != lastVarTypeGuid) SSUnion.lastVarTypeGuid = lastVarTypeGuid;
      lastVarTypeGuid = null;
      if (ft is SSAgentFunction){
        String str = ft.parseValue(v);
        var cb = StateScriptProject.instance!.getFunction(str);
        if (cb != null){
          cb.isAgent = true;
          cb.extraParam = f?.extraParam;
        }
      }
      if (StateScriptProject.instance!.useDataCompatible) {
        bw.writeUint32(f.dataId, "--- field data id ---");
        ByteDataWriter fieldBw = ByteDataWriter();
        ft.export(fieldBw, v,prms: {"dynamicMode" : false ,"node" : node , "field": f});
        // bw.writeUint16(fieldBw.getFinalLength(), "--- field data length ---");

        bw.writeBufferWithLengthUint16(fieldBw);
      }
      else{
        ft.export(bw , v,prms: {"dynamicMode" : false ,"node" : node , "field": f});
      }


      if (ft.guid == "___agentvar___"){
        var guid = ft.parseValue(v);
        var fields = StateScriptProject.instance!.getAgentFieldInfos();
        var field = CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
      if (ft.guid == "___scriptvar___"){
        var guid = ft.parseValue(v);
        // var fields = ScriptInfo.current.scriptData.scriptFields;
        var field = ScriptInfo.current!.scriptData!.fullScriptsFields![guid];//CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
    }
    if (StateScriptProject.instance!.useDataCompatible) {
      bw.writeInt32(0, "--- field data end ---");
    }
    SSUnion.lastVarTypeGuid = null;

    bool bIsModule = name == "Module";
    ///out port
//    print(node.outPortDatas);
//     HashSet<String> used = HashSet<String> () ;
    for(var op in outPorts){
      if (StateScriptProject.instance!.useDataCompatible) {
        bw.writeUint32(op.dataId, "--- out port data id ---");


        ByteDataWriter fieldBw = ByteDataWriter();
        op.export(fieldBw, node);
        // bw.writeUint16(fieldBw.getFinalLength(), "--- out port data length ---");

        bw.writeBufferWithLengthUint16(fieldBw);
      }
      else{
        op.export(bw, node);
      }
      // bw.writeUint32(op.exportId ,"out port id == ${op.exportId}");
      // if (node.outPortDatas == null){
      //   bw.writeInt32(0 , "op $name.${op.name},link count == 0");
      //   continue;
      // }
      // var d = node.outPortDatas[op.guid];
      // if (d == null){
      //   bw.writeInt32(0 ,"op $name.${op.name},link count == 0");
      //   continue;
      // }
      // // used.add(op.guid);
      // d.export(bw);
    }
    if (StateScriptProject.instance!.useDataCompatible) {
      bw.writeInt32(0, "--- out port end ---");
    }
    //移除
    // if (node.outPortDatas != null) {
    //   //动态outport
    //   bw.writeUint32(bIsModule ? node.outPortDatas.length - used.length : 0, "dynamic out port data : ${bIsModule ? node.outPortDatas.length - used.length : 0}");
    //   if (bIsModule) {
    //     for (var key in node.outPortDatas.keys) {
    //       if (used.contains(key)) continue;
    //       var d = node.outPortDatas[key];
    //       //outPortId 是模板脚本中实际结点的outPortId
    //       bw.writeUint32(d.links[0].outPortId, "dynamic out port id == ${d.links[0].outPortId}");
    //       d.export(bw);
    //     }
    //   }
    // }
    // else{
    //   bw.writeUint32(0, "dynamic out port data : 0");
    // }

    ///in params
//    print(node.inParamDatas);
//     used.clear();
    for(var op in inParams){
      if (StateScriptProject.instance!.useDataCompatible) {
        bw.writeUint32(op.dataId, "--- in param data id ---");

        ByteDataWriter fieldBw = ByteDataWriter();
        op.export(fieldBw, node);
        // bw.writeUint16(fieldBw.getFinalLength(), "--- in param data length ---");

        bw.writeBufferWithLengthUint16(fieldBw);
      }
      else{
        op.export(bw, node);
      }

      // bw.writeUint32(op.exportId ,"in param id == ${op.exportId}");
      // if (node.inParamDatas == null){
      //   bw.writeInt32(-1, "ip $name.${op.name},link count == -1");
      //   continue;
      // }
      // var d = node.inParamDatas[op.guid];
      // if (d == null){
      //   bw.writeInt32(-1,"ip $name.${op.name},link count == -1");
      //   continue;
      // }
      // // used.add(op.guid);
      // d.export(bw);
    }
    if (StateScriptProject.instance!.useDataCompatible) {
      bw.writeInt32(0, "--- in param end ---");
    }
    //移除
    // if (node.inParamDatas != null) {
    //   bw.writeUint32(bIsModule ? node.inParamDatas.length - used.length : 0, "dynamic in param data : ${bIsModule ? node.inParamDatas.length - used.length : 0}");
    //   if (bIsModule) {
    //     for (var key in node.inParamDatas.keys) {
    //       if (used.contains(key)) continue;
    //       var d = node.inParamDatas[key];
    //       bw.writeUint32(d.inParamId, "dynamic in param id == ${d.inParamId}");
    //       d.export(bw);
    //     }
    //   }
    // }
    // else{
    //   bw.writeUint32(0, "dynamic in param data : 0");
    // }
  }

  OutParam? getOutParam(String outParamGuid) {

    buildPortParamMap();
    var op = oparamMap![outParamGuid];
    if (op != null) return op;

    // for(var i in outParams){
    //   if (i.guid == outParamGuid) return i;
    // }

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      return parent.getOutParam(outParamGuid);

    }
    return null;
  }

  InParam? getStaticInParam(String inParamGuid) {
    buildPortParamMap();
    var op = iparamMap![inParamGuid];
    if (op != null) return op;
    // for(var i in inParams){
    //   if (i.guid == inParamGuid) return i;
    // }

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      return parent.getStaticInParam(inParamGuid);

    }
    return null;
  }

  bool isTypeOf(NodeStructData nodeType) {

//    if (baseType == nodeType.guid) return true ;
    if (guid == nodeType.guid) return true;
    var bt = getBaseType();
    if (bt == null) return false;
    return bt.isTypeOf(nodeType);
  }

  @override
  ObjInfo? getUnityTransformInfo(data , objList){
    if (data is StateScriptNode){
      ObjInfo obj = ObjInfo();
      obj.guid = data.guid;
      obj.name = name; //TP name
      obj.showName = alias;
      bool bValid = false;
      for (var field in fields ){
        var ftp = SSFieldType.getFieldType(field.typeGuid,fieldInfo: field);
        if (field.name == "position"){
          // var ftp = SSFieldType.getFieldType(field.typeGuid);
          var pos = ftp!.parseValue(data.fieldValues[field.guid]?.value??[0.0,0.0,0.0]);
          // print(pos);
          obj.position = V3()..x = pos[0]..y = pos[1]..z = pos[2];
          bValid = true;
        }
        if (field.name == "rotation"){
          // var ftp = SSFieldType.getFieldType(field.typeGuid);
          var rot = ftp!.parseValue(data.fieldValues[field.guid]?.value??[0.0,0.0,0.0]);
          // print(rot);
          obj.rotation = V3()..x = rot[0]..y = rot[1]..z = rot[2];
          bValid = true;
        }

        if (field.name == "prefab"){
          obj.prefab = ftp!.parseValue(data.fieldValues[field.guid]?.value??"");
        }

        if (field.name == "box_size"){
          var size = ftp!.parseValue(data.fieldValues[field.guid]?.value??[0.0,0.0,0.0]);
          // print(rot);
          obj.boxSize = V3()..x = size[0]..y = size[1]..z = size[2];
          bValid = true;
        }

        if (ftp is FTObjectReference){
          // print(ftp.innerType0);
          var clz = ObjectClazz.getClazz(field.innerTypeGuid0);
          if (clz!.syncTransform) {

            var otobj = ObjectClazz.allObjects[data.fieldValues[field.guid]?.value];
            if (otobj != null){
              clz.getUnityTransformInfo(otobj , objList);
            }
          }
        }

        if (ftp is SSList){
           var intp = SSFieldType.getFieldType(ftp.innerTypeGuid0);
           if (intp is FTObjectReference){
             var clz = ObjectClazz.getClazz(intp.innerTypeGuid0);
             if (clz!.syncTransform) {
               var objInList = ftp.parseValue(data.fieldValues[field.guid]?.value??[]);
               for(var objid in objInList) {
                 var otobj = ObjectClazz.allObjects[objid];
                 if (otobj != null) {
                   clz.getUnityTransformInfo(otobj, objList);
                 }
               }
             }
           }
        }

        if (ftp is SSMap){
          var intp = SSFieldType.getFieldType(ftp.innerTypeGuid0);
          if (intp is FTObjectReference){
            var clz = ObjectClazz.getClazz(intp.innerTypeGuid0);
            if (clz!.syncTransform) {
              // print("SSMap");
              var objInList = ftp.parseValue(data.fieldValues[field.guid]?.value??[]);

              objInList.forEach((element) {
                var key = element["key"];
                var val = element["value"];
                if (key != null && val != null) {
                  var otobj = ObjectClazz.allObjects[val];
                  if (otobj != null) {
                    clz!.getUnityTransformInfo(otobj, objList);
                  }
                }
              }
              );
            }
          }
        }

      }
      if (bValid && syncTransform) {
        objList?.add(obj);
        return obj;
      }
      return null;
    }
    else {
      return null;
    }
  }
  // num fixValue(v , len){
  //   return NumUtil.getNumByValueDouble(v, len);
  // }
  //
  // num fixAngle(v , len){
  //   while(v>170){
  //     v-= 360;
  //   }
  //   return NumUtil.getNumByValueDouble(v, len);
  // }

  void setFieldValue(StateScriptNode node , String guid , dynamic val , String name){
    FieldValueHolder v = FieldValueHolder()..value = val..name = name;
    node.fieldValues[guid] = v;
  }

  @override
  void setUnityTransformInfo(ObjInfo udata , data){
    for (var field in fields ){
      if (field.name == "position"){
        setFieldValue(data , field.guid,[DartCommon.fixValue(udata.position.x , 6),DartCommon.fixValue(udata.position.y, 6),DartCommon.fixValue(udata.position.z, 6)],field.name);
        // data.fieldValues[field.guid].value = [DartCommon.fixValue(udata.position.x , 6),DartCommon.fixValue(udata.position.y, 6),DartCommon.fixValue(udata.position.z, 6)];
      }
      if (field.name == "rotation"){
        setFieldValue(data , field.guid,[DartCommon.fixAngle(udata.rotation.x , 3),DartCommon.fixAngle(udata.rotation.y , 3),DartCommon.fixAngle(udata.rotation.z , 3)],field.name);
        // data.fieldValues[field.guid].value = [DartCommon.fixAngle(udata.rotation.x , 3),DartCommon.fixAngle(udata.rotation.y , 3),DartCommon.fixAngle(udata.rotation.z , 3)];
      }
      if (field.name == "box_size"){
        setFieldValue(data , field.guid,[DartCommon.fixAngle(udata.boxSize.x , 3),DartCommon.fixAngle(udata.boxSize.y , 3),DartCommon.fixAngle(udata.boxSize.z , 3)],field.name);
        // data.fieldValues[field.guid].value = [DartCommon.fixAngle(udata.rotation.x , 3),DartCommon.fixAngle(udata.rotation.y , 3),DartCommon.fixAngle(udata.rotation.z , 3)];
      }
    }
  }

  int getInPortCount() {
    int count = inPorts.length;
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      count += parent.getInPortCount();
    }

    return count;
  }

  int getOutPortCount() {
    int count = outPorts.length;
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      count += parent.getOutPortCount();
    }

    return count;
  }

  void clearExportId() {
    exportId = null;
    for(var p in inPorts){
      p.exportId = null;
    }
    for(var p in outPorts){
      p.exportId = null;
    }

    for(var p in inParams){
      p.exportId = null;
    }

    for(var p in outParams){
      p.exportId = null;
    }

    for(var p in fields){
      p.exportId = null;
    }
  }

  bool hasInParamType(String inParamFilter) {

    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      if (parent.hasInParamType(inParamFilter)){
        return true;
      }
    }

    for(var op in inParams){
      if (op.paramType == inParamFilter) return true;
    }

    return false;
  }

  List<InParam> getInParamsOfType(String inParamFilter) {
    List<InParam> res = [];
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      var res2 = parent.getInParamsOfType(inParamFilter);
      res.addAll(res2);
    }

    for(var op in inParams){
      if (op.paramType == inParamFilter) res.add(op);
    }

    return res;
  }

  bool hasOutParamType(String outParamFilter) {
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      if (parent.hasOutParamType(outParamFilter)){
        return true;
      }
    }

    for(var op in outParams){
      if (op.paramType == outParamFilter) return true;
    }
    // outParams.forEach((element) {
    //   if (element.paramType == outParamFilter) return true;
    // });

    return false;
  }

  List<OutParam> getOutParamsOfType(String outParamFilter) {
    List<OutParam> res = [];
    var parent = StateScriptProject.instance!.structMap![baseType];
    if (parent != null){
      var res2 = parent.getOutParamsOfType(outParamFilter);
      res.addAll(res2);
    }

    for(var op in outParams){
      if (op.paramType == outParamFilter) res.add(op);
    }

    return res;
  }

  int getIDFlag() {
    if (tagSet == null || tagSet!.tagGuids.length <=0) return ATag.tagCommonFlag;
    return tagSet!.getIDFlag() ;
  }

  String? getTagGenExportPath(bool isCSharp){
    if (tagSet == null) return null ;
    if (isCSharp) {
      for (var tguid in tagSet!.tagGuids) {
        var tag = StateScriptProject.instance!.tagCamp.tags[tguid];
        if (tag != null) {
          if (isLogicNode == isViewNode) {
            if (!DartCommon.isEmpty(tag.commonGenPath)) {
              return tag.commonGenPath;
            }
          }
          else if (isLogicNode) {
            if (!DartCommon.isEmpty(tag.logicGenPath)) {
              return tag.logicGenPath;
            }
          }
          else if (isViewNode) {
            if (!DartCommon.isEmpty(tag.viewGenPath)) {
              return tag.viewGenPath;
            }
          }
        }
      }
    }
    else{
      for (var tguid in tagSet!.tagGuids) {
        var tag = StateScriptProject.instance!.tagCamp.tags[tguid];
        if (tag != null) {
          if (isLogicNode == isViewNode) {
            if (!DartCommon.isEmpty(tag.commonGenPathLua)) {
              return tag.commonGenPath;
            }
          }
          else if (isLogicNode) {
            if (!DartCommon.isEmpty(tag.logicGenPathLua)) {
              return tag.logicGenPath;
            }
          }
          else if (isViewNode) {
            if (!DartCommon.isEmpty(tag.viewGenPathLua)) {
              return tag.viewGenPath;
            }
          }
        }
      }
    }

    return null;
  }

  String? getTagNodeExportPath(bool isCSharp){
    if (tagSet == null) return null ;
    if (isCSharp) {
      for (var tguid in tagSet!.tagGuids) {
        var tag = StateScriptProject.instance!.tagCamp.tags[tguid];
        if (tag != null) {
          if (isLogicNode == isViewNode) {
            if (!DartCommon.isEmpty(tag.commonNodePath)) {
              return tag.commonNodePath;
            }
          }
          else if (isLogicNode) {
            if (!DartCommon.isEmpty(tag.logicNodePath)) {
              return tag.logicNodePath;
            }
          }
          else if (isViewNode) {
            if (!DartCommon.isEmpty(tag.viewNodePath)) {
              return tag.viewNodePath;
            }
          }
        }
      }
    }
    else{
      for (var tguid in tagSet!.tagGuids) {
        var tag = StateScriptProject.instance!.tagCamp.tags[tguid];
        if (tag != null) {
          if (isLogicNode == isViewNode) {
            if (!DartCommon.isEmpty(tag.commonNodePathLua)) {
              return tag.commonNodePath;
            }
          }
          else if (isLogicNode) {
            if (!DartCommon.isEmpty(tag.logicNodePathLua)) {
              return tag.logicNodePath;
            }
          }
          else if (isViewNode) {
            if (!DartCommon.isEmpty(tag.viewNodePathLua)) {
              return tag.viewNodePath;
            }
          }
        }
      }
    }

    return null;
  }

  List getRefTypes() {
    List res = [];
    fields.forEach((element) {
      var fo = element.exportInfo() as Map;
      if (fo == null) return ;
      if (fo["type"]["name"] == "ref"){
        var innerType1 = fo["type"]["innerType1"];
        if (innerType1 == null) return ;
        if (!res.contains(innerType1["name"])) res.add(innerType1["name"]);
      }
      if (fo["type"]["isEnum"] == "1"){
        res.add(fo["type"]["name"]);
      }

      if (fo["type"]["name"] == "AgentFunction"){
        res.add("AgentFunction");
      }

      if (fo["type"]["name"] == "List"){
        var innerType1 = fo["type"]["innerType1"];
        if (innerType1 == null) return ;
        if (innerType1["name"] == "ref"){
          var innerType1_1 = innerType1["innerType1"];
          if (innerType1_1 == null) return ;
          if (!res.contains(innerType1_1["name"]))res.add(innerType1_1["name"]);
        }
        if (innerType1["isEnum"] == "1"){
          res.add(innerType1["name"]);
        }

        if (innerType1["name"] == "AgentFunction"){
          res.add("AgentFunction");
        }
      }
      if (fo["type"]["name"] == "Map"){
        var innerType1 = fo["type"]["innerType1"];
        if (innerType1 == null) return ;
        if (innerType1["name"] == "ref"){
          var innerType1_1 = innerType1["innerType1"];
          if (innerType1_1 == null) return ;
          if (!res.contains(innerType1_1["name"]))res.add(innerType1_1["name"]);
        }
        if (innerType1["isEnum"] == "1"){
          res.add(innerType1["name"]);
        }

        if (innerType1["name"] == "AgentFunction"){
          res.add("AgentFunction");
        }
      }
    });
    return res;
  }

}