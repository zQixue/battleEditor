// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubstituteOutPort.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubstituteOutPort _$SubstituteOutPortFromJson(Map<String, dynamic> json) =>
    SubstituteOutPort()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..outNodeGuid = json['outNodeGuid'] as String? ?? ''
      ..desc = json['desc'] as String? ?? ''
      ..outPortGuid = json['outPortGuid'] as String? ?? ''
      ..x = (json['x'] as num).toDouble()
      ..y = (json['y'] as num).toDouble();

Map<String, dynamic> _$SubstituteOutPortToJson(SubstituteOutPort instance) {
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
  if (instance.outNodeGuid != '') res['outNodeGuid'] = instance.outNodeGuid;
  if (instance.desc != '') res['desc'] = instance.desc;
  if (instance.outPortGuid != '') res['outPortGuid'] = instance.outPortGuid;
  if (instance.x != null) res['x'] = instance.x;
  if (instance.y != null) res['y'] = instance.y;
  return res;
}
