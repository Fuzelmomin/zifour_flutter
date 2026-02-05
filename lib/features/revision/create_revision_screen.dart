import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:zifour_sourcecode/core/api_models/api_status.dart';
import 'package:zifour_sourcecode/core/api_models/standard_model.dart';
import 'package:zifour_sourcecode/core/api_models/subject_model.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/repositories/signup_repository.dart';
import 'package:zifour_sourcecode/core/services/subject_service.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:zifour_sourcecode/core/widgets/custom_gradient_button.dart';
import 'package:zifour_sourcecode/core/widgets/custom_loading_widget.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/model/chapter_model.dart';
import 'package:zifour_sourcecode/features/challenger_zone/model/topic_model.dart';
import 'package:zifour_sourcecode/features/challenger_zone/repository/chapter_repository.dart';
import 'package:zifour_sourcecode/features/challenger_zone/repository/topic_repository.dart';
import 'package:zifour_sourcecode/features/revision/bloc/revision_bloc.dart';

import '../../core/api_models/api_response.dart';
import '../../core/widgets/multi_select_field.dart';
import '../../core/widgets/text_field_container.dart';

class CreateRevisionScreen extends StatefulWidget {
  const CreateRevisionScreen({super.key});

  @override
  State<CreateRevisionScreen> createState() => _CreateRevisionScreenState();
}

