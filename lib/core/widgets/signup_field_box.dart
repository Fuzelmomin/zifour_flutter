import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupFieldBox extends StatelessWidget {
  Widget? child;
  Color? boxBgColor;
  EdgeInsets? padding;
  EdgeInsets? margin;
  SignupFieldBox({super.key, this.child, this.boxBgColor, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(10.0),
        margin: margin ?? null,
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
