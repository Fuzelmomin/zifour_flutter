import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';
import 'chapter_selection_box.dart';
import 'signup_field_box.dart';

class MultiSelectField extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> selectedIds;
  final List<Map<String, String>> items; // List of { 'id': '...', 'name': '...' }
  final Function(List<String>) onSelectionChanged;
  final bool isLoading;

  const MultiSelectField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedIds,
    required this.items,
    required this.onSelectionChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTypography.inter12Medium.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
        ],
        InkWell(
          onTap: isLoading ? null : () => _showMultiSelectSheet(context),
          child: SignupFieldBox(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedIds.isEmpty
                        ? hint
                        : "${selectedIds.length} ${label}s selected",
                    style: AppTypography.inter14Regular.copyWith(
                      color: selectedIds.isEmpty
                          ? AppColors.hintTextColor
                          : Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.5)),
                    ),
                  )
                else
                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMultiSelectSheet(BuildContext context) {
    final tempSelectedIds = List<String>.from(selectedIds);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: const Color(0xFF1B193D),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select $label',
                          style: AppTypography.inter16SemiBold.copyWith(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            onSelectionChanged(tempSelectedIds);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Done',
                            style: AppTypography.inter14SemiBold.copyWith(color: AppColors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Text(
                              'No items available',
                              style: AppTypography.inter14Regular.copyWith(color: Colors.white.withOpacity(0.5)),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(1.w),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final itemId = item['id']!;
                              final itemName = item['name']!;
                              final isSelected = tempSelectedIds.contains(itemId);

                              return ChapterSelectionBox(
                                title: itemName,
                                isSelected: isSelected,
                                padding: EdgeInsets.zero,
                                margin: EdgeInsets.only(bottom: 5.0),
                                borderColor: Colors.transparent,
                                onTap: () {
                                  setModalState(() {
                                    if (tempSelectedIds.contains(itemId)) {
                                      tempSelectedIds.remove(itemId);
                                    } else {
                                      tempSelectedIds.add(itemId);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
