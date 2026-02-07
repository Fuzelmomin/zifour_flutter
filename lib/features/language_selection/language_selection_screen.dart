import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import '../../core/bloc/language_bloc.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../../core/api_models/medium_model.dart';
import '../../core/presentation/pages/no_internet_screen.dart';
import '../welcome/new_welcome_screen.dart';
import '../welcome/welcome_screen.dart';
import '../welcome/bloc/walkthrough_bloc.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  AppLanguage? _currentLanguage;
  List<MediumModel> _availableMediums = [];

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
    
    // Fetch languages from API
    context.read<LanguageBloc>().add(FetchLanguages());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        // Show NoInternetScreen if there's no internet
        if (state is NoInternetState) {
          return NoInternetScreen(
            onRetry: () {
              context.read<LanguageBloc>().add(FetchLanguages());
            },
            message: 'Please check your internet connection to load available languages.',
          );
        }
        
        // Show the normal language selection screen
        return _buildLanguageSelectionScreen(context);
      },
    );
  }

  Widget _buildLanguageSelectionScreen(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<LanguageBloc, LanguageState>(
          listener: (context, state) {
            if (state is LanguagesFetched) {
              setState(() {
                _availableMediums = state.mediums;
                _currentLanguage = state.currentLanguage ?? AppLanguage.english;
                // currentMedium is now available in state.currentMedium if needed
              });
              _animationController.forward();
            } else if (state is LanguageLoaded) {
              setState(() {
                _currentLanguage = state.currentLanguage;
                if (state.mediums != null) {
                  _availableMediums = state.mediums!;
                }
              });
              _animationController.forward();
            } else if (state is LanguageChanged) {
              setState(() {
                _currentLanguage = state.newLanguage;
                if (state.mediums != null) {
                  _availableMediums = state.mediums!;
                }
                // state.newMedium contains the selected MediumModel with med_id
              });
              _animationController.reset();
              _animationController.forward();
              
              // Navigate to next screen or show success message
              // TODO: Navigate to main screen
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
            } else if (state is LanguageError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.darkBlue,
            child: SafeArea(
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
                            AppLocalizations.of(context)!.chooseLanguage,
                            style: AppTypography.inter22Bold.copyWith(fontSize: 34.sp),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            AppLocalizations.of(context)!.selectLanguage,
                            style: AppTypography.inter14Regular.copyWith(
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 40.h),
                         
                         // Language selection boxes - Dynamic from API
                         BlocBuilder<LanguageBloc, LanguageState>(
                           builder: (context, state) {
                             if (state is LanguageLoading) {
                               return CustomLoadingWidget.inline(
                                 type: LoadingType.circle,
                                 color: AppColors.pinkColor,
                                 size: 50.0.sp,
                                 message: 'Loading languages...',
                               );
                             }
                             
                             if (_availableMediums.isEmpty) {
                               return Center(
                                 child: Padding(
                                   padding: EdgeInsets.all(20.h),
                                   child: Text(
                                     'No languages available',
                                     style: AppTypography.inter14Regular.copyWith(
                                       color: Colors.white.withOpacity(0.7),
                                     ),
                                   ),
                                 ),
                               );
                             }
                             
                             return Column(
                               children: _availableMediums.map((medium) {
                                 final appLanguage = AppLanguage.fromMediumModel(medium);
                                 final isSelected = appLanguage != null && 
                                     _currentLanguage != null && 
                                     _currentLanguage == appLanguage;
                                 
                                 return Padding(
                                   padding: EdgeInsets.only(bottom: 16.h),
                                   child: _buildMediumOption(
                                     medium: medium,
                                     isSelected: isSelected,
                                     onTap: () {
                                       context.read<LanguageBloc>().add(
                                         SelectLanguageFromMedium(medium),
                                       );
                                     },
                                   ),
                                 );
                               }).toList(),
                             );
                           },
                         ),
               
                       ],
                     ),
                   ),
              
                  Positioned(
                    left: 15.w,
                    right: 15.w,
                    bottom: 15.h,
                    child: CustomGradientArrowButton(
                      text: "${AppLocalizations.of(context)!.continueWith} ${_currentLanguage?.displayName ?? 'English'}",
                      onPressed: _currentLanguage == null ? null : () {
                        // Navigate to welcome screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => WalkthroughBloc(),
                              child: const NewWelcomeScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediumOption({
    required MediumModel medium,
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
              child: Text(medium.name),
            ),
          ],
        ),
      ),
    );
  }
}
