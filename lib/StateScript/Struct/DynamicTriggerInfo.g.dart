// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DynamicTriggerInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DynamicTriggerInfo _$DynamicTriggerInfoFromJson(Map<String, dynamic> json) =>
    DynamicTriggerInfo()
      ..id = json['id'] as String
      ..name = json['name'] as String;

Map<String, dynamic> _$DynamicTriggerInfoToJson(DynamicTriggerInfo instance) {
  var res = Map<String, dynamic>();

  if (instance.id != null) res['id'] = instance.id;
  if (instance.name != null) res['name'] = instance.name;
  return res;
}
