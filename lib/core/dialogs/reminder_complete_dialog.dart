import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zifour_sourcecode/core/constants/assets_path.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_gradient_button.dart';

class ReminderDialog extends StatefulWidget {

  String? title;
  String? message;
  String? btnName;
  String? dateTime;
  Function()? onTap;
  ReminderDialog({
    super.key,
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20.w),
        child: SlideTransition(
          position: _offsetAnimation,
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
                SvgPicture.asset(AssetsPath.svgRemindNoti, width: 48.h, height: 48.h,),
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
                  widget.message ?? "You will be reminded about this\nExpert's Challenge",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 10.h),

                widget.dateTime != null ?
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: Color(0xFF1B193D),
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    border: BoxBorder.all(
                      color: AppColors.white.withOpacity(0.1),
                      width: 1.0
                    )
                  ),
                  child: Text(
                    "April 24   |   10:00 AM - 1:00 PM",
                    style: TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ) : Container(),
                SizedBox(height: 20.h),


                // Button
                CustomGradientButton(
                  text: widget.btnName ?? 'Okay!',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
