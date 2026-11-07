//@dart=2.11
 
import 'package:flutter/material.dart';

class ZipItem {
  String path;
  int zipSize;
  int realSize;
  int indentLevel;
  bool noZipSize = false;

  Widget getWidget(bool bSelected){
    return Text(path??"");
  }
}