import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/ConnectPainter.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/BinaryExportExtension.dart';
import 'package:battlepus/StateScript/Struct/CodeDataExporter.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutParam.dart';
import 'package:battlepus/StateScript/Struct/SubstituteOutPort.dart';
import 'package:battlepus/StateScript/TimelinePainter.dart';
import 'package:battlepus/Transition/PackSolver.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/protos/transition.pb.dart';

part 'StateScriptNode.g.dart';

@JsonSerializable()
class StateScriptNode extends SSObjBase implements BinaryExporter , CodeDataExporter{

  @JsonKey(ignore: true)
  Map<String ,dynamic> dynamicInterfaces = Map<String ,dynamic>();

  // @JsonKey(defaultValue: <String , List<OutPort>>{})
  // Map<String , List<OutPort>> dynamicOutPorts = Map<String ,List<OutPort>>();
  //
  // @JsonKey(defaultValue: <String , List<InParam>>{})
  // Map<String , List<InParam>> dynamicInParams = Map<String ,List<InParam>>();
  //
  // @JsonKey(defaultValue: <dynamic , String>{})
  // Map<String , String> dynamicTriggerNames = Map<String , String>();

  @JsonKey(defaultValue: <String , List<OutPort>>{})
  Map<String , Map<String , OutPort>> dynamicFieldOutPorts = Map<String ,Map<String , OutPort>>();

  @JsonKey(defaultValue: <String , List<InParam>>{})
  Map<String , Map<String , InParam>> dynamicFieldInParams = Map<String ,Map<String , InParam>>();

  // @JsonKey(defaultValue: <dynamic , String>{})
  // Map<String , DynamicTriggerInfo> dynamicTriggerInfos = Map<String , DynamicTriggerInfo>();

  @JsonKey(ignore: true)
  Offset downPointer = Offset.zero;
  @JsonKey(ignore: true)
  Offset downStorePos = Offset.zero;

  double x = 0.0;
  double y = 0.0;

  @JsonKey(ignore: true)
  double oriX = 0.0;
  @JsonKey(ignore: true)
  double oriY = 0.0;

  @JsonKey(ignore: true)
  double oriWidth = 0.0;

  @JsonKey(defaultValue: "")
  String group ="";
  @JsonKey(defaultValue: "")
  String description = "";

  @JsonKey(defaultValue: 0)
  double descOffX = 0.0;
  @JsonKey(defaultValue: 0)
  double descOffY = 0.0;

  @JsonKey(defaultValue: "")
  String nodeAlias ="";

  @JsonKey(defaultValue: <String , dynamic>{})
  Map<String , FieldValueHolder> fieldValues = Map<String , FieldValueHolder>();

  @JsonKey(defaultValue: <String , bool>{})
  Map<String , bool> fieldForceShow = Map<String , bool>();

  @JsonKey(ignore: true)
  bool inEditting = false;

  //标记是否输出端口数据
  @JsonKey(ignore: true)
  bool inLogPortData =false;
  

  @JsonKey(defaultValue: false)
  bool showHelp = false;

  @JsonKey(ignore: false , defaultValue: false)
  bool eraseReady = false;

  @JsonKey(ignore: true)
  bool _selected = false;

  @JsonKey(defaultValue: false)
  bool enablePortDoneBreakPoint = false;

  @JsonKey(defaultValue: false)
  bool enableParamDoneBreakPoint = false;

  @JsonKey(defaultValue: 200)
  double tlWidth = 200.0;

  @JsonKey(ignore: true)
  static Map<String,bool> staticSelectedNodesMap = Map<String,bool>();
  @JsonKey(ignore: true)
  double sortY = 0;
  static void clearSelectedNodesMap(){
    staticSelectedNodesMap.clear();
  }

  @JsonKey(ignore: true)
  set selected(bool value) {

    if (_selected != value){
      // print("send ${this.guid}");
      EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = this);
    }
    _selected  = value;

