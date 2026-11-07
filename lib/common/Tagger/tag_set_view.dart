//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/Tagger/TagCamp.dart';
import 'package:battlepus/common/Tagger/TagSet.dart';
import 'package:battlepus/common/Tagger/tag_edit_view.dart';
import 'package:battlepus/common/Tagger/tag_view.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:theme_provider/theme_provider.dart';

class TagSetView extends StatefulWidget {
  final TagSet tagSet;
  final TagCamp tagCamp;
  final List<Widget> actions;
  TagSetView({Key key ,
    this.tagSet,
    this.tagCamp,
    this.actions,
  }) : super(key: key);

  @override
  _TagSetViewState createState() => _TagSetViewState();
}

class _TagSetViewState extends State<TagSetView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> lst = List<Widget>();
    if (widget.tagSet != null && widget.tagSet.tagGuids != null && widget.tagCamp != null && widget.tagCamp.tags!=null){
      widget.tagSet.tagGuids.forEach((key) {
        var tag = widget.tagCamp.tags[key];
        if (tag != null){
          lst.add(TagView(tag: tag,));
        }
      });
    }
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: lst,
            ),
          ),
          ThemeCenter.iconBtn(MaterialCommunityIcons.square_edit_outline,
            width: 20 , height : 20 , color: Colors.greenAccent, tooltip:"编辑标签",
            onPressed: (){


              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  var child = ThemeCenter.area(width:800 ,height:600, child: TagEditView(camp: widget.tagCamp, tagSet: widget.tagSet,));
                  return ThemeConsumer(child:Dialog(child: child));
                },
              ).then((value){
                setState(() {

                });
              });
            },
          ),
          if (widget.actions != null && widget.actions.length>0) Row(
            children: widget.actions,
          )
        ]
      ),
    );
  }
}