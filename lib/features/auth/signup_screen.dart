import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/utils/gradient_text.dart';

import '../../core/bloc/signup_bloc.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());

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
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    _otpResendTimer.add(20); // reset to 20 if you want to restart
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = _otpResendTimer.value;
      if (current > 0) {
        _otpResendTimer.add(current - 1);
      } else {
        timer.cancel();
      }
    });
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
            Column(
              children: [
                Expanded(
                  flex: 6,
                    child: Image.asset(
                      AssetsPath.signupBgImg,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: boxGradientDecoration(),
                    )
                )
              ],
            ),

            // App Bar
            Positioned(
              top: 40.h,
                left: 15.w,
                right: 15.w,
                child: SignupAppBar()),

            // Main Content with BLoC
            Positioned(
              top: 120.h,
              left: 0,
              right: 0,
              bottom: 0,
              child: BlocConsumer<SignupBloc, SignupState>(
                listener: (context, state) {
                  if (state is SignupError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  } else if (state is SignupSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Signup successful!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Heading
                        Text(
                          "Let's get your started!",
                          style: AppTypography.inter24Bold,
                        ),
                        SizedBox(height: 30.h),
                        
                        // Full Name Field
                        SignupFieldBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomTextField(
                                hint: "Full Name",
                                editingController: _fullNameController,
                                type: 'text',
                                textFieldBgColor: Colors.black.withOpacity(0.1),
                                changedValue: (value) {
                                  context.read<SignupBloc>().add(UpdateFullName(value));
                                },
                              ),
                              SizedBox(height: 10.h),

                              _buildGenderSelection(state),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        SignupFieldBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Select Standard Dropdown
                              _buildStandardDropdown(state),
                              SizedBox(height: 20.h,),
                              // Course Selection
                              _buildCourseSelection(state),
                              SizedBox(height: 20.h),

                              DottedBorder(
                                options: RectDottedBorderOptions(
                                  dashPattern: [5, 2],
                                  strokeWidth: 1,
                                  padding: EdgeInsets.all(12),
                                  color: AppColors.white.withOpacity(0.3)
                                ),
                                child: Row(
                                  spacing: 10.w,
                                  children: [
                                    SvgPicture.asset(
                                      AssetsPath.svgUploadDoc,
                                      width: 40.h,
                                      height: 40.h,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Upload your last year marksheet or 10th Exam Receipt",
                                        style: AppTypography.inter12Regular.copyWith(
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                        
                        // Mobile Number and OTP Section
                        SignupFieldBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildMobileSection(state),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                        
                        // Safety Message
                        Center(
                          child: Text(
                            "Your Details are safe with us",
                            style: AppTypography.inter12Regular.copyWith(
                              color: AppColors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        
                        // Sign Up Button
                        _buildSignUpButton(state),
                        SizedBox(height: 20.h),
                        
                        // Login Link
                        _buildLoginLink(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '🔥'
                ),
                GradientText(
                  text: ' Be Ziddi. Be a Topper.',
                  gradient: const LinearGradient(
                    colors: [AppColors.white, AppColors.pinkColor1],
                  ),
                  style: AppTypography.inter14SemiBold,
                ),
              ],
            )
          ],
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10.w,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                ('Signup Now!').toUpperCase(),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Select Standard",
              style: AppTypography.inter16Medium.copyWith(
                color: Colors.white.withOpacity(0.7),
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
          items: ['Class 11', 'Class 12', 'Dropper'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  value,
                  style: AppTypography.inter16Medium.copyWith(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            context.read<SignupBloc>().add(UpdateStandard(newValue ?? ''));
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
          color: isSelected ? AppColors.pinkColor2 : Colors.black.withOpacity(0.1),
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
              course,
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
              gender,
              style: AppTypography.inter12Medium.copyWith(
                color: isSelected ? Colors.white : AppColors.hintTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentUpload() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: Colors.white.withOpacity(0.7),
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              "Upload your last year marksheet or 10th Exam Receipt",
              style: AppTypography.inter12Regular.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSection(SignupState state) {
    return StreamBuilder<int>(
      stream: _mobileVerify,
      builder: (context, mobileVerifySnapshot) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    hint: "Mobile Number",
                    type: "phone",
                    maxLength: 10,
                    editingController: _mobileController,
                    textFieldBgColor: Colors.black.withOpacity(0.1),
                    changedValue: (value) {
                      context.read<SignupBloc>().add(UpdateMobileNumber(value));
                    },
                  ),
                ),
                SizedBox(width: 15.w),
                mobileVerifySnapshot.data == 0 || mobileVerifySnapshot.data == 3 ? Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      startTimer();
                      _mobileVerify.add(1);
                      //context.read<SignupBloc>().add(SendOTP(mobileNumber));
                    },
                    child: Container(
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Send OTP",
                          style: AppTypography.inter14Bold.copyWith(
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ) : Container(),
              ],
            ),
            SizedBox(height: 20.h),
            mobileVerifySnapshot.data == 1 || mobileVerifySnapshot.data == 3 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue2.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: AppTypography.inter16Medium.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: '-',
                      hintStyle: AppTypography.inter16Medium.copyWith(color: AppColors.white),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }

                      // Update OTP in BLoC
                      List<String> otpDigits = _otpControllers.map((controller) => controller.text).toList();
                      String otp = otpDigits.join();
                      if(otp.length == 4){
                        _mobileVerify.add(2);
                      }
                      print('OTP Value ${otpDigits}');
                      //context.read<SignupBloc>().add(UpdateOTP(otpDigits));
                    },
                  ),
                );
              }),
            ) : Container(),
            SizedBox(height: 15.h),
            mobileVerifySnapshot.data == 1 || mobileVerifySnapshot.data == 3 ? StreamBuilder<int>(
              stream: _otpResendTimer,
              builder: (context, asyncSnapshot) {
                return Row(
                  children: [
                    Text(
                        asyncSnapshot.data == 0 ? 'Re-send Code ' : 'Re-send Code in ',
                        style: AppTypography.inter12Regular
                    ),
                    GestureDetector(
                      onTap: asyncSnapshot.data == 0 ? (){
                        startTimer();
                      } : null,
                      child: Text(
                        asyncSnapshot.data == 0 ? 'Resend' : '0:${asyncSnapshot.data.toString().padLeft(2, '0')}',
                        style: AppTypography.inter12Bold.copyWith(
                          color: AppColors.pinkColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.pinkColor, // ensure underline color visible
                          decorationThickness: 1.5,
                        ),
                      ),
                    )
                  ],
                );
              }
            ) : Container(),
            mobileVerifySnapshot.data == 3 || mobileVerifySnapshot.data == 2 ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  mobileVerifySnapshot.data == 3 ? Icons.close : Icons.check_circle,
                  color: mobileVerifySnapshot.data == 3 ? AppColors.error : AppColors.success,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  mobileVerifySnapshot.data == 3 ? "Mobile Verification Failed" : "Mobile Verified Successfully",
                  style: AppTypography.inter12Medium.copyWith(
                    color: mobileVerifySnapshot.data == 3 ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ) : Container(),
          ],
        );
      }
    );
  }

  Widget _buildSignUpButton(SignupState state) {
    bool isLoading = state is SignupLoading;
    
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.pinkColor, AppColors.pinkColor1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: isLoading ? null : () {
            context.read<SignupBloc>().add(SignupSubmitted());
          },
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    "Sign Up Now!",
                    style: AppTypography.inter16Medium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already a Member? ",
              style: AppTypography.inter14Regular.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            TextSpan(
              text: "Sign In",
              style: AppTypography.inter14Medium.copyWith(
                color: AppColors.pinkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

