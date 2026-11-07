// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OTExportConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTExportConfig _$OTExportConfigFromJson(Map<String, dynamic> json) =>
    OTExportConfig()
      ..name = json['name'] as String? ?? ''
      ..active = json['active'] as bool? ?? false
      ..templatePath = json['templatePath'] as String? ?? ''
      ..codeExportPath = json['codeExportPath'] as String? ?? '';

Map<String, dynamic> _$OTExportConfigToJson(OTExportConfig instance) {
  var res = Map<String, dynamic>();

  if (instance.name != '') res['name'] = instance.name;
  if (instance.active != false) res['active'] = instance.active;
  if (instance.templatePath != '') res['templatePath'] = instance.templatePath;
  if (instance.codeExportPath != '')
    res['codeExportPath'] = instance.codeExportPath;
  return res;
}
