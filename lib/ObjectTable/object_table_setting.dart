//@dart=2.11
import 'dart:io';
 
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/OTExportConfig.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/common/FSwitch.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/directory_picker.dart';
import 'package:battlepus/common/line_container.dart';
import 'package:battlepus/common/line_field_container.dart';
import 'package:battlepus/common/pluto_list_editor.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/ThemeCenter.dart';

import 'package:path/path.dart' as PathUtil;
class ObjectTableSettingPage extends StatefulWidget {
  ObjectTableSettingPage({Key key}) : super(
      key: key);

  @override
  _ObjectTableSettingState createState() =>
      _ObjectTableSettingState(
      );
}

class _ObjectTableSettingState extends State<ObjectTableSettingPage> {
  @override
  Widget build(BuildContext context) {
    Widget rowSeparatorWidget2 = Divider(
      color: Colors.black38,
      height: 0.2,
      thickness: 0.9,
    );

    List<Widget> rows = List<Widget>();


    var r1 = Row(
      children: [
//        Expanded(
//
//          child: TextField(
//            controller: _workingPathEditor,
//            decoration: InputDecoration(
//              labelText: "工程目录",
//            ),
//            enabled: false,
//          ),
//        ),
        Expanded(
          child : LineFieldContainer(
            title: "工程目录",
            height: 52,
            child: Text(ObjectTableSetting.instance.workingPath??""),
          ),
        ),

        Container(
          width: 50,
          child : IconButton(icon: Icon(MaterialCommunityIcons.folder_open , color: Colors.blue,),iconSize: 42, color: Colors.white, tooltip:"切换工程",
            onPressed: () async {
              var path = await FileUtils.pickPath();
              if (path == null) return ;
              var filePath = PathUtil.join(path,"object_table_project.json");
              if (File(filePath).existsSync()){
                ObjectTableSetting.instance.workingPath = PathUtil.relative(path , from:GlobalBoard.getWorkingPath());
                if (ObjectTableSetting.instance.workingPath != null){
                  setState(() {
                    ObjectTableProject.load();
                    ObjectTableProject.instance.save();
                    ObjectTableProject.instance.registerEnumTypes();
//                    ScriptInfo.current = null;
                  });
                }
              }
              else{
                setState(() {
                  BotToast.showText(text: "不是有效的工程目录" , contentColor: Colors.redAccent);
                });
              }

              ObjectTableSetting.instance.save();
            },
          ),
        ),
        Container(
          width: 50,
          child : IconButton(icon: Icon(MaterialCommunityIcons.file_document_box_plus_outline , color: Colors.blue,),iconSize: 42, color: Colors.white, tooltip:"新开工程",
            onPressed: () async {
              var path = await FileUtils.pickPath();
              if (path == null) return ;
              var filePath = PathUtil.join(path,"object_table_project.json");
              if (!File(filePath).existsSync()){
                ObjectTableSetting.instance.workingPath = PathUtil.relative(path , from:GlobalBoard.getWorkingPath());
                if (ObjectTableSetting.instance.workingPath != null){
                  setState(() {
                    ObjectTableProject.load();
                    ObjectTableProject.instance.save();
//                    StateScriptProject.load();
//                    StateScriptProject.instance.save();
                  });
                }
              }
              else{
                setState(() {
                  BotToast.showText(text: "存在工程，忽略创建，直接加载", contentColor: Colors.redAccent);
                  ObjectTableSetting.instance.workingPath = PathUtil.relative(path , from:GlobalBoard.getWorkingPath());
                  if (ObjectTableSetting.instance.workingPath != null){
                    ObjectTableProject.load();
                    ObjectTableProject.instance.save();
                  }
                });
              }

              ObjectTableSetting.instance.save();
            },
          ),
        ),
      ],
    );
    rows.add(r1);

    rows.add(SizedBox(height: 42,));
    var rp = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var dc = new BoxDecoration(
      color : ThemeCenter.systemTheme.primaryColor,//CommonUtil.scaleColor(ThemeCenter.systemTheme.primaryColor,0.3),
      // boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],
    );
    if (rp != null) {

      if (!(ObjectTableProject.instance.useNewExportConfig??false)) {
        {
          var chk = Container(
            height: 48,
            decoration: dc,
            child: Row(
              children: [
                Checkbox(
                  value: ObjectTableProject.instance.csExport,
                  onChanged: (v) {
                    setState(() {
                      ObjectTableProject.instance.csExport = v;
                    });
                  },
                ),
                Text("  C# 导出"),
              ],
            ),
          );

          rows.add(chk);
        }
        if (ObjectTableProject.instance.csExport) {
          {
            var r2 = Row(
              children: [
                Expanded(
                  child: TextEditor(
                    hint: "c# 代码导出目录",
                    initValue: ObjectTableProject.instance.csCodeExportPath,
                    enabled: false,
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.folder_open, color: Colors.blue,),
                    iconSize: 42,

                    color: Colors.white,
                    tooltip: "打开文件夹",
                    onPressed: () async {
                      var path = await FileUtils.pickPath();
                      if (path != null) {
                        setState(() {
                          ObjectTableProject.instance.csCodeExportPath =
                              PathUtil.relative(path, from: rp);
                          ObjectTableProject.instance.save();
                        });
                      }
                    },
                  ),
                ),
              ],
            );
            rows.add(r2);
          }

          {
            var r2 = Row(
              children: [
                Expanded(
                  child: TextEditor(
                    hint: "c# 模板目录",
                    initValue: ObjectTableProject.instance.csTemplatePath,
                    enabled: false,
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.folder_open, color: Colors.blue,),
                    iconSize: 42,

                    color: Colors.white,
                    tooltip: "打开文件夹",
                    onPressed: () async {
                      var path = await FileUtils.pickPath();
                      if (path != null) {
                        setState(() {
                          ObjectTableProject.instance.csTemplatePath =
                              PathUtil.relative(path, from: rp);
                          ObjectTableProject.instance.save();
                        });
                      }
                    },
                  ),
                ),
              ],
            );
            rows.add(r2);
          }
        }
        {
          var chk = Container(
            height: 48,
            decoration: dc,
            child: Row(
              children: [
                Checkbox(
                  value: ObjectTableProject.instance.cppExport,
                  onChanged: (v) {
                    setState(() {
                      ObjectTableProject.instance.cppExport = v;
                    });
                  },
                ),
                Text("  C++ 导出"),
              ],
            ),
          );

          rows.add(chk);
        }

        if (ObjectTableProject.instance.cppExport) {
          {
            var r2 = Row(
              children: [
                Expanded(
                  child: TextEditor(
                    hint: "c++ 代码导出目录",
                    initValue: ObjectTableProject.instance.cppCodeExportPath,
                    enabled: false,
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.folder_open, color: Colors.blue,),
                    iconSize: 42,

                    color: Colors.white,
                    tooltip: "打开文件夹",
                    onPressed: () async {
                      var path = await FileUtils.pickPath();
                      if (path != null) {
                        setState(() {
                          ObjectTableProject.instance.cppCodeExportPath =
                              PathUtil.relative(path, from: rp);
                          ObjectTableProject.instance.save();
                        });
                      }
                    },
                  ),
                ),
              ],
            );
            rows.add(r2);
          }

          {
            var r2 = Row(
              children: [
                Expanded(
                  child: TextEditor(
                    hint: "c++ 模板目录",
                    initValue: ObjectTableProject.instance.cppTemplatePath,
                    enabled: false,
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.folder_open, color: Colors.blue,),
                    iconSize: 42,

                    color: Colors.white,
                    tooltip: "打开文件夹",
                    onPressed: () async {
                      var path = await FileUtils.pickPath();
                      if (path != null) {
                        setState(() {
                          ObjectTableProject.instance.cppTemplatePath =
                              PathUtil.relative(path, from: rp);
                          ObjectTableProject.instance.save();
                        });
                      }
                    },
                  ),
                ),
              ],
            );
            rows.add(r2);
          }
        }
        {
          var chk = Container(
            height: 48,
            decoration: dc,
            child: Row(
              children: [
                Checkbox(
                  value: ObjectTableProject.instance.luaExport,
                  onChanged: (v) {
                    setState(() {
                      ObjectTableProject.instance.luaExport = v;
                    });
                  },
                ),
                Text("  Lua 导出"),
              ],
            ),
          );

          rows.add(chk);
        }
        if (ObjectTableProject.instance.luaExport) {
          {
            var r2 = Row(
              children: [
                Expanded(
                  child: TextEditor(
                    hint: "lua 代码导出目录",
                    initValue: ObjectTableProject.instance.luaCodeExportPath,
                    enabled: false,
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.folder_open, color: Colors.blue,),
                    iconSize: 42,

                    color: Colors.white,
                    tooltip: "打开文件夹",
                    onPressed: () async {
                      var path = await FileUtils.pickPath();
                      if (path != null) {
                        setState(() {
                          ObjectTableProject.instance.luaCodeExportPath =
                              PathUtil.relative(path, from: rp);
                          ObjectTableProject.instance.save();
                        });
                      }
                    },
                  ),
                ),
              ],
            );
            rows.add(r2);
          }


          {
            var r2 = Row(
              children: [
                Expanded(
                  child: TextEditor(
                    hint: "lua 模板目录",
                    initValue: ObjectTableProject.instance.luaTemplatePath,
                    enabled: false,
                  ),
                ),
                Container(
                  width: 50,
                  child: IconButton(
                    icon: Icon(
                      MaterialCommunityIcons.folder_open, color: Colors.blue,),
                    iconSize: 42,

                    color: Colors.white,
                    tooltip: "打开文件夹",
                    onPressed: () async {
                      var path = await FileUtils.pickPath();
                      if (path != null) {
                        setState(() {
                          ObjectTableProject.instance.luaTemplatePath =
                              PathUtil.relative(path, from: rp);
                          ObjectTableProject.instance.save();
                        });
                      }
                    },
                  ),
                ),
              ],
            );
            rows.add(r2);
          }
        }
      }
      else{
        getExportConfig("主导出",ObjectTableProject.instance.mainExportConfig , rp , ObjectTableProject.instance , rows);

        var extraList = PlutoListEditor<OTExportConfig>(
          verticalActionCommand: false,
          height: 400,
          // title: "额外导出配置",
          datas: ObjectTableProject.instance.otExportConfigs,
          builder:(item){
            var itm = item as OTExportConfig;
            var header = getExportConfigHeader(itm.name , itm , rp , ObjectTableProject.instance , null , editName: true);
            // return Column(
            //   children: rows,
            // );
            return header;
          },
          creator: (){
            var cfg = OTExportConfig();
            return cfg;
          },
          onGetDetailPanel: (itm){
            return ListView(
              // itemExtent: widget.itemExtent,
              // cacheExtent: widget.cacheExtent,
              children: getExportConfig(itm.name , itm , rp , ObjectTableProject.instance , null , editName: true),
              scrollDirection: Axis.vertical,
            );
          },
          onSelectObject:(i,obj){
          },
          flexLeft: 1,
          flexRight: 2,
        );
        var blk = ThemeCenter.block(
          padding: EdgeInsets.all(4),
          expanded: false,
          headTitle: "额外导出配置",
          headHeight: 34,
          child: extraList,
        );

        rows.add(blk);

      }
      rows.add(SizedBox(height: 42,));
      {
        var r2 = Row(
          children: [
            Expanded(
              child: TextEditor(
                hint: "二进制数据导出目录",
                initValue: ObjectTableProject.instance.byteExportPath,
                enabled: false,
              ),
            ),
            Container(
              width: 50,
              child: IconButton(
                icon: Icon(
                  MaterialCommunityIcons.folder_open, color: Colors.blue,),
                iconSize: 42,

                color: Colors.white,
                tooltip: "打开文件夹",
                onPressed: () async {
                  var path = await FileUtils.pickPath();
                  if (path != null) {
                    setState(() {
                      ObjectTableProject.instance.byteExportPath =
                          PathUtil.relative(path, from: rp);
                      ObjectTableProject.instance.save();
                    });
                  }
                },
              ),
            ),
          ],
        );
        rows.add(r2);
      }

      {
        var r10 = LineContainer(
          height: 70,
          withLine: true,
          title: "新版导出路径机制",
          child: FSwitch(
              width: 40,
              open: ObjectTableProject.instance.useNewExportConfig??false,
              onChanged: (v){
                setState(() {
                  ObjectTableProject.instance.useNewExportConfig = v;
                  ObjectTableProject.instance.save();
                });
              }
          ),
        );
        rows.add(r10);
      }
    }


