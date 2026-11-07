//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/script_var_runtime_view.dart';
import 'package:battlepus/common/ThemeCenter.dart';
class ScriptVarView extends StatefulWidget {
  final VarKeyValue data;
  ScriptVarView({Key key , this.data}) : super(key: key);

  @override
  _ScriptVarViewState createState() => _ScriptVarViewState();
}

class _ScriptVarViewState extends State<ScriptVarView> {
  // VarKeyValue data;
  @override
  void dispose() {
    // TODO: implement dispose
    // data = widget.data;
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeCenter.area(
      height: 32,
      child: Row(
        children: [
          Expanded(child:Text(widget.data.name??"未知变量" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12))),//Text(data.fieldInfo.getTypeShowString());
          Expanded(child:Text(widget.data.value??"" ,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12 , color:  Colors.greenAccent))),
        ],
      ),
    );
  }
}