import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/widgets/custom_loading_widget.dart';
import 'package:zifour_sourcecode/features/live_class/bloc/lecture_reminder_bloc.dart';
import 'package:zifour_sourcecode/features/live_class/model/lectures_model.dart';
import 'package:zifour_sourcecode/features/live_class/repository/lecture_reminder_repository.dart';

import '../widgets/custom_gradient_button.dart';

class ReminderDialog extends StatefulWidget {
  final LectureItem? lecture;
  final String? title;
  final String? message;
  final String? btnName;
  final String? dateTime;
  final Function()? onTap;

  ReminderDialog({
    super.key,
    this.lecture,
    this.title,
    this.message,
    this.btnName,
    this.dateTime,
    this.onTap,
  });

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LectureReminderBloc(
        repository: LectureReminderRepository(),
      ),
      child: BlocListener<LectureReminderBloc, LectureReminderState>(
        listener: (context, state) {
          if (state is LectureReminderSuccess) {
            Navigator.pop(context);
            // Show snackbar after dialog is closed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                ),
              );
            });
          } else if (state is LectureReminderError) {
            Navigator.pop(context);
            // Show snackbar after dialog is closed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                ),
              );
            });
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20.w),
            child: SlideTransition(
              position: _offsetAnimation,
              child: BlocBuilder<LectureReminderBloc, LectureReminderState>(
                builder: (context, state) {
                  final isLoading = state is LectureReminderLoading;
                  return CustomLoadingOverlay(
                    isLoading: isLoading,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AssetsPath.svgRemindNoti,
                            width: 48.h,
                            height: 48.h,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            widget.title ?? "Reminder Set",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.message ??
                                "You will be reminded about this\nLive Class",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          widget.dateTime != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B193D),
                                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                                    border: Border.all(
                                      color: AppColors.white.withOpacity(0.1),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    widget.dateTime ?? '',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 13,
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 20.h),
                          // Button
                          CustomGradientButton(
                            text: widget.btnName ?? 'Okay!',
                            onPressed: isLoading
                                ? null
                                : () {
                                    _handleOkayClick(context);
                                  },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleOkayClick(BuildContext context) async {
    if (widget.lecture == null || widget.lecture!.lecId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lecture information not available'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      ConnectivityHelper.checkAndShowNoInternetScreen(context);
      return;
    }

    // Parse date and time, then subtract 15 minutes for reminder
    final reminderDateTime = _calculateReminderDateTime(
      widget.lecture!.lecDate,
      widget.lecture!.lecTime,
    );

    if (reminderDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to parse lecture date/time'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Format as "YYYY-MM-DD HH:mm:ss"
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(reminderDateTime);

    context.read<LectureReminderBloc>().add(
          AddLectureReminder(
            lecId: widget.lecture!.lecId!,
            reminderDate: formattedDate,
          ),
        );
  }

  DateTime? _calculateReminderDateTime(String? dateString, String? timeString) {
    if (dateString == null || timeString == null) {
      return null;
    }

    try {
      // Parse date (format: "14 Dec, 2025" or "14 Dec 2025")
      final cleanedDate = dateString.replaceAll(',', '').trim();
      final date = DateFormat('dd MMM yyyy').parse(cleanedDate);

      // Parse time (format: "1:00 PM" or "13:00")
      DateTime time;
      if (timeString.toLowerCase().contains('am') ||
          timeString.toLowerCase().contains('pm')) {
        // 12-hour format
        time = DateFormat('h:mm a').parse(timeString);
      } else {
        // 24-hour format
        time = DateFormat('HH:mm').parse(timeString);
      }

      // Combine date and time
      final lectureDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      // Subtract 15 minutes for reminder
      return lectureDateTime.subtract(const Duration(minutes: 15));
    } catch (e) {
      return null;
    }
  }
}
