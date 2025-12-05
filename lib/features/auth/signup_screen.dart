import 'dart:async';
import 'dart:io';

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
import 'package:zifour_sourcecode/core/utils/image_picker_utils.dart';
import 'package:zifour_sourcecode/core/widgets/be_ziddi_item_widget.dart';
import 'package:zifour_sourcecode/core/widgets/upload_box_widget.dart';
import 'package:zifour_sourcecode/core/widgets/custom_loading_widget.dart';
import 'package:zifour_sourcecode/features/auth/login_screen.dart';

import '../../core/bloc/signup_bloc.dart';
import '../../core/api_models/standard_model.dart';
import '../../core/api_models/exam_model.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_gradient_widget.dart';
import '../../core/widgets/line_label_row.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());

  BehaviorSubject<int> _mobileVerify = BehaviorSubject<int>.seeded(0);
  // 0 = Not Any Action, 1 = Send OTP, 2 = Verified Mobile, 3 = Failed OTP Verification

  BehaviorSubject<int> _otpResendTimer = BehaviorSubject<int>.seeded(20);
  Timer? _timer;
  bool _showOtpField = false; // Local state to track OTP field visibility

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
    _otpResendTimer.close();
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
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

  void _showImageSourceDialog(BuildContext context, SignupState state) {
    ImagePickerUtils.showImageSourceDialog(
      context: context,
      onImageSelected: (File imageFile) {
        context.read<SignupBloc>().add(UpdateImage(imageFile));
      },
      onError: (String error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
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
            Positioned(top: 40.h, left: 15.w, right: 15.w, child: SignupAppBar()),

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
                buildWhen: (previous, current) {
                  // Don't rebuild on timer updates (OtpSent with same data except timer)
                  if (previous is OtpSent && current is OtpSent) {
                    // Only rebuild if something other than timer changed
                    return previous.mobileNumber != current.mobileNumber ||
                           previous.stdId != current.stdId ||
                           previous.exmId != current.exmId ||
                           previous.name != current.name;
                  }
                  // Rebuild for all other state changes
                  return true;
                },
                builder: (context, state) {
                  return SafeArea(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main Heading
                            Text(
                              '${AppLocalizations.of(context)?.letsGetStarted}',
                              style: AppTypography.inter24Bold,
                            ),
                            SizedBox(height: 30.h),

                            // Full Name Field
                            SignupFieldBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    hint: '${AppLocalizations.of(context)?.fullName}',
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
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  // Course Selection
                                  _buildCourseSelection(state),
                                  SizedBox(height: 20.h),

                                  SizedBox(
                                    width: double.infinity,
                                    child: BlocBuilder<SignupBloc, SignupState>(
                                      builder: (context, state) {
                                        File? imageFile;
                                        if (state is SignupLoaded) {
                                          imageFile = state.data.imageFile;
                                        } else if (state is OtpSent) {
                                          imageFile = state.imageFile;
                                        } else if (state is SignupMobileVerified) {
                                          imageFile = state.imageFile;
                                        }
                                        
                                        return UploadDocBoxWidget(
                                          title: '${AppLocalizations.of(context)?.uploadMarksheet}',
                                          itemClick: () {
                                            _showImageSourceDialog(context, state);
                                          },
                                          // Show image preview if selected
                                          imageFile: imageFile,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Password Section
                            SignupFieldBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10.h,
                                children: [
                                  CustomTextField(
                                    hint: '${AppLocalizations.of(context)?.password}',
                                    editingController: _passwordController,
                                    type: 'pass',
                                    isSuffixIcon: true,
                                    textFieldBgColor: Colors.black.withOpacity(0.1),
                                    changedValue: (value) {
                                      context.read<SignupBloc>().add(UpdatePassword(value));
                                    },
                                  ),
                                  CustomTextField(
                                    hint: '${AppLocalizations.of(context)?.confirmPassword}',
                                    editingController: _confirmPassController,
                                    type: 'pass',
                                    isSuffixIcon: true,
                                    textFieldBgColor: Colors.black.withOpacity(0.1),
                                    changedValue: (value) {
                                      context.read<SignupBloc>().add(UpdateConfirmPassword(value));
                                    },
                                  ),
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
                                  SizedBox(height: 20.h),
                                  // OTP Input Fields - outside BlocBuilder to prevent rebuilds on timer updates
                                  _showOtpField
                                      ? _buildOTPInputFields()
                                      : Container(),
                                  SizedBox(height: 15.h),
                                  // Timer Display - using BehaviorSubject instead of BLoC
                                  _showOtpField
                                      ? StreamBuilder<int>(
                                          stream: _otpResendTimer.stream,
                                          initialData: _otpResendTimer.value,
                                          builder: (context, snapshot) {
                                            final timerValue = snapshot.data ?? 0;
                                            final canResend = timerValue == 0;
                                            return Row(
                                              children: [
                                                Text(
                                                  canResend
                                                      ? '${AppLocalizations.of(context)?.reSendCode}'
                                                      : '${AppLocalizations.of(context)?.reSendCodeIn}',
                                                  style: AppTypography.inter12Regular),
                                                GestureDetector(
                                                  onTap: canResend
                                                      ? () {
                                                          context.read<SignupBloc>().add(ResendOTP());
                                                        }
                                                      : null,
                                                  child: Text(
                                                    canResend
                                                        ? '${AppLocalizations.of(context)?.resend}'
                                                        : '0:${timerValue.toString().padLeft(2, '0')}',
                                                    style: AppTypography.inter12Bold.copyWith(
                                                      color: canResend ? AppColors.pinkColor : AppColors.hintTextColor,
                                                      decoration: canResend ? TextDecoration.underline : TextDecoration.none,
                                                      decorationColor: AppColors.pinkColor,
                                                      decorationThickness: 1.5,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        )
                                      : Container(),
                                  // Verification status
                                  BlocBuilder<SignupBloc, SignupState>(
                                    buildWhen: (previous, current) {
                                      return previous is SignupMobileVerified != current is SignupMobileVerified;
                                    },
                                    builder: (context, state) {
                                      final bool isVerified = state is SignupMobileVerified;
                                      return isVerified
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: AppColors.success,
                                                  size: 16.sp,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  '${AppLocalizations.of(context)?.mobileVerifiedSuccessfully}',
                                                  style: AppTypography.inter12Medium.copyWith(
                                                    color: AppColors.success,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container();
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Safety Message
                            LineLabelRow(
                              label: '${AppLocalizations.of(context)?.yourDetailsAreSafe}',
                            ),
                            SizedBox(height: 30.h),

                            // Sign Up Button
                            _buildSignUpButton(state),
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: // Login Link
                  _buildLoginLink(),
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
    String? selectedStdId;
    List<StandardModel> standards = [];
    
    if (state is SignupLoaded) {
      selectedStdId = state.data.stdId;
      standards = state.standards ?? [];
    } else if (state is ImageUploading) {
      selectedStdId = state.data.stdId;
      standards = state.standards ?? [];
    } else if (state is OtpSending) {
      selectedStdId = state.data.stdId;
      standards = state.standards ?? [];
    } else if (state is OtpSent) {
      selectedStdId = state.stdId;
      standards = state.standards ?? [];
    } else if (state is SignupMobileVerified) {
      selectedStdId = state.stdId;
      standards = state.standards ?? [];
    }

    // Don't show loader during initial fetch - just show empty dropdown
    if (standards.isEmpty) {
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${AppLocalizations.of(context)?.selectStandard}',
              style: AppTypography.inter14Regular.copyWith(
                color: AppColors.hintTextColor,
              ),
            ),
          ),
        ),
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
        child: DropdownButton<String>(
          value: selectedStdId,
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
          dropdownColor: AppColors.darkBlue4,
          items: standards.map((StandardModel standard) {
            return DropdownMenuItem<String>(
              value: standard.stdId,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  standard.name,
                  style: AppTypography.inter14Medium.copyWith(color: Colors.white),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newStdId) {
            if (newStdId != null) {
              final selectedStandard = standards.firstWhere((s) => s.stdId == newStdId);
              context.read<SignupBloc>().add(UpdateStandard(selectedStandard.name, stdId: newStdId));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCourseSelection(SignupState state) {
    String? selectedExmId;
    List<ExamModel> exams = [];
    
    if (state is SignupLoaded) {
      selectedExmId = state.data.exmId;
      exams = state.exams ?? [];
    } else if (state is ImageUploading) {
      selectedExmId = state.data.exmId;
      exams = state.exams ?? [];
    } else if (state is OtpSending) {
      selectedExmId = state.data.exmId;
      exams = state.exams ?? [];
    } else if (state is OtpSent) {
      selectedExmId = state.exmId;
      exams = state.exams ?? [];
    } else if (state is SignupMobileVerified) {
      selectedExmId = state.exmId;
      exams = state.exams ?? [];
    }

    // Don't show loader during initial fetch - just show empty container
    if (exams.isEmpty) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  '${AppLocalizations.of(context)?.selectCourse ?? "Select Course"}',
                  style: AppTypography.inter14Regular.copyWith(
                    color: AppColors.hintTextColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: exams.map((ExamModel exam) {
        final isSelected = selectedExmId == exam.exmId;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: exam != exams.last ? 15.w : 0),
            child: _buildCourseOption(exam, isSelected),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCourseOption(ExamModel exam, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<SignupBloc>().add(UpdateCourse(exam.name, exmId: exam.exmId));
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
              exam.name,
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
          child: Container(margin: EdgeInsets.only(left: 5.0), child: _buildGenderOption('Male', selectedGender == 'Male')),
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

  Widget _buildOTPInputFields() {
    // This widget doesn't rebuild when timer updates, only when OTP field visibility changes
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          key: ValueKey('otp_field_$index'), // Preserve identity during rebuilds
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
            key: ValueKey('otp_textfield_$index'), // Preserve identity
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
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
              if (value.isNotEmpty && index < 5) {
                _otpFocusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _otpFocusNodes[index - 1].requestFocus();
              }

              // Update OTP in BLoC and verify when complete
              List<String> otpDigits = _otpControllers.map((controller) => controller.text).toList();
              context.read<SignupBloc>().add(UpdateOTP(otpDigits));
            },
          ),
        );
      }),
    );
  }

  Widget _buildMobileSection(SignupState state) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is OtpSent) {
          // OTP sent successfully - show OTP field
          if (!_showOtpField) {
            setState(() {
              _showOtpField = true;
            });
          }
          _mobileVerify.add(1);
          // Start timer using BehaviorSubject
          startTimer();
          // Focus on first OTP field
          Future.delayed(const Duration(milliseconds: 300), () {
            if (_otpControllers.isNotEmpty && mounted) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          });
        } else if (state is SignupMobileVerified) {
          // OTP verified successfully
          _mobileVerify.add(2);
          _timer?.cancel();
        } else if (state is SignupError) {
          // Error is already shown by the main BlocConsumer listener
          // If error during OTP verification, show failed state
          if (state.message.contains('OTP') || state.message.contains('Invalid')) {
            _mobileVerify.add(3);
          }
        } else if (state is ImageUploading || state is OtpSending || state is OtpVerifying) {
          // Show loading
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        buildWhen: (previous, current) {
          // Only rebuild when OTP field visibility changes, not on timer updates
          final wasOtpSent = previous is OtpSent;
          final isOtpSent = current is OtpSent;
          final wasVerified = previous is SignupMobileVerified;
          final isVerified = current is SignupMobileVerified;
          final wasLoading = previous is ImageUploading || previous is OtpSending || previous is OtpVerifying;
          final isLoading = current is ImageUploading || current is OtpSending || current is OtpVerifying;
          
          // Rebuild only if visibility or loading state changes, not on timer updates
          return wasOtpSent != isOtpSent || 
                 wasVerified != isVerified || 
                 wasLoading != isLoading;
        },
        builder: (context, state) {
          final bool isVerified = state is SignupMobileVerified;
          final bool showSendButton = !_showOtpField && !isVerified;
          final bool isLoading = state is ImageUploading || state is OtpSending || state is OtpVerifying;
          
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                      hint: '${AppLocalizations.of(context)?.mobileNumber}',
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
                  showSendButton
                      ? Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: isLoading ? null : () {
                              final mobileNumber = _mobileController.text;
                              context.read<SignupBloc>().add(SendOTP(mobileNumber));
                            },
                            child: Container(
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: isLoading ? Colors.grey : AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: isLoading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
                                        ),
                                      )
                                    : Text(
                                  '${AppLocalizations.of(context)?.sendOtp}',
                                  style: AppTypography.inter14Bold.copyWith(
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSignUpButton(SignupState state) {
    // Button is enabled only when mobile is verified
    final bool isMobileVerified = state is SignupMobileVerified;
    final bool isLoading = state is OtpVerifying;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupMobileVerified) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${AppLocalizations.of(context)?.signupSuccessful}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: CustomGradientButton(
        text: '${AppLocalizations.of(context)?.signUpButton}',
        isLoading: isLoading,
        isEnabled: isMobileVerified, // Disabled by default, enabled only after OTP verification
        onPressed: isMobileVerified ? () {
          // Navigate to login screen when button is clicked after verification
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } : null,
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      width: double.infinity,
      height: 50.h,
      color: AppColors.darkBlue,
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${AppLocalizations.of(context)?.alreadyAMember}',
                style: AppTypography.inter14Regular.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              TextSpan(
                text: '${AppLocalizations.of(context)?.signIn}',
                style: AppTypography.inter14Medium.copyWith(
                    color: AppColors.pinkColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.pinkColor,
                    decorationThickness: 1.0),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
