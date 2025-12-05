import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../courses/all_course_list_screen.dart';
import '../mentor/mentor_list_screen.dart';
import '../mentor/mentors_videos_list_screen.dart';
import '../subject/bloc/subject_bloc.dart';
import 'bloc/home_bloc.dart';
import 'home_screen.dart';
import 'mentors_screen.dart';
import 'modules_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final BehaviorSubject<int> _currentIndex = BehaviorSubject<int>.seeded(0);
  late final HomeBloc _homeBloc;
  late final SubjectBloc _subjectBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc();
    _subjectBloc = SubjectBloc();
    
    // Call subject API silently when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('API Call Subject:');
      _subjectBloc.add(const SubjectRequested(silent: false));
    });
  }

  @override
  void dispose() {
    _homeBloc.close();
    _subjectBloc.close();
    _currentIndex.close();
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      BlocProvider.value(
        value: _homeBloc,
        child: const HomeScreen(),
      ),
      MentorsListScreen(),
      const AllCoursesScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    _currentIndex.add(index);
    if (index == 0) {
      _homeBloc.add(const HomeRequested());
    }
  }

  // Public method to navigate to home from child screens
  void navigateToHome() {
    _onItemTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(value: _subjectBloc),
      ],
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.darkBlue,
            child: Stack(
              children: [
                // Positioned.fill(
                //   child: Image.asset(
                //     AssetsPath.dashboardBgImg,
                //     width: double.infinity,
                //     height: double.infinity,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Positioned.fill(
                  child: StreamBuilder<int>(
                    stream: _currentIndex.stream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      final currentIndex = snapshot.data ?? 0;
                      return _buildScreens()[currentIndex];
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: StreamBuilder<int>(
            stream: _currentIndex.stream,
            initialData: 0,
            builder: (context, snapshot) {
              final currentIndex = snapshot.data ?? 0;
              return Container(
                height: 70.h,
                width: double.infinity,
                color: AppColors.darkBlue2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      currentIndex: currentIndex,
                      icon: AssetsPath.svgSelHome,
                      unselectedIcon: AssetsPath.svgUnSelHome,
                      label: 'Home',
                      onTap: () => _onItemTapped(0),
                    ),
                    _buildNavItem(
                      index: 1,
                      currentIndex: currentIndex,
                      icon: AssetsPath.svgSelMentor,
                      unselectedIcon: AssetsPath.svgUnSelMentor,
                      label: 'Mentors',
                      onTap: () => _onItemTapped(1),
                    ),
                    _buildNavItem(
                      index: 2,
                      currentIndex: currentIndex,
                      icon: AssetsPath.svgSelModules,
                      unselectedIcon: AssetsPath.svgUnSelModules,
                      label: 'Course',
                      onTap: () => _onItemTapped(2),
                    ),
                    _buildNavItem(
                      index: 3,
                      currentIndex: currentIndex,
                      icon: AssetsPath.svgSelProfile,
                      unselectedIcon: AssetsPath.svgUnSelProfile,
                      label: 'Profile',
                      onTap: () => _onItemTapped(3),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required String icon,
    required String unselectedIcon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? icon : unselectedIcon,
              width: index == 0 && isSelected == false ? 20.h : 24.h,
              height: index == 0 && isSelected == false ? 20.h : 24.h,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.pinkColor
                    : Colors.white.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
