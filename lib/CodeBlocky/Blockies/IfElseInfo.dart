
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
part 'IfElseInfo.g.dart';

@JsonSerializable()
class IfElseInfo extends SSObjBase{
  // @JsonKey(defaultValue: false)
//  bool withIf = false;
  @JsonKey(defaultValue: "")
  String blockListGuid = "";
  IfElseInfo();
  //此处与类名一致，由指令自动生成代码
  factory IfElseInfo.fromJson(Map<String, dynamic> json) =>
      _$IfElseInfoFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$IfElseInfoToJson(this);
}