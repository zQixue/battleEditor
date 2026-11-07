//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/ObjectTable/OTDefines.dart';
import 'package:battlepus/ObjectTable/OTUtils.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectCanvasItemBase.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomCanvas.dart';
import 'dart:async';

class AObjectView extends StatefulWidget {
  final AObject object;
  final CanvasHolder canvas;
  final bool editMode ;
  const AObjectView({Key key,
    this.object, this.canvas,this.editMode = false,
  }) : super(key: key);

  @override
  _AObjectViewState createState() => _AObjectViewState();
}

class _AObjectViewState extends State<AObjectView> {

  StreamSubscription<AObjectForceChanged> _lis;

  @override
  void dispose() {
    _lis?.cancel();
    // print("obj dispose : ${widget.object.guid}");
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _lis = EventCenter.eventBus.on<AObjectForceChanged>().listen((event) {
      // _focusNode.requestFocus();
      if (event?.obj == widget.object){
        setState(() {
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("obj build : ${widget.object.guid}");
    if (!OTDefines.editMode){
      return getAllFields();
    }
    var dragTarget = DragTarget<ObjectCanvasBase>(
      builder: onBuildDragTarget,
      onAcceptWithDetails: onAcceptWithDetails,
      onWillAccept: onWillAccept,
      onLeave: onLeave,
    );
    return dragTarget;
  }

  Widget getAllFields(){
    if (widget.object == null) return Container();
    // print("??????????????????????");
    // var fieldWidgets = List<Widget>();
    // fieldWidgets.add(AObjectFrameView(object: widget.object,));
    //
    // var clz = widget.object.getClazz();
    // if(clz == null) return Container();
    //
    // clz.groups.forEach((key, value) {
    //   if (value.fieldGuids.length<=0) return ;
    //   fieldWidgets.add(AGroupFrame(object: widget.object,group: value,canvas: widget.canvas, editMode: widget.editMode,));
    // });
    //
    // int iCount = 0 ;
    // var fields = clz.getAllFields();
    // fields.forEach((element) {
    //   var fv = AFieldView(clazz: clz,object: widget.object, field: element,index:iCount ,canvas : widget.canvas,editMode: widget.editMode);
    //   ++iCount;
    //   fieldWidgets.add(fv);
    // });
    if (widget.object.isComment){
      var r = widget.object.getClazz().getObjectRect();
      var objView = Container(
        width: r.width,
        height: r.height,
        // alignment: widget.isStatic? null:Alignment.centerLeft ,
        child: Text(widget.object.comment??"" , style: TextStyle(color: Colors.green , fontSize: 12,fontWeight: FontWeight.w400 ),),
      );

      var cx = widget.canvas == null?0:OTDefines.canvasZeroX;
      var cy = widget.canvas == null?0:OTDefines.canvasZeroY;

      return Positioned(
        key: ValueKey("${widget.object.guid}_comment"),
        left: r.left + cx,//- SSDefines.portOffX ,
        top: r.top + cy,
        child: objView,//RepaintBoundary(child:dnn2),
      );
    }
    var fieldWidgets = OTUtils.getCanvasObjectView(widget.object,withFrame: true , canvas: widget.canvas , editMode: widget.editMode);
    return Container(
      child:Stack(
        children: fieldWidgets
      ),
    );
  }




  Widget onBuildDragTarget(BuildContext context, List candidateData, List rejectedData) {
    return getAllFields();
  }

  void onAcceptWithDetails(DragTargetDetails<ObjectCanvasBase> details) {
  }

  bool onWillAccept(data) {
    return true;
  }

  void onLeave(Object data) {
  }
}
