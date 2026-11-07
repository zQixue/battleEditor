//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/Blockies/IfElseInfo.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_editor.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';

class CBTypeIf extends CodeBlockyType{

  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.2);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 1.2),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((5.0))
    );

    var dc2 = new BoxDecoration(
      border: new Border.all(color: bgColor, width: 0.4),
      color :Colors.white,
      //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
      boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
      borderRadius: new BorderRadius.circular((5.0))
    );


    if (blocky == null) {
      return Container(
        height: CodeBlockyType.baseRowHeightAdd,
        padding: CodeBlockyType.basePadding,
        width: 100,
        decoration: dc,
        // child : Container(
        //   height: CodeBlockyType.baseRowHeight,
        //   child:Center(child : Text( "${getTypeShowString()} if-else" , style: CodeBlockyType.baseTextStyle,)),
        // ),
        child : Center(child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(MaterialCommunityIcons.arrow_decision,color: Colors.indigo,size: 20,),
            Text("条件分支" , style: CodeBlockyType.baseTextStyle,)
          ],
        )),
      );
    }

    List<Widget> ifElses = List<Widget>();
//    ifElses.add(con);

    var ifs = blocky.values["ifs"] as List<dynamic>;//

    if (ifs == null) ifs = blocky.values["ifs"] = <IfElseInfo>[IfElseInfo()];
    for(var i = 0 ; i < ifs.length ;++i) {
      if (!(ifs[i] is IfElseInfo)){
        ifs[i] = IfElseInfo.fromJson(ifs[i]);
      }
    }
    var lastElse = blocky.values["else"];
    if (lastElse != null && !(lastElse is IfElseInfo)){
      lastElse = blocky.values["else"] = IfElseInfo.fromJson(lastElse);
    }
    
    var iCount = 0;
    for(var _1If in ifs){
      int iIndex = iCount;
//      var _1If = tmp is  IfElseInfo.fromJson(tmp);
      var dtgt = BlockySlotEditor(blockFlag: BlockyTypes.BT_CONDITION,defaultWidgetBlockFlag: BlockyTypes.BT_CONDITION ,container: blocky,slot: _1If.guid,);
      var elseHead = Container(
        key: ValueKey(blocky.guid),
        padding: CodeBlockyType.basePadding,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(iIndex==0?"如果":"否则如果",style: CodeBlockyType.baseTextStyle,),
            SizedBox(width: 8,),
            dtgt,
            SizedBox(width: 8,),
            Text("则",style: CodeBlockyType.baseTextStyle,),
            SizedBox(width: 8,),
            iIndex>0?IconButton(
              padding: EdgeInsets.all(0),
              color:CommonUtil.scaleColor(bgColor, 0.7),
              icon:Icon(MaterialCommunityIcons.chevron_up_box,),
              onPressed: (){
                HistoryManager.functionHistory?.appendHistory();
                ifs.removeAt(iIndex);
                ifs.insert(iIndex - 1 , _1If);
                EventCenter.eventBus.fire(BlockContainerRefresh());
              }
            ):SizedBox(width:0),
            iIndex < ifs.length-1?IconButton(
                padding: EdgeInsets.all(0),
                color:CommonUtil.scaleColor(bgColor, 0.7),
                icon:Icon(MaterialCommunityIcons.chevron_down_box,),
                onPressed: (){
                  HistoryManager.functionHistory?.appendHistory();
                  ifs.removeAt(iIndex);
                  ifs.insert(iIndex + 1 , _1If);
                  EventCenter.eventBus.fire(BlockContainerRefresh());
                }
            ):SizedBox(width:0),
            iIndex>0?IconButton(
                padding: EdgeInsets.all(0),
                color:CommonUtil.scaleColor(Colors.red, 0.7),
                icon:Icon(MaterialCommunityIcons.close_box,),
                onPressed: (){
                  HistoryManager.functionHistory?.appendHistory();
                  ifs.removeAt(iIndex);
                  blocky.removeBlocky(blocky.getBlocky(_1If.guid));
                  blocky.removeBody(key: _1If.guid);
                  EventCenter.eventBus.fire(BlockContainerRefresh());
                }
            ):SizedBox(width:0),            
          ],
        ),
      );
      var bodyElse = blocky.getCreateBody(key: _1If.guid);
      var bodyElseWidget = BlockyEditor(func: func, blockiesContainer: bodyElse, expanded: false,owner: blocky,);
      var conElse = Container(
//        decoration: dc,
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            elseHead,
            Container(
              padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, CodeBlockyType.baseSplitWidth, 0),
              child:Container(
                decoration: dc2,
                child: bodyElseWidget,
              ),
            ),

            iCount == ifs.length-1?Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: 8,),
                  TextButton(
                    style : ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(CommonUtil.scaleColor(bgColor, 0.3))),// color: CommonUtil.scaleColor(bgColor, 0.3),
                    child: Row(children: [ Text("Else If" , style: TextStyle(color: Colors.indigo , fontWeight: FontWeight.w600),),Icon(MaterialCommunityIcons.plus_box_outline,color:CommonUtil.scaleColor(bgColor, 0.7)) , ],),
                    onPressed: (){
                      HistoryManager.functionHistory?.appendHistory();
                      ifs.add(IfElseInfo());
                      EventCenter.eventBus.fire(BlockContainerRefresh());
                    },
                  ),
                  Container(width: 8,),
                  lastElse == null? TextButton(
                    style : ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(CommonUtil.scaleColor(bgColor, 0.3))),//// color: CommonUtil.scaleColor(bgColor, 0.3),
                    child: Row(children: [ Text("Else" , style: TextStyle(color: Colors.indigo , fontWeight: FontWeight.w600),),Icon(MaterialCommunityIcons.plus_box_outline,color:CommonUtil.scaleColor(bgColor, 0.7)) , ],),
                    onPressed: (){
                      HistoryManager.functionHistory?.appendHistory();
                      blocky.values["else"] = IfElseInfo();
                      EventCenter.eventBus.fire(BlockContainerRefresh());
                    },
                  ):SizedBox(width: 0,)
                ],
              ),
            ):Container(
              height: CodeBlockyType.baseRowHeight/2,
            ),
          ],
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
      iCount++;
      ifElses.add(conElse);
    }

    if (lastElse != null){
      var elseHead = Container(
        key: ValueKey(blocky.guid),
        padding: CodeBlockyType.basePadding,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("否则",style: CodeBlockyType.baseTextStyle,),
            SizedBox(width: 8,),
            IconButton(
                padding: EdgeInsets.all(0),
                color:CommonUtil.scaleColor(Colors.red, 0.7),
                icon:Icon(MaterialCommunityIcons.close_box,),
                onPressed: (){
                  HistoryManager.functionHistory?.appendHistory();
                  blocky.values["else"] = null;
                  blocky.removeBody(key : lastElse.guid);
                  EventCenter.eventBus.fire(BlockContainerRefresh());
                }
            )
          ],
        ),
      );
      var bodyElse = blocky.getCreateBody(key: lastElse.guid);
      var bodyElseWidget = BlockyEditor(func: func,blockiesContainer: bodyElse, expanded: false,owner: blocky,);
      var conElse = Container(
//        decoration: dc,
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            elseHead,
            Container(
              padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, CodeBlockyType.baseSplitWidth, 0),
              child:Container(
                decoration: dc2,
                child: bodyElseWidget,
              ),
            ),
            Container(
              height: CodeBlockyType.baseRowHeight/2,
            ),
          ],
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
      ifElses.add(conElse);
    }
    else{

    }
