//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/autoSizeTextField/auto_size_text_field.dart';

class IntEditorEx extends StatefulWidget {
  final int initValue;
  final String hint;
  final bool forceBuild;
  final double fontSize;
  final FunctionDynamicCallback onChanged;
  final FunctionDynamicCallback onSubmitted;
  final bool enabled ;
  final bool noBorder ;
  final bool unsigned;
  final bool isDense;
  final dynamic onTap;
  final TextStyle textStyle;
  final bool autoSize ;
  final bool focus;
  final EdgeInsetsGeometry contentPadding ;
  final RegExp formatReg ;// RegExp(widget.unsigned?"[0-9]":"[;0-9\+\-]")
  // bool forceRefresh;


  IntEditorEx({Key key ,this.formatReg , this.focus= false,this.autoSize = false,this.isDense,this.textStyle,this.onTap,this.unsigned = false, this.contentPadding , this.hint , this.noBorder = false , this.initValue
  = 0 , this
      .onChanged , this
      .onSubmitted
    ,this
        .enabled = true ,
    this.forceBuild = false , this.fontSize}) : super(key: key){
    // forceRefresh = true;
  }


  @override
  _IntEditorExState createState() => _IntEditorExState();
}

class _IntEditorExState extends State<IntEditorEx> {
  TextEditingController _valueController;
  int _crtValue ;
  FocusNode _focusNode ;

  @override
  void dispose() {
    _focusNode?.dispose();
    // TODO: implement dispose
    super.dispose();
    _valueController?.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _valueController = TextEditingController();
    _valueController.text = widget.initValue.toString();
    _crtValue = widget.initValue;
    _focusNode = FocusNode();


    if (widget.focus){
      _focusNode.requestFocus();
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // print('得到焦点');
      }else{
        var v = _valueController.text;
        var intv = int.tryParse(v);
        if (intv != null){
          _crtValue = intv;
          widget.onSubmitted?.call(intv);
          setState(() {
          });
        }
        else{
          // print("comma v : $v");
          // if (v== ""){
          //   widget.onSubmitted?.call(0);
          //   setState(() {
          //   });
          //   return;
          // }
          widget.onSubmitted?.call(v);
          setState(() {
          });
        }
        // print('失去焦点');
        // var v = _valueController.text;
        // var intv = int.tryParse(v)??0;
        // if (intv != null){
        //   _crtValue = intv;
        //   widget.onSubmitted?.call(intv);
        //   setState(() {
        //   });
        // }
        // else{
        //   // print("comma v : $v");
        //   widget.onSubmitted?.call(v);
        //   setState(() {
        //   });
        // }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // if (widget.forceBuild) _valueController.text = widget.initValue.toString();
    // if (widget.forceRefresh){
    //   _crtValue = widget.initValue;
    //   widget.forceRefresh = false;
    // }
    // var cv = int.tryParse(_valueController.text);
    // if (cv != null && cv != _crtValue){
    //   _valueController.text = _crtValue.toString();
    // }
    _valueController.clear();
    _valueController.text = _crtValue.toString();

    // _valueController.selection = 0;
    // _crtValue = widget.initValue;
    var reg = widget.formatReg;
    if (reg == null){
      reg = RegExp(widget.unsigned?"[0-9]":"[0-9\+\-]");
    }
    if (widget.autoSize){
      var tf = AutoSizeTextField(
        focusNode: _focusNode,
          textAlign: TextAlign.center,
          extraWidth:4,
        decoration: InputDecoration(
            labelText: widget.hint,
            border: widget.noBorder?InputBorder.none:null,
            isDense: widget.isDense??true,
            contentPadding: widget.contentPadding??EdgeInsets.only(bottom: 4)
        ),
        style : widget.textStyle ,//TextStyle(color: Colors.green ),
        autofocus: false,
        onTap: (){
          widget.onTap?.call();
        },
        fullwidth:false,
        controller: _valueController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(reg),
        ],
        onChanged: (v){
          // print("comma : $v");
          var intv = int.tryParse(v);
          if (intv != null){
            _crtValue = intv;
            widget.onChanged?.call(intv);
          }
          // else{
          //   // print("comma v : $v");
          //   widget.onChanged?.call(v);
          // }
          // else{
          //   _crtValue = 0;
          //   widget.onChanged?.call(intv);
          //   setState(() {
          //
          //   });
          // }
        },
        onSubmitted: (v){
          // var intv = int.tryParse(v);
          // if (intv != null){
          //   _crtValue = intv;
          //   widget.onSubmitted?.call(intv);
          //   setState(() {
          //   });
          // }
          // else{
          //   // print("comma v : $v");
          //   widget.onSubmitted?.call(v);
          //   setState(() {
          //   });
          // }
        },
      );
      return tf;
    }

    var tf = TextField(
      enabled: widget.enabled,
      decoration: InputDecoration(
          labelText: widget.hint,
          border: widget.noBorder?InputBorder.none:null,
          isDense: widget.isDense??true,
          contentPadding: widget.contentPadding??EdgeInsets.only(bottom: 4)
      ),
      style : widget.textStyle ,//TextStyle(color: Colors.green ),
      autofocus: false,
      onTap: (){
        widget.onTap?.call();
      },
      controller: _valueController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(reg),
      ],
      onChanged: (v){
        var intv = int.tryParse(v);
        if (intv != null){
          _crtValue = intv;
          widget.onChanged?.call(intv);
        }
      },
      onSubmitted: (v){
        var intv = int.tryParse(v);
        if (intv != null){
          _crtValue = intv;
          widget.onSubmitted?.call(intv);
        }
        else{
          widget.onSubmitted?.call(v);
        }
      },
    );


    return tf;
  }
}
