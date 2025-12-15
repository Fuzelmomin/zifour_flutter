import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/doubts/my_doubts_list_screen.dart';

import '../../core/api_models/api_status.dart';
import '../../core/api_models/standard_model.dart';
import '../../core/api_models/subject_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/repositories/signup_repository.dart';
import '../../core/services/subject_service.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/utils/image_picker_utils.dart';
import '../../core/utils/user_preference.dart';
import '../../core/widgets/bookmark_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/custom_loading_widget.dart';
import '../../core/widgets/text_field_container.dart';
import '../../core/widgets/upload_box_widget.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/doubt_bloc.dart';
import 'bloc/doubt_event.dart';

class AskDoubtsScreen extends StatefulWidget {
  const AskDoubtsScreen({super.key});

  @override
  State<AskDoubtsScreen> createState() => _AskDoubtsScreenState();
}

class _AskDoubtsScreenState extends State<AskDoubtsScreen> {
  // Behavior Subjects
  final BehaviorSubject<String> _subjectCtrl = BehaviorSubject<String>.seeded("Subject");
  final BehaviorSubject<String> _standardCtrl = BehaviorSubject<String>.seeded("Standard");
  final BehaviorSubject<String> _topicCtrl = BehaviorSubject<String>.seeded("Select Topic");

  final TextEditingController _doubtController = TextEditingController();

  final SignupRepository _signupRepository = SignupRepository();
  final SubjectService _subjectService = SubjectService();

  List<StandardModel> _standards = [];
  List<SubjectModel> _subjects = [];
  bool _isLoadingStandards = false;
  bool _isLoadingSubjects = false;
  String? _selectedStdId;
  String? _selectedSubId;
  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isWaitingForImageUpload = false;

  @override
  void initState() {
    super.initState();
    _loadStandards();
    _loadSubjects();
  }

  Future<void> _loadStandards() async {
    setState(() => _isLoadingStandards = true);
    final response = await _signupRepository.fetchStandards();
    setState(() => _isLoadingStandards = false);
    
    if (response.status == ApiStatus.success && response.data != null) {
      setState(() {
        _standards = response.data!.standardList;
      });
    }
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoadingSubjects = true);
    final subjects = _subjectService.subjects;
    setState(() => _isLoadingSubjects = false);
    
