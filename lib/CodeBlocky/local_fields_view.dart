//@dart=2.11
// import 'package:flutter/material.dart';
//
// class LocalFieldsView extends StatefulWidget {
//   LocalFieldsView({Key key}) : super(key: key);
//
//   @override
//   _LocalFieldsViewState createState() => _LocalFieldsViewState();
// }
//
// class _LocalFieldsViewState extends State<LocalFieldsView> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBLocalVarDefine.dart';
import 'package:battlepus/CodeBlocky/CodeBlocky.dart';
import 'package:battlepus/StateScript/HistoryManager.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/EventCenter.dart';
import 'package:battlepus/common/cell_text_field.dart';
import 'package:battlepus/common/list_table.dart';
import 'package:battlepus/common/text_editor.dart';

class LocalFieldsView extends StatefulWidget {
  // double width;
  // double height;
  final CBFunction function;
  final List<FieldInfo> fields;
  final bool withDefault;
  final String blockyType ;
  LocalFieldsView({Key key, this.fields , this.function, this.withDefault = true , this.blockyType = "___var___"}) : super(key: key);

  @override
  _LocalFieldsViewState createState() => _LocalFieldsViewState();
}

class _LocalFieldsViewState extends State<LocalFieldsView> {

  // bool _opend = false;
  CBLocalVarDefine localVarMaker ;

