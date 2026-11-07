//@dart=2.11


import 'package:battlepus/MultiLans/TableReader/ATableColumn.dart';
import 'package:battlepus/MultiLans/TableReader/TableManager.dart';

class ATable {
  String sheetName = "";
  List<ATableColumn> columns ;
  List<String> _idColumns ;
  List<List> rows ;
  Map<String,bool> removeRowKeys = Map<String,bool>() ;
  Map<String,bool> addRowKeys = Map<String,bool>() ;

  Map<String,bool> modifiedRowKeys = Map<String,bool>() ;
  Map<String,ATableColumn> modifiedColumns = Map<String,ATableColumn>() ;

  Map<String , ATableColumn> _name2ColumnMap;
  Map<String , ATableColumn> get name2ColumnMap{
    if (_name2ColumnMap == null){
      _name2ColumnMap = Map<String , ATableColumn>();
      for(var col in columns){
        _name2ColumnMap[col.name] = col;
      }
    }
    return _name2ColumnMap;
  }

  List<String> get idColumns {
    if(_idColumns == null){
      buildId2RowMap();
    }
    return _idColumns;
  }

  Map<String , ATableColumn> _lowName2ColumnMap;
  Map<String , ATableColumn> get lowName2ColumnMap{
    if (_lowName2ColumnMap == null){
      _lowName2ColumnMap = Map<String , ATableColumn>();
      for(var col in columns){
        _lowName2ColumnMap[col.name.toLowerCase()] = col;
      }
    }
    return _lowName2ColumnMap;
  }

  List addRow(String key , double prio){
    var r = List();
    rows.add(r);
    if (_id2RowMap == null){
      _id2RowMap = Map<String , List>();
    }
    _id2RowMap[key] = r;
    for(var col in columns){
      r.add("");
    }
    if (addRowKeys == null){
      addRowKeys = Map<String,bool>();
    }
    addRowKeys[key] = true;
    if (rowPrios == null){
      rowPrios = Map<String,double> ();
    }
    rowPrios[key] = prio;
    return r;
  }

  Map<String,double> rowPrios = Map<String,double>();

  void calcColumnPrio(){
    var unit = 100.0;
    var prio = 100.0;
    for(var col in columns){
      // if (col.name == null || col.name.trim() =="") continue;
      col.prio = prio;
      prio += unit;
    }
  }
  ATableColumn getColByDesc(String desc){
    for(var col in columns){
      if (col.desc == desc){
        return col;
      }
    }
    return null;
  }
  void calcColumnPrioWith(ATable baseTable){
    for(var col in columns){
      col.prio = -1;
    }
    for(var col in columns){
      if (col.name == null || col.name.trim() =="") {
        var descCol = baseTable.getColByDesc(col.desc);
        if (descCol != null){
          col.prio = descCol.prio;
        }
        continue;
      };
      var colBase = baseTable.name2ColumnMap[col.name];
      if (colBase != null) {
        col.prio = colBase.prio;
      }
    }

    // for(var col in columns){
    //   print("1 main adjust ${col.name} ${col.prio}");
    // }

    double lastPrio = -1;
    for(int i = 0 ; i < columns.length; ++i){
      var col = columns[i];
      if (col.prio == -1){
        double nextPrio = -1 ;
        for(int j = i+1; j < columns.length;++j){
          var colNext = columns[j];
          if (colNext.prio != -1){
            nextPrio = colNext.prio;
            break;
          }
        }
        if (lastPrio >=0 && nextPrio >= 0){
          col.prio = (lastPrio + nextPrio)/2;
        }
        else if (lastPrio >=0 && nextPrio<0){
          col.prio = lastPrio + 100;
        }
        else if (nextPrio >=0 && lastPrio<0){
          col.prio = nextPrio / 2;
        }
        else{
          col.prio = 100.0;
        }

      }
      lastPrio = col.prio;
    }

    // for(var col in columns){
    //   print("2 main adjust ${col.name} ${col.prio}");
    // }
    //row prio
    rowPrios.clear();
    rowPrios.addAll(baseTable.rowPrios);
    lastPrio = -1;
    int firstValid = null;
    for(int i = 0 ; i < rows.length ; ++i){
      var key = getRowKey(rows[i]);
      if (key.trim() != "") {
        var prio = rowPrios[key]??-1;
        if (prio == -1){
          double nextPrio = -1 ;
          var start = i +1;
          if (firstValid != null && firstValid>=start){
            start = firstValid;
          }
          for(int j = start; j < rows.length;++j){
            var key2 = getRowKey(rows[j]);
            var prio2  = rowPrios[key2]??-1;
            firstValid = j;
            if (prio2 != -1){
              nextPrio = prio2;
              break;
            }
          }
          if (lastPrio >=0 && nextPrio >= 0){
            prio = (lastPrio + nextPrio)/2;
          }
          else if (lastPrio >=0 && nextPrio<0){
            prio = lastPrio + 100;
          }
          else if (nextPrio >=0 && lastPrio<0){
            prio = nextPrio / 2;
          }
          else{
            prio = 100.0;
          }

          rowPrios[key] = prio;

        }
        lastPrio = prio;
      }
    }
  }

