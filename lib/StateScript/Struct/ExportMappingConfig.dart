
import 'package:liquid_engine/liquid_engine.dart';
import 'package:battlepus/StateScript/Struct/FieldMapping.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/StateScript/Struct/SSStorage.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';



part 'ExportMappingConfig.g.dart';

@JsonSerializable()
class ExportMappingConfig {

  @JsonKey(defaultValue: 'cs')
  String extension = 'cs';

  @JsonKey(defaultValue: 'buf.battlescriptx')
  String namespace = 'buf.battlescriptx';
  @JsonKey(defaultValue: 'buf.battlescriptx')
  String otnamespace = 'buf.objecttable';
  @JsonKey(defaultValue: 'buf.enum')
  String enumnamespace = 'buf.enum';

  @JsonKey(defaultValue: <FieldMapping>[])
  List<FieldMapping> fieldMaps = <FieldMapping>[];

  @JsonKey(defaultValue: <String,String>{})
  Map<String , String> operates = Map<String , String> ();

  ExportMappingConfig();
  //此处与类名一致，由指令自动生成代码
  factory ExportMappingConfig.fromJson(Map<String, dynamic> json) =>
      _$ExportMappingConfigFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ExportMappingConfigToJson(this);

  static ExportMappingConfig? parse(String mappingPath , String file){
    // var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    // var codePath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance.templatePath , basePath: basePath);
    var jm = SSStorage.loadJson(file , root:mappingPath);
    if (jm != null) return ExportMappingConfig.fromJson(jm);

    return null;
  }

  static void load(String mappingPath , {bool force = false}){
    if (force) _instance= null;
    if (_instance != null) return ;
    _instance = ExportMappingConfig.parse(mappingPath , "mapping");//LocalStorage.instance.get("setting") as Setting;
    if (_instance == null){
      _instance= ExportMappingConfig();
      var fm = FieldMapping();
      _instance!.fieldMaps.add(fm);
    }

    _instance!.initFieldMap();
    _instance!.save();
//
  }

  void save(){
    // SSStorage.saveJson("mapping" , this , root:StateScriptProject.instance.templatePath);
  }

  static ExportMappingConfig? _instance;
  static ExportMappingConfig? get instance {
    if (_instance == null) _instance = new ExportMappingConfig();
    return _instance;
  }
  final context = Context.create();
  @JsonKey(ignore:true)
  Map<String , FieldMapping>? _name2fieldMaps;
  void initFieldMap(){
    _name2fieldMaps = Map<String , FieldMapping>();
    for (var f in fieldMaps){
      _name2fieldMaps![f.srcName] = f;
    }
  }

  String mappingFieldName(String name , params){
    if(_name2fieldMaps== null) return name;
    var f = _name2fieldMaps![name];
    if (f == null) return name;
    if (f.dstName== null ||f.dstName=="") return name;

    context.variables['params'] = params;

    final template = Template.parse(context, Source.fromString(f.dstName));
    var outCode = (template.render(context));
    return outCode.trim();
  }
  String mappingBinaryReader(String name , params){
    if(_name2fieldMaps== null) return name;
    var f = _name2fieldMaps![name];
    if (f == null) return name;
    if (f.binaryReader== null ||f.binaryReader=="") return name;

    context.variables['params'] = params;

    final template = Template.parse(context, Source.fromString(f.binaryReader));
    var outCode = (template.render(context));
    return outCode.trim();
  }

  dynamic mappingFieldValue(String name , value , params){
    // print(name);
    // print(value);
    // print(StackTrace.current);
    if(_name2fieldMaps== null) return value;
    if (value is double && StateScriptProject.instance!.exportFixedPoint) {
      value = "_" + value.toString().replaceAll(".", "_");
    }
    var f = _name2fieldMaps![name];
    // print("CCCCCC");
    if (f == null) return value;
    // print("DDDDDD");

    // print(f.defaultValueTemplate);
    if (f.defaultValueTemplate== null ||f.defaultValueTemplate=="") return value;
    // print("done2");
    context.variables['oriValue'] = value;
    context.variables['value'] = value.toString();
    context.variables['params'] = params;

    final template = Template.parse(context, Source.fromString(f.defaultValueTemplate));
    var outCode = (template.render(context));
    // print("done1");
    return outCode.trim();
//    return f.valueTemplate.replaceAll("{{value}}", value);
  }
//
//  String mappingBinaryReader(String name) {
//    var f = _name2fieldMaps[name];
//    if (f == null) return "($name) ";
//    if (f.valueTemplate== null ||f.valueTemplate=="") return value;
//    return f.valueTemplate.replaceAll("{{value}}", value);
//  }
}