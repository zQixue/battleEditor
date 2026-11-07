


import 'package:json_annotation/json_annotation.dart';


part 'BreakPointList.g.dart';

@JsonSerializable()
class BreakPointList{

  @JsonKey(defaultValue: <String>[])
  List<String> bps = <String>[];

  @JsonKey(defaultValue: false)
  bool isBreakPointActive = false;

  @JsonKey(defaultValue: false)
  bool isFocusFrameMode = false;

  BreakPointList();
  //此处与类名一致，由指令自动生成代码
  factory BreakPointList.fromJson(Map<String, dynamic> json) =>
      _$BreakPointListFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BreakPointListToJson(this);
}