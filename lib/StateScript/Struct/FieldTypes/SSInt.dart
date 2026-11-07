//@dart=2.11

import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/int_editor.dart';
 
class SSInt extends SSFieldType{
  SSInt(){
    exportId = 101;
  }

  @override
  Widget getIcon(){
    return Icon(MaterialCommunityIcons.alpha_i_box_outline , color: Colors.indigo, size: SSDefines.fieldIconSize,);
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon( MaterialCommunityIcons.alpha_i_box_outline , color: Colors.blue),
        SizedBox(width: 4,),
        Expanded (child : Text(getTypeShowString(), style: ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    var v = 0;
    if (initValue is int ){
      v = initValue;
    }
    return EditorHolder()..widget = IntEditor(
      // fontSize: 14,
      fontSize: levelInfo?.fontSize,
      textStyle: const TextStyle(fontSize: 12, color: Colors.white),
      initValue: v,
      onTap: (){
        levelInfo.onFocus?.call();
      },
      onChanged: (v){
        onChanged?.call(v);
      },
      onSubmitted: (v){
        onSubmitted?.call(v);
      },
    )..height = baseHeight;
  }


  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    var v = 0;
    if (initValue is int ){
      v = initValue;
    }
    return EditorHolder()..widget = Container(
      width: levelInfo?.lineWidth,
      height : levelInfo?.lineHeight,
        child: Row(
          children: [
            Expanded(child : IntEditor(
              // contentPadding:EdgeInsets.only(bottom: 0),
              initValue: v,
              onChanged: (v){
                onChanged?.call(v);
              },
              onSubmitted: (v){
                onSubmitted?.call(v);
              },
            ))
          ],
        )
    );
//    return EditorHolder()..widget = Container(
//      width: levelInfo?.width,
//      height : SSDefines.nodeFieldRowHeight,
//      child: Row(
//        children: [
//          Expanded(child : IntEditor(
//            initValue: v,
//            onChanged: (v){
//              onChanged?.call(v);
//            },
//            onSubmitted: (v){
//              onSubmitted?.call(v);
//            },
//          ))
//        ],
//      )
//
//    ) ..height = SSDefines.nodeFieldRowHeight;
  }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    var v = 0;
    if (initValue is int ){
      v = initValue;
    }
    return EditorHolder()..widget = Row(
      children: [
        Expanded(child : IntEditor(
          // noBorder: true,
          contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
          textStyle: TextStyle(fontSize: 14),
          initValue: v,
          onChanged: (v){
            onChanged?.call(v);
          },
          onSubmitted: (v){
            onSubmitted?.call(v);
          },
        ))
      ],
    );
    // return EditorHolder()..widget = Container(
    //     // width: levelInfo?.lineWidth,
    //     // height : levelInfo?.lineHeight,
    //     child: Row(
    //       children: [
    //         Expanded(child : IntEditor(
    //           // noBorder: true,
    //           contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
    //           textStyle: TextStyle(fontSize: 14),
    //           initValue: v,
    //           onChanged: (v){
    //             onChanged?.call(v);
    //           },
    //           onSubmitted: (v){
    //             onSubmitted?.call(v);
    //           },
    //         ))
    //       ],
    //     )
    // );
  }

  @override
  int parseValue(value){
    int v = 0;
    if (value is int ){
      v = value;
    }

    if (value is String ){
      v = parseString(value);
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

  @override
  dynamic parseString(value){
    var res = int.tryParse(value);
    return res??0;
  }

  @override
  String syncSerialize(dynamic value){
    return value.toString();
  }
  @override
  dynamic syncDeserialize(String value){
    var res = int.tryParse(value);
    return res??0;
  }
}