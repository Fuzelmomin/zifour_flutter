import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/features/courses/bloc/course_package_details_bloc.dart';
import 'package:zifour_sourcecode/features/courses/course_details_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import 'bloc/course_packages_bloc.dart';
import 'models/course_package.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CoursePackagesBloc()..add(const CoursePackagesRequested()),
      child: const _AllCoursesView(),
    );
  }
}

class _AllCoursesView extends StatelessWidget {
  const _AllCoursesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AssetsPath.signupBgImg,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40.h,
              left: 15.w,
              right: 20.w,
              child: CustomAppBar(
                isBack: true,
                title: 'Course',
              ),
            ),
            Positioned(
              top: 110.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: BlocBuilder<CoursePackagesBloc, CoursePackagesState>(
                builder: (context, state) {
                  switch (state.status) {
                    case CoursePackagesStatus.loading:
                    case CoursePackagesStatus.initial:
                      return const _PackagesShimmer();
                    case CoursePackagesStatus.failure:
                      return _PackagesError(
                        message:
                            state.errorMessage ?? 'Unable to load packages.',
                        onRetry: () {
                          context
                              .read<CoursePackagesBloc>()
                              .add(const CoursePackagesRequested());
                        },
                      );
                    case CoursePackagesStatus.empty:
                      return const _EmptyPackages();
                    case CoursePackagesStatus.success:
                      return _PackagesList(packages: state.packages);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackagesList extends StatelessWidget {
  const _PackagesList({required this.packages});

  final List<CoursePackage> packages;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: packages.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final package = packages[index];
        return CourseItem(
          package: package,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => CoursePackageDetailsBloc(),  // <-- your BLoC instance
                  child: CourseDetailsScreen(
                    package: package,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PackagesShimmer extends StatelessWidget {
  const _PackagesShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 20.h),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: 16.h),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.white.withOpacity(0.2),
        child: Container(
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}

class _PackagesError extends StatelessWidget {
  const _PackagesError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyPackages extends StatelessWidget {
  const _EmptyPackages();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No packages available right now.',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
