import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class ChapterSelectionBox extends StatelessWidget {
  bool? isSelected;
  String? title;
  bool? isButton;
  Color? bgColor;
  Color? borderColor;
  EdgeInsets? padding;
  Function() onTap;

  ChapterSelectionBox({super.key, this.isSelected, this.title, this.isButton, required this.onTap, this.bgColor, this.borderColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: padding ??  EdgeInsets.symmetric(
            horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B193D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected == true
                ? AppColors.purple
                : borderColor ?? Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  activeColor:
                  AppColors.purple,
                  onChanged: (_) {
                    onTap();
                  },
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 220.w,
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
            isButton == true ? Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
              child: Text(
                isSelected == true ? "Selected": "Select",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
