//@dart=2.11

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeEnum.dart';
import 'package:battlepus/StateScript/Struct/NodeCamp.dart';
//import 'package:battlepus/StateScript/Struct/NodeCamp.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSAgent.dart';
import 'package:battlepus/StateScript/Struct/SSComponent.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
//import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/text_editor.dart';

class ProjectImportPage extends StatefulWidget {
  ProjectImportPage({Key key}) : super(
      key: key);

  @override
  _ProjectImportPageState createState() =>
      _ProjectImportPageState(
      );
}

class _ProjectImportPageState extends State<ProjectImportPage> {
  NodeCamp _nodeCamp;

  @override
  Widget build(BuildContext context) {
    var path = ModalRoute.of(context).settings.arguments as String;
    _nodeCamp = NodeCamp.loadFrom(path);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("导入预制包"),
          actions: [

            IconButton(
              icon: Icon(MaterialCommunityIcons.import),iconSize: 44, color: Colors.white, tooltip:"导入",
              onPressed: () {
                loadPackInfo();
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child :Row(
            children: [
              Expanded(flex : 2 ,child: getNodeList()),
              SizedBox(width: 8,),
              Expanded(flex : 2 , child : getEnumWidget()),
              SizedBox(width: 8,),
              Expanded(flex : 2 , child : getAgentPanel()),
              SizedBox(width: 8,),
              Expanded(flex: 2 , child :getComponentPanel()),
            ],
          ),
        )
    );
  }

  Map<String, List<NodeStructData>> groupNaps;
  List<String> groups;
  Widget getNodeList(){
    groupNaps = _nodeCamp.getStructGroups();
    groups = groupNaps.keys.toList();
    groups.sort();
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    var filter = Row(
      children: [
        Icon(Icons.search , size: 24, color: Colors.black,),
        Expanded(
          child: TextField(
            autofocus: false,
            onChanged: (v) {
              setState(() {
              }
              );
            },
          ),
        ),
      ],
    );

    return Container(

//      decoration: dc,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: filter,
          ),
          SizedBox(height: 8,),
          Expanded (child :Container(
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: Container(
//              color :Colors.black12,
              child : getStructList(),
            ),
          )),

//          Container(
//            decoration: dc,
////            padding: EdgeInsets.all(0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.end,
//              children: [
//                IconButton(
//                  icon: Icon(MaterialCommunityIcons.delete_forever),iconSize: 48, color: Colors.redAccent, tooltip:"从库移除",
//
//                  onPressed: _selectedNodes.length <=0?null: (){
//                    CommonUtil.confirm(context, "确定要移除节点吗?",onOk: (){
//                      setState(() {
//                        for(var n in _selectedNodes){
//                          NodeCamp.instance.removeNodeType(n);
//                        }
//                        StateScriptProject.instance.save();
//                        BotToast.showText(text: "移除成功");
//                        EventCenter.eventBus.fire(NodeTypeChangeEvent(null));
//                      });
//                    });
//                  },
//                ),
//                IconButton(
//                  icon: Icon(Ionicons.md_download),iconSize: 44, color: Colors.black, tooltip:"导入",
//
//                  onPressed: _selectedNodes.length <=0?null: (){
//                    CommonUtil.confirm(context, "确定要导入吗? 本地修改和代码将会被覆盖!",onOk: (){
//                      setState(() {
//                        for(var n in _selectedNodes){
//                          StateScriptProject.instance.importNode(n);
//                        }
//                        StateScriptProject.instance.save();
//                        BotToast.showText(text: "导入成功");
//                        EventCenter.eventBus.fire(NodeTypeChangeEvent(null));
//                      });
//                    });
//                  },
//                ),
//
//              ],
//            ),
//          ),
        ],
      ),
    );
  }

  Widget getStructList() {
//    var groups = StateScriptProject.instance.getStructGroups();

    var lst = ListView.builder(
      itemCount: groups.length,
      itemBuilder: onBuildGroup ,
    );

    return Scrollbar(
      child: lst,
    );

  }
  Map<String,bool> _closed = Map<String,bool>();
  Map<String,bool> _allSelected = Map<String,bool>();
  Widget onBuildGroup(BuildContext context, int index) {
//    var groupNaps = StateScriptProject.instance.getStructGroups();
//    var groups = groupNaps.keys.toList();
//    groups.sort();
    var name = groups[index];
    var showName = name;
    if (name == null || name.isEmpty){
      showName = "基本";
    }
    var items = List<Widget>();

//    var dc = BoxDecoration(
//      border:BoxBorder(
//
//      ),
////      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
//    );
    var groupBar = Container(
        padding: EdgeInsets.all(8),
//      decoration: dc,
        color  : Colors.black12,//_opend.containsKey(name)?CommonUtil.alphaColor(Colors.indigo , 32) :Colors.black12,
        height : 48,
        child: Row(

          children: [
            Icon(Icons.group_work , color: _closed.containsKey(name)?Colors.grey:Colors.indigo,),
            SizedBox(width: 16,),
            Text(showName),
//            Expanded(child:Container()),
//            Checkbox(
//              value: _allSelected[name]??false,
//              onChanged: (v){
//                setState(() {
//                  if (v){
//                    _allSelected[name] = true;
//                    _selectedNodes.clear();
//                    for(var n in groupNaps[name]){
//                      _selectedNodes.add(n);
//                    }
//                  }
//                  else{
//                    _allSelected[name] = false;
//                    _selectedNodes.clear();
//                  }
//                });
//              },
//            )
          ],
        )
    );
    var inkwell = InkWell(
      onTap: (){
        setState(() {
          if (_closed.containsKey(name)) _closed.remove(name);
          else _closed[name] = true;
        });
      },
      child: groupBar,
    );
    items.add(inkwell);

    if (!_closed.containsKey(name)){
      //打开
      for(var n in groupNaps[name]){
        var nodeItem = getNodeItem(n);
        items.add(nodeItem);
      }
    }

    return Column(
      children: items,
    );
  }
