
import 'package:json_annotation/json_annotation.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'dart:convert';
import 'package:path/path.dart' as PathUtil;
import 'dart:io';

part 'SSUserData.g.dart';

@JsonSerializable()
class SSUserData{
  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> scriptListExpandedFlags =<String , bool>{} ;
  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> moduleListExpandedFlags =<String , bool>{} ;
  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> templateListExpandedFlags =<String , bool>{} ;

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> nodeStructListExpandedFlags=<String , bool>{};

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> agentListExpandedFlags=<String , bool>{};

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> componentListExpandedFlags=<String , bool>{};

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> tempElementExpandedFlags=<String , bool>{};

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> tempFilesExpandedFlags =<String , bool>{} ;

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> behavicAgentExpandedFlags=<String , bool>{};

  @JsonKey(defaultValue: <String , bool>{})
  Map<String,bool> nodeSelectorExpandedFlags=<String , bool>{};

  @JsonKey(defaultValue: false)
  bool debugMode = false;

  SSUserData();
  //此处与类名一致，由指令自动生成代码
  factory SSUserData.fromJson(Map<String, dynamic> json) =>
      _$SSUserDataFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$SSUserDataToJson(this);

  void clear(dynamic objs , dynamic flags){

    var lstKeys = <String>[];
    lstKeys.addAll(flags.keys);
    for(var p in lstKeys){

      var ss = objs.where((element) {
        return "/${element.group}/".indexOf("$p/")>=0;
      });
      if (ss.length <=0){
        flags.remove(p);
      }
    }
  }
  void save(){
    // {
    //   var scripts = StateScriptProject.instance.scripts;
    //   var lstKeys = List<String>();
    //   lstKeys.addAll(scriptListExpandedFlags.keys);
    //   for(var p in lstKeys){
    //
    //     var ss = scripts.where((element) {
    //       return "/${element.group}/".indexOf("$p/")>=0;
    //     });
    //     if (ss.length <=0){
    //       scriptListExpandedFlags.remove(p);
    //     }
    //   }
    // }
    // clear(StateScriptProject.instance.scripts , scriptListExpandedFlags);
    // clear(StateScriptProject.instance.nodeStructs , nodeStructListExpandedFlags);
    // clear(StateScriptProject.instance.agents , agentListExpandedFlags);
    // clear(StateScriptProject.instance.components , componentListExpandedFlags);


    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String json = encoder.convert(this);
    var path = PathUtil.join(GlobalBoard.docDir.path,"battlepus");//, name+".json");
    var d = Directory(path);
    if (!d.existsSync()) d.createSync();
    var f = File(PathUtil.join(path,"ss_user.json"));
    f.writeAsStringSync(json);
  }

  static void load() {
    // _instance = ObjectTableSetting.parse("object_table_setting");//LocalStorage.instance.get("setting") as Setting;
    var path = GlobalBoard.docDir;
    var jsonPath = PathUtil.join(path.path,"battlepus","ss_user.json");
    var f = File(jsonPath);
    if (f.existsSync()){
      // JsonDecoder decoder = JsonDecoder();
      Map<String ,dynamic> userMap = jsonDecode(f.readAsStringSync());
      _instance = SSUserData.fromJson(userMap);
    }
    else{
      _instance = new SSUserData();
    }
  }

  static SSUserData? _instance;
  static SSUserData? get instance {
    if (_instance == null) _instance = new SSUserData();
    return _instance;
  }
}