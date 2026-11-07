//@dart=2.11
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyList.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_editor.dart';
import 'package:battlepus/CodeBlocky/local_fields_view.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/history_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/EventCenter.dart' as ENC;

class FunctionEditor extends StatefulWidget {
  final CBFunction function;
  FunctionEditor({Key key , this.function }) : super(key: key);

  @override
  _FunctionEditorState createState() => _FunctionEditorState();
}
enum RightState{
  None,
  Bin,
  Templates
}
class _FunctionEditorState extends State<FunctionEditor> {

  ScrollController _scrollController;
  FocusNode _focusNode;
  // bool _binOpened = false;
  RightState rightState = RightState.None;

  StreamSubscription<ENC.KeyEvent> _lis4;
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController?.dispose();
    _focusNode?.dispose();
    _lis4?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    FocusManager.instance.addListener(() {
      // print(FocusManager.instance.primaryFocus.toString());
      if (FocusManager.instance.primaryFocus is FocusScopeNode){
        _focusNode.requestFocus();
      }
    });




    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    _lis4 = ENC.EventCenter.eventBus.on<ENC.KeyEvent>().listen((event) {
      if (event.key == LogicalKeyboardKey.f3) {
        setState(() {
          rightState = rightState == RightState.Bin?RightState.None:RightState.Bin;
        });
      }

      if (event.key == LogicalKeyboardKey.f4) {
        setState(() {
          rightState = rightState == RightState.Templates?RightState.None:RightState.Templates;
        });
      }

      if ((event.event.isControlPressed && event.event.isShiftPressed && event.key == LogicalKeyboardKey.keyZ)) {
        setState(() {
          print("function redo");
          HistoryManager.functionHistory.redo();
        });
      }
      else if ((event.event.isControlPressed && event.key == LogicalKeyboardKey.keyZ)) {
        setState(() {
          print("function undo");
          HistoryManager.functionHistory.undo();
        });
      }

    });
    super.initState();
  }

  void checkSetHistory(){
    var record = (){
      var obj = widget.function;
      if (obj is CBFunction){
        JsonEncoder encoder = new JsonEncoder();
        String json = encoder.convert(obj);
        var full = {};
        full["data"] = json;
        var blocks = obj.getBlockiesList();
        if (blocks != null) {
          full["blocks"] = encoder.convert(blocks);
        }
        var bin = obj.getBinList();
        if (bin != null) {
          full["bin"] = encoder.convert(bin);
        }
        return full;
      }
    };
    var undo = (m){
      if (m != null){
        JsonDecoder decoder = new JsonDecoder();
        var obj = CBFunction.fromJson(decoder.convert(m["data"]));
        if (obj != null) {
          setState(() {
            if (m["blocks"]!= null) {
              obj.setBlockiesList(BlockyList.fromJson(decoder.convert(m["blocks"])));
            }
            if (m["bin"]!= null) {
              obj.setBinList(BlockyList.fromJson(decoder.convert(m["bin"])));
            }

            widget.function.copy(obj);
          });
        }

      }
    };
    if (widget.function.history != null){
      widget.function.history.setCallback(record , undo );
      HistoryManager.functionHistory = widget.function.history ;
    }
    else{
      HistoryManager.functionHistory = HistoryManager(record , undo );
      widget.function.history = HistoryManager.functionHistory;
    }
    // HistoryManager.functionHistory = widget.function.history ?? HistoryManager(
    //         (){
    //       var obj = widget.function;
    //       if (obj is CBFunction){
    //         JsonEncoder encoder = new JsonEncoder();
    //         String json = encoder.convert(obj);
    //         var full = {};
    //         full["data"] = json;
    //         var blocks = obj.getBlockiesList();
    //         if (blocks != null) {
    //           full["blocks"] = encoder.convert(blocks);
    //         }
    //         var bin = obj.getBinList();
    //         if (bin != null) {
    //           full["bin"] = encoder.convert(bin);
    //         }
    //         return full;
    //       }
    //     },
    //         (m){
    //       if (m != null){
    //         JsonDecoder decoder = new JsonDecoder();
    //         var obj = CBFunction.fromJson(decoder.convert(m["data"]));
    //         if (obj != null) {
    //           setState(() {
    //             if (m["blocks"]!= null) {
    //               obj.setBlockiesList(BlockyList.fromJson(decoder.convert(m["blocks"])));
    //             }
    //             if (m["bin"]!= null) {
    //               obj.setBinList(BlockyList.fromJson(decoder.convert(m["bin"])));
    //             }
    //
    //             widget.function.copy(obj);
    //           });
    //         }
    //
    //       }
    //     }
    // );

    // widget.function.history = HistoryManager.functionHistory;
  }
  Widget getWidgetBlock(String str , Color color , Widget child , {List<Widget> actions}){
    var dc2 = new BoxDecoration(
      border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
      color: color,//Color(widget.node.getNodeStructType().bgColor),
      // borderRadius: new BorderRadius.circular((5.0))
    );

    var header = Container(
      height :40,
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      decoration: dc2,
      child: Row(
          children:[
            Expanded(child:Text(str)),
            actions!= null?Row(children: actions,):SizedBox(width: 0,),
          ]),
    );
//    var dc3 = new BoxDecoration(
//      border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
//
//      // borderRadius: new BorderRadius.circular((5.0))
//    );
    return Column(
      children: [
        header,
        Expanded(child : child)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    CodeBlocky.curentFunction = widget.function;

    checkSetHistory();
    // return Container(
    //   child: getBlockView(),
    // );
    var main = Container(
      // decoration: dc1,
      child: BlockyEditor(func : widget.function,blockiesContainer: widget.function.getBlockiesList(),
        addCallback: (cb){
          setState(() {
          });
        },
      ),
    );

    var bin = Container(
      decoration: dc1,
      child: BlockyEditor(blockiesContainer: widget.function.getBinList(),onlyBlock: false,
        addCallback: (cb){
          setState(() {
          });
        },
      ),
    );

    var temp = Container(
      decoration: dc1,
      child: BlockyEditor(blockiesContainer: StateScriptProject.instance.shareCodeBlockyTemplates,onlyBlock: false,
        addCallback: (cb){
          setState(() {
          });
        },
      ),
    );
    var row = Row(
      children: [
        // Expanded( flex : 2 , child :ThemeCenter.block(
        //   headTitle: "语句块",
        //   headHeight:40,
        //   child: getTypeListBar(),
        //   // CommonUtil.scaleColor(Colors.grey , 0.3) , getTypeListBar()
        // )),
        SizedBox(width: 4,),
        // getBlockView(),
        Expanded( flex : 14 , child: Row(
          children: [
            Expanded( flex : 14 , child : ThemeCenter.block(
                headTitle: "函数体", child: main ,
                headHeight:40,
                actions: [
                  HistoryView(manager: HistoryManager.functionHistory),
                  SizedBox(width: 2,),
                ])),
            SizedBox(width: rightState == RightState.Bin?4:0,),
            rightState == RightState.Bin?Expanded( flex : 8 , child: Column(
              children: [
                Expanded( flex : 10 , child : ThemeCenter.block(headTitle:"回收站" ,headHeight:40, child:bin , headStyle: TextStyle(color: Colors.redAccent , fontSize: 12) )),
                // Expanded( flex : 10 , child : ThemeCenter.block(headTitle:"模板库" ,headHeight:40, child:temp)),
                Expanded( flex : 1 , child : getRemoveArea()),
              ],
            )):SizedBox(width:0),
            SizedBox(width: rightState == RightState.Templates?4:0,),
            rightState == RightState.Templates?Expanded( flex : 8 , child: Column(
              children: [
                // Expanded( flex : 10 , child : ThemeCenter.block(headTitle:"回收站" ,headHeight:40, child:bin)),
                Expanded( flex : 10 , child : ThemeCenter.block(headTitle:"模板库" ,headHeight:40, child:temp, headStyle: TextStyle(color: Colors.green , fontSize: 12))),
                Expanded( flex : 1 , child : getRemoveArea()),
              ],
            )):SizedBox(width:0),
//              _binOpened?Expanded( flex : 8 , child : getWidgetBlock("回收站", CommonUtil.scaleColor(Colors.redAccent , 0.3) , bin)):SizedBox(width:0),
          ],
        ),),

        SizedBox(width: 4,),
        if(!widget.function.isAgent) Expanded( flex : 3 , child : Column(
          children: [
            if(!widget.function.isAgent) Expanded( flex : 4 , child : ThemeCenter.block(headTitle:"函数信息", headHeight:40, child:getFuncInfo())),
//              Expanded( flex : 5 , child : getWidgetBlock("函数信息", CommonUtil.scaleColor(Colors.grey , 0.3) , getFuncInfo())),
            if(!widget.function.isAgent) SizedBox(height: 4,),
            if(!widget.function.isAgent) Expanded( flex : 8 , child : ThemeCenter.block(headTitle:"参数列表", headHeight:40 , child:getParams())),
            if(!widget.function.isAgent) SizedBox(height: 4,),
            if(!widget.function.isAgent) Expanded( flex : 8 , child : ThemeCenter.block(headTitle:"本地变量", headHeight:40 , child : getLocalVars())),
            // Expanded( flex : 8 , child : getWidgetBlock("回收站", CommonUtil.scaleColor(Colors.grey , 0.3) , main)),
          ],
        ))
      ],
    );
    var con = Container(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          ThemeCenter.area(
            child: getTypeHList()
          ),
          // getTypeHListBar(),
          Expanded(
            child: row,
          )
        ],
      )
    );

//    _focusNode.requestFocus();
    return RawKeyboardListener(
      focusNode: _focusNode,

      onKey: _handleKeyEvent,
      child:con
    );
  }
  RawKeyEvent keyEvent;
  void _handleKeyEvent(RawKeyEvent value) {
    // print("jsjsjsjsj ${value}");
    KeyEventCenter.updateKeyState(value);
  }

  var dc1 = new BoxDecoration(
      border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
      // color: CommonUtil.scaleColor(Colors.indigo , 0.5),//Color(widget.node.getNodeStructType().bgColor),
      // borderRadius: new BorderRadius.circular((5.0))
  );
  Widget getTypeListBar() {
    return Container(
      decoration: dc1,
      padding: EdgeInsets.all(4),
      child :getTypeList(),
    );
  }

  Widget getTypeHListBar() {
    return Container(
      decoration: dc1,
      padding: EdgeInsets.all(4),
      child : getTypeHList(),
    );
  }
  Widget getParams() {

    var l = LocalFieldsView(function: widget.function, fields: widget.function.params , withDefault:false , blockyType: "___param___",);
    return Container(
      // padding: EdgeInsets.all(1),
      decoration: dc1,
      child: l,
    );
  }
  Widget getLocalVars() {

    var l = LocalFieldsView(function: widget.function,fields: widget.function.localFields,);
    return Container(
      // padding: EdgeInsets.all(1),
      decoration: dc1,
      child: l,
    );
  }

  Widget getFuncInfo(){
    var con = Container(
      padding: EdgeInsets.all(8),
      decoration: dc1,
      child: Column(
        children: [
          TextEditor(
            hint: "函数名",
            forceRebuild: true,
            initValue: widget.function.name,
            onChanged: (v){
              var old = widget.function.name;
              HistoryManager.functionHistory?.appendCallbackHistory("${widget.function.guid}_name",
                      (){
                        widget.function.name = old;
                  },
                      (){
                        widget.function.name = v;
                  });
//              setState(() {
                widget.function.name = v;
//              });
            },
            onSubmitted: (v){
              setState(() {
                widget.function.name = v;
              });
            },
          ),
          SizedBox(height: 4,),
          TextEditor(
            hint: "别名",
            forceRebuild: true,
            initValue: widget.function.alias,
            onChanged: (v){
              var old = widget.function.alias;
              HistoryManager.functionHistory?.appendCallbackHistory("${widget.function.guid}_alias",
                      (){
                    widget.function.alias = old;
                  },
                      (){
                    widget.function.alias = v;
                  });
                widget.function.alias = v;
//              });
            },
            onSubmitted: (v){
              setState(() {
                widget.function.alias = v;
              });
            },
          ),
          SizedBox(height: 4,),
          Row(
            children: [
              Text("是否有效"),
              Checkbox(
                value: widget.function.active,
                onChanged: (v){
                  setState(() {

                    var old = widget.function.active;
                    HistoryManager.functionHistory?.appendCallbackHistory("${widget.function.guid}_active",
                            (){
                          widget.function.active = old;
                        },
                            (){
                          widget.function.active = v;
                        });
                    widget.function.active = v;
                  });
                },
              )
            ],
          )
        ],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: con,
    );
  }
  Widget getTypeHList(){
    List<Widget> tpws = List<Widget>();
    var lst = CodeBlockyType.getTypes().values.toList()..sort((a,b){
      return a.typeFlag - b.typeFlag;
    });
    for(var tp in lst){
      if (widget.function.isAgent && (tp.flag & CodeBlockyType.FIELD_FLAG_AGENT_FUNC) ==0) continue ;
      if (!widget.function.isAgent && (tp.flag & CodeBlockyType.FIELD_FLAG_FUNC) ==0) continue ;

      if (tp.guid == "___expr___" && DartCommon.isEmpty(widget.function.extraParam)){
        continue;
      }
      var w = tp.doGetBlockWidget(null,null,widget.function);
      var lwcon = Container(
        child: Row(
          children: [w],
        ),
      );
      var lw = Tooltip(
        child: w,
        message: "${tp.getTypeShowString()}",
      );
      var db = Draggable(
        child: Material(child: lw),
        feedback: Material(child: Opacity(opacity : 0.6 , child :lw)),
        childWhenDragging: Material(child: lw),
        data:CodeBlocky()..blockyTypeId = tp.guid ..guid = null,
      );
      // tpws.add(SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //   child: db,
      // ));
      tpws.add(db);
      // tpws.add(Container(width:4));
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      direction : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      // controller: _scrollController,
      children: tpws,
    );
  }
  Widget getTypeList(){
    List<Widget> tpws = List<Widget>();
    for(var tp in CodeBlockyType.getTypes().values){
      if (widget.function.isAgent && (tp.flag & CodeBlockyType.FIELD_FLAG_AGENT_FUNC) ==0) continue ;
      if (!widget.function.isAgent && (tp.flag & CodeBlockyType.FIELD_FLAG_FUNC) ==0) continue ;

      if (tp.guid == "___expr___" && DartCommon.isEmpty(widget.function.extraParam)){
        continue;
      }
      var w = tp.doGetBlockWidget(null,null,widget.function);
      var lwcon = Container(
        child: Row(
          children: [w],
        ),
      );
      var lw = Tooltip(
        child: lwcon,
        message: "${tp.getTypeShowString()}",
      );
      var db = Draggable(
        child: Material(child: lw),
        feedback: Material(child: Opacity(opacity : 0.6 , child :lw)),
        childWhenDragging: Material(child: lw),
        data:CodeBlocky()..blockyTypeId = tp.guid ..guid = null,
      );
      tpws.add(SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: db,
      ));
      tpws.add(Container(height:4));
    }
    return ListView(
      controller: _scrollController,
      children: tpws,
    );
  }
  Color _mainBlockColor = Colors.white;

  Widget getRemoveArea() {
    var dc12 = new BoxDecoration(
      border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
      color:_mainBlockColor,
      // color: CommonUtil.scaleColor(Colors.indigo , 0.5),//Color(widget.node.getNodeStructType().bgColor),
      // borderRadius: new BorderRadius.circular((5.0))
    );
    var dtgt = DragTarget<CodeBlocky>(
      builder: (p1,p2,p3){
        return Container(
//          width: 100,
//          height: 100,
          decoration: dc12,
          padding: EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("拖到此处删除",  style: TextStyle(color: Colors.grey, fontSize: 20 , fontWeight: FontWeight.w600), ),

              IconButton(
                padding: EdgeInsets.all(0),
                iconSize: 28,
                color: Colors.redAccent,
                icon: Icon(MaterialCommunityIcons.close_box_multiple_outline),
                tooltip: "全部清空",
                onPressed: (){
                  setState(() {
                    HistoryManager.functionHistory.appendHistory();
                    print("###7");
                    widget.function.getBinList().getBlockies().clear();
                  });
                },
              ),
            ],
          )
        );

      },
      onWillAccept: (e){
        // var tp = CodeBlockyType.getType(e.blockyTypeId);
        // return tp != null && (tp.typeFlag & BlockyTypes.BT_BLOCK != 0);
        return true;
      },
      onLeave: (e){
        setState(() {
          _mainBlockColor = Colors.white;
        });
      },
      onMove: (e){
        if (_mainBlockColor == Colors.white) {
          setState(() {
            _mainBlockColor = CommonUtil.scaleColor(Colors.redAccent ,0.4);
          });
        }
      },
      onAcceptWithDetails: (e){
        setState(() {
          HistoryManager.functionHistory.appendHistory();
          _mainBlockColor = Colors.white;
          var cb = e.data;
          if (cb.container != null){
            cb.container.removeBlocky(cb);
          }

          StateScriptProject.instance.shareCodeBlockyTemplates.removeBlocky(cb);
        });
      },
    );
    return dtgt;
  }


