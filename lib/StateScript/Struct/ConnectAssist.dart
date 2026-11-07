
import 'dart:convert';
import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'ConnectAssist.g.dart';
@JsonSerializable()
class ConnectAssist {
  @JsonKey(defaultValue: <String,Map<String,int>>{})
  Map<String,Map<String,int>> records = Map<String,Map<String,int>>();

  ConnectAssist();

  //此处与类名一致，由指令自动生成代码
  factory ConnectAssist.fromJson(Map<String, dynamic> json) =>
      _$ConnectAssistFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ConnectAssistToJson(this);

  void saveTo(String path){
    // var jm = json.encode(this);
    // var str =
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(this);

    // path = path;//PathUtil.join(path, name+".json");
    var f = File(path);
    f.writeAsStringSync(json);

  }

  static ConnectAssist? _instance;
  static ConnectAssist? get instance {
    return _instance;
  }

  static void load(String path){
    if (!File(path).existsSync()){
      ConnectAssist ass = ConnectAssist();
      ass.saveTo(path);
    }
    var f = File(path);
    Map<String , dynamic> userMap = jsonDecode(f.readAsStringSync());
    _instance = ConnectAssist.fromJson(userMap);
  }
}