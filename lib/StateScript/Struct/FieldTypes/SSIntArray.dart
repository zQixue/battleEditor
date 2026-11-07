//@dart=2.11

import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/int_array_editor.dart';

class SSIntArray extends SSFieldType{
  SSIntArray(){
    // exportId = 101;
  }

  @override
  Widget getIcon(){
    return Icon(MaterialCommunityIcons.code_array , color: Colors.indigo, size: SSDefines.fieldIconSize,);
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon( MaterialCommunityIcons.code_array , color: Colors.blue),
        SizedBox(width: 4,),
        Expanded (child : Text(getTypeShowString(), style: ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    // var v = 0;
    // if (initValue is int ){
    //   v = initValue;
    // }
    // return EditorHolder()..widget = Container(
    //     height: baseHeight,
    //     child: Row(
    //       children: [
    //         Expanded(child : IntEditor(
    //           // fontSize: 14,
    //           fontSize: levelInfo?.fontSize,
    //           initValue: v,
    //           onTap: (){
    //             levelInfo.onFocus?.call();
    //           },
    //           onChanged: (v){
    //             onChanged?.call(v);
    //           },
    //           onSubmitted: (v){
    //             onSubmitted?.call(v);
    //           },
    //         ))
    //       ],
    //     )
    // )..height = baseHeight;
    throw Exception("NIMPL");
  }


  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    // var v = 0;
    // if (initValue is int ){
    //   v = initValue;
    // }
    // return EditorHolder()..widget = Container(
    //     width: levelInfo?.lineWidth,
    //     height : levelInfo?.lineHeight,
    //     child: Row(
    //       children: [
    //         Expanded(child : IntEditor(
    //           // contentPadding:EdgeInsets.only(bottom: 0),
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
    return EditorHolder()..widget = Container();
    // throw Exception("NIMPL");
  }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    List<int> vals = parseValue(initValue);

    // List<Widget> ws = List<Widget>();
    // for(int i = 0 ; i< vals.length ; ++i){
    //   var edt = IntEditorEx(
    //     autoSize: true,
    //     // noBorder: true,
    //     contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
    //     textStyle: TextStyle(fontSize: 14),
    //     initValue: vals[i],
    //     onChanged: (v){
    //       vals[i] = v;
    //       onChanged?.call(vals);
    //     },
    //     onSubmitted: (v){
    //       vals[i] = v;
    //       onSubmitted?.call(vals);
    //     },
    //   );
    //
    //   ws.add(edt);
    //   if (i < vals.length -1){
    //     ws.add(Container(
    //       alignment: Alignment.bottomCenter,
    //       child: const Icon(MaterialCommunityIcons.comma , size: 8, color: Colors.green,),
    //     ));
    //   }
    // }
    return EditorHolder()..widget = IntArrayEditor (
      // crossAxisAlignment: CrossAxisAlignment.end,
      values: vals,
      onChanged: (v){
        onChanged?.call(v);
      },
      onSubmitted: (v){
        onSubmitted?.call(v);
      },
    );
  }

  @override
  List<int> parseValue(inValue){
    List<int> v = [];
    dynamic value= inValue;
    if (value is String){
      value = (value as String).split(";");
    }
    if (value is List){
      for(var i=0;i< value.length ;++i){
//      innerType0.export(bw, t);
        v.add(DartCommon.parseInt(value[i]));
      }
    }
    if (value is Map){
      value.forEach((key, val1) {
        v.add(DartCommon.parseInt(val1));
      });

    }
    return v;
  }
  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    List<int> pv = parseValue(v);
    // List<dynamic> lst = parseValue(v);
    bw.writeUint32(pv.length,"array length");
    int iCount = 0 ;
    for(var t in pv){
      bw.writeInt32(t,"item ${iCount++}");
    }
  }

  @override
  dynamic exportValue(v) {
    return parseValue(v);
  }

  @override
  dynamic parseString(value){
    var itms = (value as String).split(";");
    var res = parseValue(itms);
    return res;
  }

  @override
  dynamic otParseValue(v) {
    var lst = parseValue(v);
    StringBuffer sb = StringBuffer();
    for(int i = 0 ;i< lst.length ; ++i){
      sb.write(lst[i]);
      if (i< lst.length-1){
        sb.write(";");
      }
    }
    // lst.forEach((element) {
    //   sb.write(element);
    // });
    return sb.toString();
  }
  // @override
  // dynamic otImportValue(v) {
  //   if (v is String){
  //     v =  int.tryParse(v)??0;
  //   }
  //   return v!= 0?true:false;
  // }

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