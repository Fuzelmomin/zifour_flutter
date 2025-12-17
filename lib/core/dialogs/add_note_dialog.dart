import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/dialogs/reminder_complete_dialog.dart';
import 'package:zifour_sourcecode/core/widgets/custom_loading_widget.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/practics_mcq/bloc/mcq_notes_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/custom_gradient_button.dart';
import '../widgets/text_field_container.dart';

class AddNoteDialog extends StatefulWidget {
  final String mcqId;
  final String mcqType;

  const AddNoteDialog({
    super.key,
    required this.mcqId,
    required this.mcqType,
  });

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late McqNotesBloc _mcqNotesBloc;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mcqNotesBloc = McqNotesBloc();
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
    _mcqNotesBloc.close();
    super.dispose();
  }

  void _validateAndSubmit() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a description'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    _mcqNotesBloc.add(
      McqNotesRequested(
        mcqId: widget.mcqId,
        mcqType: widget.mcqType,
        mcqNotesTitle: title,
        mcqNotesDescription: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _mcqNotesBloc,
      child: BlocListener<McqNotesBloc, McqNotesState>(
        listener: (context, state) {
          if (state.status == McqNotesStatus.success) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.data?.message ?? 'Note added successfully.',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state.status == McqNotesStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Unable to add note.',
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<McqNotesBloc, McqNotesState>(
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
                    child: SignupFieldBox(
                      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Notification Icon Box
                            SvgPicture.asset(
                              AssetsPath.svgAddNote,
                              width: 48.h,
                              height: 48.h,
                            ),
                            SizedBox(height: 10.h),

                            const Text(
                              "Add Note!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            CustomTextField(
                              hint: 'Title of The Note',
                              editingController: _titleController,
                              type: 'text',
                              textFieldBgColor: Colors.black.withOpacity(0.1),
                              changedValue: (value) {},
                            ),
                            SizedBox(height: 10.h),

                            CustomTextField(
                              hint: 'Add Description',
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
                                    text: '${AppLocalizations.of(context)?.cancel}',
                                    onPressed: state.isLoading
                                        ? null
                                        : () {
                                      Navigator.of(context).pop();
                                    },
                                    customDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      color: const Color(0xFF464375),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CustomGradientButton(
                                    text: '${AppLocalizations.of(context)?.submit}',
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
            );
          },
        ),
      ),
    );
  }



  // Info box widget
  Widget _infoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
                letterSpacing: 0.6,
              )),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
