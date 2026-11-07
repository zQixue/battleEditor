//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/function_editor.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:battlepus/common/GlobalDoard.dart';
import 'dart:io';

class FunctionEditorView extends StatefulWidget {
  FunctionEditorView({Key key}) : super(key: key);

  @override
  _FunctionEditorViewState createState() => _FunctionEditorViewState();
}

class _FunctionEditorViewState extends State<FunctionEditorView> {
  @override
  Widget build(BuildContext context) {
    var func = ModalRoute.of(context).settings.arguments as CBFunction;
    func.load();

    return Scaffold(
        appBar: AppBar(
            title: Text("函数编辑 ${func.guid}"),
            actions: [
              IconButton(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                icon: Icon(MaterialCommunityIcons.content_save),iconSize: 44, color: Colors.greenAccent, tooltip:"保存",
                onPressed: () {
                  func.save(ScriptInfo.current.guid);
                  if (ScriptInfo.current != null){
                    StateScriptProject.instance.save();
                  }
                  BotToast.showText(text: "保存完毕", contentColor: Colors.green);

                  if (RunSession.instance.remoteIsPlaying){

                    StateScriptProject.instance.runtimeExportFunctions();
                    //cs
                    var codePath = PathUtil.join(GlobalBoard.docDir.path , "battlepus" ,"state_script" , "Functions.sscs");// //GlobalBoard.getCorrectDirectory(currentExportConfig.codeExportPath , basePath: basePath);
                    if (File(codePath).existsSync()){
                      RunSession.instance.sendReFreshFunction(codePath);
                    }
                  }
                },
              ),
            ]
        ),
        body: FunctionEditor(function: func,)
    );
  }
}