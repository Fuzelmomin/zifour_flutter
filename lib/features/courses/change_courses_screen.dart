import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/api_models/login_model.dart';
import 'package:zifour_sourcecode/core/api_models/profile_model.dart';
import 'package:zifour_sourcecode/core/api_models/subject_model.dart';
import 'package:zifour_sourcecode/core/services/subject_service.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/auth/bloc/profile_bloc.dart';
import 'package:zifour_sourcecode/features/auth/repository/profile_repository.dart';
import 'package:zifour_sourcecode/features/courses/bloc/change_course_bloc.dart';
import 'package:zifour_sourcecode/features/courses/repository/change_course_repository.dart';
import 'package:zifour_sourcecode/features/subject/bloc/subject_bloc.dart';
import 'package:zifour_sourcecode/features/subject/repository/subject_repository.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/chapter_selection_box.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../l10n/app_localizations.dart';

class ChangeCourseScreen extends StatefulWidget {
  const ChangeCourseScreen({super.key});

  @override
  State<ChangeCourseScreen> createState() => _ChangeCourseScreenState();
}

class _ChangeCourseScreenState extends State<ChangeCourseScreen> {
  // BehaviorSubjects for reactive state management
  final BehaviorSubject<String?> _selectedStdId = BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<String?> _selectedExmId = BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<String?> _selectedMedId = BehaviorSubject<String?>.seeded(null);
  final BehaviorSubject<List<String>> _selectedSubIds =
      BehaviorSubject<List<String>>.seeded([]);

  final SubjectService _subjectService = SubjectService();
  bool _hasInitialized = false;
  StreamSubscription<String?>? _examSubscription;

  Future<void> _checkConnectivityAndLoad(BuildContext blocContext) async {
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (isConnected) {
      if (!_hasInitialized) {
        _hasInitialized = true;
        final user = UserPreference.userNotifier.value;
        if (user != null) {
          blocContext.read<ProfileBloc>().add(FetchProfile(stuId: user.stuId));
          // Load subjects if not already loaded (initial load can update service if needed, 
          // but better to keep it consistent and update only on save)
          blocContext.read<SubjectBloc>().add(SubjectRequested(
                exmId: user.stuExmId,
                updateService: false,
              ));
        } else {
          UserPreference.getUserData().then((userData) {
            if (userData != null && mounted) {
              blocContext.read<ProfileBloc>().add(FetchProfile(stuId: userData.stuId));
              blocContext.read<SubjectBloc>().add(SubjectRequested(
                    exmId: userData.stuExmId,
                    updateService: false,
                  ));
            }
          });
        }
      }
    } else {
      ConnectivityHelper.checkAndShowNoInternetScreen(context);
    }
  }

