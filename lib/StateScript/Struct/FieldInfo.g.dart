// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FieldInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldInfo _$FieldInfoFromJson(Map<String, dynamic> json) => FieldInfo()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..typeGuid = json['typeGuid'] as String? ?? '___int___'
  ..innerTypeGuid0 = json['innerTypeGuid0'] as String? ?? '___int___'
  ..innerTypeGuid1 = json['innerTypeGuid1'] as String? ?? '___int___'
  ..agentBindInfo = json['agentBindInfo'] as String? ?? ''
  ..lineCount = json['lineCount'] as int? ?? 1
  ..width = (json['width'] as num?)?.toDouble() ?? 220
  ..isFreezeHeader = json['isFreezeHeader'] as bool? ?? false
  ..isSyncField = json['isSyncField'] as bool? ?? false
  ..allowEmpty = json['allowEmpty'] as bool? ?? true
  ..isSearchKey = json['isSearchKey'] as bool? ?? false
  ..func = json['func'] as String? ?? ''
  ..gridWidth = json['gridWidth'] as int? ?? 256
  ..isStatic = json['isStatic'] as bool? ?? false
  ..isPublic = json['isPublic'] as bool? ?? true
  ..isReadOnly = json['isReadOnly'] as bool? ?? false
  ..isRef = json['isRef'] as bool? ?? false
  ..desc = json['desc'] as String? ?? ''
  ..extraParam = json['extraParam'] as String? ?? ''
  ..dataId = json['dataId'] as int? ?? 0
  ..isFieldGroup = json['isFieldGroup'] as bool? ?? false
  ..groupIds =
      (json['groupIds'] as List<dynamic>?)?.map((e) => e as int).toList()
  ..haveDynamicOutPort = json['haveDynamicOutPort'] as bool? ?? false
  ..haveDynamicInParam = json['haveDynamicInParam'] as bool? ?? false
  ..disabled = json['disabled'] as bool? ?? false
  ..autoFillTrigger = json['autoFillTrigger'] as bool? ?? false
  ..resourceListGuid = json['resourceListGuid'] as String? ?? ''
  ..highlightEdit = json['highlightEdit'] as bool? ?? false
  ..defaultValue = json['defaultValue'] ?? 0;

Map<String, dynamic> _$FieldInfoToJson(FieldInfo instance) {
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
  if (instance.typeGuid != '___int___') res['typeGuid'] = instance.typeGuid;
  if (instance.innerTypeGuid0 != '___int___')
    res['innerTypeGuid0'] = instance.innerTypeGuid0;
  if (instance.innerTypeGuid1 != '___int___')
    res['innerTypeGuid1'] = instance.innerTypeGuid1;
  if (instance.agentBindInfo != '')
    res['agentBindInfo'] = instance.agentBindInfo;
  if (instance.lineCount != 1) res['lineCount'] = instance.lineCount;
  if (instance.width != 220) res['width'] = instance.width;
  if (instance.isFreezeHeader != false)
    res['isFreezeHeader'] = instance.isFreezeHeader;
  if (instance.isSyncField != false) res['isSyncField'] = instance.isSyncField;
  if (instance.allowEmpty != true) res['allowEmpty'] = instance.allowEmpty;
  if (instance.isSearchKey != false) res['isSearchKey'] = instance.isSearchKey;
  if (instance.func != '') res['func'] = instance.func;
  if (instance.gridWidth != 256) res['gridWidth'] = instance.gridWidth;
  if (instance.isStatic != false) res['isStatic'] = instance.isStatic;
  if (instance.isPublic != true) res['isPublic'] = instance.isPublic;
  if (instance.isReadOnly != false) res['isReadOnly'] = instance.isReadOnly;
  if (instance.isRef != false) res['isRef'] = instance.isRef;
  if (instance.desc != '') res['desc'] = instance.desc;
  if (instance.extraParam != '') res['extraParam'] = instance.extraParam;
  if (instance.dataId != 0) res['dataId'] = instance.dataId;
  if (instance.isFieldGroup != false)
    res['isFieldGroup'] = instance.isFieldGroup;
  if (instance.groupIds != null) res['groupIds'] = instance.groupIds;
  if (instance.haveDynamicOutPort != false)
    res['haveDynamicOutPort'] = instance.haveDynamicOutPort;
  if (instance.haveDynamicInParam != false)
    res['haveDynamicInParam'] = instance.haveDynamicInParam;
  if (instance.disabled != false) res['disabled'] = instance.disabled;
  if (instance.autoFillTrigger != false)
    res['autoFillTrigger'] = instance.autoFillTrigger;
  if (instance.resourceListGuid != '')
    res['resourceListGuid'] = instance.resourceListGuid;
  if (instance.highlightEdit != false)
    res['highlightEdit'] = instance.highlightEdit;
  if (instance.defaultValue != 0) res['defaultValue'] = instance.defaultValue;
  return res;
}
