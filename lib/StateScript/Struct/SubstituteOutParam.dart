import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/common/EventCenter.dart';

part 'SubstituteOutParam.g.dart';

@JsonSerializable()
class SubstituteOutParam extends SSObjBase{

  @JsonKey(ignore: true)
  Offset downPointer = Offset.zero;
  @JsonKey(ignore: true)
  Offset downStorePos = Offset.zero;

  @JsonKey(defaultValue: "")
  String outNodeGuid = "";

  @JsonKey(defaultValue: "")
  String outParamGuid = "";

  @JsonKey(defaultValue: "")
  String desc = "";

  @JsonKey(ignore: true)
  bool _selected = false;
  @JsonKey(ignore: true)
  set selected(bool value) {

    if (_selected != value){
      // print("send param");
      EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = this);
    }
    _selected  = value;
  }
  @JsonKey(ignore: true)
  bool get selected {
    return _selected??false;
  }

  double x = 0.0;
  double y = 0.0;

  @JsonKey(ignore: true)
  double oriX = 0.0;
  @JsonKey(ignore: true)
  double oriY = 0.0;

  @JsonKey(ignore: true)
  double width = 0;

  SubstituteOutParam();
  //此处与类名一致，由指令自动生成代码
  factory SubstituteOutParam.fromJson(Map<String, dynamic> json) =>
      _$SubstituteOutParamFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SubstituteOutParamToJson(this);

}