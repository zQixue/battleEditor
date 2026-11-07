//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battlepus/common/FuncTypeDef.dart';

class FloatEditor extends StatefulWidget {
  final double initValue;
  final double fontSize;
  final bool noUnderLine;
  final bool forceBuild;
  final dynamic onTap;
  final FunctionFloatCallback onChanged;
  final FunctionFloatCallback onSubmitted;
  final TextStyle style;
  final EdgeInsetsGeometry contentPadding ;
  bool forceRefresh;
  FloatEditor({Key key , this.contentPadding, this.onTap , this.style, this.initValue = 0 , this.onChanged , this.onSubmitted , this.fontSize , this.noUnderLine = false,this.forceBuild = true}) : super(key: key){
    forceRefresh = true;
  }

  @override
  _FloatEditorState createState() =>
      _FloatEditorState(
      );
}

class _FloatEditorState extends State<FloatEditor> {
  TextEditingController _valueController;
  double _crtValue ;
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _valueController?.dispose();
    _focusNode.removeListener(_focusChange);
  }
  @override
  void initState() {
    // TODO: implement initState
    _valueController = TextEditingController();
    _valueController.text = widget.initValue.toString();
    _crtValue= widget.initValue;
    _focusNode.addListener(_focusChange);
    super.initState();
  }

  //失去Focus时从新校正显示
  void _focusChange()
  {
    if(!_focusNode.hasFocus){
        var showText = "";
        if(_valueController.text.isEmpty){
          showText = "0.0";
        }
        else
        {
          if(_valueController.text != _crtValue.toString()){
            showText = _crtValue.toString();
          }
        }
         if(showText != ""){
          setState(() {
            _valueController.text = showText; 
            _valueController.selection = TextSelection.fromPosition(TextPosition(offset: _valueController.text.length)); 

          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.forceRefresh){
      _crtValue = widget.initValue;
      widget.forceRefresh = false;
    }

    var cv = double.tryParse(_valueController.text);
    if (cv != null && cv != _crtValue){
      _valueController.text = _crtValue.toString();
    }

    var tf = TextField(
      decoration: InputDecoration(
       border: widget.noUnderLine?InputBorder.none:null,
         // labelText: widget.hint,

        isDense: true,
          contentPadding: widget.contentPadding??EdgeInsets.only(bottom: 4)
      ),
      style: widget.style??TextStyle(fontSize: widget.fontSize),
      autofocus: false,
      onTap: (){
        widget.onTap?.call();
      },
      maxLines: 1,
      minLines: 1,
      focusNode: _focusNode,
      // enableInteractiveSelection:false,
      controller: _valueController,
//      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9\.\+\-]"))
//        WhitelistingTextInputFormatter(RegExp(r'[-+]?[0-9]*\.?[0-9]+'))
      ], // Only numbers can be entered
      onChanged: (v){
       var floatValue =  double.tryParse(v);
        if(floatValue == null && v != "-"){
          setState(() {
            if(v.isEmpty){  
              _crtValue = 0;
              widget.onChanged?.call(floatValue);
            }
            else{
              _valueController.text = _crtValue.toString();
              _valueController.selection = TextSelection.fromPosition(TextPosition(offset: _valueController.text.length));
            }
 
          });
        }
        else{
           if(v != "-"){
              _crtValue = floatValue;
              widget.onChanged?.call(floatValue);
           }
        }
      },
      onSubmitted: (v){
      var oriValue = _crtValue;
        var floatValue =  double.tryParse(v);
        if(floatValue == null)
          floatValue = oriValue;

       // var floatValue = double.tryParse(v)??0.0;
        if (floatValue != null){
          _crtValue = floatValue;
          widget.onSubmitted?.call(floatValue);
        }
      },
    );
    return tf;
  }

}