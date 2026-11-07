
import 'package:flutter/material.dart';
import 'package:battlepus/LocalStorage/LocalStorage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SSMainSetting.g.dart';

@JsonSerializable()

class SSMainSetting{
  String? workingPath ;
  @JsonKey(defaultValue: 0xFF000000)
  int canvasColor = Colors.black.value ;

  SSMainSetting();
  //此处与类名一致，由指令自动生成代码
  factory SSMainSetting.fromJson(Map<String, dynamic> json) =>
      _$SSMainSettingFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSMainSettingToJson(this);

  static SSMainSetting? parse(String file){
    var jm = LocalStorage.loadJson(file);

    if (jm != null) return SSMainSetting.fromJson(jm);

    return null;
  }

  void save(){
//    LocalStorage.instance.put("setting" , this);
    LocalStorage.saveJson("state_script_setting" , this);
  }

  static void load(){
    _instance = SSMainSetting.parse("state_script_setting");//LocalStorage.instance.get("setting") as Setting;
  }

  static SSMainSetting? _instance;

  static void setInstance(SSMainSetting setting) {
    _instance = setting;
  }
  static SSMainSetting? get instance {
    if (_instance == null) _instance = new SSMainSetting();
    return _instance;
  }
}