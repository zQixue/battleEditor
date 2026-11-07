//@dart=2.11

import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';

class SSString extends SSFieldType{
  SSString(){
    exportId = 120;
  }
  @override
  Widget getIcon(){
    return Icon(MaterialCommunityIcons.alpha_s_box_outline , color: Colors.indigoAccent, size: SSDefines.fieldIconSize,);
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType  , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.alpha_s_box_outline , color: Colors.indigoAccent,),
        SizedBox(width: 4,),
//        Container(child:Text(getTypeShowString(),maxLines: 1,overflow: TextOverflow.clip)),
        Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    var lines = levelInfo.lineCount ;
    return EditorHolder()..widget = TextEditor(
      textStyle: TextStyle(color: Colors.lightBlue , fontSize: 12),
      maxLines: lines,
      // fontSize: levelInfo?.fontSize,
      initValue: v,
      onTap: (){
        levelInfo.onFocus?.call();
      },
      onChanged: (v){
        // if (v.length>=1 && v.codeUnitAt(0) == 8291){
        //   v = v.substring(1);
        //   BotToast.showText(text: "移除了特殊字符 8291" , contentColor: Colors.redAccent);
        // }
        onChanged?.call(v);
      },
      onSubmitted: (v){
        // if (v.length>=1 && v.codeUnitAt(0) == 8291){
        //   v = v.substring(1);
        // }
        onSubmitted?.call(v);
      },
    )..height = baseHeight*lines;
  }
    @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted,{Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    return EditorHolder()..widget = Container(
        width: levelInfo?.lineWidth,
        height : levelInfo?.lineHeight,
      child: Row(
        children: [
          Expanded(
            child: TextEditor(
              textStyle: TextStyle(fontSize: levelInfo?.fontSize),
              initValue: v,
              onChanged: (v){
                onChanged?.call(v);
              },
              onSubmitted: (v){
                onSubmitted?.call(v);
              },
            )
          )
        ],
      ),
    )..height = SSDefines.nodeFieldRowHeight;
  }


  // EdgeInsets getCanvasEditPadding(){
  //   return EdgeInsets.fromLTRB(0,0,0,0);
  // }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    return EditorHolder()..widget = Row(
      children: [
        Expanded(
            child: TextEditor(
              contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
              // noUnderline: true,
              textStyle: TextStyle(fontSize: 14),
              initValue: v,
              onChanged: (v){
                onChanged?.call(v);
              },
              onSubmitted: (v){
                onSubmitted?.call(v);
              },
            )
        )
      ],
    );
    // return EditorHolder()..widget = Container(
    //   child: Row(
    //     children: [
    //       Expanded(
    //           child: TextEditor(
    //             contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
    //             // noUnderline: true,
    //             textStyle: TextStyle(fontSize: 14),
    //             initValue: v,
    //             onChanged: (v){
    //               onChanged?.call(v);
    //             },
    //             onSubmitted: (v){
    //               onSubmitted?.call(v);
    //             },
    //           )
    //       )
    //     ],
    //   ),
    // );
  }

  @override
  String parseValue(value){
    String v = "";
    if (value is String ){
      v = value;
    }
    return v;
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    if (str.length>=1 && str.codeUnitAt(0) == 8291){
      str = str.substring(1);
    }

    bw.writeString(str,exportFlag);
  }

  @override
  dynamic exportValue(v) {
    return parseValue(v);
  }

  @override
  String syncSerialize(dynamic value){
    return value.toString();
  }
  @override
  dynamic syncDeserialize(String value){
    return value;
  }

//  static void writeString(ByteDataWriter bw, String str){
//    List<int> bytes = utf8.encode(str);
//    bw.writeInt32(bytes.length);
//    bw.write(bytes);
//  }
}