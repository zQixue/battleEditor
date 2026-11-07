
import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/Struct/SyncFieldInfo.dart';


part 'SSComponent.g.dart';

@JsonSerializable()
class SSComponent extends SSObjBase implements CodeExporter{

  @JsonKey(defaultValue: <SyncFieldInfo>[])
  List<SyncFieldInfo> fields = <SyncFieldInfo>[];

  @JsonKey(defaultValue: "")
  String group = "";

  SyncFieldInfo addField(){
    SyncFieldInfo f = new SyncFieldInfo();
    fields.add(f);
    StateScriptProject.instance!.buildFieldInfos();
    return f;
  }

  void removeField(SyncFieldInfo f){
    if (fields.contains(f)){
      fields.remove(f);
      StateScriptProject.instance!.buildFieldInfos();
    }
  }

  SSComponent();
  //此处与类名一致，由指令自动生成代码
  factory SSComponent.fromJson(Map<String, dynamic> json) =>
      _$SSComponentFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSComponentToJson(this);

  @override
  exportInfo() {

    var fieldInfos = [];
    for(var f in fields){
      var fo = f.exportInfo();
      fieldInfos.add(fo);
    }

    return {
      'name': name,
      'alias': alias,
      "id":exportId,
      'guid': guid,
      'fields' : fieldInfos,

    };
  }
}