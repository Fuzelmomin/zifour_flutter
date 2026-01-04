import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/widgets/custom_loading_widget.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/practics_mcq/bloc/mcq_feedback_bloc.dart';

import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class McqFeedbackDialog extends StatefulWidget {
  final String mcqId;
  final String mcqType;

  const McqFeedbackDialog({
    super.key,
    required this.mcqId,
    required this.mcqType,
  });

  @override
  State<McqFeedbackDialog> createState() => _McqFeedbackDialogState();
}

class _McqFeedbackDialogState extends State<McqFeedbackDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late McqFeedbackBloc _mcqFeedbackBloc;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mcqFeedbackBloc = McqFeedbackBloc();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.6), // Bottom
      end: Offset.zero, // Center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _controller.dispose();
    _mcqFeedbackBloc.close();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white12),
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Text(
              'Validation Error',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.purpleAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      _showErrorDialog('Please enter a feedback title');
      return;
    }

    if (description.isEmpty) {
      _showErrorDialog('Please enter a feedback description');
      return;
    }

    _mcqFeedbackBloc.add(
      McqFeedbackRequested(
        mcqId: widget.mcqId,
        mcqType: widget.mcqType,
        mcqFdbTitle: title,
        mcqFdbDescription: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mcqFeedbackBloc,
      child: BlocListener<McqFeedbackBloc, McqFeedbackState>(
        listener: (context, state) {
          if (state.status == McqFeedbackStatus.success) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.data?.message ?? 'Feedback submitted successfully.',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state.status == McqFeedbackStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Unable to submit feedback.',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<McqFeedbackBloc, McqFeedbackState>(
          builder: (context, state) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(20.w),
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: CustomLoadingOverlay(
                    isLoading: state.isLoading,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomInset: false,
                      body: Center(
                        child: SignupFieldBox(
                          padding: EdgeInsets.symmetric(
                              vertical: 30.h, horizontal: 20.w),
                          child: Form(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Feedback Icon Box
                                SvgPicture.asset(
                                  AssetsPath.svgAddNote, // Using same icon as add note for now, check if feedback specific icon exists
                                  width: 48.h,
                                  height: 48.h,
                                ),
                                SizedBox(height: 10.h),

                                const Text(
                                  "MCQ Feedback",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                CustomTextField(
                                  hint: 'Feedback Title',
                                  editingController: _titleController,
                                  type: 'text',
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  changedValue: (value) {},
                                ),
                                SizedBox(height: 10.h),

                                CustomTextField(
                                  hint: 'Feedback Description',
                                  editingController: _descriptionController,
                                  type: 'text',
                                  textFieldBgColor: Colors.black.withOpacity(0.1),
                                  textFieldHeight: 100.h,
                                  isMessageTextField: true,
                                  changedValue: (value) {},
                                ),

                                SizedBox(height: 20.h),

                                Row(
                                  spacing: 10.0,
                                  children: [
                                    Expanded(
                                      child: CustomGradientButton(
                                        text:
                                            '${AppLocalizations.of(context)?.cancel ?? 'Cancel'}',
                                        onPressed: state.isLoading
                                            ? null
                                            : () {
                                                Navigator.of(context).pop();
                                              },
                                        customDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          color: const Color(0xFF464375),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomGradientButton(
                                        text:
                                            '${AppLocalizations.of(context)?.submit ?? 'Submit'}',
                                        onPressed: state.isLoading
                                            ? null
                                            : _validateAndSubmit,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
