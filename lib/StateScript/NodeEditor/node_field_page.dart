//@dart=2.11
import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/NodeEditor/a_field_type_selector.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/FieldValueHolder.dart';
import 'package:battlepus/StateScript/Struct/NodeStructData.dart';
import 'package:battlepus/StateScript/Struct/SSEnumType.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/StateScript/Struct/StateScriptProject.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/int_array_editor.dart';
import 'package:battlepus/common/int_editor.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/monitor.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/tree_selector.dart';

import '../FieldVisibleController.dart';

class NodeFieldPage extends StatefulWidget { 
  final NodeStructData nodeType;
  final double fullSize;
  NodeFieldPage({Key key,  this.nodeType , this.fullSize}) : super(key: key);

  @override
  _NodeFieldPageState createState() => _NodeFieldPageState();
}

class _NodeFieldPageState extends State<NodeFieldPage> {

  List<ListTableColumn> columns;

  FieldInfo focusItem;
  void initColumns(){
    columns = new List<ListTableColumn>();

    // {
    //   var c3 = ListTableColumn();
    //   c3.name = "Unity同步";
    //   c3.isFreeze = true;
    //   c3.width = 80.0;
    //   c3.widgetBuilder = (context , index) {
    //     var items = widget.nodeType.fields;
    //     var res = new ItemHolder();
    //     res.widget = Checkbox(
    //       value: items[index].isSyncField??false,
    //       onChanged: (v){
    //         setState(() {
    //           items[index].isSyncField = v;
    //         });
    //       },
    //     );//_getTypeWidgets(items[index]);
    //     return res;
    //   };
    //   c3.headAlignment = Alignment.centerLeft;
    //   c3.headerBuilder = (context) {
    //     var s = SizedBox(width: 8,);
    //     var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
    //     return Row(children: [s,t],);
    //   };
    //   columns.add(c3);
    // }
    var c3 = ListTableColumn();
    c3.name = "属性类型";
    c3.isFreeze = true;
    c3.width = 400.0;
    c3.widgetBuilder = (context , index) {
      var items = widget.nodeType.fields;
      var res = new ItemHolder();
      res.widget = _getTypeWidgets(items[index]);
      return res;
    };
    c3.headAlignment = Alignment.centerLeft;
    c3.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c3);

    ///
    var c = ListTableColumn();
    c.name = "属性名";

    c.width = 180.0;
    c.widgetBuilder = (context , index) {
      var items = widget.nodeType.fields;
      var res = new ItemHolder();
      res.widget = _getNameWidget(items[index]);
      return res;
    };

