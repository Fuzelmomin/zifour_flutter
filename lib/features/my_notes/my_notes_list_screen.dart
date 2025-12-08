import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/my_notes_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/utils/dialogs_utils.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/mcq_notes_list_bloc.dart';
import 'bloc/mcq_notes_delete_bloc.dart';

class MyNotesListScreen extends StatefulWidget {
  const MyNotesListScreen({super.key});

  @override
  State<MyNotesListScreen> createState() => _MyNotesListScreenState();
}

class _MyNotesListScreenState extends State<MyNotesListScreen> {
  late McqNotesListBloc _mcqNotesListBloc;
  late McqNotesDeleteBloc _mcqNotesDeleteBloc;

  String selectedFilter = "Practice MCQ";
  final filters = [
    "Practice MCQ",
    "All India Test Series",
    "Create Own Challenges",
    "Expert Challenge"
  ];

  @override
  void initState() {
    super.initState();
    _mcqNotesListBloc = McqNotesListBloc();
    _mcqNotesDeleteBloc = McqNotesDeleteBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mcqNotesListBloc.add(const McqNotesListRequested());
    });
  }

  @override
  void dispose() {
    _mcqNotesListBloc.close();
    _mcqNotesDeleteBloc.close();
    super.dispose();
  }

  void _showDeleteConfirmation(String mcqId) {
    DialogsUtils.confirmDialog(
      context,
      title: 'Delete Note?',
      message: 'Are you sure you want to delete this note?',
      negativeBtnName: 'Cancel',
      positiveBtnName: 'Delete',
      positiveClick: () {
        _mcqNotesDeleteBloc.add(
          McqNotesDeleteRequested(mcqId: mcqId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _mcqNotesListBloc),
        BlocProvider.value(value: _mcqNotesDeleteBloc),
      ],
      child: BlocListener<McqNotesDeleteBloc, McqNotesDeleteState>(
        listener: (context, deleteState) {
          if (deleteState.status == McqNotesDeleteStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  deleteState.data?.message ?? 'Note deleted successfully.',
                ),
                backgroundColor: AppColors.success,
              ),
            );
            // Refresh the notes list
            _mcqNotesListBloc.add(const McqNotesListRequested());
          } else if (deleteState.status == McqNotesDeleteStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  deleteState.errorMessage ?? 'Unable to delete note.',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: SafeArea(
          child: Stack(
            children: [
              // Background Decoration set
          
              Positioned.fill(
                child: Image.asset(
                  AssetsPath.signupBgImg,
                  fit: BoxFit.cover,
                ),
              ),
          
              // App Bar
              Positioned(
                  top: 20.h,
                  left: 15.w,
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.myNotes}',
                    isActionWidget: true,
                    actionWidget: PopupMenuButton<String>(
                      onSelected: (value) => setState(() => selectedFilter = value),
                      itemBuilder: (context) {
                        return filters
                            .map((e) => PopupMenuItem(value: e, child: Text(e)))
                            .toList();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFCF078A), // Pink
                              Color(0xFF5E00D8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFCF078A).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedFilter,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    actionClick: (){
          
                    },
                  )),
          
              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: BlocProvider.value(
                  value: _mcqNotesListBloc,
                  child: BlocBuilder<McqNotesListBloc, McqNotesListState>(
                    builder: (context, state) {
                      if (state.status == McqNotesListStatus.loading ||
                          state.status == McqNotesListStatus.initial) {
                        return SignupFieldBox(
                          child: _buildShimmerLoading(),
                        );
                      }

                      if (state.status == McqNotesListStatus.failure) {
                        return SignupFieldBox(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.errorMessage ?? 'Unable to load notes.',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () {
                                    _mcqNotesListBloc.add(
                                      const McqNotesListRequested(),
                                    );
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state.status == McqNotesListStatus.success) {
                        final notesList = state.data?.mcqNotesList ?? [];
                        if (notesList.isEmpty) {
                          return SignupFieldBox(
                            child: Center(
                              child: Text(
                                'No notes found.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          );
                        }

                        return BlocBuilder<McqNotesDeleteBloc, McqNotesDeleteState>(
                          builder: (context, deleteState) {
                            return SignupFieldBox(
                              child: ListView.builder(
                                itemCount: notesList.length,
                                padding: const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) {
                                  final note = notesList[index];
                                  return MyNotesItem(
                                    title: note.mcQuestion
                                        .replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                                    noteType: 'Practice MCQ',
                                    notesDes: note.mcDescription
                                        .replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                                    deleteClick: () {
                                      _showDeleteConfirmation(note.mcqId);
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      padding: const EdgeInsets.only(bottom: 20),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }
}
