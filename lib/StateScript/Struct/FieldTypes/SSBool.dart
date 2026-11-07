//@dart=2.11

import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/FSwitch.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/bool_editor.dart';

class SSBool extends SSFieldType{

  SSBool(){
    exportId = 103;
  }
  @override
  Widget getIcon(){
    return Icon(MaterialCommunityIcons.alpha_b_box_outline , color: Colors.green, size: SSDefines.fieldIconSize,);
  }
  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.alpha_b_box_outline , color: Colors.green,),
        SizedBox(width: 8,),
        Expanded(child:Text(getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }

  @override
  bool parseValue(value){
    bool v = false;
    if (value is bool ){
      v = value;
    }
    return v;
  }
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    bool v = parseValue(initValue);
    baseHeight = 22;
    // var be = SizedBox(width : 8, height :8 ,child: Checkbox(
    //   value: v,
    //   onChanged: (v){
    //     onSubmitted?.call(v);
    //   },
    // ));
    var be = FSwitch(
      width: 24,
      open: v??false,
        onChanged: (v){
          onSubmitted?.call(v);
        },
    );
    var dc =  const BoxDecoration(
        border : Border(
      bottom: BorderSide(width: 1.2,color: Colors.black),
    ));
    return EditorHolder()..widget = Container(
      decoration: dc,
      height: baseHeight,
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SSDefines.IBC( child:be),

            v?const Text("开 " , style: const TextStyle(color: Colors.green ,fontSize: 12),):
            const Text("关 " , style: const TextStyle(color: Colors.grey ,fontSize: 12),),
            be,
          ],
        )
    )..height = baseHeight;
  }
    @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
      bool v = parseValue(initValue);

      var be = BoolEditor(
        width: 32,
        height: 18,
        initValue: v,
        onSubmitted: (v){
          onSubmitted?.call(v);
        },
      );

      var dc = new BoxDecoration(
        // border : new Border.all(color: ColorUtils.StdColors[item.enumValue %ColorUtils.StdColors.length], width: 1.5),
        border :Border(
          bottom: BorderSide(width: 0.8, color: Colors.grey ),
        ),
        // color : color,//(0xFF1b1e26),
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
        // borderRadius: new BorderRadius.circular((6))
      );
      var fcon = Container(
        // height: 100,
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          decoration: dc,
          // child :con,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              be,
            ],
          )
      );
      var fw = Center(child:Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, 4), child:SizedBox(height: 26,child: fcon )));

      return EditorHolder()..widget = fw;//
    // bool v = parseValue(initValue);
    //
    // var be = BoolEditor(
    //   initValue: v,
    //   onSubmitted: (v){
    //
    //     onSubmitted?.call(v);
    //   },
    // );
    //
    // return EditorHolder()..widget = Container(
    //     width: levelInfo?.lineWidth,
    //     height : levelInfo?.lineHeight,
    //   child:Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       be,
    //     ],
    //   )
    // )..height =  SSDefines.nodeFieldRowHeight;
  }

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    bool v = parseValue(initValue);

    var be = BoolEditor(
      width: 32,
      height: 18,
      initValue: v,
      onSubmitted: (v){
        onSubmitted?.call(v);
      },
    );

    var dc = new BoxDecoration(
      // border : new Border.all(color: ColorUtils.StdColors[item.enumValue %ColorUtils.StdColors.length], width: 1.5),
      border :Border(
        bottom: BorderSide(width: 0.8, color: Colors.grey ),
      ),
      // color : color,//(0xFF1b1e26),
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
      // borderRadius: new BorderRadius.circular((6))
    );
    var fcon = Container(
      // height: 100,
      // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: dc,
      // child :con,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          be,
        ],
      )
    );
    var fw = Center(child:Padding( padding: EdgeInsets.fromLTRB(0, 0, 0, 4), child:SizedBox(height: 21,child: fcon )));

    return EditorHolder()..widget = fw;//
  }

  @override
  Widget getValueLabelWidget(initValue , {TextStyle style}){
    bool v = parseValue(initValue);


    var tf = FSwitch(
//      activeColor: Colors.green,
      open: v,
    );
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        tf,
      ],

    );
//    return BoolEditor(
//      initValue: v,
//    );
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    bool pv = parseValue(v);
    bw.writeUint8(pv?1:0 , exportFlag);
  }

  @override
  dynamic exportValue(v) {
    return parseValue(v);
  }

  @override
  getBytesCount(){
    return 1;
  }

  @override
  dynamic parseString(value){
    var res = value == "true";
    return res??false;
  }
  @override
  dynamic otParseValue(v) {
    return parseValue(v)?1:0;
  }
  @override
  dynamic otImportValue(v) {
    if (v is String){
      v =  int.tryParse(v)??0;
    }
    return v!= 0?true:false;
  }

  @override
  String syncSerialize(dynamic value){
    return value.toString();
  }
  @override
  dynamic syncDeserialize(String value){
    var res = value == "true";
    return res??false;
  }
}