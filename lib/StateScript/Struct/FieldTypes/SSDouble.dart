//@dart=2.11
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/float_editor.dart';

class SSDouble extends SSFieldType{
  SSDouble(){
    exportId = 107;
  }

  @override
  Widget getIcon(){
    return Icon(MaterialCommunityIcons.alpha_d_box_outline , color: Colors.brown, size: SSDefines.fieldIconSize,);
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.alpha_d_box_outline , color: Colors.deepOrangeAccent,),
        SizedBox(width: 4,),
        Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 12), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }
  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    double v = 0.0;
    if (initValue is double ){
      v = initValue;
    }
    return EditorHolder()..widget = Container(
        height: baseHeight,
        child: Row(
          children: [
            Expanded(
                child:FloatEditor(
                  // fontSize: 14,
                  style: const TextStyle(fontSize: 12, color: Colors.orangeAccent),
                  // fontSize: levelInfo?.fontSize,
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
                )
            )
          ],
        )
    )..height = baseHeight;
  }
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    double v = 0.0;
    if (initValue is double ){
      v = initValue;
    }
    return EditorHolder()..widget = SizedBox(
        width: levelInfo?.lineWidth,
        height : levelInfo?.lineHeight,
        child: FloatEditor(
          initValue: v,
          onChanged: (v){
            onChanged?.call(v);
          },
          onSubmitted: (v){
            onSubmitted?.call(v);
          },
        )
    )..height = SSDefines.nodeFieldRowHeight;
  }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    double v = 0.0;
    if (initValue is double ){
      v = initValue;
    }
    return EditorHolder()..widget = Container(
        child: Row(
          children: [
            Expanded(
                child:FloatEditor(
                  noUnderLine: true,

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
        )
    )..height = SSDefines.nodeFieldRowHeight;
  }
  @override
  double parseValue(value){
    double v = 0;
    if (value is double ){
      v = value;
    }
    else if (value is int ){
      v = value.toDouble();
    }

    return v;
  }
  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    double pv = parseValue(v);
    if (StateScriptProject.instance.exportFixedPoint)
    {
      bw.writeInt64((pv * 65536).toInt() , exportFlag);
      return;
    }
    bw.writeFloat64(pv , exportFlag);
  }

  @override
  dynamic exportValue(v) {
    return parseValue(v);
  }

  @override
  dynamic parseString(value){
    var res = double.tryParse(value);
    return res??0.0;
  }

  @override
  String syncSerialize(dynamic value){
    return value.toString();
  }
  @override
  dynamic syncDeserialize(String value){
    var res = double.tryParse(value);
    print("double des: $res");
    return res??0.0;
  }
}