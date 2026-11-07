//@dart=2.11
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/common/int_editor.dart';
import 'package:battlepus/common/text_editor.dart';

typedef void FunctionOnInterfaceDelete(ModuleInterface mi);
typedef Offset FunctionOnGetInterfacePosition();
class ModuleInterfaceView extends StatefulWidget {
  final StateScriptNode node;
  // final Offset position;
  final SSCanvasViewState graph;
  final bool isRight;
  final ModuleInterface interface;
  final FunctionOnInterfaceDelete onDelete;
  final FunctionOnGetInterfacePosition onGetPosition;

  ModuleInterfaceView({Key key , this.node,this.graph ,this.isRight , this.interface , this.onDelete , this.onGetPosition }) : super(key: key);

  @override
  _ModuleInterfaceViewState createState() => _ModuleInterfaceViewState();
}

class _ModuleInterfaceViewState extends State<ModuleInterfaceView> {
  StreamSubscription<ModuleInterfaceRefreshEvent> _lis;

  // bool isOpen = false;
  // Offset position;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    // position = widget.position;
    super.initState();

    _lis = EventCenter.eventBus.on<ModuleInterfaceRefreshEvent>().listen((event) {
      if (event.mi == widget.interface) {
        setState(() {
          // position = event.position;
        });
      }
    });
  }
  Offset m_dragStartPoint;
  Offset m_startPoint;
  @override
  Widget build(BuildContext context) {
    double fullHeight = 20;////SSDefines.portSize + 2;
    // double fullWidth = widget.interface.isOpen?120:48;
    double lineWidth = 1.5;
    var position = widget?.onGetPosition()??Offset(0,0);
    var dc = new BoxDecoration(
        // border: Border(
        //   // top: Divider.createBorderSide(context, color: Colors.blueAccent, width: 1),
        //   bottom: Divider.createBorderSide(context, color: Colors.lightGreen, width: lineWidth),
        // )
    );
    // var wds = [
    //   Expanded(child:TextEditor(
    //     initValue: widget.interface.name,
    //     textStyle: TextStyle(fontSize: 12 ,color: Colors.white),
    //     maxLines: 1,
    //     // isDense: true,
    //     // contentPadding : EdgeInsets.only(bottom: 0),
    //     onChanged: (v){
    //       widget.interface.name = v;
    //     },
    //   )),
    //   InkWell(
    //     child: Icon(AntDesign.delete , size: 14,color: Colors.red,),
    //     onTap: (){
    //       // setState(() {
    //         if (ScriptInfo.current == null || ScriptInfo.current.scriptData == null) return ;
    //         ScriptInfo.current.scriptData.unregisterInterface(widget.interface);
    //         widget.onDelete?.call(widget.interface);
    //       // });
    //     },
    //   ),
    //   InkWell(
    //     child: Icon(AntDesign.closesquareo , size: 14,color: Colors.indigo,),
    //     onTap: (){
    //       setState(() {
    //         widget.interface.isOpen = !widget.interface.isOpen;
    //       });
    //     },
    //   ),
    //   SizedBox(width: 20,),
    // ];
    double x = widget.interface.x ;

    if (x == null ) x = widget.node.x + (widget.isRight?(widget.node.getWidth() + 50):-60);
    double y = widget.interface.y ;// position.dy - fullHeight - 5 ;
    if (y == null ) y = position.dy - fullHeight - 5 ;
    return Positioned(
      left: x,//widget.node.x + x,
      top: y,//position.dy - fullHeight - 5,
      child: GestureDetector(
        dragStartBehavior : DragStartBehavior.down,
        onPanStart: (e){
          m_dragStartPoint = e.globalPosition;
          m_startPoint = Offset(x , y);
        },
        onPanUpdate: (e){
          if (m_startPoint == null || m_dragStartPoint == null) return ;
          setState(() {
            var off = e.globalPosition - m_dragStartPoint??Offset.zero;
            off = global2LocalDelta(off);
            widget.interface.x = m_startPoint.dx + off.dx;
            widget.interface.y = m_startPoint.dy + off.dy;

            EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
          });
        },
        child: Row(
          children: [

            Container(
              // padding: EdgeInsets.all(0),
              height: fullHeight,
              // width: fullWidth,
              decoration: dc,
              alignment: Alignment.bottomRight,//widget.isRight?Alignment.bottomRight:Alignment.bottomLeft,
              child : InkWell(
                child: Icon(MaterialCommunityIcons.import , size: 16,color: Colors.green,),
                onTap: (){
                  showDialog(
                    context: context,
                    // barrierDismissible: false,
                    builder: (BuildContext context) {
                      var child = Container(
                        padding: EdgeInsets.all(8),
                        width: 100,
                        height: 200,
                        child: getDetail(),
                      );
                      return Dialog(child: child);
                    },
                  ).then((value){
                    setState(() {

                    });
                  });

                },
              ),
            ),
            Text(DartCommon.isEmpty(widget.interface.name)?widget.node.getInterface(widget.interface)?.name??"": widget.interface.name, style: TextStyle(color: Colors.green ,fontSize: 12),),
          ],
        ),
      ),


    );
  }
  Offset global2LocalDelta(Offset offset){
    var scale = ZoomState.current.getScale();
//    RenderBox getBox = context.findRenderObject();
//    var local = getBox.globalToLocal(offset);
    return offset / scale;
  }

  Widget getDetail(){
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextEditor(
            hint : "接口名",
            initValue: widget.interface.name,
            // textStyle: TextStyle(fontSize: 12),
            maxLines: 1,
            // isDense: true,
            // contentPadding : EdgeInsets.only(bottom: 0),
            onChanged: (v){
              widget.interface.name = v;
              // ScriptInfo.current?.scriptData?.buildValidInterface();
            },
          ),
          SizedBox(height:16),
          IntEditor(
            hint: "优先级",
            initValue: widget.interface.prio??512,
            // textStyle: TextStyle(fontSize: 12),
            // maxLines: 1,
            // isDense: true,
            // contentPadding : EdgeInsets.only(bottom: 0),
            onChanged: (v){
              widget.interface.prio = v;
              // ScriptInfo.current?.scriptData?.buildValidInterface();
            },
          ),
          SizedBox(height:16),
          ElevatedButton(
            child: Text("删除"),
            onPressed: (){
              if (ScriptInfo.current == null || ScriptInfo.current.scriptData == null) return ;
              // ScriptInfo.current.scriptData.unregisterInterface(widget.interface);
              widget.interface.ownerNode.moduleInterfaces.remove(widget.interface.interfaceGuid);
              widget.onDelete?.call(widget.interface);
              // ScriptInfo.current?.scriptData?.buildValidInterface();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}