  ATableColumn addColumn(ATableColumn col){
    if (_name2ColumnMap == null){
      _name2ColumnMap = Map<String , ATableColumn>();
    }
    var colExist = _name2ColumnMap[col.name];
    if (colExist != null){
      colExist..name = col.name..type = col.type ..desc = col.desc..prio = col.prio;
      colExist.added = true;
      return colExist;
    }
    if (columns == null){
      columns = List<ATableColumn>();
    }
    ATableColumn newCol = ATableColumn()..name = col.name..type = col.type ..desc = col.desc..prio = col.prio ..noName = col.noName;
    columns.add(newCol);
    newCol.index = columns.length-1;
    if (rows == null){
      rows = List<List>();
    }
    for (var r in rows){
      r.add("");
    }
    _name2ColumnMap[newCol.name] = newCol;
    newCol.added = true;
    return newCol;
  }

  void removeCol(ATableColumn col) {
    var rcol = _name2ColumnMap[col.name];
    if (rcol == null) return ;
    rcol.deleted = true;
  }

  int getCount(){
    return rows.length;
  }
  getRowCellByColName(List row , String name){
    if (row == null) return null;
    var col = name2ColumnMap[name];
    if (col == null) return null;
    if (col.index <0 || col.index >= row.length) return null;
    return row[col.index];
  }
  getCellByColName(int row , String name){
    var col = name2ColumnMap[name];
    if (col == null) return null;
    return getCell(row , col.index);
  }
  getCellByLowColName(int row , String name){
    var col = lowName2ColumnMap[name.toLowerCase()];
    if (col == null) return null;
    return getCell(row , col.index);
  }

  int getColumnCount(){
    return name2ColumnMap.length;
  }

  getCell(int row , int col){
    if (row <0 || row >= rows.length) return null;
    var r = rows[row];
    if (col <0 || col >= r.length) return null;
    return r[col];
  }

  getCellByRow(List row , int col){
    return row[col];
  }
//  static List<ATableColumn> tableColumns(File f){
//    if (f.path.toLowerCase().endsWith(".csv")) return List<ATableColumn>();
//    if (f.path.toLowerCase().endsWith(".xlsx")) return List<ATableColumn>();
//    return null;
//  }
  //只针对多语言表格使用，格式比较固定
  Map<String , String> getValueByKeyName(List<String> names){
    Map<String , String> list = new Map<String , String>();
    rows.forEach((row) {
      var key = row[0];
      if(names.contains(key)){
        list[key] = row[1];
      }
    });
    return list;
  }


  Map<String , List> _id2RowMap;
  Map<String , List> get id2RowMap{
    if (_id2RowMap == null){
      buildId2RowMap();
    }


    return _id2RowMap;
  }

  String getRowKey(List row){

      var key = "";
      for(var kn in _idColumns){
        var colName = getRowCellByColName(row , kn);
        key+= key ==""?"$colName":"_$colName";
      }
      return key;
  }

  List<ATableColumn> getIdColumns(){
    var res = List<ATableColumn>();
    for(var key in _idColumns){
      var col = name2ColumnMap[key];
      res.add(col);
    }
    return res;
  }

