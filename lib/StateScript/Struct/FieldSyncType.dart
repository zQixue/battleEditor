//@dart=2.11

enum FieldSyncType {
  Normal ,//普通同步
  ServerAuth,//服务器权威
  ClientAuth,//客户端权威
}

String getFieldSyncTypeShowString(FieldSyncType val){
  switch(val){
    case FieldSyncType.Normal:
      return "普通";
    case FieldSyncType.ServerAuth:
      return "服务器权威";
    case FieldSyncType.ClientAuth:
      return "客户端上报";
  }
}

int getFieldSyncTypePriority(FieldSyncType val){
  switch(val){
    case FieldSyncType.Normal:
      return 256;
    case FieldSyncType.ServerAuth:
      return 32;
    case FieldSyncType.ClientAuth:
      return 16;
  }
}