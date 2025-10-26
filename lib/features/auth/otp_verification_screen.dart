import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/utils/alert_show.dart';
import 'package:zifour_sourcecode/features/auth/change_password_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../core/localization/localization_helper.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  BehaviorSubject<int> _otpVerify = BehaviorSubject<int>.seeded(0);
  // 0 = Not Any Action, 1 = Send OTP, 2 = Verified Mobile, 3 = Failed OTP Verification

  BehaviorSubject<int> _otpResendTimer = BehaviorSubject<int>.seeded(20);
  Timer? _timer;

  @override
  void initState() {
    _otpVerify.add(1);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _otpVerify.close();
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
                        context.localize('otpVerificationCode'),
                        style: AppTypography.inter24Bold,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    StreamBuilder(
                      stream: _otpVerify,
                      builder: (context, otpVerifySnapshot) {
                        return Column(
                          spacing: 20.h,
                          children: [
                            SignupFieldBox(
                              child: Column(
                                children: [
                                  Row(
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
                                              _otpVerify.add(2);
                                            }
                                            print('OTP Value ${otpDigits}');
                                            //context.read<SignupBloc>().add(UpdateOTP(otpDigits));
                                          },
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 20.h),
                                  otpVerifySnapshot.data == 1 || otpVerifySnapshot.data == 3 ?
                                  StreamBuilder<int>(
                                      stream: _otpResendTimer,
                                      builder: (context, asyncSnapshot) {
                                  return Row(
                                    children: [
                                      Text(
                                          asyncSnapshot.data == 0 ? context.localize('reSendCode') : context.localize('reSendCodeIn'),
                                          style: AppTypography.inter12Regular
                                      ),
                                      GestureDetector(
                                        onTap: asyncSnapshot.data == 0 ? (){
                                          startTimer();
                                        } : null,
                                        child: Text(
                                          asyncSnapshot.data == 0 ? context.localize('resend') : '0:${asyncSnapshot.data.toString().padLeft(2, '0')}',
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
                                ],
                              ),
                            ),
                            // Verify In Button
                            otpVerifySnapshot.data == 2 ?
                            CustomGradientButton(
                              text: context.localize('verify'),
                              onPressed: () {

                                AlertShow.alertShowSnackBar(
                                    context,
                                    context.localize('verificationSuccessfully'),
                                    Colors.green
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                                );
                              },
                            ) : Container(),

                          ],
                        );
                      }
                    ),
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
