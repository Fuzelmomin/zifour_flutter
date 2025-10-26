import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import 'home_screen.dart';
import 'mentors_screen.dart';
import 'modules_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BehaviorSubject<int> _currentIndex = BehaviorSubject<int>.seeded(0);

  final List<Widget> _screens = [
    const HomeScreen(),
    const MentorsScreen(),
    const ModulesScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _currentIndex.close();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _currentIndex.add(index);
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
                  return _screens[currentIndex];
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
                  label: 'Mentor Forum',
                  onTap: () => _onItemTapped(1),
                ),
                _buildNavItem(
                  index: 2,
                  currentIndex: currentIndex,
                  icon: AssetsPath.svgSelModules,
                  unselectedIcon: AssetsPath.svgUnSelModules,
                  label: 'Modules',
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
              width: 24.w,
              height: 24.h,
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
