

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
part 'NodeInterface.g.dart';

@JsonSerializable()
class NodeInterface extends SSObjBase{

  // @JsonKey(defaultValue: "")
  // String linkInterfaceGuid = false;
  //
  // @JsonKey(defaultValue: 1024)
  // int interfacePrio = 1024;
  @JsonKey(ignore : true)
  dynamic target;



  NodeInterface();
  //此处与类名一致，由指令自动生成代码
  factory NodeInterface.fromJson(Map<String, dynamic> json) =>
      _$NodeInterfaceFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$NodeInterfaceToJson(this);

}