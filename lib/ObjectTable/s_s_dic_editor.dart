//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:reorderables/reorderables.dart';

class SSDicEditor extends StatefulWidget {
  final dynamic initValue ;
  final dynamic onChanged ;
  final dynamic onSubmitted;
  final GridCellInfo gci;
  final SSFieldType innerType0;
  final SSFieldType innerType1;
  final String name;

  SSDicEditor({Key key , this.name, this.gci,this.innerType0 ,this.innerType1, this.initValue , this.onChanged , this.onSubmitted}) : super(key: key);

  @override
  _SSDicEditorState createState() => _SSDicEditorState();
}

class _SSDicEditorState extends State<SSDicEditor> {

  dynamic initValue;
  bool _isReorder = false ;
  @override
  void initState() {
    initValue = widget.initValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // var initValue = widget.initValue;
    var onChanged = widget.onChanged;
    var onSubmitted = widget.onSubmitted;
    var innerType0 = widget.innerType0;
    var innerType1 = widget.innerType1;
    var gci = widget.gci;

    // List<dynamic> lst = [];
    // if (initValue is List<dynamic> ){
    //   lst = initValue;
    // }
    var lst = initValue;
    var maincolor = ThemeCenter.systemTheme.scaffoldBackgroundColor;//CommonUtil.alphaColorD(Colors.redAccent, 0.06);
    List<Widget> ws = new List<Widget>();
    for(int i = 0 ; i < lst.length ; ++i){

      var crt = lst[i];
      // crt = innerType0.parseValue(crt);
      var key = innerType1.parseValue(crt["key"]);
      var val = innerType0.parseValue(crt["value"]);

      var wKey = innerType1.getGridCellEditor(initValue: key,
          onChanged: (v){
            lst[i]["key"] = v;
            onChanged?.call(lst);
          },
          onSubmitted:(v){
            lst[i]["key"]  = v;
            onSubmitted?.call(lst);
          },
        gci: gci,
      );
      var wVal = innerType0.getGridCellEditor(initValue:val,
          onChanged: (v){

            setState(() {
              lst[i]["value"] = v;
              onChanged?.call(lst);
            });

          },
          onSubmitted:(v){
            setState(() {
              lst[i]["value"] = v;
              onChanged?.call(lst);
            });
          },
        gci: gci,
        context: context,
      );
      // levelInfo.lineWidth = old;

      // var color = (i%2 ==1) ? CommonUtil.alphaColorD(Colors.deepPurpleAccent, 0.05) : CommonUtil.alphaColorD(Colors.grey, 0.2);
      var rowitem = Container(
        width: 700,
        height: 36,
        key: ValueKey(i),
//        height: SSDefines.nodeFieldRowHeight,
//         color: color,
        child : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ThemeCenter.iconBtn(MaterialCommunityIcons.minus_box_outline , color: Colors.red,
              width: 24 , height :24 ,
              tooltip: "删除",
              onPressed: (){
                lst.removeAt(i);
                onSubmitted?.call(lst);
                setState(() {
                  initValue = lst;
                });
              },
            ),
            SizedBox(width: 8,),
            _isReorder? Expanded(child:innerType1.getValueLabelWidget(lst[i]["key"]??"" , style: TextStyle(color: Colors.blueAccent , fontSize: 14), )) : Expanded(flex:2,child:wKey.widget),
            Icon(MaterialCommunityIcons.arrow_right , color: Colors.lightBlue,),
            _isReorder? Expanded(child:innerType0.getValueLabelWidget(lst[i]["value"]??"" , style: TextStyle(color: Colors.blueAccent , fontSize: 14), )) : Expanded(flex:4,child:wVal.widget),
            if (_isReorder) Icon(MaterialCommunityIcons.drag)
          ],
        ),
      );
      // ws.add(Text("${lst[i]}" , key: ValueKey(i) ,));
      ws.add(rowitem);
    }
    var leftPadding = EdgeInsets.fromLTRB(8, 0, 8, 0);
    var edtCon = Container(
      width: 700,
      // padding: EdgeInsets.fromLTRB(0, 0, 8, 0),

      color:maincolor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(

            // width: 340,
            height: 36,
            // height:levelInfo.lineHeight,
            padding: leftPadding,
            color: ThemeCenter.systemTheme.primaryColor,
            child:Row(
              children: [

                // onVisible!= null?IconButton(
                //   icon:Icon(bOpen?MaterialCommunityIcons.close_box_outline:MaterialCommunityIcons.square_edit_outline , color: bOpen?Colors.redAccent : Colors.indigoAccent),
                //   onPressed: (){
                //     onVisible?.call(!bOpen);
                //   },
                // ):SizedBox(width: 0,),

                Expanded(child : Text(widget.name??"")),
                // ThemeCenter.iconBtn(MaterialCommunityIcons.drag_variant,
                //     width: 24 , height:24,
                //     tooltip: "排序模式",
                //     color: _isReorder?Colors.lightBlue:Colors.grey,
                //     onPressed: (){
                //       setState(() {
                //         _isReorder = !_isReorder;
                //
                //       });
                //     }
                // ),
              ],
            ),
          ),
          Expanded(child:Container(
            padding: leftPadding,
            child: _isReorder?ReorderableColumn(
              // crossAxisAlignment: CrossAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ws,
              // needsLongPressDraggable:false,
              onReorder: (int oldIndex, int newIndex){
                setState(() {
                  // Widget row = _rows.removeAt(oldIndex);
                  // _rows.insert(newIndex, row);
                  var vvv = lst.removeAt(oldIndex);
                  lst.insert(newIndex, vvv);
                  initValue = lst;
                });
              },
            ):ListView(
              children: ws,
            ),
          )),
          // SizedBox(height : bOpen?2:0),
          Container(
            // width: 340,
            height:36,
//            height: levelInfo.lineHeight,
//            width: levelInfo.lineWidth + (bOpen?levelInfo.spaceStep+2:0.0),
//             padding: leftPadding,
            color: ThemeCenter.systemTheme.primaryColor,
            child:Row(
              children: [

//                  Expanded(child : showInfo??Text("")),
                IconButton(
                  icon:Icon(MaterialCommunityIcons.plus_box_outline , color: Colors.green),
                  tooltip: "添加",
                  onPressed: (){
                    var dKey = innerType0.parseValue(null);
                    var dVal = innerType1.parseValue(null);
                    lst.add({'key':dKey , 'value':dVal});
                    onSubmitted?.call(lst);
                    setState(() {
                      initValue = lst;
                    });
                  },

                ),
              ],
            ),
          ),
        ],
      ),
    );

    return edtCon;
  }
}