    c.headAlignment = Alignment.centerLeft;
    c.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c);

    ///
    var c1 = ListTableColumn();
    c1.name = "别名(优先显示)";

    c1.width = 180.0;
    c1.widgetBuilder = (context , index) {
      var items = widget.nodeType.fields;
      var res = new ItemHolder();
      res.widget = _getAliasWidget(items[index]);
      return res;
    };
    c1.headAlignment = Alignment.centerLeft;
    c1.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c1);
    {
      var c1 = ListTableColumn();
      c1.name = "行数";

      c1.width = 60.0;
      c1.widgetBuilder = (context , index) {
        var items = widget.nodeType.fields;
        var bIsEdit = true;//focusItem == items[index];
        var res = new ItemHolder();
        var edt = bIsEdit?IntEditor(
          initValue: items[index].lineCount,
          onChanged: (v){
            items[index].lineCount = v;
          },
          onSubmitted: (v){
            setState(() {
              items[index].lineCount = v;
            });
          },
        ):Center(child:Text("${items[index].lineCount}"));

        res.widget = Container(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child : edt,
        );
        return res;
      };
      c1.headAlignment = Alignment.centerLeft;
      c1.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c1);
    }

    var c4 = ListTableColumn();
    c4.name = "默认值";

    c4.width = 160.0;
    c4.widgetBuilder = (context , index) {

      var items = widget.nodeType.fields;
      var res = new ItemHolder();
      var item = items[index];
      var fi = SSFieldType.getFieldType(item.typeGuid ,fieldInfo: item);
      if (fi == null){
        res.widget = Container(child: const Text("无效类型"),);
        return res;
      }

      if ((fi.flag & SSFieldType.FIELD_FLAG_CONTAINER) >0){
        res.widget = Container(child: const Text("默认容器"),);
        return res;
      }
      if ((fi.flag & SSFieldType.FIELD_NO_DEFAULT) >0){
        res.widget = Container(child: const Text("无"),);
        return res;
      }


      var bIsEdit = true;//focusItem == item;
      // var edt = fi.getDefaultEditWidget(bIsEdit,
      //   item.defaultValue,
      //   (v){
      //     item.defaultValue = v;
      //   },(v){
      //     setState(() {
      //       item.defaultValue = v;
      //     });
      //
      //   },
      //   context: context
      // );

      // var edt = Container();
      if ((fi.flag & SSFieldType.FIELD_FLAG_REF) >0){
        res.widget = Container(child: const Text("默认空对象"),);
        return res;
      }

      var edt = fi.getEditWidget(
          item.defaultValue,
          (v){
            var oriValue = item.defaultValue;
              try
              {
                setState(() {
                  // print("set $v");
                  item.defaultValue = v;
                });
              }
              catch(e)
              {
                  item.defaultValue  = oriValue;
              }
          },
            (v){
                setState(() {
                  // print("set $v");
                  item.defaultValue = v;
                });
          },
          context: context
      ).widget;
      // var edt = fi.getGridCellEditor(
      //     initValue:item.defaultValue,
      //     onSubmitted:    (v){
      //       setState(() {
      //         // print("set $v");
      //         item.defaultValue = v;
      //       });
      //     }
      // ).widget;

      res.widget = Container(
        // color: Colors.redAccent,
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child : edt,
      );
      return res;
    };
    c4.headAlignment = Alignment.centerLeft;
    c4.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c4.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c4);
    {
      var c2 = ListTableColumn();
      c2.name = "额外参数";

      c2.width = 230.0;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        res.widget = _getExtraParamWidgets(index);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }

    // columns.add(c4);


    {
      var c2 = ListTableColumn();
      c2.name = "操作";

      c2.width = 100.0;
      c2.widgetBuilder = (context, index) {
        var res = new ItemHolder();
        res.widget = _getActionWidgets(index);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ThemeCenter.mainTextStepColor(5)), textAlign: TextAlign.left,);
        return Row(children: [s, t],);
      };
      columns.add(c2);
    }
    {
      var c2 = ListTableColumn();
      c2.name = "锁定";

      c2.width = 80.0;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        var items = widget.nodeType.fields;
        res.widget = _getLockFlag(items[index]);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }

    {
      var c2= ListTableColumn();
      c2.name = "高亮编辑";
      c2.width = 80;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        var items = widget.nodeType.fields;
        res.widget = _getHighlightFlag(items[index]);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }

    if (!StateScriptProject.instance.useLuaForFieldVisible) {
      var c2 = ListTableColumn();
      c2.name = "字段分类";

      c2.width = 80.0;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        var items = widget.nodeType.fields;
        res.widget = _getIsFieldGroupFlag(items[index]);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }
    {
      var c2 = ListTableColumn();
      c2.name = "自动填充";

      c2.width = 80.0;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        var items = widget.nodeType.fields;
        res.widget = _getIsAutoFillFlag(items[index]);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }

    {
      var c2 = ListTableColumn();
      c2.name = "资源列表";

      c2.width = 200.0;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        var items = widget.nodeType.fields;
        res.widget = _getResourceList(items[index]);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }

    if (!StateScriptProject.instance.useLuaForFieldVisible) {
      var c2 = ListTableColumn();
      c2.name = "字段分类IDs";

      c2.width = 180.0;
      c2.widgetBuilder = (context , index) {

        var res = new ItemHolder();
        var items = widget.nodeType.fields;
        res.widget = _getIsFieldGroupIds(items[index]);
        return res;
      };
      c2.headAlignment = Alignment.centerLeft;
      c2.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c2);
    }


  }

  Widget _getActionWidgets(int index) {
    var items = widget.nodeType.fields;
    var upCmd = IconButton(icon: Icon(MaterialCommunityIcons.close_box_outline),iconSize: 24, color: Colors.redAccent, tooltip:"刪除",
      onPressed: (){
        setState(() {
          var item = items[index];
          widget.nodeType.removeField(item);
          // if (widget.nodeType.containTag(item.guid)){
          //   widget.nodeType.reorderTags();
          // }
          // item = null;
          // widget.nodeType.rebuildAllFields();

        });
      },
    );
    var up = Container(
        width: 24,
//      height: 32,
        child: upCmd
    );
    var dowmCmd = IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 24, color: Colors.green, tooltip:"添加新字段",
      onPressed: (){
        setState(() {
          setState(() {
            var item = widget.nodeType.addField();
            items.remove(item);
            items.insert(index+1, item);
            // if (widget.clazz.containTag(item.guid)){
            //   widget.clazz.reorderTags();
            // }
            // widget.clazz.rebuildAllFields();
          });

        });
      },
    );
    var down = Container(
        width: 24,
//      height: 32,
        child: dowmCmd
    );

    var dup = IconButton(icon: Icon(MaterialCommunityIcons.content_copy),iconSize: 24, color: Colors.green, tooltip:"复制字段",
      onPressed: (){
        setState(() {
          setState(() {
            //var item = widget.nodeType.addField();
            var curItme = items[index];
            var item = curItme.clone();
            item.name = curItme.name+"_1";
            if(!DartCommon.isEmpty(item.alias)){
              item.alias  = "";
            }
            items.remove(item);
            items.insert(index+1, item);
            // if (widget.clazz.containTag(item.guid)){
            //   widget.clazz.reorderTags();
            // }
            // widget.clazz.rebuildAllFields();
          });

        });
      },
    );
    return Container(
      child: Row(
        children: [
          up,
          down,
          dup,
        ],
      ),
    );
  }
  StreamSubscription<NodeTypeSelectionChangeEvent> _lis;
  @override
  void dispose() {
    SSDefines.isNodeRef = false;
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  @override
  void initState() {
    SSDefines.isNodeRef = true;
    // TODO: implement initState
    super.initState();
    focusItem = null;
    initColumns();

    _lis = EventCenter.eventBus.on<NodeTypeSelectionChangeEvent>().listen((event) {
      setState(() {
        focusItem = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var items = widget.nodeType.fields;
    var lst = ListTable(
      onReorder: (oldIdx , newIdx){
        setState(() {
          var vvv = items.removeAt(oldIdx);
          items.insert(newIdx, vvv);
        });
      },
      seperateFrame: true,
      forceWidth: widget.fullSize-2,
      scrollableBar: true,
      columns:columns,
      itemCount: items.length,
      itemHeight: 42,
      useCard: false,
      onRowInfo: (idx){
        var info = RowInfoHolder();
        info.forceColor = focusItem == items[idx];
        info.bgColor = Color(0x220000dF);
        return info;
      },
    );

    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child :lst),
          SizedBox(height: 4,),
          Row(
            children: [
              ElevatedButton(
                child: Text("添加字段"),
                onPressed: (){
                  setState(() {
                    var item = widget.nodeType.addField();
                    // if (widget.nodeType.containTag(item.guid)){
                    //   widget.nodeType.reorderTags();
                    // }
                    // widget.nodeType.rebuildAllFields();
                  });
                },
              ),

               SizedBox(width:10),
              ElevatedButton(
                child: Text("同步到引用脚本"),
                onPressed: (){
                  setState(() {
                    var scripts = StateScriptProject.instance.scripts;
                      for(var s in scripts){
                        bool needSave = false;
                        var nodes = s.scriptData.nodes;
                  
                        for (var node in nodes) {
                          if(node.nodeTypeGuid == widget.nodeType.guid){

                          //判定增加字段
                            for(var f in widget.nodeType.fields){  //遍历nodetype的字段
                                var ft = SSFieldType.getFieldType(f.typeGuid , fieldInfo: f);
                                var fguid = f.guid;
                                var crtVal = node.fieldValues[fguid];
                                
                                if(crtVal == null){
                                  needSave = true;
                                  var fvh = FieldValueHolder();
                                  fvh.name = f.getTypeShowString();
                                  fvh.value = ft.parseValue(f.defaultValue);
                                  node.fieldValues[fguid] = fvh;
                                }
                            }
                           

                          //判定删除字段
                            List<String> removeGuid = [];
                            node.fieldValues.forEach((key, value) {
                              bool find = false;
                              var fguid = key;
                              var nodeTypeFields = widget.nodeType.fields;

                              for (var element in nodeTypeFields) {
                                if(element.guid == fguid){
                                    find = true;
                                    break;
                                }    
                              }
                              if(!find){
                               needSave = true;
                                removeGuid.add(fguid);
                              }
                            });
                            for (var guid in removeGuid) {
                              node.fieldValues.remove(guid);
                            }

                          }               
                        }
                        if(needSave)
                          s.saveScript();
                      }

                      BotToast.showText(text: "保存完毕");
                  });
                },
              ),

              Expanded(child: const SizedBox(width: 1,)),
              if (StateScriptProject.instance.useLuaForFieldVisible) ElevatedButton(
                child: Text("编辑字段显隐逻辑"),
                onPressed: (){
                  setState(() {
                    var path = FieldVisibleController.instance.getOrCreateCodePath(widget.nodeType.guid , name : widget.nodeType.name, description: widget.nodeType.description);
                    Process.start(path, [], runInShell: true);
                  });

                },
              ),
              if (StateScriptProject.instance.useLuaForFieldVisible && FieldVisibleController.instance.isCodeForNodeTypeExists(widget.nodeType.guid, name : widget.nodeType.name, description: widget.nodeType.description)) const SizedBox(width: 4,),
              if (StateScriptProject.instance.useLuaForFieldVisible && FieldVisibleController.instance.isCodeForNodeTypeExists(widget.nodeType.guid, name : widget.nodeType.name, description: widget.nodeType.description)) ElevatedButton(
                child: Text("移除"),
                onPressed: (){
                  setState(() {
                    FieldVisibleController.instance.removeCodeForNodeType(widget.nodeType.guid, name : widget.nodeType.name, description: widget.nodeType.description);
                    BotToast.showText(text: "移除完毕！",contentColor: Colors.green);
                  });

                },
              ),
              if (StateScriptProject.instance.useLuaForFieldVisible && FieldVisibleController.instance.isCodeForNodeTypeExists(widget.nodeType.guid, name : widget.nodeType.name, description: widget.nodeType.description)) const SizedBox(width: 4,),
              if (StateScriptProject.instance.useLuaForFieldVisible && FieldVisibleController.instance.isCodeForNodeTypeExists(widget.nodeType.guid, name : widget.nodeType.name, description: widget.nodeType.description)) ElevatedButton(
                child: Text("刷新"),
                onPressed: (){
                  FieldVisibleController.instance.loadCodeForNodeType(widget.nodeType.guid, name : widget.nodeType.name, description: widget.nodeType.description);
                  BotToast.showText(text: "刷新完毕！",contentColor: Colors.green);
                },
              ),
            ],
          ),

        ],
      ),
    );

//     var items = widget.nodeType.fields;
//     var lst = ListTable(
//       forceWidth: widget.fullSize,
//       columns:columns,
//       itemCount: items.length,
//       itemHeight: 48,
//       useCard: false,
//       onTap: (idx){
//         setState(() {
//           if(focusItem != items[idx]) {
//             focusItem = items[idx];
//           }
//         });
//       },
//       onRowInfo: (idx){
//         var info = RowInfoHolder();
//         info.forceColor = focusItem == items[idx];
//         info.bgColor = Color(0x220000dF);
//         return info;
//       },
//     );
//
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(height: 6,),
//           Container(
//             height: 52,
// //            color: CommonUtil.alphaColor(Colors.indigo, 24),
//             child :Row(
//               children: [
//                 IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 40, color: ThemeCenter.mainTextStepColor(8), tooltip:"添加新字段",
//                   onPressed: (){
//                     setState(() {
//                       focusItem = widget.nodeType.addField();
//                     });
//                   },
//                 ),
//                 if (focusItem != null)IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 40, color: Colors.redAccent, tooltip:"删除",
//                   onPressed: (){
//                     setState(() {
//                       widget.nodeType.removeField(focusItem);
//                       focusItem = null;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 4,),
//           Expanded(child :lst),
// //          lst,
// //          SizedBox(height: 4,),
//
//           SizedBox(height: 4,),
//         ],
//       ),
//     );
  }

  Widget _getNameWidget(FieldInfo item) {

    var str = item.name;
    if (str == null || str.isEmpty) str = "请输入名字";
    var bIsEdit = true;//focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.name??"",
          onChanged : (v){
            item.name = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(str);
  }

  Widget _getAliasWidget(FieldInfo item) {

    var bIsEdit = true ;//focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.alias??"",
          onChanged : (v){
            item.alias = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.alias);
  }
  Widget _getExtraParamWidgets(int index) {
    var items = widget.nodeType.fields;
    var fi = items[index];
    var fitp = fi.typeGuid;
    print("fitp : $fitp" );
    if (fitp == "___list___"){
      // var extra = fi?.extraParam;
      // if (DartCommon.isEmpty(extra)){
      //   extra = "0,0";
      // }
      // var vals = extra.split(",");
      var dop = fi.withDynamicOutPort();
      var dip = fi.withDynamicInParam();
      return Row(
        children: [
          SizedBox(
            width: 18,
            child: Tooltip(
              child: Icon(MaterialCommunityIcons.alpha_o_box ,color: Colors.redAccent,),
              message: "动态出口",
            ),
          ),


          Checkbox(
            value: dop,
            activeColor: Colors.green,
            onChanged: (v){
              setState(() {
                fi.setDynamicTrigger(v, dip);
                // items[index].extraParam = "${v?1:0},${dip?1:0}";
              });

            },
          ),
          // Icon(MaterialCommunityIcons.comma,size: 8,),
          // SizedBox(
          //   width: 18,
          //   child: Tooltip(
          //     child: Icon(MaterialCommunityIcons.alpha_o_box),
          //     message: "动态出口",
          //   ),
          // ),
          SizedBox(
            width: 18,
            child: Tooltip(
              child: Icon(MaterialCommunityIcons.alpha_p_box,color: Colors.greenAccent,),
              message: "动态参数入口",
            ),
          ),
          // Icon(MaterialCommunityIcons.access_point),
          Checkbox(
            value: dip,
            activeColor: Colors.green,
            onChanged: (v){
              setState(() {
                // items[index].extraParam = "${dop?1:0},${v?1:0}";
                fi.setDynamicTrigger(dop, v);
              });
            },
          ),
          if (dip)Expanded(child:TextEditor(
            initValue:items[index].extraParam ,
            onChanged: (v){
              items[index].extraParam = v ;
            },
          ))
        ],
      );
    }
    return Container(
      child: Row(
        children: [
          Expanded(child:TextEditor(
            initValue:items[index].extraParam ,
            onChanged: (v){
              items[index].extraParam = v ;
            },
          ))
        ],
      ),
    );
  }

  Widget _getIsFieldGroupFlag(FieldInfo item) {
    var ft = SSFieldType.getFieldType(item.typeGuid , fieldInfo: item);
    if (ft == null || !(ft is SSEnumType)){
      return Container();
    }
    return Container(
      child: Checkbox(
        value: item.isFieldGroup??false,
        activeColor: Colors.green,
        onChanged: (v){
          setState(() {
            item.isFieldGroup = v;
          });

        },
      ),
    );
  }

  Widget _getIsAutoFillFlag(FieldInfo item) {
    var ft = SSFieldType.getFieldType(item.typeGuid , fieldInfo: item);
    // if (ft == null || !(ft is SSEnumType)){
    //   return Container();
    // }
    return Container(
      child: Checkbox(
        value: item.autoFillTrigger??false,
        activeColor: Colors.green,
        onChanged: (v){
          setState(() {
            item.autoFillTrigger = v;
          });

        },
      ),
    );
  }

  Widget _getLockFlag(FieldInfo item) {
    var ft = SSFieldType.getFieldType(item.typeGuid , fieldInfo: item);
    if (ft == null){
      return Container();
    }
    return Container(
      child: Checkbox(
        value: item.disabled??false,
        activeColor: Colors.redAccent,
        onChanged: (v){
          setState(() {
            item.disabled = v;
          });
        },
      ),
    );
  }


  Widget _getHighlightFlag(FieldInfo item)
  {
    var ft = SSFieldType.getFieldType(item.typeGuid , fieldInfo: item);
    if (ft == null){
      return Container();
    }
    return Container(
      child: Checkbox(
        value: item.highlightEdit??false,
        activeColor: Colors.redAccent,
        onChanged: (v){
          setState(() {
            item.highlightEdit = v;
          });
        },
      ),
    );
  }

  Widget _getIsFieldGroupIds(FieldInfo item) {
    // var ft = SSFieldType.getFieldType(item.typeGuid , fieldInfo: item);
    // if (ft == null || !(ft is SSEnumType)){
    //   return Container();
    // }
    return Container(
      child: IntArrayEditor(
        values: item.groupIds??[],
        onChanged: (v){
          item.groupIds = v;
          if (item.groupIds == null || item.groupIds.length<=0){
            item.groupIds = null;
          }
        },
        onSubmitted: (v){
          item.groupIds = v;
          if (item.groupIds == null || item.groupIds.length<=0){
            item.groupIds = null;
          }
        },
      )
    );
  }

//   Widget _getActionWidgets(int index) {
//     var items = widget.nodeType.fields;
//     var upCmd = IconButton(icon: Icon(MaterialCommunityIcons.arrow_up_bold_box_outline),iconSize: 30, color: Colors.indigo, tooltip:"上移",
//       onPressed: (){
//         setState(() {
//           var item = items[index];
//           items.remove(item);
//           items.insert(index-1, item);
//           focusItem = item;
//         });
//       },
//     );
//     var up = Container(
//       width: 32,
// //      height: 32,
//       child: index>0?upCmd:Container(),
//     );
//     var dowmCmd = IconButton(icon: Icon(MaterialCommunityIcons.arrow_down_bold_box_outline),iconSize: 30, color: Colors.indigo, tooltip:"上移",
//       onPressed: (){
//         setState(() {
//           var item = items[index];
//           items.remove(item);
//           items.insert(index+1, item);
//           focusItem = item;
//         });
//       },
//     );
//     var down = Container(
//       width: 32,
// //      height: 32,
//       child: index<items.length-1?dowmCmd:Container(),
//     );
//     return Container(
//       child: Row(
//         children: [
//           up,
//           down,
//         ],
//       ),
//     );
//   }

  Widget _getTypeWidgets(FieldInfo item) {
    var bIsEdit = true;//focusItem == item;
    var fi = SSFieldType.getFieldType(item.typeGuid,fieldInfo: item);
    if (fi == null){
      return Container();
    }
//    if (fi == null) fi =
    if (bIsEdit){
      var lst = SSFieldType.getTypeMap(excludeFlag: SSFieldType.FIELD_FLAG_NO_NODE_FIELD);
      lst.sort((a,b)=>a.priority-b.priority);


      // List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
      // for(var i in lst){
      //   var item = PopupMenuItem<String>(
      //     value: i.guid,
      //     child: i.getTypeShowWidget(),
      //   );
      //   items.add(item);
      // }
      //
      // var res = PopupMenuButton<String>(
      //   initialValue:item.typeGuid,
      //
      //   onSelected: (String result) { setState(() { item.typeGuid = result; }); },
      //   itemBuilder: (BuildContext context) => items,
      // );

      var res = AFieldTypeSelector(
        types: lst,
        initialValue: item.typeGuid,
        // field: focusItem,
        onChanged: (v){
          setState(() { item.typeGuid = v; });
        },
      );
      return Container(
        padding: EdgeInsets.all(4),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Expanded(child:Container(
              alignment: Alignment.center,
//              width: 200,
              child: fi.getTypeShowWidget( fieldType: SSFieldType.getFieldType(item.typeGuid , fieldInfo: item), onChange: (v){
                setState(() {
                  item.copyTypes(v);
                });
              }),
            )),
            Container(
              width: 40,
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

  Widget _getResourceList(FieldInfo item) {

    return Monitor(
      value: item.resourceListGuid,
      builder: (state , context){
        var guid = item.resourceListGuid??"";
        var resourceList = StateScriptProject.instance.resourceLists[guid];
        var res = TreeSelector(
          datas: StateScriptProject.instance.resourceLists.values.toList(),
          onCheckSelected: (v){
            return v == resourceList;
          },
          onItemBuilder: (item){
            return Text(item.name);
          },
          onGetFilter: (item){
            return "${item.name}";
          },
          // field: focusItem,
          onChanged: (v){
            item.resourceListGuid = v.guid;
            state.setValue(v.guid);
          },
          onClear: (){
            item.resourceListGuid = "";
            state.setValue("");
          },
        );
        return Container(
            padding: EdgeInsets.all(4),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Expanded(
                    child:Text(resourceList?.name??""),
                  ),
                  Container(
                    width: 40,
                    child: res,
                  ),
//            res,
                ]
            )

        );
      },
    );

  }
}