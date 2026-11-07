import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectClazz.dart';
import 'package:battlepus/ObjectTable/Struct/ObjectTableProject.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/searchable_theme_tree_view.dart';

class AClazzTypeSelector extends StatefulWidget {
  final String? initialValue;
  final dynamic onChanged;
  AClazzTypeSelector({Key? key,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _AClazzTypeSelectorState createState() => _AClazzTypeSelectorState();
}

class _AClazzTypeSelectorState extends State<AClazzTypeSelector> {
  @override
  Widget build(BuildContext context) {
    return ThemeCenter.iconBtn(Icons.menu ,
        height: 38,
        width: 24,
        onPressed: (){
          showDialog(
            context: context,
            barrierColor:Colors.black87,
            // barrierDismissible: false,
            builder: (BuildContext context) {
              // var child = getScriptChooser(context,scriptInfo , onlyModule: levelInfo.isModule);
              return Dialog(child: Container(
                color:  Color(0xff2f2f2f),
                width: 400,
                height: 800,
                child: getSearchBox(),
              ), );
            },
          );
        }
    );
  }

  Widget getSearchBox(){

    ATreeNode<ObjectClazz> _compRoot = DartCommon.buildTree<ObjectClazz>(ObjectTableProject.instance!.clazzes!, (item){
      var sp = ((item as ObjectClazz)?.group??"").split("/");
      return sp;
    });

    var con = SearchableThemeTreeView(
      // onFilterChanged: (lst){
      //   _filterdStrings = lst;
      // },
      defaultExpanded: true,
      onGetID: (node){
        return (node as ATreeNode<ObjectClazz>).id;
      },
      indent: 16,
      root : _compRoot,
      onBuildItem: (node,expanded , highlightPattern){
        print(highlightPattern);
        var agent = node as ATreeNode<ObjectClazz>;
        if (agent.isLeaf) {
          var si = (agent as ATreeNode<ObjectClazz>).data;

          bool selected = widget.initialValue?.indexOf(si.guid)==0;//(_selectedStrings[si.guid] != null);

          var tagEdt = Text( si.getTypeShowString() , style: ThemeCenter.mainTextStyle(step: 6 ,fontSize: 14),);//si.getTypeShowWidget();

          var con = Container(
              color: selected ? CommonUtil.alphaColorD(Colors.blue, 0.4) : null,

              child: Padding(

                  padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      // SizedBox(width : 8),
                      // Icon(Icons.web , color: Colors.greenAccent , size: 16,),
                      SizedBox(width : 4),
                      Expanded(child : tagEdt),
                    ],
                  )
              )
          );
          // return txt;
          con = Container(
            padding: EdgeInsets.all(1),
            child: InkWell(
              child: con,
              onTap: (){

                if (si != null ) {
                  widget.onChanged?.call(si.guid);
                  // controller?.hideMenu();
                  Navigator.pop(context, si.guid);
                }
              },
            ),
          );

          return con;
        }
        else{
          var txt = Text(agent.name??"",style: ThemeCenter.mainTextStyle(step: expanded?9:4 ,fontSize: 12));
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
        }
      },
      onGetChildren: (node){
        return (node as ATreeNode<ObjectClazz>).children;
      },
      onFilter: (node){
        var ns  = node as ATreeNode<ObjectClazz>;
        if (ns != null) {
          // if (!ns.isLeaf) return ns.id;
          var n = ns.data;
          if (n == null) return "";
          return n.getShowStringAndName();
        }

        return "";
      },


      onItemTap: (item){

      },

      actions: [

        ThemeCenter.iconBtn(MaterialCommunityIcons.close_box_outline, color: Colors.redAccent,
          width: 24,height :24,
          onPressed: (){
            Navigator.pop(context);
            // controller?.hideMenu();
          },
          tooltip: "关闭",
        ),
      ],
    );

    return con;
  }
}