import '../model/module_order_model.dart';

abstract class ModuleOrderState {
  const ModuleOrderState();
}

class ModuleOrderInitial extends ModuleOrderState {}

class ModuleOrderLoading extends ModuleOrderState {}

class ModuleOrderSuccess extends ModuleOrderState {
  final ModuleOrderResponse response;

  const ModuleOrderSuccess(this.response);
}

class ModuleOrderError extends ModuleOrderState {
  final String message;

  const ModuleOrderError(this.message);
}
