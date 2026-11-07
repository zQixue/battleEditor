

import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/DynamicTriggerInfo.dart';
import 'package:uuid/uuid.dart';

part 'FieldValueHolder.g.dart';

@JsonSerializable()
class FieldValueHolder{
  String? name;
  dynamic value;
  String? fieldType;
  @JsonKey(defaultValue: false)
  bool highlightEdit = false;

  @JsonKey(defaultValue: null)
  List<DynamicTriggerInfo>? dtis ;

  FieldValueHolder();
  //此处与类名一致，由指令自动生成代码
  factory FieldValueHolder.fromJson(Map<String, dynamic> json) =>
      _$FieldValueHolderFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$FieldValueHolderToJson(this);


  DynamicTriggerInfo getOrCreateDynamicTriggerInfo(int iIndex){
    if (dtis == null) dtis = <DynamicTriggerInfo>[];
    if (iIndex >= dtis!.length){
      for(int i = dtis!.length ; i <= iIndex ;++i){
        var ni = DynamicTriggerInfo()..id = Uuid().v4();
        dtis!.add(ni);
      }
    }
    return dtis![iIndex];
  }

  void removeDynamicTriggerInfo(int iIndex) {
    if (dtis == null) return;
    if (iIndex < 0 || iIndex>=dtis!.length) return ;
    dtis!.removeAt(iIndex);
  }

  void reorderDynamicTriggerInfo(int oldI, int newI) {
    var info = dtis!.removeAt(oldI);
    dtis!.insert(newI, info);
  }

  void addDynamicTriggerInfo(String? id , String name) {
    if (dtis == null) dtis = <DynamicTriggerInfo>[];
    dtis!.add(DynamicTriggerInfo()..id = id??(Uuid().v4()) ..name = name??"");
  }

  void clearDynamicTriggerInfo() {
    if (dtis != null) dtis?.clear();
  }

  HashSet<String> getValidDynamicTriggers() {
    HashSet<String> res = HashSet<String>();
    dtis?.forEach((element) {
      res.add(element.id);
    });
    return res;
  }

  static FieldValueHolder clone(FieldValueHolder from) {
    if (from == null) return FieldValueHolder();
    var m = from.toJson();
    var obj = FieldValueHolder.fromJson(m);
    return obj;
  }
}