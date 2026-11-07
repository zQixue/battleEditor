// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BreakPointList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreakPointList _$BreakPointListFromJson(Map<String, dynamic> json) =>
    BreakPointList()
      ..bps =
          (json['bps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              []
      ..isBreakPointActive = json['isBreakPointActive'] as bool? ?? false
      ..isFocusFrameMode = json['isFocusFrameMode'] as bool? ?? false;

Map<String, dynamic> _$BreakPointListToJson(BreakPointList instance) {
  var res = Map<String, dynamic>();

  if (instance.bps != []) res['bps'] = instance.bps;
  if (instance.isBreakPointActive != false)
    res['isBreakPointActive'] = instance.isBreakPointActive;
  if (instance.isFocusFrameMode != false)
    res['isFocusFrameMode'] = instance.isFocusFrameMode;
  return res;
}
