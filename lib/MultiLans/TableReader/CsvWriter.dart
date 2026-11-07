//@dart=2.11

import 'dart:io';

// import 'package:csv/csv.dart';
import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/TableWriterBase.dart';
import 'package:battlepus/csv-4.1.0/lib/csv.dart';
import 'package:path/path.dart' as PathUtil;
import 'package:utf/utf.dart';

class CsvWriter extends TableWriterBase {

  @override
  void writeTable(ATable tbl , String filePath){
    var path = PathUtil.dirname(filePath);
    var dir = Directory(path);
    if (!dir.existsSync()){
      dir.createSync(recursive: true);
    }

    var f = File(filePath);


    List<List<dynamic>> lst = List<List<dynamic>>();
    var tmp = List<dynamic>();
    for(var col in tbl.columns){
      tmp.add(col.desc);
    }
    lst.add(tmp);

    tmp = List<dynamic>();
    for(var col in tbl.columns){
      tmp.add(col.noName?"":col.name);
    }
    lst.add(tmp);

    tmp = List<dynamic>();
    for(var col in tbl.columns){
      tmp.add(col.type);
    }
    lst.add(tmp);

    for(var row in tbl.rows){
      lst.add(row);
    }
    String csv = const ListToCsvConverter(fieldDelimiter: '\t' , textDelimiter:'"' , textEndDelimiter: '"').convert(lst);
    // csv +="\n";
    var bytes = encodeUtf16le(csv,true);
    f.writeAsBytesSync(bytes);

    // var str = "";
    // var first = true;
    // for(var col in tbl.columns){
    //   str += (!first?"\t":"") + col.desc.toString();
    //   first = false;
    // }
    // str += "\n";
    //
    // first = true;
    // for(var col in tbl.columns){
    //
    //   str += (!first?"\t":"") + col.name.toString();
    //   first = false;
    // }
    // str += "\n";
    //
    // first = true;
    // for(var col in tbl.columns){
    //
    //   str += (!first?"\t":"") + col.type.toString();
    //   first = false;
    // }
    // str += "\n";
    //
    // for(var row in tbl.rows){
    //   var first = true;
    //   for(var cell in row){
    //     str += (!first?"\t":"") + cell.toString();
    //     first = false;
    //   }
    //   str += "\n";
    // }
    // // f.writeAsStringSync(str);
    // var bytes = encodeUtf16(str);
    // f.writeAsBytesSync(bytes);

    return ;
  }
}