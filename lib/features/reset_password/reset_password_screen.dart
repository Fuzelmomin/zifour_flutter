import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/utils/alert_show.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/reset_password/bloc/reset_password_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    // Check if old password is empty
    if (_oldPasswordController.text.isEmpty) {
      AlertShow.alertShowSnackBar(
        context,
        '${AppLocalizations.of(context)?.enterOldPass ?? 'Please enter old password'}',
        Colors.red,
      );
      return false;
    }

    // Check if password is empty
    if (_passwordController.text.isEmpty) {
      AlertShow.alertShowSnackBar(
        context,
        '${AppLocalizations.of(context)?.pleaseEnterPassword ?? 'Please enter password'}',
        Colors.red,
      );
      return false;
    }

    // Check if confirm password is empty
    if (_confirmPasswordController.text.isEmpty) {
      AlertShow.alertShowSnackBar(
        context,
        '${AppLocalizations.of(context)?.pleaseEnterConfirmPassword ?? 'Please enter confirm password'}',
        Colors.red,
      );
      return false;
    }

    // Check minimum password length (at least 6 characters)
    if (_passwordController.text.length < 6) {
      AlertShow.alertShowSnackBar(
        context,
        '${AppLocalizations.of(context)?.passwordMustBe6Characters ?? 'Password must be at least 6 characters'}',
        Colors.red,
      );
      return false;
    }

    // Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      AlertShow.alertShowSnackBar(
        context,
        '${AppLocalizations.of(context)?.passwordDoesNotMatch ?? 'Passwords do not match'}',
        Colors.red,
      );
      return false;
    }

    // Check if old password and new password are the same
    if (_oldPasswordController.text == _passwordController.text) {
      AlertShow.alertShowSnackBar(
        context,
        'New password must be different from old password',
        Colors.red,
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
            AlertShow.alertShowSnackBar(
              context,
              state.message,
              Colors.green,
            );
            
            // Clear text fields
            _oldPasswordController.clear();
            _passwordController.clear();
            _confirmPasswordController.clear();
            
            // Navigate back after a short delay
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            });
          } else if (state is ResetPasswordError) {
            AlertShow.alertShowSnackBar(
              context,
              state.message,
              Colors.red,
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
                            '${AppLocalizations.of(context)?.resetPassword}',
                            style: AppTypography.inter24Bold,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        SignupFieldBox(
                          child: Column(
                            children: [
                              CustomTextField(
                                editingController: _oldPasswordController,
                                hint: '${AppLocalizations.of(context)?.enterOldPass}',
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
                              text: '${AppLocalizations.of(context)?.changePassword}',
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
                                    oldPassword: _oldPasswordController.text.trim(),
                                    newPassword: _passwordController.text.trim(),
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
