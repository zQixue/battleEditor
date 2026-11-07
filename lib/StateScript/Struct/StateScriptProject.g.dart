// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StateScriptProject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateScriptProject _$StateScriptProjectFromJson(Map<String, dynamic> json) =>
    StateScriptProject()
      ..scripts = (json['scripts'] as List<dynamic>?)
              ?.map((e) => ScriptInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..scriptTemplates = (json['scriptTemplates'] as List<dynamic>?)
              ?.map((e) => ScriptInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..hidePort = json['hidePort'] as bool? ?? false
      ..groupSave = json['groupSave'] as bool? ?? false
      ..showScriptId = json['showScriptId'] as bool? ?? false
      ..showScriptNameAtLast = json['showScriptNameAtLast'] as bool? ?? true
      ..showAllFields = json['showAllFields'] as bool? ?? false
      ..exportTxtInfo = json['exportTxtInfo'] as bool? ?? false
      ..useDataCompatible = json['useDataCompatible'] as bool? ?? false
      ..exportAgentFunctionLength =
          json['exportAgentFunctionLength'] as bool? ?? false
      ..exportLuaDataCode = json['exportLuaDataCode'] as bool? ?? false
      ..useObjectTable = json['useObjectTable'] as bool? ?? false
      ..addNameToFilePath = json['addNameToFilePath'] as bool? ?? false
      ..useNewExportPathRule = json['useNewExportPathRule'] as bool? ?? false
      ..forceSaveNodePosition = json['forceSaveNodePosition'] as bool? ?? false
      ..cubicLine = json['cubicLine'] as bool? ?? false
      ..storeFunctionInScript = json['storeFunctionInScript'] as bool? ?? false
      ..exportFixedPoint = json['exportFixedPoint'] as bool? ?? false
      ..useLuaForFieldVisible = json['useLuaForFieldVisible'] as bool? ?? false
      ..scriptModules = (json['scriptModules'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ScriptModule.fromJson(e as Map<String, dynamic>)),
      )
      ..behavicAgentProject = json['behavicAgentProject'] == null
          ? null
          : BehavicAgentProject.fromJson(
              json['behavicAgentProject'] as Map<String, dynamic>)
      ..globalScriptVars =
          (json['globalScriptVars'] as Map<String, dynamic>?)?.map(
                (k, e) =>
                    MapEntry(k, FieldInfo.fromJson(e as Map<String, dynamic>)),
              ) ??
              {}
      ..resourceLists = (json['resourceLists'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, ResourceList.fromJson(e as Map<String, dynamic>)),
          ) ??
          {}
      ..tagCamp = TagCamp.fromJson(json['tagCamp'] as Map<String, dynamic>)
      ..csharpConfig =
          ExportConfig.fromJson(json['csharpConfig'] as Map<String, dynamic>)
      ..luaConfig =
          ExportConfig.fromJson(json['luaConfig'] as Map<String, dynamic>)
      ..exportExtraConfigs = (json['exportExtraConfigs'] as List<dynamic>?)
              ?.map((e) => ExportConfig.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..byteExportPath = json['byteExportPath'] as String? ?? ''
      ..ignoreTypes = Map<String, bool>.from(json['ignoreTypes'] as Map)
      ..binaryVersionCode = json['binaryVersionCode'] as int?;

Map<String, dynamic> _$StateScriptProjectToJson(StateScriptProject instance) {
  var res = Map<String, dynamic>();

  if (instance.scripts != []) res['scripts'] = instance.scripts;
  if (instance.scriptTemplates != [])
    res['scriptTemplates'] = instance.scriptTemplates;
  if (instance.hidePort != false) res['hidePort'] = instance.hidePort;
  if (instance.groupSave != false) res['groupSave'] = instance.groupSave;
  if (instance.showScriptId != false)
    res['showScriptId'] = instance.showScriptId;
  if (instance.showScriptNameAtLast != true)
    res['showScriptNameAtLast'] = instance.showScriptNameAtLast;
  if (instance.showAllFields != false)
    res['showAllFields'] = instance.showAllFields;
  if (instance.exportTxtInfo != false)
    res['exportTxtInfo'] = instance.exportTxtInfo;
  if (instance.useDataCompatible != false)
    res['useDataCompatible'] = instance.useDataCompatible;
  if (instance.exportAgentFunctionLength != false)
    res['exportAgentFunctionLength'] = instance.exportAgentFunctionLength;
  if (instance.exportLuaDataCode != false)
    res['exportLuaDataCode'] = instance.exportLuaDataCode;
  if (instance.useObjectTable != false)
    res['useObjectTable'] = instance.useObjectTable;
  if (instance.addNameToFilePath != false)
    res['addNameToFilePath'] = instance.addNameToFilePath;
  if (instance.useNewExportPathRule != false)
    res['useNewExportPathRule'] = instance.useNewExportPathRule;
  if (instance.forceSaveNodePosition != false)
    res['forceSaveNodePosition'] = instance.forceSaveNodePosition;
  if (instance.cubicLine != false) res['cubicLine'] = instance.cubicLine;
  if (instance.storeFunctionInScript != false)
    res['storeFunctionInScript'] = instance.storeFunctionInScript;
  if (instance.exportFixedPoint != false)
    res['exportFixedPoint'] = instance.exportFixedPoint;
  if (instance.useLuaForFieldVisible != false)
    res['useLuaForFieldVisible'] = instance.useLuaForFieldVisible;
  if (instance.scriptModules != null)
    res['scriptModules'] = instance.scriptModules;
  if (instance.behavicAgentProject != null)
    res['behavicAgentProject'] = instance.behavicAgentProject;
  if (instance.globalScriptVars != {})
    res['globalScriptVars'] = instance.globalScriptVars;
  if (instance.resourceLists != {})
    res['resourceLists'] = instance.resourceLists;
  if (instance.tagCamp != null) res['tagCamp'] = instance.tagCamp;
  if (instance.csharpConfig != null)
    res['csharpConfig'] = instance.csharpConfig;
  if (instance.luaConfig != null) res['luaConfig'] = instance.luaConfig;
  if (instance.exportExtraConfigs != [])
    res['exportExtraConfigs'] = instance.exportExtraConfigs;
  if (instance.byteExportPath != '')
    res['byteExportPath'] = instance.byteExportPath;
  if (instance.ignoreTypes != null) res['ignoreTypes'] = instance.ignoreTypes;
  if (instance.binaryVersionCode != null)
    res['binaryVersionCode'] = instance.binaryVersionCode;
  return res;
}
