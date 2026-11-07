



import 'package:json_annotation/json_annotation.dart';


part 'ExportConfig.g.dart';

@JsonSerializable()
class ExportConfig{
  @JsonKey(defaultValue: "")
  String name = "";
  @JsonKey(defaultValue: true)
  bool active = true;

  @JsonKey(defaultValue: "")
  String? defaultNodeExportPath ;
  @JsonKey(defaultValue: "")
  String? defaultGenExportPath ;

  /// 逻辑层节点的 gen/node 导出目录，留空时使用下面的默认路径
  @JsonKey(defaultValue: "")
  String? logicGenExportPath ;
  @JsonKey(defaultValue: "")
  String? logicNodeExportPath ;

  /// 逻辑层节点默认导出目录（相对导出根路径）
  static const String defaultLogicGenExportPath =
      r"..\..\Assets\Scripts\GameScripts\BattleScript\Logic\BehaviorTree\treeGen";
  static const String defaultLogicNodeExportPath =
      r"..\..\Assets\Scripts\GameScripts\BattleScript\Logic\BehaviorTree\treeNode";

  String get effectiveLogicGenExportPath =>
      (logicGenExportPath == null || logicGenExportPath!.isEmpty)
          ? defaultLogicGenExportPath
          : logicGenExportPath!;

  String get effectiveLogicNodeExportPath =>
      (logicNodeExportPath == null || logicNodeExportPath!.isEmpty)
          ? defaultLogicNodeExportPath
          : logicNodeExportPath!;

  @JsonKey(defaultValue: "")
  String? nodeCodeExportPath ;

  @JsonKey(defaultValue: "")
  String? logicNodeCodeExportPath ;
  @JsonKey(defaultValue: "")
  String? viewNodeCodeExportPath ;

  @JsonKey(defaultValue: "")
  String? codeExportPath ;

  @JsonKey(defaultValue: "")
  String? logicCodeExportPath ;

  @JsonKey(defaultValue: "")
  String? viewCodeExportPath ;

  @JsonKey(defaultValue: "")
  String? runtimeCodePath ;
  @JsonKey(defaultValue: "")
  String? templatePath ;

  @JsonKey(defaultValue: "")
  String baseCodeExportPath = "";

  @JsonKey(defaultValue: false)
  bool expandExport = false;

  ExportConfig();
  //此处与类名一致，由指令自动生成代码
  factory ExportConfig.fromJson(Map<String, dynamic> json) =>
      _$ExportConfigFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$ExportConfigToJson(this);
}