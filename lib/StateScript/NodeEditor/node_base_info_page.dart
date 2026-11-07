//@dart=2.11

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
// import 'package:markdown_widget/markdown_widget.dart';
import 'package:battlepus/StateScript/SSMainSetting.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSUserData.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/FSwitch.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/Tagger/TagSet.dart';
import 'package:battlepus/common/Tagger/tag_set_view.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/directory_picker.dart';
import 'package:battlepus/common/float_editor.dart';
import 'package:battlepus/common/line_container.dart';
import 'package:battlepus/common/line_field_container.dart';
import 'package:battlepus/common/markdown_editor.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:theme_provider/theme_provider.dart';
// import 'package:pluto_grid/pluto_grid.dart';

class NodeBaseInfoPage extends StatefulWidget {
  final NodeStructData nodeType;
  NodeBaseInfoPage({Key key,  this.nodeType}) : super(key: key);

  @override
  _NodeBaseInfoPageState createState() => _NodeBaseInfoPageState();
}

class _NodeBaseInfoPageState extends State<NodeBaseInfoPage> {
  TextEditingController _nameEditor ;
  TextEditingController _aliasEditor ;
  TextEditingController _groupEditor ;
  ScrollController controller;
  static int _clipColor = 0;
//  TextEditingController _ftpPortEditor ;
//  TextEditingController _ftpUserEditor ;
//  TextEditingController _ftpPassEditor ;
  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
    _nameEditor.dispose();
    _aliasEditor.dispose();
    _groupEditor.dispose();
//    _ftpPortEditor.dispose();
//    _ftpUserEditor.dispose();
//    _ftpPassEditor.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    controller = ScrollController();
    super.initState();

