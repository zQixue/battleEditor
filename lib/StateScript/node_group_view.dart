//@dart=2.11
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/NodeGroup.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/common/text_editor.dart';

class NodeGroupView extends StatefulWidget {
  final NodeGroup group;
  final SSCanvasViewState graph;
  NodeGroupView({Key key , this.group , this.graph}) : super(key: key);

  @override
  _NodeGroupViewState createState() => _NodeGroupViewState();
}

class _NodeGroupViewState extends State<NodeGroupView> {

  StreamSubscription<GroupRefreshEvent> _lis;

  bool _storeHistory = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _lis?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _lis = EventCenter.eventBus.on<GroupRefreshEvent>().listen((event) {
      if (widget.group.guid == event.guid){
        setState(() {
        });
      }

    });
    super.initState();
  }
  Offset _downPointer = Offset.zero;
  void dragStorePos(e){
    _downPointer = e.globalPosition;
    var nodes = ScriptInfo.current.scriptData.nodes;
    nodeMap.clear();
    for(var n in nodes){
      if (n.group == widget.group.guid){
        n.downPointer = e.globalPosition;
        n.downStorePos = Offset(n.x , n.y);
        nodeMap[n.guid] = n;
      }
      for(var sop in n.soports){
        sop.downStorePos = Offset(sop.x , sop.y);
      }
      for(var sop in n.sops){
        sop.downStorePos = Offset(sop.x , sop.y);
      }
    }

    var paramConnections = ScriptInfo.current.scriptData.paramConnections;
    for(var c in paramConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOP(c.sopGuid);
        if (sop != null) {
          sop.downStorePos = Offset(sop.x , sop.y);
        }
      }
    }

    var portConnections = ScriptInfo.current.scriptData.portConnections;
    for(var c in portConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOPort(c.sopGuid);
        if (sop != null) {
          sop.downStorePos = Offset(sop.x , sop.y);
        }
      }
    }
  }

  Map<String,StateScriptNode> nodeMap = Map<String,StateScriptNode>();
  void dragUpdatePos(DragUpdateDetails e , SSCanvasViewState graph){
      var off = e.globalPosition - _downPointer??Offset.zero;
      off = graph.global2LocalDelta(off);
      // EventCenter.eventBus.fire(NodeDescRefreshEvent());
      var nodes = nodeMap.values;//ScriptInfo.current.scriptData.nodes;
      // nodeMap.clear();
      for(var n in nodes){
        if (n.group == widget.group.guid){
          n.x = n.downStorePos.dx + off.dx;
          n.y = n.downStorePos.dy + off.dy;
          // nodeMap[n.guid] = true;
          // EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n);
          // EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);


          for(var sop in n.soports){
            if (n.group == widget.group.guid){
              var pos = Offset(sop.x,sop.y);
              // pos = graph.fixPosition(pos);
              sop.x = pos.dx;
              sop.y = pos.dy;

              // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
            }
          }
          for(var sop in n.sops){
            if (n.group == widget.group.guid){
              var pos = Offset(sop.x,sop.y);
              // pos = graph.fixPosition(pos);
              sop.x = pos.dx;
              sop.y = pos.dy;

              // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
            }
          }
        }
      }

    var paramConnections = ScriptInfo.current.scriptData.paramConnections;
    for(var c in paramConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOP(c.sopGuid);
        if (sop != null) {
          sop.x = sop.downStorePos.dx + off.dx;
          sop.y = sop.downStorePos.dy + off.dy;
          // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
        }
      }
    }

    var portConnections = ScriptInfo.current.scriptData.portConnections;
    for(var c in portConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOPort(c.sopGuid);
        if (sop != null) {
          sop.x = sop.downStorePos.dx + off.dx;
          sop.y = sop.downStorePos.dy + off.dy;
          // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
        }
      }
    }

    // widget.node.x = widget.node.downStorePos.dx + off.dx;
    // widget.node.y = widget.node.downStorePos.dy + off.dy;
    // EventCenter.eventBus.fire(RefreshConnectCommandEvent());
  }


  void sendDragUpdatePosEvent(){

    var nodes = nodeMap.values;//ScriptInfo.current.scriptData.nodes;
    // nodeMap.clear();
    for(var n in nodes){
      if (n.group == widget.group.guid){
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n..posChanged = true);
        EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);


        for(var sop in n.soports){
          if (n.group == widget.group.guid){
            EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
          }
        }
        for(var sop in n.sops){
          if (n.group == widget.group.guid){
            EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
          }
        }
      }
    }

    var paramConnections = ScriptInfo.current.scriptData.paramConnections;
    for(var c in paramConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOP(c.sopGuid);
        if (sop != null) {
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
        }
      }
    }

    var portConnections = ScriptInfo.current.scriptData.portConnections;
    for(var c in portConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOPort(c.sopGuid);
        if (sop != null) {
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
        }
      }
    }

  }

  void dragEndPos(DragEndDetails e , SSCanvasViewState graph){
    // var off = e.globalPosition - _downPointer??Offset.zero;
    // off = graph.global2LocalDelta(off);

    var nodes = nodeMap.values;//ScriptInfo.current.scriptData.nodes;
    for(var n in nodes){
      bool bingo = false;
      if (n.group == widget.group.guid){
        var pos = Offset(n.x,n.y);
        pos = graph.fixPosition(pos);
        n.x = pos.dx;
        n.y = pos.dy;
        bingo = true;
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n);
        EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);

        for(var sop in n.soports){
          if (n.group == widget.group.guid){
            var pos = Offset(sop.x,sop.y);
            pos = graph.fixPosition(pos);
            sop.x = pos.dx;
            sop.y = pos.dy;
            bingo = true;
            EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
          }
        }
        for(var sop in n.sops){
          if (n.group == widget.group.guid){
            var pos = Offset(sop.x,sop.y);
            pos = graph.fixPosition(pos);
            sop.x = pos.dx;
            sop.y = pos.dy;
            bingo = true;
            EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
          }
        }

      }


      if (bingo) EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = n);
    }

    var paramConnections = ScriptInfo.current.scriptData.paramConnections;
    for(var c in paramConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOP(c.sopGuid);
        if (sop != null) {
          var pos = Offset(sop.x,sop.y);
          pos = graph.fixPosition(pos);
          sop.x = pos.dx;
          sop.y = pos.dy;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
        }
      }
    }

    var portConnections = ScriptInfo.current.scriptData.portConnections;
    for(var c in portConnections) {
      if (c.sopGuid != null && c.sopGuid.trim() != "" && nodeMap.containsKey(c.inNodeGuid)){
        var outNode = ScriptInfo.current.scriptData.nodeMap[c.outNodeGuid];
        var sop = outNode.getSOPort(c.sopGuid);
        if (sop != null) {
          var pos = Offset(sop.x,sop.y);
          pos = graph.fixPosition(pos);
          sop.x = pos.dx;
          sop.y = pos.dy;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
        }
      }
    }
  }

  Timer _darggingEventTimer ;
  @override
  Widget build(BuildContext context) {
    var rect = widget.group.getRect();
    if (rect == null){
      return null;
    }
    // var scale = ZoomState.current.getScale();
    var c = widget.group.backgroundColor??Colors.blueAccent.value;
    var _dc = new BoxDecoration(
      border: new Border.all(color: CommonUtil.alphaColor(Color(c),200), width: 2), // 边色与边宽度
      // color: CommonUtil.alphaColor(Color(c),120),
      color:  CommonUtil.changeColorLightness(CommonUtil.alphaColor(Color(c),120), 0.2),
    ); // 圆角度
    // var foregroundColor = Color(c).computeLuminance() > 0.5 ? Colors.black : Colors.yellow;
    var _nameEdt = TextEditor(

      initValue: widget.group.name??"",
      textStyle: TextStyle(color: Colors.white),
      forceRebuild: false,
      onChanged: (v){
        var groupId = widget.group.guid;
        var old = widget.group.name;
        HistoryManager.scriptHistory.appendCallbackHistory("$groupId",
                (){
              // setState(() {
              if (ScriptInfo.current!=null && ScriptInfo.current.scriptData!= null){
                var group = ScriptInfo.current.scriptData.getGroup(groupId);
                if (group != null) {
                  print("revert $old");
                  widget.group.name = old;
                  EventCenter.eventBus.fire(GroupRefreshEvent()..guid = groupId);
                }
              }
              // });
            },
                (){
              // setState(() {
                  if (ScriptInfo.current!=null && ScriptInfo.current.scriptData!= null){
                    var group = ScriptInfo.current.scriptData.getGroup(groupId);
                    if (group != null) {
                      widget.group.name = v;
                      EventCenter.eventBus.fire(GroupRefreshEvent()..guid = groupId);
                    }
                  }
              // });
            });

        widget.group.name = v;
      },
      onSubmitted: (v){
        setState(() {
          widget.group.inEditName = false;
        });

      },
    );
    var normal = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: _dc,
      width: rect.width,
      height : rect.height,

      child: Column(
        children: [
          GestureDetector(
            child :Container(
              padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
              height: 30,
              color:Colors.black,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(!widget.group.inEditName?MaterialCommunityIcons.square_edit_outline:MaterialCommunityIcons.close_box_outline),
                      color: !widget.group.inEditName?Colors.greenAccent:Colors.redAccent,
                      iconSize: 24,
                      onPressed: (){
                        setState(() {
                          widget.group.inEditName = !widget.group.inEditName;
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child: widget.group.inEditName?_nameEdt:Text(widget.group.name??"",style: TextStyle(fontSize: 17, color: Colors.white),)
                  ),
                  Container(
                    width: 24,
                    height: 22,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(Ionicons.md_color_palette),
                      color: Colors.yellow,
                      iconSize: 23,
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder:(context)=> AlertDialog(
                            title: const Text('选择颜色!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: Color(widget.group.backgroundColor),
                                onColorChanged: (clr){
                                  HistoryManager.scriptHistory.appendHistory();
                                  widget.group.backgroundColor = clr.value;
                                },
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('确定'),
                                onPressed: () {
                                  setState(() {
                                    EventCenter.eventBus.fire(GlobalRefreshEvent());
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                        EventCenter.eventBus.fire(GlobalRefreshEvent());
                      },
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(MaterialCommunityIcons.minus_box),
                      color: Colors.redAccent,
                      iconSize: 24,
                      onPressed: (){
                        HistoryManager.scriptHistory.appendHistory();
                        widget.group.doRemove();
                        EventCenter.eventBus.fire(GlobalRefreshEvent());
                      },
                    ),
                  ),

                ],
              ),
            ),
            onTapDown: (e) {
              print("start");
              // dragStorePos(e);
              _storeHistory = false;
            },
            onPanStart: (e){
              // _downPointer = e.globalPosition;
              SSDefines.isInDagging = true;
              EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
              EventCenter.eventBus.fire(LocationFlagEvent()..scale = 100);
              dragStorePos(e);
            },
            onPanUpdate: (e){
              SSDefines.isInDagging = true;
              setState(() {
                if (!_storeHistory) {
                  HistoryManager.scriptHistory.appendHistory();
                  _storeHistory = true;
                }
                dragUpdatePos(e , widget.graph);
                EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
                if (_darggingEventTimer == null){
                  sendDragUpdatePosEvent();
                  _darggingEventTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
                    sendDragUpdatePosEvent();
                  });
                }

              });
            },
            onPanEnd: (e){

              setState(() {
                dragEndPos(e , widget.graph);
              });
              SSDefines.isInDagging = false;
              EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
              EventCenter.eventBus.fire(LocationFlagEvent()..scale = ZoomState.current.getScale());
              if (_darggingEventTimer != null){
                _darggingEventTimer.cancel();
                _darggingEventTimer = null;
              }

            },
          ),


          // scale < 0.2? Text(widget.group.getTypeShowString(),
          //   style:TextStyle(fontSize: 100 , fontWeight: FontWeight.w900)
          // ) :Container(),
        ],
      )
    );

    return Positioned(
        left: rect.left,//- SSDefines.portOffX ,
        top: rect.top,
        child: normal
    );
  }
}