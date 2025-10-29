import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/utils/alert_show.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                    CustomGradientButton(
                      text: '${AppLocalizations.of(context)?.changePassword}',
                      onPressed: () {
                        // TODO: Implement login logic
                        if (_oldPasswordController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                          AlertShow.alertShowSnackBar(context, '${AppLocalizations.of(context)?.pleaseFillAllFields}', Colors.red);
                          return;
                        }

                        if (_passwordController.text != _confirmPasswordController.text) {
                          AlertShow.alertShowSnackBar(context, '${AppLocalizations.of(context)?.passwordDoesNotMatch}', Colors.red);
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${AppLocalizations.of(context)?.changePassword}'),
                            backgroundColor: Colors.green,
                          ),
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
    );
  }
}
