//@dart=2.11
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/CommonUtil.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/line_field_container.dart';
import 'package:path/path.dart' as PathUtil;

class DirectoryPicker extends StatefulWidget {
  final String initPath;
  final String basePath;
  final String hint;
  final String tooltip;
  final dynamic onChanged;
  final bool withLine;
  final double iconSize;
  final bool withClear;
  final double height ;
  DirectoryPicker({Key key , this.height = 48, this.withClear = false, this.iconSize = 42, this.initPath , this.basePath , this.hint = "" , this.tooltip = "" , this.onChanged, this.withLine = true}) : super(key: key);

  @override
  _DirectoryPickerState createState() => _DirectoryPickerState();
}

class _DirectoryPickerState extends State<DirectoryPicker> {
  // String _lastInitPath ;
  String _choosenPath ;
  @override
  void initState() {
    // print("1 $_choosenPath");
    _choosenPath = widget.initPath;
    // _lastInitPath = widget.initPath;
    // print("3 $_choosenPath");
    // TODO: implement initState
    super.initState();
  }

  @override
  void didUpdateWidget(DirectoryPicker oldWidget) {
    // TODO: implement didUpdateWidget
    _choosenPath = widget.initPath;
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    // if (_lastInitPath != widget.initPath){
    //   print("4 $_choosenPath");
    //   _choosenPath = widget.initPath;
    //   _lastInitPath = _choosenPath;
    // }
    // print("2 $_choosenPath");
    var basePath = DartCommon.isEmpty(widget.basePath)?".":widget.basePath;
    var con = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child : LineFieldContainer(
              withLine: false,//widget.withLine,
              title: widget.hint??"",
              separatorColor: ThemeCenter.mainTextStepColor(2),
              // height: 52,
              child: Text(_choosenPath??"" , style: TextStyle(fontSize: 17 , fontWeight: FontWeight.w500 , color:  Colors.lightBlueAccent),),
            ),
          ),
          Container(

            width: widget.iconSize,
            child : IconButton(icon: Icon(MaterialCommunityIcons.folder_open , color: Colors.blue,),iconSize: widget.iconSize, color: Colors.white, tooltip:widget.tooltip,
              onPressed: () async {
              print(PathUtil.normalize(PathUtil.join(basePath , _choosenPath)));
         
                var path = await FileUtils.pickPath(initDir: PathUtil.normalize(PathUtil.join(basePath , _choosenPath)) );
                if (path == null) return ;
                setState(() {
                  _choosenPath = PathUtil.relative(path , from:basePath);
                  // _lastInitPath = _choosenPath;
                  widget.onChanged?.call(_choosenPath);
                });

              },
            ),
          ),

          if (widget.withClear) Container(
            // padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
            width: widget.iconSize,
            child : IconButton(icon: Icon(MaterialCommunityIcons.close_box , color: Colors.redAccent,),iconSize: widget.iconSize, color: Colors.white, tooltip:"清空",
              onPressed: () async {
                setState(() {
                  _choosenPath = "";
                  // _lastInitPath = _choosenPath;
                  widget.onChanged?.call("");
                });


              },
            ),
          ),
          Container(width: 8,),
        ],
      );
      if (widget.withLine) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 2.0,color: CommonUtil.alphaColorD( Colors.grey , 0.35)),
            ),
          ),
          child: con,
        );
      }
      else{
        return Container(
          height: widget.height,
          child: con,
        );
      }
  }
}