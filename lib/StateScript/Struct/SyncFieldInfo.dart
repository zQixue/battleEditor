
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/FieldSyncType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';



part 'SyncFieldInfo.g.dart';

@JsonSerializable()
class SyncFieldInfo extends FieldInfo {
  @JsonKey(defaultValue: FieldSyncType.Normal)
  FieldSyncType syncType = FieldSyncType.Normal;

  SyncFieldInfo();
  //此处与类名一致，由指令自动生成代码
  factory SyncFieldInfo.fromJson(Map<String, dynamic> json) =>
      _$SyncFieldInfoFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SyncFieldInfoToJson(this);


  @override
  dynamic exportInfo() {
    var tp = SSFieldType.getFieldType(typeGuid,fieldInfo: this);
    var dv = tp!.getExportDefault(defaultValue);
    var vals = {
      'name': name,
      'alias': alias,
      'guid': guid,
      'id':exportId,
      'hash':guid.hashCode,
      'syncType' : syncType.toString(),
      'type': tp.getExportInfo(),
    };

    dv = ExportMappingConfig.instance!.mappingFieldValue(tp.name, dv , vals);
    vals['default'] = dv;
    return vals;

  }
}