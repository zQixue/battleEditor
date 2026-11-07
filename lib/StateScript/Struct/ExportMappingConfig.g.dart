// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExportMappingConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportMappingConfig _$ExportMappingConfigFromJson(Map<String, dynamic> json) =>
    ExportMappingConfig()
      ..extension = json['extension'] as String? ?? 'cs'
      ..namespace = json['namespace'] as String? ?? 'buf.battlescriptx'
      ..otnamespace = json['otnamespace'] as String? ?? 'buf.battlescriptx'
      ..enumnamespace = json['enumnamespace'] as String? ?? 'buf.enum'
      ..fieldMaps = (json['fieldMaps'] as List<dynamic>?)
              ?.map((e) => FieldMapping.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..operates = (json['operates'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          {};

Map<String, dynamic> _$ExportMappingConfigToJson(ExportMappingConfig instance) {
  var res = Map<String, dynamic>();

  if (instance.extension != 'cs') res['extension'] = instance.extension;
  if (instance.namespace != 'buf.battlescriptx')
    res['namespace'] = instance.namespace;
  if (instance.otnamespace != 'buf.battlescriptx')
    res['otnamespace'] = instance.otnamespace;
  if (instance.enumnamespace != 'buf.enum')
    res['enumnamespace'] = instance.enumnamespace;
  if (instance.fieldMaps != []) res['fieldMaps'] = instance.fieldMaps;
  if (instance.operates != {}) res['operates'] = instance.operates;
  return res;
}
