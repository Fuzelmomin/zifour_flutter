import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../repository/module_order_repository.dart';
import 'module_order_event.dart';
import 'module_order_state.dart';

class ModuleOrderBloc extends Bloc<ModuleOrderEvent, ModuleOrderState> {
  final ModuleOrderRepository repository;

  ModuleOrderBloc({required this.repository}) : super(ModuleOrderInitial()) {
    on<SubmitModuleOrder>(_onSubmitModuleOrder);
  }

  Future<void> _onSubmitModuleOrder(
    SubmitModuleOrder event,
    Emitter<ModuleOrderState> emit,
  ) async {
    emit(ModuleOrderLoading());
    try {
      final response = await repository.submitModuleOrder(
        stuId: event.stuId,
        mdlId: event.mdlId,
        name: event.name,
        mobile: event.mobile,
        pincode: event.pincode,
        address: event.address,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        emit(ModuleOrderSuccess(response.data!));
      } else {
        emit(ModuleOrderError(response.errorMsg ?? 'Failed to submit order'));
      }
    } catch (e) {
      emit(ModuleOrderError(e.toString()));
    }
  }
}
