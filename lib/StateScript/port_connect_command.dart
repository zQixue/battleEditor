//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/BreakPointType.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class PortConnectCommand extends StatefulWidget {
  final dynamic connection;
  final SSCanvasViewState graph;
  final dynamic onOpen;
  final dynamic onClose;
  PortConnectCommand({Key key, this.connection  , this.graph , this.onClose , this.onOpen}) : super(key: key);

  @override
  _PortConnectCommandState createState() => _PortConnectCommandState();
}

class _PortConnectCommandState extends State<PortConnectCommand> {
  var btnSize = 16.0;
  // bool isCommandOpen = false ;
  StreamSubscription<RefreshConnectCommandEvent> _lis;
  StreamSubscription<ChangeConnectLineColorEvent> _lis2;

  @override
  void dispose() {
    // TODO: implement dispose
    _lis?.cancel();
    _lis2?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    // isCommandOpen = widget.connection.guid == widget.globalOpenGuid;
    _lis2 = EventCenter.eventBus.on<ChangeConnectLineColorEvent>().listen((event) {
      setState(() {
        widget.connection.lineColor = event.color;
      });
    });
    _lis = EventCenter.eventBus.on<RefreshConnectCommandEvent>().listen((event) {
      if (event.globalRefresh??false){
        setState(() {

        });
        return;
      }
      if (event.refreshConnection == widget.connection) {
        // print("1 ${widget.connection.guid}");
        setState(() {
        });
      }
      if (event.targetNode != null) {
        var outNode = ScriptInfo.current.scriptData.nodeMap[widget.connection.outNodeGuid];
        var inNode = ScriptInfo.current.scriptData.nodeMap[widget.connection.inNodeGuid];
        if (outNode == event.targetNode || inNode == event.targetNode ){
          // print("2 ${widget.connection.guid}");
          setState(() {
          });
        }
      }


      // if (event.openChanged??false){
      //   var newState = event.openedPortConnection == widget.connection;
      //   if (newState != isCommandOpen){
      //     // print("3 ${widget.connection.guid}");
      //     setState(() {
      //       isCommandOpen = newState;
      //     });
      //   }
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (SSDefines.isInDagging){
    //   return Container();
    // }
    // print("rebuild ${widget.connection.guid}");
    dynamic c;
    dynamic con;
    StateScriptNode outNode , inNode;
    Offset pout;
    Offset pin;
    Offset p;
    bool bNormal = false;
    if (widget.connection is PortConnection){
      c = widget.connection;
      con = widget.connection;
      outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];
      if (outNode == null || inNode == null) return Positioned(left: 0,top:0,child: Container());
      pout = outNode.getOutPortPosition(c.outPortGuid);
      pin = inNode.getInPortPosition(c.inPortGuid);
      if (c.sopGuid != null && c.sopGuid.trim() != ""){
        var sopout = outNode.getOutPortPositionBySOP(c.sopGuid);
        if (sopout != null){
          pout = sopout;
        }
      }
      if (pout == null || pin == null) return Positioned(left: 0,top:0,child: Container());

      pout = Offset(pout.dx + con.outOffX + SSDefines.draw_port_line_off ,pout.dy) ;
      pin = Offset(pin.dx + con.inOffX - SSDefines.draw_port_line_off ,pin.dy) ;

      p = (pout + pin)/2;
      // bNormal = pout.dx <= pin.dx;
    }
    else {
      c = widget.connection;
      con = widget.connection;
      outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
      inNode = ScriptInfo.current.scriptData.nodeMap[c.inNodeGuid];
      if (outNode == null || inNode == null) return Positioned(left: 0,top:0,child: Container());
      pout = outNode.getOutParamPosition(c.outParamGuid);

      if (c.sopGuid != null && c.sopGuid.trim() != "") {
        var sopout = outNode.getOutParamPositionBySOP(c.sopGuid);
        if (sopout != null) {
          pout = sopout;
        }
      }

      pin = inNode.getInParamPosition(c.inParamGuid);
      if (pout == null || pin == null) return Positioned(left: 0,top:0,child: Container());
      pout = Offset(pout.dx + con.outOffX + SSDefines.draw_port_line_off ,pout.dy) ;
      pin = Offset(pin.dx + con.inOffX - SSDefines.draw_port_line_off ,pin.dy) ;
      p = (pout + pin) / 2;
      // bNormal = pout.dx <= pin.dx;
    }




      double size = btnSize;
      var dc = new BoxDecoration(
        borderRadius: new BorderRadius.circular((90.0)),
        color: Colors.white70,
      );
      // return Positioned(
      //   left: p.dx -size/2,
      //   top: p.dy -size/2 + (bNormal?0.0:c.offY??0),
      //   child: Container(width: 40, height: 40,color: Colors.blue,),
      // );
    final offStep = 8.0;
      var pos = Positioned(
        left: p.dx -size/2,
        top: p.dy -size/2 + (bNormal?0.0:c.offY??0),
        child: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          onPanStart: (e){
            if(bNormal) return;
            c.downPointer = e.globalPosition;
            c.downOffY = c.offY;
          },
          onPanUpdate: (e){
            if(bNormal) return;
            setState(() {
              var off = e.globalPosition - c.downPointer;
              off = widget.graph.global2LocalDelta(off);
              c.offY = ((c.downOffY + off.dy)/offStep).floor() * offStep;

              if ((c.offY + p.dy - pout.dy).abs() < SSDefines.portSize){
                c.offY = pout.dy - p.dy;
              }
              else if ((c.offY+ p.dy - pin.dy).abs() < SSDefines.portSize){
                c.offY = pin.dy- p.dy;
              }
              else{
                var finalY = c.downOffY + c.offY;
                finalY = (finalY/offStep).floor() * offStep;
                c.offY = finalY - c.downOffY;
              }
              // print("----- off y ${c.offY}");
              EventCenter.eventBus.fire(RefreshConnectCommandEvent()..refreshConnection = con);
              EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
            });

          },
          onPanEnd: (e){
            if(bNormal) return;
            EventCenter.eventBus.fire(RefreshConnectCommandEvent()..refreshConnection = con);
          },

          // onTap: (){
          //   setState(() {
          //     if (isCommandOpen){
          //       widget.onClose?.call();
          //       EventCenter.eventBus.fire(RefreshConnectCommandEvent()..openedPortConnection = null..openChanged = true);
          //     }
          //     else{
          //       widget.onOpen?.call(c.guid);
          //       EventCenter.eventBus.fire(RefreshConnectCommandEvent()..openedPortConnection = c..openChanged = true);
          //     }
          //   });
          //
          // },
          // onDoubleTap: (){
          //
          // },
          child: Container(
            decoration: dc,
            padding: EdgeInsets.all(0),
            // color: Colors.green,
            width: size*((con.offY != null && con.offY != 0.0)?4:3), height: size,
            child:Row(
              children: [
                // Container(width:btnSize,height:btnSize,child:IconButton(
                //   icon : Icon(MaterialCommunityIcons.close_circle),
                //   color: Colors.red,
                //   padding: EdgeInsets.all(0),
                //   iconSize: btnSize,
                //   tooltip: "关闭",
                //   onPressed: (){
                //     setState(() {
                //       widget.onClose?.call();
                //       EventCenter.eventBus.fire(RefreshConnectCommandEvent()..openedPortConnection = null..openChanged = true);
                //     });
                //   },
                // )),
                Container(width:btnSize,height:btnSize,child:IconButton(
                  icon : Icon(MaterialCommunityIcons.minus_circle),
                  color: Colors.red,
                  padding: EdgeInsets.all(0),
                  tooltip: "删除连线",
                  iconSize: btnSize,
                  onPressed: (){
                    setState(() {
                      setState(() {
                        HistoryManager.scriptHistory.appendHistory();
                        if (con is PortConnection)
                          ScriptInfo.current.scriptData.removePortConnection(c);
                        else
                          ScriptInfo.current.scriptData.removeParamConnection(c);
                      });
                    });
                  },
                )),
                if (con.offY != null && con.offY != 0.0)Container(width:btnSize,height:btnSize,child:IconButton(
                  icon : Icon(MaterialCommunityIcons.lock_reset),
                  color: Colors.red,
                  padding: EdgeInsets.all(0),
                  tooltip: "偏移复位",
                  iconSize: btnSize,
                  onPressed: (){
                    setState(() {
                      con.offY = 0.0;
                      EventCenter.eventBus.fire(RefreshConnectCommandEvent()..refreshConnection = con);
                      EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                    });
                  },
                )),
                // Container(width:btnSize,height:btnSize,child:IconButton(
                //   icon : Icon(MaterialCommunityIcons.palette),
                //   color: Colors.blue,
                //   padding: EdgeInsets.all(0),
                //   tooltip: "配色",
                //   iconSize: btnSize,
                //   onPressed: (){
                //     setState(() {
                //       con.offY = 0.0;
                //       EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                //     });
                //   },
                // )),

                CustomPopupMenu(
                  child: Icon(MaterialCommunityIcons.palette,size: size, color: Colors.deepPurpleAccent,),
                  menuBuilder:   () {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: 160,
                        color: const Color(0xFF2C2C2C),
                        child: GridView.count(
                          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          crossAxisCount: 5,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: line_colors.map((item) => ThemeCenter.iconBtn(
                              MaterialCommunityIcons.square,
                              width: 24 , height: 24,
                              color: item,
                              onPressed: (){
                                con.lineColor = item.value;
                                EventCenter.eventBus.fire(ChangeConnectLineColorEvent()..color =item.value );
                                EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                                setState(() {

                                });
                              }
                          )).toList(),
                        ),
                      ),
                    );
                  },
                  barrierColor: Colors.transparent,
                  pressType: PressType.singleClick,
                    horizontalMargin: -5,
                  // verticalMargin: 25,
                ),

                Container(width:btnSize,height:btnSize,child:IconButton(
                  icon : Icon(MaterialCommunityIcons.alpha_b_circle),
                  color: (widget.connection.enableBreakPoint??false)?Colors.brown : Colors.grey,
                  padding: EdgeInsets.all(0),
                  tooltip: (widget.connection.enableBreakPoint??false) ? "关闭断点":"打开断点",
                  iconSize: btnSize,
                  onPressed: (){
                    setState(() {
                      HistoryManager.scriptHistory.appendHistory();
                      widget.connection.enableBreakPoint = !(widget.connection.enableBreakPoint??false);
                      EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                      if (RunSession.instance.remoteIsPlaying){
                        //通知unity
                        var script = ScriptInfo.current.scriptData;
                        bool isPort = widget.connection is PortConnection;
                        if (script!=null) {
                          var bpKey = "${script.exportId}_${isPort?BreakPointType.BPT_PORT_CONNECTION:BreakPointType.BPT_PARAM_CONNECTION}_${widget.connection.getConnectionId(script)}";
                          if (widget.connection.enableBreakPoint) {
                            RunSession.instance.sendAddBreakPoint(bpKey);
                          }
                          else{
                            RunSession.instance.sendRemoveBreakPoint(bpKey);
                          }
                        }
                      }
                    });
                  },
                )),
              ],
            ),

          ),
        ) ,

      );
      return pos;
  }



  List<ItemModel> menuItems = [
    ItemModel('复制', Icons.content_copy),
    ItemModel('转发', Icons.send),
    ItemModel('收藏', Icons.collections),
    ItemModel('删除', Icons.delete),
    ItemModel('多选', Icons.playlist_add_check),
    ItemModel('引用', Icons.format_quote),
    ItemModel('提醒', Icons.add_alert),
    ItemModel('搜一搜', Icons.search),
  ];

  static var line_colors = [Color(0xFFCC9999),  Color(0xFF666699),
    Color(0xFF0099CC),
    Color(0xFFCCCC99), Color(0xFFCC3399), Color(0xFF99CC00),
    Color(0xFFFF6666),  Color(0xFF3399CC),
    Color(0xFFCC6600), Color(0xFF999999),
    Color(0xFFFFFFCC), Color(0xFF009933),
    Color(0xFF0099CC), Color(0xFFCCCCCC), Color(0xFFFF6666),
    Color(0xFFFF6600), Color(0xFF009966),
    Color(0xFFCC6633), Color(0xFFCC6600),
    Color(0xFFCC0066), Color(0xFF009999),
    Color(0xFF6699CC), Color(0xFF663366), Color(0xFFCCCC99),
    Color(0xFF990033), Color(0xFFCCFF66), Color(0xFFFF9900),
    Color(0xFF666699), Color(0xFF660033), Color(0xFF99CC99),
    Color(0xFF663300),
    Color(0xFF990033), Color(0xFF006633),
    Color(0xFF660033), Color(0xFF999933), Color(0xFF660099),
    Color(0xFF993366), Color(0xFF666633),
    Color(0xFF996600), Color(0xFF666600),
    Color(0xFF009933), Color(0xFFCC9900), Color(0xFF666666),
    Color(0xFF666633),  Color(0xFFCC3366)];
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}