    if (subjects.isNotEmpty) {
      setState(() {
        _subjects = subjects;
      });
    }
  }

  @override
  void dispose() {
    _subjectCtrl.close();
    _standardCtrl.close();
    _topicCtrl.close();
    _doubtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoubtBloc(),
      child: BlocConsumer<DoubtBloc, DoubtState>(
        listener: (context, state) async {
          if (state is DoubtImageUploadSuccess) {
            setState(() {
              _uploadedImageUrl = state.imageUrl;
            });
            // Auto-submit after image upload success if user clicked submit
            if (_isWaitingForImageUpload) {
              _isWaitingForImageUpload = false;
              final user = await UserPreference.getUserData();
              if (user != null && _selectedStdId != null && _selectedSubId != null) {
                context.read<DoubtBloc>().add(
                  SubmitDoubt(
                    stuId: user.stuId,
                    stdId: _selectedStdId!,
                    exmId: user.stuExmId ?? '1',
                    subId: _selectedSubId!,
                    medId: user.stuMedId,
                    dbtMessage: _doubtController.text.trim(),
                    dbtAttachment: state.imageUrl,
                  ),
                );
              }
            }
          } else if (state is DoubtImageUploadError) {
            _isWaitingForImageUpload = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is DoubtSubmitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            // Reset form before navigating
            _resetForm(context);
            // Navigate to MyDoubtsListScreen
            // Future.microtask(() {
            //   if (mounted) {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(builder: (context) => MyDoubtsListScreen()),
            //     );
            //   }
            // });

            Navigator.pop(context, true);
          } else if (state is DoubtSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, doubtState) {
          final isLoading = doubtState is DoubtImageUploading || doubtState is DoubtSubmitting;
          
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.darkBlue,
              child: SafeArea(
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
                    Positioned(
                      top: 20.h,
                      left: 15.w,
                      right: 5.w,
                      child: CustomAppBar(
                        isBack: true,
                        title: '${AppLocalizations.of(context)?.askYourDoubts}',
                        isActionWidget: true,
                        actionWidget: Text(
                          '${AppLocalizations.of(context)?.pastDoubts}',
                          style: AppTypography.inter14Bold.copyWith(
                            color: AppColors.pinkColor,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.pinkColor
                          ),
                        ),
                        actionClick: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MyDoubtsListScreen()),
                          // );
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    Positioned(
                      left: 20.w,
                      right: 20.w,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(AssetsPath.svgFour),
                      ),
                    ),

                    // Main Content
                    Positioned(
                      top: 90.h,
                      left: 20.w,
                      right: 20.w,
                      bottom: 0,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)?.getExpertAnswer}',
                              style: AppTypography.inter16Regular.copyWith(
                                color: AppColors.white.withOpacity(0.6)
                              ),
                            ),

                            SizedBox(height: 25.h),

                            _buildStandardAndSubject(),

                            // Topic dropdown (optional)
                            // SizedBox(height: 15.h),
                            // _buildTopicDropdown(),

                            SizedBox(height: 15.h),

                            // Doubt text input
                            CustomTextField(
                              editingController: _doubtController,
                              hint: '${AppLocalizations.of(context)?.typeYourDoubt}',
                              type: 'text',
                              isMessageTextField: true,
                              textFieldHeight: 200.h,
                            ),

                            SizedBox(height: 15.h),

                            // Upload box
                            UploadDocBoxWidget(
                              title: '${AppLocalizations.of(context)?.uploadYourImage}',
                              itemClick: () => _handleImagePicker(context),
                              imageFile: _selectedImage,
                            ),

                            SizedBox(height: 50.h),
                            CustomGradientArrowButton(
                              text: "${AppLocalizations.of(context)!.submitDoubt}",
                              isLoading: isLoading,
                              onPressed: isLoading ? null : () => _handleSubmitDoubt(context),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Loading overlay
                    if (isLoading)
                      CustomLoadingWidget.fullScreen(
                        message: doubtState is DoubtImageUploading 
                          ? 'Uploading image...' 
                          : 'Submitting doubt...',
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildStandardAndSubject() {
    return Row(
      spacing: 15.w,
      children: [
        Expanded(
          child: _buildStandardDropdown(),
        ),
        Expanded(
          child: _buildSubjectDropdown(),
        ),
      ],
    );
  }

  Widget _buildStandardDropdown() {
    return StreamBuilder<String>(
      stream: _standardCtrl.stream,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF2A2663),
              value: _selectedStdId,
              hint: Text(
                'Standard',
                style: AppTypography.inter14Regular.copyWith(
                  color: AppColors.hintTextColor,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: _standards.map((standard) {
                return DropdownMenuItem<String>(
                  value: standard.stdId,
                  child: Text(standard.name),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedStdId = val;
                  });
                  final selectedStandard = _standards.firstWhere((s) => s.stdId == val);
                  _standardCtrl.add(selectedStandard.name);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubjectDropdown() {
    return StreamBuilder<String>(
      stream: _subjectCtrl.stream,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF2A2663),
              value: _selectedSubId,
              hint: Text(
                'Subject',
                style: AppTypography.inter14Regular.copyWith(
                  color: AppColors.hintTextColor,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: _subjects.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject.subId,
                  child: Text(subject.name),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSubId = val;
                  });
                  final selectedSubject = _subjects.firstWhere((s) => s.subId == val);
                  _subjectCtrl.add(selectedSubject.name);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopicDropdown() {
    return StreamBuilder<String>(
      stream: _topicCtrl.stream,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF2A2663),
              value: snapshot.data == "Select Topic" ? null : snapshot.data,
              hint: Text(
                'Select Topic (Optional)',
                style: AppTypography.inter14Regular.copyWith(
                  color: AppColors.hintTextColor,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: [
                DropdownMenuItem<String>(
                  value: "Select Topic",
                  child: Text("Select Topic"),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  _topicCtrl.add(val);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleImagePicker(BuildContext context) async {
    ImagePickerUtils.showImageSourceDialog(
      context: context,
      onImageSelected: (File imageFile) {
        setState(() {
          _selectedImage = imageFile;
          _uploadedImageUrl = null;
        });
        // Just show preview, don't upload yet
      },
      onError: (String error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
          ),
        );
      },
    );
  }

  Future<void> _handleSubmitDoubt(BuildContext context) async {
    // Validation
    if (_selectedStdId == null || _selectedStdId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a standard'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedSubId == null || _selectedSubId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a subject'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_doubtController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your doubt'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Get user data
    final user = await UserPreference.getUserData();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please login again to continue'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check connectivity
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // If image is selected but not uploaded yet, upload it first
    if (_selectedImage != null && _uploadedImageUrl == null) {
      // Set flag to auto-submit after upload
      setState(() {
        _isWaitingForImageUpload = true;
      });
      // Upload image first - listener will auto-submit after success
      context.read<DoubtBloc>().add(UploadDoubtImage(_selectedImage!));
      return;
    }

    // Submit doubt directly if no image or image already uploaded
    context.read<DoubtBloc>().add(
      SubmitDoubt(
        stuId: user.stuId,
        stdId: _selectedStdId!,
        exmId: user.stuExmId ?? '1',
        subId: _selectedSubId!,
        medId: user.stuMedId,
        dbtMessage: _doubtController.text.trim(),
        dbtAttachment: _uploadedImageUrl,
      ),
    );
  }

  void _resetForm(BuildContext context) {
    _doubtController.clear();
    _selectedImage = null;
    _uploadedImageUrl = null;
    _selectedStdId = null;
    _selectedSubId = null;
    _isWaitingForImageUpload = false;
    _standardCtrl.add("Standard");
    _subjectCtrl.add("Subject");
    _topicCtrl.add("Select Topic");
    if (mounted && context.mounted) {
      context.read<DoubtBloc>().add(ResetDoubtState());
    }
  }
}
