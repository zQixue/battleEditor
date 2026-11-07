//@dart=2.11
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:path/path.dart' as PathUtil;

class PathPicker extends StatefulWidget {
  final String initPath;
  final String basePath;
  final dynamic onChoosePath;
  final String tooltip;
  final Widget header;
  final double width;
  PathPicker({Key key,
    this.initPath,
    this.basePath,
    this.onChoosePath,
    this.tooltip,
    this.header,
    this.width = 200,
  }) : super(key: key);

  @override
  _PathPickerState createState() => _PathPickerState();
}

class _PathPickerState extends State<PathPicker> {
  String crtPath;
  @override
  void initState() {
    crtPath = widget.initPath;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var iPath = widget.initPath;
    if (widget.basePath != null){
      iPath = PathUtil.canonicalize(PathUtil.join(widget.basePath , iPath));
    }
    if (!Directory(iPath).existsSync()) iPath = null;

    var btn = ThemeCenter.iconBtn(MaterialCommunityIcons.folder_open,
      width: 28 , height: 28,
      color: Colors.greenAccent,
      tooltip: widget.tooltip,
      onPressed: () async {
        var path = await FileUtils.pickPath(initDir: iPath);
        if (path != null) {
          if (widget.basePath != null){
            path = PathUtil.relative(path , from: widget.basePath );
          }
          setState(() {
            crtPath = path;
            widget.onChoosePath?.call(crtPath);
          });
        }
      },
    );
    return Container(
      width: widget.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(widget.header!= null)widget.header,
          if(widget.header!= null)Container(width: 4,),
          Expanded(child:TextEditor(
            enabled: false,
            initValue: crtPath??"",
          )),
          Container(width: 4,),
          btn,
        ],
      ),
    );
  }
}