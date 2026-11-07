import 'package:json_annotation/json_annotation.dart';
part 'OTExportConfig.g.dart';
@JsonSerializable()
class OTExportConfig{
  @JsonKey(defaultValue: "")
  String name = "";

  @JsonKey(defaultValue: false)
  bool active = false;

  @JsonKey(defaultValue: "")
  String templatePath = "";

  @JsonKey(defaultValue: "")
  String codeExportPath = "";

  OTExportConfig();
  //此处与类名一致，由指令自动生成代码
  factory OTExportConfig.fromJson(Map<String, dynamic> json) =>
      _$OTExportConfigFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$OTExportConfigToJson(this);
}