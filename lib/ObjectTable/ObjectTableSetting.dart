 
import 'package:battlepus/LocalStorage/LocalStorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ObjectTableSetting.g.dart';

@JsonSerializable()

class ObjectTableSetting{
  String? workingPath ;

  ObjectTableSetting();
  //此处与类名一致，由指令自动生成代码
  factory ObjectTableSetting.fromJson(Map<String, dynamic> json) =>
      _$ObjectTableSettingFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ObjectTableSettingToJson(this);

  static ObjectTableSetting? parse(String file){
    var jm = LocalStorage.loadJson(file);

    if (jm != null) return ObjectTableSetting.fromJson(jm);

    return null;
  }

  void save(){
//    LocalStorage.instance.put("setting" , this);
    LocalStorage.saveJson("object_table_setting" , this);
  }

  static void load(){
    _instance = ObjectTableSetting.parse("object_table_setting");//LocalStorage.instance.get("setting") as Setting;
  }

  static ObjectTableSetting? _instance;
  static void setInstance(ObjectTableSetting ins){
    _instance = ins;
  }
  static ObjectTableSetting? get instance {
    if (_instance == null) _instance = new ObjectTableSetting();
    return _instance;
  }
}