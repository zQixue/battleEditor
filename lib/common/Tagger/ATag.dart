
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:uuid/uuid.dart';

part 'ATag.g.dart';
@JsonSerializable()
class ATag {
  static int tagCommonFlag = 1<<31;

  @JsonKey(defaultValue: "")
  String? guid;
  @JsonKey(defaultValue: "")
  String? name;
  @JsonKey(defaultValue: "")
  String? alias;
  @JsonKey(defaultValue: "")
  String commonNodePath = "";
  @JsonKey(defaultValue: "")
  String logicNodePath = "";

  @JsonKey(defaultValue: "")
  String commonGenPath = "";

  @JsonKey(defaultValue: "")
  String logicGenPath = "";

  @JsonKey(defaultValue: "")
  String viewNodePath = "";

  @JsonKey(defaultValue: "")
  String viewGenPath = "";


  //for lua
  @JsonKey(defaultValue: "")
  String commonNodePathLua = "";
  @JsonKey(defaultValue: "")
  String logicNodePathLua = "";

  @JsonKey(defaultValue: "")
  String commonGenPathLua = "";

  @JsonKey(defaultValue: "")
  String logicGenPathLua = "";

  @JsonKey(defaultValue: "")
  String viewNodePathLua = "";

  @JsonKey(defaultValue: "")
  String viewGenPathLua = "";

  @JsonKey(ignore: true)
  int? id;

  String? getTypeShowString(){
    if (!DartCommon.isEmpty(alias)) {
      return alias;
    }
    if (!DartCommon.isEmpty(name)) {
      return name;
    }
    return guid;
  }

  ATag(){
    guid = Uuid().v4();
  }

  //此处与类名一致，由指令自动生成代码
  factory ATag.fromJson(Map<String, dynamic> json) =>
      _$ATagFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ATagToJson(this);


}