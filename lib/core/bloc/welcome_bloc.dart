import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Welcome Screen Model
class WelcomeContent {
  final String title;
  final String description;
  final String imagePath;
  final String? videoPath;
  final String? subtitle;

  const WelcomeContent({
    required this.title,
    required this.description,
    required this.imagePath,
    this.videoPath,
    this.subtitle,
  });
}

// Welcome Screen BLoC Events
abstract class WelcomeEvent {}

class LoadWelcomeContent extends WelcomeEvent {}

class LoadWelcomeContentWithData extends WelcomeEvent {
  final List<WelcomeContent> content;
  LoadWelcomeContentWithData(this.content);
}

class NextWelcomeScreen extends WelcomeEvent {}

class PreviousWelcomeScreen extends WelcomeEvent {}

class GoToWelcomeScreen extends WelcomeEvent {
  final int index;
  GoToWelcomeScreen(this.index);
}

// Welcome Screen BLoC States
abstract class WelcomeState {}

class WelcomeInitial extends WelcomeState {}

class WelcomeLoaded extends WelcomeState {
  final List<WelcomeContent> content;
  final int currentIndex;
  final bool canGoNext;
  final bool canGoPrevious;

  WelcomeLoaded({
    required this.content,
    required this.currentIndex,
    required this.canGoNext,
    required this.canGoPrevious,
  });
}

class WelcomeChanged extends WelcomeState {
  final int newIndex;
  final WelcomeContent currentContent;
  final List<WelcomeContent> content;
  final bool canGoNext;
  final bool canGoPrevious;

  WelcomeChanged({
    required this.newIndex,
    required this.currentContent,
    required this.content,
    required this.canGoNext,
    required this.canGoPrevious,
  });
}

// Welcome Screen BLoC
class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<LoadWelcomeContent>(_onLoadWelcomeContent);
    on<LoadWelcomeContentWithData>(_onLoadWelcomeContentWithData);
    on<NextWelcomeScreen>(_onNextWelcomeScreen);
    on<PreviousWelcomeScreen>(_onPreviousWelcomeScreen);
    on<GoToWelcomeScreen>(_onGoToWelcomeScreen);
  }

  void _onLoadWelcomeContent(LoadWelcomeContent event, Emitter<WelcomeState> emit) {
    final content = _getWelcomeContent();
    emit(WelcomeLoaded(
      content: content,
      currentIndex: 0,
      canGoNext: content.length > 1,
      canGoPrevious: false,
    ));
  }

  void _onLoadWelcomeContentWithData(
    LoadWelcomeContentWithData event,
    Emitter<WelcomeState> emit,
  ) {
    final content = event.content.isNotEmpty ? event.content : _getWelcomeContent();
    emit(WelcomeLoaded(
      content: content,
      currentIndex: 0,
      canGoNext: content.length > 1,
      canGoPrevious: false,
    ));
  }

  void _onNextWelcomeScreen(NextWelcomeScreen event, Emitter<WelcomeState> emit) {
    List<WelcomeContent> content;
    int currentIndex;
    
    if (state is WelcomeLoaded) {
      final currentState = state as WelcomeLoaded;
      content = currentState.content;
      currentIndex = currentState.currentIndex;
    } else if (state is WelcomeChanged) {
      final currentState = state as WelcomeChanged;
      content = currentState.content;
      currentIndex = currentState.newIndex;
    } else {
      content = _getWelcomeContent();
      currentIndex = 0;
    }
    
    final nextIndex = currentIndex + 1;
    if (nextIndex < content.length) {
      emit(WelcomeChanged(
        newIndex: nextIndex,
        currentContent: content[nextIndex],
        content: content,
        canGoNext: nextIndex < content.length - 1,
        canGoPrevious: nextIndex > 0,
      ));
    }
  }

  void _onPreviousWelcomeScreen(PreviousWelcomeScreen event, Emitter<WelcomeState> emit) {
    List<WelcomeContent> content;
    int currentIndex;
    
    if (state is WelcomeLoaded) {
      final currentState = state as WelcomeLoaded;
      content = currentState.content;
      currentIndex = currentState.currentIndex;
    } else if (state is WelcomeChanged) {
      final currentState = state as WelcomeChanged;
      content = currentState.content;
      currentIndex = currentState.newIndex;
    } else {
      content = _getWelcomeContent();
      currentIndex = 0;
    }
    
    final prevIndex = currentIndex - 1;
    if (prevIndex >= 0) {
      emit(WelcomeChanged(
        newIndex: prevIndex,
        currentContent: content[prevIndex],
        content: content,
        canGoNext: prevIndex < content.length - 1,
        canGoPrevious: prevIndex > 0,
      ));
    }
  }

  void _onGoToWelcomeScreen(GoToWelcomeScreen event, Emitter<WelcomeState> emit) {
    List<WelcomeContent> content;
    
    if (state is WelcomeLoaded) {
      content = (state as WelcomeLoaded).content;
    } else if (state is WelcomeChanged) {
      content = (state as WelcomeChanged).content;
    } else {
      content = _getWelcomeContent();
    }
    
    if (event.index >= 0 && event.index < content.length) {
      emit(WelcomeChanged(
        newIndex: event.index,
        currentContent: content[event.index],
        content: content,
        canGoNext: event.index < content.length - 1,
        canGoPrevious: event.index > 0,
      ));
    }
  }

  // Static content - can be made dynamic in future
  List<WelcomeContent> _getWelcomeContent() {
    return [
      const WelcomeContent(
        title: "Zidd is the First Step— Success Follows",
        description: "Join thousands of determined NEET & JEE aspirants who started with just one thing: Zidd (Unstoppable Determination).",
        imagePath: "assets/images/welcome1_img.png",
      ),
      const WelcomeContent(
        title: "Live Classes & Strategy from NEET/JEE Experts",
        description: "Get guidance, clarity, and motivation from the best—every step of the way",
        imagePath: "assets/images/welcome2_img.png",
      ),
      const WelcomeContent(
        title: "Master Every Concept with Smart MCQs",
        description: "Practice chapter-wise MCQs, compete in All India challenges, test your preparation with full-length test series, and learn smart solving tricks from your mentors in live classes with a pool of more than 40,000 MCQs.",
        imagePath: "assets/images/welcome3_img.png",
      ),
      const WelcomeContent(
        title: "Track, Compete, Win!",
        description: "MCQs, test series, leaderboards that push you forward—every week",
        imagePath: "assets/images/welcome4_img.png",
      ),
      const WelcomeContent(
        title: "Beti Kafi Hai",
        subtitle: "OUR SOCIAL INITIATIVE TO EMPOWER GIRLS",
        description: "All girl students are eligible for a 50% scholarship on any course they choose. Prepare. Compete. Succeed.",
        imagePath: "assets/images/welcome5_img.png",
      ),
    ];
  }
}
