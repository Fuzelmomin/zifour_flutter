import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/mentor/bloc/get_mentors_bloc.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_videos_list_screen.dart';
import 'package:zifour_sourcecode/features/mentor/model/mentors_list_model.dart' hide MentorItem;

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/mentor_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';

class MentorsListScreen extends StatefulWidget {
  MentorsListScreen({
    super.key,
  });

  @override
  State<MentorsListScreen> createState() => _MentorsListScreenState();
}

class _MentorsListScreenState extends State<MentorsListScreen> {
  bool _eventsLoaded = false;
  late GetMentorsBloc _mentorsBloc;

  @override
  void initState() {
    super.initState();
    _mentorsBloc = GetMentorsBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMentors();
    });
  }

  @override
  void dispose() {
    _mentorsBloc.close();
    super.dispose();
  }

  Future<void> _loadMentors() async {
    if (_eventsLoaded) return;
    _eventsLoaded = true;

    final userData = await UserPreference.getUserData();
    // if (userData != null && mounted) {
    //   final subId = userData.stuSubId?.isNotEmpty == true
    //       ? userData.stuSubId!
    //       : userData.stuStdId;
    //
    //   if (mounted) {
    //     _mentorsBloc.add(FetchMentors(subId: subId));
    //   }
    // }

    if (mounted) {
      _mentorsBloc.add(FetchMentors(subId: "1"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mentorsBloc,
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.darkBlue,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        AssetsPath.signupBgImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0.h,
                      left: 15.w,
                      right: 20.w,
                      child: CustomAppBar(
                        isBack: true,
                        title: '${AppLocalizations.of(context)?.mentors}',
                      ),
                    ),
                    Positioned(
                      top: 70.h,
                      left: 20.w,
                      right: 20.w,
                      bottom: 0,
                      child: BlocBuilder<GetMentorsBloc, GetMentorsState>(
                        builder: (context, state) {
                          if (state is GetMentorsLoading) {
                            return _buildShimmerLoading();
                          }

                          if (state is GetMentorsError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      _eventsLoaded = false;
                                      _loadMentors();
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is GetMentorsSuccess) {
                            final mentors = state.mentors;
                            if (mentors.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No mentors available',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: mentors.length,
                              padding: EdgeInsets.only(bottom: 20.h),
                              itemBuilder: (context, index) {
                                final mentor = mentors[index];
                                final item = {
                                  'name': mentor.name ?? '',
                                  'desc': mentor.description ?? '',
                                  'img': mentor.mtrImage ?? '',
                                };
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: MentorItem(
                                    item: item,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MentorsVideosListScreen(
                                            mentorId: mentor.mtrId ?? '',
                                            mentorName: mentor.name,
                                          ),
                                        ),
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
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 4,
      padding: EdgeInsets.only(bottom: 20.h),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: SignupFieldBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 80.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 100.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