//    ifElses.add(SizedBox(height: CodeBlockyType.baseInterval ,));

    var allIfElse = Container(
      decoration: dc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ifElses,
      )
    ) ;
    return Container(
      child: Column(
        children: [
          allIfElse,
          SizedBox(height: CodeBlockyType.baseInterval ,),
        ],
      ),
    );
  }
  CBTypeIf(){
    typeFlag = BlockyTypes.BT_BLOCK;
    // bgColor = Colors.lightBlueAccent;
    setDefaultColor(Color(0xFF6699CC));
    name = "If";
    alias = "条件";
  }



  @override
  dynamic getExportFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    var ifs = blk.values["ifs"] as List<dynamic>;//

    if (ifs == null) ifs = blk.values["ifs"] = <IfElseInfo>[IfElseInfo()];
    for(var i = 0 ; i < ifs.length ;++i) {
      if (!(ifs[i] is IfElseInfo)){
        ifs[i] = IfElseInfo.fromJson(ifs[i]);
      }
    }
    res ["block"] = blk.getCreateBody(key : ifs[0].guid).getExportCode();
    res ["expr"] = blk.getBlockyCode(ifs[0].guid);

    var els = res["elseIfs"] = [];
    for(var i = 1 ; i < ifs.length ;++i) {
      var iif = ifs[i] as IfElseInfo;
      var block = blk.getCreateBody(key : iif.guid).getExportCode();
      var exp = blk.getBlockyCode(iif.guid);
      els.add({"expr" : exp , "block":block});
    }

    var lastElse = blk.values["else"];
    print("=================================== lastElse : $lastElse");

    if (lastElse != null && !(lastElse is IfElseInfo)){
      lastElse = blk.values["else"] = IfElseInfo.fromJson(lastElse);
    }
    if (lastElse != null){// && !(lastElse is IfElseInfo)){
      res["lastElse"] = blk.getCreateBody(key : lastElse.guid).getExportCode();
    }

    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();
    var ifs = blk.values["ifs"] as List<dynamic>;//

    if (ifs == null) ifs = blk.values["ifs"] = <IfElseInfo>[IfElseInfo()];
    for(var i = 0 ; i < ifs.length ;++i) {
      if (!(ifs[i] is IfElseInfo)){
        ifs[i] = IfElseInfo.fromJson(ifs[i]);
      }
    }
    var bCode = blk.getCreateBody(key : ifs[0].guid).getBehavicCode();
    var eCode = blk.getBlockyBehavicCode(ifs[0].guid);
    sb.write("if ($eCode) { $bCode }");

    // var els = res["elseIfs"] = [];
    for(var i = 1 ; i < ifs.length ;++i) {
      var iif = ifs[i] as IfElseInfo;
      var block = blk.getCreateBody(key : iif.guid).getBehavicCode();
      var exp = blk.getBlockyBehavicCode(iif.guid);
      // els.add({"expr" : exp , "block":block});
      sb.write(" else if ($exp) { $block }");
    }

    var lastElse = blk.values["else"];
    if (lastElse != null && !(lastElse is IfElseInfo)){
      lastElse = blk.values["else"] = IfElseInfo.fromJson(lastElse);
    }
    if (lastElse != null){// && !(lastElse is IfElseInfo)){
      // res["lastElse"] = blk.getCreateBody(key : lastElse.guid).getExportCode();
      sb.write(" else { ${blk.getCreateBody(key : lastElse.guid).getBehavicCode()} }");
    }

    return sb.toString();
  }


  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){

    // var res = Map<String , dynamic>();
    var ifs = blk.values["ifs"] as List<dynamic>;//

    if (ifs == null) ifs = blk.values["ifs"] = <IfElseInfo>[IfElseInfo()];
    for(var i = 0 ; i < ifs.length ;++i) {
      if (!(ifs[i] is IfElseInfo)){
        ifs[i] = IfElseInfo.fromJson(ifs[i]);
      }
    }
    var mainBlocky = blk.getCreateBody(key : ifs[0].guid);
    var mainCon = blk.getBlocky(ifs[0].guid);
    if (mainCon == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 条件表达式未设置, ${func.getTypeShowString()}");
      return 0;
    }
    var lastElse = blk.values["else"];
    // print("=================================== lastElse : $lastElse");
    if (lastElse != null && !(lastElse is IfElseInfo)){
      lastElse = blk.values["else"] = IfElseInfo.fromJson(lastElse);
    }

    // List endJumps  = List();
    List bws = List();

    {
      ByteDataWriter con = ByteDataWriter();
      int iConCount = CodeBlockyType.doCompile(mainCon, "bool", con, errLst, func);
      // bw.writeUint16(CodeBlockyType.OP_CON_JUMP , "if 判断");
      // int iOff = bw.getOffset();
      // bw.writeInt32( 0, "跳转距离");

      ByteDataWriter bw2 = ByteDataWriter();
      int iBlkCount = mainBlocky.doCompile(bw2, errLst, func);
      // bw.write(bw2.toBytes());
      // int iNewOff = bw.getOffset();
      // bw.setOffset(iOff);
      // bw.writeInt32( iBlkCount + 1, "修正跳转距离");
      // bw.setOffset(iNewOff);
      // iCount += (iConCount + iBlkCount + 1);
      // {
      //   bw.writeUint16(CodeBlockyType.OP_JUMP , "结束跳转");
      //   // var endOff = bw.getOffset();
      //   // endJumps.add({"off" : endOff , "count" : iCount});
      //   bw.writeInt32( 0, "结束跳转距离");
      //   ++iCount;
      // }
      bws.add({'con':con , 'blk':bw2 , 'conLength':iConCount , 'blkLength':iBlkCount});

    }


    // var els = res["elseIfs"] = [];
    for(var i = 1 ; i < ifs.length ;++i) {
      var iif = ifs[i] as IfElseInfo;
      var block = blk.getCreateBody(key : iif.guid);
      var exp = blk.getBlocky(iif.guid);
      if (exp == null){
        errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 条件表达式未设置, ${func.getTypeShowString()}");
        continue;
      }
      {
        ByteDataWriter con = ByteDataWriter();
        int iConCount = CodeBlockyType.doCompile(exp, "bool", con, errLst, func);
        // bw.writeUint16(CodeBlockyType.OP_CON_JUMP , "elseif 判断");
        // int iOff = bw.getOffset();
        // bw.writeInt32( 0, "跳转距离");
        // int iBlkCount = block.doCompile(bw, errLst, func);
        ByteDataWriter bw2 = ByteDataWriter();
        int iBlkCount = block.doCompile(bw2, errLst, func);
        // int iNewOff = bw.getOffset();
        // bw.setOffset(iOff);
        // bw.writeInt32( iBlkCount + 1, "修正跳转距离");
        // bw.setOffset(iNewOff);
        // iCount += (iConCount + iBlkCount + 1);
        // {
        //   bw.writeUint16(CodeBlockyType.OP_JUMP , "结束跳转");
        //   // var endOff = bw.getOffset();
        //   // endJumps.add({"off" : endOff , "count" : iCount});
        //   bw.writeInt32( 0, "结束跳转距离");
        //   ++iCount;
        // }
        bws.add({'con':con , 'blk':bw2 , 'conLength':iConCount , 'blkLength':iBlkCount});

      }
    }


    if (lastElse != null){// && !(lastElse is IfElseInfo)){
      var lb = blk.getCreateBody(key : lastElse.guid);

      ByteDataWriter bw2 = ByteDataWriter();

      int iBlkCount = lb.doCompile(bw2, errLst, func);
      bws.add({'blk':bw2 , 'blkLength':iBlkCount});
      // iCount += (iBlkCount);
    }

    int jumpCount = 0;
    for(var i = bws.length -1; i >=0 ; --i){
      var ele = bws[i];
      ele['jumpCount'] = jumpCount;
      var con = ele['con'];
      if (con != null){
        jumpCount += ele['blkLength'] + ele['conLength'] + 2;
      }
      else{
        jumpCount += ele['blkLength'];
      }
    }

    int iCount = 0;
    for(var ele in bws){
      var con = ele['con'];
      if (con != null){
        bw.writeBuffer(con);
        bw.writeUint16(CodeBlockyType.OP_CON_JUMP , "if/elif 判断");
        bw.writeInt32( ele['blkLength'] + 1, "跳转距离");
        bw.writeBuffer(ele['blk']);
        bw.writeUint16(CodeBlockyType.OP_JUMP , "分支结束跳转");
        bw.writeInt32( ele['jumpCount'], "结束跳转距离");

        iCount += ele['blkLength'] + ele['conLength'] + 2;
      }
      else{
        bw.writeBuffer(ele['blk']);
        iCount += ele['blkLength'];
      }
    }

    // int iAllOff = bw.getOffset();
    // for(var ej in endJumps){
    //   bw.setOffset(ej["off"]);
    //   bw.writeInt32( iCount - ej["count"], "修正结束跳转距离");
    // }
    // bw.setOffset(iAllOff);
    return iCount;

  }

}