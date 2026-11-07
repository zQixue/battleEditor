//@dart=2.11
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Realtime/RunSession.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/InParam.dart';
import 'package:battlepus/StateScript/Struct/InPort.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/OutParam.dart';
import 'package:battlepus/StateScript/Struct/OutPort.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/PortInfo.dart';
import 'package:battlepus/StateScript/Struct/RefSubScript.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/StateScript/right_tool_bar.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/s_s_canvas_view.dart';
import 'package:battlepus/StateScript/state_script_node_view.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FSwitch.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/ZoomEx.dart';
import 'package:battlepus/common/drag_target_ex.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/common/text_editor.dart';


class ModulePanel extends StatefulWidget {
  final RefSubScript subScript;
  final SSCanvasViewState graph;
  final Function(String) onSubmitted;
  ModulePanel({Key key , this.subScript , this.onSubmitted , this.graph}) : super(key: key);

  @override
  _ModulePanelState createState() => _ModulePanelState();
}

class _ModulePanelState extends State<ModulePanel> {

  bool _storeHistory = false;

  @override
  Widget build(BuildContext context) {

    var res = ThemeCenter.iconBtn(MaterialCommunityIcons.menu,
      // padding: EdgeInsets.all(0),
      // icon : Icon(MaterialCommunityIcons.menu , ),
      // iconSize: SSDefines.iconButtonSize,
      tooltip: "选择模块",
      color: Colors.white,
      onPressed: (){
        showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext context) {
            var child = getScriptChooser(widget.subScript.scriptId , onlyModule: true);
            return Dialog(child: child);
          },
        ).then((value) {
          // print(value);
          if (value == null) return ;
          HistoryManager.scriptHistory.appendHistory();
          if (value == empty) {
            widget.onSubmitted?.call("");
            widget.subScript.scriptId = "";
            setState(() {
              widget.subScript.reload(ScriptInfo.current.guid);
            });
            ScriptInfo.current.scriptData.loadSubScripts(ScriptInfo.current.guid);
            ScriptInfo.current.scriptData.initConnectionCount();
            EventCenter.eventBus.fire(GlobalRefreshEvent());
          }
          // else{
          //   widget.subScript.scriptId = (value as ScriptInfo).guid;
          //   widget.onSubmitted?.call((value as ScriptInfo).guid);
          //   setState(() {
          //     widget.subScript.reload(ScriptInfo.current.guid);
          //   });
          //   ScriptInfo.current.scriptData.loadSubScripts(ScriptInfo.current.guid);
          //   ScriptInfo.current.scriptData.initConnectionCount();
          //   EventCenter.eventBus.fire(GlobalRefreshEvent());
          // }

        });
      },
    );
    var del = ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
      // padding: EdgeInsets.all(0),
      // icon : Icon(MaterialCommunityIcons.close_box_outline , ),
      // iconSize: SSDefines.iconButtonSize,
      color: (widget.subScript.errorInfo != null)? Colors.black : Colors.redAccent  ,
      tooltip: "删除模块",
      onPressed: (){
        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
          setState(() {
            HistoryManager.scriptHistory.appendHistory();
            ScriptInfo.current.scriptData.deleteSubScript(widget.subScript);
            ScriptInfo.current.scriptData.loadSubScripts(ScriptInfo.current.guid);
            ScriptInfo.current.scriptData.initConnectionCount();
            EventCenter.eventBus.fire(GlobalRefreshEvent());
          });
        });
      },
    );

    var expand = ThemeCenter.iconBtn(MaterialCommunityIcons.ungroup,
      // padding: EdgeInsets.all(0),
      // icon : Icon(MaterialCommunityIcons.close_box_outline , ),
      // iconSize: SSDefines.iconButtonSize,
      color: (widget.subScript.errorInfo != null)? Colors.white : Colors.indigo  ,
      tooltip: "展开",
      onPressed: (){
        CommonUtil.confirm(context, "确定要展开吗?",onOk: (){
          setState(() {
            HistoryManager.scriptHistory.appendHistory();
            widget.subScript.expandModule(ScriptInfo.current.scriptData);
            ScriptInfo.current.scriptData.deleteSubScript(widget.subScript);
            ScriptInfo.current.scriptData.loadSubScripts(ScriptInfo.current.guid);
            ScriptInfo.current.scriptData.initConnectionCount();
            EventCenter.eventBus.fire(GlobalRefreshEvent());
          });
        });
      },
    );

    var clone = ThemeCenter.iconBtn(MaterialCommunityIcons.content_copy,
      color: (widget.subScript.errorInfo != null)? Colors.white : Colors.indigo  ,
      tooltip: "复制",
      onPressed: (){
          var n = RefSubScript();
          n.x = widget.subScript.x + 64;
          n.y = widget.subScript.y + 64;
          print("${n.x} ${n.y}");
          n.scriptId = widget.subScript.scriptId;

          HistoryManager.scriptHistory.appendHistory();
          ScriptInfo.current.scriptData.addSubScript(n);
          ScriptInfo.current.scriptData.loadSubScripts(n.guid);
          ScriptInfo.current.scriptData.initConnectionCount();
          n.collectModuleInterfaces();
          copyFields(widget.subScript , n);

          EventCenter.eventBus.fire(GlobalRefreshEvent());
          //
          // setState(() {
          //   bShowList = false;
          // });
      },
    );

    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == (widget.subScript?.scriptId??""), orElse:()=>null);
    var opn = ThemeCenter.iconBtn(MaterialCommunityIcons.link_box_outline,
      // padding: EdgeInsets.all(0),
      // icon : Icon(MaterialCommunityIcons.link_box_outline , ),
      // iconSize: SSDefines.iconButtonSize,
      tooltip: "打开编辑",
      color: Colors.white,
      onPressed: (){


        if (scriptInfo == null){
          return ;
        }
        RightToolBarState.scriptStack.push(ScriptInfo.current.guid);

        ScriptInfo.current = scriptInfo;
        ScriptInfo.addOpenScript(scriptInfo);
        ZoomState.current.centered();
        EventCenter.eventBus.fire(GlobalRefreshEvent());
      },
    );
    Widget con ;
    // var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == widget.subScript?.scriptId??"", orElse:()=>null);
    var name = scriptInfo?.name??"";
    // if (scriptInfo == null){
    //   return Text("未指定", style: style,);
    // }
    var headRow = Row(
      children: [
        Container(
          // width: 24,
          // height: 20,
          child : FSwitch(
            width: 24,
            height: 16,
            open: widget.subScript.isExpanded??false,
            onChanged: (v){
              widget.subScript.isExpanded = v;
              EventCenter.eventBus.fire(GlobalRefreshEvent());
            },
          ),
          // child: Checkbox(
          //   activeColor: Colors.white,
          //   value: widget.subScript.isExpanded??false,
          //   onChanged: (v){
          //     widget.subScript.isExpanded = v;
          //     EventCenter.eventBus.fire(GlobalRefreshEvent());
          //   },
          // ),
        ),

        if (widget.subScript.errorInfo != null) Icon(MaterialCommunityIcons.bug_outline , size: 20, color: Colors.white,),
        // Icon(MaterialCommunityIcons.fire , size: 28,),
        Expanded(
            child:TextEditor(
              initValue: name,
              onChanged: (v){
                // widget.subScript?.name = v;
                scriptInfo.name = v;
              },
            ),
        ),
        Text("[${widget.subScript.exportId??""}]", style: SSDefines.lineContentStyle),
        const SizedBox(width: 8,),
        getValueLabelWidget(widget.subScript?.scriptId??"",style:  SSDefines.lineContentStyle,),
        if(scriptInfo!=null) opn,
        if(scriptInfo!=null && widget.subScript.isExpanded)expand,
        res,
        clone,
        del,
      ],
    );
    var clr1 = Color(0xFF303030);//Color(0xFF336633);
    var nodeOutDec = new BoxDecoration(
      // color:Colors.white,
        border: new Border.all(color: Colors.green, width: 2),
        color: (widget.subScript.errorInfo != null)?Colors.redAccent: clr1,
        // color : inDebug?mainColor:Color.fromARGB(255,30, 30, 30),
        // boxShadow: [ BoxShadow(color: (widget.node.selected??false)? CommonUtil.alphaColor(Colors.lightGreen,220):mainColor, offset:Offset(0.0, 0.0),    blurRadius:  widget.node.selected??false?6.0:0.0, spreadRadius: widget.node.selected??false?8.0:0.0) , BoxShadow(color: Colors.white)],
        // // shape: BoxShape.rectangle, // 默认值也是矩形
        // borderRadius: new BorderRadius.circular(((nodeType.getIsTimelineNode()??false)?1.0:5.0))
    );

    if (!widget.subScript.isExpanded){

      var cols = List<Widget>();
      cols.add(Container(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 6),
        alignment: Alignment.center,
        color: (widget.subScript.errorInfo != null)?Colors.redAccent: clr1,
        height: SSDefines.moduleHeadHeight,
        width: moduleWidth,
        child: headRow,
        // decoration: nodeOutDec,
      ));

      buildModuleInterface(cols);
      con = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
        // color: (widget.subScript.errorInfo != null)?Colors.redAccent: clr1,
        // height: SSDefines.moduleHeadHeight,
        width: moduleWidth,
        decoration: nodeOutDec,
        child: Column(
          children: cols,
        )
      );
    }
    else{
      con = Container(
        // color: (widget.subScript.errorInfo != null)?Colors.redAccent: clr1,
        height: SSDefines.moduleHeadHeight,
        width: moduleWidth,
        child: headRow,
        decoration: nodeOutDec,
      );
    }

    var dnn2 = GestureDetector(
      dragStartBehavior : DragStartBehavior.down,
      child: con,
      onTapDown: (e) {
        // print("onTapDown");
        // onHeadTapDown();

        _storeHistory = false;
      },
      onPanStart: (e){
        // print("onPanStart");
        SSDefines.isInDagging = true;
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());//RefreshConnectCommandEvent().globalRefresh = true);
        EventCenter.eventBus.fire(PortClickEvent()..node = null);
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = 100);
        // onHeadTapDown(noEditing : true);
        dragStorePos(e);

      },
      onPanUpdate: (e){
        // print("pan update");
        SSDefines.isInDagging = true;

        if (!_storeHistory) {
          HistoryManager.scriptHistory.appendHistory();
          _storeHistory = true;
        }

        int count = dragUpdatePos(e, widget.graph);
        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        // EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=true);

        if (widget.subScript.isExpanded) move();
        return;
      },
      onPanEnd: (e){
        SSDefines.isInDagging = false;
        // setState(() {
        // if (darggingEventTimer != null){
        //   darggingEventTimer.cancel();
        //   darggingEventTimer = null;
        // }
        dragEndPos(e, widget.graph);

        EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());//RefreshConnectCommandEvent().globalRefresh = true);
        EventCenter.eventBus.fire(LocationFlagEvent()..scale = ZoomState.current.getScale()..bForce = true);
        // sendDragUpdatePosEvent();
        // EventCenter.eventBus.fire(RefreshMultiDraggingEvent()..bShow=false);
        move();
      },
    );

    return Positioned(
      left: widget.subScript.x ,//- SSDefines.portOffX ,
      top: widget.subScript.y,
      child: dnn2,//RepaintBoundary(child:dnn2),
    );
  }

  void buildModuleInterface(List<Widget> cols){
    var mis = widget.subScript.misInScripts;
    totalLineHeight = SSDefines.moduleHeadHeight ;
    var miInPorts = mis.where((element) => element.type == InterfaceType.InPort).toList();
    var miOutPorts = mis.where((element) => element.type == InterfaceType.OutPort).toList();

    getPortsWidget(miInPorts,miOutPorts,cols);

    var miInParams = mis.where((element) => element.type == InterfaceType.InParam).toList();
    var miOutParams = mis.where((element) => element.type == InterfaceType.OutParam).toList();

    getParamsWidget(miInParams , miOutParams,cols);
  }
  double totalLineHeight = 0 ;
  final double moduleWidth = 420;
  var textStyle = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);

  void copyFields(RefSubScript src , RefSubScript dst){
    var mis = src.misInScripts;
    var miInParams = mis.where((element) => element.type == InterfaceType.InParam).toList();
    Map<String ,FieldValueHolder> vals = {};
    miInParams.forEach((inparam) {
      var inNode = inparam?.ownerNode;
      var inRealParam = inNode?.getInParam(inparam?.interfaceGuid);
      var f = inNode.getNodeStructType().getField(inRealParam.bindFieldGuid);
      if (f != null) {
        vals[inparam?.guid] = ScriptInfo.current.scriptData.overrideFieldValues["${inNode.guid}-${f.guid}"];
      }
    });

    var misDst = dst.misInScripts;
    var miInParamsDest = misDst.where((element) => element.type == InterfaceType.InParam).toList();
    miInParamsDest.forEach((inparam) {
      var inNode = inparam?.ownerNode;
      var inRealParam = inNode?.getInParam(inparam?.interfaceGuid);
      var f = inNode.getNodeStructType().getField(inRealParam.bindFieldGuid);
      if (f != null) {
        ScriptInfo.current.scriptData.overrideFieldValues["${inNode.guid}-${f.guid}"] = FieldValueHolder.clone(vals[inparam?.guid]);
      }
    });
  }

  void getParamsWidget(List<ModuleInterface> miInPorts , List<ModuleInterface> miOutPorts , List<Widget> lines ) {

    var _sb4 = const SizedBox(width: 2,);
    var fullParamLineCount = max(miInPorts.length,miOutPorts.length);


    for(int i = 0 ; i < fullParamLineCount;++i){
      var withIn = i < miInPorts.length;
      var withOut = i < miOutPorts.length ;
      var inparam = withIn ? miInPorts[i]:null;
      var outparam = withOut ? miOutPorts[i]:null;

      var outNode = outparam?.ownerNode;
      var inNode = inparam?.ownerNode;

      var inNodeType = inNode?.getNodeStructType();
      var outNodeType = outNode?.getNodeStructType();

      withIn = withIn && inNodeType != null;
      withOut = withOut && outNodeType != null;

      var inRealParam = inNode?.getInParam(inparam?.interfaceGuid);
      var outRealParam = outNodeType?.getOutParam(outparam?.interfaceGuid);

      var inStr = DartCommon.isEmpty(inparam?.name)?inRealParam?.getTypeShowString():inparam?.name;
      var outStr = DartCommon.isEmpty(outparam?.name)?outRealParam?.getTypeShowString():outparam?.name;

      Widget rowLine ;

      // if (hideNoConnection){
      //   bool bInWithConnection = withIn && ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam);
      //   bool bOutWithConnection = withOut && ScriptInfo.current.getScriptData().hasOutParamConnection(node , nodeType.outParams[i]);
      //   withIn &= bInWithConnection;
      //   withOut &= bOutWithConnection;
      // }
      if (!withIn && !withOut) continue;

        bool withSubParams = withOut && outNode.getSubParamsByParamGuid(outRealParam.guid).length>0;
        rowLine = Container(
          padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding, 0, SSDefines.innerHPadding , 0),
          height: SSDefines.nodeParamHeight,
          child: Row (
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                !withIn?SizedBox(width:0):getInParamWidget(inNodeType , inNode , inRealParam),
                _sb4,
                !withIn?SizedBox(width:0):Text(inStr??"无效", maxLines: 1, overflow: TextOverflow.clip , style: textStyle),
                Expanded(child:Container()),
                !withOut?SizedBox(width:0):Text(outStr ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
                _sb4,
                if (withSubParams) Icon(MaterialCommunityIcons.link_box_variant , size: 12,),
                !withOut?SizedBox(width:0):getOutParamWidget(outNodeType , outNode , outRealParam),
              ]
          ),
        );

      lines.add(rowLine);
      if (withIn){
        var key = "${inNode.guid}_${inRealParam?.guid??""}";
        inNode.portYPos[key] = Offset(widget.subScript.x+SSDefines.portSize/2 , widget.subScript.y+totalLineHeight + SSDefines.nodeParamHeight/2);
      }
      if (withOut){
        var key = "${outNode.guid}_${outRealParam.guid}";
        outNode.portYPos[key] =  Offset(widget.subScript.x + moduleWidth - SSDefines.portSize/2 , widget.subScript.y + totalLineHeight + SSDefines.nodeParamHeight/2);
      }
      totalLineHeight += SSDefines.nodeParamHeight;

      if (withIn && inRealParam != null && !DartCommon.isEmpty(inRealParam.bindFieldGuid)){
        getFieldWidgets(inRealParam.bindFieldGuid,inNode,inNodeType,lines,inNode.fieldValues);
        // totalLineHeight -= SSDefines.nodeFieldRowHeight;
      }
    }
  }

  var nodeHeaderStyle = const TextStyle(fontSize: 14 , color: Colors.grey , fontWeight: FontWeight.w800 ,);
  var paramHeaderStyle = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);
  var fieldHeaderStyle = const TextStyle(fontSize: 12 , color: Colors.grey , fontWeight: FontWeight.w500 ,);
  double getFieldWidgets(String fguid , StateScriptNode node , NodeStructData nodeType ,List<Widget> lines , Map<String,dynamic> values ){

    bool flip = false;
    double finalHeight = 0;
    // var parent = StateScriptProject.instance.structMap[nodeType.baseType];
    // if (parent != null) finalHeight += getFieldWidgets(node , parent , lines , values , flip);

    var extraPadding = 20.0;

    var lastVarTypeGuid = "";
    {//for(var f in nodeType.fields){
      var f = nodeType.getField(fguid);
      if (f == null) return 0;
      // var lf = nodeType.getLastField(lastVarTypeGuid);
      //
      // // var fguid = f.guid;
      // if (lf != null){
      //
      //
      //     var ft = SSFieldType.getFieldType(lf.typeGuid , fieldInfo: lf);
      //     if (ft != null) {
      //       if (ft.guid == "___agentvar___") {
      //         var crtV = values[lf.guid];
      //         var guid = ft.parseValue(crtV.value);
      //         var fields = StateScriptProject.instance.getAgentFieldInfos();
      //         var field = CommonUtil.getItemByGuid(fields, guid);
      //         if (field != null) {
      //           lastVarTypeGuid = field.typeGuid;
      //         }
      //       }
      //       if (ft.guid == "___scriptvar___") {
      //         var crtV = values[lf.guid];
      //         var guid = ft.parseValue(crtV?.value);
      //         var field = ScriptInfo.current.scriptData.fullScriptsFields[guid]; //CommonUtil.getItemByGuid(fields, guid);
      //         if (field != null) {
      //           // print("----- ${field.typeGuid}");
      //           lastVarTypeGuid = field.typeGuid;
      //         }
      //       }
      //     }
      //     else{
      //       print("[字段类型缺失] ${lf.typeGuid}");
      //     }
      //
      //   // lastVarTypeGuid = lf.typeGuid;
      // }

      EditorLevelInfo ei = EditorLevelInfo()..fontSize = 12..lastVarTypeGuid = lastVarTypeGuid;
      // print("set 4 : $lastVarTypeGuid");
      lastVarTypeGuid="";
      // var inParam = nodeType.getBindInParam(fguid);

      // bool isLock =  (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(inParam?.guid)));
      // if (isLock && inParam == null) {
      //   var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      //
      //   if (ft.guid == "___agentvar___"){
      //     var crtV = values[fguid];
      //     var guid = ft.parseValue(crtV.value);
      //     var fields = StateScriptProject.instance.getAgentFieldInfos();
      //     var field = CommonUtil.getItemByGuid(fields, guid);
      //     if (field != null){
      //       lastVarTypeGuid = field.typeGuid;
      //     }
      //   }
      //   if (ft.guid == "___scriptvar___"){
      //     var crtV = values[fguid];
      //     var guid = ft.parseValue(crtV.value);
      //     // var fields = ScriptInfo.current.scriptData.scriptFields;
      //     var field = ScriptInfo.current.scriptData.fullScriptsFields[guid];//CommonUtil.getItemByGuid(fields, guid);
      //     if (field != null){
      //       lastVarTypeGuid = field.typeGuid;
      //     }
      //   }
      //   SSDefines.lastEnumValue = -1;
      //   continue;
      // }
      // bool bWithConnection = inParam != null ? ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam) : false;
      var templateVal = values[fguid];
      bool bOverrided = false;
      var crtVal = templateVal;
      if (node.isModuleNode){
        //模块结点
        fguid = "${node.guid}-$fguid";
        values = ScriptInfo.current.scriptData.overrideFieldValues;
        // if (templateVal != null && values[fguid] == null) values[fguid] =
        if (values[fguid] == null) {
          var fvh = FieldValueHolder();
          fvh.name = f.getTypeShowString();
          fvh.value = templateVal?.value;
          values[fguid] = fvh;
        }
        bOverrided = values[fguid] != null && templateVal?.value != values[fguid]?.value;
        // print("??? override value : ${values[fguid]?.value}");
        crtVal = values[fguid];
      }
      bool bHideEdt = false;//!node.inEditting ;//|| bWithConnection;
      var _sb4 = const SizedBox(width: 2,);

      // print("node type : ${nodeType.name}");
      var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
      // print("ft : $ft");
      // var crtV = values[fguid];
      if (crtVal == null) {
        var fvh = FieldValueHolder();
        fvh.name = f.getTypeShowString();
        fvh.value = ft.parseValue(f.defaultValue);
        crtVal = fvh;
        values[fguid] = fvh;
      }


      var edt = ft.getThinEditWidget(
        // ft.parseValue(crtV.value),
        crtVal.value,
            (v){
          var old = crtVal.value;
          var nodeId = node.guid;
          HistoryManager.scriptHistory.appendCallbackHistory("${node.guid}-${fguid}",
                  (){
                // setState(() {
                if (ScriptInfo.current!=null && ScriptInfo.current.scriptData!= null){
                  var node = ScriptInfo.current.scriptData.nodeMap[nodeId];
                  if (node != null) {
                    node.fieldValues[fguid].value = old;
                    node.inEditting = true;
                    EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
                  }
                }
                // });
              },
                  (){
                // setState(() {
                if (ScriptInfo.current!=null && ScriptInfo.current.scriptData!= null){
                  var node = ScriptInfo.current.scriptData.nodeMap[nodeId];
                  if (node != null) {
                    node.inEditting = true;
                    node.fieldValues[fguid].value = v;
                    EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = node);
                  }
                }
                // });
              });
          values[fguid].value = v;
          // if (node.getNodeStructType().syncTransform ) {
          //   //
          //   if ((f.name == "position" || f.name == "rotation") && ft.guid == "___vector3___") {
          //     // print("0000000000000000");
          //     ObjInfo info = node.getTransformInfo(null);
          //     PackSolver.registerTransitionObject(node);
          //     Transport.instance.sendUdpData(OPackType.O2U_SigleObject, info);
          //   }
          // }

          //battlepus runtime 实时更新
          // print(RunSession.instance.remoteIsPlaying);
          // if (RunSession.instance.remoteIsPlaying){
          //   if (ScriptInfo.current != null){
          //     var scriptHashCode = ScriptInfo.current.guid.hashCode;
          //     var nodeId = widget.node.exportId;
          //     RunSession.instance.sendRuntimeRefreshNodeData(scriptHashCode,nodeId,widget.node);
          //   }
          // }
        },
            (v){
          setState(() {
            values[fguid].value = v;
            // print("111111");
            //battlepus runtime 实时更新
            // print(RunSession.instance.remoteIsPlaying);
            if (RunSession.instance.remoteIsPlaying){
              if (ScriptInfo.current != null){
                var scriptHashCode = ScriptInfo.current.guid.hashCode;
                var nodeId = node.exportId;
                RunSession.instance.sendRuntimeRefreshNodeData(ScriptInfo.current.exportId,nodeId,node);
              }
            }
          });
        },
        SSDefines.nodeFieldRowHeight,
        levelInfo: ei..fi = f ..lineCount = f.lineCount .. isModule = true..fieldValueHolder = values[fguid]..onFocus=(){
          if (!node.selected && !node.isModuleNode){
            ScriptInfo.current.unselectAll();
            node.selected = true;
          }
        },
        bOpen: true,
        context: context,
      );
      if (ft.guid == "___agentvar___"){
        var guid = ft.parseValue(crtVal.value);
        var fields = StateScriptProject.instance.getAgentFieldInfos();
        var field = CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }
      if (ft.guid == "___scriptvar___"){
        var guid = ft.parseValue(crtVal.value);
        // var fields = ScriptInfo.current.scriptData.scriptFields;
        var field = ScriptInfo.current.scriptData.fullScriptsFields[guid];//CommonUtil.getItemByGuid(fields, guid);
        if (field != null){
          lastVarTypeGuid = field.typeGuid;
        }
      }

      if (bOverrided){
        var row = Container(
          height: edt.height,
          // color: bOverrided?Colors.amber:null,
          child: Column(
            children: [
              // if(!bHideEdt || bWithConnection) header,
              if (!bHideEdt) Container(
                color: bOverrided?Colors.amber.withAlpha(30):null,
                child:Row(
                  children: [
                    Expanded(
                      child:Container(

                        // padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding , 0, SSDefines.innerHPadding + extraPadding, 0),
                          padding: flip?EdgeInsets.fromLTRB(SSDefines.innerHPadding , 0, SSDefines.innerHPadding+ extraPadding, 0):
                          EdgeInsets.fromLTRB(SSDefines.innerHPadding + extraPadding, 0, SSDefines.innerHPadding, 0),
                          child : edt.widget
                      ),
                    ),
                    if (bOverrided) ThemeCenter.iconBtn(MaterialCommunityIcons.alpha_o_box,
                        color: Colors.redAccent,
                        tooltip: "清理重载",
                        onPressed: (){
                          setState(() {
                            ScriptInfo.current.scriptData.overrideFieldValues[fguid] = null;

                            if (RunSession.instance.remoteIsPlaying ){
                              if (ScriptInfo.current != null){
                                var scriptHashCode = ScriptInfo.current.guid.hashCode;
                                var nodeId = node.exportId;
                                RunSession.instance.sendRuntimeRefreshNodeData(ScriptInfo.current.exportId,nodeId,node);
                              }
                            }
                          });

                        }
                    )
                  ],
                ),
              )
              // if (bOverrided) ThemeCenter.iconBtn(MaterialCommunityIcons.alpha_o_box,
              //   tooltip: "清理重载",
              //   onPressed: (){
              //     setState(() {
              //       ScriptInfo.current.scriptData.overrideFieldValues[fguid] = null;
              //     });
              //
              //   }
              // )

            ],
          ),
        );

        lines.add(row);
      }
      else{
        var row = Container(
          height: edt.height,
          child: Column(
            children: [
              // if(!bHideEdt || bWithConnection) header,
              if (!bHideEdt ) Container(
                  color: bOverrided?Colors.amber.withAlpha(30):null,
                  // padding: EdgeInsets.fromLTRB(SSDefines.innerHPadding , 0, SSDefines.innerHPadding + extraPadding, 0),
                  padding: flip?EdgeInsets.fromLTRB(SSDefines.innerHPadding , 0, SSDefines.innerHPadding+ extraPadding, 0):
                  EdgeInsets.fromLTRB(SSDefines.innerHPadding + extraPadding, 0, SSDefines.innerHPadding, 0),
                  child : edt.widget
              ),

            ],
          ),
        );

        lines.add(row);
      }

      // if (inParam != null){
      //   var key = "${node.guid}_${inParam.guid}";
      //   node.portYPos[key] = Offset(node.x+SSDefines.portSize/2 , node.y + node.totalLineHeight + SSDefines.nodeFieldRowHeight/2 );//+ SSDefines.nodeParamHeight/2;
      //   node.totalLineHeight += ((!bHideEdt && !isLock))?edt.height:0.0;//(bHideEdt?SSDefines.nodeFieldRowHeight:SSDefines.nodeFieldRowHeight + edt.height);// + SSDefines.nodeParamHeight;
      //   // if (bWithConnection) node.totalLineHeight += SSDefines.nodeFieldRowHeight;
      //   node.totalLineHeight += SSDefines.nodeFieldRowHeight;
      // }
      // else{
      //   // node.totalLineHeight += (bHideEdt?0.0:SSDefines.nodeFieldRowHeight + edt.height);// + SSDefines.nodeParamHeight;
      //   node.totalLineHeight += (((bHideEdt || isLock))?0.0: edt.height + SSDefines.nodeFieldRowHeight);
      // }

      totalLineHeight += edt.height;
    }
    SSDefines.lastEnumValue = -1;
    return finalHeight;
  }
  Widget getInParamWidget(NodeStructData nodeType, StateScriptNode node, InParam inParam) {
    // bool withIn = iIndex <nodeType.getNormalInParamsCount();
    if (inParam == null) return Container(width: SSDefines.paramSize,);
    bool bWithConnection = ScriptInfo.current.getScriptData().hasInParamConnection(node , inParam);
    Color tpColor = CommonUtil.alphaColorD( Color(inParam.paramType.hashCode) , 1.0);
    tpColor =CommonUtil.changeColorLightness(tpColor, 0.4);

    if (node.isModuleNode && (!node.isRootModuleNode ||!node.moduleInterfaces.containsKey(inParam.guid))){
      return Tooltip(
        child: Icon(
          MaterialCommunityIcons.record_circle,
          color: Colors.grey,
          size: SSDefines.portSize,
        ),
        message: inParam.paramType,
      );// dragTarget;
    }

    var dn = DraggableEx(
      child: Container(
        // color: CommonUtil.alphaColor(Colors.green, 80) ,
        child: Icon(
          // AntDesign.rightsquare,
          MaterialCommunityIcons.record_circle,
          // color: bWithConnection?tpColor:CommonUtil.alphaColorD(tpColor, 0.5),
          color:tpColor,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
      ),
      childWhenDragging: Container(
        child: Icon(
          MaterialCommunityIcons.record_circle,
          color: Colors.green,//bWithConnection?Colors.red:Colors.grey,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
      ),
      feedback:Container(
//        color: Colors.red,
//        width: SSDefines.portSize ,
//        height: SSDefines.portSize ,

      ),

      data: InParamInfo(node, inParam),
      onDragStarted: (pos){
        EventCenter.eventBus.fire(ConnectLineStartEvent(pos));
      },
      onDragMove: (pos){
        EventCenter.eventBus.fire(ConnectLineMoveEvent(pos));
      },
      onDragEnd: (e){
        EventCenter.eventBus.fire(ConnectLineEndEvent());
      },

      onDraggableCanceled:(Velocity velocity, Offset offset){
        // if (KeyEventCenter.isShiftPressed()){
        //
        //   if (node.isModuleNode){
        //     BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
        //     return;
        //   }
        //
        //   var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
        //   var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = inParam.guid..x = off.dx..y = off.dy ..type = InterfaceType.InParam;
        //   // ScriptInfo.current.scriptData.inParams.add(mi);
        //   node.moduleInterfaces[mi.interfaceGuid] = mi;
        //   // ScriptInfo.current.scriptData.registerInParamInterface(mi);
        //   EventCenter.eventBus.fire(GlobalRefreshEvent());
        // }
      },
    );
    var dragTarget = DragTargetEx<OutParamInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
      onWillAccept:(OutParamInfo ii){
        // if (ii.port.paramType != inParam.paramType){
        if (!StateScriptNodeViewState.isTypeCanLink(node , inParam , ii.port)){
          BotToast.showText(text:"参数类型不匹配" , contentColor : Colors.redAccent);
          return false;
        }
        BotToast.cleanAll();
        return true;
      },
//      onAccept: onAccept,
      onAcceptWithDetails: (DragTargetDetails<OutParamInfo> details) {
        if (node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = ParamConnection();
        con.inNodeGuid = node.guid;
        con.inParamGuid = inParam.guid;
        con.outNodeGuid = details.data.node.guid;
        con.outParamGuid = details.data.port.guid;
        con.sopGuid = details.data.sop?.guid;

        // if (details.data.port.paramType != inParam.paramType){
        if (!StateScriptNodeViewState.isTypeCanLink(node , inParam , details.data.port)){
          BotToast.showText(text:"参数类型不匹配，忽略本次操作" , contentColor : Colors.redAccent);
          return;
        }

        if (!ScriptInfo.current.scriptData.addParamConnection(con , sop:details.data.sop)){
          BotToast.showText(text:"参数连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);
        }
        else{

          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        }
      },
    );
    return Tooltip(
      child: GestureDetector(
        onTapUp: (e){
          EventCenter.eventBus.fire(PortClickEvent()..node = node..portGuid = inParam.guid);
        },
        child: dragTarget,
      ),
      message: inParam.paramType,
    );// dragTarget;
  }

  Widget getOutParamWidget(NodeStructData nodeType, StateScriptNode node, OutParam outParam) {
    bool withOut = outParam != null;//iIndex <nodeType.outParams.length;
    if (!withOut) return Container(width: SSDefines.paramSize,);

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutParamConnection(node , outParam);
    Color tpColor =CommonUtil.alphaColorD( Color(outParam.paramType.hashCode) , 1.0);
    tpColor =CommonUtil.changeColorLightness(tpColor, 0.4);

    if (node.isModuleNode && (!node.isRootModuleNode || !node.moduleInterfaces.containsKey(outParam.guid))){
      return Tooltip(
        child: Icon(
          MaterialCommunityIcons.alpha_f_circle,
          color: Colors.grey,
          size: SSDefines.portSize,
        ),
        message: outParam.paramType,
      );// dragTarget;
    }

    var dn = DraggableEx(
      child:Icon(
        MaterialCommunityIcons.alpha_f_circle,
        color:tpColor,
        size: SSDefines.portSize,
      ),
      childWhenDragging: Container(
        child: Icon(
          MaterialCommunityIcons.alpha_f_circle,
          // AntDesign.rightsquare,
          // AntDesign.rightsquare,
          color: Colors.red,//bWithConnection?Colors.red:Colors.grey,
          size: SSDefines.portSize,
        ),
        // width: SSDefines.paramSize ,
        // height: SSDefines.paramSize ,
      ),
      feedback:Container(
//          color: Colors.red,
//          width: SSDefines.portSize ,
//          height: SSDefines.portSize ,
      ),
      onDragStarted: (pos){
        EventCenter.eventBus.fire(ConnectLineStartEvent(pos));
      },
      onDragMove: (pos){
        EventCenter.eventBus.fire(ConnectLineMoveEvent(pos));

      },
      onDragEnd: (e){

        EventCenter.eventBus.fire(ConnectLineEndEvent());
      },
      onDraggableCanceled:(Velocity velocity, Offset offset){
        // if (KeyEventCenter.isControlPressed()){
        //   if (node.isModuleNode){
        //     BotToast.showText(text:"模块内结点不允许创建替身" , contentColor : Colors.redAccent);
        //     return;
        //   }
        //   // var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
        //   // SubstituteOutParam sop = SubstituteOutParam()..outParamGuid = outParam.guid..x = off.dx..y = off.dy;
        //   // widget.node.sops.add(sop);
        //   // EventCenter.eventBus.fire(GlobalRefreshEvent());
        // }

        // if (KeyEventCenter.isShiftPressed()){
        //
        //   if (widget.node.isModuleNode){
        //     BotToast.showText(text:"模块内结点不允许开放引脚" , contentColor : Colors.redAccent);
        //     return;
        //   }
        //   var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
        //   var mi = ModuleInterface()..nodeGuid = node.guid .. interfaceGuid = outParam.guid..x = off.dx..y = off.dy ..type = InterfaceType.OutParam;
        //   // ScriptInfo.current.scriptData.outParams.add(mi);
        //   node.moduleInterfaces[mi.interfaceGuid] = mi;
        //   // ScriptInfo.current.scriptData.registerOutParamInterface(mi);
        //   EventCenter.eventBus.fire(GlobalRefreshEvent());
        // }
      },
//        data:nodeType.outPorts[iIndex],
      data: OutParamInfo(node, outParam , null),
    );

    var dragTarget = DragTargetEx<InParamInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
//      onAccept: onAccept,
//      onDragMove: (off){
//
//      },
      onWillAccept:(InParamInfo ii){
        // if (ii.port.paramType != nodeType.outParams[iIndex].paramType){
        if (!StateScriptNodeViewState.isTypeCanLink(ii.node , ii.port , outParam)){
          BotToast.showText(text:"参数类型不匹配" , contentColor : Colors.redAccent);
          return false;
        }
        BotToast.cleanAll();
        return true;
      },
      onAcceptWithDetails: (DragTargetDetails<InParamInfo> details) {
        if (node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = ParamConnection();
        con.outNodeGuid = node.guid;
        con.outParamGuid = outParam.guid;
        con.inNodeGuid = details.data.node.guid;
        con.inParamGuid = details.data.port.guid;
        // if (details.data.port.paramType != nodeType.outParams[iIndex].paramType){
        if (!StateScriptNodeViewState.isTypeCanLink(details.data.node , details.data.port, outParam)){
          BotToast.showText(text:"参数类型不匹配，忽略本次操作" , contentColor : Colors.redAccent);
          return;
        }

        if (!ScriptInfo.current.scriptData.addParamConnection(con)){
//          BotToast.showSimpleNotification(title: "连接已经存在，忽略本次操作");
          BotToast.showText(text:"参数连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);

        }
        else{
          EventCenter.eventBus.fire(RefreshAllConnectLineEvent______());
        }
      },
      // onWillAccept: (e){return true;},
//      onLeave: onOutPortLeave,
    );


    // return dragTarget;
    return Tooltip(
        child: GestureDetector(
          onTapUp: (e){
            EventCenter.eventBus.fire(PortClickEvent()..node = node..portGuid = outParam.guid);
          },
          child: dragTarget,
        ),
        message: outParam.paramType
    );// dragTarget;
  }

  void getPortsWidget(List<ModuleInterface> miInPorts , List<ModuleInterface> miOutPorts , List<Widget> lines){

    var _sb4 = const SizedBox(width: 2,);
    var fullPortLineCount = max(miInPorts.length,miOutPorts.length);

    for(int i = 0 ; i < fullPortLineCount; ++i){
      var withIn = i < miInPorts.length;
      var withOut = i < miOutPorts.length ;
      var inport = withIn ? miInPorts[i]:null;
      var outport = withOut ? miOutPorts[i]:null;

      var outNode = outport?.ownerNode;
      var inNode = inport?.ownerNode;

      var inNodeType = inNode?.getNodeStructType();
      var outNodeType = outNode?.getNodeStructType();

      withIn = withIn && inNodeType != null;
      withOut = withOut && outNodeType != null;

      var inRealPort = inNodeType?.getInPort(inport?.interfaceGuid);
      var outRealPort = outNode?.getOutPort(outport?.interfaceGuid);

      bool withSubPort = withOut && outNode.getSubPortsByPortGuid(outRealPort.guid).length>0;
      var inStr = DartCommon.isEmpty(inport?.name)?inRealPort?.getTypeShowString():inport?.name;
      var outStr = DartCommon.isEmpty(outport?.name)?outRealPort?.getTypeShowString():outport?.name;
      var rowLine = SizedBox(
        // 端口行不再包一层无色容器，直接由高度约束承载，端口图标与节点边缘对齐
        height: SSDefines.nodePortHeight,
        child: Row (
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              getInPortWidget(inNodeType ,inNode , inRealPort),
              _sb4,
              !withIn?SizedBox(width:0):Text(inStr,maxLines: 1, overflow: TextOverflow.clip,  style: textStyle),
              Expanded(child:Container()),
              !withOut?SizedBox(width:0):Text(outStr ,maxLines: 1, overflow: TextOverflow.clip, style: textStyle),
              _sb4,
              if (withSubPort) Icon(MaterialCommunityIcons.link_box_variant , size: 12,),
              getOutPortWidget(outNodeType ,outNode , outRealPort),
            ]
        ),
      );
      lines.add(rowLine);
      if (withIn){
        var key = "${inNode.guid}_${inRealPort.guid}";
        inNode.portYPos[key] = Offset(widget.subScript.x + SSDefines.portSize/2 , widget.subScript.y + totalLineHeight + SSDefines.nodePortHeight/2);
      }
      if (withOut){
        var key = "${outNode.guid}_${outRealPort.guid}";
        outNode.portYPos[key] = Offset(widget.subScript.x + moduleWidth - SSDefines.portSize/2 ,widget.subScript.y +  totalLineHeight + SSDefines.nodePortHeight/2);
      }
      totalLineHeight += SSDefines.nodePortHeight;
    }
  }

  Widget getInPortWidget(NodeStructData nodeType , StateScriptNode node , InPort inPort){

    bool withIn = inPort != null;//iIndex <nodeType.inPorts.length;
    if (!withIn) return Container(width: SSDefines.portSize,);
    // exit enter in out
    bool bWithConnection = ScriptInfo.current.getScriptData().hasInPortConnection(node , inPort);

    if (node.isModuleNode && !node.moduleInterfaces.containsKey(inPort.guid)){
      return Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      );// dragTarget;
    }

    var dn = DraggableEx(
      child: Icon(
        AntDesign.rightsquare,
        color: bWithConnection?Colors.green :Colors.grey,
        size: SSDefines.portSize,
      ),

      childWhenDragging: Container(
        child: const Icon(
          AntDesign.rightsquare,
          color: Colors.green,
          size: SSDefines.portSize,
        ),

        // width: SSDefines.portSize ,
        // height: SSDefines.portSize ,
      ),
      feedback:Container(
        // color: Colors.red,
        // width: SSDefines.portSize ,
        // height: SSDefines.portSize ,

      ),

      data: InPortInfo(node, inPort),
      onDragStarted: (pos){
        EventCenter.eventBus.fire(ConnectLineStartEvent(pos));
      },
      onDragMove: (pos){
        EventCenter.eventBus.fire(ConnectLineMoveEvent(pos));
      },
      onDragEnd: (e){
        EventCenter.eventBus.fire(ConnectLineEndEvent());
      },

      onDraggableCanceled:(Velocity velocity, Offset offset){
      },
    );
    var dragTarget = DragTargetEx<OutPortInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
//      onAccept: onAccept,
      onAcceptWithDetails: (DragTargetDetails<OutPortInfo> details) {
        if (node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = PortConnection();
        con.inNodeGuid = node.guid;
        con.inPortGuid = inPort.guid;
        con.outNodeGuid = details.data.node.guid;
        con.outPortGuid = details.data.port.guid;
        con.sopGuid = details.data.sop?.guid??"";
        if (!ScriptInfo.current.scriptData.addPortConnection(con , sop:details.data.sop)){
          BotToast.showText(text:"连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);
        }
        else{
          EventCenter.eventBus.fire(RefreshConnectCommandEvent());
        }
//    con.
      },


      onWillAccept: (e){return true;},
//      onWillAccept: onInPortWillAccept,
//      onLeave: onInPortLeave,
    );

    return Wrap(
      children: [
        GestureDetector(
          onTapUp: (e){
            EventCenter.eventBus.fire(PortClickEvent()..node = node..portGuid = inPort.guid);
          },
          child: dragTarget,
        ),

      ],
    );
  }

  Widget getOutPortWidget(NodeStructData nodeType ,StateScriptNode node , OutPort outPort){
    bool withOut = outPort != null;//iIndex <nodeType.outPorts.length;
    if (!withOut) return Container(width: SSDefines.portSize,);

    bool bWithConnection = ScriptInfo.current.getScriptData().hasOutPortConnection(node , outPort);

    if (node.isModuleNode && !node.moduleInterfaces.containsKey(outPort.guid)){
      return Icon(
        AntDesign.rightsquare,
        color: Colors.grey,
        size: SSDefines.portSize,
      );// dragTarget;
    }

    var dn = DraggableEx(

      child: Icon(
        AntDesign.rightsquare,
        color: bWithConnection?Colors.red:Colors.grey,
        size: SSDefines.portSize,
      ),
      childWhenDragging: Container(
        child: Icon(
          AntDesign.rightsquare,
          color: Colors.red,
          size: SSDefines.portSize,
        ),
      ),
      feedback:Container(
//          color: Colors.red,
//          width: SSDefines.portSize ,
//          height: SSDefines.portSize ,
      ),
      onDragStarted: (pos){
        EventCenter.eventBus.fire(ConnectLineStartEvent(pos));
      },
      onDragMove: (pos){
        EventCenter.eventBus.fire(ConnectLineMoveEvent(pos));

      },
      onDragEnd: (e){
        EventCenter.eventBus.fire(ConnectLineEndEvent());
      },

      onDraggableCanceled:(Velocity velocity, Offset offset){
        // if (KeyEventCenter.isControlPressed()){
        //   var off = widget.graph.fixPosition(widget.graph.calcLocalPosition(offset));
        //   SubstituteOutPort sop = SubstituteOutPort()..outPortGuid = outPort.guid..x = off.dx..y = off.dy;
        //   node.soports.add(sop);
        //   EventCenter.eventBus.fire(GlobalRefreshEvent());
        // }

      },
//        data:nodeType.outPorts[iIndex],
      data: OutPortInfo(node, outPort , null),
    );

    var dragTarget = DragTargetEx<InPortInfo>(
      builder: (BuildContext context, List candidateData, List rejectedData){
        return dn;
      },
//      onAccept: onAccept,
//      onDragMove: (off){
//
//      },
      onAcceptWithDetails: (DragTargetDetails<InPortInfo> details) {
        if (node.isModuleNode && details.data.node.isModuleNode){
          BotToast.showText(text:"模块结点不允许编辑链接" , contentColor : Colors.redAccent);
          return;
        }
        var con = PortConnection();
        con.outNodeGuid = node.guid;
        con.outPortGuid = outPort.guid;
        con.inNodeGuid = details.data.node.guid;
        con.inPortGuid = details.data.port.guid;

        if (!ScriptInfo.current.scriptData.addPortConnection(con)){
//          BotToast.showSimpleNotification(title: "连接已经存在，忽略本次操作");
          BotToast.showText(text:"连接已经存在，忽略本次操作" , contentColor : Colors.redAccent);
        }
        else{
          EventCenter.eventBus.fire(RefreshConnectCommandEvent());
        }
      },
      onWillAccept: (e){return true;},
//      onLeave: onOutPortLeave,
    );


    return GestureDetector(
      onTapUp: (e){
        EventCenter.eventBus.fire(PortClickEvent()..node = node..portGuid = outPort.guid);
      },
      child: dragTarget,
    );// dragTarget;
  }

  void move(){
    if (widget.subScript.subNodes != null) {
      for (var n in widget.subScript.subNodes) {
        n.x = widget.subScript.x + n.oriX;
        n.y = widget.subScript.y + n.oriY;
        for(var sop in n.soports){
          sop.x = sop.oriX + widget.subScript.x;
          sop.y = sop.oriY + widget.subScript.y;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
        }

        for(var sop in n.sops){
          sop.x = sop.oriX + widget.subScript.x;
          sop.y = sop.oriY + widget.subScript.y;
          EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop);
        }
        EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n);
      }
    }
  }
  Offset _downPointer = Offset.zero;
  Offset downStorePos = Offset.zero;

  void dragStorePos(DragStartDetails e){
    _downPointer = e.globalPosition;
    downStorePos = Offset(widget.subScript.x ,widget.subScript.y);
    // var nodes = ScriptInfo.current.scriptData.nodes;
    // for(var n in nodes){
    //   if (n.selected){
    //     n.downPointer = e.globalPosition;
    //     n.downStorePos = Offset(n.x , n.y);
    //   }
    //   for(var sop in n.soports){
    //     if (sop.selected){
    //       // sop.downPointer = e.globalPosition;
    //       sop.downStorePos = Offset(sop.x , sop.y);
    //     }
    //   }
    //   for(var sop in n.sops){
    //     if (sop.selected){
    //       // sop.downPointer = e.globalPosition;
    //       sop.downStorePos = Offset(sop.x , sop.y);
    //     }
    //   }
    // }
  }

  int dragUpdatePos(DragUpdateDetails e , SSCanvasViewState graph){
    var off = e.globalPosition - _downPointer??Offset.zero;
    off = graph.global2LocalDelta(off);
    int res = 0;

    widget.subScript.x = downStorePos.dx + off.dx;
    widget.subScript.y = downStorePos.dy + off.dy;

    setState(() {

    });

    // var nodes = ScriptInfo.current.scriptData.nodes;
    // for(var n in nodes){
    //   // bool bingo = false;
    //   if (n.selected){
    //     n.x = n.downStorePos.dx + off.dx;
    //     n.y = n.downStorePos.dy + off.dy;
    //     res+=1;
    //     // EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n..posChanged = true);
    //     // EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);
    //
    //     // bingo = true;
    //   }
    //
    //   for(var sop in n.soports){
    //     if (sop.selected){
    //       sop.x = sop.downStorePos.dx + off.dx;
    //       sop.y = sop.downStorePos.dy + off.dy;
    //       res+=1;
    //       // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
    //       // bingo = true;
    //     }
    //   }
    //   for(var sop in n.sops){
    //     if (sop.selected){
    //       sop.x = sop.downStorePos.dx + off.dx;
    //       sop.y = sop.downStorePos.dy + off.dy;
    //       res+=1;
    //       // EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
    //       // bingo = true;
    //     }
    //   }

    // }

    return res;
  }

  void dragEndPos(DragEndDetails e , SSCanvasViewState graph){
    // var off = e.globalPosition - _downPointer??Offset.zero;
    // off = graph.global2LocalDelta(off);
    var pos = Offset(widget.subScript.x,widget.subScript.y);
    pos = graph.fixPosition(pos);
    widget.subScript.x = pos.dx;
    widget.subScript.y = pos.dy;

    setState(() {

    });
    //EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = n);
    // var nodes = ScriptInfo.current.scriptData.nodes;
    // for(var n in nodes){
    //   bool bingo = false;
    //   if (n.selected){
    //     var pos = Offset(n.x,n.y);
    //     pos = graph.fixPosition(pos);
    //     n.x = pos.dx;
    //     n.y = pos.dy;
    //     bingo = true;
    //     EventCenter.eventBus.fire(NodeRefreshWithTargetEvent()..node = n..posChanged = true);
    //     EventCenter.eventBus.fire(NodeDescRefreshEvent()..node = n);
    //   }
    //
    //   for(var sop in n.soports){
    //     if (sop.selected){
    //       var pos = Offset(sop.x,sop.y);
    //       pos = graph.fixPosition(pos);
    //       sop.x = pos.dx;
    //       sop.y = pos.dy;
    //       bingo = true;
    //       EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
    //     }
    //   }
    //   for(var sop in n.sops){
    //     if (sop.selected){
    //       var pos = Offset(sop.x,sop.y);
    //       pos = graph.fixPosition(pos);
    //       sop.x = pos.dx;
    //       sop.y = pos.dy;
    //       bingo = true;
    //       EventCenter.eventBus.fire(SubstituteObjectRefreshEvent()..object = sop..posChanged = true);
    //     }
    //   }
    //
    //   if (bingo) EventCenter.eventBus.fire(RefreshConnectCommandEvent()..targetNode = n);
    // }
  }

  ScriptInfo empty = ScriptInfo()..group = "空"..name ="empty"..alias="空";
  Widget getScriptChooser( String current , {bool onlyModule = false}){


    var scripts = StateScriptProject.instance.scripts.where((element) => element.isModule??false).toList();//.where((element) => false == element.isModule).toList();?
    ATreeNode<ScriptInfo> _compRoot = DartCommon.buildTree<ScriptInfo>(scripts, (item){
      return <String>[];
    });

    // scripts.add(empty);
    var con = SearchableThemeTreeView(
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ScriptInfo>).data;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node , expanded , highlightPattern){
        // print(highlightPattern);
        var agent = node as ATreeNode<ScriptInfo>;
        if (agent.isLeaf) {

          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var txt = Text((agent.data).getShowStringAndName()??"" ,style: TextStyle( color: ThemeCenter.mainTextStepColor(8)));
          // var iconSize = 28.0;
          var cate = SSCategory.categories.where((element) => element.id == agent.data.category).toList();
          var con = Container(
            color: current == agent.data.guid? CommonUtil.alphaColorD(Colors.blue,0.2):ThemeCenter.systemTheme.scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 32,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
                SizedBox(width: 4,),
                Expanded(child : txt),
              ],
            ),
          );
          // return txt;
          return Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
          var con = Container(
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 36,
            //CommonUtil.alphaColor(nd.isExpand ? Colors.green : Colors.grey , 50),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                !expanded ? Icon(FontAwesome.folder_o , size: 18,color: Colors.grey,):Icon(FontAwesome.folder_open_o , size: 18,color: Colors.blueAccent,),
                SizedBox(width: 8,),
                Expanded(child : txt),
              ],
            ),
          );
          // return txt;
          return Container(
            padding: EdgeInsets.all(1),
            child: con,
          );
        }
      },
      onGetChildren: (node){
        return (node as ATreeNode<ScriptInfo>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<ScriptInfo>;
        if (ns != null) {

          if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.alias}";
          // if (ns.isLeaf) return n.//return "${n.name}`${n.defaultValue}";
          // return "${ns.id}";
        }
        return "";
      },

      onSortLeaf: (a,b){
        return (a as ATreeNode<ScriptInfo>).data.name.compareTo((b as ATreeNode<ScriptInfo>).data.name);
      },

      onItemTap: (item){
        // var a = item as ATreeNode<ScriptInfo>;
        // if (a != null && a.data != null) {
        //   onSubmitted?.call(a.data);
        //   Navigator.pop(context, a.data);
        // }

        widget.subScript.scriptId = (item.data as ScriptInfo).guid;
        ScriptInfo.current.scriptData.loadSubScripts(widget.subScript.guid);
        ScriptInfo.current.scriptData.initConnectionCount();
        EventCenter.eventBus.fire(GlobalRefreshEvent());
        setState(() {

        });
        Navigator.pop(CommonUtil.getGlobalContex() , item);
      },

      actions: [
        ElevatedButton(
          // padding: EdgeInsets.all(0),
          style: ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(CommonUtil.scaleColor(Colors.red,1.0))),
          // color: CommonUtil.scaleColor(Colors.red,1.0),
          child: Text("清空"),
          onPressed: (){
            ScriptInfo.current.scriptData.loadSubScripts(widget.subScript.guid);
            ScriptInfo.current.scriptData.initConnectionCount();
            EventCenter.eventBus.fire(GlobalRefreshEvent());
            setState(() {
              widget.subScript.scriptId = "";
            });

            Navigator.pop(CommonUtil.getGlobalContex() , empty);
          },
        ),
        SizedBox(width: 8,),
        ElevatedButton(
          // padding: EdgeInsets.all(0),
          // color: Colors.indigo,
          child: Text("取消"),
          onPressed: (){
            Navigator.pop(CommonUtil.getGlobalContex() , null);
          },
        ),
        // SSDefines.IBC(child :IconButton(
        //   padding: EdgeInsets.all(0),
        //   icon : Icon(MaterialCommunityIcons.close_box_outline , color: Colors.redAccent,),
        //   iconSize: SSDefines.iconButtonSize,
        //   onPressed: (){
        //     Navigator.pop(context);
        //   },
        //   tooltip: "关闭",
        // ))

      ],
    );

    return ThemeCenter.area(
      width: 600,
      child: con,
    );

  }

  Widget getValueLabelWidget(String initValue, {TextStyle style}){
    var str = initValue;
    var scriptInfo = StateScriptProject.instance.scripts.firstWhere((element) => element.guid == str, orElse:()=>null);
    if (scriptInfo == null){
      return Text("未指定", style: style,);
    }
    return Text("[${scriptInfo?.alias??""},${initValue.substring(0,8)}]", style: style);
  }
}