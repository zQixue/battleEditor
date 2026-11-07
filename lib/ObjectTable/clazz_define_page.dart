//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/MultiLans/TableReader/TableManager.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/ObjectTable/clazz_define_list_view.dart';
import 'package:battlepus/ObjectTable/clazz_detail_view.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/ObjectTable/xml_types_tree_view.dart';
import 'package:battlepus/BattlePusGlobal.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:path/path.dart' as PathUtil;

class ClazzDefinePage extends StatefulWidget {
  ClazzDefinePage({Key key}) : super(
      key: key);

  @override
  _ClazzDefinePageState createState() =>
      _ClazzDefinePageState(
      );
}

class _ClazzDefinePageState extends State<ClazzDefinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("对象(表)定义"),
        actions: [

          IconButton(icon: Icon(MaterialCommunityIcons.import),iconSize: 36, color: Colors.white, tooltip:"导入类型",
            onPressed: (){
              // ObjectTableProject.instance.save(saveObject: false);
              FileUtils.pickFile("选择文件", ["xml","csv"]).then((value){
                if (value != null){
                  print("---- pick file: $value");
                  if (value.toLowerCase().endsWith(".csv")){
                    //导入 csv 类型
                    loadCsvType(value);
                    // BotToast.showText(text: "导入完成" , contentColor: Colors.green);
                  }
                  if (value.toLowerCase().endsWith(".xml")){
                    //导入 xml 类型
                    var aXml = CommonUtil.loadXml(value);
                    var types = aXml["types"];

                    showDialog(
                      context: context,
                      barrierColor:Colors.black87,
                      // barrierDismissible: false,
                      builder: (BuildContext context) {
                        // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
                        return Dialog(child: Container(
                          color: Colors.black45,
                          width: 1000,
                          height: 800,
                          child: XmlTypesTreeView(types : types),
                        ), );
                      },
                    ).then((value){
                      print("---------------- return checked : $value");
                      if (value != null){
                        var inputTypes = value[0] as Map<String,bool>;
                        inputTypes.forEach((key, value) {
                          loadXmlType(types[key]);
                        });

                        inputTypes.forEach((key, value) {
                          loadXmlType(types[key]);
                        });

                        BotToast.showText(text: "导入完成" , contentColor: Colors.green);
                        setState(() {

                        });
                      }
                    });

                  }
                }
              });
            },
          ),

          IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 36, color: Colors.white, tooltip:"保存",
            onPressed: (){
              ObjectTableProject.instance.save(saveObject: false);
              BattlePusGlobal.broadcastToMain("ot_reload");
            },
          ),
        ],
      ),
      body:Container(
        padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(flex:3,child:ClazzDefineListView()),
            // SizedBox(width: 8,),
            Expanded(flex:14,child:ClazzDetailView()),
          ],
        ),
      ),
    );
  }

  void loadCsvType(String csvFilePath){
    var tbl = TableManager.getTable(csvFilePath);
    if (tbl == null) {
      BotToast.showText(text: "CSV 文件读取失败", contentColor: Colors.redAccent);
      return;
    }
    var clzname = PathUtil.basenameWithoutExtension(csvFilePath);
    if (TableUtiles.name2clazzes == null) TableUtiles.initName2Clazzes();
    var clz = TableUtiles.name2clazzes[clzname];

    if (clz == null){
      clz = ObjectTableProject.instance.addClazz();
      clz.name = clzname;
      ObjectTableProject.instance.refreshClazzMap();
    }

    tbl.columns.forEach((element) {
      var desc = element.desc;
      var name = element.name;
      var type = element.type;
      if (DartCommon.isEmpty(name) || DartCommon.isEmpty(type)){
        return ;
      }
      var existField = clz.getNameToFieldMap()[name];
      if (existField != null) return ;
      var field = clz.addField();
      field.name = name;
      field.desc = desc;
      field.alias = desc;
      if (type == "int") {
        field.typeGuid = "___int___";
      }
      else if (type == "float") {
        field.typeGuid = "___float___";
      }
      else if (type == "int[]") {
        field.typeGuid = "___intarray___";
      }
      else{
        field.typeGuid = "___string___";
      }
    });
    TableUtiles.initName2Clazzes();
    clz.rebuildAllFields();
    BotToast.showText(text: "导入完成" , contentColor: Colors.green);
    setState(() {

    });
  }

  void loadXmlType(ClazzInfo ci){
    // var tbl = TableManager.getTable(csvFilePath);
    // if (tbl == null) {
    //   BotToast.showText(text: "CSV 文件读取失败", contentColor: Colors.redAccent);
    //   return;
    // }
    var clzname = ci.name;
    if (TableUtiles.name2clazzes == null) TableUtiles.initName2Clazzes();
    var clz = TableUtiles.name2clazzes[clzname];

    if (clz == null){
      clz = ObjectTableProject.instance.addClazz();
      clz.name = clzname;
      ObjectTableProject.instance.refreshClazzMap();
    }

    ci.fields.forEach((key,element) {
      var desc = element["name"];
      var name = element["name"];
      var type = "string";//element.type;

      var val = element["value"];
      if (int.tryParse(val) != null){
        type = "int";
      }
      else if (double.tryParse(val) != null){
        type = "float";
      }

      if (DartCommon.isEmpty(name) || DartCommon.isEmpty(type)){
        return ;
      }
      var existField = clz.getNameToFieldMap()[name];
      if (existField != null) return ;
      var field = clz.addField();
      field.name = name;
      field.desc = desc;
      field.alias = desc;
      if (type == "int") {
        field.typeGuid = "___int___";
      }
      else if (type == "float") {
        field.typeGuid = "___float___";
      }
      else if (type == "int[]") {
        field.typeGuid = "___intarray___";
      }
      else{
        field.typeGuid = "___string___";
      }
    });

    ci.childTypes.forEach((tpName, value) {
      var subClz = TableUtiles.name2clazzes[tpName];
      if (subClz != null){
        if (value>1){
          //数组
          var fName = "a${tpName}List";
          var existField = clz.getNameToFieldMap()[fName];
          if (existField != null) return ;
          var field = clz.addField();
          field.name = fName;

          field.typeGuid = "___list___";
          field.innerTypeGuid0 = "___objref___:${subClz.guid}:___int___";
        }
        else{
          var fName = "a$tpName";
          var existField = clz.getNameToFieldMap()[fName];
          if (existField != null) return ;
          var field = clz.addField();
          field.name = fName;

          field.typeGuid = "___objref___";
          field.innerTypeGuid0 = subClz.guid;
        }
      }
    });

    TableUtiles.initName2Clazzes();
    clz.rebuildAllFields();

  }
}