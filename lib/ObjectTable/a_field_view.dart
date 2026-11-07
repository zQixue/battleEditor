//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/FieldGroup.dart';
import 'package:battlepus/ObjectTable/Struct/FieldLayout.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'package:battlepus/protos/transition.pb.dart';

class AFieldView extends StatefulWidget {
  final ObjectClazz clazz;
  final AObject object;
  final FieldGroup group;
  final FieldInfo field;
  final int index;
  final CanvasHolder canvas;
  final bool editMode;
  const AFieldView({Key key ,
    this.clazz,
    this.object,
    this.field,
    this.index,
    this.canvas,
    this.group,
    this.editMode = false,
  }) : super(key: key);
  @override
  _AFieldViewState createState() => _AFieldViewState();
}

class _AFieldViewState extends State<AFieldView> {

  static Offset _downPointer = Offset.zero;
  static Offset _downStorePos = Offset.zero;

  StreamSubscription<AFieldTransformChanged> _lis2;
  StreamSubscription<AGroupVisibleChanged> _lis3;

  @override
  void dispose() {
    _lis2?.cancel();
    _lis3?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _lis2 = EventCenter.eventBus.on<AFieldTransformChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (event.obj!= null && event.obj != widget.object) return ;

      if (widget.field.guid == event.fieldGuid){
        setState(() {
        });
      }
    });
    _lis3 = EventCenter.eventBus.on<AGroupVisibleChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (event.group!= null && event.group == widget.group) {
        setState(() {
        });
      } ;
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    // var fValue = widget.object.fieldValues[widget.field.guid];
    var fi = SSFieldType.getFieldType(widget.field.typeGuid , fieldInfo: widget.field);
    var obj = widget.object;
    var field = widget.field;

    var edth = fi.getGridCellEditor(
      initValue: obj.getFieldValue(field.guid),
//        item.name,
      onChanged: (v) {
        obj.setFieldValue(field.guid, v, field.getTypeShowString());

        if (widget.clazz.getAllTagFields().contains(widget.field.guid)) {
          obj.buildTag(widget.clazz.getAllTagFields());
          EventCenter.eventBus.fire(AObjectChanged()..obj = obj);
        }
      },
      onSubmitted: (v) {
        obj.setFieldValue(field.guid, v, field.getTypeShowString());
        // EventCenter.eventBus.fire(AObjectChanged()..obj = obj);
        if (widget.clazz.getAllTagFields().contains(widget.field.guid)) {
          obj.buildTag(widget.clazz.getAllTagFields());
          EventCenter.eventBus.fire(AObjectChanged()..obj = obj);
        }
        tryFlush2Unity();
        setState(() {

        });
      },
      context: context,
      gci: GridCellInfo()..fieldInfo = field..object = widget.object..isObjectTableEditMode = widget.editMode,
    );
    var color = CommonUtil.changeColorLightness(Color(0x7F666666),0.2);//clz.color);
    var colorBd = CommonUtil.changeColorLightness(color, 0.25);
    // var colorContent = CommonUtil.changeColorLightness(Color(0x7F666666),0.3);//clz.color);

    var edt = edth.widget;
    if (widget.editMode) edt = IgnorePointer(child:edt);

    double x = 0;
    double y = widget.index * (OTDefines.fieldViewHeight + OTDefines.fieldViewIntervalY);

    var fl = widget.clazz.getFieldLayout(field); //fieldsLayouts[field.guid];
    if (fl != null){
      x = fl.x;
      y = fl.y;
    }

    var width = fl.width;
    var height = fl.height;

    bool isSelected = fl.selected??false;
    if (isSelected && widget.editMode) colorBd = Colors.red;//CommonUtil.changeColorLightness(Colors.green, 1.0);

    var dc = new BoxDecoration(
      border: new Border.all(color: colorBd, width: 1),
      color : isSelected?color:null,
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
      // borderRadius: new BorderRadius.circular((5)),
    );

    var af =  Container(
      padding: (widget.editMode) ? null:EdgeInsets.all(1),
      decoration: (widget.editMode) ? dc : null,
      // color: Colors.grey,
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (height >= OTDefines.fieldShowHeadTitleViewHeight && (fl.showTitle??false)) SizedBox(
            // color: Colors.green,
            height : OTDefines.fieldHeadTitleViewHeight , child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0) ,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center ,
                children: [
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(0, 3, 6, 2),
                  //   child: Container(width: 3,
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           begin : Alignment.topCenter,
                  //           end : Alignment.bottomCenter,
                  //           colors: [Colors.blueAccent, Colors.blueGrey ],),
                  //         // color : Colors.blueAccent,
                  //         //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
                  //         // boxShadow: [ BoxShadow(color: bgColor, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgColor)],
                  //         borderRadius: new BorderRadius.circular((2)),
                  //       )
                  //   ),
                  // ),
                  Expanded(child : Text(field.getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:4 , fontSize: 10), )),
                ],
              ),
            ),),
          // Expanded(flex : 6 , child: Text(field.getTypeShowString() ,style: ThemeCenter.mainTextStyle(step:5 , fontSize: 16), ),),
          Expanded(flex : 8 , child: Container(padding: fi.getCanvasEditPadding(), color: fi.getCanvasEditBgColor(), child:edt),),
          // Expanded(flex : 8 , child: Container(padding: fi.getCanvasEditPadding(), color: Colors.black, child:edt),),
        ],
      ),
    );

    var cx = widget.canvas == null?0:OTDefines.canvasZeroX;
    var cy = widget.canvas == null?0:OTDefines.canvasZeroY;
    if (!widget.editMode){

      if (widget.group != null){
        // print("${widget.group.guid} ${widget.group.visible} ${widget.group.defaultVisible}");
        // print("uuu ${widget.group.visible??widget.group.defaultVisible}");
        if (!(widget.group.visible??widget.group.defaultVisible)){
          // print("${widget.group.guid} ${widget.group.defaultVisible}");
          print("hide field");
          return Positioned(
            key: ValueKey("${obj.guid}_${field.guid}"),
            left: x + cx ,//- SSDefines.portOffX ,
            top: y + cy,
            child: const SizedBox(width: 0,),//Container(width: 0, height: 0, color: Colors.red,),//RepaintBoundary(child:dnn2),
          );
          return Container(width: 100, height: 100, color: Colors.red,);
        }
      }
      print("not hide field");
      return Positioned(
        key: ValueKey("${obj.guid}_${field.guid}"),
        left: x + cx ,//- SSDefines.portOffX ,
        top: y + cy,
        child: af,//RepaintBoundary(child:dnn2),
      );
    }
    double resizeSize = 16 ;
    var stk = Container(
      width: width,
      height: height,
      color: Colors.red.withAlpha(30),
      child:Stack(
        children: [
          // IgnorePointer(child:af),
          af,
          Positioned(
            left: width-resizeSize,
            top: height-resizeSize,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              dragStartBehavior : DragStartBehavior.down,

              child: Container(width: resizeSize,height: resizeSize, child: Center(child: Icon(MaterialCommunityIcons.resize_bottom_right , size: resizeSize, color: Colors.green,))),//Icon
              // (MaterialCommunityIcons
            // .arrow_collapse_left ),
              onTapDown: (e) {
              },
              onPanDown: (e){
              },
              onPanStart: (e){
                widget.clazz.storeSelectedSize();
                _downPointer = e.globalPosition;
                _downStorePos = Offset(x , y);
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
        _downStorePos = Offset(x , y);


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
      key: ValueKey("${obj.guid}_${field.guid}"),
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
  V3 tryGetV3(List<double> lst){
    if (lst.length>=3){
      return V3(x: lst[0] , y: lst[1] , z: lst[2] ,);
    }
    if (lst.length == 2){
      return V3(x: lst[0] , y: 0.0 , z: lst[1] ,);
    }
    if (lst.length == 1){
      return V3(x: lst[0] , y: 0.0 , z: 0.0 ,);
    }
    return V3(x: 0.0 , y: 0.0 , z: 0.0 ,);
  }
  void tryFlush2Unity() {
    var obj = widget.object;
    if (obj == null) return ;
    var field = widget.field;
    if (field == null) return ;
    var tgtGuid = obj.guid;
    var map = TableUtiles.otTransformFieldMap[obj.guid];
    if (map == null){
      var fullGuid = "${obj.guid}_${field.name}";
      map = TableUtiles.otTransformFieldMap[fullGuid];
      tgtGuid = fullGuid;
      // TableUtiles.getTransformFieldMapBy(obj.guid , )
    }
    if (map == null) return ;

    var val = obj.fieldValues[field.guid].value;
    var fi = SSFieldType.getFieldType(widget.field.typeGuid , fieldInfo: widget.field);
    var rVal = fi.parseValue(val);

    if (map["pos"] == field.name){
      OT_ObjectTransform po = OT_ObjectTransform();
      po.guid = tgtGuid;
      po.pos = tryGetV3(rVal);
      po.updatePos = true;
      Transport.instance.sendUdpData(OPackType.O2U_OT_TRANSFORM_CHANGED, po);
    }
    if (map["rot"] == field.name){
      OT_ObjectTransform po = OT_ObjectTransform();
      po.guid = tgtGuid;
      po.rot = tryGetV3(rVal);
      po.updateRot = true;
      Transport.instance.sendUdpData(OPackType.O2U_OT_TRANSFORM_CHANGED, po);
    }
    if (map["scale"] == field.name){
      OT_ObjectTransform po = OT_ObjectTransform();
      po.guid = tgtGuid;
      po.scale = tryGetV3(rVal);
      po.updateScale = true;
      Transport.instance.sendUdpData(OPackType.O2U_OT_TRANSFORM_CHANGED, po);
    }
  }
}
