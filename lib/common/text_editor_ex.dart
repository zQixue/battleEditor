//@dart=2.11

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/autoSizeTextField/auto_size_text_field.dart';
import 'package:battlepus/common/text_editor.dart';
class TextEditorEx extends StatefulWidget {
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

  final bool autoSize ;
  final bool focus;
  // final RegExp formatReg ;// RegExp(widget.unsigned?"[0-9]":"[;0-9\+\-]")
  // final Color cursorColor;
  // final double cursorWidth;
  // ,this.cursorColor,this.cursorWidth
  TextEditorEx({Key key ,this.focus = false, this.autoSize = false,this.textInputType, this.onTap , this.noUnderline = false ,this.decoration,this.initValue = "" , this.withFocusManager = false, this.onComplete,this.isDense,this.onChanged ,
    this.contentPadding = const EdgeInsets.only(bottom: 4), this.onSubmitted , this.forceRebuild = true, this.hint , this.fontSize , this.autoFocus =false,this.enabled = true , this.maxLines = 1 ,this.textStyle = const TextStyle(color: Colors.green ),}) : super(key: key){
    // forceRefresh = true;
  }

  @override
  _TextEditorExState createState() => _TextEditorExState();
}

class _TextEditorExState extends State<TextEditorEx> {
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
        else{
          var v = _valueController.text;
          if (v.length>=1 && v.codeUnitAt(0) == 8291){
            v = v.substring(1);
            setState(() {

            });
          }
          _crtValue = v;
          widget.onSubmitted?.call(v);

          if (TextEditorFocusManager.focusNodes.contains(_focusNode)) {
            Future.delayed(Duration(milliseconds: 10)).then((value) {
              TextEditorFocusManager.focusNext();
            });
          }
        }
      });
    }

    if (widget.focus){
      _focusNode.requestFocus();
    }
    // print("text initState = ${_valueController.text}");
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    _valueController.clear();
    _valueController.text = _crtValue.toString();

    // var reg = widget.formatReg;
    // if (reg == null){
    //   reg = RegExp(widget.unsigned?"[0-9]":"[0-9\+\-]");
    // }

    // print("text build = ${_valueController.text}  , ${widget.initValue}");
    // else _valueController.text = _crtValue;

    if (widget.autoSize){
      var tf = AutoSizeTextField(
        focusNode: _focusNode,
        extraWidth:4,
        fullwidth: false,
        decoration: widget.decoration??InputDecoration(
            labelText: widget.hint,

            isDense: widget.isDense??true,
            border: widget.noUnderline?InputBorder.none:null,
            contentPadding: widget.contentPadding??EdgeInsets.only(bottom: 4)
        ),
        // cursorWidth: widget.cursorWidth,
        // cursorColor: widget.cursorColor,
        keyboardType:widget.textInputType,
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


        },
      );
      if (widget.autoFocus) _focusNode.requestFocus();
      return tf;
    }

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
        if (v.length>=1 && v.codeUnitAt(0) == 8291){
          v = v.substring(1);
          setState(() {

          });
        }
        _crtValue = v;
        widget.onSubmitted?.call(v);

        if (TextEditorFocusManager.focusNodes.contains(_focusNode)) {
          Future.delayed(Duration(milliseconds: 10)).then((value) {
            TextEditorFocusManager.focusNext();
          });
        }

      },
    );
    if (widget.autoFocus) _focusNode.requestFocus();
    return tf;
  }

}