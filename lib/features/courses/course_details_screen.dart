import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/features/courses/bloc/course_package_details_bloc.dart';
import 'package:zifour_sourcecode/features/courses/models/course_details_model.dart';
import 'package:zifour_sourcecode/features/courses/order_summery_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/signup_field_box.dart';
import 'models/course_package.dart';

class CourseDetailsScreen extends StatefulWidget {
  final CoursePackage package;
  const CourseDetailsScreen({
    super.key,
    required this.package,
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
    final userData = await UserPreference.getUserData();
    if (userData != null && mounted) {
      context.read<CoursePackageDetailsBloc>().add(
            FetchPackageDetails(
              packageId: widget.package.id,
              studentId: '6',
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: SafeArea(
          child: Stack(
          children: [
            // Background Decoration
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
              right: 20.w,
              child: CustomAppBar(
                isBack: true,
                title: 'Course Details',
              ),
            ),

            // Main Content with BLoC
            Positioned(
              top: 90.h,
              left: 0.w,
              right: 0.w,
              bottom: 0.h,
              child: BlocBuilder<CoursePackageDetailsBloc,
                  CoursePackageDetailsState>(
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Loading View
// ═══════════════════════════════════════════════════════════════

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
                height: 220.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ...List.generate(6, (i) => _ShimmerBulletPoint()),
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

// ═══════════════════════════════════════════════════════════════
// Error View
// ═══════════════════════════════════════════════════════════════

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

// ═══════════════════════════════════════════════════════════════
// Success View — Main Content
// ═══════════════════════════════════════════════════════════════

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.packageDetails,
    required this.initialPackage,
  });

  final PackageDetailsItem packageDetails;
  final CoursePackage initialPackage;

  // ── Static fallback data ──
  static const List<String> _defaultWhyJoinItems = [
    'Crystal-clear concept building from basics',
    'MCQs by expert faculty to improve retention',
    'Dedicated Challenger Zone for exam readiness',
    'Personal mentorship for Guidance & mindset',
    'Free access to All India Test Series',
    'AI based performance analysis',
  ];

  static const List<String> _featureTags = [
    'NCERT Focused',
    'Latest NEET Pattern',
    'Expert Mentors',
  ];

  static const List<Map<String, String>> _freeDemoItems = [
    {'left': 'Sample Video Lectures', 'right': 'Change Zone Access'},
    {'left': 'Practice MCQs', 'right': 'Test Series Preview'},
    {'left': 'Challenger Zone Access', 'right': ''},
  ];

  @override
  Widget build(BuildContext context) {
    // Parse description for "Why join" items
    final descriptionList = packageDetails.description
            ?.split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList() ??
        [];
    final whyJoinItems =
        descriptionList.isNotEmpty ? descriptionList : _defaultWhyJoinItems;

    // Parse prices with fallbacks
    final finalPrice = _extractPrice(packageDetails.finalPrice, '4555');
    final oldPrice = _extractPrice(packageDetails.oldPrice, '6000');

    return Stack(
      children: [
        // ── Scrollable Content ──
        Positioned.fill(
          bottom: 70.h,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Banner Card
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                //   child: _HeroBannerCard(
                //     packageDetails: packageDetails,
                //     finalPrice: finalPrice,
                //     oldPrice: oldPrice,
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _CourseDetailsItem(packageDetails: packageDetails),
                ),

                SizedBox(height: 14.h),

                // 2. Feature Tags Row
                _FeatureTagsRow(tags: _featureTags),
                SizedBox(height: 8.h),

                // Divider
                Divider(
                  color: Colors.white.withOpacity(0.15),
                  thickness: 1,
                  indent: 20.w,
                  endIndent: 20.w,
                ),
                SizedBox(height: 8.h),

                // 3. "Why should you join this course?" Section
                _WhyJoinSection(items: whyJoinItems),
                SizedBox(height: 8.h),

                // Divider
                Divider(
                  color: Colors.white.withOpacity(0.15),
                  thickness: 1,
                  indent: 20.w,
                  endIndent: 20.w,
                ),
                SizedBox(height: 14.h),

                // 4. Review Section
                _buildReviewSection(),
                SizedBox(height: 14.h),

                // Divider
                Divider(
                  color: Colors.white.withOpacity(0.15),
                  thickness: 1,
                  indent: 20.w,
                  endIndent: 20.w,
                ),
                SizedBox(height: 14.h),

                // 5. "Try Before You Enroll" Section
                _TryBeforeEnrollSection(items: _freeDemoItems),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),

        // 6. Bottom Price Bar
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomPriceBar(
            price: finalPrice,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrderSummeryScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  String _extractPrice(String? rawPrice, String fallback) {
    if (rawPrice == null || rawPrice.isEmpty) return fallback;
    // Try to extract just the numeric part
    final cleaned = rawPrice
        .replaceAll('₹', '')
        .replaceAll('&#8377;', '')
        .replaceAll('&nbsp;', '')
        .replaceAll(' ', '')
        .trim();
    return cleaned.isNotEmpty ? cleaned : fallback;
  }

  /// ── Student Reviews Section ──
  Widget _buildReviewSection() {
    final List<Map<String, dynamic>> reviews = [
      {
        'name': 'Student',
        'image': 'https://randomuser.me/api/portraits/men/32.jpg',
        'rating': 4.0,
      },
      {
        'name': 'Student',
        'image': 'https://randomuser.me/api/portraits/women/44.jpg',
        'rating': 5.0,
      },
      {
        'name': 'Student',
        'image': 'https://randomuser.me/api/portraits/women/68.jpg',
        'rating': 5.0,
      },
      {
        'name': 'Student',
        'image': 'https://randomuser.me/api/portraits/women/65.jpg',
        'rating': 4.0,
      },
      {
        'name': 'Student',
        'image': 'https://randomuser.me/api/portraits/men/75.jpg',
        'rating': 5.0,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Rating Header ──
          Row(
            children: [
              Icon(Icons.star_rounded,
                  color: const Color(0xFFFFD700), size: 22.sp),
              SizedBox(width: 6.w),
              Text(
                'Rated 4.9 / 5  by NEET Aspirants',
                style: AppTypography.inter16SemiBold,
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // ── Horizontally scrollable review cards ──
          SizedBox(
            height: 155.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _ReviewCard(
                  name: review['name'] as String,
                  imageUrl: review['image'] as String,
                  rating: review['rating'] as double,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 1. Hero Banner Card
// ═══════════════════════════════════════════════════════════════

class _HeroBannerCard extends StatelessWidget {
  const _HeroBannerCard({
    required this.packageDetails,
    required this.finalPrice,
    required this.oldPrice,
  });

  final PackageDetailsItem packageDetails;
  final String finalPrice;
  final String oldPrice;

  @override
  Widget build(BuildContext context) {
    final label = (packageDetails.label?.isNotEmpty == true)
        ? packageDetails.label!
        : 'NEW';
    final courseName = packageDetails.name ?? '11th NEET English';
    final exam = packageDetails.exam ?? 'NEET';
    final imageUrl = packageDetails.pkImage ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A0E3E),
            Color(0xFF150B3A),
            Color(0xFF0D0730),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E00D8).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Purple glow effect in background ──
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF5E00D8).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Course Image (Right side) ──
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              child: _HeroCourseImage(imageUrl: imageUrl),
            ),
          ),

          // ── Content (Left side) ──
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCF078A), Color(0xFFE8196E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCF078A).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                // Course Name
                SizedBox(
                  width: 180.w,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                      children: _buildCourseNameSpans(courseName),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Subtitle
                Text(
                  'Regular Batch',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 12.h),

                // Price Row
                Row(
                  children: [
                    Text(
                      '₹ $finalPrice',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '₹ $oldPrice',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Tags Row
                Row(
                  children: [
                    // "For NEET 2026 Aspirants" Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.white.withOpacity(0.12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'For $exam 2026 Aspirants',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // "Limited-time offer" Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFFFD700),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        'Limited-time offer',
                        style: TextStyle(
                          color: const Color(0xFFFFD700),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
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

  /// Build rich text spans — makes "th" superscript if name has pattern like "11th"
  List<TextSpan> _buildCourseNameSpans(String name) {
    final regExp = RegExp(r'(\d+)(th|st|nd|rd)\b', caseSensitive: false);
    final match = regExp.firstMatch(name);

    if (match != null) {
      final before = name.substring(0, match.start);
      final number = match.group(1)!;
      final suffix = match.group(2)!;
      final after = name.substring(match.end);

      return [
        if (before.isNotEmpty) TextSpan(text: before),
        TextSpan(text: number),
        TextSpan(
          text: suffix,
          style: TextStyle(
            fontSize: 12.sp,
            fontFeatures: const [FontFeature.superscripts()],
          ),
        ),
        TextSpan(text: after),
      ];
    }

    return [TextSpan(text: name)];
  }
}

class _HeroCourseImage extends StatelessWidget {
  const _HeroCourseImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Image.asset(
        AssetsPath.trendingCourseImg,
        width: 140.w,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 140.w,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        width: 140.w,
        color: AppColors.pinkColor.withOpacity(0.15),
        child: Center(
          child: Icon(Icons.image,
              color: AppColors.pinkColor.withOpacity(0.5), size: 40.sp),
        ),
      ),
      errorWidget: (_, __, ___) => Image.asset(
        AssetsPath.trendingCourseImg,
        width: 140.w,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 2. Feature Tags Row
// ═══════════════════════════════════════════════════════════════

class _FeatureTagsRow extends StatelessWidget {
  const _FeatureTagsRow({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tags.asMap().entries.map((entry) {
            final index = entry.key;
            final tag = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check,
                    color: AppColors.white, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  tag,
                  style: AppTypography.inter12Medium.copyWith(
                    color: Colors.white.withOpacity(0.85)
                  ),
                ),
                if (index < tags.length - 1) SizedBox(width: 14.w),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 3. "Why should you join this course?" Section
// ═══════════════════════════════════════════════════════════════

class _WhyJoinSection extends StatelessWidget {
  const _WhyJoinSection({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why should you join this course?',
            style: AppTypography.inter16SemiBold,
          ),
          SizedBox(height: 12.h),
          ...items.map((item) => _GreenCheckItem(text: item)),
        ],
      ),
    );
  }
}

class _GreenCheckItem extends StatelessWidget {
  const _GreenCheckItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check,
              color: AppColors.green.withOpacity(0.6), size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: AppTypography.inter12Regular.copyWith(
                  color: Colors.white.withOpacity(0.85),
                fontSize: 13.sp
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 4. Review Card
// ═══════════════════════════════════════════════════════════════

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.name,
    required this.imageUrl,
    required this.rating,
  });

  final String name;
  final String imageUrl;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Stack(
          children: [
            // ── Full-width Profile Image ──
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.pinkColor.withOpacity(0.15),
                  child: Center(
                    child: Icon(Icons.person,
                        color: AppColors.pinkColor, size: 40.sp),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.pinkColor.withOpacity(0.15),
                  child: Center(
                    child: Icon(Icons.person,
                        color: AppColors.pinkColor, size: 40.sp),
                  ),
                ),
              ),
            ),

            // ── Bottom Gradient Overlay ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.selectedBoxColor.withOpacity(0.85),
                    ],
                    stops: const [0.0, 0.5],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Star Rating ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return Icon(
                          i < rating.round()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: const Color(0xFFFFD700),
                          size: 13.sp,
                        );
                      }),
                    ),
                    SizedBox(height: 4.h),

                    // ── Label ──
                    Text(
                      '$name\nfeedback',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 5. "Try Before You Enroll" Section
// ═══════════════════════════════════════════════════════════════

class _TryBeforeEnrollSection extends StatelessWidget {
  const _TryBeforeEnrollSection({required this.items});

  final List<Map<String, String>> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text('🎁', style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Try Before You Enroll – Free Demo Includes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Two-column grid
          ...items.map((row) {
            final left = row['left'] ?? '';
            final right = row['right'] ?? '';
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  // Left column
                  Expanded(
                    child: _GreenCheckItem(text: left),
                  ),
                  // Right column (only if non-empty)
                  if (right.isNotEmpty)
                    Expanded(
                      child: _GreenCheckItem(text: right),
                    ),
                  if (right.isEmpty) const Expanded(child: SizedBox()),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 6. Bottom Price Bar
// ═══════════════════════════════════════════════════════════════

class _BottomPriceBar extends StatelessWidget {
  const _BottomPriceBar({
    required this.price,
    required this.onPressed,
  });

  final String price;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1A0E3E),
            Color(0xFF2A1060),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Price
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '₹',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  TextSpan(
                    text: price,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),

            // Unlock Button
            Expanded(
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
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
                        color: const Color(0xFFCF078A).withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Unlock Full Course',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    final finalPrice = '₹ ${packageDetails.finalPrice?.split(" ")[1]}' ??
        '₹ 00';
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
