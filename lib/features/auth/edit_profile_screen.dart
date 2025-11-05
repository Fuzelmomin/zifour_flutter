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

import '../../core/bloc/signup_bloc.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

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
    // Initialize BLoC
    context.read<SignupBloc>().add(SignupInitialized());
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
    return Scaffold(
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

              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: BlocConsumer<SignupBloc, SignupState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return Column(
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
                                        .read<SignupBloc>()
                                        .add(UpdateFullName(value));
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
                                  changedValue: (value) {
                                    context
                                        .read<SignupBloc>()
                                        .add(UpdateMobileNumber(value));
                                  },
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
                                  changedValue: (value) {},
                                ),
                                SizedBox(
                                  height: 7.h,
                                ),
                                labelWidget(
                                    '${AppLocalizations.of(context)?.selectStandard.toUpperCase()}'),
                                SizedBox(
                                  height: 3.h,
                                ),
                                _buildStandardDropdown(state),
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
                                        .read<SignupBloc>()
                                        .add(UpdateFullName(value));
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
                                  editingController: _cityController,
                                  type: 'phone',
                                  maxLength: 10,
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {
                                    context
                                        .read<SignupBloc>()
                                        .add(UpdateFullName(value));
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
                                        .read<SignupBloc>()
                                        .add(UpdateFullName(value));
                                  },
                                ),
                                SizedBox(height: 7.h),
                                _buildGenderSelection(state),
                                SizedBox(height: 7.h),
                                _buildCourseSelection(state),

                                SizedBox(height: 25.h,),
                                CustomGradientButton(
                                  text: '${AppLocalizations.of(context)?.updateProfile}',
                                  onPressed: () {
                                    // TODO: Implement login logic
                                    // if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
                                    //   ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //       content: Text('Please fill all fields'),
                                    //       backgroundColor: Colors.red,
                                    //     ),
                                    //   );
                                    //   return;
                                    // }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${AppLocalizations.of(context)?.signupSuccessful}'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    );
                                  },
                                )

                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
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

  Widget _buildStandardDropdown(SignupState state) {
    String selectedStandard = '';
    if (state is SignupLoaded) {
      selectedStandard = state.data.standard;
    }

    // Get the displayed value based on current language
    String? displayValue;
    if (selectedStandard.isNotEmpty) {
      if (selectedStandard == 'Class 11') {
        displayValue = '${AppLocalizations.of(context)?.class11}';
      } else if (selectedStandard == 'Class 12') {
        displayValue = '${AppLocalizations.of(context)?.class12}';
      } else if (selectedStandard == 'Dropper') {
        displayValue = '${AppLocalizations.of(context)?.dropper}';
      }
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
        child: DropdownButton<String>(
          value: selectedStandard.isEmpty ? null : selectedStandard,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '${AppLocalizations.of(context)?.selectStandard}',
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
          selectedItemBuilder: (context) {
            return ['Class 11', 'Class 12', 'Dropper'].map((value) {
              String displayText;
              if (value == 'Class 11') {
                displayText = '${AppLocalizations.of(context)?.class11}';
              } else if (value == 'Class 12') {
                displayText = '${AppLocalizations.of(context)?.class12}';
              } else {
                displayText = '${AppLocalizations.of(context)?.dropper}';
              }
              return Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  displayText,
                  style:
                      AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
              );
            }).toList();
          },
          items: ['Class 11', 'Class 12', 'Dropper'].map((String value) {
            String displayText;
            if (value == 'Class 11') {
              displayText = '${AppLocalizations.of(context)?.class11}';
            } else if (value == 'Class 12') {
              displayText = '${AppLocalizations.of(context)?.class12}';
            } else {
              displayText = '${AppLocalizations.of(context)?.dropper}';
            }

            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  displayText,
                  style:
                      AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<SignupBloc>().add(UpdateStandard(newValue));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCourseSelection(SignupState state) {
    String selectedCourse = 'NEET';
    if (state is SignupLoaded) {
      selectedCourse = state.data.course;
    }

    return Row(
      children: [
        Expanded(
          child: _buildCourseOption('NEET', selectedCourse == 'NEET'),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildCourseOption('JEE', selectedCourse == 'JEE'),
        ),
      ],
    );
  }

  Widget _buildCourseOption(String course, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<SignupBloc>().add(UpdateCourse(course));
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
            Text(
              course == 'NEET'
                  ? '${AppLocalizations.of(context)?.neet}'
                  : '${AppLocalizations.of(context)?.jee}',
              style: AppTypography.inter14Medium.copyWith(
                color: Colors.white,
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

  Widget _buildGenderSelection(SignupState state) {
    String selectedGender = 'Male';
    if (state is SignupLoaded) {
      selectedGender = state.data.gender;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 5.0),
              child: _buildGenderOption('Male', selectedGender == 'Male')),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildGenderOption('Female', selectedGender == 'Female'),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _buildGenderOption('Other', selectedGender == 'Other'),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<SignupBloc>().add(UpdateGender(gender));
      },
      child: Container(
        height: 48.h,
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
              gender == 'Male'
                  ? '${AppLocalizations.of(context)?.male}'
                  : gender == 'Female'
                      ? '${AppLocalizations.of(context)?.female}'
                      : '${AppLocalizations.of(context)?.other}',
              style: AppTypography.inter12Medium.copyWith(
                color: isSelected ? Colors.white : AppColors.hintTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
