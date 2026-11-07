//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/common/Filter/TextFilter.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';

class FilterLine extends StatefulWidget {
  final TextFilter filter ;
  final double width;
  final dynamic onChanged;
  const FilterLine({Key key,
    this.filter,
    this.width,
    this.onChanged,
  }) : super(key: key);

  @override
  _FilterLineState createState() => _FilterLineState();
}

class _FilterLineState extends State<FilterLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Row(
        children: [
          Expanded(
            child: TextEditor(
              initValue: widget.filter.filter ,
              textStyle : ThemeCenter.mainTextStyle(step: 9,fontSize: 12),//TextStyle(color: Colors.white , fontSize: 16),
              forceRebuild:false,
              onChanged: (v){
                setState(() {
                  widget.filter.filter = v;
                  widget.onChanged?.call();
                });
              },
            )
          )
        ],
      ),
    );
  }
}
