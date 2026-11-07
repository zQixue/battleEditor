//@dart=2.11
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/ConnectAssist.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/ModuleInterface.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/ParamConnection.dart';
import 'package:battlepus/StateScript/Struct/PortConnection.dart';
import 'package:battlepus/StateScript/Struct/RefSubScript.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/Struct/ScriptInfo.dart';
import 'package:battlepus/StateScript/Struct/StateScript.dart';
import 'package:battlepus/StateScript/Struct/StateScriptNode.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/Transition/Transport.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/Tagger/ATag.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/protos/transition.pb.dart';
import 'package:theme_provider/theme_provider.dart';

class NodeSelector extends StatefulWidget {
  final double containerWidth;
  final double containerHeight;
  NodeSelector({Key key , this.containerWidth , this.containerHeight}) : super(key: key);

  @override
  _NodeSelectorState createState() => _NodeSelectorState();
}

class _NodeSelectorState extends State<NodeSelector> {
  bool bShowList = false;
  double width = 400;
  double height = 500;

  String inParamFilter;
  String outParamFilter;
  String paramName;

  String srcNodeGuid ;
  String srcParamGuid ;

  String srcNodeId;


  double posX = 0;
  double posY = 0;

  double showListX = 0;
  double showListY = 0;

  ATreeNode<NodeStructData> _nodeRoot;
  bool _nodeRootNR = false;

  String _filterStr;

