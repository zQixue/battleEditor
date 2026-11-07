// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PortConnection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortConnection _$PortConnectionFromJson(Map<String, dynamic> json) =>
    PortConnection()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..outNodeGuid = json['outNodeGuid'] as String
      ..outPortGuid = json['outPortGuid'] as String
      ..inNodeGuid = json['inNodeGuid'] as String
      ..inPortGuid = json['inPortGuid'] as String
      ..sopGuid = json['sopGuid'] as String
      ..lineColor = json['lineColor'] as int
      ..offY = (json['offY'] as num?)?.toDouble() ?? 0
      ..outOffX = (json['outOffX'] as num?)?.toDouble() ?? 0
      ..inOffX = (json['inOffX'] as num?)?.toDouble() ?? 0
      ..enableBreakPoint = json['enableBreakPoint'] as bool? ?? false;

Map<String, dynamic> _$PortConnectionToJson(PortConnection instance) {
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
  if (instance.outPortGuid != null) res['outPortGuid'] = instance.outPortGuid;
  if (instance.inNodeGuid != null) res['inNodeGuid'] = instance.inNodeGuid;
  if (instance.inPortGuid != null) res['inPortGuid'] = instance.inPortGuid;
  if (instance.sopGuid != null) res['sopGuid'] = instance.sopGuid;
  if (instance.lineColor != null) res['lineColor'] = instance.lineColor;
  if (instance.offY != 0) res['offY'] = instance.offY;
  if (instance.outOffX != 0) res['outOffX'] = instance.outOffX;
  if (instance.inOffX != 0) res['inOffX'] = instance.inOffX;
  if (instance.enableBreakPoint != false)
    res['enableBreakPoint'] = instance.enableBreakPoint;
  return res;
}
