
import 'dart:convert';

import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/DartCommon.dart';



part 'BehavicAgentProject.g.dart';

@JsonSerializable()
class BehavicAgentProject extends SSObjBase{
  BehavicAgentProject();

  //类型
  // @JsonKey(defaultValue : <String , BehavicAgentClass>{})
  @JsonKey(ignore:true)
  Map<String , BehavicAgentClass> classes = Map<String , BehavicAgentClass>();

  //枚举
  @JsonKey(defaultValue : <String , SSEnumType>{})
  Map<String , SSEnumType> enums = Map<String , SSEnumType>();

  // @JsonKey(ignore: true)
  // Map<String , SSFieldType> registeredFieldTypes = Map<String , SSFieldType>();
  //
  // //初始化类型
  // void initFieldTypes(){
  //
  // }

  //此处与类名一致，由指令自动生成代码
  factory BehavicAgentProject.fromJson(Map<String, dynamic> json) =>
      _$BehavicAgentProjectFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BehavicAgentProjectToJson(this);


  BehavicAgentClass cloneNodeStruct(BehavicAgentClass struct) {
    JsonEncoder ec = JsonEncoder();
    var json = ec.convert(struct);
    JsonDecoder dec = JsonDecoder();
    BehavicAgentClass data = BehavicAgentClass.fromJson(dec.convert(json));
    data.rebuildGuid();
    var fields = data.fields.values.toList();
    data.fields.clear();
    for(var f in fields){
      f.rebuildGuid();
      data.fields[f.guid] = f;
    }

    var methods = data.methods.values.toList();
    data.methods.clear();
    for(var f in methods){
      f.rebuildGuid();
      data.methods[f.guid] = f;
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

    classes[data.guid] = data;


    return data;
  }

  BehavicAgentClass addNewType() {
    var data = BehavicAgentClass();
    classes[data.guid] = data;
    return data;
  }
}