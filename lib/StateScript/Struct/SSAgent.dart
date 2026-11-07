

import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';


part 'SSAgent.g.dart';

@JsonSerializable()
class SSAgent extends SSObjBase implements CodeExporter{

  @JsonKey(defaultValue: <String>[])
  List<String> componentIds = <String>[] ;
  @JsonKey(defaultValue: "")
  String group = "";

  SSAgent();
  //此处与类名一致，由指令自动生成代码
  factory SSAgent.fromJson(Map<String, dynamic> json) =>
      _$SSAgentFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSAgentToJson(this);

  @override
  exportInfo() {

    var comps = [];

    for(var compId in componentIds){
      var comp = StateScriptProject.instance!.getComponent(compId);
      if (comp != null){
        comps.add(comp.exportInfo());
      }
    }
    comps.sort((a,b)=>a["name"].compareTo(b["name"]));

    return {
      'id' : exportId,
      'name': name,
      'alias': alias,
      'guid': guid,
      'hash':guid.hashCode,
      'upperName': name.toUpperCase(),
      'components' : comps,
    };
  }
}