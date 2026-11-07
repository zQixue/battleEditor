// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NodeStructData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NodeStructData _$NodeStructDataFromJson(Map<String, dynamic> json) =>
    NodeStructData()
      ..guid = json['guid'] as String? ?? ''
      ..name = json['name'] as String? ?? ''
      ..cname = json['cname'] as String? ?? ''
      ..alias = json['alias'] as String? ?? ''
      ..cateTag = json['cateTag'] as String? ?? ''
      ..index = json['index'] as int? ?? -1
      ..exportId = json['exportId'] as int?
      ..syncTransform = json['syncTransform'] as bool? ?? false
      ..baseType = json['baseType'] as String
      ..group = json['group'] as String
      ..fields = (json['fields'] as List<dynamic>)
          .map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList()
      ..inPorts = (json['inPorts'] as List<dynamic>?)
              ?.map((e) => InPort.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..outPorts = (json['outPorts'] as List<dynamic>?)
              ?.map((e) => OutPort.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..inParams = (json['inParams'] as List<dynamic>?)
              ?.map((e) => InParam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..width = (json['width'] as num?)?.toDouble() ?? 180
      ..withViewNode = json['withViewNode'] as bool? ?? false
      ..isLogicNode = json['isLogicNode'] as bool? ?? true
      ..isSystemNode = json['isSystemNode'] as bool? ?? false
      ..isViewNode = json['isViewNode'] as bool? ?? true
      ..descriptionTemplate = json['descriptionTemplate'] as String? ?? ''
      ..tagSet = json['tagSet'] == null
          ? null
          : TagSet.fromJson(json['tagSet'] as Map<String, dynamic>)
      ..dataHashs = (json['dataHashs'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          []
      ..isExportDynamicData = json['isExportDynamicData'] as bool? ?? false
      ..forceExportGenPath = json['forceExportGenPath'] as String? ?? ''
      ..forceExportNodePath = json['forceExportNodePath'] as String? ?? ''
      ..needLoadResource = json['needLoadResource'] as bool? ?? false
      ..outParams = (json['outParams'] as List<dynamic>?)
              ?.map((e) => OutParam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..isSyncNode = json['isSyncNode'] as bool? ?? false
      ..isTimelineNode = json['isTimelineNode'] as bool? ?? false
      ..isFlipParam = json['isFlipParam'] as bool? ?? false
      ..syncFields = (json['syncFields'] as List<dynamic>?)
              ?.map((e) => SyncFieldInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          []
      ..description = json['description'] as String? ?? ''
      ..code = json['code'] as String? ?? ''
      ..bgColor = json['bgColor'] as int? ?? 4286545791
      ..withUpdateLogic = json['withUpdateLogic'] as bool? ?? false
      ..isSystemType = json['isSystemType'] as bool? ?? false
      ..isDebugNode = json['isDebugNode'] as bool? ?? false;

Map<String, dynamic> _$NodeStructDataToJson(NodeStructData instance) {
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
  if (instance.baseType != null) res['baseType'] = instance.baseType;
  if (instance.group != null) res['group'] = instance.group;
  if (instance.fields != null) res['fields'] = instance.fields;
  if (instance.inPorts != []) res['inPorts'] = instance.inPorts;
  if (instance.outPorts != []) res['outPorts'] = instance.outPorts;
  if (instance.inParams != []) res['inParams'] = instance.inParams;
  if (instance.width != 180) res['width'] = instance.width;
  if (instance.withViewNode != false)
    res['withViewNode'] = instance.withViewNode;
  if (instance.isLogicNode != true) res['isLogicNode'] = instance.isLogicNode;
  if (instance.isSystemNode != false)
    res['isSystemNode'] = instance.isSystemNode;
  if (instance.isViewNode != true) res['isViewNode'] = instance.isViewNode;
  if (instance.descriptionTemplate != '')
    res['descriptionTemplate'] = instance.descriptionTemplate;
  if (instance.tagSet != null) res['tagSet'] = instance.tagSet;
  if (instance.dataHashs != []) res['dataHashs'] = instance.dataHashs;
  if (instance.isExportDynamicData != false)
    res['isExportDynamicData'] = instance.isExportDynamicData;
  if (instance.forceExportGenPath != '')
    res['forceExportGenPath'] = instance.forceExportGenPath;
  if (instance.forceExportNodePath != '')
    res['forceExportNodePath'] = instance.forceExportNodePath;
  if (instance.needLoadResource != false)
    res['needLoadResource'] = instance.needLoadResource;
  if (instance.outParams != []) res['outParams'] = instance.outParams;
  if (instance.isSyncNode != false) res['isSyncNode'] = instance.isSyncNode;
  if (instance.isTimelineNode != false)
    res['isTimelineNode'] = instance.isTimelineNode;
  if (instance.isFlipParam != false) res['isFlipParam'] = instance.isFlipParam;
  if (instance.syncFields != []) res['syncFields'] = instance.syncFields;
  if (instance.description != '') res['description'] = instance.description;
  if (instance.code != '') res['code'] = instance.code;
  if (instance.bgColor != 4286545791) res['bgColor'] = instance.bgColor;
  if (instance.withUpdateLogic != false)
    res['withUpdateLogic'] = instance.withUpdateLogic;
  if (instance.isSystemType != false)
    res['isSystemType'] = instance.isSystemType;
  if (instance.isDebugNode != false) res['isDebugNode'] = instance.isDebugNode;
  return res;
}
