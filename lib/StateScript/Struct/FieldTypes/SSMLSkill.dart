//@dart=2.11


import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldTypes/SSString.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/protos/transition.pb.dart';
class SSMLSkill extends SSString{

  @override
  Widget getTypeShowWidget({SSFieldType fieldType  , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(MaterialCommunityIcons.fire , color: Colors.greenAccent,),
        SizedBox(width: 8,),
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

    return EditorHolder()..widget = Container(
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded( flex: 6, child:TextEditor(
              textStyle: const TextStyle(fontSize: 12 , color: Colors.white),
              initValue: v,
              onChanged: (val){
                onSubmitted?.call(val);
              },
            )),
            // res,
            // SizedBox(width: scriptInfo != null?8:0,),
            SizedBox(width: 2,),
            if (!DartCommon.isEmpty(v)) ThemeCenter.iconBtn(MaterialCommunityIcons.link_box_outline,
              width: 16, height:16,
              onPressed: (){
                OpenMLScript po = OpenMLScript();
                po.scriptName = v;
                Transport.instance.sendUdpData2MLSkill(OPackType.O2SO_OpenMLScript, po);
                BotToast.showText(text: "命令已发送",contentColor: Colors.greenAccent);
              },
              tooltip: "打开",
            ),
            SizedBox(width: 2,),
          ],
        )
    ) ..height = baseHeight;
  }
    @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted,{Widget showInfo , bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context}){
    return EditorHolder()..widget = Container()..height = SSDefines.nodeFieldRowHeight;
  }
  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    String v = "";
    if (initValue is String ){
      v = initValue;
    }
    return EditorHolder()..widget = Container(
        child:Row(
          children: [
//        Expanded( flex: 6, child:Center(child:getValueLabelWidget(initValue))),
            Expanded( flex: 6, child:TextEditor(
              initValue: v,
              onChanged: (val){
                onSubmitted?.call(val);
              },
            )),
            // res,
            // SizedBox(width: scriptInfo != null?8:0,),
            SizedBox(width: 8,),
            if (!DartCommon.isEmpty(v) && !gci.isObjectTableMode) ThemeCenter.iconBtn(MaterialCommunityIcons.link_box_outline,
              width: 24, height:24,
              onPressed: (){
                OpenMLScript po = OpenMLScript();
                po.scriptName = v;
                Transport.instance.sendUdpData2MLSkill(OPackType.O2SO_OpenMLScript, po);
                BotToast.showText(text: "命令已发送",contentColor: Colors.greenAccent);
              },
              tooltip: "打开",
            ),
          ],
        )
    ) ..height = SSDefines.nodeFieldRowHeight;
  }

  @override
  Widget getDefaultEditWidget(bool bIsEdit , initValue , onChanged , onSubmitted , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    // return Text(parseValue(initValue).toString());
    // var edt = bIsEdit?getEditWidget(
    //     initValue,
    //         (v){
    //       onChanged?.call(v);
    //     }, (v){
    //   onSubmitted?.call(v);
    // },
    //     context: context
    // ).widget:getValueLabelWidget(initValue);

    return Text("默认空");
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    bw.writeString(str??"", "scene name");
  }

  @override
  String getFilterString(v) {
    String str = parseValue(v);
    return str;
  }

  @override
  dynamic exportValue(v) {
    String str = parseValue(v);
    return str;
  }

  @override
  dynamic parseFinalValue(value){
    String str = parseValue(value);
    return str;
  }

  @override
  Widget getValueLabelWidget(initValue, {TextStyle style}){
    var str = parseValue(initValue);
    return Text(str, style: style);
  }

  @override
  dynamic getExportDefault(dynamic defaultValue){
    return "";
  }

  @override
  String getExportType(){
    return "String";
  }
}