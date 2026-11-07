
import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/LayoutObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:uuid/uuid.dart';


part 'FieldGroup.g.dart';

@JsonSerializable()
class FieldGroup extends LayoutObject {

  String? guid;
  @JsonKey(defaultValue: "")
  String name = "";
  @JsonKey(defaultValue: "")
  String alias = "";
  @JsonKey(defaultValue: "")
  String desc= "";

  @JsonKey(defaultValue: true)
  bool showTitle = true;

  @JsonKey(defaultValue: null)
  int? bgColor;

  @JsonKey(defaultValue: true)
  bool defaultVisible = true;

  @JsonKey(ignore: true)
  bool? visible;


  @JsonKey(defaultValue: <String>[])
  List<String> fieldGuids = <String>[];

  FieldGroup(){
    guid = Uuid().v4();
  }
  //此处与类名一致，由指令自动生成代码
  factory FieldGroup.fromJson(Map<String, dynamic> json) =>
      _$FieldGroupFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FieldGroupToJson(this);

  bool getGroupValid(ObjectClazz clz){
    bool bValid = false;
    for (int  i = 0 ; i <fieldGuids.length ;++i){
      var element = fieldGuids[i];
      var fi = clz.getFieldMap()![element];
      if (fi != null) {
        bValid = true;
        break;
      }
    }
    return bValid;
  }

  void clean(ObjectClazz clz){
    for (int  i = fieldGuids.length -1 ; i>=0;--i){
      var element = fieldGuids[i];
      var fi = clz.getFieldMap()![element];
      if (fi == null) {
        fieldGuids.removeAt(i);
      }
    }
  }

  Rect getGroupRect(ObjectClazz clz , {bool bEditMode = false}){
    // Rect res = Rect.fromLTRB(double.maxFinite, double.maxFinite, double.minPositive, double.minPositive);
    var left = double.maxFinite;
    var top = double.maxFinite;
    var right = double.minPositive;
    var bottom = double.minPositive;
    // var clz = widget.object.getClazz();
    int iCount = 0;

    var currentVisible = (visible??defaultVisible) || bEditMode;

    fieldGuids.forEach((element) {
      double x = 0;
      double y = iCount * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);
      double width = OTDefines.fieldViewWidth;
      double height = OTDefines.fieldViewHeight;
      var fi = clz.getFieldMap()![element];
      if (fi == null) return ;
      var fl = clz.getFieldLayoutById(element);
      if (fl != null){
        x = fl.x;
        y = fl.y;
        if (fl.width>0) width = fl.width;
        if (fl.height>0) height = fl.height;
      }
      // print("compute min x : $x ${element}");
      left = min(left , x);
      top = min(top , y);
      right = max(right , x + width);
      bottom = max(bottom , y + height);
      ++iCount;
    });
    var headerHeight = OTDefines.groupHeaderHeight;////showTitle?OTDefines.groupHeaderHeight:0;

    if (!currentVisible){
      var l = left - OTDefines.frameBorderSize;
      var t = top - OTDefines.frameBorderSize - headerHeight ;
      var r = right+OTDefines.frameBorderSize;
      var b = t + headerHeight + OTDefines.frameBorderSize;
      return Rect.fromLTRB(l,t,r,b);
    }


    return Rect.fromLTRB(left - OTDefines.frameBorderSize, top - OTDefines.frameBorderSize - headerHeight, right+OTDefines.frameBorderSize, bottom+OTDefines.frameBorderSize);
  }
  // @override
  FieldGroup clone() {
    FieldGroup res = FieldGroup();
    res.fieldGuids = <String>[];
    fieldGuids.forEach((element) {
      res.fieldGuids.add(element);
    });

    res.name = name;
    res.alias = alias;
    res.desc= desc;
    res.showTitle = showTitle;
    res.bgColor = bgColor;
    return res;
  }

}