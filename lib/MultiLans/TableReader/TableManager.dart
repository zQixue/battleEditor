//@dart=2.11

import 'dart:io';

import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/ATableColumn.dart';
import 'package:battlepus/MultiLans/TableReader/CsvReader.dart';
import 'package:battlepus/MultiLans/TableReader/CsvWriter.dart';
import 'package:battlepus/MultiLans/TableReader/TableReaderBase.dart';
import 'package:battlepus/MultiLans/TableReader/TableWriterBase.dart';
import 'package:battlepus/MultiLans/TableReader/XlsxReader.dart';
import 'package:battlepus/MultiLans/TableReader/XlsxWriter.dart';
import 'package:path/path.dart' as PathUtil;

class TableManager {

  static Map<String , TableReaderBase> readers ;//= Map<String , TableReaderBase>();
  static Map<String , TableWriterBase> writers ;//= Map<String , TableReaderBase>();
  static void registerReader(String tgtExt , TableReaderBase reader){
    if (readers == null){
      readers = Map<String , TableReaderBase>();
      initReaders();
    }
    readers[tgtExt] = reader;
  }

  static void registerWriter(String tgtExt , TableWriterBase writer){
    if (writers == null){
      writers = Map<String , TableWriterBase>();
      initReaders();
    }
    writers[tgtExt] = writer;
  }

  static TableReaderBase getReader(String tgtExt){
    if (readers == null){
      readers = Map<String , TableReaderBase>();
      initReaders();
    }
    return readers[tgtExt];
  }

  static TableWriterBase getWriter(String tgtExt){
    if (writers == null){
      writers = Map<String , TableWriterBase>();
      initReaders();
    }
    return writers[tgtExt];
  }

  static void initReaders(){
    registerReader(".csv" , CsvReader());
    registerReader(".xlsx" , XlsxReader());
    registerReader(".xls" , XlsxReader());

    registerWriter(".csv" , CsvWriter());
    registerWriter(".xlsx" , XlsxWriter());
    registerWriter(".xls" , XlsxWriter());
//    registerReader(".xls" , XlsxReader());
  }
//  static Map<String , ATable> tables = Map<String , ATable>();
  static List<ATableColumn> getTableColumns(File f) {
    return getTableColumnsOfPath(f.path);
  }

  static isReadable(File f) {
    var ext = PathUtil.extension(f.path).toLowerCase();
    var reader = getReader(ext);
    return reader != null;
  }

  static List<ATableColumn> getTableColumnsOfPath(String path) {
    var ext = PathUtil.extension(path).toLowerCase();
    var reader = getReader(ext);
    if (reader == null) return null;
    return reader.readColumns(path);
  }

  static ATable getTable(String path){
    var ext = PathUtil.extension(path).toLowerCase();
    var reader = getReader(ext);
    if (reader == null) return null;

    return reader.readTable(path);
  }

  static List<List<dynamic>> getData(String path){
    var ext = PathUtil.extension(path).toLowerCase();
    var reader = getReader(ext);
    if (reader == null) return null;

    return reader.readData(path);
  }

  static ATable getSimpleTable(String path){
    var ext = PathUtil.extension(path).toLowerCase();
    var reader = getReader(ext);
    if (reader == null) return null;

    return reader.readSimpleTable(path);
  }

  static List<ATable> getTables(String path){
    var ext = PathUtil.extension(path).toLowerCase();
    var reader = getReader(ext);
    if (reader == null) return null;

    return reader.readTables(path);
  }

  static void writeTable(ATable tbl , String path){
    var ext = PathUtil.extension(path).toLowerCase();
    var writer = getWriter(ext);
    if (writer == null) return null;

    return writer.writeTable(tbl , path);
  }
}