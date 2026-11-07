import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ClassDecoration.g.dart';

@JsonSerializable()
class ClassDecoration extends FieldInfo {

  @JsonKey(defaultValue: DecorationType.label)
  DecorationType type = DecorationType.label;
  dynamic value;

  //
  // double _x = 0;
  // @JsonKey(defaultValue: 0)
  // double get x {return _x;}
  // @JsonKey(defaultValue: 0)
  // set x(double v) {_x = v;}
  //
  // double _y= 0;
  // @JsonKey(defaultValue: 0)
  // double get y {return _y;}
  // @JsonKey(defaultValue: 0)
  // set y(double v) {_y = v;}
  //
  // double _width= 0;
  // @JsonKey(defaultValue: OTDefines.fieldViewWidth)
  // double get width {
  //   if (_width>0) return _width;
  //   return OTDefines.fieldViewWidth;
  // }
  // @JsonKey(defaultValue: OTDefines.fieldViewWidth)
  // set width(double v) {_width = v;}
  //
  // double _height= 0;
  // @JsonKey(defaultValue: OTDefines.fieldViewWidth)
  // double get height {
  //   if (_height>0) return _height;
  //   return OTDefines.fieldViewHeight;
  // }
  //
  // @JsonKey(ignore: true)
  // bool selected = false;
  //
  // @JsonKey(ignore: true)
  // double storeX;
  // @JsonKey(ignore: true)
  // double storeY;
  //
  // @JsonKey(ignore: true)
  // double storeWidth;
  // @JsonKey(ignore: true)
  // double storeHeight;

  ClassDecoration();
  //此处与类名一致，由指令自动生成代码
  factory ClassDecoration.fromJson(Map<String, dynamic> json) =>
      _$ClassDecorationFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ClassDecorationToJson(this);
}