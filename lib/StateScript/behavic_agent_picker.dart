//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentProject.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';

class BehavicAgentPicker extends StatefulWidget {
  final String agentGuid;
  final dynamic onChanged ;
  final dynamic onClear;
  BehavicAgentPicker({Key key,this.agentGuid , this.onChanged , this.onClear}) : super(key: key);

  @override
  _BehavicAgentPickerState createState() => _BehavicAgentPickerState();
}

class _BehavicAgentPickerState extends State<BehavicAgentPicker> {
  @override
  Widget build(BuildContext context) {
    if (StateScriptProject.instance.behavicAgentProject == null) StateScriptProject.instance.behavicAgentProject = BehavicAgentProject();
    var agent = StateScriptProject.instance.behavicAgentProject.classes[widget.agentGuid];
    var clzLst = StateScriptProject.instance.behavicAgentProject.classes.values.toList();
    return Row(
      children: [
        Expanded(child: Text(agent?.getTypeShowString()??""),),
        ElevatedButton(
          child: Text("选择"),
          onPressed: (){
            CommonUtil.popupTreeMenu(clzLst, context ,
                title: "选择 behavic agent",
                width: 600,
                height: 800,
                onBuildItem: (clz){
                  var txt = Text((clz as BehavicAgentClass).getTypeShowString() , style : clz == agent ? TextStyle(color: Colors.greenAccent):null);
                  return Row(
                    children: [
                      Container(width: 4,),
                      Expanded(child : txt),
                    ],
                  );
                },
                // onBuildGroup: (node){
                //   return Text(node.name??"");
                // },
                onResult: (clz){
                  if (clz == null) return ;
                  widget.onChanged?.call(clz);
                },
              actions: [
                ElevatedButton(
                  child: Text("清空"),
                  style: ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(Colors.redAccent)),
                  // color: Colors.redAccent,
                  onPressed: (){
                    widget.onClear?.call();
                    Navigator.pop(context);
                  },
                )
              ]
            );
          },
        ),
      ],
    );
  }
}