  double _initOffset;
  ATreeNode<NodeStructData> getNodeTreeRoot(){
    if (_nodeRoot == null || _nodeRootNR){
      StateScriptProject.instance.tagCamp.buildIds();
      var scriptTagFlag = ATag.tagCommonFlag;

      // print("======== scriptTagFlag : ${scriptTagFlag.toRadixString(2)}");
      if (ScriptInfo.current != null){
        scriptTagFlag = ScriptInfo.current?.getIDFlag();
        //
      }
      // print("======== scriptTagFlag : ${scriptTagFlag.toRadixString(2)}");
      var scripts = StateScriptProject.instance.nodeStructs.where((element){
        bool res = true ;
        if (ScriptInfo.current.logicOrView??true){
          res &= element.isLogicNode;
        }
        else{
          res &= element.isViewNode;
        }

        if (!res) return false;
        if (inParamFilter != null){
          if (!element.hasInParamType(inParamFilter)){
            return false;
          }
        }

        if (outParamFilter != null){
          if (!element.hasOutParamType(outParamFilter)){
            return false;
          }
        }

        var nodeTagFlag =  element.getIDFlag();
        // print("======== nodeTagFlag : ${nodeTagFlag.toRadixString(2)}");
        // print("======== nodeTagFlag & scriptTagFlag : ${element.name}, ${(nodeTagFlag & scriptTagFlag).toRadixString(2)}");
        if (nodeTagFlag & scriptTagFlag == 0) return false;
        // print("======== ${element.getTypeShowString()} ${(nodeTagFlag & scriptTagFlag).toRadixString(2)}");
        return true;

      }).toList();//.where((element) => false == element.isModule).toList();

      _nodeRoot = DartCommon.buildTree(scripts, (item){
        var sp = (item as NodeStructData).group.split("/");
        bool res = false ;



        if (srcNodeId != null){
          // print("-------------------------- srcNodeId : $srcNodeId");
          var m1 = ConnectAssist.instance.records[srcNodeId];
          // print("-------------------------- m1 : $m1");
          if (m1 != null){
            if (m1.containsKey((item as NodeStructData).guid)){
              res = true;
            }
          }
        }
        if (res){
          return ["-- 联想"];
        }
        return sp;
      });
    }
    _nodeRootNR = false;
    return _nodeRoot;
  }
  void forceBuildTree(){
    _nodeRootNR = true;
  }
  StreamSubscription<NodeTypeListRefreshEvent> _lis;
  @override
  void initState() {
    _lis = EventCenter.eventBus.on<NodeTypeListRefreshEvent>().listen((event) {
      if(bShowList != event.bShow || posX != event.x ||posY != event.y) {
        setState(() {
          _nodeRootNR = true;
          bShowList = event.bShow;
          posX = event.x ?? 0;
          posY = event.y ?? 0;
          showListX = event.showListX ?? 200;
          showListY = event.showListY ?? 200;

          inParamFilter = event.inParamFilter;
          outParamFilter = event.outParamFilter;
          paramName = event.paramName;
          srcNodeId = event.srcNodeId;

          srcNodeGuid = event.srcNodeGuid;
          srcParamGuid = event.srcParamGuid;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _lis?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (!bShowList) {
      return Container();
    }

    var con = SearchableThemeTreeView(
      initPosition: _initOffset,
      onScrollPosition: (v){
        _initOffset = v;
      },

      filterString: _filterStr,
      onFilterStringChanged:(v){
        _filterStr = v;
      },
      onExpandedFlagChanged: (map){
        SSUserData.instance.nodeSelectorExpandedFlags = map;
        SSUserData.instance.save();
      },
      expandedFlags: SSUserData.instance.nodeSelectorExpandedFlags,

      defaultExpanded: true,
      indent: 16,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getNodeTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<NodeStructData>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<NodeStructData>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<NodeStructData>;
        if (nd.isLeaf){
          var si = nd.data;
          var txt = Text((si as NodeStructData).getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
          var con = Container(
            // color: CommonUtil.alphaColorD(Colors.blue,0.4),
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 32,
            child: Row(
              children: [

                SizedBox(width: 4,),
                Container(width: 12,height: 12, color: CommonUtil.scaleColor(Color((si as NodeStructData).bgColor??0), 0.5),),
                SizedBox(width: 4,),
                Expanded(child : txt),

                Tooltip(
                  child: Icon(MaterialCommunityIcons.information ,color: Colors.green),
                  message: "${si.description}",
                )
                // Container(
                //   width: 22,
                //   child:IconButton(padding:EdgeInsets.all(0),icon: Icon(MaterialCommunityIcons.information,), iconSize: 20,color: Colors.green, tooltip:"结点描述",
                //     onPressed: (){
                //       showDialog(
                //         context: context,
                //         barrierDismissible: true,
                //         builder: (BuildContext context) {
                //           var ch = NodeInfoView(nodeType: n,);
                //           return Dialog(child: ch);
                //         },
                //       );
                //     },
                //   ),
                // ),

                // Draggable(
                //   child: Icon(MaterialCommunityIcons.drag_variant , color: Colors.blueGrey,),
                //   feedback: Icon(MaterialCommunityIcons.drag_variant , color: Colors.lightBlueAccent,),
                //   childWhenDragging: Icon(MaterialCommunityIcons.drag_variant , color: Colors.lightBlueAccent,),
                //   data:si,
                // ),
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
          // var txt = Text(name??"",style: TextStyle( color:  nd.isExpand?Colors.black:Colors.grey));
          var txt = Text(nd.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
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
          // return txt;
        }
      },

      onFilter: (node){
        var ns  = node as ATreeNode<NodeStructData>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.group}`${n.alias}";
        }
        return "";
      },
      onSortDir: (aDir , bDir){
        var a = (aDir as ATreeNode<NodeStructData>).name;
        var b = (bDir as ATreeNode<NodeStructData>).name;

        if (a == "-- 联想"){
          return -1;
        }
        if (b == "-- 联想"){
          return 1;
        }
        return a.compareTo(b);
      },
      onSortLeaf: (srcNodeId != null && ConnectAssist.instance.records[srcNodeId] != null)?(aNode,bNode){
        var a = (aNode as ATreeNode<NodeStructData>).data;
        var b = (bNode as ATreeNode<NodeStructData>).data;
        var m1 = ConnectAssist.instance.records[srcNodeId];

        var av = (m1 != null) ? m1[a.guid]??0:0;
        var bv = (m1 != null) ? m1[b.guid]??0:0;

        if (av == bv){
          return a.getShowStringAndName().compareTo(b.getShowStringAndName());
        }
        return (av-bv);
      }:null,

      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<NodeStructData>).data;
          if (si != null) {
            var n = StateScriptNode();

            // var off = ZoomState.calcLocalPosition(details.offset);// + Offset(BTDefines.nodeTypeWidth/2 , BTDefines.nodeTypeHeight/2));
            //
            //
            // off = ZoomState.fixPosition(off);

            n.x = posX;
            n.y = posY;
            print("add node ${n.x} ${n.y}");
            n.nodeTypeGuid = (item as ATreeNode<NodeStructData>).data.guid;
            HistoryManager.scriptHistory.appendHistory();
            ScriptInfo.current.scriptData.addNode(n);
            SyncNodeData info = n.getSyncData();
            Transport.instance.sendUdpData(OPackType.O2U_MAP_SyncObject, info);

            if (inParamFilter != null){
              var ps = si.getInParamsOfType(inParamFilter);
              if (ps.length ==1){
                var con = ParamConnection();
                con.outNodeGuid = srcNodeGuid;
                con.outParamGuid = srcParamGuid;
                con.inNodeGuid = n.guid;
                con.inParamGuid = ps[0].guid;
                inParamFilter = null;
                ScriptInfo.current.scriptData.addParamConnection(con);
              }
            }

            if (outParamFilter != null){
              var ps = si.getOutParamsOfType(outParamFilter);
              if (ps.length ==1){
                var con = ParamConnection();
                con.inNodeGuid = srcNodeGuid;
                con.inParamGuid = srcParamGuid;
                con.outNodeGuid = n.guid;
                con.outParamGuid = ps[0].guid;
                ScriptInfo.current.scriptData.addParamConnection(con);
              }
            }

            EventCenter.eventBus.fire(GlobalRefreshEvent());
            setState(() {
              bShowList = false;
            });
            // setState(() {
            //
            //   // ScriptInfo.current.scriptData.addNode(n);
            // });
          }
          // forceBuildTree();
        });

      },

      actions: [
        if (withSelectedNodes())ElevatedButton(
          child: Text("创建模板"),
          onPressed: (){

            createModule();
            // var n = RefSubScript();
            // n.x = posX;
            // n.y = posY;
            // print("${n.x} ${n.y}");
            // // n.scriptId = (item as ATreeNode<NodeStructData>).data.guid;
            // HistoryManager.scriptHistory.appendHistory();
            // ScriptInfo.current.scriptData.addSubScript(n);
            // EventCenter.eventBus.fire(GlobalRefreshEvent());
            //
            // setState(() {
            //   bShowList = false;
            // });
          },
        ),
        Expanded(child:Container()),
        ElevatedButton(
          child: Text("添加模板"),
          onPressed: (){
            var n = RefSubScript();

            n.x = posX;
            n.y = posY;
            print("${n.x} ${n.y}");

            HistoryManager.scriptHistory.appendHistory();
            ScriptInfo.current.scriptData.addSubScript(n);
            EventCenter.eventBus.fire(GlobalRefreshEvent());

            setState(() {
              bShowList = false;
            });
          },
        ),
        // ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_decision_outline , width: 20 ,height: 20,
        //   tooltip: "添加模板",
        //   onPressed: (){
        //
        //
        //   }
        // ),
      ],
    );

    var w = widget.containerWidth/4;
    var h = widget.containerHeight *4/5;
    var block = ThemeCenter.block (
      width: w,
      height: h,
      headTitle: "选择创建结点",
      // width: 480,
      child: con,
      actions: [
        // ThemeCenter.iconBtn(MaterialCommunityIcons.ballot_recount,
        //     color: Colors.greenAccent,
        //     tooltip: "显示全部结点",
        //     onPressed: (){
        //       setState(() {
        //         bShowList = true;
        //         _nodeRootNR = true;
        //         inParamFilter = null;
        //         outParamFilter = null;
        //         srcNodeId = null;
        //
        //       });
        //
        //     }
        // ),
        ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline,
            color: Colors.redAccent,
            tooltip: "关闭",
            onPressed: (){
              setState(() {
                bShowList = false;
              });

            }
        ),
      ]
    );

    var l = showListX;
    var t = showListY;

    if (l + w > widget.containerWidth) l = widget.containerWidth -w;
    if (t + h> widget.containerHeight) t = widget.containerHeight -h;



    return Positioned(
      left: l,//(widget.containerWidth - width)/2,
      top: t,//(widget.containerHeight - height)/2,
      child: ThemeConsumer(child: block),
    );

    // return block;
  }

  bool withSelectedNodes() {
    StateScript srcScriptData = ScriptInfo.current.scriptData;
    for (var n in srcScriptData.nodes){
      if (n.selected) return true;
    }

    return false;
  }
  void createModule() {
    HistoryManager.scriptHistory.appendHistory();
    StateScript srcScriptData = ScriptInfo.current.scriptData;

    var newModuleScript = StateScriptProject.instance.addScript();
    newModuleScript.isModule = true;
    newModuleScript.loadScript();
    StateScript tgtScriptData = newModuleScript.scriptData;

    Map<String , String> guidMap = Map<String , String>();
    Map<String , StateScriptNode> nodeMap = Map<String , StateScriptNode>();
    for(var i = srcScriptData.nodes.length - 1 ; i >=0 ; --i){// sbn in srcScriptData.nodes){
      var sbn = srcScriptData.nodes[i];
      if (!sbn.selected) continue;

      var json = jsonEncode(sbn);
      Map userMap = jsonDecode(json);
      var newn = StateScriptNode.fromJson(userMap);
      var old = newn.guid;
      newn.rebuildGuid();
      newn.moduleInterfaces.clear();
      guidMap[old] = newn.guid;
      for(var sp in newn.soports){
        var old = sp.guid;
        sp.rebuildGuid();
        guidMap[old] = sp.guid;
      }

      for(var sp in newn.sops){
        var old = sp.guid;
        sp.rebuildGuid();
        guidMap[old] = sp.guid;
      }

      tgtScriptData.addNode(newn);
      // srcScriptData.deleteNode(sbn);
      srcScriptData.nodes.removeAt(i);
      nodeMap[newn.guid] = newn;

      var allFields = newn.getNodeStructType().getAllFields();

      Map<String,FieldInfo> newScriptFields = Map<String,FieldInfo>();
      allFields.forEach((element) {
        var fi = newn.fieldValues[element.guid];
        if (element.typeGuid == "___scriptvar___"){
          //模块脚本变量
          var svarGuid = fi.value.toString();
          var newVar = newScriptFields[svarGuid];
          if (newVar == null){
            var svar = srcScriptData.scriptFieldVars.firstWhere((element) => element.guid == svarGuid, orElse: ()=>null);
            if (svar != null){
              newVar = svar.clone();
              newScriptFields[svarGuid] = newVar;
            }
          }

          if (newVar != null){
            fi.value = newVar.guid;
          }
        }
      });
      newScriptFields.forEach((key, value) {
        tgtScriptData.scriptFieldVars.add(value);
      });
    }


    srcScriptData.refreshNodeMap();
    var off = tgtScriptData.adjustGraphPosition();

    var aModule = RefSubScript();
    aModule.x = off.dx;
    aModule.y = off.dy;

    print("${aModule.x} ${aModule.y}");

    for(var i = srcScriptData.portConnections.length - 1 ; i >=0 ; --i){
      var cn = srcScriptData.portConnections[i];
      if (guidMap[cn.inNodeGuid] != null && guidMap[cn.outNodeGuid] != null){
        var json = jsonEncode(cn);
        Map userMap = jsonDecode(json);
        var newCn = PortConnection.fromJson(userMap);
        newCn.rebuildGuid();
        newCn.inNodeGuid = guidMap[cn.inNodeGuid];
        newCn.outNodeGuid = guidMap[cn.outNodeGuid];
        if (newCn.sopGuid != null) newCn.sopGuid = guidMap[newCn.sopGuid];
        tgtScriptData.addPortConnection(newCn,recordHistory: false);
        srcScriptData.removePortConnection(cn);//portConnections.removeAt(i);
      }
      else{
        if (guidMap[cn.inNodeGuid] != null){
          var node = nodeMap[guidMap[cn.inNodeGuid]];
          var mi = ModuleInterface()..nodeGuid = node.guid ..interfaceGuid = cn.inPortGuid .. x = node.x - 128 .. y = node.y ..type = InterfaceType.InPort;
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          cn.inNodeGuid = "${aModule.guid}-${guidMap[cn.inNodeGuid]}";
        }

        if (guidMap[cn.outNodeGuid] != null){
          var node = nodeMap[guidMap[cn.outNodeGuid]];
          var mi = ModuleInterface()..nodeGuid = node.guid ..interfaceGuid = cn.outPortGuid .. x = node.x + 128 + 256 .. y = node.y..type = InterfaceType.OutPort;
          node.moduleInterfaces[mi.interfaceGuid] = mi;
          cn.outNodeGuid = "${aModule.guid}-${guidMap[cn.outNodeGuid]}";
        }
      }
    }

    for(var i = srcScriptData.paramConnections.length - 1 ; i >=0 ; --i){
      var cn = srcScriptData.paramConnections[i];
      if (guidMap[cn.inNodeGuid] != null && guidMap[cn.outNodeGuid] != null){
        var json = jsonEncode(cn);
        Map userMap = jsonDecode(json);
        var newCn = ParamConnection.fromJson(userMap);
        newCn.rebuildGuid();
        newCn.inNodeGuid = guidMap[cn.inNodeGuid];
        newCn.outNodeGuid = guidMap[cn.outNodeGuid];
        if (newCn.sopGuid != null) newCn.sopGuid = guidMap[newCn.sopGuid];

        tgtScriptData.addParamConnection(newCn,recordHistory: false);
        srcScriptData.removeParamConnection(cn);//portConnections.removeAt(i);
      }
      else{
        if (guidMap[cn.inNodeGuid] != null){
          var node = nodeMap[guidMap[cn.inNodeGuid]];
          var mi = ModuleInterface()..nodeGuid = node.guid ..interfaceGuid = cn.inParamGuid .. x = node.x - 128 .. y = node.y..type = InterfaceType.InParam;
          node.moduleInterfaces[mi.guid] = mi;
          cn.inNodeGuid = "${aModule.guid}-${guidMap[cn.inNodeGuid]}";
        }

        if (guidMap[cn.outNodeGuid] != null){
          var node = nodeMap[guidMap[cn.outNodeGuid]];
          var mi = ModuleInterface()..nodeGuid = node.guid ..interfaceGuid = cn.outParamGuid .. x = node.x + 128 + 256 .. y = node.y..type = InterfaceType.OutParam;
          node.moduleInterfaces[mi.guid] = mi;
          cn.outNodeGuid = "${aModule.guid}-${guidMap[cn.outNodeGuid]}";
        }
      }
    }

    // srcScriptData.addSubScript(aModule);
    newModuleScript.saveScript();
    aModule.scriptId = newModuleScript.guid;

    srcScriptData.addSubScript(aModule);
    srcScriptData.loadSubScripts(ScriptInfo.current.guid);
    srcScriptData.initConnectionCount();
    EventCenter.eventBus.fire(GlobalRefreshEvent());
    setState(() {
      bShowList = false;
    });
  }
}