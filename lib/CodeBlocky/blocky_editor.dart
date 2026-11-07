//@dart=2.11
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyContainer.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/KeyEventCenter.dart';
import 'package:reorderables/reorderables.dart';

class BlockyEditor extends StatefulWidget {
  final IBlockyContainer blockiesContainer;
  final dynamic addCallback;
  final dynamic removeCallback;
  final CodeBlocky owner;
  final bool expanded;
  final bool onlyBlock;
  final CBFunction func;
  BlockyEditor({Key key , this.func,this.blockiesContainer ,this.owner, this.addCallback ,this.removeCallback,this.expanded=true ,this.onlyBlock = true}) : super(key: key);

  @override
  _BlockyEditorState createState() => _BlockyEditorState();
}

class _BlockyEditorState extends State<BlockyEditor> {

  // List<Widget> _rows2;
  // @override
  // void initState() {
  //   super.initState();
  //   _rows2 = List<Widget>.generate(50,
  //           (int index) => Text('This is row $index', key: ValueKey(index), textScaleFactor: 1.5)
  //   );
  // }
  ScrollController scrollController;

  StreamSubscription<BlockContainerRefresh> _lis3;
  CodeBlocky _tempInsertBlocky;
  @override
  void dispose() {
    // TODO: implement dispose
    scrollController?.dispose();
    _lis3?.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    scrollController = ScrollController();
    _lis3 = EventCenter.eventBus.on<BlockContainerRefresh>().listen((event) {
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBlockView();
  }

  Color _mainBlockColor = Colors.white;
  Widget getBlockView() {


    // var dc1 = new BoxDecoration(
    //   border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
    //   // color: CommonUtil.scaleColor(Colors.indigo , 0.5),//Color(widget.node.getNodeStructType().bgColor),
    //   // borderRadius: new BorderRadius.circular((5.0))
    // );
    var _rows = List<Widget>();
    // print("###4");
    var blockies = widget.blockiesContainer.getBlockies();
    for(var b in blockies){
      b.container = widget.blockiesContainer;
      var tp = CodeBlockyType.getType(b.blockyTypeId);
      if (tp != null){
        var s = tp.doGetBlockWidget(b,null,widget.func);
        var d =Draggable(
          child: s,
          feedback: Opacity(opacity : 0.6 , child : Material(child:s,color: CommonUtil.alphaColor(Colors.white, 0),)),
          childWhenDragging: Opacity(child : s , opacity: 0.3),
          data: b,
        );
        _rows.add(Row(key :ValueKey(b.guid),children: [d],));
      }
    }

     if (_tempInsertBlocky != null){
       _rows.add( IgnorePointer(child:Opacity(opacity: 0.4,child : Opacity(opacity : 0.3,child : _tempInsertBlocky.getBlockWidget(widget.func))) ));
     }

    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        var row = blockies.removeAt(oldIndex);
        blockies.insert(newIndex, row);
      });
    }

