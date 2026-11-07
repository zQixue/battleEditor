
import 'dart:convert';

import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/DartCommon.dart';

import 'package:battlepus/StateScript/SSDefines.dart';

part 'FieldInfo.g.dart';

@JsonSerializable()

class FieldInfo extends SSObjBase implements CodeExporter{

  @JsonKey(defaultValue: "___int___")
  String typeGuid = "___int___" ;

  @JsonKey(defaultValue: "___int___")
  String innerTypeGuid0 = "___int___" ;

  @JsonKey(defaultValue: "___int___")
  String innerTypeGuid1 = "___int___" ;

  @JsonKey(defaultValue: "")
  String agentBindInfo = "";

  @JsonKey(defaultValue: 1)
  int lineCount = 1;

  @JsonKey(defaultValue: 220)
  double width = 220;

  @JsonKey(defaultValue: false)
  bool isFreezeHeader = false ;

  @JsonKey(defaultValue: false)
  bool isSyncField = false ;

  @JsonKey(defaultValue: true)
  bool allowEmpty = true ;

  @JsonKey(defaultValue: false)
  bool isSearchKey = false ;

  @JsonKey(ignore : true)
  String extraInfo = "" ;

  @JsonKey(ignore : true)
  String extraInfo2 = "" ;

  @JsonKey(ignore : true)
  dynamic extraObject = "" ;

  @JsonKey(ignore : true)
  int extraType = 0 ;

  @JsonKey(defaultValue: "")
  String func = "" ;

  @JsonKey(defaultValue: 256)
  int gridWidth = 256;

  @JsonKey(defaultValue: false)
  bool isStatic = false ;

  @JsonKey(defaultValue: true)
  bool isPublic = true ;

  @JsonKey(defaultValue: false)
  bool isReadOnly = false ;

  @JsonKey(defaultValue: false)
  bool isRef = false ;

  @JsonKey(ignore: true)
  String group = "" ;

  @JsonKey(defaultValue: "")
  String desc = "" ;

  @JsonKey(defaultValue: "")
  String extraParam = "" ;

  @JsonKey(defaultValue: 0)
  int? dataId = 0 ;

  @JsonKey(defaultValue: false)
  bool isFieldGroup = false ;

  @JsonKey(defaultValue: null)
  List<int>? groupIds ;

  @JsonKey(defaultValue: false)
  bool haveDynamicOutPort = false ;

  @JsonKey(defaultValue: false)
  bool haveDynamicInParam = false ;

  @JsonKey(defaultValue: false)
  bool disabled = false ;

  @JsonKey(defaultValue: false)
  bool autoFillTrigger = false;

  @JsonKey(defaultValue: "")
  String resourceListGuid = "";

  @JsonKey(defaultValue: false)
  bool highlightEdit = false;

  String getFullType(){
    var fi = SSFieldType.getFieldType(typeGuid);
    if (fi!.innerTypeCount == 0){
      if (DartCommon.isEmpty(fi.cname)) return fi.name;
      return fi.cname;
    }
    if (fi.innerTypeCount == 1){
      var fi2 = SSFieldType.getFieldType(innerTypeGuid0);
      if (fi2 != null) return "${fi.cname}<${fi2.cname}>";
    }
    if (fi.innerTypeCount == 2){
      var fi2 = SSFieldType.getFieldType(innerTypeGuid0);
      var fi3 = SSFieldType.getFieldType(innerTypeGuid1);
      if (fi2 != null && fi3 != null)  return "${fi.cname}<${fi3.cname},${fi2.cname}>";
    }
    if (DartCommon.isEmpty(fi.cname)) return fi.name;
    return fi.cname;
  }

  bool withDynamicOutPort(){
    return haveDynamicOutPort && (typeGuid == "___list___");
    // if (typeGuid != "___list___") return false;
    // if (DartCommon.isEmpty(extraParam)) return false;
    // var vals = extraParam.split(",");
    // if (vals.length <2) return false;
    // return int.tryParse(vals[0]) == 1;
  }

  bool withDynamicInParam(){
    return haveDynamicInParam && (typeGuid == "___list___");
    // if (typeGuid != "___list___") return false;
    // if (DartCommon.isEmpty(extraParam)) return false;
    // var vals = extraParam.split(",");
    // if (vals.length <2) return false;
    // return int.tryParse(vals[1]) == 1;
  }

  void setDynamicTrigger(bool op , bool ip){
    haveDynamicInParam = ip;
    haveDynamicOutPort = op;
    // extraParam = "${op?1:0},${ip?1:0}";
  }

  int? getOperateExtraType(){
    var tp = getFullTypeWithExtra();
    var eid = CodeBlocky.operateExtras[tp];
    if (eid != null) return eid;
    if (tp.startsWith("Enum.")){
      return CodeBlocky.operateExtras["enum"];
    }
    if (tp.startsWith("BObj.")){
      return CodeBlocky.operateExtras["obj"];
    }

    return null;
  }

