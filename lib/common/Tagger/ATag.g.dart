// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ATag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ATag _$ATagFromJson(Map<String, dynamic> json) => ATag()
  ..guid = json['guid'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..alias = json['alias'] as String? ?? ''
  ..commonNodePath = json['commonNodePath'] as String? ?? ''
  ..logicNodePath = json['logicNodePath'] as String? ?? ''
  ..commonGenPath = json['commonGenPath'] as String? ?? ''
  ..logicGenPath = json['logicGenPath'] as String? ?? ''
  ..viewNodePath = json['viewNodePath'] as String? ?? ''
  ..viewGenPath = json['viewGenPath'] as String? ?? ''
  ..commonNodePathLua = json['commonNodePathLua'] as String? ?? ''
  ..logicNodePathLua = json['logicNodePathLua'] as String? ?? ''
  ..commonGenPathLua = json['commonGenPathLua'] as String? ?? ''
  ..logicGenPathLua = json['logicGenPathLua'] as String? ?? ''
  ..viewNodePathLua = json['viewNodePathLua'] as String? ?? ''
  ..viewGenPathLua = json['viewGenPathLua'] as String? ?? '';

Map<String, dynamic> _$ATagToJson(ATag instance) {
  var res = Map<String, dynamic>();

  if (instance.guid != '') res['guid'] = instance.guid;
  if (instance.name != '') res['name'] = instance.name;
  if (instance.alias != '') res['alias'] = instance.alias;
  if (instance.commonNodePath != '')
    res['commonNodePath'] = instance.commonNodePath;
  if (instance.logicNodePath != '')
    res['logicNodePath'] = instance.logicNodePath;
  if (instance.commonGenPath != '')
    res['commonGenPath'] = instance.commonGenPath;
  if (instance.logicGenPath != '') res['logicGenPath'] = instance.logicGenPath;
  if (instance.viewNodePath != '') res['viewNodePath'] = instance.viewNodePath;
  if (instance.viewGenPath != '') res['viewGenPath'] = instance.viewGenPath;
  if (instance.commonNodePathLua != '')
    res['commonNodePathLua'] = instance.commonNodePathLua;
  if (instance.logicNodePathLua != '')
    res['logicNodePathLua'] = instance.logicNodePathLua;
  if (instance.commonGenPathLua != '')
    res['commonGenPathLua'] = instance.commonGenPathLua;
  if (instance.logicGenPathLua != '')
    res['logicGenPathLua'] = instance.logicGenPathLua;
  if (instance.viewNodePathLua != '')
    res['viewNodePathLua'] = instance.viewNodePathLua;
  if (instance.viewGenPathLua != '')
    res['viewGenPathLua'] = instance.viewGenPathLua;
  return res;
}
