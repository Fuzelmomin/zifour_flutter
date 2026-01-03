// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleOrderResponse _$ModuleOrderResponseFromJson(Map<String, dynamic> json) =>
    ModuleOrderResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ModuleOrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModuleOrderResponseToJson(
        ModuleOrderResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ModuleOrderData _$ModuleOrderDataFromJson(Map<String, dynamic> json) =>
    ModuleOrderData(
      mdlsTrAmount: json['mdls_tr_amount'],
      odrId: json['odr_id'] as String,
      mdlsTrToken: json['mdls_tr_token'] as String,
    );

Map<String, dynamic> _$ModuleOrderDataToJson(ModuleOrderData instance) =>
    <String, dynamic>{
      'mdls_tr_amount': instance.mdlsTrAmount,
      'odr_id': instance.odrId,
      'mdls_tr_token': instance.mdlsTrToken,
    };
