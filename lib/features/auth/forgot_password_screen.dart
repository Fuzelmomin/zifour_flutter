import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/utils/alert_show.dart';
import 'package:zifour_sourcecode/features/auth/otp_verification_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../core/localization/localization_helper.dart';

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

                    // Sign in title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.localize('forgotPasswordTitle'),
                        style: AppTypography.inter24Bold,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Phone Number Field
                    CustomTextField(
                      editingController: _phoneController,
                      type: 'phone',
                      maxLength: 10,
                      changedValue: (value){},
                      hint: context.localize('phoneNumber'),
                      isPrefixIcon: true,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey[400],
                        size: 20.sp,
                      ),
                      isSuffixIcon: false,
                      keyboardAction: TextInputAction.next,
                    ),

                    SizedBox(height: 20.h),

                    // Sign In Button
                    CustomGradientButton(
                      text: context.localize('send'),
                      onPressed: () {
                        // TODO: Implement login logic
                        if (_phoneController.text.isEmpty) {
                          AlertShow.alertShowSnackBar(
                              context,
                              context.localize('pleaseEnterPhoneNumber'),
                              Colors.red
                          );
                          return;
                        }

                        if (_phoneController.text.length != 10) {
                          AlertShow.alertShowSnackBar(
                              context,
                              context.localize('pleaseEnterValidPhoneNumber'),
                              Colors.red
                          );
                          return;
                        }

                        AlertShow.alertShowSnackBar(
                            context,
                            '${context.localize('sendOtpOnNumber')} ${_phoneController.text}',
                            Colors.green
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OTPVerificationScreen()),
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
