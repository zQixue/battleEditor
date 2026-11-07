//@dart=2.11




import 'dart:convert';

class ClipObj{
  String type;
  dynamic serializedData;
}

class ClipBoard{
  static List<ClipObj> objs = List<ClipObj>();

  static void clear(){
    objs.clear();
  }

  static void copy(String type , dynamic data){
    objs.add(ClipObj()..type = type..serializedData = data);
  }

  static void copyJsonObj(String type , dynamic obj){
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    var json = encoder.convert(obj);
    objs.add(ClipObj()..type =type..serializedData = json);
  }

  static List<dynamic> getJsonObj(String type){
    List<dynamic> res = [];
    for(var json in objs){
      if (json.type == type){
        res.add(json.serializedData);
      }
    }
    return res;
  }

}