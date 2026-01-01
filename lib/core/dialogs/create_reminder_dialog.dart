import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';
import 'package:zifour_sourcecode/core/dialogs/reminder_complete_dialog.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/live_class/model/lectures_model.dart';

import '../widgets/custom_gradient_button.dart';

class CreateReminderDialog extends StatefulWidget {
  final LectureItem? lecture;
  final VoidCallback? onSuccess;

  const CreateReminderDialog({
    super.key,
    this.lecture,
    this.onSuccess,
  });

  @override
  State<CreateReminderDialog> createState() => _CreateReminderDialogState();
}

class _CreateReminderDialogState extends State<CreateReminderDialog>
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: SlideTransition(
          position: _offsetAnimation,
          child: SignupFieldBox(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification Icon Box
                SvgPicture.asset(AssetsPath.svgRemindNoti, width: 48.h, height: 48.h,),
                SizedBox(height: 10.h),

                const Text(
                  "Reminder Confirmed!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "We'll remind you 15 mins before the class starts.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13.5),
                ),

                const SizedBox(height: 22),

                // Class Info
                _infoBox("CLASS", widget.lecture?.chpName ?? widget.lecture?.name ?? "Lecture"),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(child: _infoBox("DATE", _formatDate(widget.lecture?.lecDate))),
                    const SizedBox(width: 12),
                    Expanded(child: _infoBox("TIME", _formatTime(widget.lecture?.lecTime))),
                  ],
                ),

                const SizedBox(height: 22),

                // Button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => ReminderDialog(
                        lecture: widget.lecture,
                        dateTime: _formatDateTime(widget.lecture?.lecDate, widget.lecture?.lecTime),
                        onSuccess: widget.onSuccess,
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFD2D7B), Color(0xFF6B2CF5)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Got it!",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }
    try {
      // Parse formats like "14 Dec, 2025" or "14 Dec 2025"
      final cleanedDate = dateString.replaceAll(',', '');
      final date = DateFormat('dd MMM yyyy').parse(cleanedDate);
      return DateFormat('MMM dd').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return 'N/A';
    }
    return timeString;
  }

  String _formatDateTime(String? dateString, String? timeString) {
    if (dateString == null || timeString == null) {
      return '';
    }
    try {
      final cleanedDate = dateString.replaceAll(',', '');
      final date = DateFormat('dd MMM yyyy').parse(cleanedDate);
      return '${DateFormat('MMMM dd').format(date)}   |   $timeString';
    } catch (e) {
      return '$dateString   |   $timeString';
    }
  }
}
