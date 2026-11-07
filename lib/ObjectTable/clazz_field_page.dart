//@dart=2.11
import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fswitch/fswitch.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/StateScript/NodeEditor/a_field_type_selector.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/float_editor.dart';
import 'package:battlepus/common/int_editor.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';

class ClazzFieldPage extends StatefulWidget {
  final ObjectClazz clazz;
  final double fullSize;
  ClazzFieldPage({Key key , this.clazz, this.fullSize}) : super(
      key: key);

  @override
  _ClazzFieldPageState createState() =>
      _ClazzFieldPageState(
      );
}

class _ClazzFieldPageState extends State<ClazzFieldPage> {
  List<ListTableColumn> columns;
  FieldInfo focusItem;

  void initColumns(){
    columns = new List<ListTableColumn>();



    var c3 = ListTableColumn();
    c3.name = "属性类型";

    c3.width = 320.0;
    c3.widgetBuilder = (context , index) {
      var items = widget.clazz.fields;
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
    {
      var c3 = ListTableColumn();
      c3.name = "允许空";

      c3.width = 60.0;
      c3.widgetBuilder = (context , index) {
        var items = widget.clazz.fields;
        var res = new ItemHolder();
        res.widget = _getAllowEmptyWidgets(items[index]);
        return res;
      };
      c3.headAlignment = Alignment.centerLeft;
      c3.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c3);
    }


    {
      var c3 = ListTableColumn();
      c3.name = "组合查询键";

      c3.width = 80.0;
      c3.widgetBuilder = (context , index) {
        var items = widget.clazz.fields;
        var res = new ItemHolder();
        res.widget = _getIsSerchKeyWidgets(items[index]);
        return res;
      };
      c3.headAlignment = Alignment.centerLeft;
      c3.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c3);
    }

    {
      var c3 = ListTableColumn();
      c3.name = "唯一";

      c3.width = 48.0;
      c3.widgetBuilder = (context , index) {
        var items = widget.clazz.fields;
        var res = new ItemHolder();
        res.widget = _getIsUniqueWidgets(items[index]);
        return res;
      };
      c3.headAlignment = Alignment.centerLeft;
      c3.headerBuilder = (context) {
        var s = SizedBox(width: 8,);
        var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
        return Row(children: [s,t],);
      };
      columns.add(c3);
    }

    ///
    var c = ListTableColumn();
    c.name = "属性名";

