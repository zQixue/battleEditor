import 'package:json_annotation/json_annotation.dart';



part 'FieldMapping.g.dart';

@JsonSerializable()
class FieldMapping {

  @JsonKey(defaultValue: "")
  String srcName ="";
  @JsonKey(defaultValue: "")
  String dstName ="";
  @JsonKey(defaultValue: "")
  String defaultValueTemplate ="";
  @JsonKey(defaultValue: "")
  String binaryReader ="";
  FieldMapping();
  //此处与类名一致，由指令自动生成代码
  factory FieldMapping.fromJson(Map<String, dynamic> json) =>
      _$FieldMappingFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FieldMappingToJson(this);
}