//@dart=2.11
import 'package:flutter/material.dart';
typedef CellTextWidgetOnDone = Function(String value);

class CellTextField extends StatefulWidget {
  final String initText;
  final CellTextWidgetOnDone onDone;
  CellTextField({Key key, this.initText , this.onDone}) : super(key: key);

  @override
  _CellTextFieldState createState() => _CellTextFieldState();
}

class _CellTextFieldState extends State<CellTextField> {

  TextEditingController _textController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController?.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    _textController.text = widget.initText;
    var tf = TextField(
      controller: _textController,
      onChanged: (v){
        widget.onDone?.call(v);
      },
      onSubmitted: (v) {
        widget.onDone?.call(v);
      },
    );

    return tf;
  }
}