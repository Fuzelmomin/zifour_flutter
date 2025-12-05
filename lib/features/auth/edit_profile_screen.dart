import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/utils/gradient_text.dart';
import 'package:zifour_sourcecode/core/widgets/be_ziddi_item_widget.dart';
import 'package:zifour_sourcecode/features/auth/login_screen.dart';

import '../../core/api_models/profile_model.dart';
import '../../core/bloc/signup_bloc.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/profile_bloc.dart';
import '../../core/api_models/standard_model.dart';
import '../../core/api_models/exam_model.dart';
import '../../core/api_models/medium_model.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/widgets/custom_loading_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodePassController = TextEditingController();
  final TextEditingController _addressPassController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());

  BehaviorSubject<int> _mobileVerify = BehaviorSubject<int>.seeded(0);

  // 0 = Not Any Action, 1 = Send OTP, 2 = Verified Mobile, 3 = Failed OTP Verification

  BehaviorSubject<int> _otpResendTimer = BehaviorSubject<int>.seeded(20);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _mobileVerify.close();
    _emailController.dispose();
    _cityController.dispose();
    _addressPassController.dispose();
    _pincodePassController.dispose();
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(),
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
                  top: 0.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.studentInfo}',
                  )),

              // Loading Overlay
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading ||
                      state is ProfileInitial ||
                      state is ProfileUpdating) {
                    return Positioned.fill(
                      child: CustomLoadingWidget.fullScreen(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileLoaded) {
                      // Populate text fields when profile is loaded
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _fullNameController.text = state.profileData.stuName;
                        _mobileController.text = state.profileData.stuMobile;
                        _emailController.text = state.profileData.stuEmail ?? '';
                        _cityController.text = state.profileData.stuCity ?? '';
                        _pincodePassController.text = state.profileData.stuPincode ?? '';
                        _addressPassController.text = state.profileData.stuAddress ?? '';
                      });
                    } else if (state is ProfileUpdateSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } else if (state is ProfileError) {
                      // Check if it's a connectivity error and show no internet screen
                      if (state.message.contains('No internet connection') || 
                          state.message.contains('network')) {
                        ConnectivityHelper.checkAndShowNoInternetScreen(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    // Initialize profile fetch on first build
                    if (state is ProfileInitial) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<ProfileBloc>().add(ProfileInitialized());
                      });
                      return const SizedBox.shrink();
                    }

                    if (state is ProfileLoading) {
                      return const SizedBox.shrink();
                    }

                    if (state is ProfileError) {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: AppTypography.inter14Regular.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20.h),
                                CustomGradientButton(
                                  text: 'Retry',
                                  onPressed: () {
                                    context.read<ProfileBloc>().add(ProfileInitialized());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    if (state is! ProfileLoaded) {
                      return const SizedBox.shrink();
                    }
                    
                    final profileState = state as ProfileLoaded;
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15.h,
                          children: [
                          SignupFieldBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                labelWidget(
                                    '${AppLocalizations.of(context)?.studentName.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  hint:
                                      '${AppLocalizations.of(context)?.fullName}',
                                  editingController: _fullNameController,
                                  type: 'text',
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(UpdateProfileName(value));
                                  },
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.phoneNumber.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  hint:
                                      '${AppLocalizations.of(context)?.mobileNumber.toUpperCase()}',
                                  type: "phone",
                                  maxLength: 10,
                                  editingController: _mobileController,
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  enabled: false,
                                  changedValue: (value) {},
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.email.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  hint:
                                      '${AppLocalizations.of(context)?.email}',
                                  type: "email",
                                  editingController: _emailController,
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(UpdateProfileEmail(value));
                                  },
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.selectStandard.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                _buildStandardDropdown(context, profileState),
                                SizedBox(
                                  height: 7.h,
                                ),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.city.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  hint:
                                  '${AppLocalizations.of(context)?.city}',
                                  editingController: _cityController,
                                  type: 'text',
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(UpdateProfileCity(value));
                                  },
                                ),

                                SizedBox(
                                  height: 7.h,
                                ),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.pincode.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  hint:
                                  '${AppLocalizations.of(context)?.pincode}',
                                  editingController: _pincodePassController,
                                  type: 'phone',
                                  maxLength: 10,
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(UpdateProfilePincode(value));
                                  },
                                ),
                                SizedBox(height: 7.h,),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.address.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                CustomTextField(
                                  hint:
                                  '${AppLocalizations.of(context)?.address}',
                                  editingController: _addressPassController,
                                  type: 'text',
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {
                                    context
                                        .read<ProfileBloc>()
                                        .add(UpdateProfileAddress(value));
                                  },
                                ),
                                SizedBox(height: 7.h),
                                labelWidget('${AppLocalizations.of(context)?.gender?.toUpperCase() ?? 'GENDER'}'),
                                // SizedBox(height: 7.h),
                                _buildGenderSelection(context, profileState),
                                SizedBox(height: 7.h),
                                labelWidget('${AppLocalizations.of(context)?.selectCourse?.toUpperCase() ?? 'SELECT COURSE'}'),
                                SizedBox(height: 7.h),
                                _buildCourseSelection(context, profileState),
                                SizedBox(height: 7.h),
                                _buildMediumSelection(context, profileState),

                                SizedBox(height: 25.h,),
                                BlocBuilder<ProfileBloc, ProfileState>(
                                  builder: (context, state) {
                                    final bool isUpdating = state is ProfileUpdating;
                                    return CustomGradientButton(
                                      text: '${AppLocalizations.of(context)?.updateProfile}',
                                      isLoading: isUpdating,
                                      onPressed: isUpdating ? null : () async {
                                        // Check internet connectivity before updating
                                        final isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
                                        if (!isConnected) {
                                          return; // No internet screen is already shown
                                        }

                                        context.read<ProfileBloc>().add(ProfileUpdateSubmitted());
                                      },
                                    );
                                  },
                                )

                              ],
                            ),
                          )
                        ],
                      ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget labelWidget(String label) {
    return Text(
      label,
      style: AppTypography.inter10Medium
          .copyWith(color: AppColors.white.withOpacity(0.7)),
    );
  }

  Widget SignupAppBar() {
    return Column(
      spacing: 10.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AssetsPath.appTitleLogo,
              height: 40.h,
            ),
            BeZiddiItemWidget()
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.w,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                '${AppLocalizations.of(context)?.signupNow}'.toUpperCase(),
                style: AppTypography.inter12Regular.copyWith(
                  color: AppColors.white.withOpacity(0.5),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: AppColors.hintTextColor,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildStandardDropdown(BuildContext blocContext, ProfileLoaded state) {
    final selectedStdId = state.selectedStdId;
    final standards = state.standardList;
    
    NewStandardModel? selectedStandard;
    if (selectedStdId.isNotEmpty && standards.isNotEmpty) {
      selectedStandard = standards.firstWhere(
        (std) => std.stdId == selectedStdId,
        orElse: () => standards.first,
      );
    }

    return Container(
      height: 56.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<NewStandardModel>(
          value: selectedStandard,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '${AppLocalizations.of(blocContext)?.selectStandard}',
              style: AppTypography.inter14Regular.copyWith(
                color: AppColors.hintTextColor,
              ),
            ),
          ),
          icon: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          items: standards.map((NewStandardModel standard) {
            return DropdownMenuItem<NewStandardModel>(
              value: standard,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  standard.name,
                  style: AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          onChanged: (NewStandardModel? newValue) {
            if (newValue != null) {
              blocContext.read<ProfileBloc>().add(
                UpdateProfileStandard(
                  stdId: newValue.stdId,
                  stdName: newValue.name,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCourseSelection(BuildContext blocContext, ProfileLoaded state) {
    final selectedExmId = state.selectedExmId;
    final exams = state.examList;

    if (exams.isEmpty) {
      return SizedBox.shrink();
    }

    return Row(
      children: exams.map((NewExamModel exam) {
        print('buildCourseSelection ${exam.exmId} And Selected: $selectedExmId');
        final isSelected = exam.exmId == selectedExmId;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: exam != exams.last ? 15.w : 0),
            child: _buildCourseOption(blocContext, exam, isSelected),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCourseOption(BuildContext blocContext, NewExamModel exam, bool isSelected) {
    print('buildCourseOption ${exam.name}');
    print('buildCourseOption ${exam.toJson()}');
    return GestureDetector(
      onTap: () {
        blocContext.read<ProfileBloc>().add(
          UpdateProfileExam(
            exmId: exam.exmId,
            exmName: exam.name,
          ),
        );
      },
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.pinkColor2 : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                exam.name,
                style: AppTypography.inter14Medium.copyWith(
                  color: Colors.white.withOpacity(1.0),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: AppColors.darkBlue,
                      size: 12.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMediumSelection(BuildContext blocContext, ProfileLoaded state) {
    final selectedMedId = state.selectedMedId;
    final mediums = state.mediumList;

    if (mediums.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelWidget('${AppLocalizations.of(blocContext)?.languagePreference?.toUpperCase() ?? 'LANGUAGE PREFERENCE'}'),
        SizedBox(height: 7.h),
        Row(
          children: mediums.map((NewMediumModel medium) {
            final isSelected = medium.medId == selectedMedId;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: medium != mediums.last ? 15.w : 0),
                child: _buildMediumOption(blocContext, medium, isSelected),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMediumOption(BuildContext blocContext, NewMediumModel medium, bool isSelected) {
    return GestureDetector(
      onTap: () {
        blocContext.read<ProfileBloc>().add(
          UpdateProfileMedium(
            medId: medium.medId,
            medName: medium.medName,
          ),
        );
      },
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.pinkColor2 : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                medium.medName,
                style: AppTypography.inter14Medium.copyWith(
                  color: Colors.white.withOpacity(1.0),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: AppColors.darkBlue,
                      size: 12.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection(BuildContext blocContext, ProfileLoaded state) {
    final selectedGender = state.selectedGender;
    // Gender: 1 = Male, 2 = Female, 3 = Other (or similar mapping)

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: _buildGenderOption(blocContext, 1, selectedGender == 1)),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildGenderOption(blocContext, 2, selectedGender == 2),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildGenderOption(blocContext, 3, selectedGender == 3),
        ),
      ],
    );
  }

  Widget _buildGenderOption(BuildContext blocContext, int gender, bool isSelected) {
    String genderText;
    if (gender == 1) {
      genderText = '${AppLocalizations.of(blocContext)?.male}';
    } else if (gender == 2) {
      genderText = '${AppLocalizations.of(blocContext)?.female}';
    } else {
      genderText = '${AppLocalizations.of(blocContext)?.other}';
    }

    return GestureDetector(
      onTap: () {
        blocContext.read<ProfileBloc>().add(UpdateProfileGender(gender));
      },
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pinkColor2 : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: AppColors.darkBlue,
                      size: 12.sp,
                    )
                  : null,
            ),
            SizedBox(width: 8.w),
            Text(
              genderText,
              style: AppTypography.inter14Medium.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
