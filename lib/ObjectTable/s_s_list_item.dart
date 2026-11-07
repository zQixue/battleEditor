//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_cursor/flutter_cursor.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/KeFrame/frame_separate_widget.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/card_loading/card_loading.dart';

class SSListItem extends StatefulWidget {
  final bool separateFrame;
  final double itemExtent;
  final List<dynamic> lst ;
  final int index;
  final SSFieldType innerType0 ;
  final dynamic onChanged;
  final dynamic onSubmitted;
  final bool expanded;
  final dynamic onExpandedChanged;
  // final dynamic onAdd;
  // final dynamic onAdd;
  final GridCellInfo gci;
  const SSListItem({Key key,
    this.separateFrame = true,
    this.itemExtent,
    this.lst,
    this.index,
    this.innerType0,
    this.onChanged,
    this.onSubmitted,
    this.gci,
    this.expanded = false,
    this.onExpandedChanged,
  }) : super(key: key);

  @override
  _SSListItemState createState() => _SSListItemState();
}

class _SSListItemState extends State<SSListItem> {
  bool operateMode = false;
  bool dragingOn = false;
  bool dragingStarted = false;
  bool dragingNode = false;

  @override
  void initState() {
    operateMode = widget.expanded;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getItem(widget.lst, widget.index, widget.innerType0, widget.onChanged, widget.onSubmitted, widget.gci);
  }

