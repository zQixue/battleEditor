//@dart=2.11
import 'package:flutter/material.dart';
import 'package:battlepus/common/ThemeCenter.dart';
import 'package:battlepus/common/text_editor.dart';
import 'package:battlepus/common/DartCommon.dart';

typedef String GetFilterTargetCallback<T>(T obj);
typedef void OnFilterResult<T>(List<T> objs);

class FilterBar<T> extends StatefulWidget {
  final List<T> inputObjects ;
  final GetFilterTargetCallback<T> onGetFilterTarget;
  final OnFilterResult<T> onFilterResult;
  FilterBar({Key key,this.inputObjects , this.onGetFilterTarget , this.onFilterResult}) : super(key: key);

  @override
  _FilterBarState<T>  createState() => _FilterBarState<T>();
}

class _FilterBarState<T>  extends State<FilterBar<T>> {
  String _filterString ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 6, 4, 2),
      color: ThemeCenter.systemTheme.scaffoldBackgroundColor,

      child: Row(
        children: [
          Icon(Icons.search , size: 20, color: ThemeCenter.mainTextStepColor(6),),
          Expanded(child: Container(

            child:TextEditor(
              textStyle: ThemeCenter.mainTextStyle(step: 8 , fontSize: 14),
              initValue: _filterString,
              onChanged: (v){
                _filterString = v;

                if (!DartCommon.isEmpty(_filterString)){
                  buildMultiFilter(_filterString);

                  var res = widget.inputObjects.where((element){
                    print(element);
                    var tgtStr = widget.onGetFilterTarget(element);
                    print(tgtStr);
                    bool bingo = doFilter(tgtStr);
                    return bingo;
                  }).toList();

                  widget.onFilterResult(res);
                }
              },
            ) ,
          ),)
        ],
      ),
    );
  }

  List<List<String>> mfilters = List<List<String>>();
  void buildMultiFilter(String filter){
    var f = filter.trim().toLowerCase();
    mfilters.clear();
    if (DartCommon.isEmpty(f)) return ;

    var pls = f.split("|");
    for(var pl in pls){
      if (DartCommon.isEmpty(pl.trim())) return ;
      var andpls = pl.split("+");
      if (andpls.length>0){
        for(var i = andpls.length -1;i>=0;--i){
          var v = andpls[i].trim();
          if (DartCommon.isEmpty(v)){
            andpls.removeAt(i);
            continue;
          }
          andpls[i] = v;
        }
        if (andpls.length>0) {
          mfilters.add(andpls);
        }
      }

    }
  }

  bool doFilter(String tgt){
    if (mfilters.length <=0) return true;
    // print(mfilters);
    tgt = tgt.toLowerCase();
    for(var lst in mfilters){
      var bingo = true;
      for(var str in lst){
        bingo &= tgt.indexOf(str)>=0;
        if (!bingo) break;
      }

      if (bingo) return true;
    }

    return false;
  }
}