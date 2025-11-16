import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/features/auth/change_password_screen.dart';
import 'package:zifour_sourcecode/features/auth/bloc/forgot_password_verification_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../l10n/app_localizations.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String? mobileNumber;
  
  const OTPVerificationScreen({
    super.key,
    this.mobileNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Timer starts automatically when BLoC is created
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Widget _buildOTPInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          key: ValueKey('otp_field_$index'),
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
            key: ValueKey('otp_textfield_$index'),
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
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordVerificationBloc(),
      child: BlocListener<ForgotPasswordVerificationBloc, ForgotPasswordVerificationState>(
        listener: (context, state) {
          if (state is ForgotPasswordVerificationOTPVerified) {
            // Navigate to change password screen on success with OTP from state
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordScreen(
                  mobileNumber: widget.mobileNumber ?? '',
                  otp: state.otp,
                ),
              ),
            );
          } else if (state is ForgotPasswordVerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.darkBlue,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      AssetsPath.loginBgImg,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 60.h),

                        // App Logo and Name
                        Image.asset(
                          AssetsPath.appLogo,
                          width: 100.w,
                          height: 100.h,
                        ),

                        SizedBox(height: 60.h),

                        // Sign in title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${AppLocalizations.of(context)?.otpVerificationCode}',
                            style: AppTypography.inter24Bold,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        BlocBuilder<ForgotPasswordVerificationBloc, ForgotPasswordVerificationState>(
                          builder: (context, state) {
                            final bool isLoading = state is ForgotPasswordVerificationLoading;
                            final bool canVerify = _otpControllers.every((controller) => controller.text.isNotEmpty);
                            
                            return Column(
                              spacing: 20.h,
                              children: [
                                SignupFieldBox(
                                  child: Column(
                                    children: [
                                      _buildOTPInputFields(),
                                      SizedBox(height: 20.h),
                                      // Resend OTP section
                                      BlocBuilder<ForgotPasswordVerificationBloc, ForgotPasswordVerificationState>(
                                        buildWhen: (previous, current) => 
                                          previous.otpResendTimer != current.otpResendTimer,
                                        builder: (context, state) {
                                          final canResend = state.otpResendTimer == 0;
                                          
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                canResend
                                                    ? '${AppLocalizations.of(context)?.reSendCode} '
                                                    : '${AppLocalizations.of(context)?.reSendCodeIn} ',
                                                style: AppTypography.inter12Regular,
                                              ),
                                              GestureDetector(
                                                onTap: canResend && !isLoading
                                                    ? () async {
                                                        if (widget.mobileNumber == null || widget.mobileNumber!.isEmpty) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text('Mobile number not found'),
                                                              backgroundColor: AppColors.error,
                                                            ),
                                                          );
                                                          return;
                                                        }

                                                        // Check internet connectivity before API call
                                                        final isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
                                                        if (!isConnected) {
                                                          return;
                                                        }

                                                        // Resend OTP
                                                        context.read<ForgotPasswordVerificationBloc>().add(
                                                          ResendForgotPasswordOTP(widget.mobileNumber!),
                                                        );
                                                      }
                                                    : null,
                                                child: Text(
                                                  canResend
                                                      ? '${AppLocalizations.of(context)?.resend}'
                                                      : '0:${state.otpResendTimer.toString().padLeft(2, '0')}',
                                                  style: AppTypography.inter12Bold.copyWith(
                                                    color: canResend ? AppColors.pinkColor : AppColors.hintTextColor,
                                                    decoration: canResend ? TextDecoration.underline : TextDecoration.none,
                                                    decorationColor: AppColors.pinkColor,
                                                    decorationThickness: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // Verify Button
                                if (canVerify && !isLoading)
                                  CustomGradientButton(
                                    text: '${AppLocalizations.of(context)?.verify}',
                                    isLoading: isLoading,
                                    onPressed: isLoading ? null : () async {
                                      if (widget.mobileNumber == null || widget.mobileNumber!.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Mobile number not found'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                        return;
                                      }

                                      // Get OTP from controllers
                                      final otp = _otpControllers.map((controller) => controller.text).join();
                                      
                                      if (otp.length != 6) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Please enter complete OTP'),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                        return;
                                      }

                                      // Check internet connectivity before API call
                                      final isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
                                      if (!isConnected) {
                                        return;
                                      }

                                      // Verify OTP
                                      context.read<ForgotPasswordVerificationBloc>().add(
                                        VerifyForgotPasswordOTP(
                                          mobile: widget.mobileNumber!,
                                          otp: otp,
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
