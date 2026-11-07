//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/common/FuncTypeDef.dart';

class TextEditor extends StatefulWidget { 
  final String initValue;
  final String hint;
  final double fontSize;
  final bool forceRebuild ;
  final VoidCallback onComplete;
  final int maxLines;
  final FunctionStringCallback onChanged;
  final FunctionStringCallback onSubmitted;
  final bool enabled ;
  final TextStyle textStyle;
  final bool autoFocus;
  final bool isDense;
  final bool withFocusManager;
  final EdgeInsetsGeometry contentPadding;
  final InputDecoration decoration;
  final dynamic onTap;
  final bool noUnderline;
  final TextInputType textInputType;
  bool forceRefresh;
  // final Color cursorColor;
  // final double cursorWidth;
  // ,this.cursorColor,this.cursorWidth
  TextEditor({Key key , this.textInputType, this.onTap , this.noUnderline = false ,this.decoration,this.initValue = "" , this.withFocusManager = false, this.onComplete,this.isDense,this.onChanged ,
    this
      .contentPadding = const EdgeInsets.only(bottom: 4), this.onSubmitted , this.forceRebuild = true, this.hint , this.fontSize , this.autoFocus =false,this.enabled = true , this.maxLines = 1 ,this.textStyle = const TextStyle(color: Colors.green ),}) : super(key: key){
    forceRefresh = true;
  }

  @override
  _TextEditorState createState() =>
      _TextEditorState(
      );
}
class TextEditorFocusManager{
  static FocusNode crtFocusNode;
  static List<FocusNode> focusNodes = List<FocusNode>();

  static void focusNext(){
    if (crtFocusNode == null) return ;
    var index = focusNodes.indexOf(crtFocusNode);
    if (index>=0){

      index = (index + 1) % focusNodes.length;
      // print(index);

      focusNodes[index].requestFocus();
    }


  }

}
class _TextEditorState extends State<TextEditor> {
  TextEditingController _valueController;
  String _crtValue = "";
  String _crtInitValue = "";

  FocusNode _focusNode;
  @override
  void dispose() {
    // print("text dispose = ${_valueController.text}");
    _valueController?.dispose();
    TextEditorFocusManager.focusNodes.remove(_focusNode);
    _focusNode?.dispose();

    // TODO: implement dispose
    super.dispose();

  }
  @override
  void initState() {
    _focusNode = FocusNode();
    _valueController = TextEditingController();
    _valueController.text = widget.initValue??"";
    _crtInitValue = widget.initValue??"";
    _crtValue =_valueController.text;

    if (widget.withFocusManager) {
      TextEditorFocusManager.focusNodes.add(_focusNode);
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          // print("focus node");
          TextEditorFocusManager.crtFocusNode = _focusNode;
        }
      });
    }

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus){
        if (!bSubmitted) {
          widget.onSubmitted?.call(_valueController.text);
          bSubmitted;
        }
      }
      else{
        bSubmitted = false;
      }
    });
    // print("text initState = ${_valueController.text}");
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    // if (widget.forceRebuild){
    //   if (_valueController.text != _crtValue??"") {
    //     _valueController.text = _crtValue??"";
    //   }
    // }
    if (_crtInitValue != widget.initValue || widget.forceRefresh){
      // print("force");
      widget.forceRefresh = false;
      _crtInitValue = widget.initValue;
      _crtValue = _crtInitValue;
      if (_valueController.text != _crtValue) {
        _valueController.text = _crtValue;
      }
    }

    // print("text build = ${_valueController.text}  , ${widget.initValue}");
    // else _valueController.text = _crtValue;
    var tf = TextField(
       decoration: widget.decoration??InputDecoration(
        labelText: widget.hint,

          isDense: widget.isDense??true,
          border: widget.noUnderline?InputBorder.none:null,
          contentPadding: widget.contentPadding??EdgeInsets.only(bottom: 4)
      ),
      // cursorWidth: widget.cursorWidth,
      // cursorColor: widget.cursorColor,
      keyboardType:widget.textInputType,
      focusNode: _focusNode,
      onTap: (){
        widget.onTap?.call();
      },
      style : widget.textStyle ,//TextStyle(color: Colors.green ),
      maxLines: widget.maxLines,
      autofocus: widget.autoFocus,
     // textAlignVertical :TextAlignVertical.top,
      controller: _valueController,
      enabled: widget.enabled,
//      maxLines: 1,
      onChanged: (v){

        if (v.length>=1 && v.codeUnitAt(0) == 8291){
          v = v.substring(1);
          BotToast.showText(text: "移除了特殊字符 8291" , contentColor: Colors.redAccent);
          setState(() {

          });
        }

        _crtValue = v;
        widget.onChanged?.call(v);
      },
        // onEditingComplete:(){
        //   widget.onComplete?.call();
        // },
      onSubmitted: (v){
        // print(2);
        _submit(v);

        if (TextEditorFocusManager.focusNodes.contains(_focusNode)) {
          Future.delayed(Duration(milliseconds: 10)).then((value) {
            TextEditorFocusManager.focusNext();
          });
        }

      },
    );
    if (widget.autoFocus) _focusNode.requestFocus();
    return tf;
//    var rowSeparatorWidget = Divider(
//      color: Colors.grey,
//      height: 0.3,
//      thickness: 0.9,
//    );
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.end,
//      children: [
//        Expanded(child: tf,),
//        rowSeparatorWidget
//      ],
//    );
  }

  bool bSubmitted = false;
  void _submit(String v){
    if (v.length>=1 && v.codeUnitAt(0) == 8291){
      v = v.substring(1);
      setState(() {

      });
    }
    _crtValue = v;
    bSubmitted = true;
    widget.onSubmitted?.call(v);
  }

}