//  NodeStructData _selected ;
  List<NodeStructData> _selectedNodes = List<NodeStructData>();
  Widget getNodeItem(NodeStructData n) {
    var name = n.name;
    bool inLocal = _nodeCamp.nodeStructs.where((element) => element.guid == n.guid).length>0;
    var item = Container(
      padding: EdgeInsets.all(8),
      color  : Colors.white,
      height: 48,
      child: Row(
        children: [
          SizedBox(width: 32,),
          Icon(Icons.adjust , color: Colors.black,),
          SizedBox(width: 16,),
          Expanded(child:Text(n.getShowStringAndName() , maxLines: 1,)),
//            RaisedButton(
//              child: Text("从库移除"),
//              onPressed: (){
//                CommonUtil.confirm(context, "确定要从节点库移除 ${n.name} 吗?",onOk: (){
//                  setState(() {
//                    NodeCamp.instance.removeNodeType(n);
//                    NodeCamp.instance.save();
//                    EventCenter.eventBus.fire(NodeTypeChangeEvent(null));
//                  });
//                });
//              },
//            ),
//          SizedBox(width : 4),
//          Checkbox(
//            value: _selectedNodes.contains(n),
//            onChanged: (v){
//              setState(() {
//                if (v) addNode(n);
//                else _selectedNodes.remove(n);
//              });
//
//            },
//          ),
//            RaisedButton(
//              child: Text("导入"),
//              color: CommonUtil.scaleColor(inLocal?Colors.redAccent:Colors.black, 0.5),
//              onPressed: (){
//                CommonUtil.confirm(context, "确定要导入 ${n.name} 吗? 本地修改和代码将会被覆盖!",onOk: (){
//                  setState(() {
//                    StateScriptProject.instance.importNode(n);
//                    StateScriptProject.instance.save();
//                    EventCenter.eventBus.fire(NodeTypeChangeEvent(null));
//                  });
//                });
//              },
//            )
        ],
      ),
    );
    var inkwell = InkWell(
      onTap: (){
        setState(() {
//          _selected = n;
        });

      },
      child: item,
    );
    return inkwell;
  }

  void addNode(NodeStructData node){
    _selectedNodes.add(node);

//    var codePath = StateScriptProject.instance.nodeCodeExportPath;
//    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
//    var codeNodePath = GlobalBoard.getCorrectDirectory(codePath, basePath: basePath);
//
//    var nodeCodePath = PathUtil.join(codeNodePath , "${node.name}.cs");
////    print(nodeCodePath);
//    if (!File(nodeCodePath).existsSync()) return ;
//    var codebytes = File(nodeCodePath).readAsBytesSync();
//    var code = String.fromCharCodes(codebytes);
////    print(code);
//    var enums = StateScriptProject.instance.enums;
//
//    for(var e in enums){
//      if (code.indexOf(new RegExp(r'^Buttons')) >=0){
//        _selectEnums.add(e);
//      }
//    }
//    var agents = StateScriptProject.instance.agents;
//    for (var a in agents){
//      if (code.indexOf(r"^${a.name}$") >=0){
//        addAgent(a);
//      }
//    }
  }

  List<SSEnumType> sortedEnums;
  Widget getEnumWidget(){

    sortedEnums = _nodeCamp.enums;
    sortedEnums.sort((a,b)=>a.name.compareTo(b.name));
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    var filter = Row(
      children: [
        Icon(Icons.search , size: 24, color: Colors.black,),
        Expanded(
          child: TextField(
            autofocus: false,
            onChanged: (v) {
              setState(() {
              }
              );
            },
          ),
        ),
      ],
    );

    return Container(
//      decoration: dc,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: filter,
          ),
          SizedBox(height: 8,),
          Expanded (child :Container(
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: Container(
//              color :Colors.black12,
              child : getEnumList(),
            ),
          )),
        ],
      ),
    );

  }

  Widget getEnumList() {
//    var groups = StateScriptProject.instance.getStructGroups();

    var lst = ListView.builder(
      itemCount: sortedEnums.length,
      itemBuilder: onBuildEnum ,
    );
    return Scrollbar(
      child: lst,
    );

  }
  List<SSEnumType> _selectEnums = new List<SSEnumType>();
  Widget onBuildEnum(BuildContext context, int index) {
    var item = sortedEnums[index];
    bool isSelected = _selectEnums.contains(item);
    return InkWell(
      onTap: (){
      },
      child: Container(
          padding: EdgeInsets.all(4),
          height: 58,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(child:item.getTypeShowWidget()),
//              Checkbox(
//                value:isSelected ,
//                onChanged: (v){
//                  setState(() {
//                    if (v){
//                      _selectEnums.add(item);
//                    }
//                    else{
//                      _selectEnums.remove(item);
//                    }
//                  });
//                },
//              )
            ],
          )
      ),
    );
  }


  List<SSAgent> sortedAgents;

  String _agentFilter ;

