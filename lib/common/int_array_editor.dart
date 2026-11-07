//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/int_editor_ex.dart';

class IntArrayEditor extends StatefulWidget {
  final List<int> values;
  final dynamic onChanged ;
  final dynamic onSubmitted ;
  const IntArrayEditor({Key key,
    this.values = const <int>[],
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _IntArrayEditorState createState() => _IntArrayEditorState();
}

class _IntArrayEditorState extends State<IntArrayEditor> {
  List<int> vals;
  int iFocusIndex ;
  @override
  void initState() {
    vals = widget.values;
    print("comma 3 : $vals");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var vals = widget.values;
    List<Widget> ws = List<Widget>();
    ws.add(Container(
      // height: 40,
      // width: 12,
      alignment: Alignment.topCenter,
      child: const Icon(MaterialCommunityIcons.code_array , size: 10, color: Colors.green,),
    ));
    // print("comma 4 : $vals");
    for(int i = 0 ; i< vals.length ; ++i){
      var edt = IntEditorEx(
        formatReg: RegExp("[;0-9\+\-]"),
        focus:iFocusIndex == i,
        key: UniqueKey(),
        autoSize: true,
        // noBorder: true,
        contentPadding: EdgeInsets.fromLTRB(0,0,0,4),
        textStyle: TextStyle(fontSize: 14),
        initValue: vals[i],
        onChanged: (v){
          if (v is int) {
            vals[i] = v;
            widget.onChanged?.call(vals);
          }

        },
        onSubmitted: (v){
          if (v is int) {
            vals[i] = v;
            widget.onChanged?.call(vals);
            // setState(() {});
          }
          else{
            if (v is String){
              if (v.indexOf(";") >=0){
                // print("comma ");
                var commaLst = v.split(";");
                // print("comma $commaLst");
                vals.removeAt(i);
                for(int j = commaLst.length-1 ; j>=0;--j ){
                  vals.insert(i, DartCommon.parseInt(commaLst[j]));
                }
                iFocusIndex = i + commaLst.length - 1;
                widget.onChanged?.call(vals);
                // print("comma $vals");
                setState(() {

                });
              }
              else{
                if (v == ""){
                  vals.removeAt(i);
                  iFocusIndex = i - 1;
                  widget.onChanged?.call(vals);
                  // print("comma $vals");
                  setState(() {

                  });
                }
              }
            }
          }
        },
      );

      ws.add(edt);
      if (i < vals.length -1){
        ws.add(Container(
          alignment: Alignment.bottomCenter,
          child: const Icon(MaterialCommunityIcons.comma , size: 8, color: Colors.green,),
        ));
      }
    }
    iFocusIndex = null;
    if (vals.length<=0)ws.add(ThemeCenter.iconBtn(MaterialCommunityIcons.plus_box_outline , color: Colors.green,
      tooltip: "添加",
      onPressed: (){
        vals.add(0);
        widget.onSubmitted?.call(vals);
        setState(() {

        });
      }
    ));
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: ws,
    );
  }
}
