//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/markdown_widget.dart';
import 'package:battlepus/common/ThemeCenter.dart';

class MarkdownEditor extends StatefulWidget {
  String data;
  final double height;
  final double width;
  final Color bgColor;
  final String title;
  final FunctionStringCallback onChanged;
  final FunctionStringCallback onSubmitted;
  final FunctionStringCallback onClose;
  final bool editFull;
  MarkdownEditor({Key key , this.data , this.height ,this.width ,this.editFull = false, this.bgColor  , this.title = "title" , this.onChanged , this.onSubmitted , this.onClose}) : super(key: key);

  @override
  MarkdownEditorState createState() => MarkdownEditorState();
}

class MarkdownEditorState extends State<MarkdownEditor> {
  bool isEditting  = false;

  TextEditingController valueController;

  MarkdownWidgetState mdWidget;
  // ScrollController controller;

  @override
  void dispose() {
    // controller?.dispose();
    // TODO: implement dispose
    super.dispose();
    valueController?.dispose();
//    mdWidget?.dispose();
  }
  @override
  void initState() {
    // controller = ScrollController();
    // TODO: implement initState
    super.initState();
    valueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    mdWidget = null;
//    print("init data " + widget.data.toString());
//    print("data " + data.toString());
////    if (data == null) data = widget.data;
    valueController.text = widget.data;
//    print("init data " + data);
    var md = MarkdownWidgetEx(
        data: (widget.data == null|| widget.data.isEmpty) ?"输入说明文档":widget.data,
      parent:this,
    );
    // var md = Markdown(
    //   controller: controller,
    //   selectable: true,
    //   data: (widget.data == null|| widget.data.isEmpty) ?"输入说明文档":widget.data,
    // );
    var mdc = Container(
      padding: EdgeInsets.all(4),
      color: widget.bgColor??ThemeCenter.systemTheme.scaffoldBackgroundColor,
      child:md
    );

    var edt = Container(
        padding: EdgeInsets.all(4),
        // color: CommonUtil.alphaColor(Colors.white , 240),
//        child:md
        child: Column(
          children: [
            Expanded(child:TextField(

              maxLines:null,
              expands:true,
              controller: valueController,
              onChanged: (v){
                widget.onChanged?.call(v);
                widget.data = v;
                if (mdWidget != null){
                  mdWidget.data = v;
                  mdWidget.setState(() {

                  });
                }
              },
              onSubmitted: (v){
                widget.onSubmitted?.call(v);
                widget.data = v;
                if (mdWidget != null){
                  mdWidget.data = v;
                  mdWidget.setState(() {
                  });
                }
              },
            )),
          ],
        ),
    );

    var headbar = Container(
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      height : 24,
      color: CommonUtil.alphaColor(Colors.black, 200),
      child: Row(
        children: [
          Expanded(child : Text(widget.title ,style: TextStyle(fontSize: 14, color: Colors.white ,fontWeight: FontWeight.w400),)),
          widget.onClose != null?Container(
            width: 22,
            height: 22,
            child: IconButton(
              padding : EdgeInsets.all(0) ,
              icon: Icon(MaterialCommunityIcons.close_box_outline),
              iconSize: 22,
              color: Colors.white,
              tooltip: "关闭",

              onPressed: (){
                setState(() {
                  widget.onClose?.call("");
                });

              },
            ),
          ):SizedBox(width: 0,),
          Container(
            width: 22,
            height: 22,
            child: IconButton(
              padding : EdgeInsets.all(0) ,
              icon: Icon(!isEditting?MaterialCommunityIcons.square_edit_outline:MaterialCommunityIcons.backspace_outline),
              iconSize: 22, color: Colors.white,
              tooltip:!isEditting?"编辑":"退出编辑",
              onPressed: (){
                setState(() {
                  isEditting = !isEditting;
                });
              },
            ),
          ),

        ],
      ),
    );

    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          headbar,
          !isEditting?Expanded(child :mdc)
          :Expanded(child:Row(
            children: [
              widget.editFull?SizedBox(width: 0,):Expanded(flex: 1,child: mdc,),
              Expanded(flex: 1,child: edt,),
            ],
          )),
        ],
      ),
    );
  }
}