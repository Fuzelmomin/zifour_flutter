import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupFieldBox extends StatelessWidget {
  Widget? child;
  Color? boxBgColor;
  SignupFieldBox({super.key, this.child, this.boxBgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: boxBgColor ?? Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
      child: child,
    );
  }
}
