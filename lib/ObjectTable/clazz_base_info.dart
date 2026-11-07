//@dart=2.11
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fswitch/fswitch.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/line_field_container.dart';
import 'package:battlepus/common/markdown_editor.dart';
 
class ClazzBaseInfo extends StatefulWidget {
  final ObjectClazz clazz;
  ClazzBaseInfo({Key key, this.clazz}) : super(
      key: key);

  @override
  _ClazzBaseInfoState createState() =>
      _ClazzBaseInfoState(
      );
}

class _ClazzBaseInfoState extends State<ClazzBaseInfo> {

  TextEditingController _nameEditor ;
  TextEditingController _aliasEditor ;
  TextEditingController _groupEditor ;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameEditor.dispose();
    _aliasEditor.dispose();
    _groupEditor.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameEditor = TextEditingController();
    _aliasEditor = TextEditingController();
    _groupEditor = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _nameEditor.text = widget.clazz.name;
    _aliasEditor.text = widget.clazz.alias;
    _groupEditor.text = widget.clazz.group;
//    var baseNode = ObjectTableProject.instance.clazzMap[widget.clazz.baseType??""];
    var interval = const SizedBox(height: 8,);

    var lst = ListView(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child:Column(
              children: [
                TextField(
                  controller: _nameEditor,
                  decoration: InputDecoration(
                    labelText: "类型(表)名",
                  ),
                  onChanged: (v){
                    widget.clazz.name = v;
                  },
                  onSubmitted: (v) {
                    widget.clazz.name = v;
                    EventCenter.eventBus.fire(ClazzChangeEvent(widget.clazz));
                  },
                ),
                interval,
                TextField(
                  controller: _aliasEditor,
                  decoration: InputDecoration(
                    labelText: "别名(优先显示)",
                  ),
                  onChanged: (v){
                    widget.clazz.alias = v;
                  },
                  onSubmitted: (v) {
                    widget.clazz.alias = v;
                    EventCenter.eventBus.fire(ClazzChangeEvent(widget.clazz));
                  },
                ),
                interval,
                // IntEditor(
                //   forceBuild: true,
                //   hint: "ID 起始",
                //   initValue: widget.clazz.idStart,
                //   onChanged: (v){
                //     widget.clazz.idStart = v;
                //   },
                //   onSubmitted: (v){
                //     widget.clazz.idStart = v;
                //   },
                // )

               LineFieldContainer(
                 height: 62,
                 title: "父类",
                 noExpanded: true,
                 child: DragTarget<ObjectClazz>(
                   builder: (p1,p2,p3){
                     var nt = ObjectTableProject.instance.clazzMap[widget.clazz.baseClazz??""];
                     var str = nt==null?"未选择":nt.getTypeShowString();
                     return Container (
                         padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                         child:Container(
                             padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                             color: CommonUtil.alphaColor( Colors.indigo , 18),
                             child: Row(
                               children: [
                                 Icon(MaterialCommunityIcons.drag_variant , color: CommonUtil.alphaColor( Colors.grey , 148),),
                                 const SizedBox(width: 10,),
                                 Text(str , style: TextStyle(color: Colors.blue , fontSize: 16 , fontWeight: FontWeight.w600),),
                                 Expanded(child:Container(
                                   // height: 68,
                                   child :Text("    从左侧列表拖拽蓝色图标" ,style:TextStyle(color: CommonUtil.alphaColor( Colors.grey , 148))),
                                 )),


                                 nt != null?IconButton(padding : EdgeInsets.all(0), icon: Icon(MaterialCommunityIcons.delete_forever),iconSize: 38, color: Colors.red, tooltip:"移除父类",
                                   onPressed: (){
                                     setState(() {
                                       widget.clazz.baseClazz = "";
                                     });
                                   },
                                 ):Center(),
                               ],

                             )
                         )
                     );
                   },
                   onWillAccept: (e){return true;},
                   onAcceptWithDetails: (e){
                     if (widget.clazz.guid == e.data.guid){
                       BotToast.showText(text:"不能将自己设为父类", contentColor: Colors.red);
                       return;
                     }
                     if (widget.clazz.isParentOf(e.data)){
                       BotToast.showText(text:"循环继承!", contentColor: Colors.red);
                       return;
                     }

                     setState(() {
                       widget.clazz.baseClazz = e.data.guid;
                     });

                   },
                 ),
               ),
              ],
            )),
            SizedBox(width: 8,),
            Expanded(flex: 1, child:Column(
              children: [
                TextField(
                  controller: _groupEditor,
                  decoration: InputDecoration(
                    labelText: "组名",
                  ),
                  onChanged: (v){
                    widget.clazz.group = v;
                  },
                  onSubmitted: (v) {
                    widget.clazz.group = v;
                    EventCenter.eventBus.fire(ClazzChangeEvent(widget.clazz));
                  },
                ),

                interval,
                Row(
                  children: [
                    Expanded(child: LineFieldContainer(
                      height: 57,
                      title: "背景颜色",
                      child: Container(
                        padding: EdgeInsets.all(4),

                        child : Row(
                          children: [
                            Container(
                              width: 64,
                              color: Color(widget.clazz.color),
                            ),
                            IconButton(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              icon:Icon(MaterialCommunityIcons.format_color_fill),
                              color: Colors.blueAccent,
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
                                            pickerColor: Color(widget.clazz.color),
                                            onColorChanged: (clr){
                                              widget.clazz.color = clr.value;
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
                          ],
                        ),
//                    child: Container(
//                      color: Color(widget.nodeType.bgColor),
//                      child:
//                    ),
                      ),
                    ),),
//                     Expanded(child: LineFieldContainer(
//                       height: 57,
//                       title: "宽度",
//                       // noExpanded: true,
//                       child: Container(
//                         padding: EdgeInsets.all(4),
//                         // child: IntEditor(
//                         //
//                         // ),
//                         child : IntEditor(
//                           initValue: 100,
//                         )
// //                    child: Container(
// //                      color: Color(widget.nodeType.bgColor),
// //                      child:
// //                    ),
//                       ),
//                     ),)
                  ],
                ),

                Row(
                  children: [
                    Expanded(flex : 2 ,child :LineFieldContainer(
                      height: 70,
                      title: "是否可以引用",
                      child: FSwitch(
                          open: widget.clazz.refable??true,
                          enable: true,//baseNode == null || !baseNode.getSyncTransformNode(),
                          onChanged: (v){
                            setState(() {
                              widget.clazz.refable = v;
                            });
                          }
                      ),
                    )),
                    if (ObjectTableProject.withPlugins()) Expanded(flex : 2 ,child :LineFieldContainer(
                      height: 70,
                      title: "导出二进制",
                      child: FSwitch(
                          open: widget.clazz.forceExportBinary??false,
                          enable: true,//baseNode == null || !baseNode.getSyncTransformNode(),
                          onChanged: (v){
                            setState(() {
                              widget.clazz.forceExportBinary = v;
                            });
                          }
                      ),
                    )),
                    if (ObjectTableProject.withPlugins()) Expanded(flex : 3 ,child :LineFieldContainer(
                      height: 70,
                      title: "创建内部对象映射",
                      child: FSwitch(
                          open: widget.clazz.buildSpaceMap??false,
                          enable: true,//baseNode == null || !baseNode.getSyncTransformNode(),
                          onChanged: (v){
                            setState(() {
                              widget.clazz.buildSpaceMap = v;
                            });
                          }
                      ),
                    )),
                    Expanded(flex : 3 ,child :LineFieldContainer(
                      height: 70,
                      title: "是否展示在引导条",
                      child: FSwitch(
                          open: widget.clazz.showOnNavigatorBar??false,
                          enable: true,//baseNode == null || !baseNode.getSyncTransformNode(),
                          onChanged: (v){
                            setState(() {
                              widget.clazz.showOnNavigatorBar = v;
                            });
                          }
                      ),
                    )),

                    Expanded(flex : 2 ,child :LineFieldContainer(
                      height: 70,
                      title: "默认打开",
                      child: FSwitch(
                          open: widget.clazz.isDefaultClazz??false,
                          enable: true,//baseNode == null || !baseNode.getSyncTransformNode(),
                          onChanged: (v){
                            setState(() {
                              ObjectTableProject.instance.clazzes.forEach((element) {
                                element.isDefaultClazz = false;
                              });
                              widget.clazz.isDefaultClazz = v;
                            });
                          }
                      ),
                    )),

                    // Expanded(flex : 1 ,child :LineFieldContainer(
                    //   height: 70,
                    //   title: "是否可以引用",
                    //   child: FSwitch(
                    //       open: widget.clazz.refable,
                    //       enable: true,//baseNode == null || !baseNode.getSyncTransformNode(),
                    //       onChanged: (v){
                    //         setState(() {
                    //           widget.clazz.refable = v;
                    //         });
                    //       }
                    //   ),
                    // )),
                  ],
                ),
//                interval,
//                LineFieldContainer(
//                  height: 70,
//                  title: "是否带 Update 逻辑",
//                  child: FSwitch(
//                      open: widget.nodeType.getWithUpdateLogic() || widget.nodeType.getIsSyncNode(),
//                      enable: baseNode == null && !widget.nodeType.getIsSyncNode(),
//                      onChanged: (v){
//                        setState(() {
//                          widget.nodeType.withUpdateLogic = v;
//                        });
//                      }
//                  ),
//                ),
              ],
            )),
          ],
        ),
//        TextField(
//          controller: _nameEditor,
//          decoration: InputDecoration(
//            labelText: "结点名",
//          ),
//          onChanged: (v){
//            widget.nodeType.name = v;
//          },
//          onSubmitted: (v) {
//            widget.nodeType.name = v;
//            EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
//          },
//        ),
//        interval,
//        TextField(
//          controller: _aliasEditor,
//          decoration: InputDecoration(
//            labelText: "别名(优先显示)",
//          ),
//          onChanged: (v){
//            widget.nodeType.alias = v;
//          },
//          onSubmitted: (v) {
//            widget.nodeType.alias = v;
//            EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
//          },
//        ),
//        interval,
//        TextField(
//          controller: _groupEditor,
//          decoration: InputDecoration(
//            labelText: "组名",
//          ),
//          onChanged: (v){
//            widget.nodeType.group = v;
//          },
//          onSubmitted: (v) {
//            widget.nodeType.group = v;
//            EventCenter.eventBus.fire(NodeTypeChangeEvent(widget.nodeType));
//          },
//        ),
//        interval,
//        LineFieldContainer(
//          height: 70,
//          title: "父类",
//          child: DragTarget<NodeStructData>(
//            builder: (p1,p2,p3){
//              var nt = StateScriptProject.instance.structMap[widget.nodeType.baseType??""];
//              var str = nt==null?"未选择":nt.getTypeShowString();
//              return Container (
//                padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
//                child:Container(
//                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
//                  color: CommonUtil.alphaColor( Colors.indigo , 18),
//                  child: Row(
//                    children: [
//                      Icon(MaterialCommunityIcons.drag_variant , color: CommonUtil.alphaColor( Colors.grey , 148),),
//                      const SizedBox(width: 10,),
//                      Text(str , style: TextStyle(color: Colors.indigo , fontSize: 16 , fontWeight: FontWeight.w600),),
//                      Expanded(child : Container(
//                        child :Text("    从左侧列表拖拽蓝色图标" ,style:TextStyle(color: CommonUtil.alphaColor( Colors.grey , 100))),
//                      )),
//
//
//                      nt != null?IconButton(padding : EdgeInsets.all(0), icon: Icon(MaterialCommunityIcons.delete_forever),iconSize: 38, color: Colors.red, tooltip:"移除父类",
//                        onPressed: (){
//                          setState(() {
//                            widget.nodeType.baseType = "";
//                          });
//                        },
//                      ):Center(),
//                    ],
//
//                  )
//                )
//              );
//            },
//            onWillAccept: (e){return true;},
//            onAcceptWithDetails: (e){
//              if (widget.nodeType.guid == e.data.guid){
//                BotToast.showSimpleNotification(title: "不能将自己设为父类");
//                return;
//              }
//              setState(() {
//                widget.nodeType.baseType = e.data.guid;
//              });
//
//            },
//          ),
//        ),
//        interval,
//        LineFieldContainer(
//          height: 70,
//          title: "是否带 Update 逻辑",
//          child: FSwitch(
//            open: widget.nodeType.getWithUpdateLogic() || widget.nodeType.getIsSyncNode(),
//              enable: baseNode == null && !widget.nodeType.getIsSyncNode(),
//              onChanged: (v){
//              setState(() {
//                widget.nodeType.withUpdateLogic = v;
//              });
//              }
//          ),
//        ),
        interval,
        MarkdownEditor(
          title: "表介绍",
          height: 680,
          bgColor : CommonUtil.alphaColor(Colors.blueAccent , 12),
          data: widget.clazz.description,
          onChanged: (v){
            widget.clazz.description = v;
            print("change " +v);
          },
          onSubmitted: (v){
            widget.clazz.description = v;
          },
        ),

      ],
    );

    return Container(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Scrollbar(
          child:lst
      ),
    ) ;
  }

}