abstract class ModuleListEvent {}

class FetchModuleList extends ModuleListEvent {
  final String stuId;
  final String chapterId;

  FetchModuleList({
    required this.stuId,
    required this.chapterId,
  });
}
