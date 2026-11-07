//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:battlepus/CodeBlocky/Blockies/BlockyContainer.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/KeyEventCenter.dart';

class BlockySlotEditor extends StatefulWidget {
  final int blockFlag;
  final int defaultWidgetBlockFlag;
  final IBlockyContainer container;
  final String slot;
  final dynamic canReceiveCallback;
  final String targetType;
  final CBFunction func;
  BlockySlotEditor({Key key , this.func,this.blockFlag , this.defaultWidgetBlockFlag , this.container,this.slot ,this.canReceiveCallback , this.targetType}) : super(key: key);

  @override
  _BlockySlotEditorState createState() => _BlockySlotEditorState();
}

class _BlockySlotEditorState extends State<BlockySlotEditor> {
  Color _mainBlockColor = Colors.white;
  CodeBlocky tempBlocky;
  Widget getDefaultWidget(Color clr , int flag){
    switch(flag){
      case BlockyTypes.BT_VAR:
        return Container(
          height: CodeBlockyType.baseRowHeight,
          width: 80,
          decoration: BoxDecoration(
          // border: new Border.all(color: Colors.black, width: 0.1),
          color : clr,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: Colors.grey, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
          borderRadius: new BorderRadius.circular((90.0))
          ),
        );
      case BlockyTypes.BT_EXPR:
      case BlockyTypes.BT_METHOD:
      return Container(
        height: CodeBlockyType.baseRowHeight,
        width: 100,
        decoration: BoxDecoration(
          // border: new Border.all(color: Colors.black, width: 0.5),
            color : clr,
            //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
            boxShadow: [ BoxShadow(color: Colors.grey, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
            borderRadius: new BorderRadius.circular((90.0))
        ),
      );


      case BlockyTypes.BT_BLOCK:
        return Container(
          height: CodeBlockyType.baseRowHeight,
          width: 80,
          decoration: BoxDecoration(
              // border: new Border.all(color: Colors.black, width: 0.5),
              color : clr,
              //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
              boxShadow: [ BoxShadow(color: Colors.grey, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
              // borderRadius: new BorderRadius.circular((90.0))
          ),
        );
      case BlockyTypes.BT_CONDITION:
        return Material(
          color: clr,
          shadowColor: Colors.grey,
          shape: BeveledRectangleBorder(
              side: BorderSide(width: 0.5, color: Colors.grey),
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 80,
            height: CodeBlockyType.baseRowHeight,
          ),


          // decoration: BoxDecoration(
          //
          //     height: CodeBlockyType.baseRowHeight,
          //   // border: new Border.all(color: Colors.black, width: 0.1),
          //     color : clr,
          //     //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          //     boxShadow: [ BoxShadow(color: Colors.grey, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
          //     borderRadius: new BorderRadius.circular((90.0))
          // ),
        );
    }
    throw new Exception("无效的 blocky 默认类型");
  }
  @override
  Widget build(BuildContext context) {

    var dtgt = DragTarget<CodeBlocky>(
      builder: (p1,p2,p3){
        if (widget.container == null || widget.slot == null) {
          return getDefaultWidget(_mainBlockColor , widget.defaultWidgetBlockFlag);
        }

        var inputBlocky = widget.container.getBlocky(widget.slot);

        // if (inputBlocky == null && tempBlocky != null){
        //   inputBlocky = tempBlocky;
        // }
        if (inputBlocky!=null){
          var bw = inputBlocky.getBlockWidget(widget.func , targetType: widget.targetType);
          return Draggable(
            child: tempBlocky != null?Opacity(opacity: 0.2 ,child : bw ):bw,
            feedback: Opacity(opacity: 0.6 ,child : Material(child:bw,color: CommonUtil.alphaColor(Colors.white, 0),)),
            childWhenDragging: Opacity(child : bw , opacity: 0.3),
            data: inputBlocky,
          );
        }
        return getDefaultWidget(_mainBlockColor , widget.defaultWidgetBlockFlag);
      },
      onWillAccept: (e){
        if (e == widget.container) return false;
        return true;
      },
      onLeave: (e){
        if (e == widget.container) return false;
        setState(() {
          _mainBlockColor = Colors.white;
          tempBlocky = null;
        });
      },
      onMove: (e){
        if (e.data == widget.container) return false;
        var tp = CodeBlockyType.getType(e.data.blockyTypeId);
        var canReceive = tp != null && (tp.typeFlag & widget.blockFlag != 0);

        if (widget.canReceiveCallback!= null){
          // print(tp);
          bool can = true;
          var res = widget.canReceiveCallback(e.data);
          if (res is String){
            can = false;
          }
          canReceive = canReceive && can;//widget.canReceiveCallback(e.data);
        }
        if (widget.targetType != null && tp.getBlockyType(e.data) != widget.targetType){
          canReceive = false;
        }
        setState(() {
          _mainBlockColor = canReceive? CommonUtil.scaleColor(Colors.green,0.2):CommonUtil.scaleColor(Colors.red,0.2);
          tempBlocky = canReceive?e.data:null;
        });
      },
      onAcceptWithDetails: (e){
        var tp = CodeBlockyType.getType(e.data.blockyTypeId);
        var canReceive = tp != null && (tp.typeFlag & widget.blockFlag != 0);
        // print("canReceive = $canReceive ${tp.typeFlag} ${widget.blockFlag}");
        var errmeg = "不支持的 blocky 类型";
        if (widget.canReceiveCallback!= null){
          var cr = widget.canReceiveCallback(e.data);
          if (cr != true) {
            canReceive = false;
            if (cr is String){
              errmeg = cr ;
            }
          }
          // canReceive = canReceive && widget.canReceiveCallback(e.data);
        }
        // var btp = tp.getBlockyType(e.data);
        if (widget.targetType != null && !CodeBlockyType.isObjectTypeValid(widget.targetType, e.data.getFullTypeWithExtra())){// widget.targetType != null && btp != null && btp != widget.targetType){
          canReceive = false;
          errmeg = "类型不匹配，期望 ${widget.targetType}";
        }
        if (!canReceive){
          BotToast.showText(text : errmeg,contentColor: Colors.red);
          setState(() {
            _mainBlockColor = Colors.white;
            tempBlocky = null;
          });
          return;
        }
        setState(() {

          _mainBlockColor = Colors.white;
          tempBlocky = null;


          if (widget.container != null && widget.slot!= null){
            var cb = e.data;
            if (cb.guid == null) {
              // print("new blocky");
              cb = CodeBlocky();
              cb.blockyTypeId = tp.guid;
            }
            cb.values.addAll(e.data.values);
            var cbOld = widget.container.getBlocky(widget.slot);
            if (cbOld == cb) return;
            HistoryManager.functionHistory?.appendHistory();
            if (cbOld != null){
              if (CodeBlocky.curentFunction != null){
                CodeBlocky.curentFunction.getBinList().addBlocky(cbOld);
              }
            }
            // print("set blocky");
            if (KeyEventCenter.isControlPressed()) {
              var ncb = CodeBlocky();
              ncb.copy(cb);
              widget.container.setBlocky(widget.slot, ncb);
            }
            else{
              widget.container.setBlocky(widget.slot, cb);
            }

          }
          // widget.blockiesContainer.addBlocky(cb);
          // widget.addCallback?.call(cb);
          // _mainBlockColor = Colors.white;

        });
        // setState(() {
        //   var cb = CodeBlocky();
        //   cb.blockyTypeId = tp.guid;
        //   // widget.blockies.addBlocky(cb);
        //   widget.addCallback?.call(cb);
        //   _mainBlockColor = Colors.white;
        // });
      },
    );

    return dtgt;
  }
}