  String getFullTypeWithExtra(){
    var fi = SSFieldType.getFieldType(typeGuid);
    var tp = getFullType();
    if (fi is SSEnumType){
      return "Enum.$tp";
    }
    else if (fi is BehavicAgentClass){
      if (fi.isStruct??false){
        return "BStruct.$tp";
      }
      return "BObj.$tp";
    }

    return tp;
  }


//  String getType(){
//    var fi = SSFieldType.getFieldType(typeGuid);
//
//    return fi?.name??"NOTYPE";
//  }



  bool noInnerType(){
    return innerTypeGuid0 == null && innerTypeGuid1 == null;
  }

  @JsonKey(defaultValue: 0)
  dynamic defaultValue = 0;

  FieldInfo();
  //此处与类名一致，由指令自动生成代码
  factory FieldInfo.fromJson(Map<String, dynamic> json) =>
      _$FieldInfoFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FieldInfoToJson(this);


  @override
  dynamic exportInfo() {
    var agent ;
    if (agentBindInfo != null && agentBindInfo.trim()!=""){
      var datas = StateScriptProject.instance!.getAgentFieldInfos();
      var bindAgents = datas!.where((element) => element.guid == agentBindInfo).toList();
      if (bindAgents != null && bindAgents.length >0){
        // print("bind : " + bindAgents[0].name);
        var ba = bindAgents[0];
        agent = {"name" : ba.name , "id":ba.exportId };
        print(agent);
      }
    }
    print("fieldInfo : ${this.name}");
    var tp = SSFieldType.getFieldType(typeGuid,fieldInfo: this);
    var dv = tp!.getExportDefault(defaultValue);
    var vals = {
      'name': name,
      'alias': alias,
      'guid': guid,
      'id':exportId,
      'dataId': dataId,
      'hash': guid.hashCode,
      'isRef': isRef??false,
      "isStatic" : isStatic??false,
      "isReadOnly" : isReadOnly??false,
      "isPublic" : isPublic??false,
      'isSearchKey': isSearchKey,
      'haveDynamicOutPort':haveDynamicOutPort,
      'haveDynamicInParam':haveDynamicInParam,
      'agent_bind' : agentBindInfo.trim()==""?null:agentBindInfo.hashCode,
      'agent' : agent,
      'type' : tp.getExportInfo( extra : {'field': {'name': name,
        'alias': alias,
        'guid': guid,}})
    };
    // var tpei = tp.getExportInfo( extra : {'field': vals});
    //
    // vals = {
    //   'name': name,
    //   'alias': alias,
    //   'guid': guid,
    //   'type' : tp.getExportInfo( extra : {'field': "vals"}),
    // };

    // vals['type'] = tpei;
    // 'type': tp.getExportInfo( extra : {'name': name}),

    dv = ExportMappingConfig.instance!.mappingFieldValue(tp.name, dv , vals);
    vals['default'] = dv;
    return vals;

  }

  void copyTypes(String v) {
    var ft = SSFieldType.getFieldType(v);
    innerTypeGuid0 = ft!.innerTypeGuid0 ;
    innerTypeGuid1 = ft!.innerTypeGuid1 ;
  }

  FieldInfo clone() {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(this);
    JsonDecoder dec = JsonDecoder();
    FieldInfo data = FieldInfo.fromJson(dec.convert(json));
    data.rebuildGuid();
    return data;
  }

  @override
  String getTypeShowString(){

    if (SSDefines.lastEnumValue >=0 && !DartCommon.isEmpty(alias) && alias[0] == "#"){
      var regexp = RegExp(r'\s*(\d+)\s*:\s*([^,^:]+)');
      var ms = regexp.allMatches(alias);
      Map<String,String> map = Map<String,String>();
      for(var m in ms){
        map[m.group(1)!] = m.group(2)!;
        // print("group count : ${m.groupCount}");
        // for(var i = 0 ; i <=  m.groupCount ;++i){
        //   var g = m.group(i);
        //   print(g);
        // }
      }
      var res = map["${SSDefines.lastEnumValue}"];
      if (res != null) return res;
      else return "---";
    }
    if (alias != null && alias != "") return  alias;
    if (name != null && name != "") return name;

    return guid.substring(0,8);
  }

  String getFullGuidWithType() {
    var fi = SSFieldType.getFieldType(typeGuid);

    if (fi!.innerTypeCount == 0){
      return "${guid}";
    }
    if (fi!.innerTypeCount == 1){
      var fi2 = SSFieldType.getFieldType(innerTypeGuid0);
      return "${guid}_${fi2?.guid??innerTypeGuid0}";
    }
    if (fi!.innerTypeCount == 2){
      var fi2 = SSFieldType.getFieldType(innerTypeGuid0);
      var fi3 = SSFieldType.getFieldType(innerTypeGuid1);
      return "${guid}_${fi2?.guid??innerTypeGuid0}_${fi3?.guid??innerTypeGuid1}";
    }
    return "";
  }


}