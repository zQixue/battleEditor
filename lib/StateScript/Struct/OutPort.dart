 

import 'package:battlepus/StateScript/Struct/CodeExporter.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/NodeInterface.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';

part 'OutPort.g.dart';

@JsonSerializable()
class OutPort extends NodeInterface implements CodeExporter{

  @JsonKey(defaultValue: 0)
  int dataId = 0 ;
  @JsonKey(ignore: true)
  bool isDynamic = false ;

  OutPort();

  //此处与类名一致，由指令自动生成代码
  factory OutPort.fromJson(Map<String, dynamic> json) =>
      _$OutPortFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$OutPortToJson(this);

  @override
  exportInfo() {
    return {
      'name': name,
      'alias': alias,
      'guid': guid,
      'dataId': dataId,
      'exportId':exportId.toString(),
    };
  }

  OutPort clone(){
    return OutPort()..name = name ..alias = alias;
  }

  void export(ByteDataWriter bw , StateScriptNode node) {
    var op = this;
    bw.writeUint32(op.exportId ,"out port id == ${op.exportId}");
    if (node.outPortDatas == null){
      bw.writeInt32(0 , "op $name.${op.name},link count == 0");
      return;
    }
    var d = node.outPortDatas![op.guid];
    if (d == null){
      bw.writeInt32(0 ,"op $name.${op.name},link count == 0");
      return;
    }
    // used.add(op.guid);
    d.export(bw);
  }
}
