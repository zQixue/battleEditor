//@dart=2.11

import 'dart:io';

import 'package:excel/excel.dart';
import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/ATableColumn.dart';
import 'package:battlepus/MultiLans/TableReader/TableReaderBase.dart';
import 'package:battlepus/common/DartCommon.dart';

class XlsxReader extends TableReaderBase {
  @override
  List<ATableColumn> readColumns(String path){
    var res = List<ATableColumn>();

    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var tableName in excel.tables.keys) {
      print(tableName); //sheet Name
      if(tableName.startsWith('~') || tableName.startsWith("-")){
        continue;
      }
      var table = excel.tables[tableName];
      // print(table.maxCols);
      // print(table.maxRows);
      var iCount = table.maxCols;
      if (table.rows.length < 3){
        //无效
        return null;
      }
      for(int i = 0 ; i < iCount ;++i) {
        var col = ATableColumn();
        col.name = table.rows[1][i].toString();
        col.desc = table.rows[0][i].toString();
        col.type = table.rows[2][i].toString();
        if (DartCommon.isEmpty(col.name)){
          col.name = col.desc;
          col.noName = true;
        }
        col.index = i;
        res.add(col);
      }
//      for (var row in excel.tables[table].rows) {
//        print("$row");
//      }
      //break;
    }

    return res;
  }
  @override
  ATable readTable(String path){
    // var sw = Stopwatch();
    var res = List<ATableColumn>();
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var tableName in excel.tables.keys) {

      // sw.start();
      var table = excel.tables[tableName];
      // sw.stop();
      // print("load 1 : ${sw.elapsedMilliseconds}");
      if(tableName.startsWith('~') || tableName.startsWith('-')){
        continue;
      }
      var iCount = table.maxCols;
      if (table.rows.length < 3){
        //无效
        continue;
      }
      var t = ATable();
      t.sheetName = tableName;
      // sw.start();
      for(int i = 0 ; i < iCount ;++i) {
        var col = ATableColumn();
        col.name = table.rows[1][i].toString();
        col.desc = table.rows[0][i].toString();
        col.type = table.rows[2][i].toString();
        if (DartCommon.isEmpty(col.name)){
          col.name = col.desc;
          col.noName = true;
        }
        col.index = i;
        res.add(col);
      }
      // sw.stop();
      // print("load 2 : ${sw.elapsedMilliseconds}");

      // sw.start();
      t.columns = res;
      t.rows = List<List>();
      var allRows = table.rows;
      var iRowCount = table.maxRows;
      for(int i = 3 ; i < iRowCount ;++i) {
        t.rows.add(allRows[i]);
      }
      return t;
    }

    return null;
  }

  @override
  List<List<dynamic>> readData(String path ){
    // var sw = Stopwatch();
    var res = List<List>();
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var tableName in excel.tables.keys) {

      // sw.start();
      var table = excel.tables[tableName];
      return table.rows;
    }

    return null;
  }

  @override
  ATable readSimpleTable(String path){
    // var sw = Stopwatch();
    var res = List<ATableColumn>();
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var tableName in excel.tables.keys) {

      // sw.start();
      var table = excel.tables[tableName];
      // sw.stop();
      // print("load 1 : ${sw.elapsedMilliseconds}");
      if(tableName.startsWith('~') || tableName.startsWith('-')){
        continue;
      }
      var iCount = table.maxCols;
      if (table.rows.length < 1){
        //无效
        continue;
      }
      var t = ATable();
      t.sheetName = tableName;
      // sw.start();
      for(int i = 0 ; i < iCount ;++i) {
        var col = ATableColumn();
        col.name = table.rows[0][i];
        col.index = i;
        res.add(col);
      }
      // sw.stop();
      // print("load 2 : ${sw.elapsedMilliseconds}");

      // sw.start();
      t.columns = res;
      t.rows = List<List>();
      var allRows = table.rows;
      var iRowCount = table.maxRows;
      for(int i = 1 ; i < iRowCount ;++i) {
        t.rows.add(allRows[i]);
      }
      return t;
    }

    return null;
  }

  @override
  List<ATable> readTables(String path){
    List<ATable> tbls = new List<ATable>();

    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var tableName in excel.tables.keys) {

      //- 和 ~开头的表格忽略读取
      if(tableName.startsWith('-') ||tableName.startsWith('~')){
        continue;
      }
      // sw.start();
      var table = excel.tables[tableName];
      var res = List<ATableColumn>();
      // sw.stop();
      // print("load 1 : ${sw.elapsedMilliseconds}");
      var iCount = table.maxCols;
      if (table.rows.length < 3){
        //无效
        continue;
      }
      var t = ATable();
      t.sheetName = tableName;
      // sw.start();
      for(int i = 0 ; i < iCount ;++i) {
        var col = ATableColumn();
        col.name = table.rows[1][i].toString();  //这三个表头都是string类型  一定要做一次兼容
        col.desc = table.rows[0][i].toString();
        col.type = table.rows[2][i].toString();
        if (DartCommon.isEmpty(col.name)){
          col.name = col.desc;
          col.noName = true;
        }
        col.index = i;
        res.add(col);
      }
      // sw.stop();
      // print("load 2 : ${sw.elapsedMilliseconds}");

      // sw.start();
      t.columns = res;
      t.rows = List<List>();
      var allRows = table.rows;
      var iRowCount = table.maxRows;
      for(int i = 3 ; i < iRowCount ;++i) {
        t.rows.add(allRows[i]);
      }

      tbls.add(t);
    }

    return tbls;
  }
}