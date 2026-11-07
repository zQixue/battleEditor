//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'package:battlepus/common/directory_picker.dart';
import 'package:battlepus/common/text_editor_ex.dart';

class AObjectFrameView extends StatefulWidget {
  final AObject object;
  final CanvasHolder canvas;
  final bool editMode;
  AObjectFrameView({Key key,
    this.object, this.canvas,
  this.editMode,
  }) : super(key: key);

  @override
  _AObjectFrameViewState createState() => _AObjectFrameViewState();
}

class _AObjectFrameViewState extends State<AObjectFrameView> {

  StreamSubscription<AObjectChanged> _lis;
  StreamSubscription<AGroupVisibleChanged> _lis3;

  // Rect getObjectRect(){
  //   // Rect res = Rect.fromLTRB(double.maxFinite, double.maxFinite, double.minPositive, double.minPositive);
  //   var left = double.maxFinite;
  //   var top = double.maxFinite;
  //   var right = double.minPositive;
  //   var bottom = double.minPositive;
  //   var clz = widget.object.getClazz();
  //   var f2g = clz.getFiled2GroupMap();
  //
  //   clz.groups.forEach((key, value) {
  //     var r = value.getGroupRect(clz);
  //     left = min(left , r.left);
  //     top = min(top , r.top);
  //     right = max(right , r.right);
  //     bottom = max(bottom , r.bottom);
  //   });
  //
  //   int iCount = 0;
  //   var fields = clz.getAllFields();
  //   fields.forEach((element) {
  //     if (f2g.containsKey(element)) return;
  //     double x = 0;
  //     double y = iCount * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);
  //     double width = OTDefines.fieldViewWidth;
  //     double height = OTDefines.fieldViewHeight;
  //
  //     var fl = clz.fieldsLayouts[element.guid];
  //     if (fl != null){
  //       x = fl.x;
  //       y = fl.y;
  //       if (fl.width>0) width = fl.width;
  //       if (fl.height>0) height = fl.height;
  //     }
  //     left = min(left , x);
  //     top = min(top , y);
  //     right = max(right , x + width);
  //     bottom = max(bottom , y + height);
  //     ++iCount;
  //   });
  //
  //   return Rect.fromLTRB(0 - OTDefines.frameBorderSize, 0 - OTDefines.frameBorderSize - OTDefines.objectHeaderHeight, right+OTDefines.frameBorderSize, bottom+OTDefines.frameBorderSize);
  // }

  @override
  void dispose() {
    _lis?.cancel();
    _lis3?.cancel();
    _nameNotifier?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _nameNotifier.value = widget.object.getTag();
    _lis = EventCenter.eventBus.on<AObjectChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (event?.obj == widget.object){// && (event?.buildLayout??false)){
        setState(() {

        });
      }
    });

    _lis3 = EventCenter.eventBus.on<AGroupVisibleChanged>().listen((event) {
      // _focusNode.requestFocus();
      setState(() {
      });
    });
    // TODO: implement initState
    super.initState();
  }
  final _nameNotifier = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    var obj = widget.object;
    var rect  = widget.object.getClazz().getObjectRect(bEditMode: widget.editMode);

    // rect = Rect.fromLTRB(rect.left - OTDefines.frameBorderSize, rect.top - OTDefines.frameBorderSize - OTDefines.objectHeaderHeight, rect.right+OTDefines.frameBorderSize, rect.bottom+OTDefines.frameBorderSize);
    rect = Rect.fromLTRB(rect.left - OTDefines.frameBorderSize, rect.top - OTDefines.frameBorderSize - 12, rect.right+OTDefines.frameBorderSize, rect.bottom+OTDefines.frameBorderSize);
    var color = Color(0xFF1f242b);//CommonUtil.changeColorLightness(Color(0xCF1f242b),0.9);//clz.color);
    var colorBd = Color(0xFF2c323e);
    var dc = new BoxDecoration(
      // border: new Border.all(color: colorBd, width: 1),
      color :color,
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      // boxShadow: [ BoxShadow(color: colorBd, offset:Offset(2.0, 2.0), blurRadius:2.0, spreadRadius: 0.0) , BoxShadow(color: colorBd)],
      borderRadius: new BorderRadius.circular((5)),
    );

    var basePath = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var row = Row(
      children: [
        Tooltip(
          message: "guid : ${widget.object.guid??""}",
          child: ValueListenableBuilder<String>(
            key: ValueKey("${widget.object.guid}_vlb"),
            valueListenable: _nameNotifier,
            builder: (_, value, __) =>  Text(widget.object.getTag() , style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w800 , color: Colors.blueAccent),),
          ),
        ),

        SizedBox(width: 8,),
        Icon(MaterialCommunityIcons.account_box , size: 16,),
        SizedBox(width: 8,),
        SizedBox(
          height: 64,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
              child:TextEditorEx(
                // isDense:false,
                textStyle: const TextStyle(fontSize: 14 , color: Colors.grey),
                autoSize: true,
                initValue: widget.object.alias??"",
                onChanged: (v){
                  widget.object.alias = v;
                  _nameNotifier.value = widget.object.getTag();
                  EventCenter.eventBus.fire(ObjectTreeRefreshEvent());

                },
                onSubmitted: (v){
                  widget.object.alias = v;
                  _nameNotifier.value = widget.object.getTag();
                  EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
                  // setState(() {
                  //
                  // });
                },
              )
          ),
        ),


        SizedBox(width: 32,),
        Icon(MaterialCommunityIcons.content_save_move , size: 16,),
        const SizedBox(width: 2,),
        SizedBox(
            width: 640,
            height: 36,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
              child: DirectoryPicker(
                // withLine: false,
                iconSize: 20,
                basePath: basePath,
                initPath: widget.object.group??"",
                onChanged: (v){
                  widget.object.group = v;
                  EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
                },
              ),
            )
        )
        // TextEditorEx(
        //   autoSize: true,
        //   initValue: widget.object.group??"",
        //   onChanged: (v){
        //     widget.object.group = v;
        //
        //
        //   },
        //   onSubmitted: (v){
        //     widget.object.group = v;
        //     EventCenter.eventBus.fire(ObjectTreeRefreshEvent());
        //   },
        // )
      ],
    );
    var af =  Container(

      decoration: dc,
      // color: Colors.grey,
      width: rect.width,
      height: rect.height,
      // child: Column(
      //   children: [
      //     Container(
      //       padding: EdgeInsets.fromLTRB(8, 0, 2, 0),
      //       // color: Colors.blueAccent,//CommonUtil.alphaColorD(Colors.green,0.5),
      //       height: OTDefines.objectHeaderHeight,
      //       child:
      //     ),
      //   ],
      // ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Expanded(child: Text(field.getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:5 , fontSize: 16), ),),
      //     Expanded(child: Container(padding: EdgeInsets.fromLTRB(4,0,4,0), color: colorContent, child:edth.widget),),
      //   ],
      // ),
    );
    var cx = widget.canvas == null?0:OTDefines.canvasZeroX;
    var cy = widget.canvas == null?0:OTDefines.canvasZeroY;

    return Positioned(
      key: ValueKey("${obj.guid}_frame"),
      left: rect.left + cx,//- SSDefines.portOffX ,
      top: rect.top + cy - OTDefines.objectHeaderHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: dc,
            height:  OTDefines.objectHeaderHeight,
            child: row,
          ),

          af
        ],
      ),//RepaintBoundary(child:dnn2),
    );
  }
}