  Widget getItem(List<dynamic> lst,int i,SSFieldType innerType0,onChanged,onSubmitted,gci){
    var crt = lst[i];
    crt = innerType0.parseValue(crt);
    var w = innerType0.getGridCellEditor(initValue:crt,
      onChanged:(v){
        setState(() {
          lst[i] = v;
          onChanged?.call(lst);
        });

      },
      onSubmitted:(v){
        setState(() {
          lst[i] = v;
          onChanged?.call(lst);
        });
      },
      gci: gci,
      context: context,

    );
    var color = (i%2 ==1) ? Color(0x6F242730) : Color(0xfF242730);

    var dc = new BoxDecoration(
        color :color,
        borderRadius: new BorderRadius.circular((4))
    );

    var e = InkWell(
      // hoverColor: Colors.green,
      // mouseCursor:SystemMouseCursors.,
      onHover: (v){
        setState(() {
          dragingNode = v;
        });
      },
        onTap: (){

        },
      child:SizedBox(
        child: Icon(MaterialCommunityIcons.drag,color: dragingOn ? Colors.redAccent : (dragingNode?Colors.green:Colors.grey)),
        width: 24, height: 24,
      )
    );

    var e2 = SizedBox(
      child: Icon(MaterialCommunityIcons.drag,color: Colors.green),
      width: 24, height: 24,
    );
    var e3 = SizedBox(
      child: Icon(MaterialCommunityIcons.sort,color: Colors.green),
      width: 24, height: 24,
    );

    Widget rowitem = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        if (operateMode) SizedBox(
          width: 22, height: 24,
          child:ThemeCenter.iconBtn(MaterialCommunityIcons.minus_box_outline , color: Colors.redAccent,
            width: 20 , height :20 ,
            tooltip: "删除",
            onPressed: (){
              CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                innerType0.deleteObject(crt);
                lst.removeAt(i);
                onSubmitted?.call(lst);
              });

            },
          ),
        ),
        if (operateMode) SizedBox(
          width: 22, height: 24,
          child:ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline , color: Colors.green,
            width: 20 , height :20 ,
            tooltip: "插入",
            onPressed: (){
              var guid = innerType0.createObject();
              if (guid != null){
                var df = innerType0.parseValue(guid);
                lst.insert(i,df);
              }
              else{
                var df = innerType0.parseValue(null);
                lst.insert(i,df);
              }
              onSubmitted?.call(lst);
            },
          ),
        ),
        if (operateMode) SizedBox(
          width: 22, height: 24,
          child:ThemeCenter.iconBtn(MaterialCommunityIcons.content_copy , color: Colors.green,
            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
            width: 20 , height :20 ,
            tooltip: "复制",
            onPressed: (){
              var guid = innerType0.createObject();
              if (guid != null){
                var df = innerType0.parseValue(guid);
                var crtObj = ObjectClazz.allObjects[crt];
                var obj = ObjectClazz.allObjects[df];
                crtObj.copyTo(obj);
                lst.insert(i,df);
              }
              else{
                // var df = innerType0.parseValue(null);
                lst.insert(i,crt);
              }
              onSubmitted?.call(lst);
            },
          ),
        ),
        if (operateMode && innerType0.useComment()) SizedBox(
          width: 22, height: 24,
          child:ThemeCenter.iconBtn(MaterialCommunityIcons.comment_plus_outline , color: Colors.green,
            padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
            width: 20 , height :20 ,
            tooltip: "插入注释",
            onPressed: (){
              var guid = innerType0.createObject(para: "comment");
              if (guid != null){
                var df = innerType0.parseValue(guid);
                lst.insert(i,df);
              }
              else{
                var df = innerType0.parseValue(null);
                lst.insert(i,df);
              }
              onSubmitted?.call(lst);
            },
          ),
        ),

        SizedBox(
          width: 24, height: 24,
          child:ThemeCenter.iconBtn(!operateMode?MaterialCommunityIcons.chevron_double_right:MaterialCommunityIcons.chevron_double_left ,
            color: Colors.grey,
            width: 20 , height :20 ,
            tooltip: operateMode?"关闭操作":"展开操作",
            onPressed: (){
              setState(() {
                operateMode = !operateMode;
                widget.onExpandedChanged?.call(i , operateMode);
              });
            },
          ),
        ),
        // if(operateMode) SizedBox(
        //   width: 24, height: 24,
        //   child:ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_up , color: Colors.white,
        //     width: 20 , height :20 ,
        //     tooltip: "上移",
        //     onPressed: (){
        //       // CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
        //       //   lst.removeAt(i);
        //       //   onSubmitted?.call(lst);
        //       //   // setState(() {
        //       //   // });
        //       // });
        //       var oldItemIndex = widget.index;
        //       var newItemIndex = widget.index - 1;
        //       var vvv = lst.removeAt(oldItemIndex);
        //       lst.insert(newItemIndex, vvv);
        //       onSubmitted?.call(lst);
        //     },
        //   ),
        // ),
        // if(operateMode) SizedBox(
        //   width: 24, height: 24,
        //   child:ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_down , color: Colors.white,
        //     width: 20 , height :20 ,
        //     tooltip: "下移",
        //     onPressed: (){
        //       var oldItemIndex = widget.index;
        //       var newItemIndex = widget.index + 1;
        //       var vvv = lst.removeAt(oldItemIndex);
        //       lst.insert(newItemIndex, vvv);
        //       onSubmitted?.call(lst);
        //     },
        //   ),
        // ),
        Expanded(child:w.widget),
        Draggable(
          child: e,
          feedback: e3,
          childWhenDragging: e2,
          // feedbackOffset: Offset(30.0,30.0),
          // ignoringFeedbackSemantics:false,
          data: DragData()..typeGuid = innerType0.guid..index = widget.index,
            onDragStarted:(){
              setState(() {
                dragingStarted = true;
              });
            },
          onDragEnd:(e){
            setState(() {
              dragingStarted = false;
            });
          },
          onDraggableCanceled: (e,b){
            setState(() {
              dragingStarted = false;
            });
          },
          onDragCompleted: (){
            setState(() {
              dragingStarted = false;
            });
          },
        ),

        SizedBox(width: 12,),
      ],
    );



    if (dragingStarted){
      rowitem = Container(
        child: rowitem,
        color: CommonUtil.alphaColorD( Colors.green , 0.4),
      );
    }
    else{
      if (dragingOn){
        rowitem = Container(
          child: rowitem,
          color: CommonUtil.alphaColorD( Colors.redAccent , 0.4),
        );
      }
    }
    // else{
    //   rowitem = Container(
    //     child: rowitem,
    //   );
    // }


    var dt = DragTarget<DragData>(
      builder: (p1,p2,p3){

        return rowitem;
      },
      onMove: (details){
        if (details.data.typeGuid != innerType0.guid) return ;
        setState(() {
          // selectTags.add(e.data);
          dragingOn = true;
        });
      },
      onLeave: (details){
        setState(() {
          // selectTags.add(e.data);
          dragingOn = false;
        });
      },
      onWillAccept: (e){return e.typeGuid == innerType0.guid;},
      onAcceptWithDetails: (e){
        // if (selectTags.contains(e.data)){
        //   BotToast.showText(text: "此 tag 已存在");
        //   return;
        // }
        //
        var inIndex = e.data.index;
        var toIndex = widget.index;
        if (inIndex != toIndex) {
          var vvv = lst.removeAt(inIndex);
          lst.insert(toIndex, vvv);
          onSubmitted?.call(lst);
        }


        setState(() {
          // selectTags.add(e.data);
          dragingOn = false;
        });

      },
    );

    if (!widget.separateFrame){
      var itm = Container(
        key: ValueKey(i),
        decoration: dc,
        child: dt,
      );
      return itm;
    }

    var fsw = FrameSeparateWidget(
      index: i,
      placeHolder: Padding(
        padding: EdgeInsets.fromLTRB(widget.itemExtent/3, widget.itemExtent/3, widget.itemExtent/3, widget.itemExtent/3),
        // child: Center(child:Text("...")),
        child:Center(child:CardLoading(
          cardLoadingTheme: CardLoadingTheme(colorOne: Colors.green,colorTwo:Colors.grey),
          height: 2,
          animationDuration : const Duration(milliseconds: 1600),
          borderRadius: BorderRadius.all(Radius.circular(1)),
          // margin: EdgeInsets.all(value),
        )),
        // decoration: dc,
        // height: widget.itemExtent,
      ),
      child: dt,
    );
    // return rowitem;

    return  Container(
      key: ValueKey(i),
      decoration: dc,
      child: fsw,
    );

  }
}


class DragData{
  String typeGuid;
  int index;
}

