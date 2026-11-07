// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ParamConnection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParamConnection _$ParamConnectionFromJson(Map<String, dynamic> json) =>
    ParamConnection()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..outNodeGuid = json['outNodeGuid'] as String
      ..outParamGuid = json['outParamGuid'] as String
      ..inNodeGuid = json['inNodeGuid'] as String
      ..inParamGuid = json['inParamGuid'] as String
      ..sopGuid = json['sopGuid'] as String
      ..lineColor = json['lineColor'] as int
      ..offY = (json['offY'] as num?)?.toDouble() ?? 0
      ..outOffX = (json['outOffX'] as num?)?.toDouble() ?? 0
      ..inOffX = (json['inOffX'] as num?)?.toDouble() ?? 0
      ..enableBreakPoint = json['enableBreakPoint'] as bool? ?? false;

Map<String, dynamic> _$ParamConnectionToJson(ParamConnection instance) {
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
  if (instance.outNodeGuid != null) res['outNodeGuid'] = instance.outNodeGuid;
  if (instance.outParamGuid != null)
    res['outParamGuid'] = instance.outParamGuid;
  if (instance.inNodeGuid != null) res['inNodeGuid'] = instance.inNodeGuid;
  if (instance.inParamGuid != null) res['inParamGuid'] = instance.inParamGuid;
  if (instance.sopGuid != null) res['sopGuid'] = instance.sopGuid;
  if (instance.lineColor != null) res['lineColor'] = instance.lineColor;
  if (instance.offY != 0) res['offY'] = instance.offY;
  if (instance.outOffX != 0) res['outOffX'] = instance.outOffX;
  if (instance.inOffX != 0) res['inOffX'] = instance.inOffX;
  if (instance.enableBreakPoint != false)
    res['enableBreakPoint'] = instance.enableBreakPoint;
  return res;
}
