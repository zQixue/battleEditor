
import 'package:battlepus/LocalStorage/LocalStorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SSConfig.g.dart';

@JsonSerializable()

class SSConfig{
  @JsonKey(defaultValue: 0)
  int portGroup = 0  ;

  SSConfig();
  //此处与类名一致，由指令自动生成代码
  factory SSConfig.fromJson(Map<String, dynamic> json) =>
      _$SSConfigFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSConfigToJson(this);

  static SSConfig? parse(String file){
    var jm = LocalStorage.loadJson(file);

    if (jm != null) return SSConfig.fromJson(jm);

    return null;
  }

  void save(){
//    LocalStorage.instance.put("setting" , this);
    LocalStorage.saveJson("state_script_extra_config" , this);
  }

  static void load(){
    _instance = SSConfig.parse("state_script_extra_config");//LocalStorage.instance.get("setting") as Setting;
  }

  static SSConfig? _instance;
  static SSConfig? get instance {
    if (_instance != null) return _instance ;
    if (_instance == null) load();
    if (_instance == null) _instance = new SSConfig();
    _instance!.save();
    return _instance;
  }
}