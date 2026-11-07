import '../../common/Tagger/TagSet.dart';
import 'SSObjBase.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ScriptModule.g.dart';

@JsonSerializable()
class ScriptModule extends SSObjBase {
  @JsonKey(defaultValue: "")
  String savePath = "";

  @JsonKey(defaultValue: null)
  TagSet? tagSet; //= TagSet();

  @JsonKey(defaultValue: 0xFFFFFFFF)
  int color = 0xFFFFFFFF;

  @JsonKey(defaultValue: 0)
  int iconCode = 0;

  ScriptModule();

  //此处与类名一致，由指令自动生成代码
  factory ScriptModule.fromJson(Map<String, dynamic> json) =>
      _$ScriptModuleFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ScriptModuleToJson(this);
}