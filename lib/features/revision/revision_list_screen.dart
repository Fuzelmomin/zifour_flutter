import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/dialogs_utils.dart';
import 'package:zifour_sourcecode/features/revision/bloc/revision_bloc.dart';
import 'package:zifour_sourcecode/features/revision/create_revision_screen.dart';
import 'package:zifour_sourcecode/features/revision/widgets/revision_item_widget.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../l10n/app_localizations.dart';

class RevisionListScreen extends StatefulWidget {
  const RevisionListScreen({super.key});

  @override
  State<RevisionListScreen> createState() => _RevisionListScreenState();
}

class _RevisionListScreenState extends State<RevisionListScreen> {
  late RevisionBloc _revisionBloc;

  @override
  void initState() {
    super.initState();
    _revisionBloc = RevisionBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revisionBloc.add(const RevisionListRequested());
    });
  }

  @override
  void dispose() {
    _revisionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _revisionBloc,
      child: BlocListener<RevisionBloc, RevisionState>(
        listener: (context, state) {
          if (state.status == RevisionStatus.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.deleteMessage ?? 'Deleted successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state.status == RevisionStatus.deleteFailure ||
              state.status == RevisionStatus.failure) {
            String? errorMsg = state.errorMessage;
            if (errorMsg != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMsg),
                  backgroundColor: AppColors.error,
                ),
              );
            }
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
                  /// Background
                  Positioned.fill(
                    child: Image.asset(
                      AssetsPath.signupBgImg,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// App Bar
                  Positioned(
                    top: 20.h,
                    left: 15.w,
                    right: 5.w,
                    child: CustomAppBar(
                      isBack: true,
                      title: 'Revision List',
                    ),
                  ),

                  /// Main Content
                  Positioned(
                    top: 90.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 0,
                    child: BlocBuilder<RevisionBloc, RevisionState>(
                      builder: (context, state) {
                        if (state.status == RevisionStatus.loading ||
                            state.status == RevisionStatus.initial) {
                          return _buildShimmerLoading();
                        }

                        if (state.status == RevisionStatus.failure &&
                            (state.data?.plannerList.isEmpty ?? true)) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 60.sp,
                                  color: Colors.white24,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  state.errorMessage ?? 'Failed to load revisions',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () {
                                    _revisionBloc.add(const RevisionListRequested(
                                        forceRefresh: true));
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        final list = state.data?.plannerList ?? [];

                        if (list.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SvgPicture.asset(
                                //   AssetsPath.icNoData, // Assuming this exists or using a fallback
                                //   width: 150.w,
                                //   height: 150.h,
                                //   color: Colors.white10,
                                // ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No revision planners found.',
                                  style: TextStyle(
                                    color: Colors.white24,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: list.length,
                          padding: EdgeInsets.only(bottom: 80.h),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final planner = list[index];
                            return RevisionItemWidget(
                              planner: planner,
                              onDelete: () {
                                DialogsUtils.confirmDialog(
                                  context,
                                  title: 'Delete Revision',
                                  message:
                                      'Are you sure you want to delete this revision planner?',
                                  positiveBtnName: 'Delete',
                                  negativeBtnName: 'Cancel',
                                  positiveClick: () {
                                    _revisionBloc.add(RevisionItemDeleted(
                                        plnrId: planner.plnrId));
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Floating Button
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 190.w,
            height: 48.h,
            child: CustomGradientArrowButton(
              text: 'Add Revision Plan',
              isLoading: false,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateRevisionScreen(),
                  ),
                );

                if (result == true) {
                  _revisionBloc.add(const RevisionListRequested(forceRefresh: true));
                }
              },
            ),
          ),
        ),
      ),
    );
    }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.05),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            margin: EdgeInsets.only(bottom: 15.h),
            height: 140.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        );
      },
    );
  }
}
