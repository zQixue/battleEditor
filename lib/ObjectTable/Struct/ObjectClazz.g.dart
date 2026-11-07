// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ObjectClazz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectClazz _$ObjectClazzFromJson(Map<String, dynamic> json) => ObjectClazz()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..cname = json['cname'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..cateTag = json['cateTag'] as String? ?? ''
  ..index = json['index'] as int? ?? -1
  ..exportId = json['exportId'] as int?
  ..syncTransform = json['syncTransform'] as bool? ?? false
  ..group = json['group'] as String? ?? ''
  ..fields = (json['fields'] as List<dynamic>?)
          ?.map((e) => FieldInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..decorations = (json['decorations'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ClassDecoration.fromJson(e as Map<String, dynamic>)),
      ) ??
      {}
  ..tagFields =
      (json['tagFields'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          []
  ..refable = json['refable'] as bool? ?? true
  ..showOnNavigatorBar = json['showOnNavigatorBar'] as bool? ?? false
  ..isDefaultClazz = json['isDefaultClazz'] as bool? ?? false
  ..forceExportBinary = json['forceExportBinary'] as bool? ?? false
  ..buildSpaceMap = json['buildSpaceMap'] as bool? ?? false
  ..tagFormat = json['tagFormat'] as String? ?? '%6s: %s'
  ..fieldsLayouts = (json['fieldsLayouts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, FieldLayout.fromJson(e as Map<String, dynamic>)),
      ) ??
      {}
  ..dataHashs =
      (json['dataHashs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? []
  ..groups = (json['groups'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, FieldGroup.fromJson(e as Map<String, dynamic>)),
      ) ??
      {}
  ..baseClazz = json['baseClazz'] as String? ?? ''
  ..color = json['color'] as int? ?? 4294967295
  ..description = json['description'] as String? ?? ''
  ..idStart = json['idStart'] as int? ?? 0
  ..dels = (json['dels'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$ObjectClazzToJson(ObjectClazz instance) {
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
  if (instance.group != '') res['group'] = instance.group;
  if (instance.fields != []) res['fields'] = instance.fields;
  if (instance.decorations != {}) res['decorations'] = instance.decorations;
  if (instance.tagFields != []) res['tagFields'] = instance.tagFields;
  if (instance.refable != true) res['refable'] = instance.refable;
  if (instance.showOnNavigatorBar != false)
    res['showOnNavigatorBar'] = instance.showOnNavigatorBar;
  if (instance.isDefaultClazz != false)
    res['isDefaultClazz'] = instance.isDefaultClazz;
  if (instance.forceExportBinary != false)
    res['forceExportBinary'] = instance.forceExportBinary;
  if (instance.buildSpaceMap != false)
    res['buildSpaceMap'] = instance.buildSpaceMap;
  if (instance.tagFormat != '%6s: %s') res['tagFormat'] = instance.tagFormat;
  if (instance.fieldsLayouts != {})
    res['fieldsLayouts'] = instance.fieldsLayouts;
  if (instance.dataHashs != []) res['dataHashs'] = instance.dataHashs;
  if (instance.groups != {}) res['groups'] = instance.groups;
  if (instance.baseClazz != '') res['baseClazz'] = instance.baseClazz;
  if (instance.color != 4294967295) res['color'] = instance.color;
  if (instance.description != '') res['description'] = instance.description;
  if (instance.idStart != 0) res['idStart'] = instance.idStart;
  if (instance.dels != null) res['dels'] = instance.dels;
  return res;
}