  void buildId2RowMapByKeys(List<String> keys) {
    _id2RowMap = Map<String , List>();
    _idColumns = keys;
    rowPrios.clear();

    // bool bMulti = false;
    // for(int i = 0 ; i < columns.length ; ++i){
    //   var col = columns[i];
    //   if (i == 0 || bMulti){
    //     _idColumns.add(col.name);
    //   }
    //   bMulti = col.type.endsWith("|m");
    // }
    double prio = 0;
    double unit = 100.0;

    for(int i = 0 ; i < rows.length ; ++i){
      var key = "";
      for(var kn in _idColumns){
        var colName = getCellByColName(i , kn);
        key+= key ==""?"$colName":"_$colName";
      }
      if (key.trim() != "") {
        _id2RowMap[key] = rows[i];

        rowPrios[key] = prio;
        prio += unit;
      }
    }
  }

  void buildId2RowMap() {
    _id2RowMap = Map<String , List>();
    _idColumns = List<String>();
    bool bMulti = false;
    for(int i = 0 ; i < columns.length ; ++i){
      var col = columns[i];
      if (i == 0 || bMulti){
        _idColumns.add(col.name);
      }
      bMulti = col.type.endsWith("|m");

      if (col.name == "TranslateID"){
        _idColumns = [col.name];
        bMulti = false;
        break;
      }
    }

    for(int i = 0 ; i < rows.length ; ++i){
      var key = "";
      for(var kn in _idColumns){
        var colName = getCellByColName(i , kn);

        key+=key==""?"$colName":"_$colName";
      }
      if (key.trim() != "") {
        _id2RowMap[key] = rows[i];
      }
    }


  }

  bool setRowCellByColName(List row, String name, contentSrc) {
    var col = name2ColumnMap[name];
    if (col == null) return false;
    if (col.index <0 || col.index >= row.length) return false;
    row[col.index] = contentSrc??"";
    return true;
  }

  void save(String path) {
    TableManager.writeTable(this, path);
  }

  void removeRow(String key) {
    removeRowKeys[key] = true;
  }

  void remove(String key) {
    var row = _id2RowMap[key];
    if (row == null) return ;
    rows.remove(row);
    _id2RowMap.remove(key);
  }

  void printTable(){
    for(var col in columns) {
      print("${col.name} ${col.index}");
    }
    for(var r in rows){
      var a = getRowCellByColName(r, "SkillName_M");
      var b = getRowCellByColName(r, "MainLost");
      var c = getRowCellByColName(r, "MainTp1");

      print("$a $b $c");
    }
  }

  ATable normalize() {
    ATable res = ATable();
    res.columns = new List<ATableColumn>();

    for(var col in columns){
      if (col.deleted && !col.added){
        continue;
      }
      res.columns.add(col);
    }
    // res.columns.addAll(columns);
    res.columns.sort((a,b){
      if(a.prio == b.prio) return 0;
      return a.prio>b.prio?1:-1;
    });

    res.rows = List<List>() ;
    for(var row in rows){
      var newRow = List();
      for(var col in res.columns){
        // print(col.name);
        newRow.add(getCellByRow(row, col.index));
      }
      // print(row);
      // print(newRow);
      res.rows.add(newRow);
    }
    // print(rowPrios);
    // print(res.rows);
    res.rows.sort((a,b){
      var pa = rowPrios[getRowKey(a)];
      var pb = rowPrios[getRowKey(b)];
      if(pa == pb) return 0;
      return pa>pb?1:-1;
    }
    );
    // print(res.rows);
    res.buildId2RowMapByKeys(_idColumns);
    // print(res.rows);
    return res;
  }

  Map convertMap(){
    Map res = Map();
    Map columnsMap = Map();
    columns.forEach((element) {
      columnsMap[element.name] = {"name" : element.name , "type":element.type , "desc" : element.desc};
    });
    res["columns"] = columnsMap;
    List outRows = List();

    rows.forEach((trow) {
      Map aRow = Map();
      columns.forEach((element) {
        aRow[element.name] = getRowCellByColName(trow, element.name);

      });
      outRows.add(aRow);
    });
    res["rows"] = outRows;

    return res;
  }

}