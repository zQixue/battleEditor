//@dart=2.11

import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/ATableColumn.dart';

class TableReaderBase {
  List<ATableColumn> readColumns(String path){
    return null;
  }
  ATable readTable(String path ){
    return null;
  }

  ATable readSimpleTable(String path ){
    return null;
  }

  List<List<dynamic>> readData(String path ){
    return null;
  }

  List<ATable> readTables(String path){
    return null;
  }
}