    c.width = 200.0;
    c.widgetBuilder = (context , index) {
      var items = widget.clazz.fields;
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

    // {
    //   var c1 = ListTableColumn();
    //   c1.name = "公式";
    //
    //   c1.width = 200.0;
    //   c1.widgetBuilder = (context , index) {
    //     var items = widget.clazz.fields;
    //     var res = new ItemHolder();
    //     res.widget = _getFuncWidget(items[index]);
    //     return res;
    //   };
    //   c1.headAlignment = Alignment.centerLeft;
    //   c1.headerBuilder = (context) {
    //     var s = SizedBox(width: 8,);
    //     var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
    //     return Row(children: [s,t],);
    //   };
    //   columns.add(c1);
    // }
    //

    ///
    var c1 = ListTableColumn();
    c1.name = "别名(优先显示)";

    c1.width = 180.0;
    c1.widgetBuilder = (context , index) {
      var items = widget.clazz.fields;
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

    var c4 = ListTableColumn();
    c4.name = "默认值";

    c4.width = 160.0;
    c4.widgetBuilder = (context , index) {

      var items = widget.clazz.fields;
      var res = new ItemHolder();
      var item = items[index];
      var fi = SSFieldType.getFieldType(item.typeGuid ,fieldInfo: item);
      if (fi == null){
        res.widget = getLostEnum();
        return res;
      }
      if ((fi.flag & SSFieldType.FIELD_FLAG_CONTAINER) >0){
        res.widget = Container(child: const Text("默认容器"),);
        return res;
      }

      if ((fi.flag & SSFieldType.FIELD_FLAG_REF) >0){
        res.widget = Container(child: const Text("默认空对象"),);
        return res;
      }

      var bIsEdit = true;// = focusItem == item;
      var edt = fi.getDefaultEditWidget(bIsEdit,
          item.defaultValue,
              (v){
            item.defaultValue = v;
          },(v){
            setState(() {
              item.defaultValue = v;
            });

          },
          context: context
      );

      res.widget = Container(
        padding: EdgeInsets.all(4),
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
      var c1 = ListTableColumn();
      c1.name = "标签";

      c1.width = 48.0;
      c1.widgetBuilder = (context , index) {
        var items = widget.clazz.fields;
        var res = new ItemHolder();
        res.widget = _getIsTagWidgets(items[index]);
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

    {
      var c1 = ListTableColumn();
      c1.name = "简化展示";

      c1.width = 80.0;
      c1.widgetBuilder = (context , index) {
        var items = widget.clazz.fields;
        var res = new ItemHolder();
        res.widget = _getIsPrivateWidgets(items[index]);
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

    {
      var c1 = ListTableColumn();
      c1.name = "静态";

      c1.width = 48.0;
      c1.widgetBuilder = (context , index) {
        var items = widget.clazz.fields;
        var res = new ItemHolder();
        res.widget = _getIsStaticWidgets(items[index]);
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

    {
      var c2 = ListTableColumn();
      c2.name = "操作";

      c2.width = 90.0;
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
    // {
    //   var c1 = ListTableColumn();
    //   c1.name = "宽度";
    //
    //   c1.width = 140.0;
    //   c1.widgetBuilder = (context , index) {
    //     var items = widget.clazz.fields;
    //     var res = new ItemHolder();
    //     res.widget = _getWidthWidget(items[index]);
    //     return res;
    //   };
    //   c1.headAlignment = Alignment.centerLeft;
    //   c1.headerBuilder = (context) {
    //     var s = SizedBox(width: 8,);
    //     var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
    //     return Row(children: [s,t],);
    //   };
    //   columns.add(c1);
    // }
    // {
    //   var c1 = ListTableColumn();
    //   c1.name = "冷冻格";
    //
    //   c1.width = 140.0;
    //   c1.widgetBuilder = (context , index) {
    //     var items = widget.clazz.fields;
    //     var res = new ItemHolder();
    //     res.widget = _getIsFreezeWidget(items[index]);
    //     return res;
    //   };
    //   c1.headAlignment = Alignment.centerLeft;
    //   c1.headerBuilder = (context) {
    //     var s = SizedBox(width: 8,);
    //     var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
    //     return Row(children: [s,t],);
    //   };
    //   columns.add(c1);
    // }


    // {
    //   var c = ListTableColumn();
    //   c.name = "Grid宽度";
    //
    //   c.width = 120.0;
    //   c.widgetBuilder = (context , index) {
    //     var items = widget.clazz.fields;
    //     var res = new ItemHolder();
    //     res.widget = _getGridWidthWidget(items[index]);
    //     return res;
    //   };
    //
    //   c.headAlignment = Alignment.centerLeft;
    //   c.headerBuilder = (context) {
    //     var s = SizedBox(width: 8,);
    //     var t = Text(c.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
    //     return Row(children: [s,t],);
    //   };
    //   columns.add(c);
    // }

    // {
    //   var c1 = ListTableColumn();
    //   c1.name = "Agent数据注入";
    //
    //   c1.width = 200.0;
    //   c1.widgetBuilder = (context , index) {
    //     var items = widget.clazz.fields;
    //     var res = new ItemHolder();
    //     res.widget = _getBindAgentVar(items[index]);
    //     return res;
    //   };
    //   c1.headAlignment = Alignment.centerLeft;
    //   c1.headerBuilder = (context) {
    //     var s = SizedBox(width: 8,);
    //     var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: ThemeCenter.mainTextStepColor(5)),textAlign: TextAlign.left,);
    //     return Row(children: [s,t],);
    //   };
    //   columns.add(c1);
    // }
  }
  StreamSubscription<ClazzSelectionChangeEvent> _lis;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lis?.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusItem = null;
    initColumns();

    _lis = EventCenter.eventBus.on<ClazzSelectionChangeEvent>().listen((event) {
      setState(() {
        focusItem = null;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var items = widget.clazz.fields;
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
      itemHeight: 48,
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
          // SizedBox(height: 6,),
          ThemeCenter.block(
            headTitle: "标签模板",
            height: 100,
              padding: EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextEditor(
                  // hint: "标签模板",
                  initValue: widget.clazz.tagFormat??"",
                  onChanged: (v){
                    widget.clazz.tagFormat = v;
                  },
                  onSubmitted: (v){
                    widget.clazz.tagFormat = v;
                    widget.clazz.reorderTags();
                  },
                ),
                TextButton(
                  // color: Colors.blueGrey,
                  // hoverColor: Colors.blue,
                  child: Text("刷新"),
                  onPressed: (){
                    widget.clazz.reorderTags();
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 6,),
          Expanded(child :lst),
          if(widget.clazz.fields.length<=0) ElevatedButton(
            child: Text("添加字段"),
            onPressed: (){
              setState(() {
                var item = widget.clazz.addField();
                if (widget.clazz.containTag(item.guid)){
                  widget.clazz.reorderTags();
                }
                widget.clazz.rebuildAllFields();
              });
            },
          ),
          SizedBox(height: 4,),

        ],
      ),
    );
  }

  Widget _getNameWidget(FieldInfo item) {

    var str = item.name;
    if (str == null || str.isEmpty) str = "请输入名字";
    var bIsEdit = true;////focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.name??"",
          onChanged : (v){
            item.name = v;
            widget.clazz.rebuildAllFields();
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(str);
  }

  Widget _getGridWidthWidget(FieldInfo item) {

    // int width = item.gridWidth??128;
    // if (str == null || str.isEmpty) str = "请输入名字";
    var bIsEdit = true;// = focusItem == item;
    if (bIsEdit){
      var res = IntEditor(
          initValue: item.gridWidth??128,
          onChanged : (v){
            item.gridWidth = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text("${item.gridWidth}");
  }

  Widget _getWidthWidget(FieldInfo item) {

    var bIsEdit = true;// = focusItem == item;
    if (bIsEdit){
      var res = FloatEditor(
          initValue: item.width,
          onChanged: (v){
            item.width = v;
          },
          onSubmitted: (v){
            item.width = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.width.toString());
  }

  Widget _getIsFreezeWidget(FieldInfo item) {

    var bIsEdit = true;// = focusItem == item;

    var res = FSwitch(
      open: item.isFreezeHeader==true,
      enable: bIsEdit,
      onChanged: (v){
        item.isFreezeHeader = v;
      },
    );
    return Container(
      padding: EdgeInsets.all(4),
      child: res,
    );
//    if (bIsEdit){
//
//    }
//    return Text(item.width.toString());
  }

  Widget _getAliasWidget(FieldInfo item) {

    var bIsEdit = true;// focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.alias,
          onChanged: (v){
            item.alias = v;
            widget.clazz.rebuildAllFields();
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.alias);
  }

  Widget _getFuncWidget(FieldInfo item) {

    var bIsEdit = true;// = focusItem == item;
    if (bIsEdit){
      var res = TextEditor(
          initValue: item.func??"",
          onChanged: (v){
            item.func = v;
          }
      );
      return Container(
        padding: EdgeInsets.all(4),
        child: res,
      );
    }
    return Text(item.func);
  }

  Widget _getActionWidgets(int index) {
    var items = widget.clazz.fields;
    var upCmd = IconButton(icon: Icon(MaterialCommunityIcons.close_box_outline),iconSize: 24, color: Colors.redAccent, tooltip:"刪除",
      onPressed: (){
        setState(() {
          var item = items[index];
          widget.clazz.removeField(item);
          if (widget.clazz.containTag(item.guid)){
            widget.clazz.reorderTags();
          }
          item = null;
          widget.clazz.rebuildAllFields();

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
            var item = widget.clazz.addField();
            items.remove(item);
            items.insert(index+1, item);
            if (widget.clazz.containTag(item.guid)){
              widget.clazz.reorderTags();
            }
            widget.clazz.rebuildAllFields();
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
            var itemCopy = items[index].clone();
            // var item = widget.clazz.addField();
            // items.remove(item);
            items.insert(index+1, itemCopy);
            if (widget.clazz.containTag(itemCopy.guid)){
              widget.clazz.reorderTags();
            }
            widget.clazz.rebuildAllFields();
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
  Widget _getIsSerchKeyWidgets(FieldInfo item) {

    return Checkbox(
      value: item.isSearchKey??true,
      onChanged: (v){
        setState(() {
          item.isSearchKey = v;
          widget.clazz.rebuildSearchFields();
        });
      },
    );
  }

  Widget _getIsUniqueWidgets(FieldInfo item) {

    return Checkbox(
      value: item.isRef??true,
      onChanged: (v){
        setState(() {
          item.isRef = v;
          // widget.clazz.rebuildSearchFields();
        });
      },
    );
  }

  Widget _getIsTagWidgets(FieldInfo item) {

    return Checkbox(
      value: widget.clazz.containTag(item.guid),//item.isSearchKey??true,
      onChanged: (v){
        setState(() {
          if (v){
            if (!widget.clazz.containTag(item.guid)) widget.clazz.tagFields.add(item.guid);
          }
          else{
            widget.clazz.tagFields.remove(item.guid);
          }

          widget.clazz.buildTags();
          // item.isSearchKey = v;
        });
      },
    );
  }

  Widget _getIsPrivateWidgets(FieldInfo item) {

    return Checkbox(
      value: !item.isPublic,//item.isSearchKey??true,
      onChanged: (v){
        setState(() {
          item.isPublic = !v;
        });
      },
    );
  }

  Widget _getIsStaticWidgets(FieldInfo item) {

    return Checkbox(
      value: item.isStatic,//item.isSearchKey??true,
      onChanged: (v){
        setState(() {
          item.isStatic = v;
        });
      },
    );
  }

  Widget _getAllowEmptyWidgets(FieldInfo item) {

    return Checkbox(
      value: item.allowEmpty??true,
      onChanged: (v){
        setState(() {
          item.allowEmpty = v;
        });
      },
    );
  }
  Widget _getTypeWidgets(FieldInfo item) {
    var bIsEdit = true;// = focusItem == item;
    var fi = SSFieldType.getFieldType(item.typeGuid,fieldInfo: item);
    if (fi == null) {
      //可能枚举被删
      return  getLostEnum();
    }
//    if (fi == null) fi =
    if (bIsEdit){
      var lst = SSFieldType.getTypeMap();
      lst.sort((a,b)=>a.priority-b.priority);
      //
      // List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();
      // for(var i in lst){
      //   if (i.flag & SSFieldType.FIELD_FLAG_NO_OT_FIELD != 0 ) continue;
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
        initialValue:item.typeGuid,
        // field: item,
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
                  child: fi.getTypeShowWidget(fieldType: SSFieldType.getFieldType(item.typeGuid , fieldInfo: item) , onChange: (v){
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


  Widget getLostEnum(){
    return  Container(
      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
      child:Center(child:Text("请检查是否丢失枚举" , style: TextStyle(color: Colors.red), )),
    );
  }
  Widget _getBindAgentVar(FieldInfo item) {
    var agentVarId = item.agentBindInfo;
    var fi = SSFieldType.getFieldType(item.typeGuid);
    if (fi == null){
      //可能枚举被删
      return getLostEnum();
    }
    var sstype = SSFieldType.getFieldType("___agentvar___");
    var wid = sstype.getEditWidget(agentVarId,
        (v){
          setState(() {
            item.agentBindInfo = v;
          });

        },
        (v){
          setState(() {
            item.agentBindInfo = v;
          });
        },
        context: context,
        levelInfo : EditorLevelInfo()..varType = fi.guid).widget;
    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: wid,
    );
  }
}