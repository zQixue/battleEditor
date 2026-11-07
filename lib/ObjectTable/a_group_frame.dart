//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/FieldGroup.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AGroupFrame extends StatefulWidget {
  final AObject object;
  final FieldGroup group;
  final CanvasHolder canvas;
  final bool editMode;
  AGroupFrame({Key key,
    this.object,
    this.group,
    this.canvas,
    this.editMode = false,
  }) : super(key: key);

  @override
  _AGroupFrameState createState() => _AGroupFrameState();
}

class _AGroupFrameState extends State<AGroupFrame> {
  StreamSubscription<AGroupChanged> _lis;
  StreamSubscription<AFieldTransformChanged> _lis2;
  bool editName = false;

  @override
  void dispose() {
    _lis?.cancel();
    _lis2?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _lis = EventCenter.eventBus.on<AGroupChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (event?.group == widget.group){
        setState(() {
        });
      }
    });

    _lis2 = EventCenter.eventBus.on<AFieldTransformChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (widget.group.fieldGuids.contains(event?.fieldGuid)){
        setState(() {
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }
  static Offset _downPointer = Offset.zero;
  @override
  Widget build(BuildContext context) {

    // return Container();
    var obj = widget.object;
    if (widget.group.fieldGuids.length<=0) return Container(width: 0,);
    bool withHeader = true ;//widget.group.showTitle;
    var currentVisible = widget.group.visible??widget.group.defaultVisible;
    var rect  = widget.group.getGroupRect(widget.object.getClazz() , bEditMode: widget.editMode);
    var clz = obj.getClazz();
    var color = Color(widget.group?.bgColor??0xFF1b1e26); //CommonUtil.changeColorLightness(Color(0xCFFFFFFF),0.9);//clz.color);
    // var colorBd = CommonUtil.changeColorLightness(color, 0.25);
    var dc = new BoxDecoration(
      // border: new Border.all(color: colorBd, width: 1),
      color :color,
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
      borderRadius: new BorderRadius.circular((8))
    );

    var ts = TextStyle(color: Colors.blue ,fontSize: 14, fontWeight: FontWeight.w600);
    var ts2 = TextStyle(color: Colors.red ,fontSize: 14, fontWeight: FontWeight.w600);
    bool bFullWidth = (widget.group.visible??widget.group.defaultVisible) || widget.editMode;
    var af =  Container(
      padding: EdgeInsets.fromLTRB(0, 4, 12, 0),
      decoration: dc,
      // color: Colors.grey,
      width: bFullWidth?rect.width:null,
      height: rect.height,
      child: Column(
        children: [
          if (withHeader) Container(
            // padding: EdgeInsets.fromLTRB(6, 0, 6, 2),
            // color: Colors.grey,
            height: OTDefines.groupHeaderHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(9, 5, 4, 5),
                  child: Container(width: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin : Alignment.topCenter,
                          end : Alignment.bottomCenter,
                          colors: [Colors.blueAccent, Colors.blueGrey ],),
                        // color : Colors.blueAccent,
                        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
                        // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
                        borderRadius: new BorderRadius.circular((2)),
                      )
                  ),
                ),
                // if (widget.editMode)ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline,
                //   tooltip: "编辑",
                //   color: Colors.blue,
                //   onPressed: (){
                //     setState(() {
                //       editName = !editName;
                //     });
                //   }
                // ),
                // SizedBox(width: 4,),
                // Text(widget.group.name , style: TextStyle(color: Colors.blue , fontSize: 16, fontWeight: FontWeight.w600),),
                !bFullWidth? Text(widget.group.name , style: ts,): Expanded(

                  child:Container(
                    // color: Colors.black87,
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child:Row(
                        children: [
                          if (widget.editMode)Expanded(child:TextEditor(
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            initValue: widget.group.name??"",
                            // noUnderline: true,
                            textStyle: ts2,
                            onChanged: (v){
                              widget.group.name = v;
                            },
                          )),
                          if (widget.editMode)ThemeCenter.iconBtn(MaterialCommunityIcons.palette,
                            tooltip: "切换背景色",
                            onPressed: (){
                              setState(() {
                                bool isInitClr = widget.group.bgColor == null || widget.group.bgColor == 0xFF1b1e26;
                                widget.group.bgColor = isInitClr? 0xFF2c323e:0xFF1b1e26;
                              });
                            }
                          ),
                          if (widget.editMode) const SizedBox(width: 16,),
                          if (!widget.editMode) Expanded(child:Text(widget.group.name , style: ts,)),

                          // if (!widget.editMode) (OTDefines.crtFocusGroup == widget.group)?
                          //     Shimmer(
                          //       // This is the ONLY required parameter
                          //       child: Text(widget.group.name , style: ts,),
                          //       // This is the default value
                          //       duration: Duration(seconds: 3),
                          //       // This is NOT the default value. Default value: Duration(seconds: 0)
                          //       interval: Duration(seconds: 5),
                          //
                          //       // This is the default value
                          //       color: Colors.white,
                          //       // This is the default value
                          //       // colorOpacity: 0.3,
                          //       // This is the default value
                          //       enabled: true,
                          //       // This is the default value
                          //       direction: ShimmerDirection.fromLTRB(),
                          //     )
                          //     :Text(widget.group.name , style: ts,),

                          ],
                        )
                )),
                if (!bFullWidth) const SizedBox(width: 16,),
                if (widget.editMode) SizedBox(width: 10,height :16,child:Checkbox(
                    value: widget.group.defaultVisible??true,
                    activeColor: Colors.red,
                    onChanged: (v){
                      setState(() {
                        widget.group.defaultVisible = v;
                      });
                    }
                )),
                if (!widget.editMode) SizedBox(width: 10,height :16,child:Checkbox(
                    value: currentVisible ,
                    activeColor: Colors.blue,
                    onChanged: (v){
                      setState(() {
                        widget.group.visible = v;
                        EventCenter.eventBus.fire(AGroupVisibleChanged()..group = widget.group);
                      });
                    }
                )),
              ],
            ),
          ),
        ],
      ),
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
    if (!widget.editMode){
      Widget fw = af;
      if (OTDefines.crtFocusGroup == widget.group){
        fw = Shimmer(
          // This is the ONLY required parameter
          child: af,
          // This is the default value
          duration: Duration(seconds: 3),
          // This is NOT the default value. Default value: Duration(seconds: 0)
          interval: Duration(seconds: 102400),

          // This is the default value
          color: Colors.yellowAccent,
          // This is the default value
          // colorOpacity: 0.3,
          // This is the default value
          enabled: true,
          // This is the default value
          direction: ShimmerDirection.fromLTRB(),
        );
      }

      return Positioned(
        key: ValueKey("${obj.guid}_frame"),
        left: rect.left + cx,//- SSDefines.portOffX ,
        top: rect.top + cy,
        child: fw,//RepaintBoundary(child:dnn2),
      );
    }

    var fields = clz.getGroupFields(widget.group);
    var gd = GestureDetector(
      // behavior: HitTestBehavior.opaque,
      dragStartBehavior : DragStartBehavior.down,
      child: af ,//Icon(MaterialCommunityIcons.arrow_collapse_left ),
      onTapDown: (e) {
      },
      onPanDown: (e){
      },
      onPanStart: (e){
        clz.storePos(fields);
        _downPointer = e.globalPosition;
        // _downStorePos = Offset(x , y);
      },
      onPanUpdate: (e){
        var off = e.globalPosition - _downPointer??Offset.zero;
        off = widget.canvas.canvasState.global2LocalDelta(off);
        clz.updatePos(fields,off , bFixed: true);
        // print("group pan update");
        setState(() {
          EventCenter.eventBus.fire(AObjectChanged()..obj = widget.object ..buildLayout = true);
        });
      },
      onPanEnd: (e){
      },
    );

    return Positioned(
      key: ValueKey("${obj.guid}_frame"),
      left: rect.left + cx ,//- SSDefines.portOffX ,
      top: rect.top + cy,
      child: gd,//RepaintBoundary(child:dnn2),
    );
  }

  // Rect getGroupRect(){
  //   // Rect res = Rect.fromLTRB(double.maxFinite, double.maxFinite, double.minPositive, double.minPositive);
  //   var left = double.maxFinite;
  //   var top = double.maxFinite;
  //   var right = double.minPositive;
  //   var bottom = double.minPositive;
  //   var clz = widget.object.getClazz();
  //   int iCount = 0;
  //
  //   widget.group.fieldGuids.forEach((element) {
  //     double x = 0;
  //     double y = iCount * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);
  //     double width = OTDefines.fieldViewWidth;
  //     double height = OTDefines.fieldViewHeight;
  //
  //     var fl = clz.fieldsLayouts[element];
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
  //   return Rect.fromLTRB(left - OTDefines.frameBorderSize, top - OTDefines.frameBorderSize - OTDefines.groupHeaderHeight, right+OTDefines.frameBorderSize, bottom+OTDefines.frameBorderSize);
  // }
}