//    _extensionsEditor.text = SSMainSetting.instance.extensions;
//    _ftpAddressEditor.text = SSMainSetting.instance.ftpAddress??"127.0.0.1";
//    var port = SSMainSetting.instance.ftpPort??8989;
//    _ftpPortEditor.text = port.toString();
//    _ftpUserEditor.text = SSMainSetting.instance.ftpUser??"ftpuser";
//    _ftpPassEditor.text = SSMainSetting.instance.ftpPassword??"123456";
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("设置"),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child:SingleChildScrollView(
          child : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[

              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(20),
                width: 240,
                height: 200,
                child : Icon(Icons.settings , color: Colors.grey, size: 130,),
              ),
              Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: rows
              )),
            ],
          ),
        ),
      ),

    );
  }

  List<Widget> getExportConfig(String name , OTExportConfig ec , String rpath , ObjectTableProject prj , List<Widget> fullrows , {bool editName = false}){
    if (fullrows == null) fullrows = List<Widget>();
    var dc = new BoxDecoration(
        color : ThemeCenter.systemTheme.primaryColor
    );

    {
      var chk = Container(
        // height: 48,
        decoration: dc,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: ec.active??false,
              onChanged: (v){
                setState(() {
                  ec.active = v;
                });
              },
            ),
            editName? Expanded(child:TextEditor(
              initValue: ec.name??"",
              onChanged: (v){
                ec.name = v;
                // ssp.save();
              },
              onSubmitted: (v){
                ec.name = v;
                prj.save();
              },
            )):
            Text(name),
          ],
        ),
      );
      fullrows.add(chk);
    }
    var rows = List<Widget>();
    if (ec.active ) {

      {
        var r2 = DirectoryPicker(
          hint: "代码导出路径",
          tooltip: "选择代码导出路径",
          withClear: true,
          iconSize: 32,
          initPath: ec.codeExportPath??"",
          basePath: rpath,
          onChanged: (v) {
            setState(() {
              ec.codeExportPath = v;
            });

          },
        );
        rows.add(r2);
      }

      {
        var r2 = DirectoryPicker(
          hint: "模板目录",
          tooltip: "打开文件夹",
          withClear: true,
          iconSize: 32,
          initPath: ec.templatePath??"",
          basePath: rpath,
          onChanged: (v) {
            ec.templatePath = v;
            prj.save();

          },
        );
        rows.add(r2);
      }
    }

    fullrows.add(Row(
      children: [
        SizedBox(width: 40,height: 8,),
        Expanded(child:Column(
          children: rows,
        ))
      ],
    ));
    return fullrows;
  }

  Widget getExportConfigHeader(String name , OTExportConfig ec , String rpath , ObjectTableProject ssp , List<Widget> rows , {bool editName = false}){
    return Row(
      children: [
        Checkbox(
          value: ec.active??false,
          onChanged: (v){
            setState(() {
              ec.active = v;
            });
          },
        ),
        Text(name),
      ],
    );
  }

}