//@dart=2.11
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/ExportConfig.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/FSwitch.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/checkbox_with_title.dart';
import 'package:battlepus/common/directory_picker.dart';
import 'package:battlepus/common/line_container.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:path/path.dart' as PathUtil;

class StateScriptSettingPage extends StatefulWidget {
  StateScriptSettingPage({Key key}) : super(
      key: key);

  @override
  _StateScriptSettingPageState createState() =>
      _StateScriptSettingPageState(
      );
}

class _StateScriptSettingPageState extends State<StateScriptSettingPage> {

  TextEditingController _workingPathEditor ;
  TextEditingController _codeExportPathEditor ;
  TextEditingController _nodeCodeExportPathEditor ;
  TextEditingController _byteExportPathEditor ;
  TextEditingController _templatePathEditor ;
//  TextEditingController _ftpPortEditor ;
//  TextEditingController _ftpUserEditor ;
//  TextEditingController _ftpPassEditor ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _workingPathEditor = TextEditingController();
    _codeExportPathEditor = TextEditingController();
    _byteExportPathEditor = TextEditingController();
    _templatePathEditor = TextEditingController();
    _nodeCodeExportPathEditor = TextEditingController();
//    _ftpUserEditor = TextEditingController();
//    _ftpPassEditor = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _workingPathEditor.dispose();
    _codeExportPathEditor.dispose();
    _byteExportPathEditor.dispose();
    _templatePathEditor.dispose();
    _nodeCodeExportPathEditor.dispose();
//    _ftpUserEditor.dispose();
//    _ftpPassEditor.dispose();
  }

  Widget getExportConfigHeader(String name , ExportConfig ec , String rpath , StateScriptProject ssp , List<Widget> rows , {bool editName = false}){
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
  List<Widget> getExportConfig(String name , ExportConfig ec , String rpath , StateScriptProject ssp , List<Widget> fullrows , {bool editName = false}){
    if (fullrows == null) fullrows = List<Widget>();
    var dc = new BoxDecoration(
      color : ThemeCenter.systemTheme.primaryColor
      // boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: ThemeCenter.systemTheme.primaryColor)],
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
                ssp.save();
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
          hint: "导出根路径",
          tooltip: "选择代码导出根路径(gen & node)",
          withClear: true,
          iconSize: 32,
          initPath: ec.baseCodeExportPath??"",
          basePath: rpath,
          onChanged: (v) {
            setState(() {
              ec.baseCodeExportPath = v;
            });

          },
        );
        rows.add(r2);
      }
      if (!(StateScriptProject.instance.useNewExportPathRule??false)) {
        {
          var r2 = Row(
            children: [
              Expanded(
                child: TextEditor(
                  hint: "结点导出目录(nodes 需要程序扩展)",
                  initValue: ec.nodeCodeExportPath,
                  enabled: false,
                ),
              ),

              // Expanded(
              //   child: TextEditor(
              //     hint: "结点导出 logic 目录(仅逻辑结点导出路径)",
              //     initValue: ec.logicNodeCodeExportPath,
              //     enabled: false,
              //   ),
              // ),
              //
              // Expanded(
              //   child: TextEditor(
              //     hint: "结点导出 view 目录(仅显示结点导出路径)",
              //     initValue: ec.logicNodeCodeExportPath,
              //     enabled: false,
              //   ),
              // ),
              Container(
                width: 50,
                child: IconButton(
                  icon: Icon(
                    MaterialCommunityIcons.folder_open, color: Colors.blue,),
                  iconSize: 42,

                  color: Colors.white,
                  tooltip: "打开文件夹",
                  onPressed: () async {
                    var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.nodeCodeExportPath, basePath: rpath));
                    if (path != null) {
                      setState(() {
                        ec.nodeCodeExportPath = PathUtil.relative(path, from: rpath);
                        ssp.save();
                      });
                    }
                  },
                ),
              ),
            ],
          );
          // rows.add(r2);
          rows.add(r2);
        }

        {
          var r2 = Row(
            children: [
              Expanded(
                child: TextEditor(
                  hint: "logic 结点导出目录(仅逻辑结点导出路径)",
                  initValue: ec.logicNodeCodeExportPath,
                  enabled: false,
                ),
              ),
              //
              // Expanded(
              //   child: TextEditor(
              //     hint: "结点导出 view 目录(仅显示结点导出路径)",
              //     initValue: ec.logicNodeCodeExportPath,
              //     enabled: false,
              //   ),
              // ),
              Container(
                width: 50,
                child: IconButton(
                  icon: Icon(
                    MaterialCommunityIcons.folder_open, color: Colors.blue,),
                  iconSize: 42,

                  color: Colors.white,
                  tooltip: "打开文件夹",
                  onPressed: () async {
                    var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.logicNodeCodeExportPath, basePath: rpath));
                    if (path != null) {
                      setState(() {
                        ec.logicNodeCodeExportPath = PathUtil.relative(path, from: rpath);
                        ssp.save();
                      });
                    }
                  },
                ),
              ),
            ],
          );
          // rows.add(r2);
          rows.add(r2);
        }

        {
          var r2 = Row(
            children: [
              //
              Expanded(
                child: TextEditor(
                  hint: "view 结点导出目录(仅显示结点导出路径)",
                  initValue: ec.viewNodeCodeExportPath,
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
                    var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.viewNodeCodeExportPath, basePath: rpath));
                    if (path != null) {
                      setState(() {
                        ec.viewNodeCodeExportPath = PathUtil.relative(path, from: rpath);
                        ssp.save();
                      });
                    }
                  },
                ),
              ),
            ],
          );
          // rows.add(r2);
          rows.add(r2);
        }
        {
          var r2 = Row(
            children: [
              Expanded(
                child: TextEditor(
                  hint: "辅助导出目录(gen 不可修改)",
                  initValue: ec.codeExportPath,
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
                    var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.codeExportPath, basePath: rpath));
                    if (path != null) {
                      setState(() {
                        ec.codeExportPath = PathUtil.relative(path, from: rpath);
                        ssp.save();
                      });
                    }
                  },
                ),
              ),
            ],
          );
          // rows.add(r2);
          rows.add(r2);
        }
        {
          var r2 = Row(
            children: [
              Expanded(
                child: TextEditor(
                  hint: "logic 辅助导出目录(仅逻辑结点导出路径)",
                  initValue: ec.logicCodeExportPath,
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
                    var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.logicCodeExportPath, basePath: rpath));
                    if (path != null) {
                      setState(() {
                        ec.logicCodeExportPath = PathUtil.relative(path, from: rpath);
                        ssp.save();
                      });
                    }
                  },
                ),
              ),
            ],
          );
          // rows.add(r2);
          rows.add(r2);
        }

        {
          var r2 = Row(
            children: [
              Expanded(
                child: TextEditor(
                  hint: "view 辅助导出目录(仅显示结点导出路径)",
                  initValue: ec.viewCodeExportPath,
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
                    var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.viewCodeExportPath, basePath: rpath));
                    if (path != null) {
                      setState(() {
                        ec.viewCodeExportPath = PathUtil.relative(path, from: rpath);
                        ssp.save();
                      });
                    }
                  },
                ),
              ),
            ],
          );
          // rows.add(r2);
          rows.add(r2);
        }
      }
      else{
        var baseCodePath = GlobalBoard.getCorrectDirectory(ec.baseCodeExportPath , basePath: rpath);
        {
          var r2 = DirectoryPicker(
            key: UniqueKey(),
            hint: "结点导出目录(nodes 需要程序扩展)",
            tooltip: "结点导出目录(nodes 需要程序扩展)",
            withClear: true,
            iconSize: 32,
            initPath: ec.defaultNodeExportPath ?? "",
            basePath: baseCodePath,
            onChanged: (v) {
              ec.defaultNodeExportPath = v;
              ssp.save();
            },
          );
          rows.add(r2);
        }

        var r2 = DirectoryPicker(
          key: UniqueKey(),
          hint: "辅助导出目录(gen 不可修改)",
          tooltip: "辅助导出目录(gen 不可修改)",
          withClear: true,
          iconSize: 32,
          initPath: ec.defaultGenExportPath??"",
          basePath: baseCodePath,
          onChanged: (v) {
            ec.defaultGenExportPath = v;
            ssp.save();
          },
        );
        rows.add(r2);

        if (ec == ssp.csharpConfig) {
          {
            var r3 = DirectoryPicker(
              key: UniqueKey(),
              hint: "逻辑层导出目录(gen)",
              tooltip: "逻辑层导出目录(gen 逻辑结点统一导出路径)",
              withClear: true,
              iconSize: 32,
              initPath: ec.effectiveLogicGenExportPath,
              basePath: baseCodePath,
              onChanged: (v) {
                ec.logicGenExportPath = v;
                ssp.save();
              },
            );
            rows.add(r3);
          }

          {
            var r3 = DirectoryPicker(
              key: UniqueKey(),
              hint: "逻辑层导出目录(node)",
              tooltip: "逻辑层导出目录(node 逻辑结点统一导出路径)",
              withClear: true,
              iconSize: 32,
              initPath: ec.effectiveLogicNodeExportPath,
              basePath: baseCodePath,
              onChanged: (v) {
                ec.logicNodeExportPath = v;
                ssp.save();
              },
            );
            rows.add(r3);
          }
        }
      }

      {
        var r2 = DirectoryPicker(
          hint: "runtime代码位置(用于生成二进制版本号)",
          tooltip: "打开文件夹",
          withClear: true,
          iconSize: 32,
          initPath: ec.runtimeCodePath??"",
          basePath: rpath,
          onChanged: (v) {
            ec.runtimeCodePath = v;
            ssp.save();
          },
        );
        rows.add(r2);
      }

      {
        // var r2 = Row(
        //   children: [
        //     Expanded(
        //       child: TextEditor(
        //         hint: "模板目录",
        //         initValue: ec.templatePath,
        //         enabled: false,
        //       ),
        //     ),
        //     Container(
        //       width: 50,
        //       child: IconButton(
        //         icon: Icon(
        //           MaterialCommunityIcons.folder_open, color: Colors.blue,),
        //         iconSize: 42,
        //
        //         color: Colors.white,
        //         tooltip: "打开文件夹",
        //         onPressed: () async {
        //           var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(ec.templatePath , basePath: rpath));
        //           if (path != null) {
        //             setState(() {
        //               ec.templatePath = PathUtil.relative(path, from: rpath);
        //               ssp.save();
        //             });
        //           }
        //         },
        //       ),
        //     ),
        //   ],
        // );
        var r2 = DirectoryPicker(
          hint: "模板目录",
          tooltip: "打开文件夹",
          withClear: true,
          iconSize: 32,
          initPath: ec.templatePath??"",
          basePath: rpath,
          onChanged: (v) {
            ec.templatePath = v;
            ssp.save();

          },
        );
        rows.add(r2);
        // rows.add(r2);
      }
      {
      //  var r2 = CheckboxWithTitle(
      //     title: "是否展开动态导出代码",
      //     value: ec.expandExport,
      //     onChanged: (v){
      //       ec.expandExport = v;
      //       ssp.save();
      //     },
      //  );
      var r2 =   LineContainer(
            title: "是否展开导出（忽略节点动态导出设置）",
            height: 52,
            child: CheckboxWithTitle(
              value: ec.expandExport,
              onChanged: (v){
                ec.expandExport = v;
                ssp.save();
              },
            )
        );

       rows.add(r2);
      }
    }
    //
    fullrows.add(Row(
      children: [
        SizedBox(width: 40,height: 8,),
        Expanded(child:Column(
          children: rows,
        ))
      ],
    ));
    return fullrows;
    // return ListView(children: rows);
  }

  @override
  Widget build(BuildContext context) {
    Widget rowSeparatorWidget2 = Divider(
      color: Colors.black38,
      height: 0.2,
      thickness: 0.9,
    );
    _workingPathEditor.text = SSMainSetting.instance.workingPath;
    // _codeExportPathEditor.text = StateScriptProject.instance.codeExportPath;
    _byteExportPathEditor.text = StateScriptProject.instance.byteExportPath;
    // _templatePathEditor.text = StateScriptProject.instance.templatePath;
    // _nodeCodeExportPathEditor.text = StateScriptProject.instance.nodeCodeExportPath;

    List<Widget> rows = List<Widget>();

    {
      var r1 = Row(
        children: [
          Expanded(
            child: TextField(
              controller: _workingPathEditor,
              decoration: InputDecoration(
                labelText: "工程目录",
              ),
              enabled: false,
            ),
          ),
          Container(
            width: 32,
            child: IconButton(icon: Icon(MaterialCommunityIcons.folder_open, color: Colors.blue,),
              iconSize: 32,
              color: Colors.white,
              tooltip: "切换工程",
              onPressed: () async {
                var initDir = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath, basePath: GlobalBoard.getWorkingPath());
                print(initDir);
                var path = await FileUtils.pickPath(initDir: initDir);
                if (path == null) return;

                var filePath = PathUtil.join(path, "state_script_project.json");
                if (File(filePath).existsSync()) {
                  SSMainSetting.instance.workingPath = PathUtil.relative(path, from: GlobalBoard.getWorkingPath());
                  if (SSMainSetting.instance.workingPath != null) {
                    setState(() {
                      StateScriptProject.switchProjectLoad();
                      StateScriptProject.instance.save();
                      ScriptInfo.current = null;
                    });
                  }
                }
                else {
                  setState(() {
                    BotToast.showText(text: "不是有效的工程目录", contentColor: Colors.redAccent);
                  });
                }

                SSMainSetting.instance.save();
              },
            ),
          ),
          Container(
            width: 41,
            child: IconButton(icon: Icon(MaterialCommunityIcons.file_document_box_plus_outline, color: Colors.blue,),
              iconSize: 32,
              color: Colors.white,
              tooltip: "新开工程",
              onPressed: () async {
                var path = await FileUtils.pickPath(
                    initDir: GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath, basePath: GlobalBoard.getWorkingPath()));
                if (path == null) return;
                var filePath = PathUtil.join(path, "state_script_project.json");
                if (!File(filePath).existsSync()) {
                  SSMainSetting.instance.workingPath = PathUtil.relative(path, from: GlobalBoard.getWorkingPath());
                  if (SSMainSetting.instance.workingPath != null) {
                    setState(() {
                      StateScriptProject.load();
                      StateScriptProject.instance.save();
                    });
                  }
                }
                else {
                  setState(() {
                    BotToast.showText(text: "存在工程，忽略创建，直接加载", contentColor: Colors.redAccent);
                    SSMainSetting.instance.workingPath = PathUtil.relative(path, from: GlobalBoard.getWorkingPath());
                    if (SSMainSetting.instance.workingPath != null) {
                      StateScriptProject.load();
                      StateScriptProject.instance.save();
                    }
                  });
                }
                SSMainSetting.instance.save();
              },
            ),
          ),
        ],
      );
      rows.add(r1);
    }

    // {
    //   var r2 = DirectoryPicker(
    //     hint: "工程目录",
    //     tooltip: "切换工程",
    //     withClear: true,
    //     iconSize: 32,
    //     initPath: StateScriptProject.instance.byteExportPath??"",
    //     basePath: GlobalBoard.getWorkingPath(),
    //     onChanged: (v) {
    //       StateScriptProject.instance.byteExportPath = v;
    //       StateScriptProject.instance.save();
    //     },
    //   );
    //   rows.add(r2);
    // }

    var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    if (rp != null) {
//       var r2 = Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _templatePathEditor,
//               decoration: InputDecoration(
//                 labelText: "导出模板目录",
//               ),
//               enabled: false,
//               onSubmitted: (v) {
//                 if (GlobalBoard.directoryExist(
//                     v)) {
//                   StateScriptProject.instance.templatePath = v;
//                   StateScriptProject.instance.save(
//                   );
// //                        EventCenter.eventBus.fire(AddResWorkPathEvent());
//                 }
//                 else {
//                   BotToast.showText(
//                       text: "文件夹 $v 不存在", contentColor: Colors.redAccent);
//                   setState(
//                           () {
//
//                       });
//                 }
//               },
//             ),
//           ),
//           Container(
//             width: 50,
//             child: IconButton(
//               icon: Icon(
//                 MaterialCommunityIcons.folder_open, color: Colors.blue,),
//               iconSize: 42,
//
//               color: Colors.white,
//               tooltip: "打开文件夹",
//               onPressed: () async {
//                 var path = await FileUtils.pickPath(
//                 );
//                 if (path != null) {
//                   setState(
//                           () {
//                         StateScriptProject.instance.templatePath = PathUtil.relative(
//                             path, from: rp);
//                         StateScriptProject.instance.save(
//                         );
//                       });
//                 }
//               },
//             ),
//           ),
//         ],
//       );

//       var r3 = Row(
//         children: [
//           Expanded(
//             child: TextField(
//               enabled: false,
//               controller: _nodeCodeExportPathEditor,
//               decoration: InputDecoration(
//                 labelText: "结点代码导出目录",
//               ),
//               onSubmitted: (v) {
//                 if (!GlobalBoard.directoryExist(
//                     v)) {
//                   GlobalBoard.tryCreateDirectory(
//                       v);
//                 }
//                 if (GlobalBoard.directoryExist(
//                     v)) {
//                   StateScriptProject.instance.nodeCodeExportPath = v;
//                   StateScriptProject.instance.save(
//                   );
// //                        EventCenter.eventBus.fire(AddResWorkPathEvent());
//                 }
//                 else {
//                   BotToast.showText(
//                       text: "文件夹 $v 不存在", contentColor: Colors.redAccent);
//                   setState(
//                           () {
//
//                       });
//                 }
//               },
//             ),
//           ),
//           Container(
//             width: 50,
//             child: IconButton(
//               icon: Icon(
//                 MaterialCommunityIcons.folder_open, color: Colors.blue,),
//               iconSize: 42,
//               color: Colors.white,
//               tooltip: "打开文件夹",
//               onPressed: () async {
//                 var path = await FileUtils.pickPath(
//                 );
//                 if (path != null) {
//                   setState(
//                           () {
//                         StateScriptProject.instance.nodeCodeExportPath = PathUtil.relative(
//                             path, from: rp);
//                         StateScriptProject.instance.save(
//                         );
//                       });
//                 }
//               },
//             ),
//           ),
//         ],
//       );


//       var r4 = Row(
//         children: [
//           Expanded(
//             child: TextField(
//               enabled: false,
//               controller: _codeExportPathEditor,
//               decoration: InputDecoration(
//                 labelText: "代码导出目录",
//               ),
//               onSubmitted: (v) {
//                 if (!GlobalBoard.directoryExist(
//                     v)) {
//                   GlobalBoard.tryCreateDirectory(
//                       v);
//                 }
//                 if (GlobalBoard.directoryExist(
//                     v)) {
//                   StateScriptProject.instance.codeExportPath = v;
//                   StateScriptProject.instance.save(
//                   );
// //                        EventCenter.eventBus.fire(AddResWorkPathEvent());
//                 }
//                 else {
//                   BotToast.showText(
//                       text: "文件夹 $v 不存在", contentColor: Colors.redAccent);
//                   setState(
//                           () {
//
//                       });
//                 }
//               },
//             ),
//           ),
//           Container(
//             width: 50,
//             child: IconButton(
//               icon: Icon(
//                 MaterialCommunityIcons.folder_open, color: Colors.blue,),
//               iconSize: 42,
//               color: Colors.white,
//               tooltip: "打开文件夹",
//               onPressed: () async {
//                 var path = await FileUtils.pickPath(
//                 );
//                 if (path != null) {
//                   setState(
//                           () {
//                         StateScriptProject.instance.codeExportPath = PathUtil.relative(
//                             path, from: rp);
//                         StateScriptProject.instance.save(
//                         );
//                       });
//                 }
//               },
//             ),
//           ),
//         ],
//       );

//       var r5 = Row(
//         children: [
//           Expanded(
//             child: TextField(
//               enabled: false,
//               controller: _byteExportPathEditor,
//               decoration: InputDecoration(
//                 labelText: "二进制数据导出目录",
//               ),
//               onSubmitted: (v) {
//                 if (!GlobalBoard.directoryExist(
//                     v)) {
//                   GlobalBoard.tryCreateDirectory(
//                       v);
//                 }
//                 if (GlobalBoard.directoryExist(
//                     v)) {
//                   StateScriptProject.instance.byteExportPath = v;
//                   StateScriptProject.instance.save(
//                   );
// //                        EventCenter.eventBus.fire(AddResWorkPathEvent());
//                 }
//                 else {
//                   BotToast.showText(
//                       text: "文件夹 $v 不存在", contentColor: Colors.redAccent);
//                   setState(
//                           () {
//
//                       });
//                 }
//               },
//             ),
//           ),
//           Container(
//             width: 50,
//             child: IconButton(
//               icon: Icon(
//                 MaterialCommunityIcons.folder_open, color: Colors.blue,),
//               iconSize: 42,
//               color: Colors.white,
//               tooltip: "打开文件夹",
//               onPressed: () async {
//                 var path = await FileUtils.pickPath(initDir: GlobalBoard.getCorrectDirectory(StateScriptProject.instance.byteExportPath, basePath: rp)
//                 );
//                 if (path != null) {
//                   setState(
//                           () {
//                         StateScriptProject.instance.byteExportPath = PathUtil.relative(path, from: rp);
//                         StateScriptProject.instance.save();
//                       });
//                 }
//               },
//             ),
//           ),
//
//         ],
//       );
//
//       rows.add(r5);

      {
        var r2 = DirectoryPicker(
          hint: "二进制数据导出目录",
          tooltip: "打开文件夹",
          withClear: true,
          iconSize: 32,
          initPath: StateScriptProject.instance.byteExportPath??"",
          basePath: rp,
          onChanged: (v) {
            StateScriptProject.instance.byteExportPath = v;
            StateScriptProject.instance.save();
          },
        );
        rows.add(r2);
      }
      if (StateScriptProject.instance.csharpConfig == null) StateScriptProject.instance.csharpConfig = ExportConfig();



      getExportConfig("主导出",StateScriptProject.instance.csharpConfig , rp , StateScriptProject.instance , rows);
      if (!(StateScriptProject.instance.useNewExportPathRule??false)) {
        if (StateScriptProject.instance.luaConfig == null) StateScriptProject.instance.luaConfig = ExportConfig();
        getExportConfig(" Lua 导出", StateScriptProject.instance.luaConfig, rp, StateScriptProject.instance, rows);
      }
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "隐藏空闲引脚",
        child: FSwitch(
          width: 40,
          open: StateScriptProject.instance.hidePort??false,
          onChanged: (v){
            setState(() {
              StateScriptProject.instance.hidePort = v;
              StateScriptProject.instance.save();
            });
          }
        ),
      );
      rows.add(r10);
    }
    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "导出 txt 辅助信息",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.exportTxtInfo??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.exportTxtInfo = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }
    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "数据兼容",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.useDataCompatible??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.useDataCompatible = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }
    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "Agent Function 导出整体长度",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.exportAgentFunctionLength??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.exportAgentFunctionLength = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }
    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "开启对象表",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.useObjectTable??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.useObjectTable = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "文件名添加名字和别名",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.addNameToFilePath??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.addNameToFilePath = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "保存的时候强制保存结点位置，不做提示",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.forceSaveNodePosition??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.forceSaveNodePosition = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "是否导出lua代码数据",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.exportLuaDataCode??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.exportLuaDataCode = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "分组保存",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.groupSave??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.groupSave = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "脚本列表前面显示脚本Id",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.showScriptId??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.showScriptId = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "脚本列表最后显示脚本名字",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.showScriptNameAtLast??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.showScriptNameAtLast = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "不隐藏参数",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.showAllFields??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.showAllFields = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "新版导出路径机制",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.useNewExportPathRule??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.useNewExportPathRule = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
    
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "开启定点数导出",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.exportFixedPoint??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.exportFixedPoint = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }
    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "使用曲线连接",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.cubicLine??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.cubicLine = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }
    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "使用 lua 脚本控制字段显隐",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.useLuaForFieldVisible??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.useLuaForFieldVisible = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
    }

    {
      var r10 = LineContainer(
        height: 70,
        withLine: true,
        title: "自定义函数保存在脚本",
        child: FSwitch(
            width: 40,
            open: StateScriptProject.instance.storeFunctionInScript??false,
            onChanged: (v){
              setState(() {
                StateScriptProject.instance.storeFunctionInScript = v;
                StateScriptProject.instance.save();
              });
            }
        ),
      );
      rows.add(r10);
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
//        actions: [
//          IconButton(icon: Icon(Icons.settings),iconSize: 32, color: Colors.white,
//            onPressed: (){
//            },
//          )
//        ],
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
}