class _CreateRevisionScreenState extends State<CreateRevisionScreen> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final SignupRepository _signupRepository = SignupRepository();
  final SubjectService _subjectService = SubjectService();
  final ChapterRepository _chapterRepository = ChapterRepository();
  final TopicRepository _topicRepository = TopicRepository();

  List<StandardModel> _standards = [];
  List<SubjectModel> _subjects = [];
  List<ChapterModel> _chapters = [];
  List<TopicModel> _topics = [];

  String? _selectedStdId;
  List<String> _selectedSubIds = [];
  List<String> _selectedChpIds = [];
  List<String> _selectedTpcIds = [];

  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoadingDropdowns = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoadingDropdowns = true);
    final results = await Future.wait([
      _signupRepository.fetchStandards(),
    ]);

    final standardRes = results[0] as ApiResponse<StandardResponse>;
    
    if (standardRes.status == ApiStatus.success && standardRes.data != null) {
      _standards = standardRes.data!.standardList;
    }
    
    _subjects = _subjectService.subjects;
    
    setState(() => _isLoadingDropdowns = false);
  }

  Future<void> _loadChapters(List<String> subIds) async {
    setState(() {
      _isLoadingDropdowns = true;
      _chapters = [];
      _selectedChpIds = [];
      _topics = [];
      _selectedTpcIds = [];
    });
    
    // Create a list of futures to fetch chapters for each subject
    final responses = await Future.wait(
      subIds.map((id) => _chapterRepository.fetchChapters(subId: id))
    );
    
    if (mounted) {
      setState(() => _isLoadingDropdowns = false);
      List<ChapterModel> allChapters = [];
      for (var response in responses) {
        if (response.status == ApiStatus.success && response.data != null) {
          allChapters.addAll(response.data!.chapterList);
        }
      }
      setState(() {
        _chapters = allChapters;
      });
    }
  }

  Future<void> _loadTopics(List<String> chpIds) async {
    setState(() {
      _isLoadingDropdowns = true;
      _topics = [];
      _selectedTpcIds = [];
    });
    
    final response = await _topicRepository.fetchTopics(chapterIds: chpIds);
    
    if (mounted) {
      setState(() => _isLoadingDropdowns = false);
      if (response.status == ApiStatus.success && response.data != null) {
        setState(() {
          _topics = response.data!.topicList;
        });
      }
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _messageController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.pinkColor,
              onPrimary: Colors.white,
              surface: Color(0xFF1B193D),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1B193D),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _endDate = picked;
          _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RevisionBloc(),
      child: BlocListener<RevisionBloc, RevisionState>(
        listener: (context, state) {
          if (state.status == RevisionStatus.submitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.deleteMessage ?? 'Revision created successfully'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          } else if (state.status == RevisionStatus.submitFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to create revision'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<RevisionBloc, RevisionState>(
          builder: (context, state) {
            bool isSubmitting = state.status == RevisionStatus.submitting;

            return Scaffold(
              body: Container(
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
                          title: 'Create Revision',
                        ),
                      ),
                      Positioned(
                        top: 90.h,
                        left: 20.w,
                        right: 20.w,
                        bottom: 0,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plan your study and stay organized',
                                style: AppTypography.inter16Regular.copyWith(
                                  color: AppColors.white.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              Row(
                                children: [
                                  Expanded(child: _buildStandardDropdown()),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: MultiSelectField(
                                      label: 'Subject',
                                      hint: 'Select Subjects',
                                      selectedIds: _selectedSubIds,
                                      items: _subjects.map((s) => {'id': s.subId, 'name': s.name}).toList(),
                                      onSelectionChanged: (ids) {
                                        setState(() => _selectedSubIds = ids);
                                        if (ids.isNotEmpty) {
                                          _loadChapters(ids);
                                        } else {
                                          setState(() {
                                            _chapters = [];
                                            _selectedChpIds = [];
                                            _topics = [];
                                            _selectedTpcIds = [];
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              MultiSelectField(
                                label: 'Chapter',
                                hint: 'Select Chapters',
                                selectedIds: _selectedChpIds,
                                items: _chapters.map((c) => {'id': c.chpId, 'name': c.name}).toList(),
                                onSelectionChanged: (ids) {
                                  setState(() => _selectedChpIds = ids);
                                  if (ids.isNotEmpty) {
                                    _loadTopics(ids);
                                  } else {
                                    setState(() {
                                      _topics = [];
                                      _selectedTpcIds = [];
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 15.h),
                              MultiSelectField(
                                label: 'Topic',
                                hint: 'Select Topics',
                                selectedIds: _selectedTpcIds,
                                items: _topics.map((t) => {'id': t.tpcId ?? '', 'name': t.name}).toList(),
                                onSelectionChanged: (ids) {
                                  setState(() => _selectedTpcIds = ids);
                                },
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDatePickerField(
                                      'Start Date',
                                      _startDateController,
                                      () => _selectDate(context, true),
                                    ),
                                  ),
                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: _buildDatePickerField(
                                      'End Date',
                                      _endDateController,
                                      () => _selectDate(context, false),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              CustomTextField(
                                editingController: _hourController,
                                hint: 'Duration (Hours)',
                                type: 'number',
                              ),
                              SizedBox(height: 15.h),
                              CustomTextField(
                                editingController: _messageController,
                                hint: 'Revision Notes / Message',
                                type: 'text',
                                isMessageTextField: true,
                                textFieldHeight: 120.h,
                              ),
                              SizedBox(height: 40.h),
                              CustomGradientArrowButton(
                                text: 'Submit Revision',
                                isLoading: isSubmitting,
                                onPressed: isSubmitting ? null : () => _handleSubmit(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isSubmitting || _isLoadingDropdowns)
                        CustomLoadingWidget.fullScreen(
                          message: _isLoadingDropdowns ? 'Loading data...' : 'Creating revision...',
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStandardDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Standard',
          style: AppTypography.inter12Medium.copyWith(color: Colors.white),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: const Color(0xFF2A2663),
              value: _selectedStdId,
              hint: Text(
                'Standard',
                style: AppTypography.inter14Regular.copyWith(color: AppColors.hintTextColor),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: _standards.map((s) => DropdownMenuItem(value: s.stdId, child: Text(s.name, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedStdId = val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(String hint, TextEditingController controller, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 52.h,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                controller.text.isEmpty ? hint : controller.text,
                style: AppTypography.inter14Regular.copyWith(
                  color: controller.text.isEmpty ? AppColors.hintTextColor : Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.calendar_today, size: 18.sp, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_selectedStdId == null) {
      _showError('Please select standard');
      return;
    }
    if (_selectedSubIds.isEmpty) {
      _showError('Please select at least one subject');
      return;
    }
    if (_selectedChpIds.isEmpty) {
      _showError('Please select at least one chapter');
      return;
    }
    if (_selectedTpcIds.isEmpty) {
      _showError('Please select at least one topic');
      return;
    }
    if (_startDate == null) {
      _showError('Please select start date');
      return;
    }
    if (_endDate == null) {
      _showError('Please select end date');
      return;
    }
    if (_hourController.text.trim().isEmpty) {
      _showError('Please enter duration');
      return;
    }
    if (_messageController.text.trim().isEmpty) {
      _showError('Please enter message');
      return;
    }

    final user = await UserPreference.getUserData();
    if (user == null) return;

    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      _showError('No internet connection');
      return;
    }

    context.read<RevisionBloc>().add(RevisionSubmitted(
      stdId: _selectedStdId!,
      exmId: user.stuExmId ?? '1',
      subId: _selectedSubIds,
      medId: user.stuMedId ?? "",
      chpId: _selectedChpIds,
      tpcId: _selectedTpcIds,
      sDate: _startDateController.text,
      eDate: _endDateController.text,
      dHours: _hourController.text.trim(),
      message: _messageController.text.trim(),
    ));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }
}
