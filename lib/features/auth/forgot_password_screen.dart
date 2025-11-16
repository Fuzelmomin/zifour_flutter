import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/features/auth/otp_verification_screen.dart';
import 'package:zifour_sourcecode/features/auth/bloc/forgot_password_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordOTPSent) {
            // Navigate to OTP verification screen on success with mobile number
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(mobileNumber: state.mobile),
              ),
            );
          } else if (state is ForgotPasswordError) {
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
                            '${AppLocalizations.of(context)?.forgotPasswordTitle}',
                            style: AppTypography.inter24Bold,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Phone Number Field
                        CustomTextField(
                          editingController: _phoneController,
                          type: 'phone',
                          maxLength: 10,
                          changedValue: (value) {},
                          hint: '${AppLocalizations.of(context)?.phoneNumber}',
                          isPrefixIcon: true,
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.grey[400],
                            size: 20.sp,
                          ),
                          isSuffixIcon: false,
                          keyboardAction: TextInputAction.done,
                        ),

                        SizedBox(height: 20.h),

                        // Send Button
                        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                          builder: (context, state) {
                            final bool isLoading = state is ForgotPasswordLoading;
                            
                            return CustomGradientButton(
                              text: '${AppLocalizations.of(context)?.send}',
                              isLoading: isLoading,
                              onPressed: isLoading ? null : () async {
                                // Validate phone number
                                if (_phoneController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${AppLocalizations.of(context)?.pleaseEnterPhoneNumber}'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                  return;
                                }

                                if (_phoneController.text.length != 10) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${AppLocalizations.of(context)?.pleaseEnterValidPhoneNumber}'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                  return;
                                }

                                // Check internet connectivity before API call
                                final isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
                                if (!isConnected) {
                                  return; // No internet screen is already shown
                                }

                                // Send OTP
                                context.read<ForgotPasswordBloc>().add(
                                  SendForgotPasswordOTP(_phoneController.text),
                                );
                              },
                            );
                          },
                        ),

                        SizedBox(height: 40.h),
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