  @override
  void initState() {
    // TODO: implement initState
    localVarMaker = CBLocalVarDefine();
    super.initState();
  }
  FieldInfo getLocalField(fiGuid) {
    for(var fi in widget.fields){
      if (fi.guid == fiGuid){
        return fi;
      }
    }
    return null;
  }
  Widget getBlockWidget(CodeBlocky blocky , bool isFocus , {bool isSimple = false}){
    var bgColor = Colors.white24;
    var bgcolor2 = bgColor;//CommonUtil.scaleColor(bgColor, 0.3);
    var dc = new BoxDecoration(
        border: new Border.all(color: Colors.white, width: 0.5),
        color :bgcolor2,
        //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
        boxShadow: [ BoxShadow(color: bgcolor2, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: Colors.black)],
        borderRadius: new BorderRadius.circular((isFocus?15.0:90.0))
    );


    var fiGuid = blocky.values["guid"];
    var fi = getLocalField(fiGuid);

    if (isSimple){
      return Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        width: 120,
        height: 32,
        child:Row(
          children: [
            Icon(MaterialCommunityIcons.key,color: Colors.indigo,size: 24,),
            Text(fi.getTypeShowString() , style: TextStyle(fontSize: 13 , fontWeight: FontWeight.w500 , color: Colors.black),),
          ],
        ),
        // width: 120,
        decoration: dc,
      );
    }
    return Container(
      child:localVarDefineView(fi,isFocus),
      // width: 120,
      decoration: dc,
    );
  }
  Widget localVarDefineView(FieldInfo fi , bool isFocus) {
    // var fi = widget.field;
    var ft = SSFieldType.getFieldType(fi.typeGuid ,fieldInfo: fi);

    Widget con ;
    if (!isFocus){
      var row1 = Row(
        children: [
          Icon(MaterialCommunityIcons.key,color: Colors.indigo,size: 24,),
          SizedBox(width: 8,),
          Expanded(child :Text(fi.getTypeShowString())),
          // Icon(MaterialCommunityIcons.equal_box, color: Colors.indigo, size: 24,),
          // Expanded(child :Text(ft.parseValue(fi.defaultValue).toString())),
        ],
      );
      con = Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: row1
      );
    }
    else {
      var row1 = Row(
        children: [
          Expanded(child: _getTypeWidgets(fi)),
        ],
      );
      var row2 = Row(
        children: [
          Icon(MaterialCommunityIcons.key, color: Colors.indigo, size: 24,),
          SizedBox(width: 8,),
          Expanded(child: TextEditor(
            initValue: fi.name,
            forceRebuild: false,
            onChanged: (v) {
              setState(() {
                if (widget.function != null){
                  HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_name_${fi.guid}");
                }
                fi.name = v;
              });
              EventCenter.eventBus.fire(BlockContainerRefresh());
            },
          )),
          // Icon(MaterialCommunityIcons.equal_box,color: Colors.indigo,size: 20,),
          // Expanded(child :edt),
        ],
      );
      bool bWithFunc = CodeBlocky.curentFunction != null;


      var edt = ft.getDefaultEditWidget(true,
          fi.defaultValue,
              (v){
                if (widget.function != null){
                  HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_dv_${fi.guid}");
                }
            fi.defaultValue = v;
          },(v){
            setState(() {
              fi.defaultValue = v;
            });

          },
          context: context
      );


      if (widget.withDefault){
        var row3 = Row(
          children: [

            Icon(
              MaterialCommunityIcons.equal_box, color: Colors.indigo, size: 24,),
            SizedBox(width: 8,),
            Expanded(child: edt),
            // SizedBox(width: bWithFunc ? 8 : 0,),
            // bWithFunc ? IconButton(
            //   icon: Icon(MaterialCommunityIcons.minus_box_outline),
            //   iconSize: 24,
            //   color: Colors.red,
            //   tooltip: "删除",
            //   padding: EdgeInsets.all(0),
            //   onPressed: () {
            //     setState(() {});
            //   },
            // ) : SizedBox(width: 0,),
          ],
        );
        var row4 = Row(
          children: [
            Icon(MaterialCommunityIcons.rename_box, color: Colors.indigo, size: 24,),
            SizedBox(width: 8,),
            Expanded(child: TextEditor(
              initValue: fi.alias,
              forceRebuild: false,
              onChanged: (v) {
                setState(() {
                  if (widget.function != null){
                    HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_alias_${fi.guid}");
                  }
                  fi.alias = v;
                });
                EventCenter.eventBus.fire(BlockContainerRefresh());
              },
            )),
            // Icon(MaterialCommunityIcons.equal_box,color: Colors.indigo,size: 20,),
            // Expanded(child :edt),
          ],
        );
        con = Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              row1,
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: row2,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: row4,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: row3,
              ),
              SizedBox(height: 10,),
            ],
          ),
        );
      }
      else{
        var row3 = Row(
          children: [
            Icon(MaterialCommunityIcons.rename_box, color: Colors.indigo, size: 24,),
            SizedBox(width: 8,),
            Expanded(child: TextEditor(
              initValue: fi.alias,
              forceRebuild: false,
              onChanged: (v) {
                setState(() {
                  if (widget.function != null){
                    HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_alias_${fi.guid}");
                  }
                  fi.alias = v;
                });
                EventCenter.eventBus.fire(BlockContainerRefresh());
              },
            )),
            // Icon(MaterialCommunityIcons.equal_box,color: Colors.indigo,size: 20,),
            // Expanded(child :edt),
          ],
        );
        con = Container(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              row1,
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: row2,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: row3,
              ),
              SizedBox(height: 10,),
            ],
          ),
        );
      }
    }

    return con;

  }

  Widget _getTypeWidgets(FieldInfo item) {
    var bIsEdit = true;//focusItem == item;
    var fi = SSFieldType.getFieldType(item.typeGuid,fieldInfo: item);
//    if (fi == null) fi =
    if (bIsEdit){
      var lst = SSFieldType.getTypeMap();
      lst.sort((a,b)=>a.priority-b.priority);

      List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();

      for(var i in lst){
        if ((i.flag & SSFieldType.FIELD_FLAG_NO_SCRIPT_FIELD) != 0) continue;
        var item = PopupMenuItem<String>(
          value: i.guid,
          child: i.getTypeShowWidget(),
        );
        items.add(item);
      }

      var res = PopupMenuButton<String>(
        padding: EdgeInsets.all(0),
        initialValue:item.typeGuid,

        onSelected: (String result) { setState(() {
          if (widget.function != null){
            HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_type_${fi.guid}");
          }
          item.typeGuid = result;
        }); },
        itemBuilder: (BuildContext context) => items,
      );
      return Container(
          padding: EdgeInsets.all(4),
          child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Expanded(child:Container(
                  alignment: Alignment.center,
//              width: 200,
                  child: fi.getTypeShowWidget(fieldType: SSFieldType.getFieldType(item.typeGuid , fieldInfo: item), onChange: (v){
                    setState(() {
                      if (widget.function != null){
                        HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_copyTypes_${fi.guid}");
                      }
                      item.copyTypes(v);
                    });
                  }),
                )),
                Container(
//                  width: 40,
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

  FieldInfo addField({FieldInfo newFi}) {

    FieldInfo n = newFi??FieldInfo();
    widget.fields.add(n);
    return n;
  }

  void removeField(FieldInfo f) {
    widget.fields.remove(f);
  }

  @override
  Widget build(BuildContext context) {
    // if (!_opend){
    // }
    // else{
    {
      // var finalWidth = widget.width;//max(widget.width/2 , 300.0);
      // var finalHeight = widget.height;//max(widget.height/2 , 200.0);

      // finalWidth = min(finalWidth+1 , 200.0+200.0+200.0+200.0+101);
//      finalHeight = max(widget.height/2 , 200.0);
//       initColumns();
      var items = widget.fields;//ScriptInfo.current.scriptData.scriptFields;
      List<Widget> rows = List<Widget>();
      for(var itm in items){
        var cb = CodeBlocky()..blockyTypeId = widget.blockyType ..guid = null;
        // cb.values["category"] = "local";
        cb.values["guid"] = itm.guid;
        var w = getBlockWidget(cb , focusItem == itm);//localVarMaker.getBlockWidget(cb);
        var iw =InkWell(
            focusColor:CommonUtil.alphaColor(Colors.white, 0),
          onTap: (){
            setState(() {
              focusItem = itm;
            });
          },
          child: w,
        );
        // var iw = w;
        var db = Draggable(
          child: iw,
          feedback: Material(child:getBlockWidget(cb , focusItem == itm , isSimple: true) , color: CommonUtil.alphaColor(Colors.white, 0),),
          // feedback: getBlockWidget(cb , focusItem == itm , isSimple: true),
          childWhenDragging: iw,
          data:cb,
        );
        rows.add(db);
        rows.add(SizedBox(height: 4,));
      }

      var lst = Container(
        padding: EdgeInsets.all(4),
        child:ListView(
          children: rows,
        ) ,
      );
//       var lst = FreezeHeaderTable(
//         forceWidth: finalWidth,
//         columns:columns,
//         itemCount: items.length,
//         itemHeight: 42,
//
//         useCard: false,
//         onTap: (idx){
//           setState(() {
//             if(focusItem != items[idx]) {
//               focusItem = items[idx];
//             }
//           });
//         },
//         onRowInfo: (idx){
//           var info = RowInfoHolder();
//           info.forceColor = focusItem == items[idx];
//           info.bgColor = Color(0x220000dF);
//           return info;
//         },
//       );
//       var dc = new BoxDecoration(
//         border: new Border.all(color: Colors.grey, width: 0.5),
// //          color :bgcolor2,
//         //   color: getNodeColor(),//Color(widget.node.getNodeStructType().bgColor),
//         boxShadow: [ BoxShadow(color: Colors.grey, offset:Offset(0.0, 0.0), blurRadius: 2.0, spreadRadius: 1.0) , BoxShadow(color: Colors.white)],
// //          borderRadius: new BorderRadius.circular((90.0))
//       );
      var con= Container(
        // decoration: dc,
        // width : finalWidth,
        // height : finalHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 6,),
            Container(
              height: 34,
//            color: CommonUtil.alphaColor(Colors.indigo, 24),
              child :Row(
                children: [
                  IconButton(icon: Icon(MaterialCommunityIcons.plus_box_outline),iconSize: 30, color: Colors.white, tooltip:"添加新字段",
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      setState(() {
                        focusItem = FieldInfo();
                        if (widget.function != null){
                          HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_add_${focusItem.guid}");
                        }
                        addField(newFi: focusItem);
                        EventCenter.eventBus.fire(NodeRefreshEvent());
                      });
                    },
                  ),
                  IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 30, color: focusItem==null?Colors.grey:Colors.redAccent, tooltip:"删除",
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      setState(() {
                        if (widget.function != null){
                          HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_remove_${focusItem.guid}");
                        }
                        removeField(focusItem);
                        focusItem = null;
                        EventCenter.eventBus.fire(NodeRefreshEvent());
                      });
                    },
                  ),
                  Expanded(child: Container()),
                  // IconButton(icon: Icon(MaterialCommunityIcons.close_box_outline),iconSize: 30, color: Colors.red, tooltip:"关闭",
                  //   padding: EdgeInsets.all(0),
                  //   onPressed: (){
                  //     setState(() {
                  //       setState(() {
                  //         _opend = false;
                  //       });
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
            SizedBox(height: 4,),
            Expanded(child :lst),
//          lst,
//          SizedBox(height: 4,),

            SizedBox(height: 4,),
          ],
        ),
      );

      // return Positioned.directional(
      //   textDirection:TextDirection.ltr,
      //   child: con ,
      //   end:10,
      //   bottom: 10,
      // );
      return con;
    }
  }


  Widget _getNameWidget(FieldInfo item) {

    var str = item.name;
    if (str == null || str.isEmpty) str = "请输入名字";
    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = CellTextField(
          initText: item.name,
          onDone: (v){

            if (widget.function != null){
              HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_inputName_${item.guid}");
            }

            item.name = v;
            EventCenter.eventBus.fire(NodeRefreshEvent());
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

    var bIsEdit = focusItem == item;
    if (bIsEdit){
      var res = CellTextField(
          initText: item.alias,
          onDone: (v){
            if (widget.function != null){
              HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_inputAlias_${item.guid}");
            }
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

  Widget _getActionWidgets(int index) {
    var items = widget.fields;//ScriptInfo.current.scriptData.scriptFields;
    var upCmd = IconButton(icon: Icon(MaterialCommunityIcons.arrow_up_bold_box_outline),iconSize: 30, color: Colors.indigo, tooltip:"上移",
      onPressed: (){
        setState(() {

          var item = items[index];
          if (widget.function != null){
            HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_moveup_${item.guid}");
          }

          items.remove(item);
          items.insert(index-1, item);
          focusItem = item;
        });
      },
    );
    var up = Container(
      width: 32,
//      height: 32,
      child: index>0?upCmd:Container(),
    );
    var dowmCmd = IconButton(icon: Icon(MaterialCommunityIcons.arrow_down_bold_box_outline),iconSize: 30, color: Colors.indigo, tooltip:"下移",
      onPressed: (){
        setState(() {
          var item = items[index];
          if (widget.function != null){
            HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_movedown_${item.guid}");
          }
          items.remove(item);
          items.insert(index+1, item);
          focusItem = item;
        });
      },
    );
    var down = Container(
      width: 32,
//      height: 32,
      child: index<items.length-1?dowmCmd:Container(),
    );
    return Container(
      child: Row(
        children: [
          up,
          down,
        ],
      ),
    );
  }

  List<ListTableColumn> columns;

  FieldInfo focusItem;
  void initColumns(){
    columns = new List<ListTableColumn>();

    var c3 = ListTableColumn();
    c3.name = "属性类型";
    c3.isFreeze = true;
    c3.width = 200.0;
    c3.widgetBuilder = (context , index) {
      var items = widget.fields;//ScriptInfo.current.scriptData.scriptFields;
      var res = new ItemHolder();
      res.widget = _getTypeWidgets(items[index]);
      return res;
    };
    c3.headAlignment = Alignment.centerLeft;
    c3.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c3.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c3);

    ///
    var c = ListTableColumn();
    c.name = "属性名";

    c.width = 200.0;
    c.widgetBuilder = (context , index) {
      var items = widget.fields;//ScriptInfo.current.scriptData.scriptFields;
      var res = new ItemHolder();
      res.widget = _getNameWidget(items[index]);
      return res;
    };

    c.headAlignment = Alignment.centerLeft;
    c.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c);

    ///
    var c1 = ListTableColumn();
    c1.name = "别名(优先显示)";

    c1.width = 200.0;
    c1.widgetBuilder = (context , index) {
      var items = widget.fields;//ScriptInfo.current.scriptData.scriptFields;
      var res = new ItemHolder();
      res.widget = _getAliasWidget(items[index]);
      return res;
    };
    c1.headAlignment = Alignment.centerLeft;
    c1.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c1);
//    {
//      var c1 = ListTableColumn();
//      c1.name = "显示行数";
//
//      c1.width = 100.0;
//      c1.widgetBuilder = (context , index) {
//        var items = ScriptInfo.current.scriptData.scriptFields;
//        var bIsEdit = focusItem == items[index];
//        var res = new ItemHolder();
//        var edt = bIsEdit?IntEditor(
//          initValue: items[index].lineCount,
//          onChanged: (v){
//            items[index].lineCount = v;
//          },
//          onSubmitted: (v){
//            setState(() {
//              items[index].lineCount = v;
//            });
//          },
//        ):Center(child:Text("${items[index].lineCount}"));
//
//        res.widget = Container(
//          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
//          child : edt,
//        );
//        return res;
//      };
//      c1.headAlignment = Alignment.centerLeft;
//      c1.headerBuilder = (context) {
//        var s = SizedBox(width: 8,);
//        var t = Text(c1.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
//        return Row(children: [s,t],);
//      };
//      columns.add(c1);
//    }

    var c4 = ListTableColumn();
    c4.name = "默认值";

    c4.width = 200.0;
    c4.widgetBuilder = (context , index) {

      var items = widget.fields;//ScriptInfo.current.scriptData.scriptFields;
      var res = new ItemHolder();
      var item = items[index];
      var fi = SSFieldType.getFieldType(item.typeGuid ,fieldInfo: item);

      if ((fi.flag & SSFieldType.FIELD_FLAG_CONTAINER) >0){
        res.widget = Container(child: const Text("默认容器"),);
        return res;
      }

      var bIsEdit = focusItem == item;
      var edt = fi.getDefaultEditWidget(bIsEdit,
          item.defaultValue,
              (v){
                if (widget.function != null){
                  HistoryManager.functionHistory?.appendHistory(guid : "${widget.function.guid}_dv_${fi.guid}");
                }
            item.defaultValue = v;
          },(v){
            setState(() {
              item.defaultValue = v;
            });

          },
          context: context
      );
      // var edt = bIsEdit?fi.getEditWidget(
      //     item.defaultValue,
      //     null,
      //     (v){
      //           setState(() {
      //             item.defaultValue = v;
      //           });
      //     }
      // ).widget:fi.getValueLabelWidget(item.defaultValue);

      res.widget = Container(
        padding: EdgeInsets.all(4),
        child : edt,
      );
      return res;
    };
    c4.headAlignment = Alignment.centerLeft;
    c4.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c4.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c4);

    var c2 = ListTableColumn();
    c2.name = "操作";

    c2.width = 100.0;
    c2.widgetBuilder = (context , index) {

      var res = new ItemHolder();
      res.widget = _getActionWidgets(index);
      return res;
    };
    c2.headAlignment = Alignment.centerLeft;
    c2.headerBuilder = (context) {
      var s = SizedBox(width: 8,);
      var t = Text(c2.name , style: TextStyle(fontSize: 13 , fontWeight:FontWeight.w600 ,color: Colors.black45),textAlign: TextAlign.left,);
      return Row(children: [s,t],);
    };
    columns.add(c2);
  }

  Widget buildFields(){

  }
}