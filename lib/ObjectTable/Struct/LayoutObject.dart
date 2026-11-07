
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';

part 'LayoutObject.g.dart';

@JsonSerializable()
class LayoutObject {


  // double _test;
  // @JsonKey(defaultValue: 0)
  // double get test {return _test;}
  // @JsonKey(defaultValue: 0)
  // set test(double v) {_test = v;int  a = 1;}
  @JsonKey(defaultValue: "")
  String tag = "";

  @JsonKey(defaultValue: true)
  bool showTitle  = true;


  double _x = 0;
  @JsonKey(defaultValue: 0)
  double get x {return _x;}
  @JsonKey(defaultValue: 0)
  set x(double v) {_x = v;}

  double _y= 0;
  @JsonKey(defaultValue: 0)
  double get y {return _y;}
  @JsonKey(defaultValue: 0)
  set y(double v) {_y = v;}

  double _width= 0;
  @JsonKey(defaultValue: OTDefines.fieldViewWidth)
  double get width {
    if (_width>0) return _width;
    return OTDefines.fieldViewWidth;
  }
  @JsonKey(defaultValue: OTDefines.fieldViewWidth)
  set width(double v) {_width = v;}

  double _height= 0;
  @JsonKey(defaultValue: OTDefines.fieldViewWidth)
  double get height {
    if (_height>0) return _height;
    return OTDefines.fieldViewHeight;
  }
  @JsonKey(defaultValue: OTDefines.fieldViewHeight)
  set height(double v) {_height = v;}

  // // @override
  // double getWidth(){
  //   if (width>0) return width;
  //   return OTDefines.fieldViewWidth;
  // }
  // // @override
  // double getHeight(){
  //   if (height>0) return height;
  //   return OTDefines.fieldViewHeight;
  // }

  double getX(){
    return 0;
  }

  double getY(){
    return 0;
  }

  // double getWidth(){
  //   return OTDefines.fieldViewWidth;
  // }
  //
  // double getHeight(){
  //   return OTDefines.fieldViewHeight;
  // }

  @JsonKey(ignore: true)
  bool selected = false;

  @JsonKey(ignore: true)
  double? storeX;
  @JsonKey(ignore: true)
  double? storeY;

  @JsonKey(ignore: true)
  double? storeWidth;
  @JsonKey(ignore: true)
  double? storeHeight;

  LayoutObject();
  //此处与类名一致，由指令自动生成代码
  factory LayoutObject.fromJson(Map<String, dynamic> json) =>
      _$LayoutObjectFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$LayoutObjectToJson(this);

}