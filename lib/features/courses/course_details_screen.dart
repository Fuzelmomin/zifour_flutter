import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/courses/bloc/course_package_details_bloc.dart';
import 'package:zifour_sourcecode/features/courses/models/course_details_model.dart';
import 'package:zifour_sourcecode/features/courses/order_summery_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import 'models/course_package.dart';

class CourseDetailsScreen extends StatefulWidget {
  final CoursePackage package;
  const CourseDetailsScreen({
    super.key,
    required this.package
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadPackageDetails();
  }

  Future<void> _loadPackageDetails() async {
    print('_loadPackageDetails ${widget.package.id}');
    final userData = await UserPreference.getUserData();
    if (userData != null && mounted) {

      print('_loadPackageDetails ${widget.package.id}');
      context.read<CoursePackageDetailsBloc>().add(
            FetchPackageDetails(
              packageId: widget.package.id,
              studentId: '6',
            ),
          );
    }

    // context.read<CoursePackageDetailsBloc>().add(
    //   FetchPackageDetails(
    //     packageId: widget.package.id,
    //     studentId: '6',
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
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
                top: 40.h,
                left: 15.w,
                right: 20.w,
                child: CustomAppBar(
                  isBack: true,
                  title: 'Course',
                )),

            // Main Content with BLoC
            Positioned(
              top: 110.h,
              left: 0.w,
              right: 0.w,
              bottom: 0.h,
              child: BlocBuilder<CoursePackageDetailsBloc, CoursePackageDetailsState>(
                builder: (context, state) {
                  if (state is CoursePackageDetailsLoading) {
                    return const _LoadingView();
                  }

                  if (state is CoursePackageDetailsError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: _loadPackageDetails,
                    );
                  }

                  if (state is CoursePackageDetailsSuccess) {
                    return _SuccessView(
                      packageDetails: state.packageDetails,
                      initialPackage: widget.package,
                    );
                  }

                  return const _LoadingView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletPoint() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.circle, color: Color(0xffA259FF), size: 10),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model.",
              style: TextStyle(color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFF1B193D),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1.0
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 14)),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
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
          ),
          SizedBox(height: 15.h),
          ...List.generate(4, (i) => _ShimmerBulletPoint()),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Shimmer.fromColors(
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
          ),
        ],
      ),
    );
  }
}

class _ShimmerBulletPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: Shimmer.fromColors(
        baseColor: Colors.white.withOpacity(0.08),
        highlightColor: Colors.white.withOpacity(0.2),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.packageDetails,
    required this.initialPackage,
  });

  final PackageDetailsItem packageDetails;
  final CoursePackage initialPackage;

  @override
  Widget build(BuildContext context) {
    final descriptionList = packageDetails.description
            ?.split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList() ??
        [];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _CourseDetailsItem(packageDetails: packageDetails),
          ),
          SizedBox(height: 15.h),
          if (descriptionList.isNotEmpty)
            ...descriptionList.map((description) => _bulletPoint(description)),
          if (descriptionList.isEmpty)
            ...List.generate(4, (i) => _bulletPoint('')),

          const SizedBox(height: 20),

          SignupFieldBox(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "THIS COURSE INCLUDES",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                _infoRow(
                  "Video",
                  "${packageDetails.totalVideo ?? 0}",
                ),
                const SizedBox(height: 10),
                _infoRow(
                  "Test",
                  "${packageDetails.totalTests ?? 0}",
                ),
                const SizedBox(height: 10),
                _infoRow(
                  "Chapter",
                  "${packageDetails.totalChapter ?? 0}",
                ),
                const SizedBox(height: 10),
                _infoRow(
                  "Validity",
                  packageDetails.validity ?? 'N/A',
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          CustomGradientButton(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            text: 'Buy Now',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderSummeryScreen()),
              );
            },
          ),
          SizedBox(height: 70.h),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.circle, color: Color(0xffA259FF), size: 10),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.isNotEmpty
                  ? text
                  : "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model.",
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1B193D),
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseDetailsItem extends StatelessWidget {
  const _CourseDetailsItem({required this.packageDetails});

  final PackageDetailsItem packageDetails;

  @override
  Widget build(BuildContext context) {
    final label = packageDetails.label?.isNotEmpty == true
        ? packageDetails.label!
        : 'Best Selling';
    final title = packageDetails.name ?? 'Course Name';
    final testsText = '${packageDetails.totalTests ?? 0} Tests';
    final videosText = '${packageDetails.totalVideo ?? 0} Videos';
    final finalPrice = '₹ ${packageDetails.finalPrice?.split(" ")[1]}' ?? '₹ 00';
    final oldPrice = '₹ ${packageDetails.oldPrice?.split(" ")[1]}' ?? '₹ 00';
    final imageUrl = packageDetails.pkImage ?? '';

    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: _CourseImage(imageUrl: imageUrl),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFCF078A),
                        Color(0xFF5E00D8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCF078A).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  spacing: 10.w,
                  children: [
                    _iconLabelWidget(AssetsPath.svgFileText, testsText),
                    _iconLabelWidget(AssetsPath.svgPlayCircle, videosText),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  spacing: 5.w,
                  children: [
                    Text(
                      finalPrice,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (oldPrice != null && oldPrice.isNotEmpty)
                      Text(
                        oldPrice,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconLabelWidget(String iconPath, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFF4C4993),
        borderRadius: BorderRadius.all(Radius.circular(6.r)),
      ),
      child: Row(
        spacing: 7.w,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 15.h,
            height: 15.h,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseImage extends StatelessWidget {
  const _CourseImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        AssetsPath.trendingCourseImg,
        width: double.infinity,
        height: 140.h,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 140.h,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: double.infinity,
        height: 140.h,
        decoration: BoxDecoration(
          color: AppColors.pinkColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.image,
          color: AppColors.pinkColor,
          size: 40.sp,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        AssetsPath.trendingCourseImg,
        width: double.infinity,
        height: 140.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
