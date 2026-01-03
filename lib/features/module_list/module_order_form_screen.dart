import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:zifour_sourcecode/core/dialogs/success_dialog.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import 'bloc/module_order_bloc.dart';
import 'bloc/module_order_event.dart';
import 'bloc/module_order_state.dart';
import 'repository/module_order_repository.dart';

class ModuleOrderFormScreen extends StatefulWidget {
  final String mdlId;
  const ModuleOrderFormScreen({super.key, required this.mdlId});

  @override
  State<ModuleOrderFormScreen> createState() => _ModuleOrderFormScreenState();
}

class _ModuleOrderFormScreenState extends State<ModuleOrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final ModuleOrderRepository _repository = ModuleOrderRepository();
  late ModuleOrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ModuleOrderBloc(repository: _repository);
    //_loadUserData();
  }

  // void _loadUserData() async {
  //   final userData = await UserPreference.getUserData();
  //   if (userData != null) {
  //     setState(() {
  //       _nameController.text = userData.name ?? '';
  //       _mobileController.text = userData.mobile ?? '';
  //     });
  //   }
  // }mobile

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _submitForm() async {
    final String name = _nameController.text.trim();
    final String mobile = _mobileController.text.trim();
    final String pincode = _pincodeController.text.trim();
    final String address = _addressController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please enter your full name');
      return;
    }

    if (mobile.isEmpty) {
      _showSnackBar('Please enter your mobile number');
      return;
    }

    if (mobile.length != 10) {
      _showSnackBar('Mobile number must be 10 digits');
      return;
    }

    if (pincode.isEmpty) {
      _showSnackBar('Please enter your pincode');
      return;
    }

    if (pincode.length != 6) {
      _showSnackBar('Pincode must be 6 digits');
      return;
    }

    if (address.isEmpty) {
      _showSnackBar('Please enter your full address');
      return;
    }

    final isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
    if (!isConnected) return;

    final userData = await UserPreference.getUserData();
    if (userData == null) return;

    _bloc.add(SubmitModuleOrder(
      stuId: userData.stuId.toString(),
      mdlId: widget.mdlId,
      name: name,
      mobile: mobile,
      pincode: pincode,
      address: address,
    ));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        body: BlocListener<ModuleOrderBloc, ModuleOrderState>(
          listener: (context, state) {
            if (state is ModuleOrderSuccess) {
              SuccessDialog.showSuccessDialog(context: this.context, message: state.response.message, btnClick: () {
                Navigator.of(context).pop(); // Pop dialog
                Navigator.of(context).pop(); // Pop screen
              });
            } else if (state is ModuleOrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.darkBlue,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      AssetsPath.signupBgImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 20.h,
                    left: 15.w,
                    right: 5.w,
                    child: CustomAppBar(
                      isBack: true,
                      title: 'Module Order Summary',
                    ),
                  ),
                  Positioned(
                    top: 90.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 0,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Please fill the details below to complete your order.',
                              style: AppTypography.inter14Medium.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            SignupFieldBox(
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hint: 'Full Name',
                                    editingController: _nameController,
                                    type: 'text',
                                    changedValue: (val) {},
                                  ),
                                  SizedBox(height: 15.h),
                                  CustomTextField(
                                    hint: 'Mobile Number',
                                    editingController: _mobileController,
                                    type: 'phone',
                                    maxLength: 10,
                                    changedValue: (val) {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            SignupFieldBox(
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hint: 'Pincode',
                                    editingController: _pincodeController,
                                    type: 'phone',
                                    maxLength: 6,
                                    changedValue: (val) {},
                                  ),
                                  SizedBox(height: 15.h),
                                  CustomTextField(
                                    hint: 'Full Address',
                                    editingController: _addressController,
                                    type: 'text',
                                    isMessageTextField: true,
                                    textFieldHeight: 100.h,
                                    changedValue: (val) {},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.h),
                            BlocBuilder<ModuleOrderBloc, ModuleOrderState>(
                              builder: (context, state) {
                                return CustomGradientButton(
                                  text: 'Submit Order',
                                  isLoading: state is ModuleOrderLoading,
                                  onPressed: _submitForm,
                                );
                              },
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
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
