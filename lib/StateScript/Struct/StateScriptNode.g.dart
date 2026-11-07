// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StateScriptNode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateScriptNode _$StateScriptNodeFromJson(Map<String, dynamic> json) =>
    StateScriptNode()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..dynamicFieldOutPorts =
          (json['dynamicFieldOutPorts'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k,
                    (e as Map<String, dynamic>).map(
                      (k, e) => MapEntry(
                          k, OutPort.fromJson(e as Map<String, dynamic>)),
                    )),
              ) ??
              {}
      ..dynamicFieldInParams =
          (json['dynamicFieldInParams'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k,
                    (e as Map<String, dynamic>).map(
                      (k, e) => MapEntry(
                          k, InParam.fromJson(e as Map<String, dynamic>)),
                    )),
              ) ??
              {}
      ..x = (json['x'] as num).toDouble()
      ..y = (json['y'] as num).toDouble()
      ..group = json['group'] as String? ?? ''
      ..description = json['description'] as String? ?? ''
      ..descOffX = (json['descOffX'] as num?)?.toDouble() ?? 0
      ..descOffY = (json['descOffY'] as num?)?.toDouble() ?? 0
      ..nodeAlias = json['nodeAlias'] as String? ?? ''
      ..fieldValues = (json['fieldValues'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, FieldValueHolder.fromJson(e as Map<String, dynamic>)),
          ) ??
          {}
      ..fieldForceShow = (json['fieldForceShow'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          {}
      ..showHelp = json['showHelp'] as bool? ?? false
      ..eraseReady = json['eraseReady'] as bool? ?? false
      ..enablePortDoneBreakPoint =
          json['enablePortDoneBreakPoint'] as bool? ?? false
      ..enableParamDoneBreakPoint =
          json['enableParamDoneBreakPoint'] as bool? ?? false
      ..tlWidth = (json['tlWidth'] as num?)?.toDouble() ?? 200
      ..sops = (json['sops'] as List<dynamic>?)
              ?.map(
                  (e) => SubstituteOutParam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..soports = (json['soports'] as List<dynamic>?)
              ?.map(
                  (e) => SubstituteOutPort.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..moduleInterfaces =
          (json['moduleInterfaces'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k, ModuleInterface.fromJson(e as Map<String, dynamic>)),
              ) ??
              {}
      ..nodeTypeGuid = json['nodeTypeGuid'] as String? ?? '';

Map<String, dynamic> _$StateScriptNodeToJson(StateScriptNode instance) {
  var res = Map<String, dynamic>();

  if (instance.guid != '') res['guid'] = instance.guid;
  if (instance.name != '') res['name'] = instance.name;
  if (instance.cname != '') res['cname'] = instance.cname;
  if (instance.alias != '') res['alias'] = instance.alias;
  if (instance.cateTag != '') res['cateTag'] = instance.cateTag;
  if (instance.index != -1) res['index'] = instance.index;
  if (instance.exportId != null) res['exportId'] = instance.exportId;
  if (instance.syncTransform != false)
    res['syncTransform'] = instance.syncTransform;
  if (instance.dynamicFieldOutPorts != {})
    res['dynamicFieldOutPorts'] = instance.dynamicFieldOutPorts;
  if (instance.dynamicFieldInParams != {})
    res['dynamicFieldInParams'] = instance.dynamicFieldInParams;
  if (instance.x != null) res['x'] = instance.x;
  if (instance.y != null) res['y'] = instance.y;
  if (instance.group != '') res['group'] = instance.group;
  if (instance.description != '') res['description'] = instance.description;
  if (instance.descOffX != 0) res['descOffX'] = instance.descOffX;
  if (instance.descOffY != 0) res['descOffY'] = instance.descOffY;
  if (instance.nodeAlias != '') res['nodeAlias'] = instance.nodeAlias;
  if (instance.fieldValues != {}) res['fieldValues'] = instance.fieldValues;
  if (instance.fieldForceShow != {})
    res['fieldForceShow'] = instance.fieldForceShow;
  if (instance.showHelp != false) res['showHelp'] = instance.showHelp;
  if (instance.eraseReady != false) res['eraseReady'] = instance.eraseReady;
  if (instance.enablePortDoneBreakPoint != false)
    res['enablePortDoneBreakPoint'] = instance.enablePortDoneBreakPoint;
  if (instance.enableParamDoneBreakPoint != false)
    res['enableParamDoneBreakPoint'] = instance.enableParamDoneBreakPoint;
  if (instance.tlWidth != 200) res['tlWidth'] = instance.tlWidth;
  if (instance.sops != []) res['sops'] = instance.sops;
  if (instance.soports != []) res['soports'] = instance.soports;
  if (instance.moduleInterfaces != {})
    res['moduleInterfaces'] = instance.moduleInterfaces;
  if (instance.nodeTypeGuid != '') res['nodeTypeGuid'] = instance.nodeTypeGuid;
  return res;
}
