

import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/NodeInterface.dart';
part 'OutParam.g.dart';

@JsonSerializable()
class OutParam extends NodeInterface implements CodeExporter{

  @JsonKey(defaultValue: "int")
  String paramType = "int";

  OutParam();

  //此处与类名一致，由指令自动生成代码
  factory OutParam.fromJson(Map<String, dynamic> json) =>
      _$OutParamFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$OutParamToJson(this);

  @override
  exportInfo() {
    var tp = ExportMappingConfig.instance?.mappingFieldName(paramType , {})??paramType;
    return {
      'name': name,
      'alias': alias,
      'withUnionRead': InParam.ignoreTypes[paramType.trim()]==true,//ignoreTypes.containsKey(paramType.trim()),
      'guid': guid,
      'exportId':exportId.toString(),
      'paramType':tp,
    };
  }

  OutParam clone(){
    return OutParam()..name = name ..alias = alias .. paramType = paramType;
  }
}