    ConnectPainter.currentSelectTimelineClipNode = this;
    // if (_selected){
    //   staticSelectedNodesMap[guid] = true;
    // }
    // else{
    //   staticSelectedNodesMap.remove(guid);
    // }
  }

  @JsonKey(ignore: true)
  bool get selected {
    return _selected ?? false;
  }


    @JsonKey(ignore: true)
  Map<String , OutPortData>? outPortDatas;

  @JsonKey(ignore: true)
  bool active = false;

  @JsonKey(ignore: true)
  String scriptName = "";

  @JsonKey(ignore: true)
  int? scriptId = -1;

  @JsonKey(ignore: true)
  double totalLineHeight = 0;

  @JsonKey(ignore: true)
  bool isModuleNode = false;

  @JsonKey(ignore: true)
  bool isRootModuleNode = false;

  @JsonKey(ignore: true)
  Map<String , Offset>? portYPos ;

  @JsonKey(defaultValue: <SubstituteOutParam>[])
  List<SubstituteOutParam> sops = <SubstituteOutParam>[];

  @JsonKey(defaultValue: <SubstituteOutPort>[])
  List<SubstituteOutPort> soports = <SubstituteOutPort>[];

  static bool alphaParamLineColor = true;
  static bool withTimelineNode = false;

  @JsonKey(defaultValue: <String , ModuleInterface>{})
  Map<String , ModuleInterface> moduleInterfaces = Map<String , ModuleInterface>();

  @JsonKey(ignore : true)
  static List<ModuleInterface> allModuleInterfaces = <ModuleInterface>[];


  void initPortYPos(){
    if (portYPos == null){
      portYPos = Map<String , Offset>();
      return ;
    }
    portYPos!.clear();
  }

  int getInPortCount(){
    var nsd = getNodeStructType();
    return nsd!.getInPortCount();
  }

  int getOutPortCount(){
    var nsd = getNodeStructType();
    return nsd!.getOutPortCount();
  }


  void addOutPortLink(String outGuid , int iNodeIndex , int iInPortId ,int oNodeIndex , int iOutPortId , int? connectionId , StateScriptNode outNode ,StateScriptNode inNode, OutPort op , InPort ip){
    if (outPortDatas == null) outPortDatas = Map<String , OutPortData>();
    OutPortData? od = outPortDatas![outGuid];
    if (od == null) od = OutPortData();
    outPortDatas![outGuid] = od;
    od.addLink(iNodeIndex,iInPortId , oNodeIndex ,iOutPortId , connectionId ,  outNode ,  inNode , op , ip);
  }

  @JsonKey(ignore: true)
  Map<String , InParamData>? inParamDatas;

  void addInParamLink(String inguid , int iOutNodeIndex , int iOutParamId , int iInNodeIndex , int iInParamId , int? connectionId,StateScriptNode outNode ,StateScriptNode inNode , OutParam op ,
      InParam ip2){
    if (inParamDatas == null) inParamDatas = Map<String , InParamData>();
    var ip = InParamData();
    ip.nodeId = iOutNodeIndex;
    ip.outParamId = iOutParamId;
    ip.inParamId = iInParamId;
    ip.inNodeId = iInNodeIndex;
    ip.connectionId = connectionId;
    ip.outNode = outNode;
    ip.inNode = inNode;

    ip.outParam = op;
    ip.inParam= ip2;
    inParamDatas![inguid] = ip;
  }

  List<SubstituteOutPort> getSubPortsByPortGuid(String portGuid){
    List<SubstituteOutPort> res = <SubstituteOutPort>[];
    for(var p in soports){
      if (p.outPortGuid == portGuid){// && nodeGuid == p.outNodeGuid){
        res.add(p);

      }
    }
    return res;
  }

  List<SubstituteOutParam> getSubParamsByParamGuid( String portGuid){
    List<SubstituteOutParam> res = <SubstituteOutParam>[];
    for(var p in sops){
      if (p.outParamGuid == portGuid){// && nodeGuid == p.outNodeGuid){
        res.add(p);
      }
    }
    return res;
  }

  Offset? getOutPortPosition(String guid){

    var nodeType = StateScriptProject.instance!.structMap![nodeTypeGuid];
    // var fullWidth = nodeType.width; //SSDefines.nodeWidth;// * (inEditting ? SSDefines.editFactor:1);
    if (nodeType == null) return null;
    // var off = nodeType.getOutPortLocalOffset(guid);
    var key = "${this.guid}_$guid";
    // print(portYPos);
    if (portYPos == null)return null;
    if (!portYPos!.containsKey(key)) return null;

    // double y = portYPos[key];//SSDefines.nodePortHeight * res.index + SSDefines.nodePortHeight/2;
    // double x = fullWidth- SSDefines.portSize/2;
    // var off = Offset(x,y);
    var off = portYPos![key];

    if (off == null) return null;
    return off + Offset(-5, 3) ;
  }

  Offset? getInPortPosition(String guid){

    var nodeType = StateScriptProject.instance!.structMap![nodeTypeGuid];
    if (nodeType == null) return null;
    // var off = nodeType.getInPortLocalOffset(guid);
    var key = "${this.guid}_$guid";
    // print(portYPos);
    // print(key);
    // print("==============================================================");
    if (portYPos == null)return null;
    if (!portYPos!.containsKey(key)) return null;
    // double y = portYPos[key];//SSDefines.nodePortHeight * res.index + SSDefines.nodePortHeight/2;
    // double x = SSDefines.portSize/2;
    // var off = Offset(x,y);
    var off = portYPos![key];

    if (off == null) return null;
    return off + Offset(5, 3) ;
  }


  SubstituteOutParam? getSOP(String guid){
    for(var sop in sops){
      if(sop.guid == guid){
        return sop;
      }
    }
    // print("getOutParamPositionBySOP error");
    return null;
  }

  SubstituteOutPort? getSOPort(String guid){
    for(var sop in soports){
      if(sop.guid == guid){
        return sop;
      }
    }
    // print("getOutParamPositionBySOP error");
    return null;
  }
  Offset? getOutPortPositionBySOP(String guid){
    for(var sop in soports){
      if(sop.guid == guid){
        var off = Offset(sop.x-10 , sop.y + 6 + SSDefines.sopHeight/2);
        return off;
      }
    }
    // print("getOutParamPositionBySOP error");
    return null;
  }
  Offset? getOutParamPositionBySOP(String guid){
    for(var sop in sops){
      if(sop.guid == guid){
        var off = Offset(sop.x-10 , sop.y + 6+ SSDefines.sopHeight/2);
        return off;
      }
    }
    // print("getOutParamPositionBySOP error");
    return null;
  }
  Offset? getOutParamPosition(String guid){

    var nodeType = StateScriptProject.instance!.structMap![nodeTypeGuid];
    // var fullWidth = nodeType.width;// * (inEditting ? SSDefines.editFactor:1);
    if (nodeType == null) return null;
    // var off = nodeType.getOutParamLocalOffset(guid);
    var key = "${this.guid}_$guid";
    if (portYPos == null)return null;
    if (!portYPos!.containsKey(key)) return null;
    // double y = portYPos[key];//SSDefines.nodePortHeight * res.index + SSDefines.nodePortHeight/2;
    // double x = 0;
    // if (!nodeType.getIsFlipParam()) {
    //   x = fullWidth - SSDefines.paramSize / 2;
    //
    // }
    // else{
    //   x = SSDefines.paramSize / 2;
    // }
    // var off = Offset(x,y);
    var off = portYPos![key];

    if (off == null) return null;
    return off + Offset(-3.5, 1.5) ;
  }

  Offset? getInParamPosition(String guid){
    var fullWidth = SSDefines.nodeWidth ;//* (inEditting ? SSDefines.editFactor:1);
    var nodeType = StateScriptProject.instance!.structMap![nodeTypeGuid];
    if (nodeType == null) return null;
    // var off = nodeType.getInParamLocalOffset(guid);
    var key = "${this.guid}_$guid";
    if (portYPos == null)return null;
    if (!portYPos!.containsKey(key)) return null;
    // double y = portYPos[key];//SSDefines.nodePortHeight * res.index + SSDefines.nodePortHeight/2;
    // double x = 0;
    // if (!nodeType.getIsFlipParam()) {
    //   x = SSDefines.paramSize / 2;
    // }
    // else{
    //   x = fullWidth - SSDefines.paramSize / 2;
    // }
    // var off = Offset(x,y);
    var off = portYPos![key];

    if (off == null) return null;
    return off + Offset(3.5, 1.5) ;
  }


  @JsonKey(defaultValue: "")
  String nodeTypeGuid = "";

  StateScriptNode();
  //此处与类名一致，由指令自动生成代码
  factory StateScriptNode.fromJson(Map<String, dynamic> json) =>
      _$StateScriptNodeFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$StateScriptNodeToJson(this);
  bool isNodeTypeValid(){
    var nt = StateScriptProject.instance!.structMap![nodeTypeGuid];
    return nt != null;
  }

  NodeStructData? getNodeStructType(){
    var nt = StateScriptProject.instance!.structMap![nodeTypeGuid];
    return nt;
  }

  void cloneAgentFunctions(ScriptInfo newScript){
    var tp = this.getNodeStructType();
    var funcFields = tp!.getFieldsByTypeGuid("___agentfunction___");
    if (funcFields != null){
      for(var funcField in funcFields) {
        var fv = this.fieldValues[funcField.guid]?.value;
        if (fv != null) {
          this.fieldValues[funcField.guid]!.value = "";
          var func = StateScriptProject.instance!.getFunction(fv);
          if (func != null) {
            var newfunc = func.clone(newScript);
            newfunc.rebuildGuid();
            // print(newfunc.guid);
            StateScriptProject.instance!.addFunction(newfunc);
            this.fieldValues[funcField.guid]!.value = newfunc.guid;
          }
        }
      }
    }
  }

  @JsonKey(ignore:true)
  static StateScriptNode? crtExportNode;

  @override
  void export(ByteDataWriter bw) {
    crtExportNode = this;
    bw.writeUint32(exportId ,"node id : ${exportId}");
    var nodeStruct = getNodeStructType();
    bw.writeUint32(nodeStruct!.exportId ,"node type : ${nodeStruct!.exportId}");

    // bw.writeInt32((x - SSDefines.canvasWidth/2).toInt(),"pos x");
    // bw.writeInt32((y - SSDefines.canvasHeight/2).toInt() , "pos y");
    bool isGroupEmpty = group == null || group.trim() == "";
    bw.writeInt32(isGroupEmpty?0:group.hashCode, "group");

    if (nodeStruct.getIsTimelineNode()??false){
      bw.writeInt8(1, "时间线节点");
      bw.writeFloat32(getStartTime(), "时间线起始时间点");
      bw.writeFloat32(getEndTime(), "时间线终止时间点");
    }
    else{
      bw.writeInt8(0, "非时间线节点");
    }
    //所有节点导出

    // }

    var nt = getNodeStructType();
    nt!.export(bw , this);
    if (nt.getIsExportDynamicData()) {
      bw.writeUint8(0, "后续没有有子类了");
    }
  }

  InPort? findInPort(StateScript ssd,String inPortGuid) {
    var nt = StateScriptProject.instance!.structMap![nodeTypeGuid];
    // if (nt.name == "Module"){
    //   var tgt = getModuleInterfaceTarget( nt ,  inPortGuid);
    //   if (tgt != null) return tgt;
    // }
    return nt!.getInPort(inPortGuid);
  }

  // dynamic getModuleInterfaceTarget(NodeStructData nodeType , String interfaceId){
  //
  //   if (nodeType.fields.length<=0) return null;
  //   var scriptFieldId = nodeType.fields[0].guid;
  //   var fvh = this.fieldValues[scriptFieldId];
  //   if (fvh== null) return null ;
  //   var scriptId = this.fieldValues[scriptFieldId].value as String;
  //   ScriptInfo si ;
  //   if (scriptId != null) {
  //     si = StateScriptProject.instance.getScriptByGuid(scriptId);
  //     if (si == null){
  //       return null ;
  //     }
  //   }
  //   //加载脚本
  //   if (si.scriptData == null) si.loadScript();
  //   var ssd = si.scriptData;
  //   return ssd.getModuleInterfaceTarget(interfaceId);
  // }

  OutPort? findOutPort(StateScript ssd, String outPortGuid) {
    var nt = StateScriptProject.instance!.structMap![nodeTypeGuid];
    // if (nt.name == "Module"){
    //   var tgt = getModuleInterfaceTarget( nt ,  outPortGuid);
    //   if (tgt != null) return tgt;
    // }
    return getOutPort(outPortGuid);
  }

  OutParam? findOutParam(StateScript ssd,String outParamGuid) {
    var nt = StateScriptProject.instance!.structMap![nodeTypeGuid];
    // if (nt.name == "Module"){
    //   var tgt = getModuleInterfaceTarget( nt ,  outParamGuid);
    //   if (tgt != null) return tgt;
    // }
    return nt!.getOutParam(outParamGuid);
  }

  InParam? findInParam(StateScript ssd,String inParamGuid) {
    // var nt = StateScriptProject.instance.structMap[nodeTypeGuid];
    // if (nt.name == "Module"){
    //   var tgt = getModuleInterfaceTarget( nt ,  inParamGuid);
    //   if (tgt != null) return tgt;
    // }
    return getInParam(inParamGuid);
  }

  dynamic getInterface(ModuleInterface mi){
    var nt = getNodeStructType();
    if (nt == null) return null;
    switch(mi.type){
      case InterfaceType.InPort:
        return nt.getInPort(mi.interfaceGuid);
      case InterfaceType.OutPort:
        return getOutPort(mi.interfaceGuid);
      case InterfaceType.InParam:
        return getInParam(mi.interfaceGuid);
      case InterfaceType.OutParam:
        return getOutPort(mi.interfaceGuid);
    }

    return null;
  }

  exportFakeCode(StateScript scriptData) {

    var nodeStruct = getNodeStructType();
    Map<String,dynamic> out = {'index' : exportId , 'nodeTypeId' : nodeStruct!.exportId};
    var outNameMap = scriptData.collectInParamNameMaps();
    var desc = getFullDesc(outNameMap);
    out['desc'] = "//"+desc.replaceAll("\n", "\n//");
    // List<dynamic> lst = List<dynamic>();
    // var n = this;
    // var nType = n.getNodeStructType();
    // var funcFields = nType.getFieldsByTypeGuid("___agentfunction___");
    // if (funcFields != null) {
    //   for (var funcField in funcFields) {
    //     var afi = n.fieldValues[funcField.guid];
    //     if (afi == null) continue;
    //     var fv = afi?.value;
    //     if (fv != null) {
    //       // n.fieldValues[funcField.guid].value = "";
    //       var func = StateScriptProject.instance.getFunction(fv);
    //       if (func != null) {
    //         lst.add({
    //           "nodeId" : n.exportId,
    //           "funcName" : funcField.name,
    //           "fakeCode" : func.getBlockBehavicCode(),
    //         });
    //       }
    //     }
    //   }
    // }
    //
    // out['func_count'] = lst.length;
    // out['funcs'] = lst;
    List<dynamic> ops = <dynamic>[];
    if (this.outPortDatas != null)
    this.outPortDatas!.forEach((key, value) {
      List<dynamic> ips = <dynamic>[];
      var outPort = "";
      value.links.forEach((element) {
        outPort = element.outPort.name;
        ips.add({
          "InNodeId": element.inNodeId,
          "InPortId": element.inPortId,
          "InPortName": element.inPort.name,
        });
      });
      ops.add({
        "outPortName" : outPort,
        "links" : ips,
      });
    });
    out['out_ports'] = ops;
    List<dynamic> ips = <dynamic>[];
    if (this.inParamDatas != null)
    this.inParamDatas!.forEach((key, value) {
      ips.add({
        "InParamName" : value.inParam.name,
        "OutNodeId" : value.nodeId,
        "OutParamId" : value.outParamId,
        "OutParamName" :value.outParam.name,
      });
    });

    out['in_params'] = ips;
    // out['posX'] = (x - SSDefines.canvasZeroX).toInt();
    // out['posY'] = (y - SSDefines.canvasZeroY).toInt();
    // out['group'] = group;
    // out['isStateNode'] = nodeStruct.getIsSyncNode();
    // out['withUpdateLogic'] = nodeStruct.getWithUpdateLogic();
    // List<dynamic> outData = List<dynamic>();
    // nodeStruct.exportCodeData(outData , this);
    // out['datas'] = outData;
    return out;
  }

  @override
  exportCodeData({int? hash}) {

    var nodeStruct = getNodeStructType();
    Map<String,dynamic> out = {'index' : exportId , 'nodeTypeId' : nodeStruct!.exportId};
    out['posX'] = (x - SSDefines.canvasZeroX).toInt();
    out['posY'] = (y - SSDefines.canvasZeroY).toInt();
    out['group'] = group;
    out['isStateNode'] = nodeStruct.getIsSyncNode();
    out['withUpdateLogic'] = nodeStruct.getWithUpdateLogic();
    // out['withViewNode'] = nodeStruct.withViewNode;


//
    List<dynamic> outData = <dynamic>[];
    nodeStruct.exportCodeData(outData , this);
    out['datas'] = outData;

    return out;
  }

  Map exportMap() {
    var nodeStruct = getNodeStructType();
    return nodeStruct?.exportMap(this)??{};
  }

  ObjInfo? getTransformInfo(objList) {
    var tp = getNodeStructType();
    // if (!tp.syncTransform) return null;
    if (tp!.syncTransform)PackSolver.registerTransitionObject(this);
    var res = tp.getUnityTransformInfo(this,objList);
    if (res != null){
      res..ex = x..ey = y;
    }
    return res;
  }

  String fullString(){
    var fullData = "id=$exportId";
    var tp = getNodeStructType();
    for(var fk in fieldValues.keys){
      var fv = fieldValues[fk];
      var field = tp!.getField(fk);
      if (field == null) continue;
      var fieldType = SSFieldType.getFieldType(field!.typeGuid ,fieldInfo: field );
      if (fieldType == null) continue;
      var fd = fieldType.getFilterString(fv!.value.toString());
      fullData = "$fullData`${field.alias}`$fd";
      // var tp = f.fieldType;
      // var rtp = SSFieldType.getFieldType(guid)
    }

    return "${tp!.name}`${tp!.alias}`$description`${tp!.description}`$fullData";
  }

  String getFullDesc(Map<String, Map<String, String>> outNameMap) {
    // if (DartCommon.isEmpty(description)) return description;
    // var nt = getNodeStructType();
    // var res = description ;//nt.getTypeShowString();
    //
    // if (!DartCommon.isEmpty(res) && res[0] == "#"){
    //   var newName = res.substring(1).replaceAllMapped(RegExp(r'\{\s*(\w+)\s*\}'), (match){
    //     var fieldName = match.group(1);
    //     var fi = nt.getFieldByName(fieldName); //widget.node.fie
    //     if (fi != null){
    //       // print(fi.guid);
    //       var val = fieldValues[fi.guid]?.value;
    //       if (val != null) {
    //         var ed = SSFieldType.getFieldType(fi.typeGuid, fieldInfo: fi);
    //         if (ed != null) {
    //           return ed.parseShortShowName(val);
    //         }
    //       }
    //       // return val;
    //     }
    //     return "";
    //   });
    //
    //   res = newName;
    // }
    if (!DartCommon.isEmpty(description)) return "${description??""}\n$exportId";
    // return "$exportId";
    // print("$outNameMap $guid");
    var selfNT = getNodeStructType();
    var descriptionTemplate = selfNT!.descriptionTemplate;
    if (!DartCommon.isEmpty(descriptionTemplate)){
      var nt = getNodeStructType();
      var res = descriptionTemplate;
      var inparams = outNameMap[guid]??{};
      // print(inparams);
      var newName = res!.replaceAllMapped(RegExp(r'\{([^}]+)\}'), (match){
        var fieldName = match.group(1);
        // print(fieldName);
        if (inparams[fieldName] != null){
          return inparams[fieldName]!;
        }


        var fi = nt!.getFieldByName(fieldName!); //widget.node.fie
        if (fi == null) {
          fi = nt!.getFieldByAlias(fieldName!);
        }
        if (fi != null){
          // print(fi.guid);
          var val = fieldValues[fi.guid]?.value;
          if (val != null) {
            var ed = SSFieldType.getFieldType(fi.typeGuid, fieldInfo: fi);
            if (ed != null) {
              return ed.parseShortShowName(val);
            }
          }
          // return val;
        }
        return "";
      });

      res = newName;
      // print("------------------------- newName : $newName");
      return res;
    }


    return "$exportId";
  }

  double getWidth() {
    var nt = getNodeStructType();
    // if (nt.isTimelineNode){
    //   return tlWidth;
    // }

    return nt!.width;
  }

  double getStartTime({double? v}){
    var s = TimelinePainter.step_1s;
    return ((v??x) - SSDefines.canvasZeroX)/s;
  }

  double getEndTime({double? v}){
    var s = TimelinePainter.step_1s;
    return ((v??x) + tlWidth - SSDefines.canvasZeroX)/s;
  }

  SyncNodeData? getSyncData(){
    SyncNodeData res = SyncNodeData();
    res.guid = guid;
    res.typeGuid = nodeTypeGuid;
    res.startTime = getStartTime();
    res.endTime = getEndTime();
    var nt = getNodeStructType();
    var fields = nt!.getAllFields();
    bool withSyncFields = false;
    for(var f in fields){
      var fv = fieldValues[f.guid]?.value;
      var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      fv =ft!.parseValue(fv??"");
      if (ft != null && fv != null){
        var ser = ft.syncSerialize(fv);
        if (ser != null){
          res.fieldValues.add(SyncFieldData()..guid = f.name..value = ser);
          withSyncFields = true;
        }
      }
    }

    if (withSyncFields) return res;
    return null;
  }

  void syncFromUnity(SyncNodeData data){
    var nt = getNodeStructType();
    if (nt == null) return ;
    var fmap = nt.getAllFieldsNameMap();

    for(var f in data.fieldValues){

      var fi = fmap[f.guid];
      if (fi == null) continue;

      var fv = fieldValues[f.guid];
      if (fv == null) {
        fv = FieldValueHolder()..name = fi.name;
        fieldValues[fi.guid] = fv;
      }

      var ft = SSFieldType.getFieldType(fi.typeGuid , fieldInfo: fi);
      if (ft == null) continue;
      var incomeValue = ft.syncDeserialize(f.value);
      if (incomeValue != null){
        fv.value = incomeValue;
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = this);
      }
    }
  }

  double getSortY() {
    if (this.isModuleNode){
      return sortY;
    }
    return y;
  }

  int? getCurrentFieldGroupId() {
    var fields = getNodeStructType()!.getAllFieldMap();
    for(var f in fields!.values){
      if (!f.isFieldGroup) continue;
      var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      if ((ft is SSEnumType)){
        return ft.getItemValue(fieldValues[f.guid]?.value);
      }
    }

    return null;
  }

  // dynamic outports
  OutPort? getOutPort(String outportguid){
    var op = getNodeStructType()!.getStaticOutPort(outportguid);
    if (op != null) {
      op.isDynamic = false;
      return op;
    }

    op = getDynamicOutPortMap()![outportguid];
    if (op != null) op.isDynamic = true;
    return op;
  }

  @JsonKey(ignore: true)
  Map<String , OutPort>? dynamicOutPortsMap ;//= Map<String ,OutPort>();

  void buildDynamicOutPortMap(){
    var fields = getNodeStructType()!.getAllFieldMap();
    List<String> inValidKeys = <String>[];
    dynamicFieldOutPorts.forEach((key, value) {
      if (!fields!.containsKey(key)){
        inValidKeys.add(key);
        return ;
      }
      if (!fields[key]!.withDynamicOutPort()){
        inValidKeys.add(key);
      }
    });
    inValidKeys.forEach((element) {
      dynamicFieldOutPorts.remove(element);
    });

    if (dynamicOutPortsMap != null) return ;
    dynamicOutPortsMap = new Map<String , OutPort>();
    dynamicFieldOutPorts.forEach((key, value) {
      var valids = fieldValues[key]?.getValidDynamicTriggers();
      List<String> deleted = [];
      value.forEach((key2,element) {
        if (valids!.contains(key2)) {
          dynamicOutPortsMap![element.guid] = element;
        }
        else{
          deleted.add(key2);
        }
      });

      deleted.forEach((element) {
        value.remove(element);
      });
    });
  }

  void rebuildDynamicOutPortMap(){
    dynamicOutPortsMap = null;
    buildDynamicOutPortMap();
  }

  Map<String , OutPort>? getDynamicOutPortMap(){
    if (dynamicOutPortsMap == null) buildDynamicOutPortMap();
    return dynamicOutPortsMap;
  }

  void buildDynamicOutPortId(){
    List<OutPort> outPorts = <OutPort>[];
    getDynamicOutPortMap()!.forEach((key, value) {
      outPorts.add(value);
    });

    SSObjBase.buildHashExportId(outPorts);
  }

  // OutPort newDynamicOutPort(){
  //   var op = new OutPort();
  //   buildDynamicOutPortMap();
  //
  // }

  // dynamic inparams
  InParam? getInParam(String inParamGuid){
    var ip = getNodeStructType()!.getStaticInParam(inParamGuid);
    if (ip != null) {
      ip.isDynamic = false;
      return ip;
    }

    ip = getDynamicInParamsMap()![inParamGuid];
    if (ip != null) ip.isDynamic = true;
    return ip;
  }

  @JsonKey(ignore: true)
  Map<String , InParam>? dynamicInParamsMap ;//= Map<String ,OutPort>();

  void buildDynamicInParamsMap(){
    var fields = getNodeStructType()!.getAllFieldMap();
    List<String> inValidKeys = <String>[];
    dynamicFieldInParams.forEach((key, value) {
      if (!fields!.containsKey(key)){
        inValidKeys.add(key);
        return ;
      }
      if (!fields[key]!.withDynamicInParam()){
        inValidKeys.add(key);
      }
    });
    inValidKeys.forEach((element) {
      dynamicFieldInParams.remove(element);
    });

    if (dynamicInParamsMap != null) return ;
    dynamicInParamsMap = new Map<String , InParam>();
    dynamicFieldInParams.forEach((key, value) {
      // value.forEach((key , element) {
      //   dynamicInParamsMap![element.guid] = element;
      // });

      var valids = fieldValues[key]?.getValidDynamicTriggers();
      List<String> deleted = [];
      value.forEach((key2,element) {
        if (valids!.contains(key2)) {
          dynamicInParamsMap![element.guid] = element;
        }
        else{
          deleted.add(key2);
        }
      });

      deleted.forEach((element) {
        value.remove(element);
      });
    });
  }

  void rebuildDynamicInParamsMap(){
    dynamicInParamsMap = null;
    buildDynamicInParamsMap();
  }

  Map<String , InParam>? getDynamicInParamsMap(){
    if (dynamicInParamsMap == null) buildDynamicInParamsMap();
    return dynamicInParamsMap;
  }

  void buildDynamicInParamId(){
    List<InParam> inParamss = <InParam>[];
    getDynamicInParamsMap()!.forEach((key, value) {
      inParamss.add(value);
    });

    SSObjBase.buildHashExportId(inParamss);
  }


}