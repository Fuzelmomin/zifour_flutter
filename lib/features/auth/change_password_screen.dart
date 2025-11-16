import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/features/auth/bloc/reset_password_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../l10n/app_localizations.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String mobileNumber;
  final String otp;
  
  const ChangePasswordScreen({
    super.key,
    required this.mobileNumber,
    required this.otp,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    // Check if password is empty
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseEnterPassword ?? 'Please enter password'}'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    // Check if confirm password is empty
    if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseEnterConfirmPassword ?? 'Please enter confirm password'}'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    // Check minimum password length (at least 6 characters)
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.passwordMustBe6Characters}'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.passwordNotMatch ?? 'Passwords do not match'}'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(),
      child: BlocListener<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate to login screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          } else if (state is ResetPasswordError) {
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

                        // title
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${AppLocalizations.of(context)?.changePassword}',
                            style: AppTypography.inter24Bold,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        SignupFieldBox(
                          child: Column(
                            children: [
                              CustomTextField(
                                editingController: _passwordController,
                                hint: '${AppLocalizations.of(context)?.password}',
                                type: 'pass',
                                isPrefixIcon: true,
                                isSuffixIcon: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey[400],
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              CustomTextField(
                                editingController: _confirmPasswordController,
                                hint: '${AppLocalizations.of(context)?.confirmPassword}',
                                type: 'pass',
                                isPrefixIcon: true,
                                isSuffixIcon: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey[400],
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Submit Button
                        BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
                          builder: (context, state) {
                            final bool isLoading = state is ResetPasswordLoading;
                            
                            return CustomGradientButton(
                              text: '${AppLocalizations.of(context)?.submit}',
                              isLoading: isLoading,
                              onPressed: isLoading ? null : () async {
                                // Step 1: Validate inputs
                                if (!_validateInputs()) {
                                  return;
                                }

                                // Step 2: Check network connectivity
                                final isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
                                if (!isConnected) {
                                  return; // No internet screen is already shown
                                }

                                // Step 3: Call API
                                context.read<ResetPasswordBloc>().add(
                                  ResetPasswordSubmitted(
                                    mobile: widget.mobileNumber,
                                    otp: widget.otp,
                                    password: _passwordController.text,
                                  ),
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
