// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SSMainSetting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SSMainSetting _$SSMainSettingFromJson(Map<String, dynamic> json) =>
    SSMainSetting()
      ..workingPath = json['workingPath'] as String?
      ..canvasColor = json['canvasColor'] as int? ?? 4278190080;

Map<String, dynamic> _$SSMainSettingToJson(SSMainSetting instance) {
  var res = Map<String, dynamic>();

  if (instance.workingPath != null) res['workingPath'] = instance.workingPath;
  if (instance.canvasColor != 4278190080)
    res['canvasColor'] = instance.canvasColor;
  return res;
}
