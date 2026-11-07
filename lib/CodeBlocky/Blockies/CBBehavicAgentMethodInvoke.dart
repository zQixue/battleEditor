//@dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/BlockyTypes.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/CodeBlocky/CodeBlockyType.dart';
import 'package:battlepus/CodeBlocky/blocky_slot_editor.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentMethod.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';


class CBBehavicAgentMethodInvoke extends CodeBlockyType{

  @override
  String getBlockyType(CodeBlocky blk){

    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      return null;
    }

    var methodGuid = blk.values["method"]??"";
    var methodsMap = agent?.getAllMethods();

    if (agent != null){
      var crt = methodsMap[methodGuid];
      if (crt != null){
        return crt.withReturn? crt.returnType.getFullTypeWithExtra():"void";
      }
    }

    return null;
  }
  @override
  BehavicAgentClass getStructType(CodeBlocky blk){
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      return null;
    }

    var methodGuid = blk.values["method"]??"";
    var methodsMap = agent?.getAllMethods();

    if (agent != null){
      var crt = methodsMap[methodGuid];
      if (crt != null && crt.withReturn){
        var fi = SSFieldType.getFieldType(crt.returnType.typeGuid);
        if (fi is BehavicAgentClass){
          return fi;
        }
      }
    }
    return null;
  }

  bool isCurrentMethodValid(CodeBlocky blk){
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      return true;
    }
    var methodGuid = blk.values["method"]??"";
    var methodsMap = agent?.getAllMethods();
    BehavicAgentMethod crt = methodsMap[methodGuid];
    if(crt == null){
      return true;
    }
    return crt.isPublic && (blk.freeFunctionFlag || getBlockyType(blk) != "void");
  }
  @override
  Widget getBlockWidget(CodeBlocky blocky , String targetType , CBFunction func){
    var bgcolor2 = CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 1.2),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );

    var dc2 = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 0.4),
        color :Colors.white,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );


    if (blocky == null) {
      return Container(
        // height: 28,\
        padding: CodeBlockyType.basePadding,
        // width: 120,
        decoration: dc,
        child : Wrap(
          crossAxisAlignment: WrapCrossAlignment.center ,
          children: [


            Icon(MaterialCommunityIcons.alpha_m_box,color: Colors.indigo,size: 20,),
            Container(
              // padding: EdgeInsets.fromLTRB(CodeBlockyType.baseSplitWidth, 0, 2, 0),
              height: CodeBlockyType.baseRowHeight,
              child:Container(
                width: 60,
                decoration: dc2,
              ),
            ),
          ],
        ),
        //child:Center(child : Text(getTypeShowString() , style: style,)),
      );
    }
    // var blocky1 = blocky.getBlocky(0);

    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      return Container(
        decoration: dc,
        padding: CodeBlockyType.basePadding,
        child : Center(child : Text("脚本未指定")),
      );
    }

    var methodGuid = blocky.values["method"]??"";


    var methodsMap = agent?.getAllMethods();
    BehavicAgentMethod crt ;
    if (agent != null){
      crt = methodsMap[methodGuid];
    }
    List<BehavicAgentMethod> methods = methodsMap?.values?.where((element) => element.isPublic && (blocky.freeFunctionFlag || element.withReturn))?.toList()??List<BehavicAgentMethod>();

    dc = new BoxDecoration(
        border: new Border.all(color: bgColor, width: 1.2),
        color :(targetType != null && crt != null && crt.getFullTypeWithExtra() != targetType)?Colors.redAccent: bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
        borderRadius: new BorderRadius.circular((90.0))
    );

    if (targetType != null) {
      print("method tgt type = $targetType");
      methods = methods.where((element) => element.getFullTypeWithExtra() == targetType || CodeBlockyType.isObjectTypeValid(targetType , element.getFullTypeWithExtra()) ).toList();
    }

    if (CodeBlockyType.isTypeError(blocky , targetType) || !isCurrentMethodValid(blocky)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 0.5),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
    }

    var mcon = Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      key: ValueKey(blocky.guid),
      height: CodeBlockyType.baseRowHeight ,
      child:Row(
        children: [

          Tooltip(
            child: Icon(MaterialCommunityIcons.alpha_m_box,color: Colors.deepPurple ),
            message: "${crt == null?"未指定": (crt.withReturn??false?crt.returnType.getFullTypeWithExtra():"void")}",
          ),
          Text(crt?.getTypeShowString()??"" , style : TextStyle(color: Colors.brown , fontWeight: FontWeight.w600)),
          ThemeCenter.iconBtn(MaterialCommunityIcons.menu,color: Colors.black,
              tooltip: "选择 agent 函数",
              onPressed: (){
                CommonUtil.popupTreeMenu(methods, CommonUtil.getGlobalContex(),
                  title: "选择 agent 函数",
                  width: 600,
                  height: 800,
                  onBuildItem: (clz){
                    var txt = Text((clz as BehavicAgentMethod).getTypeShowString() , style : clz == crt ? TextStyle(color: Colors.greenAccent):null);
                    return Row(
                      children: [
                        Container(width: 4,),
                        Expanded(child : txt),
                      ],
                    );
                  },
                  // onBuildGroup: (node){
                  //   return Text(node.name??"");
                  // },
                  onResult: (clz){
                    if (clz == null) return ;
                    if ((clz as BehavicAgentMethod).guid != blocky.values["method"]){
                      HistoryManager.functionHistory?.appendHistory();
                      blocky.values.clear();
                      blocky.subBlockies.clear();
                      blocky.values["method"] = (clz as BehavicAgentMethod).guid;
                      print("method clear");
                      EventCenter.eventBus.fire(BlockContainerRefresh());

                    }
                  },
                  // actions: [
                  //   RaisedButton(
                  //     child: Text("清空"),
                  //     color: Colors.redAccent,
                  //     onPressed: (){
                  //       widget.onClear?.call();
                  //       Navigator.pop(context);
                  //     },
                  //   )
                  // ]
                );
              }
          ),
        ],
      ),
      // decoration: dc,
    );
    List<Widget> ms = List<Widget>();
    ms.add(mcon);
    if (crt!= null){
      var prms = crt.params.values.toList();
      prms.sort((a,b)=>a.index - b.index);
      for(var i = 0 ; i < prms.length ; ++i){
        var prm = prms[i];
        var flag = BlockyTypes.BT_METHOD|BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST;
        if (prm.isRef){
          flag = BlockyTypes.BT_VAR;
        }
        var dtgt1 = BlockySlotEditor( targetType: prm.getFullTypeWithExtra() , blockFlag: flag,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: prm.guid,);
        // ms.add(Tooltip(
        //   child: dtgt1,
        //   message: "${prm.getFullType()} ${prm.name}",
        // ));
        ms.add(Tooltip(
          child: Icon(MaterialCommunityIcons.alpha_p_box,color: prm.isRef?Colors.red:Colors.green ),
          message:"${prm.getFullTypeWithExtra()} ${prm.name}",
        ));
        ms.add(dtgt1);
        if (i < prms.length-1)ms.add(Icon(MaterialCommunityIcons.comma,color: Colors.black,size: 12,));
      }
    }

    // var dtgt1 = BlockySlotEditor(blockFlag: BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "0",);
    // var dtgt2 = BlockySlotEditor(blockFlag: BlockyTypes.BT_EXPR|BlockyTypes.BT_VAR|BlockyTypes.BT_CONST,defaultWidgetBlockFlag: BlockyTypes.BT_VAR ,container: blocky,slot: "1",);
    //
    // var operate = blocky.values["operate"]??"+";
    // var op = CommonUtil.getStringDropdown("选择运算符",(itm){
    //   return operateIcons[itm];
    // }
    //     ,operateTypes
    //     ,operate, (v){
    //       // blocky.setBlocky(2, v);
    //       blocky.values["operate"] = v;
    //       EventCenter.eventBus.fire(BlockContainerRefresh());
    //     },menuIcon: operateIcons[operate]);
    if (CodeBlockyType.isTypeError(blocky , targetType)){
      dc = new BoxDecoration(
          border: new Border.all(color: bgColor, width: 0.5),
          color : Colors.redAccent,
          //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
          boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: bgcolor2)],
          borderRadius: new BorderRadius.circular((90.0))
      );
    }
    var con = Container(
      decoration: dc,
      padding: CodeBlockyType.basePadding,
      // height: CodeBlockyType.baseRowHeight,
      child : Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: ms
      ),
      //child:Center(child : Text(getTypeShowString() , style: style,)),
    );
    return con;
  }
  CBBehavicAgentMethodInvoke(){
    typeFlag = BlockyTypes.BT_METHOD;
    // bgColor = Colors.deepPurpleAccent;
    setDefaultColor(Colors.deepPurpleAccent);
    name = "AgentFuncCall";
    alias = "Agent函数调用";
  }

  List<String> operateTypes =["+","-","X","/","div","mod"];
  Map<String,Widget> operateIcons ={
    "+" : Icon(MaterialCommunityIcons.plus , color: Colors.indigo,size:22),
    "-" : Icon(MaterialCommunityIcons.minus , color: Colors.indigo,size:22),
    "X" : Icon(Entypo.cross , color: Colors.indigo,size:22),
    "/" : Icon(MaterialCommunityIcons.division , color: Colors.indigo,size:22),
    "div" : Text("整除" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo)),//Icon(MaterialCommunityIcons.div , color: Colors.indigo,size:22),
    "mod" : Text("取余" , style: TextStyle(fontSize: 14 , fontWeight: FontWeight.w700,color: Colors.indigo))//Icon(MaterialCommunityIcons. , color: Colors.indigo,size:22),
  };
  //
  // static FieldInfo getField(String guid){
  //   var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current.behavicAgentGuid??""];
  //   var f = agent?.getFieldByGuid(guid);
  //   // if (!f.isPublic) return null;
  //   return f;
  // }

  @override
  dynamic getExportFuncInfo(CodeBlocky blk , {dynamic tag = 0}){
    var res = Map<String , dynamic>();
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      return res;
    }

    var methodGuid = blk.values["method"]??"";
    var methodsMap = agent?.getAllMethods();
    BehavicAgentMethod crt ;
    if (agent != null){
      crt = methodsMap[methodGuid];
    }
    if(crt == null){
      return res;
    }
    if(!crt.isPublic){
      return res;
    }
    if (!isCurrentMethodValid(blk)){
      return res;
    }
    var prms = crt.params.values.toList();
    List params = List();
    prms.sort((a,b)=>a.index - b.index);
    // int iCount = 0;
    for(var i = 0 ; i < prms.length ; ++i){
      var prm = prms[i];
      var blk1 = blk.getBlocky(prm.guid);
      if (blk1 == null){
        params.add({});
      }
      Map op = {"code":blk.getBlockyCode(prm.guid)};
      if (i == prms.length-1){
        op["isLast"] = true;
      }
      params.add(op);
    }
    res["params"] = params;
    res["method"] = crt.exportInfo();
    return res;
  }

  @override
  String getExportBehavicFuncInfo(CodeBlocky blk, {dynamic tag = 0}){
    StringBuffer sb = StringBuffer();
    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      return "";
    }

    var methodGuid = blk.values["method"]??"";
    var methodsMap = agent?.getAllMethods();
    BehavicAgentMethod crt ;
    if (agent != null){
      crt = methodsMap[methodGuid];
    }
    if(crt == null){
      return "";
    }
    if (!isCurrentMethodValid(blk)){
      return "";
    }
    sb.write("${crt.name}(");
    var prms = crt.params.values.toList();
    prms.sort((a,b)=>a.index - b.index);

    for(var i = 0 ; i < prms.length ; ++i){
      var prm = prms[i];
      var blk1 = blk.getBlocky(prm.guid);
      if (blk1 != null){
        sb.write("${blk.getBlockyBehavicCode(prm.guid)}");
      }
      if (i < prms.length-1){
        sb.write(",");
      }
    }
    sb.write(")");
    return sb.toString();
  }

  @override
  int compile(CodeBlocky blk , String targetType , ByteDataWriter bw , List<String> errLst, CBFunction func){

    var agent = StateScriptProject.instance.behavicAgentProject.classes[ScriptInfo.current?.behavicAgentGuid??""];
    if (agent == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 指定的Agent无效, ${func.getTypeShowString()}");
      return 0;
    }
    var methodGuid = blk.values["method"]??"";
    var methodsMap = agent?.getAllMethods();
    BehavicAgentMethod crt ;
    if (agent != null){
      crt = methodsMap[methodGuid];
    }
    if(crt == null){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 指定的函数无效, ${func.getTypeShowString()}");
      return 0;
    }
    if(!crt.isPublic){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 指定的函数不可访问, ${func.getTypeShowString()}");
      return 0;
    }
    if (!isCurrentMethodValid(blk)){
      errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 指定的函数无效,请检查返回类型是否符合 ${func.getTypeShowString()}");
      return 0;
    }
    var prms = crt.params.values.toList();
    prms.sort((a,b)=>a.index - b.index);
    int iCount = 0;
    for(var i = 0 ; i < prms.length ; ++i){
      var prm = prms[i];
      var blk1 = blk.getBlocky(prm.guid);
      if (blk1 == null){
        // print("---------------------------------------------- 结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 参数 ${prm.getFullTypeWithExtra()} 未设置, ${func.getTypeShowString()}");
        errLst.add("结点 ${StateScriptNode.crtExportNode.exportId} , ${getTypeShowString()} 参数 ${prm.getFullTypeWithExtra()} 未设置, ${func.getTypeShowString()}");
        return 0;
      }
      iCount += CodeBlockyType.doCompile(blk1, prm.getFullTypeWithExtra(), bw, errLst, func);
    }

    // bw.writeUint16(CodeBlockyType.OP_PUSH_FUNCID , "函数ID压栈");
    // bw.writeUint32(crt.exportId, "函数id");
    bw.writeUint16(CodeBlockyType.OP_CALL_FUNC, "调用函数");
    bw.writeUint32(crt.exportId, "函数id");
    ++iCount;

    for(var i = 0 ; i < prms.length ; ++i){
      var prm = prms[i];
      if (!prm.isRef) continue;
      var blk1 = blk.getBlocky(prm.guid);
      var tp = CodeBlockyType.getType(blk1.blockyTypeId);
      // print("--------------------- tp : ${tp.name}");
      var count = tp.compileRef(blk1,targetType,bw,errLst,func);
      iCount += count;
      
      // iCount += CodeBlockyType.doRefCompile(blk1, prm.getFullTypeWithExtra(), bw, errLst, func);
    }

    return iCount;
  }
}