    _nameEditor = TextEditingController();
    _aliasEditor = TextEditingController();
    _groupEditor = TextEditingController();
//    _ftpPortEditor = TextEditingController();
//    _ftpUserEditor = TextEditingController();
//    _ftpPassEditor = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    _nameEditor.text = widget.nodeType.name;
    _aliasEditor.text = widget.nodeType.alias;
    _groupEditor.text = widget.nodeType.group;
    var baseNode = StateScriptProject.instance.structMap[widget.nodeType.baseType??""];
    var interval = const SizedBox(height: 8,);
    var intervalH = const SizedBox(width: 4,);
    if (widget.nodeType.tagSet == null){
      widget.nodeType.tagSet = new TagSet();
    }
    var rp = GlobalBoard.getCorrectDirectory(SSMainSetting.instance.workingPath);
    var baseCodePath = GlobalBoard.getCorrectDirectory(StateScriptProject.instance.csharpConfig.baseCodeExportPath , basePath: rp);
    var lst2 = ListView(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
      controller: controller,
        children: [
          Row(
            //第一行
            children: [
              Expanded(child : Text("GUID : ${widget.nodeType.guid} EID : ${widget.nodeType.exportId??"?"}" , style: TextStyle(color: Colors.white),)),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(MaterialCommunityIcons.content_copy),
                color: Colors.white,
                tooltip: "复制guid",
                iconSize: 24,
                onPressed: (){
                  Clipboard.setData(ClipboardData(text: '${widget.nodeType.guid}'));
                  BotToast.showText(text: "GUID 已拷贝");
                },
              ),
              SizedBox(width:10),

              Checkbox(
                activeColor: Colors.green,
                value: widget.nodeType.isSystemNode,
                onChanged: (v){
                  setState(() {
                    widget.nodeType.isSystemNode = v;
                  });
                },
              ),
              Text("系统" , style: TextStyle(color: Colors.greenAccent),),

              Checkbox(
                activeColor: Colors.green,
                value: widget.nodeType.isLogicNode,
                onChanged: (v){
                  setState(() {
                    widget.nodeType.isLogicNode = v;
                  });
                },
              ),
              Text("逻辑" , style: TextStyle(color: Colors.white),),

              Checkbox(
                activeColor: Colors.green,
                value: widget.nodeType.isViewNode,
                onChanged: (v){
                  setState(() {
                    widget.nodeType.isViewNode = v;
                  });
                },
              ),
              Text("显示" , style: TextStyle(color: Colors.white),),
              Container(
                width: 8,
              ),
            ],
          ),
          interval,
          Row(
            children: [
              Expanded(
                child: TextEditor(
                  initValue: widget.nodeType.group??"",
                  hint: "组名",
                  isDense: false,
                  contentPadding: null,
                  onChanged: (v){
                    setState(() {
                      widget.nodeType.group = v;
                      SSUserData.instance.nodeStructListExpandedFlags["/$v"] = true;
                      SSUserData.instance.save();

                      EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
                    });
                  },
                ),
              ),
              ThemeCenter.iconBtn(MaterialCommunityIcons.menu,width: 24,height: 24,
                  tooltip: "选择现有 group",
                  onPressed: (){
                    showDialog(

                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        var child =  Container(
                          width: 500,
                          height :600,
                          child: getGroupLisst(widget.nodeType.group),
                        );
                        return ThemeConsumer(child :Dialog(child: child));
                      },
                    );
                  }
              ),
              intervalH,
              intervalH,
              intervalH,
              Expanded(child:TextEditor(
                initValue: widget.nodeType.name??"",
                hint: "节点名",
                isDense: false,
                contentPadding: null,
                // controller: _nameEditor,
                // decoration: InputDecoration(
                //   labelText: "结点名",
                // ),

                onChanged: (v){
                  widget.nodeType.name = v;
                  EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
                },
                onSubmitted: (v) {
                  widget.nodeType.name = v;
                },
              )),
              intervalH,
              Expanded(child:TextEditor(
                // controller: _aliasEditor,
                // decoration: InputDecoration(
                //   labelText: "别名(优先显示)",
                // ),
                initValue: widget.nodeType.alias??"",
                hint: "别名(优先显示)",
                isDense: false,
                contentPadding: null,
                onChanged: (v){
                  widget.nodeType.alias = v;
                  EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
                },
                onSubmitted: (v) {
                  widget.nodeType.alias = v;
                  EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
                },
              )),


            ],
          ),
          interval,
          Row(
            children: [
              Expanded(child:DirectoryPicker(
                hint: "指定导出路径 gen",
                tooltip: "选择",
                withClear: true,
                iconSize: 32,
                initPath: DartCommon.isEmpty(widget.nodeType.forceExportGenPath)?StateScriptProject.instance.csharpConfig.defaultGenExportPath??"" : widget.nodeType.forceExportGenPath??"",
                basePath: baseCodePath,
                onChanged: (v) {
                  widget.nodeType.forceExportGenPath = v;
                },
              )),
              intervalH,
              Expanded(child:DirectoryPicker(
                hint: "指定导出路径 node",
                tooltip: "选择",
                withClear: true,
                iconSize: 32,
                initPath: DartCommon.isEmpty(widget.nodeType.forceExportNodePath)? StateScriptProject.instance.csharpConfig.defaultNodeExportPath??"" : widget.nodeType.forceExportNodePath??"",
                basePath: baseCodePath ,
                onChanged: (v) {
                  widget.nodeType.forceExportNodePath = v;  //存储的是相对于导出根目录的相对路径
                },
              )),
            ],
          ),
          interval,
          Row(
            children: [
              Expanded(child:LineContainer(
                hintStyle: TextStyle(color: Colors.grey ,fontSize: 13),
                height: 64,
                title: "父类",
                child: DragTarget<NodeStructData>(

                  builder: (p1,p2,p3){
                    var nt = StateScriptProject.instance.structMap[widget.nodeType.baseType??""];
                    var str = nt==null?"未选择":nt.getTypeShowString();

                    return Padding (
                      // width: 500,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                        child:Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            color: CommonUtil.alphaColor( Colors.indigo , 18),
                            child: Row(
                              children: [
                                Icon(MaterialCommunityIcons.drag_variant , color: CommonUtil.alphaColor( Colors.grey , 148),),
                                const SizedBox(width: 10,),
                                Text(str , style: TextStyle(color: Colors.lightBlueAccent , fontSize: 16 , fontWeight: FontWeight.w600),),
                                Expanded(child : Container(
                                  child :Text("    从左侧列表拖拽蓝色图标" ,style:TextStyle(color: CommonUtil.alphaColor( Colors.grey , 100))),
                                )),


                                nt != null?SizedBox(width:32 ,child:IconButton(padding : EdgeInsets.all(0), icon: Icon(MaterialCommunityIcons.close_box),iconSize: 32, color: Colors.red, tooltip:"移除父类",
                                  onPressed: (){
                                    setState(() {
                                      widget.nodeType.baseType = "";
                                    });
                                  },
                                )):Center(),
                              ],

                            )
                        )
                    );
                  },
                  onWillAccept: (e){return true;},
                  onAcceptWithDetails: (e){
                    if (widget.nodeType.guid == e.data.guid){
                      BotToast.showSimpleNotification(title: "不能将自己设为父类");
                      return;
                    }
                    setState(() {
                      widget.nodeType.baseType = e.data.guid;
                    });

                  },
                ),
              )),
              intervalH,
              Expanded(child:LineFieldContainer(
                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                height: 64,
                title: "背景颜色",
                withLine: true,
                child: Container(
                  // padding: EdgeInsets.fromLTRB(0,4,4,4),

                  child : Row(
                    children: [
                      Container(
                        height: 24,
                        width: 64,
                        color: Color(widget.nodeType.bgColor),
                      ),
                      IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon:Icon(MaterialCommunityIcons.format_color_fill),
                        color: Colors.lightBlueAccent,
                        iconSize: 32,
                        tooltip: "修改背景颜色",
                        onPressed: (){
                          setState(() {
                            // raise the [showDialog] widget
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: const Text('选择颜色!'),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: Color(widget.nodeType.bgColor),
                                      onColorChanged: (clr){
                                        widget.nodeType.bgColor = clr.value;
                                        EventCenter.eventBus.fire(GlobalRefreshEvent());
                                      },
                                      showLabel: true,
                                      pickerAreaHeightPercent: 0.8,
                                    ),

                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('确定'),
                                      onPressed: () {
                                        setState(() {

                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                          });
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon:Icon(Ionicons.ios_copy),
                        color: Colors.lightBlueAccent,
                        iconSize: 24,
                        tooltip: "复制颜色",
                        onPressed: (){

                          _clipColor = widget.nodeType.bgColor;
                          BotToast.showText(text: "颜色已复制",contentColor: Color(widget.nodeType.bgColor));
                        },
                      ),
                      IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon:Icon(FontAwesome.paste),
                        color: Colors.lightBlueAccent,
                        iconSize: 22,
                        tooltip: "粘贴颜色",
                        onPressed: (){
                          setState(() {
                            widget.nodeType.bgColor =_clipColor;
                          });

                        },
                      ),

                      if (!DartCommon.isEmpty(widget.nodeType.group))IconButton(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        icon:Icon(FontAwesome.paste),
                        color: Colors.redAccent,
                        iconSize: 22,
                        tooltip: "全组粘贴颜色",
                        onPressed: (){
                          setState(() {
                            var group = widget.nodeType.group;
                            StateScriptProject.instance.nodeStructs.forEach((element) {
                              if (group == element.group) {
                                element.bgColor = _clipColor;
                              }
                            });

                          });

                        },
                      ),
                      // Expanded(
                      // SizedBox(width: 100,),
                      // Text("宽度 "),
                      // Container(
                      //   width: 200,
                      //   child : FloatEditor(
                      //     initValue: widget.nodeType.width,
                      //     noUnderLine:true,
                      //     onChanged: (v){
                      //       widget.nodeType.width = v;
                      //     },
                      //   ),
                      // )
                    ],
                  ),
//                    child: Container(
//                      color: Color(widget.nodeType.bgColor),
//                      child:
//                    ),
                ),
              )),
              
              intervalH,

               Expanded(child: LineFieldContainer(
                hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                height: 64,
                title: "节点宽度",
                withLine: true,
                child:Container(
                  width: 200,
                  child: FloatEditor(
                    initValue:  widget.nodeType.width,
                    onChanged: null,
                    noUnderLine: true,
                    onSubmitted: (value){
                      setState(() {
                        if(value < 100 || value > 300) value = widget.nodeType.width;
                        widget.nodeType.width = value;
                      });
                    },
                ),
               )
        
              )),

            ],
          ),
          interval,
          Row(
            children: [
              Expanded(
                flex: 4,
                child: LineContainer(
                  title: "标签",
                  height: 64,
                  child: TagSetView(tagSet: widget.nodeType.tagSet , tagCamp: StateScriptProject.instance.tagCamp,
                    actions: [
                      ThemeCenter.iconBtn(MaterialCommunityIcons.ballot_outline,
                        width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"全组设置",
                        onPressed: (){
                          StateScriptProject.instance.nodeStructs.forEach((element) {
                            if (widget.nodeType != element && element.group == widget.nodeType.group){
                              element.tagSet = widget.nodeType.tagSet.clone();
                            }
                          });

                          BotToast.showText(text: "全组设置标签完成");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ),
          interval,
          Row(
            children: [
              Expanded(flex : 1 ,child :LineFieldContainer(
                hintStyle: TextStyle(color: Colors.grey),
                height: 64,
                title: "是否带 Update 逻辑",
                child: FSwitch(
                  width: 48,
                    open: widget.nodeType.getWithUpdateLogic() || widget.nodeType.getIsSyncNode(),
                    enable: baseNode == null && !widget.nodeType.getIsSyncNode(),
                    onChanged: (v){
                      setState(() {
                        widget.nodeType.withUpdateLogic = v;
                      });
                    }
                ),
              )),
              intervalH,
              Expanded(flex : 1 ,child :LineFieldContainer(
                hintStyle: TextStyle(color: Colors.grey),
                height: 64,
                title: "是否Debug节点",
                child: FSwitch(
                    width: 48,
                    open: widget.nodeType.isDebugNode??false,
                    enable: true,
                    onChanged: (v){
                      setState(() {
                        widget.nodeType.isDebugNode = v;
                      });
                    }
                ),
              )),
              intervalH,
              Expanded(flex : 1 ,child :LineFieldContainer(
                hintStyle: TextStyle(color: Colors.grey),
                height: 64,
                title: "是否带ViewNode",
                child: FSwitch(
                    width: 48,
                    open: widget.nodeType.withViewNode??false,
                    enable: true,
                    onChanged: (v){
                      setState(() {
                        widget.nodeType.withViewNode = v;
                      });
                    }
                ),
              )),
              // Expanded(flex : 1 ,child :LineFieldContainer(
              //   hintStyle: TextStyle(color: Colors.grey),
              //   height: 70,
              //   title: "是否导出动态数据",
              //   child: FSwitch(
              //       open: widget.nodeType.isExportDynamicData??false,
              //       enable: true,
              //       onChanged: (v){
              //         setState(() {
              //           widget.nodeType.isExportDynamicData = v;
              //         });
              //       }
              //   ),
              // )),
              intervalH,

            ],
          ),
          interval,
          interval,
          Material(child: MarkdownEditor(
            title: "结点介绍",
            height: 680,
            bgColor : CommonUtil.alphaColor(Colors.blueAccent , 12),
            data: widget.nodeType.description,
            onChanged: (v){
              widget.nodeType.description = v;
              print("change " +v);
            },
            onSubmitted: (v){
              widget.nodeType.description = v;
            },
          )),
        ]
    );
    // return lst2;
    return Scrollbar(
            controller: controller,
          thumbVisibility: true,
        // isAlwaysShown: true,
        // trackVisibility:true,
          child:lst2
        );
  }


  // ATreeNode<String> _nodeRoot2;
  ATreeNode<String> getNodeTreeRoot(){

    var nds = StateScriptProject.instance.nodeStructs;
    var scripts = List<String>();
    nds.forEach((element) {
      if (DartCommon.isEmpty( element.group)) return;
      if (!scripts.contains(element.group)){
        scripts.add(element.group);
      }
    });
    // print(scripts);
    var _nodeRoot2 = DartCommon.buildTree(scripts, (item){
        var sp = <String>[];// (item as NodeStructData).group.split("/");
        return sp;
      });


    return _nodeRoot2;
  }
  Widget getGroupLisst(String crt){
    var con = SearchableThemeTreeView(
      defaultExpanded: true,

      indent: 16,
      // itemBaseWidth: 200,
      // decoration: _onInScriptArea?dc:null,
      root:getNodeTreeRoot(),

      expandButtonColor: ThemeCenter.systemTheme.accentColor,
      onGetID: (node){
        return (node as ATreeNode<String>).id;
      },
      onGetChildren: (node){
        return (node as ATreeNode<String>).children;
      },

      dirBgColor: ThemeCenter.systemTheme.primaryColor,
      onBuildItem: (node,expanded, highlightPattern){
        var nd = node as ATreeNode<String>;
        if (nd.isLeaf){
          var si = nd.data;
          var txt = Text(si,style: ThemeCenter.mainTextStyle(step:9 ,fontSize: 12));
          var con = Container(
            // color: CommonUtil.alphaColorD(Colors.blue,0.4),
            padding: EdgeInsets.fromLTRB(8,0,8,0),
            height: 28,
            child: Row(
              children: [

                SizedBox(width: 4,),
                // Container(width: 12,height: 12, color: CommonUtil.scaleColor(Color((si as String).bgColor??0), 0.5),),
                SizedBox(width: 4,),
                Expanded(child : txt),

                // Tooltip(
                //   child: Icon(MaterialCommunityIcons.information ,color: Colors.green),
                //   message: "${si.description}",
                // )
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
            color : crt == si?Colors.blueAccent:null,
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
        var ns  = node as ATreeNode<String>;
        if (ns != null) {
          var n = ns.data;
          if (n == null) return "";
          return n;
        }
        return "";
      },

      onSortLeaf: (aNode,bNode){
        var a = (aNode as ATreeNode<String>).data;
        var b = (bNode as ATreeNode<String>).data;
        return a.compareTo(b);
      },

      onItemTap: (item){
        setState(() {
          Navigator.pop(context);
          widget.nodeType.group = (item as ATreeNode<String>).data;
          //
          // var si = (item as ATreeNode<NodeStructData>).data;
          // if (si != null) {
          //   var n = StateScriptNode();
          //
          //   // var off = ZoomState.calcLocalPosition(details.offset);// + Offset(BTDefines.nodeTypeWidth/2 , BTDefines.nodeTypeHeight/2));
          //   //
          //   //
          //   // off = ZoomState.fixPosition(off);
          //
          //   n.x = posX;
          //   n.y = posY;
          //   print("add node ${n.x} ${n.y}");
          //   n.nodeTypeGuid = (item as ATreeNode<NodeStructData>).data.guid;
          //   HistoryManager.scriptHistory.appendHistory();
          //   ScriptInfo.current.scriptData.addNode(n);
          //   EventCenter.eventBus.fire(GlobalRefreshEvent());
          //   setState(() {
          //     bShowList = false;
          //   });
          //   // setState(() {
          //   //
          //   //   // ScriptInfo.current.scriptData.addNode(n);
          //   // });
          // }
          // // forceBuildTree();
        });

      },

      actions: [
      ],
    );

    return con;
  }





}