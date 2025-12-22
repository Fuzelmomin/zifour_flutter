import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/utils/dialogs_utils.dart';
import '../../core/widgets/bookmark_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../core/services/mcq_type_service.dart';
import 'bloc/mcq_bookmark_list_bloc.dart';
import 'bloc/mcq_bookmark_delete_bloc.dart';

class BookmarkedListScreen extends StatefulWidget {
  const BookmarkedListScreen({super.key});

  @override
  State<BookmarkedListScreen> createState() => _BookmarkedListScreenState();
}

class _BookmarkedListScreenState extends State<BookmarkedListScreen> {
  late McqBookmarkListBloc _mcqBookmarkListBloc;
  late McqBookmarkDeleteBloc _mcqBookmarkDeleteBloc;
  final McqTypeService _mcqTypeService = McqTypeService();

  String selectedFilter = "Practice Mcq";

  @override
  void initState() {
    super.initState();
    _mcqBookmarkListBloc = McqBookmarkListBloc();
    _mcqBookmarkDeleteBloc = McqBookmarkDeleteBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mcqBookmarkListBloc.add(const McqBookmarkListRequested());
    });
  }

  @override
  void dispose() {
    _mcqBookmarkListBloc.close();
    _mcqBookmarkDeleteBloc.close();
    super.dispose();
  }

  String? _deletingMcqId;

  void _showDeleteConfirmation(String mcqId) {
    DialogsUtils.confirmDialog(
      context,
      title: 'Delete Bookmark?',
      message: 'Are you sure you want to delete this bookmark?',
      negativeBtnName: 'Cancel',
      positiveBtnName: 'Delete',
      positiveClick: () {
        _deletingMcqId = mcqId;
        _mcqBookmarkDeleteBloc.add(
          McqBookmarkDeleteRequested(mcqId: mcqId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _mcqBookmarkListBloc),
        BlocProvider.value(value: _mcqBookmarkDeleteBloc),
      ],
      child: BlocListener<McqBookmarkDeleteBloc, McqBookmarkDeleteState>(
        listener: (context, deleteState) {
          if (deleteState.status == McqBookmarkDeleteStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  deleteState.data?.message ?? 'Bookmark deleted successfully.',
                ),
                backgroundColor: AppColors.success,
              ),
            );
            // Remove item locally from list (no API call)
            if (_deletingMcqId != null) {
              _mcqBookmarkListBloc.add(McqBookmarkItemRemoved(mcqId: _deletingMcqId!));
              _deletingMcqId = null;
            }
          } else if (deleteState.status == McqBookmarkDeleteStatus.failure) {
            _deletingMcqId = null;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  deleteState.errorMessage ?? 'Unable to delete bookmark.',
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
                  top: 30.h,
                  left: 15.w,
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.bookmarked}',
                    isActionWidget: true,
                    actionWidget: PopupMenuButton<String>(
                      onSelected: (value) => setState(() => selectedFilter = value),
                      itemBuilder: (context) {
                        final mcqTypes = _mcqTypeService.mcqTypes;
                        return mcqTypes
                            .map((e) => PopupMenuItem(value: e.name, child: Text(e.name)))
                            .toList();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFCF078A), // Pink
                              Color(0xFF5E00D8)
                            ],
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
                    actionClick: () {},
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 100.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: BlocBuilder<McqBookmarkListBloc, McqBookmarkListState>(
                    builder: (context, state) {
                      if (state.status == McqBookmarkListStatus.loading ||
                          state.status == McqBookmarkListStatus.initial) {
                        return SignupFieldBox(
                          child: _buildShimmerLoading(),
                        );
                      }

                      if (state.status == McqBookmarkListStatus.failure) {
                        return SignupFieldBox(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.network(
                                  'https://lottie.host/b60fe9e0-8c77-4ece-b056-4d5aa54e53fa/KLlnG0PoUp.json',
                                  width: 180.w,
                                  height: 180.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.error_outline,
                                      size: 80.sp,
                                      color: Colors.white.withOpacity(0.3),
                                    );
                                  },
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  state.errorMessage ?? 'Unable to load bookmarks.',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () {
                                    _mcqBookmarkListBloc.add(
                                      const McqBookmarkListRequested(),
                                    );
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state.status == McqBookmarkListStatus.success) {
                        final bookmarkList = state.data?.mcqBookmarkList ?? [];
                        if (bookmarkList.isEmpty) {
                          return SignupFieldBox(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.network(
                                    'https://lottie.host/b60fe9e0-8c77-4ece-b056-4d5aa54e53fa/KLlnG0PoUp.json',
                                    width: 200.w,
                                    height: 200.h,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.bookmark_border,
                                        size: 80.sp,
                                        color: Colors.white.withOpacity(0.3),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No bookmarks found.',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Your bookmarked items will appear here.',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return BlocBuilder<McqBookmarkDeleteBloc, McqBookmarkDeleteState>(
                          builder: (context, deleteState) {
                            // Filter bookmarks based on selected filter
                            final filteredBookmarks = bookmarkList.where((bookmark) {
                              // Normalize both strings for comparison (case-insensitive)
                              final bookmarkType = bookmark.type.toLowerCase().trim();
                              final filter = selectedFilter.toLowerCase().trim();
                              return bookmarkType == filter;
                            }).toList();

                            // Show empty state if no bookmarks match the filter
                            if (filteredBookmarks.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.filter_alt_off,
                                      size: 80.sp,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No bookmarks found for "$selectedFilter"',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Try selecting a different filter.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return SignupFieldBox(
                              child: ListView.builder(
                                itemCount: filteredBookmarks.length,
                                padding: const EdgeInsets.only(bottom: 20),
                                itemBuilder: (context, index) {
                                  final bookmark = filteredBookmarks[index];
                                  return BookmarkItem(
                                    title: bookmark.mcQuestion
                                        .replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                                    description: bookmark.mcDescription
                                        .replaceAll(RegExp(r'\r\n&nbsp;'), ' '),
                                    bookmarkType: bookmark.type,
                                    deleteClick: () {
                                      _showDeleteConfirmation(bookmark.mcqId);
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
            height: 100.h,
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