//  Widget getBlockView() {
//
//
//
//    var _rows = List<Widget>();
//    var blockies = widget.function.getBlockies();
//    for(var b in blockies){
//      var tp = CodeBlockyType.getType(b.blockyTypeId);
//      if (tp != null){
//        var s = tp.getBlockWidget(b);
//        _rows.add(s);
//      }
//    }
//
//    void _onReorder(int oldIndex, int newIndex) {
//      setState(() {
//        Widget row = _rows.removeAt(oldIndex);
//        _rows.insert(newIndex, row);
//      });
//    }
//
//    var dtgt = DragTarget<CodeBlocky>(
//      builder: (p1,p2,p3){
//        return Container(
//          child :Column(
//           children: [
//             Expanded(child : Row(
//               children: [
//                 Expanded(
//                   child: ReorderableColumn(
//                     header: Text('THIS IS THE HEADER ROW'),
//                     footer: Text('THIS IS THE FOOTER ROW'),
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: _rows,
//                     onReorder: _onReorder,
//                   ),
//                 )
//               ],
//             )),
//           ],
//          ),
//        );
//      },
//      onWillAccept: (e){
//        // var tp = CodeBlockyType.getType(e.blockyTypeId);
//        // return tp != null && (tp.typeFlag & BlockyTypes.BT_BLOCK != 0);
//        return true;
//      },
//      onLeave: (e){
//        setState(() {
//          _mainBlockColor = Colors.white;
//        });
//      },
//      onMove: (e){
//        var tp = CodeBlockyType.getType(e.data.blockyTypeId);
//        var canReceive = tp != null && (tp.typeFlag & BlockyTypes.BT_BLOCK != 0);
//        setState(() {
//          _mainBlockColor = canReceive? CommonUtil.scaleColor(Colors.green,0.2):CommonUtil.scaleColor(Colors.red,0.2);
//        });
//      },
//      onAcceptWithDetails: (e){
//        var tp = CodeBlockyType.getType(e.data.blockyTypeId);
//        var canReceive = tp != null && (tp.typeFlag & BlockyTypes.BT_BLOCK != 0);
//        if (!canReceive){
//          BotToast.showText(text : "仅支持 block 类型元素 (矩形块)",contentColor: Colors.red);
//          setState(() {
//            _mainBlockColor = Colors.white;
//          });
//          return;
//        }
//        setState(() {
//          var cb = CodeBlocky();
//          cb.blockyTypeId = tp.guid;
//          widget.function.addBlocky(cb);
//          _mainBlockColor = Colors.white;
//        });
//      },
//    );
//
//    // var t =ReorderableSliverList(
//    //   delegate: ReorderableSliverChildListDelegate(_rows),
//    //   // children: _rows,
//    //   onReorder: _onReorder,
//    // );
//
//    return Container(
//      decoration: dc1,
//      child:Container(
//        color: _mainBlockColor,
//        child: Column(
//          children: [
//            Expanded(
//              child: dtgt,
//            )
//          ],
//        )
//        ,
//      ),
//    );
//  }
}