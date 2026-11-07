
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';

import 'package:json_annotation/json_annotation.dart';

part 'SSEnumItem.g.dart';

@JsonSerializable()
class SSEnumItem extends SSObjBase{

  @JsonKey(defaultValue: null)
  int? enumValue;
  @JsonKey(ignore: true)
  String enumId = "";

  @JsonKey(ignore: true)
  String group = "";

  @JsonKey(ignore: true)
  String codeName = "";

  @JsonKey(defaultValue: "")
  String hint = "";

  SSEnumItem();
  //此处与类名一致，由指令自动生成代码
  factory SSEnumItem.fromJson(Map<String, dynamic> json) =>
      _$SSEnumItemFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSEnumItemToJson(this);
}