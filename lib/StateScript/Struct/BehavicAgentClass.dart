
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentMethod.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';



part 'BehavicAgentClass.g.dart';

@JsonSerializable()
class BehavicAgentClass extends SSFieldType{
  BehavicAgentClass();

  @JsonKey(defaultValue: <String,FieldInfo>{})
  Map<String , FieldInfo> fields = Map<String , FieldInfo>();

  @JsonKey(defaultValue: <String,BehavicAgentMethod>{})
  Map<String , BehavicAgentMethod> methods = Map<String , BehavicAgentMethod>();

  @JsonKey(defaultValue: "")
  String group = "";

  @JsonKey(defaultValue: "")
  String baseAgentGuid = "";

  @JsonKey(defaultValue: false)
  bool? isStruct;

  // @JsonKey(defaultValue: true)
  // bool exportCode = true  ;

  @JsonKey(defaultValue: "")
  String desc = "";

  @JsonKey(defaultValue: "")
  String exportPath = "";

  @JsonKey(defaultValue: "")
  String namespace = "";

  @JsonKey(defaultValue: true)
  bool needExportCode = true;

  //此处与类名一致，由指令自动生成代码
  factory BehavicAgentClass.fromJson(Map<String, dynamic> json) =>
      _$BehavicAgentClassFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BehavicAgentClassToJson(this);

  bool isParentOf(BehavicAgentClass? clz) {
    var crt = clz;
    if (crt == null) return false;
    do{
      if (crt!.baseAgentGuid == guid){
        return true;
      }
      crt = StateScriptProject.instance!.behavicAgentProject!.classes[crt.baseAgentGuid??""];
    }
    while(crt != null);
    return false;
  }

  BehavicAgentClass? getBaseAgent(){
    return StateScriptProject.instance!.behavicAgentProject!.classes[baseAgentGuid];
  }
  void _getAllFields(Map<String , FieldInfo> res){
    var baseAgent = getBaseAgent();
    if (baseAgent != null){
      baseAgent._getAllFields(res);
    }
    res.addAll(fields);
  }
  Map<String , FieldInfo> getAllFields(){
    Map<String , FieldInfo> res = Map<String , FieldInfo>();
    _getAllFields(res);
    return res;
  }

  void _getAllMethods(Map<String , BehavicAgentMethod> res){
    var baseAgent = getBaseAgent();
    if (baseAgent != null){
      baseAgent._getAllMethods(res);
    }
    res.addAll(methods);
  }

  Map<String , BehavicAgentMethod> getAllMethods(){
    Map<String , BehavicAgentMethod> res = Map<String , BehavicAgentMethod>();
    _getAllMethods(res);
    return res;
  }

  FieldInfo? getFieldByGuid(String guid){
    var baseAgent = getBaseAgent();
    if (baseAgent != null){
      var f = baseAgent.getFieldByGuid(guid);
      if (f != null) return f;
    }
    return fields[guid];
  }

  @override
  Widget getTypeShowWidget({SSFieldType? fieldType , FunctionStringCallback? onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.face_agent , color: Colors.greenAccent,),
        SizedBox(width: 4,),
//        Text(getTypeShowString()),
        Expanded(child:Text(getShowStringAndName() , style : ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  @override
  getExportInfo({Map<String,dynamic>? extra = null}){
    var res = super.getExportInfo(extra: extra);
    res["namespace"] = namespace;
    res["fullName"] = DartCommon.isEmpty(namespace)?name:"$namespace.$name";
    res["isStruct"] = isStruct??false;

    return res;
  }
  @override
  dynamic exportInfo() {
    var base = StateScriptProject.instance!.behavicAgentProject!.classes[baseAgentGuid];
    // var baseName = base==null?"":base.name;

    /// 静态字段
    var fieldInfos = [];
    var fs = fields.values.toList();
    fs.sort((a,b)=>a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    for(var f in fs){
      var fo = f.exportInfo();
      fieldInfos.add(fo);
    }
    // print("class : $name");
    /// 函数
    var methodInfos = [];
    var ms = methods.values.toList();
    ms.sort((a,b)=>a.index-b.index);
    for(var f in ms){
      var fo = f.exportInfo();
      methodInfos.add(fo);
    }


    return {
      'name': name,
      'alias': alias,
      'guid': guid,
      'exportId':exportId??-1,
      'base': base?.exportInfo(),
      'fields' : fieldInfos,
      'methods' : methodInfos,
      'namespace' : namespace,
      "fullName" : DartCommon.isEmpty(namespace)?name:"$namespace.$name",
      "isStruct" : isStruct??false,
    };

  }
}