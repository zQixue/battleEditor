//@dart=2.11

class BlockyTypes {
  static const int BT_BLOCK = 0x1; //语句块，积木
  static const int BT_EXPR = 0x2; //表达式，圆角
  static const int BT_CONDITION = 0x4; //条件表达式，菱形
  static const int BT_VAR = 0x8; //表达式，圆角
  static const int BT_CONST = 1<<4; //表达式，圆角
  static const int BT_METHOD = 1<<5; //agent函数
  static const int BT_COMMENT = 1<<6; //注释
}

enum BlockyVarTypes {
  BVT_INT,
  BVT_FLOAT,
  BVT_BOOL,
  BVT_STRING,
}