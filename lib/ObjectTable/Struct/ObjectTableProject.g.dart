// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ObjectTableProject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectTableProject _$ObjectTableProjectFromJson(Map<String, dynamic> json) =>
    ObjectTableProject()
      ..csExport = json['csExport'] as bool? ?? true
      ..luaExport = json['luaExport'] as bool? ?? false
      ..cppExport = json['cppExport'] as bool? ?? false
      ..csCodeExportPath = json['csCodeExportPath'] as String? ?? ''
      ..csTemplatePath = json['csTemplatePath'] as String? ?? ''
      ..cppCodeExportPath = json['cppCodeExportPath'] as String? ?? ''
      ..cppTemplatePath = json['cppTemplatePath'] as String? ?? ''
      ..luaCodeExportPath = json['luaCodeExportPath'] as String? ?? ''
      ..luaTemplatePath = json['luaTemplatePath'] as String? ?? ''
      ..byteExportPath = json['byteExportPath'] as String? ?? ''
      ..groupSave = json['groupSave'] as bool? ?? false
      ..useNewExportConfig = json['useNewExportConfig'] as bool? ?? false
      ..mainExportConfig =
          ObjectTableProject.parseMainConfig(json['mainExportConfig'])
      ..otExportConfigs = (json['otExportConfigs'] as List<dynamic>?)
              ?.map((e) => OTExportConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

Map<String, dynamic> _$ObjectTableProjectToJson(ObjectTableProject instance) {
  var res = Map<String, dynamic>();

  if (instance.csExport != true) res['csExport'] = instance.csExport;
  if (instance.luaExport != false) res['luaExport'] = instance.luaExport;
  if (instance.cppExport != false) res['cppExport'] = instance.cppExport;
  if (instance.csCodeExportPath != '')
    res['csCodeExportPath'] = instance.csCodeExportPath;
  if (instance.csTemplatePath != '')
    res['csTemplatePath'] = instance.csTemplatePath;
  if (instance.cppCodeExportPath != '')
    res['cppCodeExportPath'] = instance.cppCodeExportPath;
  if (instance.cppTemplatePath != '')
    res['cppTemplatePath'] = instance.cppTemplatePath;
  if (instance.luaCodeExportPath != '')
    res['luaCodeExportPath'] = instance.luaCodeExportPath;
  if (instance.luaTemplatePath != '')
    res['luaTemplatePath'] = instance.luaTemplatePath;
  if (instance.byteExportPath != '')
    res['byteExportPath'] = instance.byteExportPath;
  if (instance.groupSave != false) res['groupSave'] = instance.groupSave;
  if (instance.useNewExportConfig != false)
    res['useNewExportConfig'] = instance.useNewExportConfig;
  if (instance.mainExportConfig != null)
    res['mainExportConfig'] = instance.mainExportConfig;
  if (instance.otExportConfigs != [])
    res['otExportConfigs'] = instance.otExportConfigs;
  return res;
}
