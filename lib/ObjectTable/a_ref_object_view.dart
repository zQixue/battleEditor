//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/OTUtils.dart';
import 'package:battlepus/ObjectTable/Struct/AObject.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/a_object_selector.dart';
import 'package:battlepus/ObjectTable/object_tag_view.dart';
import 'package:battlepus/ObjectTable/plugins/TableUtils.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';
// import 'package:show_up_animation/show_up_animation.dart';
class ARefObjectView extends StatefulWidget {
  final AObject object;
  final ObjectClazz clazz;
  final bool editMode ;
  final bool isPublic ; //引用是否可展开
  final bool isStatic;
  final FieldInfo fieldInfo;
  final dynamic onSubmitted ;
  ARefObjectView({Key key,
    this.object,
    this.editMode,
    this.onSubmitted,
    this.clazz,
    this.isPublic = true,
    this.isStatic = false,
    this.fieldInfo,
  }) : super(key: key);

  @override
  _ARefObjectViewState createState() => _ARefObjectViewState();
}

class _ARefObjectViewState extends State<ARefObjectView> {

  StreamSubscription<AObjectForceChanged> _lis;
  StreamSubscription<AObjectShowDetail> _lis2;
  StreamSubscription<FocusOTObject> _lis3;



  bool beOnHover = false ;
  bool bDisposed = false;
  bool bDelayed = false;
  bool bEditComment = false;
  AObject current ;
  @override
  void dispose() {
    bDisposed = true;
    // print("obj dispose : ${widget.object?.guid}");
    _lis?.cancel();
    _lis2?.cancel();
    _lis3?.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  final GlobalKey globalKey = GlobalKey();
  @override
  void initState() {

    _lis3 = EventCenter.eventBus.on<FocusOTObject>().listen((event) {
      if (event.guid == widget.object?.guid){
        // widget.
        // if (OTDefines.mainCanvas == null) return ;
        // final RenderBox box = globalKey.currentContext.findRenderObject();
        // final topLeftPosition = box.localToGlobal(Offset.zero);
        // var pos = topLeftPosition;
        // print("--- pos $pos");
        // pos = OTDefines.mainCanvas.canvasState.global2LocalDelta(topLeftPosition);
        // print("--- pos2 $pos");
        // // OTDefines.mainCanvas.canvasState.
        // // OTDefines.mainCanvas.canvasState.
        // OTDefines.mainCanvas.canvasState.focusOffAtLeftTop(-pos.dx , -pos.dy,);
        // // var rest =
        // // OTDefines.mainCanvas.canvasState.focusPositionAtLeftTop(rect.left + OTDefines.canvasZeroX, rect.top + OTDefines.canvasZeroY , off : widget.withItemList?  Offset(64.0 + 380,64) : Offset(64,64));

      }
    });
    if (widget.isStatic) {
      _lis2 = EventCenter.eventBus.on<AObjectShowDetail>().listen((event) {
        // _focusNode.requestFocus();
        // print("ref changed");
        if (event?.obj?.clazzGuid == widget.clazz.guid) {

          setState(() {
            current = event?.obj;
          });
        }
      });

      _lis = EventCenter.eventBus.on<AObjectForceChanged>().listen((event) {
        // _focusNode.requestFocus();
        // print("ref changed");
        if (event?.obj == current){
          setState(() {
          });
        }
      });
    }
    else{
      _lis = EventCenter.eventBus.on<AObjectForceChanged>().listen((event) {
        // _focusNode.requestFocus();
        // print("ref changed");
        if (event?.obj == widget.object){

          setState(() {
          });
        }
      });
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (!bDelayed) {
    //   bDelayed = true;
    //   Future.delayed(Duration(milliseconds: 50)).then((value) {
    //     if (!bDisposed) {
    //       setState(() {
    //       });
    //     }
    //   });
    //   return Container();
    // }

    // print("obj build : ${widget.object?.guid}");
    // var obj = widget.object;//clazz.table.objects.firstWhere((element) => element.guid == initValue , orElse:()=>null);
    if (!widget.isStatic){
      current = widget.object;
    }

    var obj = current;
    var clazz = widget.clazz;// obj?.getClazz();
    if (obj != null && obj.isDeleted) obj = null;

    if (obj == null && widget.isStatic && widget.editMode){
      for(int i = 0 ; i <widget.clazz.table.objects.length ;++i){
        obj = widget.clazz.table.objects[i];
        if (!obj.isComment) break;
      }
      // if (widget.clazz.table.objects.length>0) {
      //   obj = widget.clazz.table.objects[0];
      // }
    }
    Widget objView ;

    // if (widget.object.isComment){
    //   var r = obj.getClazz().getObjectRect();
    //   objView = Container(
    //     width: r.width,
    //     height: r.height,
    //     child: Text(obj.comment??""),
    //   );
    // }
    // else
    {
      // var aObjView = AObjectV
      if (obj != null) {
        var r = obj.getClazz().getObjectRect();
        if (obj.isComment){
          if (!bEditComment) {
            objView = Container(
              alignment: widget.isStatic ? null : Alignment.centerLeft,
              width: r.width,
              height: r.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(obj.comment ?? "", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w400),),),
                  ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline ,color: Colors.blueAccent,
                    tooltip: "编辑注释",
                    onPressed: (){
                      setState(() {
                        bEditComment = true;
                      });
                    }
                  ),
                ],
              )
            );
          }
          else{
            objView = Container(
                alignment: widget.isStatic ? null : Alignment.centerLeft,
                width: r.width,
                height: r.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: TextEditor(
                      contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
                      // noUnderline: true,
                      textStyle: TextStyle(fontSize: 12),
                      maxLines: 1024,
                      initValue: obj.comment??"",
                      onChanged: (v){
                        obj.comment = v;
                      },
                      onSubmitted: (v){
                        obj.comment = v;
                        // setState(() {
                        //   obj.comment = v;
                        //   // bEditComment = false;
                        // });

                      },
                    ),),
                    ThemeCenter.iconBtn(MaterialCommunityIcons.hand_okay ,color: Colors.green,
                        tooltip: "完成",
                        onPressed: (){
                          setState(() {
                            bEditComment = false;
                            EventCenter.eventBus.fire(AObjectChanged()..obj = obj);
                          });
                        }
                    ),
                  ],
                )
            );
          }
        }
        else {
          var fieldWidgets = OTUtils.getCanvasObjectView(obj, withFrame: false, canvas: null, editMode: false);

          // r = Rect.fromLTRB(r.left - OTDefines.frameBorderSize, r.top - OTDefines.frameBorderSize , r.right+OTDefines.frameBorderSize, r.bottom+OTDefines.frameBorderSize);
          objView = Container(
            width: r.width,
            height: r.height,
            child: Stack(
                children: fieldWidgets
            ),
          );
        }
      }
      else{

        objView = Container();
      }
    }

    bool useSelector = (!widget.isStatic) && ((clazz.refable??true) || obj == null);

    Widget objW = objView;
    // if (!useSelector && !widget.isPublic && widget.object!= null){
    // // {
    //   objW = Row(
    //     children: [
    //       objView,
    //       Tooltip(
    //         child: Icon(MaterialCommunityIcons.comment, size: 20,
    //           color: DartCommon.isEmpty(widget.object?.comment)?Colors.grey:Colors.green,
    //         ),
    //         message: widget.object?.comment??"",
    //       ),
    //     ],
    //   );
    // }

    var content = Container(
      key: globalKey,
      child: Column(
        mainAxisAlignment: (!useSelector && !widget.isPublic)?MainAxisAlignment.center:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (useSelector) AObjectSelector(clz: widget.clazz, currentObjectGuid: obj==null?"":obj.guid ,// padding: EdgeInsets.fromLTRB(1,0 ,1,0),
            onChanged: (v) async {
              if (!DartCommon.isEmpty(v)) {
                widget.onSubmitted?.call(v);
              }
              else{
                widget.onSubmitted?.call("");
              }
            },
          ),
          if(widget.isPublic ||(widget.isStatic && widget.editMode)) objW,
          if (!useSelector && !widget.isPublic) InkWell(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child:ObjectTagView(
                  object: obj,
                  color: beOnHover?Colors.amberAccent:null,
                )),

              ],
            ),
            onHover: (b){
              setState(() {
                beOnHover = b;
              });
            },
            onTap: (){
              EventCenter.eventBus.fire(AObjectShowDetail()..obj = obj);
              TableUtiles.focusUnityObject(obj.guid);
            },
          ),
        ],
      ),
    );
    // if (widget.isStatic){
    //   return FadeIn(
    //     child: content,
    //     duration: Duration(milliseconds: 150),
    //     curve: Curves.easeIn,
    //   );
    //   return ShowUpAnimation(
    //     delayStart: Duration(seconds: 0),
    //     animationDuration: Duration(milliseconds: 3000),
    //     curve: Curves.linear,
    //     direction: Direction.vertical,
    //     offset: 0.1,
    //     child: content,
    //   );
    // }

    return content;
    // if (widget.isStatic) return content;
    // var rrr = Row(
    //   children: [
    //     Expanded(child: content,),
    //     Tooltip(
    //       child: Icon(MaterialCommunityIcons.comment, size: 20,
    //         color: DartCommon.isEmpty(widget.object?.comment)?Colors.grey:Colors.green,
    //       ),
    //       message: widget.object?.comment??"",
    //     ),
    //   ],
    // );
    // return rrr;
  }
}