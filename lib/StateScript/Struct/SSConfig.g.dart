// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SSConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SSConfig _$SSConfigFromJson(Map<String, dynamic> json) =>
    SSConfig()..portGroup = json['portGroup'] as int? ?? 0;

Map<String, dynamic> _$SSConfigToJson(SSConfig instance) {
  var res = Map<String, dynamic>();

  if (instance.portGroup != 0) res['portGroup'] = instance.portGroup;
  return res;
}
