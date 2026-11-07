//@dart=2.11


import 'package:battlepus/MultiLans/TableReader/ATable.dart';
import 'package:battlepus/MultiLans/TableReader/TableWriterBase.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excelIO;

class XlsxWriter extends TableWriterBase {

  @override
  void writeTable(ATable tbl , String filePath){
    // var path = PathUtil.dirname(filePath);
    // var dir = Directory(path);
    // if (!dir.existsSync()){
    //   dir.createSync(recursive: true);
    // }
    //
    // final excelIO.Workbook workbook = new excelIO.Workbook();
    // var sheet = workbook.worksheets.add();
    // sheet.name = "texts";
    // for(int i = 0 ; i < tbl.columns.length ;++i){
    //   var col = tbl.columns[i];
    //   sheet.getRangeByIndex(1,i +1).setText(col.desc);
    //   sheet.getRangeByIndex(2,i +1).setText(col.name);
    //   sheet.getRangeByIndex(3,i +1).setText(col.type);
    // }
    //
    // int rowIndex = 4;
    // tbl.rows.forEach((element) {
    //   for(int i = 0 ; i < tbl.columns.length ;++i){
    //     var col = tbl.columns[i];
    //     sheet.getRangeByIndex(rowIndex,i +1).setText(tbl.getRowCellByColName(element, col.name));
    //
    //   }
    //   ++rowIndex;
    // });
    //
    //
    //
    // final List<int> bytes = workbook.saveAsStream();
    // try {
    //   File(path).writeAsBytesSync(bytes);
    // }
    // catch(e){
    //   workbook.dispose();
    //   throw e ;
    // }
    // //Dispose the workbook.
    // workbook.dispose();
  }
}