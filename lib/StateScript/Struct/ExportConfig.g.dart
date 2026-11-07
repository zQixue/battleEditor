// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ExportConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportConfig _$ExportConfigFromJson(Map<String, dynamic> json) => ExportConfig()
  ..name = json['name'] as String? ?? ''
  ..active = json['active'] as bool? ?? true
  ..defaultNodeExportPath = json['defaultNodeExportPath'] as String? ?? ''
  ..defaultGenExportPath = json['defaultGenExportPath'] as String? ?? ''
  ..logicGenExportPath = json['logicGenExportPath'] as String? ?? ''
  ..logicNodeExportPath = json['logicNodeExportPath'] as String? ?? ''
  ..nodeCodeExportPath = json['nodeCodeExportPath'] as String? ?? ''
  ..logicNodeCodeExportPath = json['logicNodeCodeExportPath'] as String? ?? ''
  ..viewNodeCodeExportPath = json['viewNodeCodeExportPath'] as String? ?? ''
  ..codeExportPath = json['codeExportPath'] as String? ?? ''
  ..logicCodeExportPath = json['logicCodeExportPath'] as String? ?? ''
  ..viewCodeExportPath = json['viewCodeExportPath'] as String? ?? ''
  ..runtimeCodePath = json['runtimeCodePath'] as String? ?? ''
  ..templatePath = json['templatePath'] as String? ?? ''
  ..baseCodeExportPath = json['baseCodeExportPath'] as String? ?? ''
  ..expandExport = json['expandExport'] as bool? ?? false;

Map<String, dynamic> _$ExportConfigToJson(ExportConfig instance) {
  var res = Map<String, dynamic>();

  if (instance.name != '') res['name'] = instance.name;
  if (instance.active != true) res['active'] = instance.active;
  if (instance.defaultNodeExportPath != '')
    res['defaultNodeExportPath'] = instance.defaultNodeExportPath;
  if (instance.defaultGenExportPath != '')
    res['defaultGenExportPath'] = instance.defaultGenExportPath;
  if (instance.logicGenExportPath != '')
    res['logicGenExportPath'] = instance.logicGenExportPath;
  if (instance.logicNodeExportPath != '')
    res['logicNodeExportPath'] = instance.logicNodeExportPath;
  if (instance.nodeCodeExportPath != '')
    res['nodeCodeExportPath'] = instance.nodeCodeExportPath;
  if (instance.logicNodeCodeExportPath != '')
    res['logicNodeCodeExportPath'] = instance.logicNodeCodeExportPath;
  if (instance.viewNodeCodeExportPath != '')
    res['viewNodeCodeExportPath'] = instance.viewNodeCodeExportPath;
  if (instance.codeExportPath != '')
    res['codeExportPath'] = instance.codeExportPath;
  if (instance.logicCodeExportPath != '')
    res['logicCodeExportPath'] = instance.logicCodeExportPath;
  if (instance.viewCodeExportPath != '')
    res['viewCodeExportPath'] = instance.viewCodeExportPath;
  if (instance.runtimeCodePath != '')
    res['runtimeCodePath'] = instance.runtimeCodePath;
  if (instance.templatePath != '') res['templatePath'] = instance.templatePath;
  if (instance.baseCodeExportPath != '')
    res['baseCodeExportPath'] = instance.baseCodeExportPath;
  if (instance.expandExport != false)
    res['expandExport'] = instance.expandExport;
  return res;
}
