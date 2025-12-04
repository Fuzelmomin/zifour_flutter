import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/features/auth/bloc/login_bloc.dart';
import 'package:zifour_sourcecode/features/auth/forgot_password_screen.dart';
import 'package:zifour_sourcecode/features/auth/signup_screen.dart';
import 'package:zifour_sourcecode/features/dashboard/dashboard_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// Load saved credentials if remember me was enabled
  Future<void> _loadSavedCredentials() async {
    final rememberMe = await UserPreference.getRememberMe();
    if (rememberMe) {
      final savedMobile = await UserPreference.getSavedMobile();
      final savedPassword = await UserPreference.getSavedPassword();
      
      if (savedMobile != null && savedPassword != null) {
        setState(() {
          _phoneController.text = savedMobile;
          _passwordController.text = savedPassword;
          _rememberMe = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    // Check if phone number is empty
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseEnterPhoneNumber}'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

    // Check if phone number is valid (10 digits)
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)?.pleaseEnterValidPhoneNumber}'),
          backgroundColor: AppColors.error,
        ),
      );
      return false;
    }

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
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to dashboard/home screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
              (route) => false,
            );
          } else if (state is LoginError) {
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
                            '${AppLocalizations.of(context)?.signIn}',
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
                          keyboardAction: TextInputAction.next,
                        ),

                        SizedBox(height: 20.h),

                        // Password Field
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

                        // Remember Me and Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Remember Me
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value;
                                      });
                                    },
                                    activeColor: AppColors.white,
                                    activeTrackColor: AppColors.pinkColor,
                                    inactiveThumbColor: Colors.grey[300],
                                    inactiveTrackColor: Colors.grey[600],
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '${AppLocalizations.of(context)?.rememberMe}',
                                  style: AppTypography.inter14Regular,
                                ),
                              ],
                            ),

                            // Forgot Password
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                '${AppLocalizations.of(context)?.forgotPassword}',
                                style: AppTypography.inter14Bold.copyWith(
                                  color: AppColors.pinkColor,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.pinkColor,
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 60.h),

                        // Sign In Button
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            final bool isLoading = state is LoginLoading;
                            
                            return CustomGradientButton(
                              text: '${AppLocalizations.of(context)?.signInButton}',
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
                                context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    mobile: _phoneController.text,
                                    password: _passwordController.text,
                                    rememberMe: _rememberMe,
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
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: _buildSignupLink(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignupLink() {
    return Container(
      width: double.infinity,
      height: 50.h,
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${AppLocalizations.of(context)?.dontHaveAccount}',
                style: AppTypography.inter14Regular.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              TextSpan(
                text: '${AppLocalizations.of(context)?.signUp}',
                style: AppTypography.inter14Medium.copyWith(
                    color: AppColors.pinkColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.pinkColor,
                    decorationThickness: 1.0),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
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
