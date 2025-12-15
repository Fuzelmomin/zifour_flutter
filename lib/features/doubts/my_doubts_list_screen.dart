import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_doubts_item.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../l10n/app_localizations.dart';
import '../doubts/ask_doubts_screen.dart';
import 'bloc/doubts_list_bloc.dart';
import 'model/doubts_list_model.dart';

class MyDoubtsListScreen extends StatefulWidget {
  const MyDoubtsListScreen({super.key});

  @override
  State<MyDoubtsListScreen> createState() => _MyDoubtsListScreenState();
}

class _MyDoubtsListScreenState extends State<MyDoubtsListScreen> {
  late final DoubtsListBloc _doubtsListBloc;

  String selectedFilter = "All";

  final List<String> filters = [
    "All",
    "Physics",
    "Chemistry",
    "Biology",
    "Maths",
  ];

  @override
  void initState() {
    super.initState();
    _doubtsListBloc = DoubtsListBloc()..add(DoubtsListRequested());
  }

  @override
  void dispose() {
    _doubtsListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _doubtsListBloc,
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
                    title: AppLocalizations.of(context)?.myDoubts ?? '',
                    isActionWidget: true,
                    actionWidget: PopupMenuButton<String>(
                      onSelected: (value) {
                        setState(() => selectedFilter = value);
                      },
                      itemBuilder: (context) {
                        return filters
                            .map(
                              (e) => PopupMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                            .toList();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFCF078A),
                              Color(0xFF5E00D8),
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
                          children: const [
                            Text(
                              "Filter",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Main Content
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 10.h,
                  child: BlocBuilder<DoubtsListBloc, DoubtsListState>(
                    builder: (context, state) {
                      if (state is DoubtsListLoading) {
                        return SignupFieldBox(
                          padding: const EdgeInsets.all(15),
                          child: _buildShimmerLoading(),
                        );
                      }

                      if (state is DoubtsListError) {
                        return SignupFieldBox(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 48.sp,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  state.message,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<DoubtsListBloc>()
                                        .add(DoubtsListRequested());
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is DoubtsListSuccess) {
                        List<DoubtModel> list = state.data.doubtsList;

                        if (selectedFilter != "All") {
                          list = list
                              .where(
                                (e) => e.subject == selectedFilter,
                          )
                              .toList();
                        }

                        if (list.isEmpty) {
                          return SignupFieldBox(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    color:
                                    AppColors.white.withOpacity(0.5),
                                    size: 48.sp,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No doubts found',
                                    style: TextStyle(
                                      color: AppColors.white
                                          .withOpacity(0.7),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SignupFieldBox(
                          padding: const EdgeInsets.all(15),
                          child: ListView.separated(
                            itemCount: list.length,
                            physics: const BouncingScrollPhysics(),
                            padding:
                            const EdgeInsets.only(bottom: 20),
                            itemBuilder: (context, index) {
                              final doubt = list[index];
                              final isReplied =
                                  doubt.dbtStatus.toLowerCase() !=
                                      'pending';

                              return MyDoubtsItem(
                                title: doubt.dbtMessage,
                                isReplied: isReplied,
                              );
                            },
                            separatorBuilder: (_, __) => Container(
                              height: 0.8,
                              margin:
                              EdgeInsets.symmetric(vertical: 10.h),
                              color: AppColors.white.withOpacity(0.2),
                            ),
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Floating Button
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120.w,
              height: 40.h,
              child: CustomGradientArrowButton(
                text: AppLocalizations.of(context)?.askDoubts ?? '',
                isLoading: false,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AskDoubtsScreen(),
                    ),
                  );

                  if (!mounted) return;

                  if (result == true) {
                    _doubtsListBloc.add(DoubtsListRequested());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      itemCount: 5,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.white.withOpacity(0.08),
          highlightColor: Colors.white.withOpacity(0.2),
          child: Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
    );
  }
}
