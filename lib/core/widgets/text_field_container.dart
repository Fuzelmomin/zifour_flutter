import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

class TextFieldContainer extends StatelessWidget {
  Widget? child;
  TextFieldContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
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

/*class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? type;
  final bool isPrefixIcon;
  final Widget? prefixIcon;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final TextInputAction? keyboardAction;
  final Function(String)? changedValue;
  final int? maxLength;
  final TextEditingController editingController;
  final Color? textFieldBgColor;

  const CustomTextField({
    super.key,
    this.hint,
    this.type,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isSuffixIcon = false,
    this.suffixIcon,
    this.keyboardAction,
    this.changedValue,
    this.maxLength,
    required this.editingController,
    this.textFieldBgColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: textFieldBgColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: editingController,
        textInputAction: keyboardAction ?? TextInputAction.next,
        keyboardType: type == 'phone'
            ? TextInputType.phone
            : type == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        maxLength: maxLength ?? 50,
        style: AppTypography.inter14Medium.copyWith(color: Colors.white),
        onChanged: (val){
          changedValue!(val);
        },
        decoration: InputDecoration(
          counterText: '',
          hintText: hint ?? '',
          hintStyle: AppTypography.inter14Regular.copyWith(
            color: AppColors.hintTextColor,
          ),
          prefixIcon: isPrefixIcon ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: prefixIcon,
          ) : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 24.h,
          ),
          suffixIcon: isSuffixIcon ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: suffixIcon,
          ) : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 24.h,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        ),
      ),
    );
  }
}*/

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? type;
  final bool isPrefixIcon;
  final Widget? prefixIcon;
  final bool isSuffixIcon;
  final Widget? suffixIcon;
  final TextInputAction? keyboardAction;
  final Function(String)? changedValue;
  final int? maxLength;
  final TextEditingController editingController;
  final Color? textFieldBgColor;

  final bool? isMessageTextField;
  final double? textFieldHeight;
  final bool? enabled;

  const CustomTextField({
    super.key,
    this.hint,
    this.type,
    this.isPrefixIcon = false,
    this.prefixIcon,
    this.isSuffixIcon = false,
    this.suffixIcon,
    this.keyboardAction,
    this.changedValue,
    this.maxLength,
    required this.editingController,
    this.textFieldBgColor,
    this.isMessageTextField,
    this.textFieldHeight,
    this.enabled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // For password visibility

  @override
  Widget build(BuildContext context) {
    bool isPasswordField = widget.type == 'pass';

    return Container(
      height: widget.textFieldHeight ?? 56.h,
      decoration: BoxDecoration(
        color: widget.textFieldBgColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.editingController,
        textInputAction: widget.keyboardAction ?? TextInputAction.next,
        keyboardType: widget.type == 'phone'
            ? TextInputType.phone
            : widget.type == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        maxLength: widget.maxLength ?? 50,
        maxLines: widget.isMessageTextField == true ? null : 1,
        obscureText: isPasswordField ? _obscureText : false,
        style: AppTypography.inter14Medium.copyWith(color: Colors.white),
        onChanged: (val) {
          if (widget.changedValue != null) widget.changedValue!(val);
        },
        decoration: InputDecoration(
          counterText: '',
          hintText: widget.hint ?? '',
          hintStyle: AppTypography.inter14Regular.copyWith(
            color: AppColors.hintTextColor,
          ),
          prefixIcon: widget.isPrefixIcon
              ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: widget.prefixIcon,
          )
              : null,
          prefixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 24.h,
          ),
          suffixIcon: isPasswordField
              ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[400],
                size: 20.sp,
              ),
            ),
          )
              : widget.isSuffixIcon
              ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: widget.suffixIcon,
          )
              : null,
          suffixIconConstraints: BoxConstraints(
            minWidth: 40.w,
            minHeight: 24.h,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        ),
      ),
    );
  }
}



