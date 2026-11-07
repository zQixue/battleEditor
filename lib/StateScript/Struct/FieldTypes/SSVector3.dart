//@dart=2.11
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/float_editor.dart';
import 'package:battlepus/common/ThemeCenter.dart';


class SSVector3 extends SSFieldType{

  SSVector3(){
    exportId = 105;
  }
  @override
  Widget getIcon(){
    return Icon(Ionicons.md_cube , color: Colors.indigoAccent, size: SSDefines.fieldIconSize,);
  }

  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}){
    return Row(
      children: [
        Icon(Ionicons.md_cube , color: Colors.indigoAccent,),
        SizedBox(width: 8,),
        Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
      ],
    );
  }

  @override
  EditorHolder getThinEditWidget(initValue , onChanged , onSubmitted , double baseHeight , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ) {
    List<double> lst = parseValue(initValue);


    double xySize = 16;
    var x = Container(
      width: xySize,
      height: xySize,
      // color: //Colors.red,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.red , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(
        child: const Text("X", style: const TextStyle(color: Colors.grey, fontSize: 10 )),
      ),
    );
    var xpan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: x,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[0];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[0] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );
    var xv = FloatEditor(
      // noUnderLine: true,
      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
      style: const TextStyle(fontSize: 12 , color: Colors.deepOrange),
      initValue : lst[0] ,
      onChanged : (v){
        lst[0] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[0] = v;
        onSubmitted?.call(lst);
      },
    );
    var y = Container(

      width: xySize,
      height: xySize,
      // color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.green , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(

        child: const Text("Y",style: const TextStyle(color: Colors.grey, fontSize: 10 )),
      ),
    );

    var ypan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: y,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[1];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[1] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );

    var yv = FloatEditor(
      // noUnderLine: true,
      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
      style: const TextStyle(fontSize: 12 , color: Colors.deepOrange),
      initValue : lst[1] ,
      onChanged : (v){
        lst[1] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[1] = v;
        onSubmitted?.call(lst);
      },
    );

    var z = Container(

      width: xySize,
      height: xySize,
      // color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.blue , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(

        child: const Text("Z",style: const TextStyle(color: Colors.grey, fontSize: 10 )),
      ),
    );

    var zpan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: z,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[2];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[2] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );
    var zv = FloatEditor(
      // noUnderLine: true,
      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
      style: const TextStyle(fontSize: 12 , color: Colors.deepOrange),
      initValue : lst[2] ,
      onChanged : (v){
        lst[2] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[2] = v;
        onSubmitted?.call(lst);
      },
    );

    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColor(Colors.grey , 30),
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],
    // );
    return EditorHolder()..widget = Container(
      // decoration: dc,
      child:Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            // Expanded(flex : 10 , child: xpan,),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 2) , child:xpan),
            // Expanded(flex : 2 , child: const SizedBox(width: 1,),),
            const SizedBox(width:4),
            Expanded(flex : 50 , child: xv,),
          ],)),
          // line,
          const SizedBox(width: 4,) ,
          Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            // Expanded(flex : 10 , child: y,),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 2) , child:ypan),
            // Expanded(flex : 2 , child: const SizedBox(width: 1,),),
            SizedBox(width:4 , height: baseHeight,),
            Expanded(flex : 50 , child: yv,),
          ],)),
          // line,
          const SizedBox(width: 4,) ,
          Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            // Expanded(flex : 10 , child: z,),
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 2) , child:zpan),
            // Expanded(flex : 2 , child: const SizedBox(width: 1,),),
            SizedBox(width:4 , height: baseHeight,),
            Expanded(flex : 50 , child: zv,),
          ],)),

        ],
      ),
    )..height = baseHeight * 1;

    //
    // // List<Widget> ws = new List<Widget>();
    // const TextStyle ts = const TextStyle(fontSize: 12);
    // var x = Box(
    //   color: CommonUtil.alphaColor(Colors.red , 80),//Colors.red,
    //   child: Center(
    //
    //     child: const Text("X",style: ts,),
    //   ),
    // );
    // var xv = FloatEditor(
    //   noUnderLine: true,
    //   fontSize: levelInfo?.fontSize,
    //   initValue : lst[0] ,
    //   onTap: (){
    //     levelInfo.onFocus?.call();
    //   },
    //   onChanged : (v){
    //     lst[0] = v;
    //     onChanged?.call(lst);
    //   },
    //   onSubmitted: (v){
    //     lst[0] = v;
    //     onSubmitted?.call(lst);
    //   },
    // );
    // var y = Box(
    //   color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
    //   child: Center(
    //
    //     child: const Text("Y" ,style: ts,),
    //   ),
    // );
    // var yv = FloatEditor(
    //   noUnderLine: true,
    //   fontSize: levelInfo?.fontSize,
    //   initValue : lst[1] ,
    //   onTap: (){
    //     levelInfo.onFocus?.call();
    //   },
    //   onChanged : (v){
    //     lst[1] = v;
    //     onChanged?.call(lst);
    //   },
    //   onSubmitted: (v){
    //     lst[1] = v;
    //     onSubmitted?.call(lst);
    //   },
    // );
    // var z = Box(
    //   color:  CommonUtil.alphaColor(Colors.indigo , 80),//Colors.indigo,
    //   child: Center(
    //
    //     child: const Text("Z",style: ts,),
    //   ),
    // );
    // var zv = FloatEditor(
    //   noUnderLine: true,
    //   fontSize: levelInfo?.fontSize,
    //   initValue : lst[2],
    //   onTap: (){
    //     levelInfo.onFocus?.call();
    //   },
    //   onChanged : (v){
    //     lst[2] = v;
    //     onChanged?.call(lst);
    //   },
    //   onSubmitted: (v){
    //     lst[2] = v;
    //     onSubmitted?.call(lst);
    //   },
    // );
    //
    // // for(int i = 0 ; i < lst.length ; ++i){
    // //   var crt = lst[i];
    // //   crt = innerType0.parseValue(crt);
    // //   var w = innerType0.getEditWidget(crt,
    // //           (v){
    // //         lst[i] = v;
    // //         onChanged?.call(lst);
    // //       },
    // //           (v){
    // //         lst[i] = v;
    // //         onSubmitted?.call(lst);
    // //       }
    // //   );
    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColor(Colors.grey , 30),
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 0.0) , BoxShadow(color: Colors.white)],
    // );
    // var line = Container(height:1 , color: CommonUtil.scaleColor(Colors.grey, 0.4),);
    // return EditorHolder()..widget = Container(
    //   decoration: dc,
    //   child:Column(
    //     // mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
    //         Expanded(flex : 10 , child: x,),
    //         Expanded(flex : 2 , child: const SizedBox(width: 1,),),
    //         Expanded(flex : 50 , child: xv,),
    //       ],)),
    //       line,
    //       Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
    //         Expanded(flex : 10 , child: y,),
    //         Expanded(flex : 2 , child: const SizedBox(width: 1,),),
    //         Expanded(flex : 50 , child: yv,),
    //       ],)),
    //       line,
    //       Expanded(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [
    //         Expanded(flex : 10 , child: z,),
    //         Expanded(flex : 2 , child: const SizedBox(width: 1,),),
    //         Expanded(flex : 50 , child: zv,),
    //       ],)),
    //
    //     ],
    //   ),
    // )..height = baseHeight * 3;

  }
  @override
  EditorHolder getCellEditWidget(initValue , onChanged , onSubmitted ,{ Widget showInfo,FunctionDynamicCallback onExtraEdit}){
    return EditorHolder()..widget=Container(
      child: Row(
        children: [
          Expanded(child:Text("list")),
          IconButton(
            padding: EdgeInsets.all(0),
            icon:Icon(MaterialCommunityIcons.square_edit_outline),
            onPressed: (){
              onExtraEdit?.call(null);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget getDefaultEditWidget(bool bIsEdit , initValue , onChanged , onSubmitted , {Widget showInfo,bool bOpen = false, FunctionBoolCallback onVisible , EditorLevelInfo levelInfo , BuildContext context} ){
    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColor(Colors.grey , 30),
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
    // );
    return  Container(
      // padding: EdgeInsets.all(4),
      height: SSDefines.nodeFieldRowHeight,
      child: Center(child:Text("[0,0,0]")),
    ) ;

  }
  @override
  EditorHolder getEditWidget(initValue, onChanged , onSubmitted , {Widget showInfo , bool bOpen = false , FunctionBoolCallback onVisible , EditorLevelInfo levelInfo, BuildContext context} ){

    List<double> lst = parseValue(initValue);
    double xySize = 18;
    var pa = EdgeInsets.fromLTRB(0,0,0,4);
    var x = Container(
      width: xySize,
      height: xySize,
      // color: //Colors.red,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.red , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(
        child: Text("X", style: TextStyle(fontSize: 12)),
      ),
    );
    var xpan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: x,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[0];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[0] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );
    var xv = FloatEditor(
      // noUnderLine: true,
      contentPadding: pa,
      style: TextStyle(fontSize: 14),
      initValue : lst[0] ,
      onChanged : (v){
        lst[0] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[0] = v;
        onSubmitted?.call(lst);
      },
    );
    var y = Container(

      width: xySize,
      height: xySize,
      // color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.green , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(

        child: Text("Y",style: TextStyle(fontSize: 12)),
      ),
    );

    var ypan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: y,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[1];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[1] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );

    var yv = FloatEditor(
      // noUnderLine: true,
      contentPadding: pa,
      style: TextStyle(fontSize: 14),
      initValue : lst[1] ,
      onChanged : (v){
        lst[1] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[1] = v;
        onSubmitted?.call(lst);
      },
    );

    var z = Container(

      width: xySize,
      height: xySize,
      // color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.blue , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(

        child: Text("Z",style: TextStyle(fontSize: 12)),
      ),
    );

    var zpan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: z,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[2];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[2] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );
    var zv = FloatEditor(
      // noUnderLine: true,
      contentPadding: pa,
      style: TextStyle(fontSize: 14),
      initValue : lst[2] ,
      onChanged : (v){
        lst[2] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[2] = v;
        onSubmitted?.call(lst);
      },
    );

    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColor(Colors.grey , 30),
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],
    // );
    return EditorHolder()..widget = Container(
      // padding: EdgeInsets.fromLTRB(0,4,1,4),
//      height: SSDefines.nodeFieldRowHeight,
      child: Container(
        // decoration: dc,

        padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
        // color: CommonUtil.alphaColor(Colors.redAccent, 25),
        child:Row(
          children: [
            // Expanded(flex : 10 , child: x,),
            // x,
            xpan,
            SizedBox(width: 4,),
            // Expanded(flex : 2 , child: Container(),),
            Expanded(flex : 50 , child: xv,),
            // Expanded(flex : 2 , child: Container(),),
            // Expanded(flex : 10 , child: y,),
            SizedBox(width: 8,),
            // y,
            ypan,
            SizedBox(width: 4,),
            // Expanded(flex : 2 , child: Container(),),
            Expanded(flex : 50 , child: yv,),
            // Expanded(flex : 2 , child: Container(),),

            SizedBox(width: 8,),
            // z,
            zpan,
            SizedBox(width: 4,),
            // Expanded(flex : 2 , child: Container(),),
            Expanded(flex : 50 , child: zv,),
            // Expanded(flex : 2 , child: Container(),),

          ],
        ),
      ),
    )..height = SSDefines.nodeFieldRowHeight ;

  }
  Offset storePos;
  double storeVal;

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){

    List<double> lst = parseValue(initValue);
    double xySize = 18;
    var x = Container(
      width: xySize,
      height: xySize,
      // color: //Colors.red,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.red , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(
        child: Text("X", style: TextStyle(fontSize: 12)),
      ),
    );
    var xpan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: x,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[0];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[0] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );
    var xv = FloatEditor(
      // noUnderLine: true,
      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
      style: TextStyle(fontSize: 14),
      initValue : lst[0] ,
      onChanged : (v){
        lst[0] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[0] = v;
        onSubmitted?.call(lst);
      },
    );
    var y = Container(

      width: xySize,
      height: xySize,
      // color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.green , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(

        child: Text("Y",style: TextStyle(fontSize: 12)),
      ),
    );

    var ypan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: y,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[1];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[1] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );

    var yv = FloatEditor(
      // noUnderLine: true,
      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
      style: TextStyle(fontSize: 14),
      initValue : lst[1] ,
      onChanged : (v){
        lst[1] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[1] = v;
        onSubmitted?.call(lst);
      },
    );

    var z = Container(

      width: xySize,
      height: xySize,
      // color: CommonUtil.alphaColor(Colors.green , 80),//Colors.green,
      decoration: BoxDecoration(
        // border: new Border.all(color: colorBd, width: 1),
          color : CommonUtil.alphaColor(Colors.blue , 80),
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
          borderRadius: new BorderRadius.circular((4))
      ),
      child: Center(

        child: Text("Z",style: TextStyle(fontSize: 12)),
      ),
    );

    var zpan = GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      child: InkWell(
        child: z,
        mouseCursor: SystemMouseCursors.resizeLeftRight,
      ) ,
      onHorizontalDragStart: (e){
        storePos = e.globalPosition;
        storeVal = lst[2];
      },
      onHorizontalDragUpdate: (e){
        var delta = e.globalPosition - storePos;
        var val = (delta.dx / 10.0)  + storeVal;
        lst[2] = DartCommon.toFloatAsFixed(val,3);
        onSubmitted?.call(lst);
      },
      onHorizontalDragEnd: (e){

      },
    );
    var zv = FloatEditor(
      // noUnderLine: true,
      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
      style: TextStyle(fontSize: 14),
      initValue : lst[2] ,
      onChanged : (v){
        lst[2] = v;
        onChanged?.call(lst);
      },
      onSubmitted: (v){
        lst[2] = v;
        onSubmitted?.call(lst);
      },
    );

    // var dc = new BoxDecoration(
    //   color: CommonUtil.alphaColor(Colors.grey , 30),
    //   boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(0.0, 0.0),    blurRadius: 1.0, spreadRadius: 1.0) , BoxShadow(color: ThemeCenter.systemTheme.scaffoldBackgroundColor)],
    // );
    return EditorHolder()..widget = Container(
      // padding: EdgeInsets.fromLTRB(0,4,1,4),
//      height: SSDefines.nodeFieldRowHeight,
      child: Container(
        // decoration: dc,

        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        // color: CommonUtil.alphaColor(Colors.redAccent, 25),
        child:Row(
          children: [
            // Expanded(flex : 10 , child: x,),
            // x,
            xpan,
            SizedBox(width: 4,),
            // Expanded(flex : 2 , child: Container(),),
            Expanded(flex : 50 , child: xv,),
            // Expanded(flex : 2 , child: Container(),),
            // Expanded(flex : 10 , child: y,),
            SizedBox(width: 8,),
            // y,
            ypan,
            SizedBox(width: 4,),
            // Expanded(flex : 2 , child: Container(),),
            Expanded(flex : 50 , child: yv,),
            // Expanded(flex : 2 , child: Container(),),

            SizedBox(width: 8,),
            // z,
            zpan,
            SizedBox(width: 4,),
            // Expanded(flex : 2 , child: Container(),),
            Expanded(flex : 50 , child: zv,),
            // Expanded(flex : 2 , child: Container(),),

          ],
        ),
      ),
    ) ;
  }

  @override
  List<double> parseValue(value){
    List<double> v = [0.0,0.0,0.0];
    if (value is List){
      for(var i=0;i< min(value.length,3);++i){
        v[i] = DartCommon.parseDouble(value[i]);
      }
    }

    if (value is Map){
      var x = value["x"]??0.0;
      var y = value["y"]??0.0;
      var z = value["z"]??0.0;
      // if (x is String){
      //   x = double.tryParse(x)??0.0;
      // }
      // if (y is String){
      //   y = double.tryParse(y)??0.0;
      // }
      // if (z is String){
      //   z = double.tryParse(z)??0.0;
      // }
      v = [DartCommon.parseDouble(x),DartCommon.parseDouble(y),DartCommon.parseDouble(z)];
    }
    return v;
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    List<double> lst = parseValue(v);
    // bw.writeUint32(lst.length,"list length");
    for(var t in lst){
      // innerType0.export(bw, t);
      if (StateScriptProject.instance.exportFixedPoint)
      {
        bw.writeInt64((t * 65536).toInt() , exportFlag);
        continue;
      }
      bw.writeFloat32(t , exportFlag);
    }
  }

  @override
  dynamic exportValue(v) {
    List<double> lst = parseValue(v);
    List<double> out = [0.0,0.0,0.0];//List<double>();
    for(var i=0;i<min(lst.length,3);++i){
//      innerType0.export(bw, t);
      out[i] = lst[i];
    }

    return {"x":out[0],'y':out[1],'z':out[2]};
  }


  @override
  dynamic getExportDefault(dynamic defaultValue){
    List<double> lst = parseValue(defaultValue);
    List<double> out = [0.0,0.0,0.0];
    for(var i=0;i<min(lst.length,3);++i){
//      innerType0.export(bw, t);
      out[i] = lst[i];
    }

    // return out;
    return {"x":out[0],'y':out[1],'z':out[2]};
  }

//  @override
//  String getExportType(){
//    return "List<${innerType0.name}>";
//  }
  @override
  clone(){
    var t = SSVector3();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }

  @override
  String syncSerialize(dynamic value){
    List<double> lst = parseValue(value);
    return "${lst[0]},${lst[1]},${lst[2]}";
  }
  @override
  dynamic syncDeserialize(String serStr){
    List<double> lst = [0,0,0];
    var vs = serStr.split(",");
    for(var i=0;i<min(vs.length,3);++i){
//      innerType0.export(bw, t);
      lst[i] = double.tryParse(vs[i])??0.0;
    }
    return lst;
  }
}