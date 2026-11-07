//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ClassDecoration.dart';
import 'package:battlepus/ObjectTable/Struct/FieldLayout.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'package:battlepus/common/text_editor.dart';

class DecorationView extends StatefulWidget {
  final ClassDecoration decoration;
  final ObjectClazz clazz;
  final AObject object;
  final CanvasHolder canvas;
  final bool editMode;
  DecorationView({Key key,
    this.decoration,
    this.clazz,
    this.object,
    this.canvas,
    this.editMode,
  }) : super(key: key);

  @override
  _DecorationViewState createState() => _DecorationViewState();
}

class _DecorationViewState extends State<DecorationView> {

  static Offset _downPointer = Offset.zero;

  StreamSubscription<AFieldTransformChanged> _lis2;

  @override
  void dispose() {
    _lis2?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _lis2 = EventCenter.eventBus.on<AFieldTransformChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (widget.decoration.guid == event.fieldGuid){
        setState(() {
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var color = Color(0xFF555555);//CommonUtil.alphaColorD(Color(0xFF000000),0.1);//clz.color);
    var colorBd = Color(0xFF333333);//CommonUtil.alphaColorD(color, 0.6);
    // var colorContent = CommonUtil.changeColorLightness(Color(0xFF99CCFF),0.3);//clz.color);


    // var fl = widget.decoration;
    double x = 0;//fl.x;
    double y = 0;//fl.y;//widget.index * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);

    var fl = widget.clazz.getFieldLayout(widget.decoration); //fieldsLayouts[field.guid];
    if (fl != null){
      x = fl.x;
      y = fl.y;
    }

    var width = fl.width;
    var height = fl.height;
    var ts = TextStyle(color: Color(0xFF7b7c80) ,fontSize: 10, fontWeight: FontWeight.w600);
    var ts2 = TextStyle(color: Colors.red ,fontSize: 10, fontWeight: FontWeight.w600);
    Widget edt = Text(widget.decoration.value??"" , style: ts,);
    if (widget.editMode) edt = Padding(
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      child: Container(
          // padding: EdgeInsets.fromLTRB(3,4,0,0),
          height: height - 4,
          width: width - 16,
          // color: Colors.black,
          child:TextEditor(
            contentPadding:EdgeInsets.fromLTRB(0,0,0,0),
            initValue: widget.decoration.value??"",
            noUnderline: true,
            maxLines: 64,
            // isDense: false,
            textStyle: ts2,
            onChanged: (v){
              widget.decoration.value = v;
            },
          )
      )
      ,
    );IgnorePointer(child:edt);

    // edt = Row(
    //   // crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Container(width: 2,
    //
    //         decoration: BoxDecoration(
    //           gradient: LinearGradient(
    //             begin : Alignment.topCenter,
    //             end : Alignment.bottomCenter,
    //             colors: [Colors.grey, Colors.blueGrey ],),
    //           // color : Colors.blueAccent,
    //           //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
    //           // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
    //           borderRadius: new BorderRadius.circular((2)),
    //         )
    //     ),
    //     // SizedBox(
    //     //   height: 13,
    //     //   child: Container(width: 2,
    //     //
    //     //       decoration: BoxDecoration(
    //     //         gradient: LinearGradient(
    //     //           begin : Alignment.topCenter,
    //     //           end : Alignment.bottomCenter,
    //     //           colors: [Colors.grey, Colors.blueGrey ],),
    //     //         // color : Colors.blueAccent,
    //     //         //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
    //     //         // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
    //     //         borderRadius: new BorderRadius.circular((2)),
    //     //       )
    //     //   ),
    //     // ),
    //     SizedBox(width: 4,),
    //     edt,
    //   ],
    // );

    edt = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child:edt),
        Container(height: 1.2,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin : Alignment.bottomLeft,
                end : Alignment.bottomRight,
                colors: [Colors.grey, Colors.blueGrey ],),
              // color : Colors.blueAccent,
              //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
              // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
              borderRadius: new BorderRadius.circular((1)),
            )
        ),
      ],
    );

    bool isSelected = fl.selected??false;
    if (isSelected && widget.editMode) colorBd = Colors.red;//CommonUtil.changeColorLightness(Colors.green, 1.0);

    var dc = new BoxDecoration(
      border: new Border.all(color: colorBd, width: 1),
      color : isSelected?color:null,
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
      // borderRadius: new BorderRadius.circular((5)),
    );
    double resizeSize = 16 ;
    var af =  Container(

      padding: (widget.editMode) ? EdgeInsets.fromLTRB(16, 4, 0, 0) : EdgeInsets.fromLTRB(2, 2, 0, 0),
      decoration: (widget.editMode) ? dc : null,
      // color: Colors.grey,
      width: width,
      height: height,
      child: edt,//Center(child: edt,),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     if (height >= OTDefines.fieldViewHeight) SizedBox(height : 24 , child: Padding(
      //       padding: EdgeInsets.fromLTRB(0, 0, 0, 4) ,
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.center ,
      //         children: [
      //           Expanded(child : Text(field.getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:5 , fontSize: 14), )),
      //         ],
      //       ),
      //     ),),
      //     // Expanded(flex : 6 , child: Text(field.getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:5 , fontSize: 16), ),),
      //     Expanded(flex : 8 , child: Container(padding: fi.getCanvasEditPadding(), color: fi.getCanvasEditBgColor(), child:edt),),
      //   ],
      // ),
    );

    var cx = widget.canvas == null?0:OTDefines.canvasZeroX;
    var cy = widget.canvas == null?0:OTDefines.canvasZeroY;
    if (!widget.editMode){
      return Positioned(
        key: ValueKey("${widget.decoration.guid}"),
        left: x + cx ,//- SSDefines.portOffX ,
        top: y + cy,
        child: af,//RepaintBoundary(child:dnn2),
      );
    }

    var stk = Container(
      width: width,
      height: height,
      child:Stack(
        children: [
          // IgnorePointer(child:af),
          af,
          // Positioned(
          //   left: width-64,
          //   top: height-32,
          //   child: ThemeCenter.iconBtn(MaterialCommunityIcons.close_box,color: Colors.red,
          //       width: 32,height: 32,
          //     tooltip: "删除",
          //     onPressed: (){
          //
          //     }
          //   ),
          // ),
          Positioned(
            left: width-resizeSize,
            top: height-resizeSize,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              dragStartBehavior : DragStartBehavior.down,
              child: Container(width: resizeSize,height: resizeSize, child: Center(child: Icon(MaterialCommunityIcons.resize_bottom_right , size: resizeSize, color: Colors.green,))),//Icon
              onTapDown: (e) {
              },
              onPanDown: (e){
              },
              onPanStart: (e){
                widget.clazz.storeSelectedSize();
                _downPointer = e.globalPosition;
              },
              onPanUpdate: (e){
                var off = e.globalPosition - _downPointer??Offset.zero;
                off = widget.canvas.canvasState.global2LocalDelta(off);
                widget.clazz.updateSelectedSize(off , bFixed: true);
                setState(() {
                  EventCenter.eventBus.fire(AObjectChanged()..obj = widget.object ..buildLayout = true);
                });
              },
              onPanEnd: (e){
              },
            ),
          ),


        ],
      ),
    );


    var dnn2 = GestureDetector(
      dragStartBehavior : DragStartBehavior.down,
      // behavior : HitTestBehavior.opaque,
      child: stk,

      onPanDown: (e){

      },
      onTapDown: (e) {
        onTapDown(fl);
      },
      onPanStart: (e){
        // print("onPanStart");
        if (!_doTapDown){
          onTapDown(fl);
        }
        widget.clazz.storeSelectedPos();
        _downPointer = e.globalPosition;

      },
      onPanUpdate: (e){
        var off = e.globalPosition - _downPointer??Offset.zero;
        off = widget.canvas.canvasState.global2LocalDelta(off);
        widget.clazz.updateSelectedPos(off , bFixed: true);
        setState(() {
          EventCenter.eventBus.fire(AObjectChanged()..obj = widget.object ..buildLayout = true);
        });
      },

      onPanEnd: (e){
        widget.clazz.fixSelectedPos();
        _doTapDown = false;
        // var fl = widget.clazz.fieldsLayouts[field.guid];
        // var pos = Offset(fl.x,fl.y);
        // pos = OTDefines.fixPosition(pos);// widget.canvas.fixPosition(pos);
        // fl.x = pos.dx ;
        // fl.y = pos.dy ;
        setState(() {
          EventCenter.eventBus.fire(AObjectChanged()..obj = widget.object ..buildLayout = true);
          // EventCenter.eventBus.fire(AFieldTransformChanged()..obj = widget.object ..fieldGuid = field.guid);
        });
      },
    );

    return Positioned(
      key: ValueKey("${widget.decoration.guid}"),
      left: x + cx ,//- SSDefines.portOffX ,
      top: y + cy,
      child: dnn2,//RepaintBoundary(child:dnn2),
    );
  }

  bool _doTapDown = false;
  void onTapDown(FieldLayout fl){
    bool isSelected = fl.selected??false;
    if (KeyEventCenter.isControlPressed()) {
      setState(() {
        fl.selected = !isSelected;
      });
    }
    else{
      setState(() {
        if (!isSelected) widget.clazz.unSelectAll();
        fl.selected = true;
      });
    }

    _doTapDown = true;
  }
}