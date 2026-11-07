import 'package:json_annotation/json_annotation.dart';
part 'DynamicTriggerInfo.g.dart';
@JsonSerializable()
class DynamicTriggerInfo{
  String id = "";
  String name = "";

  DynamicTriggerInfo();

  //此处与类名一致，由指令自动生成代码
  factory DynamicTriggerInfo.fromJson(Map<String, dynamic> json) =>
      _$DynamicTriggerInfoFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$DynamicTriggerInfoToJson(this);
}