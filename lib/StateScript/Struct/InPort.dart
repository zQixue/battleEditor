
import 'package:battlepus/StateScript/Struct/CodeExporter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/NodeInterface.dart';
part 'InPort.g.dart';

@JsonSerializable()
class InPort extends NodeInterface implements CodeExporter{


  InPort();
  //此处与类名一致，由指令自动生成代码
  factory InPort.fromJson(Map<String, dynamic> json) =>
      _$InPortFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$InPortToJson(this);

  @override
  exportInfo() {
    return {
      'name': name,
      'alias': alias,
      'guid': guid,
      'exportId':exportId.toString(),
    };
  }

  InPort clone(){
    return InPort()..name = name ..alias = alias;
  }


}