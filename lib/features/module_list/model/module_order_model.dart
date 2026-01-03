import 'package:json_annotation/json_annotation.dart';

part 'module_order_model.g.dart';

@JsonSerializable()
class ModuleOrderResponse {
  final bool status;
  final String message;
  final ModuleOrderData? data;

  ModuleOrderResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ModuleOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$ModuleOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleOrderResponseToJson(this);
}

@JsonSerializable()
class ModuleOrderData {
  @JsonKey(name: 'mdls_tr_amount')
  final dynamic mdlsTrAmount;
  @JsonKey(name: 'odr_id')
  final String odrId;
  @JsonKey(name: 'mdls_tr_token')
  final String mdlsTrToken;

  ModuleOrderData({
    required this.mdlsTrAmount,
    required this.odrId,
    required this.mdlsTrToken,
  });

  factory ModuleOrderData.fromJson(Map<String, dynamic> json) =>
      _$ModuleOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleOrderDataToJson(this);
}