    var dtgt = DragTarget<CodeBlocky>(
      builder: (p1,p2,p3){
        if (_rows.length<=0){

          var dc2 = new BoxDecoration(
            border: new Border.all(color: CommonUtil.scaleColor(Colors.grey , 0.9), width: 0.6),
            color: _mainBlockColor,//CommonUtil.alphaColor(Colors.white , 80),//Color(widget.node.getNodeStructType().bgColor),
            // borderRadius: new BorderRadius.circular((5.0))
          );

          if (widget.expanded) {
            if (_tempInsertBlocky != null){
              return Opacity(opacity: 0.4,child : Opacity(opacity : 0.3,child : _tempInsertBlocky.getBlockWidget(widget.func)));
            }
            return Container(
              decoration: dc2,
            );
          }
          else{
            if (_tempInsertBlocky != null){
              return Opacity(opacity: 0.4,child : Opacity(opacity : 0.3,child : _tempInsertBlocky.getBlockWidget(widget.func)));
            }

            return Container(
              // color:Colors.i,
              decoration: dc2,
              width: 240,
              height: CodeBlockyType.baseRowHeight,
            );
          }
        }

        if (widget.expanded) {
          var blks = LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                // padding: EdgeInsets.all(4),
                color: _mainBlockColor,
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // children: [
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          ReorderableWrap(
                            direction: Axis.vertical,
                            scrollDirection: Axis.vertical,
                            controller: scrollController,
                            // mainAxisSize : MainAxisSize.max,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // header: Text('THIS IS THE HEADER ROW'),
                            // footer: Text('THIS IS THE FOOTER ROW'),
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: _rows,
                            onReorder: _onReorder,
                            needsLongPressDraggable: true,
                          ),
                          SizedBox(height: 480,),
                        ],
                      )


                    )

                ),
              );
            },
          );
          return Container(
            padding: EdgeInsets.all(4),
            child: blks,
//            decoration: dc1,
          );
          return blks;
        }


        var blks = Container(

          // padding: EdgeInsets.all(4),
          color:_mainBlockColor,
          child :SingleChildScrollView(
            scrollDirection : Axis.vertical,
            // mainAxisAlignment: MainAxisAlignment.start,
            // children: [
            child : SingleChildScrollView(
              scrollDirection : Axis.horizontal,
              child: ReorderableWrap(
                direction : Axis.vertical,
                scrollDirection : Axis.vertical,
                controller: scrollController,
                // mainAxisSize : MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.start,
                // header: Text('THIS IS THE HEADER ROW'),
                // footer: Text('THIS IS THE FOOTER ROW'),
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: _rows,
                onReorder: _onReorder,
                needsLongPressDraggable:true,
              ),

            )

          ),
        );

        return Container(
          padding: EdgeInsets.all(4),
          child: blks,
//          decoration: dc1,
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
          _tempInsertBlocky = null;
        });
      },
      onMove: (e){
        print("###5");
        bool bOwner = widget.blockiesContainer.getBlockies().contains(e.data);
        var tp = CodeBlockyType.getType(e.data.blockyTypeId);
        bool isCircle =e.data == widget.owner ||  (e.data as CodeBlocky).isParentOf(widget.owner);
        // print("isCircle = $isCircle");
        var canReceive = tp != null && (!widget.onlyBlock || (tp.typeFlag & BlockyTypes.BT_BLOCK != 0)) && !isCircle;
        setState(() {
          if (!bOwner){
            _mainBlockColor = (canReceive? CommonUtil.scaleColor(Colors.green,0.2):CommonUtil.scaleColor(Colors.red,0.2));
            if (canReceive) {
              _tempInsertBlocky = e.data;
            }
          }
        });
      },
      onAcceptWithDetails: (e){
        var tp = CodeBlockyType.getType(e.data.blockyTypeId);
        bool isCircle =e.data == widget.owner ||  (e.data as CodeBlocky).isParentOf(widget.owner);
        var canReceive = tp != null && ((!widget.onlyBlock || (tp.typeFlag & BlockyTypes.BT_BLOCK != 0)) && !isCircle);
        if (!canReceive){
          BotToast.showText(text : "仅支持 block 类型元素 (矩形块)",contentColor: Colors.red);
          setState(() {
            _mainBlockColor = Colors.white;
            _tempInsertBlocky = null;
          });
          return;
        }
        setState(() {
          HistoryManager.functionHistory?.appendHistory();
          var cb = e.data;
          if (cb.guid == null) {
            cb = CodeBlocky();
            cb.blockyTypeId = tp.guid;
          }
          _mainBlockColor = Colors.white;
          _tempInsertBlocky = null;
          print("###6");
          if (widget.blockiesContainer.getBlockies().contains(cb)) return ;

          if (KeyEventCenter.isControlPressed()) {
            var ncb = CodeBlocky();
            ncb.copy(cb);
            cb = ncb;
          }

          widget.blockiesContainer.addBlocky(cb);
          widget.addCallback?.call(cb);

        });
      },
    );



    return dtgt;
  }

}