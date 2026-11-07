//@dart=2.11

import 'package:flutter/material.dart';
import 'package:battlepus/common/FSwitch.dart';

import 'package:battlepus/common/FuncTypeDef.dart';


class BoolEditor extends StatefulWidget {
  final bool initValue;
  final FunctionBoolCallback onChanged;
  final FunctionBoolCallback onSubmitted;
  final double width;
  final double height;
  BoolEditor({Key key , this.width = 59.23 , this.height , this.initValue = false , this.onChanged , this.onSubmitted}) : super(key: key);

  @override
  _BoolEditorState createState() =>
      _BoolEditorState(
      );
}

class _BoolEditorState extends State<BoolEditor> {
//  TextEditingController _valueController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    _valueController?.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _valueController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
//    _valueController.text = widget.initValue;
//  ToggleButtons(children: null, isSelected: null)

    var tf = FSwitch(
      width: widget.width,
      height: widget.height,
//      activeColor: Colors.green,
      open: widget.initValue,
      onChanged: (v){
          widget.onSubmitted?.call(v);
      },
    );
    return tf;
  }

}