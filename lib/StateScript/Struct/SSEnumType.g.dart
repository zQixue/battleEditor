// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SSEnumType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SSEnumType _$SSEnumTypeFromJson(Map<String, dynamic> json) => SSEnumType()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..innerTypeGuid0 = json['innerTypeGuid0'] as String
  ..innerTypeGuid1 = json['innerTypeGuid1'] as String
  ..innerTypeCount = json['innerTypeCount'] as int? ?? 0
  ..flag = json['flag'] as int? ?? 0
  ..priority = json['priority'] as int? ?? 1024
  ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => SSEnumItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..exportSolver = json['exportSolver'] as bool? ?? false
  ..needExport = json['needExport'] as bool? ?? true
  ..solveCompName = json['solveCompName'] as String? ?? ''
  ..staticDataName = json['staticDataName'] as String? ?? ''
  ..isBehavicEnum = json['isBehavicEnum'] as bool? ?? false
  ..namespace = json['namespace'] as String? ?? ''
  ..desc = json['desc'] as String? ?? ''
  ..group = json['group'] as String? ?? ''
  ..needExportCode = json['needExportCode'] as bool? ?? true;

Map<String, dynamic> _$SSEnumTypeToJson(SSEnumType instance) {
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
  if (instance.innerTypeGuid0 != null)
    res['innerTypeGuid0'] = instance.innerTypeGuid0;
  if (instance.innerTypeGuid1 != null)
    res['innerTypeGuid1'] = instance.innerTypeGuid1;
  if (instance.innerTypeCount != 0)
    res['innerTypeCount'] = instance.innerTypeCount;
  if (instance.flag != 0) res['flag'] = instance.flag;
  if (instance.priority != 1024) res['priority'] = instance.priority;
  if (instance.items != []) res['items'] = instance.items;
  if (instance.exportSolver != false)
    res['exportSolver'] = instance.exportSolver;
  if (instance.needExport != true) res['needExport'] = instance.needExport;
  if (instance.solveCompName != '')
    res['solveCompName'] = instance.solveCompName;
  if (instance.staticDataName != '')
    res['staticDataName'] = instance.staticDataName;
  if (instance.isBehavicEnum != false)
    res['isBehavicEnum'] = instance.isBehavicEnum;
  if (instance.namespace != '') res['namespace'] = instance.namespace;
  if (instance.desc != '') res['desc'] = instance.desc;
  if (instance.group != '') res['group'] = instance.group;
  if (instance.needExportCode != true)
    res['needExportCode'] = instance.needExportCode;
  return res;
}
