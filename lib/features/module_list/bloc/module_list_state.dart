import '../model/module_list_model.dart';

abstract class ModuleListState {}

class ModuleListInitial extends ModuleListState {}

class ModuleListLoading extends ModuleListState {}

class ModuleListLoaded extends ModuleListState {
  final List<ModuleModel> modules;

  ModuleListLoaded(this.modules);
}

class ModuleListError extends ModuleListState {
  final String errorMessage;

  ModuleListError(this.errorMessage);
}
