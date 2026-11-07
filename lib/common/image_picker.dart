//@dart=2.11
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/common/FileUtils.dart';
import 'package:path/path.dart' as PathUtil;

class ImagePicker extends StatefulWidget {
  final String imagePath;
  final dynamic onChanged ;
  final String basePath;
  ImagePicker({Key key,
    this.imagePath,
    this.onChanged,
    this.basePath,
  }) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  String crtPath;
  @override
  void initState() {
    crtPath = widget.imagePath;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Widget imgView;
    var fullPath = crtPath;
    if (fullPath == null){
      imgView = Icon(MaterialCommunityIcons.image_outline,size: 24,);
    }
    else {
      // print("loac2 image path : $fullPath");
      imgView = Image.file(File(fullPath),
      );
    }

    return Tooltip(message: "点击选择图片",child: InkWell(
      child: imgView,
      onTap: (){
        FileUtils.pickFile("选择图片", ["png","jpg","bmp","tga",]).then((newPath){
          if (!DartCommon.isEmpty(newPath)){
            // print("new path : $newPath");
            // print("basePath path : ${widget.basePath}");
            var rpath = newPath;
            if (widget.basePath != null) {
              rpath = PathUtil.relative(newPath, from: widget.basePath);
              if (rpath != null) rpath = PathUtil.withoutExtension(rpath); // print("rpath : $rpath");
              // print("rpath : $rpath");
            }

            var finalPath = rpath.replaceAll("\\", "/");
            widget.onChanged?.call(finalPath);
            setState(() {
              crtPath = newPath;
            });
          }
        });
      },
    ));
  }
}