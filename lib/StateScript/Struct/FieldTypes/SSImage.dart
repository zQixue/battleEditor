//@dart=2.11

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:battlepus/ObjectTable/ObjectTableSetting.dart';
import 'package:battlepus/StateScript/Struct/EditorHolder.dart';
import 'package:battlepus/StateScript/Struct/SSFieldType.dart';
import 'package:battlepus/common/BinaryWriter.dart';
import 'package:battlepus/common/FuncTypeDef.dart';
import 'package:battlepus/common/GlobalDoard.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/directory_picker.dart';
import 'package:battlepus/common/image_picker.dart';
import 'package:path/path.dart' as PathUtil;
class SSImage extends SSFieldType {

  SSImage(){
    innerTypeGuid0 = "";
  }
  @override
  Widget getTypeShowWidget({SSFieldType fieldType , FunctionStringCallback onChange}) {
    if (fieldType == null){
      return Row(
        children: [
          Icon(MaterialCommunityIcons.image , color: Colors.redAccent,),
          SizedBox(width: 8,),
          Expanded(child:Text(getTypeShowString() ,style : ThemeCenter.mainTextStyle(step:9,fontSize: 13), overflow: TextOverflow.clip,maxLines: 1,)),
          // Expanded(child:Text("" , overflow: TextOverflow.clip,maxLines: 1,)),
        ],
      );
    }

    var rp = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var path = fieldType.innerTypeGuid0??"";

    if (onChange == null){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(MaterialCommunityIcons.image , color: Colors.redAccent,),
          Expanded(
          child: Text(path??""),
          )],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(MaterialCommunityIcons.image , color: Colors.redAccent,),
        Expanded(
          child:  DirectoryPicker(

            // hint: "通用结点(node)导出目录",
            tooltip: "选择路径",
            withClear: true,
            iconSize: 24,
            initPath: path,
            basePath: rp,
            onChanged: (v) {
              // fieldType.innerTypeGuid0 = v;
              var subPath = (v as String).replaceAll("\\", "/");
              var newFT = SSFieldType.getFieldTypeByInnerType(fieldType.guid , subPath , fieldType.innerTypeGuid1);
              // print(newFT.guid);
              onChange?.call(newFT.guid);
              //
              // fieldType.innerTypeGuid0 = v;
              // onChange?.call(fieldType.guid);
            },
          ),
        ),
        // CommonUtil.getFilesOfDirectory(path, namePattern)
      ],
    );

  }

  String tryGetImage(String path){
    var tgtImage = "$path.png";
    if(File(tgtImage).existsSync()) return tgtImage;
    tgtImage = "$path.jpg";
    if(File(tgtImage).existsSync()) return tgtImage;
    tgtImage = "$path.bmp";
    if(File(tgtImage).existsSync()) return tgtImage;
    tgtImage = "$path.tga";
    if(File(tgtImage).existsSync()) return tgtImage;

    return null;
  }

  @override
  EditorHolder getGridCellEditor({dynamic initValue , dynamic onChanged , dynamic onSubmitted , GridCellInfo gci , BuildContext context}){
    // return EditorHolder()..widget = Container() ..height = SSDefines.nodeFieldRowHeight;
    String path = "";
    if (initValue is String ){
      path = initValue;
    }
    var rp = GlobalBoard.getCorrectDirectory(ObjectTableSetting.instance.workingPath);
    var basePath = PathUtil.canonicalize(PathUtil.join(rp , innerTypeGuid0));
    // print("loac image basePath : $basePath");
    var tgtImage = PathUtil.join(basePath , path);
    print("loac image path : $tgtImage");
    var fullPath = tryGetImage(tgtImage);

    print("full path : $fullPath");
    // Widget imgView;
    // if (fullPath == null){
    //   imgView = Icon(MaterialCommunityIcons.image_outline,size: 24,);
    // }
    // else {
    //   // print("loac2 image path : $fullPath");
    //   imgView = Image.file(File(fullPath),
    //   );
    // }

    var imgPicker = ImagePicker(
      key: ValueKey("${gci.object?.guid??""}_${gci.fieldInfo?.guid??""}"),
      imagePath: fullPath,
      basePath: basePath,
      onChanged: (newPath){
        // // print("new path : $newPath");
        // // print("basePath path : $basePath");
        // var rpath = PathUtil.relative(newPath , from: basePath);
        // if (rpath!=null) rpath = PathUtil.withoutExtension(rpath); // print("rpath : $rpath");
        // // print("rpath : $rpath");
        onChanged?.call(newPath);

      },
    );
    return EditorHolder()..widget = Center(child: imgPicker);
    // return EditorHolder()..widget = Center(child: InkWell(
    //   child: imgView,
    //   onTap: (){
    //     FileUtils.pickFile("选择图片", ["png","jpg","bmp","tga",]).then((newPath){
    //       if (!DartCommon.isEmpty(newPath)){
    //         print("new path : $newPath");
    //         print("basePath path : $basePath");
    //         var rpath = PathUtil.relative(newPath , from: basePath);
    //         if (rpath!=null) rpath = PathUtil.withoutExtension(rpath); // print("rpath : $rpath");
    //         // print("rpath : $rpath");
    //         onChanged?.call(rpath.replaceAll("\\", "/"));
    //       }
    //     });
    //   },
    // ));
  }

  @override
  void export(ByteDataWriter bw, v, {Map prms}) {
    String str = parseValue(v);
    // if (str.length>=1 && str.codeUnitAt(0) == 8291){
    //   str = str.substring(1);
    // }
    bw.writeString(str,exportFlag);
  }

  @override
  String parseValue(value){
    String v = "";
    if (value is String ){
      v = value;
    }

    return v;
  }
  @override
  clone(){
    var t = SSImage();
    copyTo(t);
    t.priority = priority;
    t.innerTypeCount = innerTypeCount;
    t.flag = flag | SSFieldType.FIELD_FLAG_HIDEN;
    return t;
  }

}