//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/CodeBlocky/Blockies/CBFunction.dart';
import 'package:battlepus/StateScript/Struct/FieldInfo.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/text_editor.dart';

class LocalVarDefineView extends StatefulWidget {
  final FieldInfo field;
  final CBFunction function;
  LocalVarDefineView({Key key , this.field , this.function}) : super(key: key);

  @override
  _LocalVarDefineViewState createState() => _LocalVarDefineViewState();
}

class _LocalVarDefineViewState extends State<LocalVarDefineView> {
  @override
  Widget build(BuildContext context) {
    var fi = widget.field;
    var ft = SSFieldType.getFieldType(fi.typeGuid ,fieldInfo: fi);
    var edt = ft.getDefaultEditWidget(true,
        fi.defaultValue,
            (v){
              fi.defaultValue = v;
        },(v){
          setState(() {
            fi.defaultValue = v;
          });

        },
        context: context
    );

    var row1 = Row(
      children: [
        Expanded(child:_getTypeWidgets(fi)),
        Icon(MaterialCommunityIcons.key,color: Colors.indigo,size: 24,),
        SizedBox(width: 8,),
        Expanded(child :TextEditor(
          initValue: fi.name,
          onChanged: (v){
            fi.name = v;
          },
        )),
        // Icon(MaterialCommunityIcons.equal_box,color: Colors.indigo,size: 20,),
        // Expanded(child :edt),
      ],
    );
    bool bWithFunc = widget.function != null;
    var row2 = Row(
      children: [

        Icon(MaterialCommunityIcons.equal_box,color: Colors.indigo,size: 24,),
        SizedBox(width: 8,),
        Expanded(child :edt),
        SizedBox(width: bWithFunc?8:0,),
        bWithFunc?IconButton(icon: Icon(MaterialCommunityIcons.minus_box_outline),iconSize: 24, color: Colors.red, tooltip:"删除",
          padding: EdgeInsets.all(0),
          onPressed: (){
            setState(() {
            });
          },
        ):SizedBox(width: 0,),
      ],
    );
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          row1,
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            child: row2,
          ),

          SizedBox(height: 10,),
        ],
      ),
    );
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

        onSelected: (String result) { setState(() { item.typeGuid = result; }); },
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
}