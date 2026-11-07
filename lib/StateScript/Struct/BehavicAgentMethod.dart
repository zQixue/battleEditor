
import 'dart:convert';

import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';

import 'SSFieldType.dart';



part 'BehavicAgentMethod.g.dart';

@JsonSerializable()
class BehavicAgentMethod extends SSObjBase{

  @JsonKey(defaultValue: false)
  bool isStatic = false ;

  @JsonKey(defaultValue: true)
  bool isPublic = true ;

  @JsonKey(defaultValue: null)
  FieldInfo? returnType  ;

  @JsonKey(defaultValue: false)
  bool withReturn = false  ;

  @JsonKey(defaultValue: false)
  bool hide = false  ;

  @JsonKey(defaultValue: <String , FieldInfo>{})
  Map<String , FieldInfo> params =  Map<String , FieldInfo>();

  @JsonKey(ignore: true)
  String group = "" ;

  @JsonKey(defaultValue: "")
  String desc = "" ;

  BehavicAgentMethod();


  String getFullType(){
    return returnType!.getFullType();
  }

  String getFullTypeWithExtra(){
    return withReturn? returnType!.getFullTypeWithExtra():"void";
  }

  bool isReturnObject(){
    if (!withReturn) return false;
    var fi = SSFieldType.getFieldType(returnType!.typeGuid);
    return fi is BehavicAgentClass;
  }

  //此处与类名一致，由指令自动生成代码
  factory BehavicAgentMethod.fromJson(Map<String, dynamic> json) =>
      _$BehavicAgentMethodFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BehavicAgentMethodToJson(this);

  BehavicAgentMethod clone() {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(this);
    JsonDecoder dec = JsonDecoder();
    BehavicAgentMethod data = BehavicAgentMethod.fromJson(dec.convert(json));
    data.rebuildGuid();
    data.name = "${data.name}_clone_";
    var prms = data.params.values.toList();
    prms.forEach((element) {element.rebuildGuid();});
    data.params.clear();
    prms.forEach((element) {data.params[element.guid] = element;});
    return data;
  }


  @override
  dynamic exportInfo() {
    List prms = [];
    var pvals = params.values.toList();
    pvals.sort((a,b)=>a.index-b.index);
    pvals.forEach((ele) {
      var ei = ele.exportInfo();
      ei['isLast'] = false;
      prms.add(ei);
    });
    if (prms.length>0) {
      prms[prms.length - 1]['isLast'] = true;
    }
    // print("method : $name");
    return {
      'name': name,
      'alias': alias,
      'guid': guid,
      'exportId':exportId??-1,
      'id':exportId??-1,
      'isPublic': isPublic??false,
      'isStatic' : isStatic??false,
      'withReturn' : withReturn??false,
      'returnType' : returnType?.exportInfo(),
      'desc' : desc,
      'hide':hide??false,
      'params':prms,
      'reverseParams':prms.reversed.toList(),
    };
  }
}