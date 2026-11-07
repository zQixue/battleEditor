//@dart=2.11
class ZhCnUtils {
  /// a str from outside inputing for handling
  String _str = '';
  static const String _zhCnRegStr = r'[\u4E00-\u9FFF]';

  ZhCnUtils(this._str);

  void setStr(String str) => _str = str;

  /// get chinese list from [_str]
  List<String> getZhCnList() {
    List<String> zhCnList = [];
    var regexp = RegExp('($_zhCnRegStr+)');

    regexp.allMatches(_str).forEach((_) {
      zhCnList.add(_.group(0));
    });

    return zhCnList;
  }

  /// get length that char is chinese in [_str]
  int getLenIsZhCnInStr() {
    int len = 0;
    for (var i = 0, l = _str.length; i < l; i++) {
      if (isCnZnChar(_str[i])) {
        len++;
      }
    }
    return len;
  }

  /// get length based chinese in [_str]
  ///
  /// one chinese equal to 1 length
  /// one not chinese equal to 0.5 length
  double getLenInStrByZhCn() {
    double len = 0;
    for (var i = 0, l = _str.length; i < l; i++) {
      len += isCnZnChar(_str[i]) ? 1 : 0.5;
    }
    return len;
  }

  /// get length based not chinese in [_str]
  ///
  /// one chinese equal to 2 length
  /// one not chinese equal to 1 length
  int getLenInStrByNotZhCn() {
    return (2 * getLenInStrByZhCn()).floor();
  }

  /// returns whether char is chinese or not
  static bool isCnZnChar(String char) {
    var regexp = RegExp('^$_zhCnRegStr\$');
    return regexp.hasMatch(char);
  }

  /// returns whether all char is chinese  in [_str] or not
  bool isAllChZnInStr() {
    var regexp = RegExp('^$_zhCnRegStr*\$');
    return regexp.hasMatch(_str);
  }

  /// returns whether having a char is chinese  in [_str] or not
  bool isHaveChZnInStr() {
    var regexp = RegExp(_zhCnRegStr);
    return regexp.hasMatch(_str);
  }
}