//  SSAgent _selected;
  List<SSAgent> _selectAgents = List<SSAgent>();

  List<SSComponent> sortedComps;

  String _compFilter ;

//  SSComponent _selectedComp;
  List<SSComponent> _selectComps = List<SSComponent>();
  Widget getAgentPanel(){
    sortedAgents = _nodeCamp.agents;
    if (_agentFilter != null && _agentFilter != ""){
      var fsl =_agentFilter.toLowerCase();
      sortedAgents = sortedAgents.where((element) {
        if (element.name.toLowerCase().indexOf(fsl) >=0) return true;
        if (element.alias.toLowerCase().indexOf(fsl) >=0) return true;
        return false;
      }).toList();
    }
    sortedAgents.sort((a,b)=>a.name.compareTo(b.name));
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    var filter = Row(
      children: [
        Icon(Icons.search , size: 24, color: Colors.black,),
        Expanded(
          child: TextField(
            autofocus: false,
            onChanged: (v) {
              setState(() {
                _agentFilter = v;
              }
              );
            },
          ),
        ),
      ],
    );

    return Container(
      width: 300,
//      decoration: dc,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: filter,
          ),

          SizedBox(height: 8,),
          Expanded (child :Container(
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: Container(
//              color :Colors.black12,
              child : getAgentList(),
            ),
          )),


        ],
      ),
    );
  }

  Widget getAgentList(){
    var lst = ListView.builder(
      itemCount: sortedAgents.length,
      itemBuilder: onBuildAgent,
    );
    return Scrollbar(
      child: lst,
    );
  }

  Widget onBuildAgent(BuildContext context, int index) {
    var item = sortedAgents[index];

    var comps = List<Widget>();
    item.componentIds.forEach((element) {
      var comp = _nodeCamp.getComponent(element);
      if (comp != null){
        var w = Container(
//          color: CommonUtil.alphaColor(Colors.green, 32),
          child: Row(
            children: [
              Expanded(child: Text(comp.getTypeShowString()),),
              SizedBox(height: 32,),
//              IconButton(
//                icon:Icon(MaterialCommunityIcons.delete_forever ,),
//                color: Colors.redAccent,
//                onPressed: (){
//                  setState(() {
//                    item.componentIds.remove(element);
//                  });
//                },
//              )
            ],
          ),
        );
        comps.add(w);
      }
    });

    if (comps.length <=0){
      var w = Container(
        height: 80,

        child: Container(),
      );
      comps.add(w);
    }

    bool bSelected = _selectAgents.contains(item);
    return InkWell(
        onTap: (){
        },
//      child: Container(
//        padding: EdgeInsets.all(4),
//        height: 58,
//        color: isSelected?CommonUtil.alphaColor(Colors.indigo, 32):Colors.white,
//        child: item.getShowWidget(),
//      ),




        child : Container(
          color: Colors.white,
//        leading: Icon(MaterialCommunityIcons.account_badge_horizontal_outline , size: 40,),

          child:Column(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                color: CommonUtil.alphaColor(Colors.grey, 32),
                child: Row(
                    children:[
                      Icon(MaterialCommunityIcons.account_badge_horizontal_outline , size: 32,),
                      const SizedBox(width: 8,),
                      Text(item.getShowStringAndName() , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400 , color: Colors.grey),),
//                      Expanded(child:Container()),
//                      Checkbox(
//                        value : bSelected,
//                        onChanged: (v){
//                          setState(() {
//                            if (v) {addAgent(item); }
//                            else _selectAgents.remove(item);
//                          });
//
//                        },
//                      )
                    ]
                ),

              ),
              DragTarget<SSComponent>(
                onWillAccept: (e){return true;},
                onAcceptWithDetails: (e){
                  if (item.componentIds.contains(e.data.guid)){
                    BotToast.showText(text: "组件已存在", contentColor: Colors.redAccent);
                    return;
                  }
                  setState(() {
                    item.componentIds.add(e.data.guid);
                  });

                },
                builder :(BuildContext context, List<SSComponent> candidateData, List<dynamic> rejectedData){
                  return Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          TextEditor(
                            hint: "名字",
                            initValue: item.name,
                            enabled: false,
                            onChanged: (v){
                              item.name = v;
                            },
                            onSubmitted: (v){
                              setState(() {
                                item.name = v;
                              });
                            },
                          ),
                          TextEditor(
                            hint: "别名",
                            initValue: item.alias,
                            enabled: false,
                            onChanged: (v){
                              item.alias = v;
                            },
                            onSubmitted: (v){
                              setState(() {
                                item.alias = v;
                              });
                            },
                          ),
                          const SizedBox(height: 8,),
                          Container(
                            color: CommonUtil.alphaColor(Colors.yellow, 32),
                            child: Column(
                              children: comps,
                            ),
                          ),
                        ],
                      )
                  );
                },
              ),

            ],
          ),

        )
    );
  }