  @override
  void dispose() {
    _selectedStdId.close();
    _selectedExmId.close();
    _selectedMedId.close();
    _selectedSubIds.close();
    _examSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => ChangeCourseBloc()),
        BlocProvider(create: (context) => SubjectBloc()),
      ],
      child: Builder(
        builder: (blocContext) {
          // Initialize exam subscription once blocs are available
          if (_examSubscription == null) {
            _examSubscription = _selectedExmId.stream.listen((exmId) {
              if (exmId != null && _hasInitialized && mounted) {
                blocContext.read<SubjectBloc>().add(SubjectRequested(
                      exmId: exmId,
                      updateService: false,
                    ));
              }
            });
          }

          // Initialize after providers are available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _checkConnectivityAndLoad(blocContext);
            }
          });

          return BlocListener<ChangeCourseBloc, ChangeCourseState>(
            listener: (context, state) {
              if (state is ChangeCourseSuccess) {
                // Update SubjectService with the current subjects in SubjectBloc
                final subjectBloc = context.read<SubjectBloc>();
                if (subjectBloc.state.data != null) {
                  _subjectService.updateSubjects(subjectBloc.state.data!.subjectList);
                }

                _updateUserDataInSharedPreferences();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.pop(context);
              } else if (state is ChangeCourseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.darkBlue,
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
                      right: 20.w,
                      child: CustomAppBar(
                        isBack: true,
                        title: '${AppLocalizations.of(context)?.changeCourse}',
                      ),
                    ),

                    // Main Content with BLoC
                    Positioned(
                      top: 90.h,
                      left: 20.w,
                      right: 20.w,
                      bottom: 0,
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, profileState) {
                          if (profileState is ProfileLoading) {
                            return _buildShimmerLoading();
                          }

                          if (profileState is ProfileError) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    profileState.message,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.inter14Regular.copyWith(
                                      color: AppColors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ElevatedButton(
                                    onPressed: () {
                                      _hasInitialized = false;
                                      _checkConnectivityAndLoad(context);
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (profileState is ProfileLoaded) {
                            // Initialize selected values if not already set (only once)
                            if (_selectedStdId.value == null) {
                              _selectedStdId.add(profileState.selectedStdId);
                            }
                            if (_selectedExmId.value == null) {
                              _selectedExmId.add(profileState.selectedExmId);
                            }
                            if (_selectedMedId.value == null) {
                              _selectedMedId.add(profileState.selectedMedId);
                            }
                            // Initialize subject from user data
                            if (_selectedSubIds.value.isEmpty) {
                              final user = UserPreference.userNotifier.value;
                              if (user?.stuSubId != null && user!.stuSubId!.isNotEmpty) {
                                _selectedSubIds.add([user.stuSubId!]);
                              } else {
                                // Try to get from SharedPreferences if notifier is null
                                UserPreference.getUserData().then((userData) {
                                  if (userData?.stuSubId != null &&
                                      userData!.stuSubId!.isNotEmpty &&
                                      _selectedSubIds.value.isEmpty) {
                                    _selectedSubIds.add([userData.stuSubId!]);
                                  }
                                });
                              }
                            }

                            return _buildContent(profileState);
                          }

                          return const SizedBox.shrink();
                        },
                      ),
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

  Widget _buildContent(ProfileLoaded profileState) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: SignupFieldBox(
              child: Column(
                children: [
                  // Class Dropdown
                  StreamBuilder<String?>(
                    stream: _selectedStdId.stream,
                    builder: (context, snapshot) {
                      final selectedStdId = snapshot.data ?? profileState.selectedStdId;
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: const Color(0xFF2A2663),
                            value: selectedStdId.isNotEmpty
                                ? selectedStdId
                                : profileState.standardList.isNotEmpty
                                    ? profileState.standardList.first.stdId
                                    : null,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            style: const TextStyle(color: Colors.white),
                            items: profileState.standardList
                                .map((std) => DropdownMenuItem(
                                      value: std.stdId,
                                      child: Text(std.name),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _selectedStdId.add(val);
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Medium Options
                  StreamBuilder<String?>(
                    stream: _selectedMedId.stream,
                    builder: (context, snapshot) {
                      final selectedMedId = snapshot.data ?? profileState.selectedMedId;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: profileState.mediumList
                            .map((medium) => _mediumButton(
                                  medium.medName,
                                  medium.medId,
                                  selectedMedId == medium.medId,
                                ))
                            .toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Exam Options
                  StreamBuilder<String?>(
                    stream: _selectedExmId.stream,
                    builder: (context, snapshot) {
                      final selectedExmId = snapshot.data ?? profileState.selectedExmId;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: profileState.examList
                            .map((exam) => _examButton(
                                  exam.name,
                                  exam.exmId,
                                  selectedExmId == exam.exmId,
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),

          // Subject Selection
          Visibility(
            visible: false,
            child: SignupFieldBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SELECT SUBJECT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "STEP 1",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  BlocBuilder<SubjectBloc, SubjectState>(
                    builder: (context, subjectState) {
                      final subjects = subjectState.data?.subjectList ?? [];
                      final isLoading = subjectState.status == SubjectStatus.loading;

                      if (isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      }

                      return StreamBuilder<List<String>>(
                        stream: _selectedSubIds.stream,
                        builder: (context, snapshot) {
                          final selectedList = snapshot.data ?? [];
                          if (subjects.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  'No subjects available',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: subjects.map((subject) {
                              final isSelected = selectedList.contains(subject.subId);
                              return ChapterSelectionBox(
                                onTap: () {
                                  // Only one subject can be selected at a time
                                  if (isSelected) {
                                    // If already selected, deselect it
                                    _selectedSubIds.add([]);
                                  } else {
                                    // Select only this subject (replace previous selection)
                                    _selectedSubIds.add([subject.subId]);
                                  }
                                },
                                title: subject.name,
                                isButton: true,
                                isSelected: isSelected,
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),
          BlocBuilder<ChangeCourseBloc, ChangeCourseState>(
            builder: (context, changeCourseState) {
              final isLoading = changeCourseState is ChangeCourseLoading;
              return CustomGradientButton(
                text: '${AppLocalizations.of(context)?.saveChanges}',
                onPressed: isLoading ? null : () => _handleSaveChanges(context),
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _examButton(String text, String exmId, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectedExmId.add(exmId),
        child: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pinkColor2 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: AppTypography.inter14Medium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected
                    ? Colors.white
                    : AppColors.white.withOpacity(0.5),
                size: 22.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mediumButton(String text, String medId, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectedMedId.add(medId),
        child: Container(
          height: 45,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.pinkColor2 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: AppTypography.inter14Medium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected
                    ? Colors.white
                    : AppColors.white.withOpacity(0.5),
                size: 22.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSaveChanges(BuildContext blocContext) async {
    final stdId = _selectedStdId.value;
    final exmId = _selectedExmId.value;
    final medId = _selectedMedId.value;
    final subIds = _selectedSubIds.value;

    if (stdId == null || stdId.isEmpty) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(
          content: Text('Please select a class'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (exmId == null || exmId.isEmpty) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(
          content: Text('Please select an exam'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (medId == null || medId.isEmpty) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(
          content: Text('Please select a medium'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (subIds.isEmpty) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(
          content: Text('Please select a subject'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      ConnectivityHelper.checkAndShowNoInternetScreen(blocContext);
      return;
    }

    final user = await UserPreference.getUserData();
    if (user == null) {
      ScaffoldMessenger.of(blocContext).showSnackBar(
        const SnackBar(
          content: Text('User data not found. Please login again.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Use first selected subject ID (API expects single sub_id)
    final subId = subIds.first;

    blocContext.read<ChangeCourseBloc>().add(
          ChangeCourseRequested(
            stuId: user.stuId,
            stuStdId: stdId,
            stuExmId: exmId,
            stuMedId: medId,
            stuSubId: subId,
          ),
        );
  }

  Future<void> _updateUserDataInSharedPreferences() async {
    final user = await UserPreference.getUserData();
    if (user == null) return;

    final stdId = _selectedStdId.value ?? user.stuStdId;
    final exmId = _selectedExmId.value ?? user.stuExmId ?? '';
    final medId = _selectedMedId.value ?? user.stuMedId;
    final subIds = _selectedSubIds.value;
    final subId = subIds.isNotEmpty ? subIds.first : user.stuSubId ?? '';

    // Create updated user data with form values
    final updatedUser = LoginData(
      stuId: user.stuId,
      stuName: user.stuName,
      stuImage: user.stuImage,
      stuMobile: user.stuMobile,
      stuEmail: user.stuEmail,
      stuCity: user.stuCity,
      stuPincode: user.stuPincode,
      stuAddress: user.stuAddress,
      stuStdId: stdId,
      stuSubId: subId,
      stuMedId: medId,
      stuExmId: exmId,
    );

    await UserPreference.saveUserData(updatedUser);
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: SignupFieldBox(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: SignupFieldBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ...List.generate(3, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
