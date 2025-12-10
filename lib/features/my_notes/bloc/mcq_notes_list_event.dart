part of 'mcq_notes_list_bloc.dart';

abstract class McqNotesListEvent {
  const McqNotesListEvent();
}

class McqNotesListRequested extends McqNotesListEvent {
  const McqNotesListRequested();
}

class McqNotesItemRemoved extends McqNotesListEvent {
  final String mcqId;
  const McqNotesItemRemoved({required this.mcqId});
}

