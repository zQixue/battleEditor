//@dart=2.11

import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
// import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class SSColor extends SSFieldType{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(Ionicons.md_color_palette , color: Colors.indigo,),
        SizedBox(width: 8,),
        Expanded (child : Text(getTypeShowString() , style : ThemeCenter.mainTextStyle(step:9,fontSize: 13),)),
      ],
    );
  }
  @override
  Widget getDefaultEditWidget(bool bIsEdit , initValue , onChanged , onSubmitted , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    var dc = new BoxDecoration(
      color: CommonUtil.alphaColor(Colors.grey , 30),
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    );
    return  Container(
      padding: EdgeInsets.all(4),
      height: SSDefines.nodeFieldRowHeight,
      child: Container(
        decoration: dc,
        child:Row(
          children: [
            Expanded(child: Container(color : Color(initValue??0xFFFFFFFF)),),
          ],
        ),
      ),
    ) ;

  }
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    var v = 0xFFFFFFFF;
    if (initValue is int ){
      v = initValue;
    }
    var dc = new BoxDecoration(
      // color: CommonUtil.alphaColor(Colors.grey , 30),

        border : Border(
          bottom: BorderSide(width: 1.2,color: Colors.black),
        )
    );
    return EditorHolder()..widget = Container(
      height : baseHeight,
      decoration: dc,
      padding: EdgeInsets.fromLTRB(2,2,2,2),
//      height: SSDefines.nodeFieldRowHeight,
      child: Container(

        child:Row(
          children: [
            Expanded(child: Container(height : 10, width: 20, color : Color(v))),
            SSDefines.IBC(child:  IconButton(
              icon : Icon(MaterialCommunityIcons.palette),
              iconSize: SSDefines.iconButtonSize,
              color: Colors.white, tooltip:"修改颜色",
              padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
              onPressed: (){
                showDialog(
                  context: context ,
                  builder:(context)=> AlertDialog(
                    title: const Text('选择颜色!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: Color(v),
                        onColorChanged: (clr){
                          v = clr.value;

                          //
                        },
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('确定'),
                        onPressed: () {

                          onSubmitted?.call(v);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
    )..height = baseHeight;
  }
    @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo,BuildContext  context}){
    var v = 0xFFFFFFFF;
    if (initValue is int ){
      v = initValue;
    }
    var dc = new BoxDecoration(
      color: CommonUtil.alphaColor(Colors.grey , 30),
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    );
    return EditorHolder()..widget = Container(
      width: levelInfo?.lineWidth,
      height : levelInfo?.lineHeight,
      padding: EdgeInsets.fromLTRB(0,4,1,4),
//      height: SSDefines.nodeFieldRowHeight,
      child: Container(
        decoration: dc,
        child:Row(
          children: [
            Expanded(child: Container(color : Color(v)),),
            IconButton(icon: Icon(Ionicons.md_color_palette),iconSize: 20, color: Colors.black, tooltip:"修改颜色",
              padding: EdgeInsets.all(0),
              onPressed: (){
                showDialog(
                  context: context ,
                  builder:(context)=> AlertDialog(
                    title: const Text('选择颜色!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: Color(v),
                        onColorChanged: (clr){
                          v = clr.value;

                          //
                        },
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('确定'),
                        onPressed: () {

                          onSubmitted?.call(v);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    )..height = SSDefines.nodeFieldRowHeight ;
    // return EditorHolder()..widget = IntEditor(
    //   initValue: v,
    //   onChanged: (v){
    //     onChanged?.call(v);
    //   },
    //   onSubmitted: (v){
    //     onSubmitted?.call(v);
    //   },
    // )..height = SSDefines.nodeFieldRowHeight;
  }

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    var v = 0xFFFFFFFF;
    if (initValue is int ){
      v = initValue;
    }
    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColor(Colors.grey , 30),
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    // );
    return EditorHolder()..widget = Container(
      padding: EdgeInsets.fromLTRB(0,4,1,4),
//      height: SSDefines.nodeFieldRowHeight,
      child: Container(
        // decoration: dc,
        child:Row(
          children: [
            Expanded(child: Container(color : Color(v)),),
            IconButton(icon: Icon(Ionicons.md_color_palette),iconSize: 20, tooltip:"修改颜色",
              padding: EdgeInsets.all(0),
              onPressed: (){
                showDialog(
                  context: context ,
                  builder :(context)=> AlertDialog(
                    title: const Text('选择颜色!'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: Color(v),
                        onColorChanged: (clr){
                          v = clr.value;

                          //
                        },
                        showLabel: true,
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('确定'),
                        onPressed: () {

                          onSubmitted?.call(v);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

  }

  @override
  int parseValue(value){
    int v = 0xFFFFFFFF;
    if (value is int ){
      v = value;
    }
    return v;
  }
  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    int pv = parseValue(v);
    bw.writeInt32(pv , exportFlag);
  }

  @override
  dynamic exportValue(v) {
    return parseValue(v);
  }
}