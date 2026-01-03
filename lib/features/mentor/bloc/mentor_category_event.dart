part of 'mentor_category_bloc.dart';

abstract class MentorCategoryEvent {
  const MentorCategoryEvent();
}

class MentorCategoryRequested extends MentorCategoryEvent {
  final bool silent;
  final bool updateService;

  const MentorCategoryRequested({
    this.silent = false,
    this.updateService = true,
  });
}
