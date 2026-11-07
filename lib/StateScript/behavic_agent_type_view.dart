//@dart=2.11
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBTypeEnum.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentClass.dart';
import 'package:battlepus/StateScript/Struct/BehavicAgentMethod.dart';
import 'package:battlepus/StateScript/Struct/ExportMappingConfig.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSEnumItem.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/SSObjBase.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/PopupTreeMenu/popup_tree_menu.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/checkbox_with_title.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/path_picker.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/tooltip_helper.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

class BehavicAgentTypeView extends StatefulWidget {
  BehavicAgentTypeView({Key key}) : super(key: key);

  @override
  _BehavicAgentTypeViewState createState() => _BehavicAgentTypeViewState();
}

class _BehavicAgentTypeViewState extends State<BehavicAgentTypeView> {
  int index = 0;

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(

//            toolbarHeight:52,
        title: Text("Behavic Agents"),
            elevation:0,
          actions: [
            IconButton(icon: Icon(MaterialCommunityIcons.delete_sweep),iconSize: 36, color: Colors.red, tooltip:"清理无用函数",
              onPressed: (){
                StateScriptProject.instance.removeUnusfulFuncs();
                BotToast.showText(text: "清理完毕");
              },
            ),
            IconButton(icon: Icon(MaterialCommunityIcons.auto_fix),iconSize: 36, color: Colors.red, tooltip:"函数迁移保存路径",
              onPressed: (){
                StateScriptProject.instance.fixFunctionSavePath();
                BotToast.showText(text: "迁移完毕");
              },
            ),
            IconButton(icon: Icon(MaterialCommunityIcons.import),iconSize: 36, color: Colors.white, tooltip:"从腾讯behavic导入",
              onPressed: (){
                FileUtils.pickFile("选择behavic meta文件", ["xml"]).then((value){
                  if (value != null){
                    importBehavicMeta(value);
                    setState(() {

                    });
                  }
                });
              },
            ),
            IconButton(icon: Icon(MaterialCommunityIcons.content_save),iconSize: 36, color: Colors.white, tooltip:"保存",
              onPressed: (){
                StateScriptProject.instance.save();
              },
            ),
          ],
      ),
      body:Container(
        // padding: EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(flex : 2 , child: getThemeStructTree()),
            // SizedBox(width: 8,),
            Expanded(flex : 10 , child: getDetail()),
          ],
        ),
      ),
    );
  }

  void importBehavicMeta(String metaPath){
    final file = new File(metaPath);
    if (!file.existsSync()){
      return;
    }
    final document = XmlDocument.parse(file.readAsStringSync());
    final enums = document.findAllElements('enumtype');
    StateScriptProject.instance.enums.removeWhere((element) => element.isBehavicEnum??false);

    Map<String , SSEnumType> name2BEnums = Map<String , SSEnumType>();
    StateScriptProject.instance.enums.forEach((element) {
      name2BEnums[element.name] = element;
    });
    for(var e in enums){
      var aenum = SSEnumType()..isBehavicEnum = true;
      var fullName = e.getAttribute("Type");
      var sps = fullName.split("::");
      if (sps.length>=2){
        aenum.name = sps[1];
      }
      else{
        aenum.name = fullName;
      }
      aenum.namespace = e.getAttribute("Namespace")??"";
      aenum.alias = e.getAttribute("DisplayName")??"";
      aenum.desc = e.getAttribute("Desc")??"";
      var impl = e.getAttribute("IsImplemented");
      aenum.needExportCode = impl == null || impl == "false";
      var items = e.findAllElements('enum');
      for(var itm in items){
        var aItm = SSEnumItem();
        aItm.name = itm.getAttribute("Value")??"";
        aItm.alias = itm.getAttribute("DisplayName")??"";
        aItm.enumValue = int.parse(itm.getAttribute("MemberValue")??"0");
        aenum.items.add(aItm);
      }

      name2BEnums[aenum.name] = aenum;
      SSFieldType.registerFieldType(aenum.guid, aenum..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD);
      StateScriptProject.instance.enums.add(aenum);
    }


    StateScriptProject.instance.behavicAgentProject.classes.clear();
    Map<String , BehavicAgentClass> name2Clzes = Map<String , BehavicAgentClass>();
    Map<String , XmlElement> guid2XMLNodes = Map<String , XmlElement>();

    final agents = document.findAllElements('agent');
    for(var agent in agents){
      var clz = BehavicAgentClass();
      var fullName = agent.getAttribute("classfullname");
      var sps = fullName.split("::");
      if (sps.length>=2){
        clz.name = sps[1];
        clz.namespace = sps[0];
      }
      else{
        clz.name = fullName;
        clz.namespace = "";
      }
      clz.alias = agent.getAttribute("DisplayName");
      clz.desc = agent.getAttribute("Desc");
      clz.exportPath = agent.getAttribute("ExportLocation");
      var impl = agent.getAttribute("IsImplemented");
      // print(agent);

      clz.needExportCode = impl != "true";
      print("${clz.name} impl $impl ${clz.needExportCode}");
      name2Clzes[clz.name] = clz;
      guid2XMLNodes[clz.guid] = agent;
      SSFieldType.registerFieldType(clz.guid, clz..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD);
      StateScriptProject.instance.behavicAgentProject.classes[clz.guid] = clz;
    }

    final structs = document.findAllElements('struct');
    for(var stru in structs){
      var astru = BehavicAgentClass()..isStruct = true;
      var fullName = stru.getAttribute("Type");
      var sps = fullName.split("::");
      if (sps.length>=2){
        astru.name = sps[1];
        astru.namespace = sps[0];
      }
      else{
        astru.name = fullName;
        astru.namespace = "";
      }
      astru.alias = stru.getAttribute("DisplayName");
      astru.desc = stru.getAttribute("Desc");
      // astru.exportPath = agent.getAttribute("ExportLocation");
      var impl = stru.getAttribute("IsImplemented");
      astru.needExportCode = impl != "true";

      name2Clzes[astru.name] = astru;
      guid2XMLNodes[astru.guid] = stru;
      SSFieldType.registerFieldType(astru.guid, astru..flag = SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD);
      StateScriptProject.instance.behavicAgentProject.classes[astru.guid] = astru;
    }


    var getFieldGuid = (String tp ,String dv){
      if (tp == null) return null;
      bool isList = tp.indexOf("vector<")>=0;
      if (isList) {
        tp = tp.replaceAll("vector<", "");tp = tp.replaceAll(">", "");
      }
      tp = tp.replaceAll("*", "").trim();
      // print(tp);
      String tpGuid;
      dynamic defaultValue;
      var sysTypeId = "___${tp}___";
      var tpObj = SSFieldType.getFieldType(sysTypeId);
      if (tpObj != null){
        tpGuid = sysTypeId;
        // var dv = mb.getAttribute("defaultvalue");
        if (!DartCommon.isEmpty(dv)){
          defaultValue = tpObj.parseString(dv);
        }
      }
      if (tpGuid == null){
        var tpSps = tp.split("::");
        var rtp = tpSps.length>=2?tpSps[1]:tp;
        var renum = name2BEnums[rtp];
        if (renum != null){
          tpGuid = renum.guid;
          // var dv = mb.getAttribute("defaultvalue");
          if (!DartCommon.isEmpty(dv)){
            var itemObj = renum.findItemByName(dv);
            if (itemObj != null) {
              defaultValue = itemObj.guid;
            }
          }
        }
        else{
          var rClz = name2Clzes[rtp];
          if (rClz != null){
            tpGuid = rClz.guid;
          }
        }
      }
      if (tpGuid == null) return null;
      if(isList){
        return {"guid" : "___list___" , "inner" : tpGuid, "defaultValue":defaultValue};
      }
      return {"guid" : tpGuid , "defaultValue":defaultValue};
    };

    for(var clz in StateScriptProject.instance.behavicAgentProject.classes.values){
      var node = guid2XMLNodes[clz.guid];
      var base = node.getAttribute("base")??"";
      if (base.split("::").length>=2){
        base = base.split("::")[1];
      }

      var baseType = name2Clzes[base];
      if (baseType != null){
        clz.baseAgentGuid = baseType.guid;
      }
      //字段
      var mbs = node.findAllElements('Member');
      for(var mb in mbs){
        var fi = FieldInfo();
        fi.name = mb.getAttribute("Name")??"";
        fi.alias = mb.getAttribute("DisplayName")??"";
        fi.desc = mb.getAttribute("Desc")??"";
        fi.isStatic = mb.getAttribute("Static") == "true";
        fi.isPublic = mb.getAttribute("Public") == "true";
        fi.isReadOnly = mb.getAttribute("Readonly") == "true";
        var tp = mb.getAttribute("Type");//.replaceAll("*", "");

        var tfinfo = getFieldGuid(tp , mb.getAttribute("defaultvalue"));
        if (tfinfo == null){
          print("------------------------------------------ importBehavicMeta 未知字段类型 : $tp");
          continue;
        }
        fi.typeGuid = tfinfo["guid"];
        fi.innerTypeGuid0 = tfinfo["inner"];
        fi.defaultValue = tfinfo["defaultValue"];
        clz.fields[fi.guid] = fi;
      }

      //方法
      var mthds = node.findAllElements('Method');
      for(var m in mthds){
        var am = BehavicAgentMethod();
        am.name = m.getAttribute("Name")??"";
        am.alias = m.getAttribute("DisplayName")??"";
        am.desc = m.getAttribute("Desc")??"";
        am.isStatic = m.getAttribute("Static") == "true";
        am.isPublic = m.getAttribute("Public") == "true";

        var returnType = m.getAttribute("ReturnType");
        if (returnType == "void"){
          am.withReturn = false;
        }
        else {
          var rtp = getFieldGuid(returnType, null);
          if (rtp == null) {
            print("------------------------------------------ importBehavicMeta 未知 return 类型 : $returnType");
            continue;
          }
          am.withReturn = true;
          am.returnType = FieldInfo();
          am.returnType.typeGuid = rtp["guid"];
          am.returnType.innerTypeGuid0 = rtp["inner"];
        }

        var prms = m.findAllElements('Param');
        for(var prm in prms){
          var aprm = FieldInfo();
          aprm.name = prm.getAttribute("Name")??"";
          aprm.alias = prm.getAttribute("DisplayName")??"";
          aprm.desc = prm.getAttribute("Desc")??"";
          aprm.isRef = prm.getAttribute("IsRef") == "true";

          var ppptype = prm.getAttribute("Type");
          var prmrtp = getFieldGuid(ppptype, null);
          if (prmrtp == null){
            print("------------------------------------------ importBehavicMeta 未知 param 类型 : $ppptype");
            continue;
          }
          aprm.typeGuid = prmrtp["guid"];
          aprm.innerTypeGuid0 = prmrtp["inner"];
          am.params[aprm.guid] = aprm;
        }


        clz.methods[am.guid] = am;
      }

    }

    CBTypeEnum.buildAllEnumMaps();

  }



  BehavicAgentClass _selected ;
  ATreeNode<BehavicAgentClass> _nodeRoot;
  bool _nodeRootNR = false;
  ATreeNode<BehavicAgentClass> getNodeTreeRoot(){
    if (_nodeRoot == null || _nodeRootNR){
      var scripts = StateScriptProject.instance.behavicAgentProject.classes.values.toList();//.where((element) => false == element.isModule).toList();
      _nodeRoot = DartCommon.buildTree(scripts, (item){
        var sp = (item as BehavicAgentClass).group.split("/");
        return sp;
      });
    }
    _nodeRootNR = false;
    return _nodeRoot;
  }
  void forceBuildTree(){
    _nodeRootNR = true;
  }

  Widget getThemeStructTree() {
    var con = SearchableThemeTreeView(
      defaultExpanded: false,
      onExpandedFlagChanged: (map){
        SSUserData.instance.behavicAgentExpandedFlags = map;
        SSUserData.instance.save();
      },
      indent: 16,
      expandedFlags: SSUserData.instance.behavicAgentExpandedFlags,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getNodeTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<BehavicAgentClass>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<BehavicAgentClass>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<BehavicAgentClass>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          var txt = Text((si as BehavicAgentClass).getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
            color: _selected == si? CommonUtil.alphaColorD(Colors.blue,0.4):null,
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 32,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              children: [
                // Visibility(
                //   visible: si.isModule??false,
                //   child: Icon(MaterialCommunityIcons.alpha_m_box_outline , color: Colors.brown,),
                // ),
                // cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
                SizedBox(width: 4,),
                Expanded(child : txt),
                TooltipHelper(
                  width: 28 , height : 28,
                  value: si.desc,//DartCommon.isEmpty(si.desc)?"没有注释":si.desc,

                  onSubmitted: (v){
                    si.desc = v;
                  },
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.minus_box_outline),
                      tooltip: "删除Agent",
                      color: Colors.redAccent,
                      iconSize: iconSize,
                      onPressed: (){
                        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                          setState(() {
                            StateScriptProject.instance.behavicAgentProject.classes.remove(si.guid);
                            StateScriptProject.instance.save();
                            SSFieldType.unregisterFieldType(si.guid);
                            if (si == _selected) {
                              _selected = null;
                              _selectedMethod = null;
                              _selectedFieldInfo = null;
                              // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(si));
                              forceBuildTree();
                            }
                          });
                        });
                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.shape_square_plus),
                      color: Colors.lightBlueAccent,
                      tooltip: "复制Agent",
                      iconSize: iconSize,
                      onPressed: (){

                        setState(() {
                          _selected = StateScriptProject.instance.behavicAgentProject.cloneNodeStruct(si);
                          _selectedMethod = null;
                          _selectedFieldInfo = null;
                          // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                          SSFieldType.registerFieldType(_selected.guid, _selected);
                          forceBuildTree();
                        });

                      },
                    )
                ),

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
        var ns  = node as ATreeNode<BehavicAgentClass>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.group}`${n.alias}";
        }
        return "";
      },


      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<BehavicAgentClass>).data;
          if (si != null) {
            _selected = si;
            _selectedMethod = null;
            _selectedFieldInfo = null;
            // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }
          // forceBuildTree();
        });

      },

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.indigo,
          iconSize: 32,
          onPressed: (){

            var newNode = StateScriptProject.instance.behavicAgentProject.addNewType();

            SSFieldType.registerFieldType(newNode.guid, newNode);
            StateScriptProject.instance.save();
            setState(() {
              _selected = newNode;
              _selectedMethod = null;
              _selectedFieldInfo = null;
              // _newNode = newNode;
              // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
              forceBuildTree();
            });

          },
        ),

      ],
    );
    var block = ThemeCenter.block (
      headTitle: "Agent 列表",
      // width: 480,
      child: con,
    );
    return block;
  }

  List<FieldInfo> fieldsLst = List<FieldInfo>();
  getDetail(){
    Widget con ;
    if (_selected == null){
      con = Center(
        child: Text("左侧选择一个 Agent" , style: ThemeCenter.mainTextStyle(step: 4,fontSize: 32),),
      );
      return ThemeCenter.block (
        // expanded: false,
        padding: EdgeInsets.all(8),
        headTitle: "Agent 详细",
        // width: 480,
        child: con,
      );
    }
    else{
      con = getAgentDetail();
    }



    var block = ThemeCenter.block (
      expanded: false,
      padding: EdgeInsets.all(8),
      headTitle: "Agent 基本信息",
      // width: 480,
      child: con,
    );



    //字段列表
    fieldsLst = _selected.fields.values.toList();
    SSObjBase.sortByIndex(fieldsLst);

    // var fieldsBlock = getThemeFieldsTree();

    Widget body ;
    switch(index){
      case 0:
        body = getThemeFieldsTree();
        break;
      case 1:
        body = getThemeMethodsTree();
        break;
    }

    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            block,
            // fieldsBlock,
            Expanded(
              child:body,
            ),
            ConvexAppBar(
              // 该页自行用 index 管理页签，没有 DefaultTabController 祖先，
              // 必须关闭默认控制器，否则 ConvexAppBar 会调用 DefaultTabController.of 抛空指针
              disableDefaultTabController: true,
              // height: 46,
              // curveSize: 20,
              backgroundColor: ThemeCenter.systemTheme.bottomAppBarColor,
              items: [
                TabItem(icon: MaterialCommunityIcons.code_array, title: '字段定义'),
                TabItem(icon: MaterialCommunityIcons.function_variant, title: '函数方法'),
              ],
              initialActiveIndex: index,//optional, default as 0
              onTap: (int i) {
                setState(() {
                  index = i;
                });
              },
            )
          ],
      )
    );
  }

  Widget getAgentDetail() {
    var baseAgent = StateScriptProject.instance.behavicAgentProject.classes[_selected.baseAgentGuid??""];
    var clzLst = StateScriptProject.instance.behavicAgentProject.classes.values.toList()..removeWhere((element) => element.guid == _selected.guid);
    
    var classHeader = Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      height: 42,
      // width: 900,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ThemeCenter.roundRect(height : 42 , padding: EdgeInsets.fromLTRB(8, 3, 8, 2), child: Text("类名" ,style: TextStyle(fontWeight: FontWeight.w800),) ,borderColor: Colors.brown,  bgColor: CommonUtil.alphaColorD(Colors.brown , 0.1) , radius: 3) ,
          Container(width: 8,),
          Container(
            width: 300,
            child: TextEditor(
              initValue: _selected.name??"",
              onChanged: (v){
                _selected.name = v;
              },
            ),
          ),
          Container(width: 16,),
          ThemeCenter.roundRect(height : 42 , padding: EdgeInsets.fromLTRB(8, 3, 8, 2), child: Text("別名" ,style: TextStyle(fontWeight: FontWeight.w800),) ,borderColor: Colors.brown, bgColor: CommonUtil.alphaColorD(Colors.brown , 0.1) , radius: 3) ,
          Container(width: 8,),
          Container(
            width: 300,
            child: TextEditor(
              initValue: _selected.alias??"",
              onChanged: (v){
                _selected.alias = v;
              },
            ),
          ),

          Container(width: 16,),
          ThemeCenter.roundRect(height : 42 , padding: EdgeInsets.fromLTRB(8, 3, 8, 2), child: Text("继承自" ,style: TextStyle(fontWeight: FontWeight.w800),) ,borderColor: Colors.brown, bgColor: CommonUtil.alphaColorD(Colors.brown , 0.1) , radius: 3) ,
          Container(width: 8,),


          ElevatedButton(
            child: Text(baseAgent?.getTypeShowString()??"无"),
            onPressed: (){
              CommonUtil.popupTreeMenu(clzLst, context ,
                title: "选择父类",
                width: 600,
                height: 800,
                onBuildItem: (clz){
                  var txt = Text((clz as BehavicAgentClass).getTypeShowString() , style : clz == baseAgent ? TextStyle(color: Colors.greenAccent):null);
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
                  if (clz != null){
                    if (_selected.isParentOf(clz)){
                      BotToast.showText(text: "检测到企图循环继承,忽略本次操作",contentColor:  Colors.redAccent);
                      return ;
                    }
                    setState(() {
                      _selected.baseAgentGuid = clz.guid;
                    });

                  }
                },
                actions: [
                  ElevatedButton(
                    child: Text("清空"),
                    style: ButtonStyle(backgroundColor: CommonUtil.createTextBtnBgColor(Colors.redAccent)),
                    // color: Colors.redAccent,
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        _selected.baseAgentGuid = "";
                      });

                    },
                  )
                ]
              );
            },
          ),

          Expanded(child:Container()),
          // CheckboxWithTitle(
          //   key: ValueKey(Uuid().v4()),
          //   title: "Struct",
          //   style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),
          //   value: _selected.isStruct??false,
          //   onChanged: (v){
          //
          //     setState(() {
          //       _selected.isStruct = v;
          //     });
          //   },
          // ),
          // CheckboxWithTitle(
          //   key: ValueKey(Uuid().v4()),
          //   title: "导出代码",
          //   style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),
          //   value: _selected.needExportCode??false,
          //   onChanged: (v){
          //
          //     setState(() {
          //       _selected.needExportCode = v;
          //     });
          //   },
          // ),

        ],
      )
    );
    var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    var classHeader2 = Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        height: 42,
        // width: 900,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ThemeCenter.roundRect(height : 42 , padding: EdgeInsets.fromLTRB(8, 3, 8, 2), child: Text("命名空间" ,style: TextStyle(fontWeight: FontWeight.w800),) ,borderColor: Colors.brown,  bgColor: CommonUtil.alphaColorD(Colors.brown , 0.1) , radius: 3) ,
            Container(width: 8,),
            Container(
              width: 300,
              child: TextEditor(
                initValue: _selected.namespace??"",
                onChanged: (v){
                  _selected.namespace = v;
                },
              ),
            ),
            // Expanded(child:Container()),
            Container(width: 8,),
            ThemeCenter.roundRect(height : 42 , padding: EdgeInsets.fromLTRB(8, 3, 8, 2), child: Text("导出路径" ,style: TextStyle(fontWeight: FontWeight.w800),) ,borderColor: Colors.brown,  bgColor: CommonUtil.alphaColorD(Colors.brown , 0.1) , radius: 3) ,
            Container(width: 8,),
            Expanded(child:PathPicker(
              key: ValueKey(Uuid().v4()),
              width: 600,
              initPath: _selected.exportPath??"",
              basePath: rp,
              onChoosePath: (v){
                _selected.exportPath = v;
              },
            )),
            Container(width :16),
            ElevatedButton(
              child: Text("导出代码"),
              onPressed: (){

                // StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
                // StateScriptProject.instance.prepareExport();
                // StateScriptProject.instance.exportVMCode();
                //
                // StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.luaConfig);
                // StateScriptProject.instance.prepareExport();
                // StateScriptProject.instance.exportVMCode();

                StateScriptProject.instance.getAllConfigs().forEach((element) {
                  StateScriptProject.instance.switchExportConfig(element);
                  StateScriptProject.instance.prepareExport();
                  StateScriptProject.instance.exportVMCode();
                });

                exportCode(_selected);
                BotToast.showText(text: "导出完毕");
              },
            ),
            Container(width :8),
            ElevatedButton(
              child: Text("仅导出VM代码"),
              onPressed: (){
                // StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.csharpConfig);
                // StateScriptProject.instance.prepareExport();
                // StateScriptProject.instance.exportVMCode();
                //
                // StateScriptProject.instance.switchExportConfig(StateScriptProject.instance.luaConfig);
                // StateScriptProject.instance.prepareExport();
                // StateScriptProject.instance.exportVMCode();
                StateScriptProject.instance.getAllConfigs().forEach((element) {
                  StateScriptProject.instance.switchExportConfig(element);
                  StateScriptProject.instance.prepareExport();
                  StateScriptProject.instance.exportVMCode();
                });
                BotToast.showText(text: "导出完毕");
              },
            ),
          ],
        )
    );


    var classHeader3 = Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        height: 42,
        // width: 900,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            ThemeCenter.roundRect(height : 42 , padding: EdgeInsets.fromLTRB(8, 3, 8, 2), child: Text("类别" ,style: TextStyle(fontWeight: FontWeight.w800),) ,borderColor: Colors.brown, bgColor: CommonUtil.alphaColorD(Colors.brown , 0.1) , radius: 3) ,
            Container(width: 8,),
            Container(
              width: 300,
              child: TextEditor(
                initValue: _selected.group??"",
                onChanged: (v){
                  _selected.group = v;
                },
                onSubmitted: (v){
                  setState(() {
                    _selected.group = v;
                    forceBuildTree();
                  });
                },
              ),
            ),
            Container(width: 32,),
            CheckboxWithTitle(
              key: ValueKey(Uuid().v4()),
              title: "Struct",
              style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),
              value: _selected.isStruct??false,
              onChanged: (v){

                setState(() {
                  _selected.isStruct = v;
                });
              },
            ),
            CheckboxWithTitle(
              key: ValueKey(Uuid().v4()),
              title: "导出代码",
              style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),
              value: _selected.needExportCode??false,
              onChanged: (v){

                setState(() {
                  _selected.needExportCode = v;
                });
              },
            ),

          ],
        )
    );

    return Column(
      children: [
        classHeader,
        classHeader2,
        classHeader3,
      ],
    );
  }
  String getTempExt(String temp){
    return PathUtil.extension(temp.replaceAll(".temp", ""));
  }
  String getTemp2Name(String temp){
    return PathUtil.basename(temp).replaceAll(".temp", "");
  }
  // void exportVMCode(){
  //   var shell = Shell(throwOnError : false  , verbose : false ,commandVerbose : false , commentVerbose : false , stdoutEncoding : utf8 , stderrEncoding : utf8);
  //   var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
  //   var tempPath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance.csharpConfig.templatePath, basePath: basePath);
  //   ExportMappingConfig.load(tempPath , force: true);
  //   var coolFormat = PathUtil.join(GlobalBoard.getWorkingPath() , "CoolFormat.exe");
  //   final context = Context.create();
  //   context.variables['namespace'] = ExportMappingConfig.instance.namespace;
  //
  //   List<FieldInfo> fields = List<FieldInfo>();
  //   List<BehavicAgentMethod> methods = List<BehavicAgentMethod>();
  //   for(var ag in StateScriptProject.instance.behavicAgentProject.classes.values){
  //     for(var m in ag.methods.values){
  //       methods.add(m);
  //     }
  //     for(var m in ag.fields.values){
  //       fields.add(m);
  //     }
  //   }
  //
  //   SSObjBase.buildExportId(fields);
  //   SSObjBase.buildExportId(methods);
  //
  //   List clzs = List();
  //
  //   for(var ag in StateScriptProject.instance.behavicAgentProject.classes.values){
  //     var clz = ag.exportInfo();
  //     clzs.add(clz);
  //   }
  //
  //   List ops = List();
  //   List sops = List();
  //   for(var opkey in  CodeBlockyType.ovmOperands.keys){
  //
  //     var n = {
  //       "operate":opkey,
  //       "operate_val":CodeBlockyType.ovmOperates[opkey] ,
  //     };
  //     sops.add(n);
  //     var oprds = CodeBlockyType.ovmOperands[opkey];
  //     List tmp = List();
  //     for (var oprd in oprds){
  //       var m = {
  //         "operate":opkey,
  //         "operand": oprd,
  //         "operate_val":CodeBlockyType.ovmOperates[opkey] ,
  //         "operand_val": CodeBlocky.operateExtras[oprd],
  //         "id": CodeBlockyType.ovmOperates[opkey] + CodeBlocky.operateExtras[oprd],
  //       };
  //       tmp.add(m);
  //     }
  //     if(tmp.length <=0){
  //       tmp.add({
  //         "operate":opkey,
  //         "operand": 0,
  //         "operate_val":CodeBlockyType.ovmOperates[opkey] ,
  //         "operand_val": 0,
  //         "id": CodeBlockyType.ovmOperates[opkey],
  //       });
  //     }
  //     ops.add(tmp);
  //
  //   }
  //   context.variables['OVMOPS'] = ops;
  //   context.variables['OVMSOPS'] = sops;
  //   // var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
  //   var iPath = StateScriptProject.instance.csharpConfig.codeExportPath;
  //   iPath = PathUtil.canonicalize(PathUtil.join(basePath , iPath));
  //   if (!Directory(iPath).existsSync()) {
  //     BotToast.showText(text: "路径 $iPath 不存在",contentColor: Colors.redAccent);
  //     return ;
  //   }
  //   {
  //     var tempDir = PathUtil.join(tempPath, "behavic_codes");
  //     var dir = Directory(tempDir);
  //     if (dir.existsSync()) {
  //       var files = dir.listSync();
  //       for (var f in files) {
  //         if (f is File && f.path.endsWith(".temp")) {
  //           var savePath = PathUtil.join(iPath, "${getTemp2Name(f.path)}");
  //
  //           context.variables['clazzes'] = clzs;
  //           var templateData = f.readAsStringSync();
  //           final template = Template.parse(context, Source.fromString(templateData));
  //           var outCode = (template.render(context));
  //           outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\n", multiLine: true), "");
  //
  //           Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
  //           File(savePath).writeAsStringSync(outCode);
  //
  //           var cmd2 = '"$coolFormat" -f "${savePath.replaceAll("\\", "/")}"';
  //           shell.run(cmd2);
  //           // DartCommon.launchURL(savePath);
  //         }
  //       }
  //     }
  //   }
  //
  //
  // }
  void exportCode(BehavicAgentClass agent){

    var basePath = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    var tempPath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance.csharpConfig.templatePath, basePath: basePath);
    ExportMappingConfig.load(tempPath , force: true);

    final context = Context.create();
    context.variables['namespace'] = ExportMappingConfig.instance.namespace;
    var clz = agent.exportInfo();

    // var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    var iPath = agent.exportPath;
    iPath = PathUtil.canonicalize(PathUtil.join(basePath , iPath));
    if (!Directory(iPath).existsSync()) {
      BotToast.showText(text: "路径 $iPath 不存在",contentColor: Colors.redAccent);
      return ;
    }
    // codePath =
    {
      var tempDir = PathUtil.join(tempPath, "behavic");
      var dir = Directory(tempDir);
      if (dir.existsSync()) {
        var files = dir.listSync();
        for (var f in files) {
          if (f is File && f.path.endsWith(".temp")) {
            var savePath = PathUtil.join(iPath, "${agent.name}${getTempExt(f.path)}");
            Map<String , int> prios = Map<String , int>();
            if (File(savePath).existsSync()){
              print(savePath);
              Map codes = Map();
              var oldCode = File(savePath).readAsStringSync();
              // print(oldCode);
              // var regFile = RegExp(r'///<<< BEGIN WRITING YOUR CODE (\w+)[\n|\r]+(.*)[\n|\r]+///<<< END WRITING YOUR CODE' , multiLine:true);
              // var regFile = RegExp(r'///<<< BEGIN WRITING YOUR CODE (\w+)\s*[\n|\r]([\s\S]*?)[\n|\r]\s*///<<< END WRITING YOUR CODE' , multiLine:false);
              var regFile = RegExp(r'///<<< BEGIN WRITING YOUR CODE (\w+)\s*[\n|\r]([\s\S]*?)///<<< END WRITING YOUR CODE' , multiLine:false);

              var allMatch = regFile.allMatches(oldCode);
              for(var m in allMatch){
                print(m.group(0));
                var codeName = m.group(1);
                var codeContent = m.group(2);
                if (codeName == agent.name){
                  codeName = 'CLASS_INIT';
                }
                // print("------ all : ${m.group(0)}");
                // print("------ name : $codeName");
                // print("------ code : $codeContent");

                codes[codeName]=codeContent;
                prios[codeName] = prios.length;
                print("--------------------------------------------------------------------------------------------------------");
              }

              context.variables['codes'] = codes;
              // print(prios);
              var methods = clz['methods'];
              methods.sort((a,b)=>(prios[a["name"]]??102400) - (prios[b["name"]]??102400));
              // print(methods);
              for(var m in methods){
                var code = codes[m["name"]];
                if (code != null){
                  m["code"] = code;
                }
              }
            }

            context.variables['clz'] = clz;
            var templateData = f.readAsStringSync();
            final template = Template.parse(context, Source.fromString(templateData));
            var outCode = (template.render(context));
            // outCode = outCode.trim().replaceAll(new RegExp(r"^\s*\n", multiLine: true), "");

            Directory(PathUtil.dirname(savePath)).createSync(recursive: true);
            // File(savePath+".tmp").writeAsStringSync(outCode);
            File(savePath).writeAsStringSync(outCode);
            DartCommon.launchURL(savePath);
          }
        }
      }
    }
    BotToast.showText(text: "导出完成",contentColor: Colors.green);
  }

  FieldInfo _selectedFieldInfo ;
  ATreeNode<FieldInfo> _fieldRoot;
  // bool _fieldRootNR = false;
  ATreeNode<FieldInfo> getFieldTreeRoot(){
    _fieldRoot = null;
    if (_fieldRoot == null ){
      var scripts = fieldsLst;//.where((element) => false == element.isModule).toList();
      _fieldRoot = DartCommon.buildTree(scripts, (item){
        // var sp = (item as FieldInfo).group.split("/");
        // return sp;
        return <String>[];
      });
    }
    // _fieldRootNR = false;
    return _fieldRoot;
  }
  // void forceBuildTree(){
  //   _nodeRootNR = true;
  // }
  Widget getFieldAttribute(String name , bool active , Color clr){
    return ThemeCenter.roundRect(height : 26 , padding: EdgeInsets.fromLTRB(8, 2, 8, 2), child: Text(name ,style: TextStyle(fontWeight: FontWeight.w600 , color: active?Colors.white:Colors.white38),) , borderColor: active?clr:Colors.grey,  bgColor: active?CommonUtil.alphaColorD(clr , 0.3):Colors.grey , radius: 3);
  }

  Widget _getTypeWidgets(FieldInfo item) {
    var bIsEdit = true;////_selectedFieldInfo == item;
    var fi = SSFieldType.getFieldType(item.typeGuid,fieldInfo: item);
//    if (fi == null) fi =
    if (bIsEdit){
      var lst = SSFieldType.getTypeMap();
      lst.sort((a,b)=>a.priority-b.priority);

      List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
      for(var i in lst){
        var item = PopupMenuItem<String>(
          value: i.guid,
          child: i.getTypeShowWidget(),
        );
        items.add(item);
      }

      var res = PopupMenuButton<String>(
        padding: EdgeInsets.all(0),
        icon: Icon(MaterialCommunityIcons.menu , size: 20,),
        initialValue:item.typeGuid,

        onSelected: (String result) { setState(() { item.typeGuid = result; }); },
        itemBuilder: (BuildContext context) => items,
      );
      return Container(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(child:Container(
                  alignment: Alignment.center,
//              width: 200,
                  child: fi.getTypeShowWidget(fieldType: SSFieldType.getFieldType(item.typeGuid , fieldInfo: item), onChange: (v){
                    setState(() {
                      item.copyTypes(v);
                    });
                  }),
                )),
                // res
                Container(
                  width: 20,
                  child: res,
                ),
//            res,
              ]
          )

      );
    }
    return Container(
        padding: EdgeInsets.all(4),
        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Expanded(child:Container(
                alignment: Alignment.center,
//                width: 200,
                child: fi.getTypeShowWidget(fieldType: SSFieldType.getFieldType(item.typeGuid , fieldInfo: item)),
              )),
              Container(
                width: 40,
                child: SizedBox(width: 80,),
              ),
//            res,
            ]
        )

    );
  }

  ItemHolder getFieldDefault(FieldInfo item){
    var res = new ItemHolder();
    var fi = SSFieldType.getFieldType(item.typeGuid ,fieldInfo: item);

    // if ((fi.flag & SSFieldType.FIELD_FLAG_CONTAINER) >0){
    //   res.widget = Container(child: const Text("默认容器"),);
    //   return res;
    // }
    if ((fi.flag & SSFieldType.FIELD_NO_DEFAULT) >0){
      res.widget = Container(child: const Text("无"),);
      return res;
    }


    var bIsEdit = true;

    // var edt = Container();
    if ((fi.flag & SSFieldType.FIELD_FLAG_REF) >0){
      res.widget = Container(child: const Text("默认空对象"),);
      return res;
    }
    var gci = GridCellInfo()..isObjectTableMode = true..name = fi.getTypeShowString();
    var edt = bIsEdit?fi.getGridCellEditor(
      context: context,
      initValue : item.defaultValue,
      onChanged : null,
      gci:gci,
      onSubmitted: (v){
          setState(() {
            // print("set $v");
            item.defaultValue = v;
          });
        },

    ).widget:fi.getValueLabelWidget(item.defaultValue);

    res.widget = ThemeCenter.roundRect( padding : EdgeInsets.fromLTRB(8, 0, 8, 0),height : 32 , width: 320 , child: edt ,borderColor: Colors.green,  bgColor : CommonUtil.alphaColorD(Colors.black, 0.1), radius: 3);
    return res;
  }

  Widget getThemeFieldsTree() {
    var con = SearchableThemeTreeView(
      defaultExpanded: true,
      indent: 16,
      root:getFieldTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<FieldInfo>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<FieldInfo>).children;
      },
      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<FieldInfo>;
        if (nd.isLeaf){
          // return Text((nodeStruct as ScriptInfo).name , style: style,);
          var si = nd.data;
          // var cate = SSCategory.categories.where((element) => element.id == si.category).toList();

          // var txt = Text((si as FieldInfo).getShowStringAndName()??"" ,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
          var iconSize = 28.0;
          var con = Container(
            // color: _selectedFieldInfo == si? CommonUtil.alphaColorD(Colors.blue,0.4):null,
            padding: EdgeInsets.fromLTRB(8,0,8,3),
            height: 34,
            // color: CommonUtil.scaleColor(Colors.grey, 0.15),
            // color: nd.isExpand ? CommonUtil.scaleColor(Colors.greenAccent, 0.15):CommonUtil.scaleColor(Colors.grey, 0.25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                InkWell(
                  child: getFieldAttribute("静态" , si.isStatic??false , Colors.redAccent),
                  onTap: (){
                    setState(() {
                      si.isStatic = !(si.isStatic??false);
                    });
                  },
                ),
                Container(width: 4,),
                InkWell(
                  child: getFieldAttribute("只读" , si.isReadOnly??false , Colors.deepPurpleAccent),
                  onTap: (){
                    setState(() {
                      si.isReadOnly = !(si.isReadOnly??false);
                    });
                  },
                ),
                Container(width: 4,),
                InkWell(
                  child: getFieldAttribute("公开" , si.isPublic??true , Colors.indigoAccent),
                  onTap: (){
                    setState(() {
                      si.isPublic = !(si.isPublic??true);
                    });
                  },
                ),
                Container(width: 4,),

                ThemeCenter.roundRect(height : 32 , width: 320 , child: _getTypeWidgets(si) ,borderColor: Colors.yellow,  bgColor : CommonUtil.alphaColorD(Colors.yellow, 0.1), radius: 3),
                Container(width: 8,),
                // Container(
                //   color:Colors.deepPurpleAccent,
                //   width: 300,
                //   child : _getTypeWidgets(si),
                // ),
                Text("属性名" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
                Container(width: 4,),
                Container(
                  width: 200,
                  child:TextEditor(
                    initValue: si.name??"",
                    onChanged: (v){
                      si.name = v;
                    },
                  )
                ),
                Container(width: 4,),
                Text("别名" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
                Container(width: 4,),
                Container(
                    width: 200,
                    child:TextEditor(
                      initValue: si.alias??"",
                      onChanged: (v){
                        si.alias = v;
                      },
                    )
                ),
                Container(width: 4,),
                Icon(MaterialCommunityIcons.equal_box),
                Container(width: 4,),
                Text("默认值" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
                Container(width: 4,),
                Container(
                  width: 200,
                  child: getFieldDefault(si).widget,
                ),

                // Visibility(
                //   visible: si.isModule??false,
                //   child: Icon(MaterialCommunityIcons.alpha_m_box_outline , color: Colors.brown,),
                // ),
                // cate.length>0?Icon(cate[0].icon , color : cate[0].color):Icon(FontAwesome.question, color : Colors.black),
                // SizedBox(width: 4,),
                Container(width: 4,),
                TooltipHelper(
                  width: 28 , height : 28,
                  value: si.desc,//DartCommon.isEmpty(si.desc)?"没有注释":si.desc,

                  onSubmitted: (v){
                    si.desc = v;
                  },
                ),
                Expanded(child : Container()),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.minus_box_outline),
                      tooltip: "删除字段",
                      color: Colors.redAccent,
                      iconSize: iconSize,
                      onPressed: (){
                        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                          setState(() {
                            _selected.fields.remove(si.guid);
                            // StateScriptProject.instance.save();
                            if (si == _selectedFieldInfo) _selectedFieldInfo = null;
                            // forceBuildTree();
                          });
                        });
                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.shape_square_plus),
                      color: Colors.lightBlueAccent,
                      tooltip: "复制字段",
                      iconSize: iconSize,
                      onPressed: (){

                        setState(() {
                          _selectedFieldInfo = si.clone();
                          fieldsLst.add(_selectedFieldInfo);
                          SSObjBase.refreshIndex(fieldsLst);
                          _selected.fields[_selectedFieldInfo.guid] = _selectedFieldInfo;
                          // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                          // forceBuildTree();
                        });

                      },
                    )
                ),

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
        var ns  = node as ATreeNode<FieldInfo>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return "${n.name}`${n.alias}";
        }
        return "";
      },


      onItemTap: (item){
        setState(() {

          var si = (item as ATreeNode<FieldInfo>).data;
          if (si != null) {
            _selectedFieldInfo = si;
            // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
          }
          // forceBuildTree();
        });

      },

      actions: [

        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.blue,
          tooltip: "添加字段",
          iconSize: 32,
          onPressed: (){

            var newField = FieldInfo();
            fieldsLst.add(newField);
            SSObjBase.refreshIndex(fieldsLst);
            _selected.fields[newField.guid] = newField;
            // StateScriptProject.instance.save();
            setState(() {
              _selectedFieldInfo = newField;
              // _newNode = newNode;
              // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
              // forceBuildTree();
            });

          },
        ),

      ],
    );
    var block = ThemeCenter.block (
      // padding: EdgeInsets.all(0),
      expanded: true,
      headTitle: "字段列表",
      // width: 480,
      child: con,
    );
    return block;
  }

  BehavicAgentMethod _selectedMethod ;
  Widget getThemeMethodsTree() {
    var methodLst =  _selected.methods.values.toList();
    SSObjBase.sortByIndex(methodLst);
    var iconSize = 28.0;
    var con1 = PopupTreeMenu(
      key:Key(_selected.guid),
      title: "函数列表",
      datas: methodLst,
      selectButton: false,
      onBuidItem: (si){
        if (si.returnType == null) si.returnType = FieldInfo();
        // var txt = Text((si as BehavicAgentMethod).getTypeShowString() , style : TextStyle(color: Colors.greenAccent));
        return Container(
          height: 34,
          child:Row(
            // crossAxisAlignment : WrapCrossAlignment.center,
            children: [
              Container(width: 4,),
              InkWell(
                child: getFieldAttribute("静态" , si.isStatic??false , Colors.redAccent),
                onTap: (){
                  setState(() {
                    si.isStatic = !(si.isStatic??false);
                  });
                },
              ),
              Container(width: 4,),
              InkWell(
                child: getFieldAttribute("公开" , si.isPublic??true , Colors.indigoAccent),
                onTap: (){
                  setState(() {
                    si.isPublic = !(si.isPublic??true);
                  });
                },
              ),
              Container(width: 8,),

              CheckboxWithTitle(
                title: "返回",
                style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),
                value: si.withReturn??false,
                onChanged: (v){

                  setState(() {
                    si.withReturn = v;
                  });
                },
              ),

              if (si.withReturn??false)Container(width: 4,),
              if (si.withReturn??false)ThemeCenter.roundRect(height : 32 , width: 320 , child: _getTypeWidgets(si.returnType) ,borderColor: Colors.yellow,  bgColor : CommonUtil.alphaColorD(Colors.yellow, 0.1), radius: 3),
              Container(width: 4,),
              Text("函数名" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
              Container(width: 4,),
              Container(
                  width: 200,
                  child:TextEditor(
                    initValue: si.name??"",
                    onChanged: (v){
                      si.name = v;
                    },
                  )
              ),
              Container(width: 4,),
              Text("别名" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
              Container(width: 4,),
              Container(
                  width: 200,
                  child:TextEditor(
                    initValue: si.alias??"",
                    onChanged: (v){
                      si.alias = v;
                    },
                  )
              ),
              Container(width: 4,),
              TooltipHelper(
                width: 28 , height : 28,
                value: si.desc,//DartCommon.isEmpty(si.desc)?"没有注释":si.desc,

                onSubmitted: (v){
                  si.desc = v;
                },
              ),
              Container(width: 4,),


              Expanded(child : Container()),
              Tooltip(
                message: (si.hide??false)?"隐藏,不可使用":"可以使用",
                child: Checkbox(
                  value: si.hide??false,
                  onChanged: (v){
                    setState(() {
                      si.hide = v;
                    });
                  },
                ),
              ),

              Container(
                  width: iconSize,
                  height: iconSize,
                  child:IconButton(
                    padding: EdgeInsets.all(0),
                    icon : Icon(MaterialCommunityIcons.minus_box_outline),
                    tooltip: "删除函数",
                    color: Colors.redAccent,
                    iconSize: iconSize,
                    onPressed: (){
                      CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                        setState(() {
                          _selected.methods.remove(si.guid);
                          if (si == _selectedMethod)
                            _selectedMethod = null;
                          // forceBuildTree();
                        });
                      });
                    },
                  )
              ),
              Container(
                  width: iconSize,
                  height: iconSize,
                  child:IconButton(
                    padding: EdgeInsets.all(0),
                    icon : Icon(MaterialCommunityIcons.shape_square_plus),
                    color: Colors.lightBlueAccent,
                    tooltip: "复制函数",
                    iconSize: iconSize,
                    onPressed: (){

                      setState(() {
                        _selectedMethod = (si as BehavicAgentMethod).clone();
                        methodLst.add(_selectedMethod);
                        SSObjBase.refreshIndex(methodLst);
                        _selected.methods[_selectedMethod.guid] = _selectedMethod;
                        // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                        // forceBuildTree();
                      });

                    },
                  )
              ),
            ],
          ),
        );
      },
      onSelect: (v){
        setState(() {
          _selectedMethod = v;
        });
      },
      actions: [
        IconButton(
          padding: EdgeInsets.all(0),
          icon : Icon(MaterialCommunityIcons.plus_box_outline),
          color: Colors.blue,
          tooltip: "添加函数",
          iconSize: 32,
          onPressed: (){

            var newMethod = BehavicAgentMethod();
            methodLst.add(newMethod);
            SSObjBase.refreshIndex(methodLst);
            _selected.methods[newMethod.guid] = newMethod;
            // StateScriptProject.instance.save();
            setState(() {
              _selectedMethod = newMethod;
            });

          },
        ),
      ],
    );

    Widget prms ;
    if (_selectedMethod == null){
      var con2 = Container(
        child: Center(
          child: Text("上侧选择一个方法" , style: ThemeCenter.mainTextStyle(step: 4,fontSize: 32),),
        ),
      );

      prms = ThemeCenter.block (
        headTitle: "参数列表",
        // width: 480,
        child: con2,
      );
    }
    else{
      var prmLst =  _selectedMethod.params.values.toList();
      SSObjBase.sortByIndex(prmLst);
      prms = PopupTreeMenu(
        key:Key(_selectedMethod.guid),
        title: "函数参数列表",
        datas: prmLst,
        selectButton: false,
        onBuidItem: (si){
          // var txt = Text((si as BehavicAgentMethod).getTypeShowString() , style : TextStyle(color: Colors.greenAccent));
          return Container(
            height: 34,
            child:Row(
              // crossAxisAlignment : WrapCrossAlignment.center,
              children: [
                InkWell(
                  child: getFieldAttribute("引用" , si.isRef??false , Colors.redAccent),
                  onTap: (){
                    setState(() {
                      si.isRef = !(si.isRef??false);
                    });
                  },
                ),
                Container(width: 4,),
                ThemeCenter.roundRect(height : 32 , width: 320 , child: _getTypeWidgets(si) ,borderColor: Colors.yellow,  bgColor : CommonUtil.alphaColorD(Colors.yellow, 0.1), radius: 3),
                Container(width: 4,),
                Text("参数名" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
                Container(width: 4,),
                Container(
                    width: 200,
                    child:TextEditor(
                      initValue: si.name??"",
                      onChanged: (v){
                        si.name = v;
                      },
                    )
                ),
                Container(width: 4,),
                Text("别名" ,style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),),
                Container(width: 4,),
                Container(
                    width: 200,
                    child:TextEditor(
                      initValue: si.alias??"",
                      onChanged: (v){
                        si.alias = v;
                      },
                    )
                ),
                Container(width: 4,),
                TooltipHelper(
                  width: 28 , height : 28,
                  value: si.desc,//DartCommon.isEmpty(si.desc)?"没有注释":si.desc,

                  onSubmitted: (v){
                    si.desc = v;
                  },
                ),

                Container(width: 8,),
                (prmLst.length>=2 && si != prmLst[0])? ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_up_bold_box_outline , color: Colors.yellow,
                    width: 28 , height : 28,
                    tooltip: "上移",
                    onPressed: (){
                      setState(() {
                        var idx = prmLst.indexOf(si);
                        prmLst.remove(si);
                        prmLst.insert(idx-1, si);
                        SSObjBase.refreshIndex(prmLst);

                      });
                    }
                ):Container(width: 28,),
                if (prmLst.length>=2 && si != prmLst[prmLst.length-1]) ThemeCenter.iconBtn(MaterialCommunityIcons.arrow_down_bold_box_outline , color: Colors.yellow,
                    width: 28 , height : 28,
                    tooltip: "下移",
                    onPressed: (){
                      setState(() {
                        var idx = prmLst.indexOf(si);
                        prmLst.remove(si);
                        prmLst.insert(idx+1, si);
                        SSObjBase.refreshIndex(prmLst);
                      });
                    }
                ),
                // ThemeCenter.iconBtn(MaterialCommunityIcons.help_box , color: Colors.greenAccent,
                //   width: 28 , height : 28,
                //   tooltip: si.desc,
                //   onPressed: (){
                //
                //   }
                // ),
                // CheckboxWithTitle(
                //   title: "默认值",
                //   style: ThemeCenter.mainTextStyle(step: 3 , fontSize: 13),
                //   value: si.withReturn??false,
                //   onChanged: (v){
                //
                //     setState(() {
                //       si.withReturn = v;
                //     });
                //   },
                // ),
                Expanded(child : Container()),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.minus_box_outline),
                      tooltip: "删除参数",
                      color: Colors.redAccent,
                      iconSize: iconSize,
                      onPressed: (){
                        CommonUtil.confirm(context, "确定要删除吗?",onOk: (){
                          setState(() {
                            _selectedMethod.params.remove(si.guid);
                            // if (si == _selectedMethod) _selectedMethod = null;
                            // forceBuildTree();
                          });
                        });
                      },
                    )
                ),
                Container(
                    width: iconSize,
                    height: iconSize,
                    child:IconButton(
                      padding: EdgeInsets.all(0),
                      icon : Icon(MaterialCommunityIcons.shape_square_plus),
                      color: Colors.lightBlueAccent,
                      tooltip: "复制参数",
                      iconSize: iconSize,
                      onPressed: (){

                        setState(() {
                          var prm = si.clone();
                          prmLst.add(prm);
                          SSObjBase.refreshIndex(prmLst);
                          _selectedMethod.params[prm.guid] = prm;
                          // EventCenter.eventBus.fire(NodeTypeSelectionChangeEvent(_selected));
                          // forceBuildTree();
                        });

                      },
                    )
                ),
              ],
            ),
          );
        },
        actions: [
          IconButton(
            padding: EdgeInsets.all(0),
            icon : Icon(MaterialCommunityIcons.plus_box_outline),
            color: Colors.blue,
            tooltip: "添加参数",
            iconSize: 32,
            onPressed: (){

              var newPrm = FieldInfo();
              prmLst.add(newPrm);
              SSObjBase.refreshIndex(prmLst);
              _selectedMethod.params[newPrm.guid] = newPrm;
              // StateScriptProject.instance.save();
              setState(() {
                // _selectedMethod = newMethod;
              });

            },
          ),
        ],
      );
    }


    var block = Container(
      child: Column(
        children: [
          Expanded(child: con1),
          Expanded(child: prms),
        ],
      ),
    );
    return block;
  }


}