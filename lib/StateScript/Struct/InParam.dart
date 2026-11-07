
import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/NodeInterface.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';

part 'InParam.g.dart';

@JsonSerializable()
class InParam extends NodeInterface implements CodeExporter{

  String paramType = "";
  @JsonKey(defaultValue: "")
  String bindFieldGuid = "";

  @JsonKey(defaultValue: 0)
  int dataId = 0 ;

  @JsonKey(ignore: true)
  bool isDynamic = false ;

  @JsonKey(defaultValue: "")
  String fieldId = "" ;
  // String getParamType(StateScript){
  //
  // }

  InParam();

  //此处与类名一致，由指令自动生成代码
  factory InParam.fromJson(Map<String, dynamic> json) =>
      _$InParamFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$InParamToJson(this);

  static Map<String , bool> ignoreTypes = {
    "int" : true,
    "float" : true,
    "double" : true,
    "bool" : true,
    "uint" : true,
    "long" : true,
    "ulong" : true,
    "Vector3" : true,
    "Vector2" : true,
    // "DVector2" : true,
    // "Vector2d" : true,
    // "Vector3d" : true,
    // "Quaternion" : true,
    "Color" : true,
    "string":true,
    // "Union" : true,
    "Microsoft.MathLibs.Math.FP":true
  };

  @override
  dynamic exportInfo({List<FieldInfo>? fields}) {

    FieldInfo? bindField ;
    if (fields != null){
      var bindFields = fields.where((element) => element.guid == bindFieldGuid).toList();
      if (bindFields.length>0){
        bindField = bindFields[0];
      }
    }
    var tp = ExportMappingConfig.instance?.mappingFieldName(paramType , {})??paramType;
    return {
      'name': name,//bindField == null?name:bindField.name,
      'alias': alias,
      'guid': guid,
      'dataId': dataId,
      'exportId':exportId.toString(),
      'withUnionRead': (ignoreTypes[paramType.trim()]==true),// paramType != "Union",//paramType != "Union" && (bindField==null||(bindField.exportId!=null && bindField.exportId>100)),
      'bindField': bindField?.exportInfo(),
      'paramType':tp,
    };
  }

  InParam clone(){
    return InParam()..name = name ..alias = alias .. paramType = paramType;
  }

  void export(ByteDataWriter bw, StateScriptNode node) {
    var op = this;
    bw.writeUint32(op.exportId ,"in param id == ${op.exportId}");
    if (node.inParamDatas == null){
      bw.writeInt32(-1, "ip $name.${op.name},link count == -1");
      return;
    }
    var d = node.inParamDatas![op.guid];
    if (d == null){
      bw.writeInt32(-1,"ip $name.${op.name},link count == -1");
      return;
    }
    // used.add(op.guid);
    d.export(bw);
  }

}