//
//  void addAgent(SSAgent agent){
//    _selectAgents.add(agent);
//    for(var c in agent.componentIds){
//      var comp = _nodeCamp.getComponent(c);
//      _selectComps.add(comp);
//    }
//  }
  Widget getComponentPanel() {
    sortedComps = _nodeCamp.components;
    if (_compFilter != null && _compFilter != ""){
      var fsl =_compFilter.toLowerCase();
      sortedComps = sortedComps.where((element) {
        if (element.name.toLowerCase().indexOf(fsl) >=0) return true;
        if (element.alias.toLowerCase().indexOf(fsl) >=0) return true;
        return false;
      }).toList();
    }
    sortedComps.sort((a,b)=>a.name.compareTo(b.name));
    var dc = new BoxDecoration(
      boxShadow: [ BoxShadow(color: Colors.grey, offset: Offset(1.0, 1.0),    blurRadius: 2.0, spreadRadius: 2.0) , BoxShadow(color: Colors.white)],
    );
    var filter = Row(
      children: [
        Icon(Icons.search , size: 24, color: Colors.black,),
        Expanded(
          child: TextField(
            autofocus: false,
            onChanged: (v) {
              setState(() {
                _compFilter = v;
              }
              );
            },
          ),
        ),
      ],
    );

    return Container(
      width: 400,
//      decoration: dc,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: filter,
          ),

          SizedBox(height: 8,),
          Expanded (child :Container(
            decoration: dc,
            padding: EdgeInsets.all(4),
            child: Container(
//              color :Colors.black12,
              child : getComponentList(),
            ),
          )),
        ],
      ),
    );
  }

  Widget getComponentList() {
    var lst = ListView.builder(
      itemCount: sortedComps.length,
      itemBuilder: onBuildComponent,
    );
    return Scrollbar(
      child: lst,
    );
  }

  Widget onBuildComponent(BuildContext context, int index) {
    var item = sortedComps[index];
//    bool isSelected = _selectedComp == item;

    bool bSelected = _selectComps.contains(item);
    return InkWell(
        onTap: (){
//          setState(() {
//            _selectedComp = item;
//          });
        },

        child : Container(
          color: Colors.white,

          child:Column(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                color: CommonUtil.alphaColor(Colors.grey, 32),
                child: Row(
                    children:[
                      Icon(MaterialCommunityIcons.power_plug , size: 32, color: CommonUtil.alphaColor(Colors.blue, 160),),
//                      Draggable(
//                        child: Icon(MaterialCommunityIcons.power_plug , size: 32, color: CommonUtil.alphaColor(Colors.blue, 160),),
//                        childWhenDragging: Icon(MaterialCommunityIcons.power_plug , size: 32, color: CommonUtil.alphaColor(Colors.blue, 160),),
//                        feedback: Icon(MaterialCommunityIcons.power_plug , size: 32, color: CommonUtil.alphaColor(Colors.redAccent, 160),),
//                        data:item,
//                      ),

                      const SizedBox(width: 8,),
                      Expanded(child: Text(item.getShowStringAndName() ,maxLines: 1, style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400 , color: Colors.grey),)),
//                      Checkbox(
//                        value: bSelected,
//                        onChanged: (v){
//                          setState(() {
//                            if (v) _selectComps.add(item);
//                            else _selectComps.remove(item);
//                          });
//                        },
//                      )
                    ]
                ),

              ),
            ],
          ),

        )
    );
  }

  void export(String path) {
    NodeCamp nc = NodeCamp();
    for(var n in _selectedNodes){
      nc.appendNodeType(n);
    }

    for(var e in _selectEnums){
      nc.enums.add(e);
    }

    for(var a in _selectAgents){
      nc.agents.add(a);
    }

    for(var c in _selectComps){
      nc.components.add(c);
    }

    nc.saveTo(path);

    BotToast.showText(text: "导出预制包完成");

  }

  void loadPackInfo() {
    NodeCamp nc = _nodeCamp;
    if (nc == null) return ;
    String res = "";
    for(var n in nc.nodeStructs){
      var nodes = StateScriptProject.instance.nodeStructs.where((element) => element.guid == n.guid).toList();
      if (nodes.length<=0){
        res += "导入结点 ${n.name}\n";
        StateScriptProject.instance.nodeStructs.add(n);
      }
      else{
        res += "已存在,忽略结点 ${n.name}\n";
      }
    }

    for(var n in nc.enums){
      var objs = StateScriptProject.instance.enums.where((element) => element.guid == n.guid).toList();
      if (objs.length<=0){
        res += "导入枚举 ${n.name}\n";
        StateScriptProject.instance.enums.add(n);
      }
      else{
        res += "已存在,忽略枚举 ${n.name}\n";
      }
    }

    CBTypeEnum.buildAllEnumMaps();

    for(var n in nc.agents){
      var objs = StateScriptProject.instance.agents.where((element) => element.guid == n.guid).toList();
      if (objs.length<=0){
        res += "导入实例 ${n.name}\n";
        StateScriptProject.instance.agents.add(n);
      }
      else{
        res += "已存在,忽略实例 ${n.name}\n";
      }
    }

    for(var n in nc.components){
      var objs = StateScriptProject.instance.components.where((element) => element.guid == n.guid).toList();
      if (objs.length<=0){
        res += "导入组件 ${n.name}\n";
        StateScriptProject.instance.components.add(n);
      }
      else{
        res += "已存在,忽略组件 ${n.name}\n";
      }
    }

    BotToast.showText(text: "预制包导入完成\n$res");
  }

}