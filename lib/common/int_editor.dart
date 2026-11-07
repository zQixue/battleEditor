//@dart=2.11
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battlepus/common/FuncTypeDef.dart';

class IntEditor extends StatefulWidget {
  final int initValue;
  final String hint;
  final bool forceBuild;
  final double fontSize;
  final FunctionIntCallback onChanged;
  final FunctionIntCallback onSubmitted;
  final bool enabled ;
  final bool noBorder ;
  final bool unsigned;
  final bool isDense;
  final dynamic onTap;
  final TextStyle textStyle;
  final bool autoSize ;
  final EdgeInsetsGeometry contentPadding ;
  bool forceRefresh;


  IntEditor({Key key , this.autoSize = false,this.isDense,this.textStyle,this.onTap,this.unsigned = false, this.contentPadding , this.hint , this.noBorder = false , this.initValue = 0 , this
      .onChanged , this
      .onSubmitted
    ,this
      .enabled = true ,
  this.forceBuild = false , this.fontSize}) : super(key: key){
    forceRefresh = true;
  }

  @override
  _IntEditorState createState() => _IntEditorState();
}

class _IntEditorState extends State<IntEditor> {
  TextEditingController _valueController;
  int _crtValue ;

  @override
  void dispose() {
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
  }
  @override
  Widget build(BuildContext context) {
    // if (widget.forceBuild) _valueController.text = widget.initValue.toString();
    if (widget.forceRefresh){
      _crtValue = widget.initValue;
      widget.forceRefresh = false;
    }
    var cv = int.tryParse(_valueController.text);
    if (cv != null && cv != _crtValue){
      _valueController.text = _crtValue.toString();
    }

    if (widget.autoSize){
      var tf = AutoSizeTextField(
        // enabled: widget.enabled,
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
          FilteringTextInputFormatter.allow(RegExp(widget.unsigned?"[0-9]":"[0-9\+\-]")),
        ],
        onChanged: (v){
          var intv = int.tryParse(v)??0;
          if (intv != null){
            _crtValue = intv;
            widget.onChanged?.call(intv);
            setState(() {

            });
          }
        },
        onSubmitted: (v){
          var intv = int.tryParse(v)??0;
          if (intv != null){
            _crtValue = intv;
            widget.onSubmitted?.call(intv);
            setState(() {

            });
          }
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
        FilteringTextInputFormatter.allow(RegExp(widget.unsigned?"[0-9]":"[0-9\+\-]")),
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
      },
    );


    return tf;
  }
}