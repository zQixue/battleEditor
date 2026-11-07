//@dart=2.11

import 'package:battlepus/common/DartCommon.dart';

class TextFilter{
  String _filter = "";

  set filter(String name) {
    _filter = name;
    update();
  }
  String get filter {
    return _filter;
  }



  List<String> _filterItems = List<String>();

  void update(){
    _filterItems.clear();
    if (DartCommon.isEmpty(filter)){
      return ;
    }
    var filterValue = _filter?.toLowerCase()?.trim();
    _filterItems = buildFilter(filterValue);
  }

  List<String> buildFilter(String filterStr) {
    var res = filterStr.split(RegExp(r'\s+'));
    for(int  i = 0 ;i< res.length;++i){
      res[i] = res[i].trim().replaceAll("#32", " ");
    }
    // print(res);
    return res;
  }

  bool passFilter(String targetStr){
    var filterStr = _filterItems;
    if (filterStr == null || filterStr.length<=0) return true;
    for(var sstr in filterStr){
      if (targetStr.toLowerCase().indexOf(sstr)<0) return false;
    }
    return true;
  }
}