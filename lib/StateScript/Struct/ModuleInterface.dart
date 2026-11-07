

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
part 'ModuleInterface.g.dart';

@JsonSerializable()
class ModuleInterface extends SSObjBase{

  //结点 guid
  @JsonKey(defaultValue: "")
  String nodeGuid = "";

  //port 或 param guid
  @JsonKey(defaultValue: "")
  String interfaceGuid = "";
  @JsonKey(ignore: true)
  bool isOpen = false;

  @JsonKey(ignore: true)
  StateScriptNode? ownerNode ;

  @JsonKey(defaultValue: 512)
  int prio = 512;

  @JsonKey(defaultValue: InterfaceType.InPort)
  InterfaceType? type;


  @JsonKey(defaultValue: null)
  double? x;

  @JsonKey(defaultValue: null)
  double? y;

  ModuleInterface();
  //此处与类名一致，由指令自动生成代码
  factory ModuleInterface.fromJson(Map<String, dynamic> json) =>
      _$ModuleInterfaceFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ModuleInterfaceToJson(this);

}