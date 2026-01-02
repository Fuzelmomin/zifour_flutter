import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/widgets/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen_protector/screen_protector.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  void initState() {
    super.initState();
    _preventScreenshot();
  }

  @override
  void dispose() {
    _allowScreenshot();
    super.dispose();
  }

  void _preventScreenshot() async {
    await ScreenProtector.preventScreenshotOn();
    // Listening for screenshot and screen recording attempts
    ScreenProtector.addListener((bool isScreenshot) {
      if (mounted) {
        _showProtectedMessage();
      }
    } as void Function()?, (bool isRecording) {
      if (mounted) {
        _showProtectedMessage();
      }
    });
  }

  void _showProtectedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Screen recording and screenshots are not allowed on this screen."),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _allowScreenshot() async {
    await ScreenProtector.preventScreenshotOff();
    ScreenProtector.removeListener();
  }

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
                    title: widget.title,
                    isLongText: true,
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
                      widget.pdfUrl,
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
