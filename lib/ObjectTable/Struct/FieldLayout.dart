
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/LayoutObject.dart';


part 'FieldLayout.g.dart';

@JsonSerializable()
class FieldLayout extends LayoutObject {




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

  FieldLayout(){
    width = OTDefines.fieldViewWidth;
    height = OTDefines.fieldViewHeight;
  }
  //此处与类名一致，由指令自动生成代码
  factory FieldLayout.fromJson(Map<String, dynamic> json) =>
      _$FieldLayoutFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FieldLayoutToJson(this);

  FieldLayout clone() {
    var res = FieldLayout();
    res.x = this.x;
    res.y = this.y;
    res.width = this.width;
    res.height = this.height;
    res.selected = selected;
    return res;
  }

}