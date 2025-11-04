import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/widgets/mentors_item_widget.dart';
import 'package:zifour_sourcecode/core/widgets/title_view_row_widget.dart';
import 'package:zifour_sourcecode/features/al_based_performance/al_based_performanc_screen.dart';
import 'package:zifour_sourcecode/features/courses/all_course_list_screen.dart';
import 'package:zifour_sourcecode/features/india_test_series/all_india_test_series_screen.dart';
import 'package:zifour_sourcecode/features/live_class/live_class_screen.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_list_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/be_ziddi_item_widget.dart';
import '../../core/widgets/courses_item_widget.dart';
import '../../core/widgets/custom_drawer.dart';
import '../../core/widgets/home_app_bar.dart';
import '../../core/widgets/home_option_widget.dart';
import '../../core/widgets/home_options_item.dart';
import '../../l10n/app_localizations.dart';
import '../challenger_zone/challenger_zone_screen.dart';
import '../doubts/ask_doubts_screen.dart';
import '../learning_course/learning_course_screen.dart';
import '../practics_mcq/practice_subject_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  final BehaviorSubject<int> _bannerIndex = BehaviorSubject<int>.seeded(0);

  List<Map<String, dynamic>> _banners = [];
  List<Map<String, dynamic>> _trendingCourses = [];
  List<Map<String, dynamic>> _mentors = [];
  Map<String, dynamic> _userProfile = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initDummyData();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _bannerIndex.close();
    super.dispose();
  }

  void _initDummyData() {
    _banners = [
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1973'
      },
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170'
      },
      {
        'imageUrl':
            'https://images.unsplash.com/photo-1535982330050-f1c2fb79ff78?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1074'
      },
    ];

    _trendingCourses = [
      {
        'id': 1,
        'title': 'Flutter Development',
        'imageUrl': 'https://picsum.photos/300/200?random=10',
        'rating': 4.8,
        'studentsCount': 1250
      },
      {
        'id': 2,
        'title': 'React Native Course',
        'imageUrl': 'https://picsum.photos/300/200?random=11',
        'rating': 4.6,
        'studentsCount': 980
      },
      {
        'id': 3,
        'title': 'Node.js Masterclass',
        'imageUrl': 'https://picsum.photos/300/200?random=12',
        'rating': 4.9,
        'studentsCount': 1500
      },
      {
        'id': 4,
        'title': 'Python Programming',
        'imageUrl': 'https://picsum.photos/300/200?random=13',
        'rating': 4.7,
        'studentsCount': 2100
      },
    ];

    _mentors = [
      {
        'id': 1,
        'name': 'John Doe',
        'imageUrl': 'https://i.pravatar.cc/150?img=1',
        'designation': 'Senior Developer',
        'rating': 4.9
      },
      {
        'id': 2,
        'name': 'Jane Smith',
        'imageUrl': 'https://i.pravatar.cc/150?img=2',
        'designation': 'Tech Lead',
        'rating': 4.8
      },
      {
        'id': 3,
        'name': 'Mike Johnson',
        'imageUrl': 'https://i.pravatar.cc/150?img=3',
        'designation': 'Full Stack Dev',
        'rating': 4.7
      },
      {
        'id': 4,
        'name': 'Sarah Williams',
        'imageUrl': 'https://i.pravatar.cc/150?img=4',
        'designation': 'Senior Engineer',
        'rating': 4.9
      },
    ];

    _userProfile = {
      'name': 'John Doe',
      'profileImageUrl': 'https://i.pravatar.cc/150?img=5',
    };
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _banners.isNotEmpty) {
        final currentIndex = (_bannerIndex.value + 1) % _banners.length;
        _bannerIndex.add(currentIndex);
        _bannerController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startBannerAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AssetsPath.homeImgBg,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w)
                            .copyWith(top: 20.h),
                    child: HomeAppBar(
                      profileImg: 'https://i.pravatar.cc/150?img=3',
                      profileClick: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildBannerSection(),
                  SizedBox(height: 15.h),
                  _buildTrendingCoursesSection(),
                  SizedBox(height: 20.h),
                  _buildMentorsSection(),
                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [BeZiddiItemWidget()],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildHomeOptionSection(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    if (_banners.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.selectedBoxColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            'No banners available',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (index) {
              _bannerIndex.add(index);
            },
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl: '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.selectedBoxColor,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      AssetsPath.BannerImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        _buildBannerIndicators(),
      ],
    );
  }

  Widget _buildBannerIndicators() {
    return StreamBuilder<int>(
      stream: _bannerIndex.stream,
      initialData: 0,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: currentIndex == index ? 24.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? AppColors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingCoursesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleViewRowWidget(
            title: '${AppLocalizations.of(context)?.trendingCourse}',
            subTitle: '${AppLocalizations.of(context)?.viewAll}',
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCoursesScreen()),
              );
            },
          ),
          SizedBox(height: 10.h),
          if (_trendingCourses.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.selectedBoxColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'No trending courses available',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _trendingCourses.length,
                itemBuilder: (context, index) {
                  return CoursesItemWidget();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeOptionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.h,
        children: [
          HomeOptionsItem(
            title: 'Start your free trial',
            subTitle: 'Free 7-Day Access to Excellence',
            imagePath: AssetsPath.svgFreeTrial,
          ),
          HomeOptionsItem(
            title: 'Live Classes',
            subTitle: 'Learn Live With Experts',
            imagePath: AssetsPath.svgLiveClass,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiveClassScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'My Courses',
            subTitle: 'Live Classes Learn Live with mentors',
            imagePath: AssetsPath.svgMyCourse,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LearningCourseScreen()),
              );
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllCoursesScreen()),
              );*/
            },
          ),
          HomeOptionsItem(
            title: 'Practice MCQS',
            subTitle: 'Master Every Concept',
            imagePath: AssetsPath.svgPractice,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PracticeSubjectScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'All india Challenger Zone',
            subTitle: 'Compete Across India',
            imagePath: AssetsPath.svgChallenger,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChallengerZoneScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'Test Series',
            subTitle: 'Full Syllabus Mock Test',
            imagePath: AssetsPath.svgTestSeries,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllIndiaTestSeriesScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'AI Based Performance Analysis',
            subTitle: 'Know Your Complete Progress',
            imagePath: AssetsPath.svgAIBase,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AiBasedPerformanceScreen()),
              );
            },
          ),
          HomeOptionsItem(
            title: 'Ask Your Doubts',
            subTitle: 'Get Expert Solutions',
            imagePath: AssetsPath.svgAskDoubts,
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AskDoubtsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMentorsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleViewRowWidget(
            title: 'Z Mentors',
            subTitle: '${AppLocalizations.of(context)?.viewAll}',
            itemClick: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentorsListScreen()),
              );
            },
          ),
          SizedBox(height: 10.h),
          if (_mentors.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.selectedBoxColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'No mentors available',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 200.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _mentors.length,
                itemBuilder: (context, index) {
                  return MentorsItemWidget();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMentorCard(Map<String, dynamic> mentor, int index) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColors.selectedBoxColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: CachedNetworkImage(
                imageUrl: mentor['profileImageUrl'],
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.pinkColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.pinkColor,
                    size: 40.sp,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.pinkColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    color: AppColors.pinkColor,
                    size: 40.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              mentor['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              mentor['designation'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.pinkColor,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  mentor['rating'].toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
