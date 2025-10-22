import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import '../../core/bloc/language_bloc.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/custom_gradient_button.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  AppLanguage _currentLanguage = AppLanguage.english;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Load current language
    context.read<LanguageBloc>().add(LoadLanguage());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LanguageBloc, LanguageState>(
        listener: (context, state) {
          if (state is LanguageLoaded) {
            setState(() {
              _currentLanguage = state.currentLanguage;
            });
            _animationController.forward();
          } else if (state is LanguageChanged) {
            setState(() {
              _currentLanguage = state.newLanguage;
            });
            _animationController.reset();
            _animationController.forward();
            
            // Navigate to next screen or show success message
            // TODO: Navigate to main screen
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: Stack(
            children: [

              // Background Widget
              Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        AssetsPath.screensBgImg,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: CustomGradientWidget(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.all(24.w),
                        ),
                      ),
                    )
                  ],
                ),
              ),
               Positioned(
                 top: 200.h,
                 left: 15.w,
                 right: 15.w,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       "Choose your Language",
                       style: AppTypography.inter22Bold.copyWith(fontSize: 34.sp),
                     ),
                     SizedBox(height: 16.h),
                     RichText(
                       text: TextSpan(
                         style: TextStyle(
                           fontSize: 16.sp,
                           color: Colors.white.withOpacity(0.9),
                           height: 1.5,
                         ),
                         children: [
                           TextSpan(
                               text: 'Select the ',
                             style: AppTypography.inter14Regular,
                           ),
                           TextSpan(
                             text: 'language',
                             style: AppTypography.inter14Medium.copyWith(color: const Color(0xFFFFA726),
                             )
                           ),
                           TextSpan(
                               text: ' you\'re most comfortable with to continue using the platform smoothly.',
                             style: AppTypography.inter14Regular,
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: 40.h),
                     
                     // Language selection boxes
                     Column(
                       children: [
                         _buildLanguageOption(
                           language: AppLanguage.gujarati,
                           isSelected: _currentLanguage == AppLanguage.gujarati,
                           onTap: () {
                             context.read<LanguageBloc>().add(ChangeLanguage(AppLanguage.gujarati));
                           },
                         ),
                         
                         SizedBox(height: 16.h),
                         
                         _buildLanguageOption(
                           language: AppLanguage.english,
                           isSelected: _currentLanguage == AppLanguage.english,
                           onTap: () {
                             context.read<LanguageBloc>().add(ChangeLanguage(AppLanguage.english));
                           },
                         ),
                       ],
                     ),
 
                   ],
                 ),
               ),

              Positioned(
                left: 15.w,
                right: 15.w,
                bottom: 15.h,
                child: CustomGradientButton(
                  text: "Continue with ${_currentLanguage.displayName}",
                  onPressed: () {
                    // Navigate to next screen or perform action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Continuing with ${_currentLanguage.displayName}'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // TODO: Navigate to main screen
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required AppLanguage language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected 
              ? Border.all(
                  color: const Color(0xFFC9FFA5).withOpacity(0.78), // #C9FFA599
                  width: 1,
                )
              : null,
          color: isSelected 
              ? AppColors.selectedBoxColor // Selected box color
              : AppColors.unSelectedBoxColor, // Unselected box color with 10% opacity
        ),
        child: Row(
          children: [
            // Selection indicator - only show when selected
            if (isSelected) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF4CAF50), // Green
                ),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
            ],
            
            // Language name
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 800),
              style: AppTypography.inter16Medium.copyWith(
                color: isSelected 
                    ? const Color(0xFFF5F5F5) // Dark white for selected
                    : const Color(0xFF747688), // Grey for unselected
              ),
              child: Text(language.displayName),
            ),
          ],
        ),
      ),
    );
  }
}
