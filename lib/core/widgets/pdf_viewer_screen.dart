import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: CustomAppBar(
                    isBack: true,
                    title: title,
                    isActionWidget: false,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SfPdfViewer.network(
                      pdfUrl,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
