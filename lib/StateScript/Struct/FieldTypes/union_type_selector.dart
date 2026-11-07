//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/StateScript/SSDefines.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:theme_provider/theme_provider.dart';

class UnionTypeSelector extends StatefulWidget {
  final String initType;
  final dynamic onSelected;
  final double height;
  UnionTypeSelector({Key key , this.initType , this.onSelected ,this.height}) : super(key: key);

  @override
  _UnionTypeSelectorState createState() => _UnionTypeSelectorState();
}

class _UnionTypeSelectorState extends State<UnionTypeSelector> {
  @override
  Widget build(BuildContext context) {

    var realType = widget.initType;//(tp as SSFieldType).guid;
    var lst = SSFieldType.getTypeMap();
    lst.sort((a,b)=>a.priority-b.priority);
    List<PopupMenuEntry<String>> items = new  List<PopupMenuEntry<String>>();

    for(var i in lst){
      if ((i.flag & SSFieldType.FIELD_FLAG_UNION) == 0){
        continue;
      }
      var item = PopupMenuItem<String>(
        value: i.guid,
        child: i.getTypeShowWidget(),
      );
      items.add(item);
    }
    var tp = SSFieldType.getFieldTypeByFullGuid(realType);
    var res = PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      icon: tp.getIcon(),
      initialValue:realType,
      onSelected: (String result) { setState(() { widget.onSelected?.call(result); }); },
      itemBuilder: (BuildContext context) => items,
    );
    return ThemeConsumer(child : Container(child : res , width: SSDefines.fieldIconSize + 4 ,height: SSDefines.fieldIconSize));
//     return Container(
//       height :widget.height,
//         padding: EdgeInsets.all(4),
//         child:Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:[
//               Expanded(child:Container(
//                 alignment: Alignment.center,
// //              width: 200,
//                 child: tp.getTypeShowWidget(),
//               )),
//               Container(
//                 width: 32,
//                 child: res,
//               ),
// //            res,
//             ]
//         )
//
//     );
  }
}