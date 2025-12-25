import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/module_list_repository.dart';
import 'module_list_event.dart';
import 'module_list_state.dart';
import 'package:zifour_sourcecode/core/api_models/api_status.dart';

class ModuleListBloc extends Bloc<ModuleListEvent, ModuleListState> {
  final ModuleListRepository repository;

  ModuleListBloc({required this.repository}) : super(ModuleListInitial()) {
    on<FetchModuleList>((event, emit) async {
      emit(ModuleListLoading());

      final response = await repository.fetchModulesList(
        stuId: event.stuId,
        chapterId: event.chapterId,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        emit(ModuleListLoaded(response.data!.modulesList));
      } else {
        emit(ModuleListError(response.errorMsg ?? 'Failed to fetch modules'));
      }
    });
  }
}
