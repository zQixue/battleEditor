//@dart=2.11
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/text_editor.dart';

class NodeFieldEditorView extends StatefulWidget {
  final StateScriptNode node ;
  final SSCanvasViewState graph;
  NodeFieldEditorView({Key key,  this.node, this.graph}) : super(
      key: key);

  @override
  _NodeFieldEditorViewState createState() =>
      _NodeFieldEditorViewState(
      );
}

class _NodeFieldEditorViewState extends State<NodeFieldEditorView> {
  ScrollController _scrollBar;

  bool _storeHistory = false;

  bool bInEditing = false;

 StreamSubscription<NodeDescRefreshEvent> _lis;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
   _lis?.cancel();
//    _scrollBar?.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _scrollBar =new ScrollController();
//
   _lis = EventCenter.eventBus.on<NodeDescRefreshEvent>().listen((event) {
     if (event.node == widget.node) {
       setState(() {

       });
     }
   });
  }

  void createBaseStringFieldEditor(List<Widget> rows , String name , String value , FunctionStringCallback onChanged ) {
    var header = Container(

      width : SSDefines.nodeFieldNameWidth,
      child : Text(name,
        style: TextStyle(color: Colors.grey , fontWeight: FontWeight.w600 ,),
        maxLines: 1,
        textAlign: TextAlign.start,
      ),
    );

    var ft = SSFieldType.getFieldType("___string___");
    var edt = ft.getEditWidget(
        value,
        (v){
          onChanged?.call(v);
        },
        (v){
          onChanged?.call(v);
        },
        context: context
    );

    var row = Container(
      color: rows.length%2==1?Colors.white:CommonUtil.alphaColor(Colors.grey, 48),
      padding: EdgeInsets.fromLTRB(8, 4, 4, 4),
      width: SSDefines.nodeFieldPanelWidth,
      height: SSDefines.nodeFieldRowHeight,
      child: Row(
        children: [
          header,
          Expanded(child:edt.widget),
        ],
      ),
    );

    rows.add(row);

  }

  @override
  Widget build(BuildContext context) {

    if (!widget.node.showHelp){
      return Container();
    }
      // double size = SSDefines.nodeWidth * 2 ;//+ (widget.node.inEditting ? SSDefines.nodeWidth/2:0);
      // double height = 180 ;//- 16.0;

      bool isEmpty = widget.node.description == null || widget.node.description.trim() == "";
      if (bInEditing){
        var dc2 =  BoxDecoration(
            color: Colors.white,
            border : Border(
              bottom: BorderSide(width: 0.1,color: Colors.green),
              left: BorderSide(width: 0.1,color: Colors.green),
              top: BorderSide(width: 0.1,color: Colors.green),
              right: BorderSide(width: 0.1,color: Colors.green),
//          top: BorderSide(width: 1,color: Colors.grey),
            )
        );

        var txtEdt = TextEditor(
          contentPadding: EdgeInsets.all(4),
          textStyle: TextStyle(fontSize: 11 , color: Colors.green),
          initValue: widget.node.description,
          maxLines: 20,
          onChanged: (v){
            widget.node.description = v;
          },
          onSubmitted: (v){
            setState(() {
              bInEditing = false;
            });
          },
        );
        var blk = CommonUtil.getWidgetBlock("输入注释", CommonUtil.scaleColor(Colors.green,0.3), txtEdt, 200 , actions:[
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(MaterialCommunityIcons.close_box),
            iconSize: 24,
            color: Colors.red,
            onPressed: (){
              setState(() {
                bInEditing = false;
              });
            },
          )
        ]);
        var md = Container(
          
            width: 200,
            height: 200,
          child:blk,
        );
        // var md = Container(
        //   width: 300,
        //   height: 200,
        //   padding: EdgeInsets.all(2),
        //   decoration: dc2,
        //   child: TextEditor(
        //     initValue: widget.node.description,
        //     maxLines: 20,
        //     onChanged: (v){
        //       widget.node.description = v;
        //     },
        //     onSubmitted: (v){
        //       setState(() {
        //         bInEditing = false;
        //       });
        //     },
        //   )
        // );
        var dnn2 = GestureDetector(
          dragStartBehavior : DragStartBehavior.down,
          child: md,
          onDoubleTap: (){
            setState(() {
              bInEditing = true;
            });

          },
          onTapDown: (e) {

            _storeHistory = false;
          },
          onPanStart: (e){
            // print("onPanStart");
            // onHeadTapDown(noEditing : true);
            // dragStorePos(e);
          },
          onPanUpdate: (e){

            setState(() {
              if (!_storeHistory) {
                HistoryManager.scriptHistory.appendHistory();
                _storeHistory = true;
              }
              // dragUpdatePos(e, widget.graph);
              widget.node.descOffX += e.delta.dx;
              widget.node.descOffY += e.delta.dy;

            });
          },
          onPanEnd: (e){
            // setState(() {
            //   dragEndPos(e, widget.graph);
            // });
          },
        );
        return Positioned(
          left: widget.node.x + widget.node.descOffX ,//- (size - SSDefines.nodeWidth)/2,//- SSDefines.portOffX + SSDefines.nodeFieldPanelOffX2Node ,
          // top: widget.node.y - height - 16,
          top: widget.node.y - 48 - 32 + widget.node.descOffY ,
          child: dnn2
        );
      }

      // if (isEmpty) return Container;
      var dc =  BoxDecoration(
        color: CommonUtil.alphaColor( Colors.black , 150),
          border : Border(
            bottom: BorderSide(width: 0.1,color: Colors.green),
            left: BorderSide(width: 0.1,color: Colors.green),
            top: BorderSide(width: 0.1,color: Colors.green),
            right: BorderSide(width: 0.1,color: Colors.green),
//          top: BorderSide(width: 1,color: Colors.grey),
          )
      );

      var md = Container(
        padding: EdgeInsets.all(2),
        decoration: dc,
        child: Text(isEmpty?"请输入注释": widget.node.description , style : TextStyle(color: Colors.white , fontSize: 11)),
      );
      // var mde = MarkdownWidgetEx(
      //   data: isEmpty?"请输入注释": widget.node.description,
      //
      // );
      // var md = Container(
      //   width: 100,
      //   height : 100,
      //   padding: EdgeInsets.all(2),
      //   decoration: dc,
      //   child: mde
      // );

      var dnn2 = GestureDetector(
        dragStartBehavior : DragStartBehavior.down,
        child: md,
        onDoubleTap: (){
          setState(() {
            bInEditing = true;
          });

        },
        onTapDown: (e) {

          _storeHistory = false;
        },
        onPanStart: (e){
          // print("onPanStart");
          // onHeadTapDown(noEditing : true);
          // dragStorePos(e);
        },
        onPanUpdate: (e){

          setState(() {
            if (!_storeHistory) {
              HistoryManager.scriptHistory.appendHistory();
              _storeHistory = true;
            }
            // dragUpdatePos(e, widget.graph);
            widget.node.descOffX += e.delta.dx;
            widget.node.descOffY += e.delta.dy;

          });
        },
        onPanEnd: (e){
          // setState(() {
          //   dragEndPos(e, widget.graph);
          // });
        },
      );

      return Positioned(
        left: widget.node.x + widget.node.descOffX ,//- (size - SSDefines.nodeWidth)/2,//- SSDefines.portOffX + SSDefines.nodeFieldPanelOffX2Node ,
        // top: widget.node.y - height - 16,
        top: widget.node.y - 48 + widget.node.descOffY ,
        child: Container(
          decoration: dc,
          child :dnn2,
        ),
      );

  }

  double getHeightAboveFields(){
    var nodeType = StateScriptProject.instance.structMap[widget.node.nodeTypeGuid];
    return SSDefines.nodeHeaderHeight + nodeType.getAllPortsHeight() + nodeType.getAllParamsHeight();
  }
}