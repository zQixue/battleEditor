//@dart=2.11

import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/ATableColumn.dart';
import 'package:battlepus/MultiLans/TableReader/TableReaderBase.dart';
import 'package:battlepus/common/DartCommon.dart';
import 'package:battlepus/csv-4.1.0/lib/csv.dart';
import 'package:utf/utf.dart';
import 'package:path/path.dart' as PathUtil;

class CsvReader extends TableReaderBase {
  @override
  List<ATableColumn> readColumns(String path){

    var lst = getTableList(path);
    if (lst.length < 3){
      //无效
      return null;
    }

    return getColumnsFromDataList(lst);
  }

  List<ATableColumn> getColumnsFromDataList(List<List> lst){

    var res = List<ATableColumn>();
    var iCount = lst[1].length;
    for(int i = 0 ; i < iCount ;++i) {
      var col = ATableColumn();
      col.name = lst[1][i].toString();
      col.desc = lst[0][i].toString();
      col.type = lst[2][i].toString();

      if (DartCommon.isEmpty(col.name)){
        col.name = col.desc;
        col.noName = true;
      }
      col.index = i;
      res.add(col);
    }

    return res;
  }

  static String globalTextDelimiter ;
  List<List> getTableList(String path){

    var conv = CsvToListConverter(fieldDelimiter: '\t' , textDelimiter:globalTextDelimiter??'"' , textEndDelimiter: globalTextDelimiter??'"');
    var lst ;
    try{
      lst = conv.convert(File(path).readAsStringSync());

    }
    catch(e){
      var bytes = File(path).readAsBytesSync();
      var decoder = Utf16BytesToCodeUnitsDecoder(bytes); // use le variant if no BOM
      var str = String.fromCharCodes(decoder.decodeRest());
      //对 unity 的补丁
      // str = str.replaceAll(new RegExp(r'\t\"\"'), '"');
      // str = str.replaceFirstMapped(RegExp(r'\"\"(\t|\r|\n)'), (match) {
      //   return "\"${match.group(1)}";}
      // );
      // str = str.replaceAll(new RegExp(r'\t\"\"'), '"');
      // str = str.replaceAll(new RegExp(r'\"\"\t'), '"\t');
      // str = str.replaceAll(new RegExp(r'\"\"\r'), '"\r');
      // str = str.replaceAll(new RegExp(r'\"\"\n'), '"\n');
      lst = conv.convert(str);
      // print(lst);
    }

    return lst;
  }

  @override
  List<List<dynamic>> readData(String path ){
    // var sw = Stopwatch();
    var lst = getTableList(path );

    return lst;
  }

  @override
  ATable readTable(String path){
    var lst = getTableList(path );
    if (lst.length < 3){
      //无效
      return null;
    }
    var t = ATable();
    var tblName = PathUtil.basenameWithoutExtension(path);
    t.sheetName = tblName;
    t.columns = getColumnsFromDataList(lst);
    t.rows = List<List>();
    var iCount = lst.length;
    for(int i = 3 ; i < iCount ;++i) {
      t.rows.add(lst[i]);
    }
    return t;
  }

  @override
  List<ATable> readTables(String path) {
    var t = readTable(path);
    List<ATable> res = List<ATable>();
    if (t != null) res.add(t);
    return res;
  }
}