//@dart=2.11


import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/int_editor.dart';
import 'package:battlepus/common/int_slider.dart';
class SSIntRange extends SSFieldType {

  SSIntRange() {
    innerTypeGuid0 = "0";
    innerTypeGuid1 = "32";
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}) {
    var a = int.tryParse(innerTypeGuid0)??0;
    var b = int.tryParse(innerTypeGuid1)??32;

    if (fieldType == null){

      return Row(
        children: [
          Icon(Icons.attachment_outlined , color: Colors.cyan,),
          SizedBox(width: 8,),
          Expanded(child:Text("($a - $b)" ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
          // Expanded(child:Text("" , overflow: TextOverflow.clip,maxLines: 1,)),
        ],
      );
    }

    // var path = fieldType.innerTypeGuid0??"";

    if (onChange == null){
      return Row(
        children: [
          Icon(Icons.attachment_outlined , color: Colors.cyan,),
          SizedBox(width: 8,),
          Expanded(child:Text("($a - $b)" ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
          // Expanded(child:Text("" , overflow: TextOverflow.clip,maxLines: 1,)),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.attachment_outlined , color: Colors.cyan,),
        Expanded(
          child:  IntEditor(
            initValue: a,
            onChanged: (v){
              var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid , "$v" , fieldType.innerTypeGuid1);
              onChange?.call(newFT.guid);
            },
          ),
        ),
        Icon(Icons.arrow_right_alt , color: Colors.white,),
        Expanded(
          child:  IntEditor(
            initValue: b,
            onChanged: (v){
              var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid , fieldType.innerTypeGuid1 , "$v");
              onChange?.call(newFT.guid);
            },
          ),
        ),
        // CommonUtil.getFilesOfDirectory(path, namePattern)
      ],
    );

  }
  @override
  EditorHolder getEditWidget(initValue , onChanged , onSubmitted , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    return EditorHolder()..widget = const Text("need impl2") .. height = SSDefines.nodeFieldRowHeight;
  }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    // return EditorHolder()..widget = Container() ..height = SSDefines.nodeFieldRowHeight;
    int val = 0;
    if (initValue is int ){
      val = initValue;
    }

    var a = int.tryParse(innerTypeGuid0)??0;
    var b = int.tryParse(innerTypeGuid1)??32;

    if (val<a){
      val = a;
    }
    if (val>b){
      val = b;
    }
    // print("slider $a $b $val");
    var slider = IntSlider(
      key: ValueKey("${gci.object?.guid??""}_${gci.fieldInfo?.guid??""}"),
      min: a,
      max:b,
      value: val,
      onChanged: (v){
        onChanged?.call(v);
      },
    );

    return EditorHolder()..widget = Center(child: slider);
  }
  @override
  int parseValue(value){
    int v = 0;
    if (value is int ){
      v = value;
    }

    var a = int.tryParse(innerTypeGuid0)??0;
    var b = int.tryParse(innerTypeGuid1)??32;

    if (v<a){
      v = a;
    }
    if (v>b){
      v = b;
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

  @override
  clone(){
    var t = SSIntRange();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }
}