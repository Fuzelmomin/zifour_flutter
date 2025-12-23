import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/india_test_series/test_analysis_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../practics_mcq/question_mcq_screen.dart';
import 'bloc/online_test_paper_bloc.dart';

class AllIndiaTestSeriesScreen extends StatefulWidget {
  const AllIndiaTestSeriesScreen({super.key});

  @override
  State<AllIndiaTestSeriesScreen> createState() => _AllIndiaTestSeriesScreenState();
}

class _AllIndiaTestSeriesScreenState extends State<AllIndiaTestSeriesScreen> {
  late OnlineTestPaperBloc _onlineTestPaperBloc;

  @override
  void initState() {
    super.initState();
    _onlineTestPaperBloc = OnlineTestPaperBloc();
    _onlineTestPaperBloc.add(const OnlineTestPaperRequested(pkId: '1'));
  }

  @override
  void dispose() {
    _onlineTestPaperBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _onlineTestPaperBloc,
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
                      title: 'All India Test Series',
                    )),
                // Main Content with BLoC
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BlocBuilder<OnlineTestPaperBloc, OnlineTestPaperState>(
                          builder: (context, state) {
                            if (state.status == OnlineTestPaperStatus.loading ||
                                state.status == OnlineTestPaperStatus.initial) {
                              return _buildShimmerLoading();
                            }

                            if (state.status == OnlineTestPaperStatus.failure) {
                              return Center(
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
                                      state.errorMessage ?? 'Unable to load test papers.',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16.h),
                                    ElevatedButton(
                                      onPressed: () {
                                        _onlineTestPaperBloc.add(
                                          const OnlineTestPaperRequested(pkId: '1'),
                                        );
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (state.status == OnlineTestPaperStatus.success) {
                              final paperList = state.data?.generalPaperList ?? [];
                              if (paperList.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        size: 80.sp,
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'No test papers found.',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: paperList.length,
                                itemBuilder: (context, index) {
                                  final paper = paperList[index];
                                  return testCard(
                                    title: paper.gPaName,
                                    status: "Attempt Now", // Placeholder or from API if available
                                    statusColor: Colors.orange,
                                    icon: Icons.error,
                                    iconColor: Colors.orange,
                                    date: "Test ID: ${paper.gPaId}", // Adjust according to requirements
                                    duration: "3 Hours", // Placeholder
                                    onItemClick: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuestionMcqScreen(
                                            type: "Start Exam",
                                            mcqType: "4", // 4 = All India Test Series MCQ Type
                                            pkId: "1",
                                            paperId: paper.gPaId,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                      CustomGradientButton(
                        text: 'View Past Test Result',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TestAnalysisScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
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
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
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

  Widget testCard({
    required String title,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconColor,
    required String date,
    required String duration,
    required Function() onItemClick,
  }) {
    return InkWell(
      onTap: (){
        onItemClick();
      },
      child: SignupFieldBox(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),

            // Status Row
            Row(
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Date + Time Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xff0D0B2F).withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "•",
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

