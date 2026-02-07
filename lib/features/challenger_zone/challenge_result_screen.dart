import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/services/subject_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/info_row.dart';
import '../../l10n/app_localizations.dart';
import '../dashboard/video_player_screen.dart';
import '../practics_mcq/model/submit_mcq_answer_model.dart';
import '../practics_mcq/question_mcq_screen.dart';
import '../solution_videos/solution_videos_screen.dart';
import 'bloc/challenge_result_bloc.dart';
import 'model/challenge_result_model.dart';
import '../../core/utils/download_utils.dart';

class ChallengeResultScreen extends StatelessWidget {
  final String? title;
  final String crtChlId;
  final String? solution;

  final String screenType;
  final String? pkId;
  final String? paperId;
  final SubmitMcqAnswerResponse? result;

  const ChallengeResultScreen({
    super.key, 
    this.title,
    required this.crtChlId,
    required this.screenType,
    this.solution,
    this.pkId,
    this.paperId,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChallengeResultBloc()
        ..add(ChallengeResultRequested(
          crtChlId: crtChlId,
          apiType: screenType,
          paperId: paperId,
          pkId: pkId
        )),
      child: _ChallengeResultView(
        title: title,
        crtChlId: crtChlId,
        solution: solution,
        screenType: screenType,
        pkId: pkId,
        paperId: paperId,
        result: result,
      ),
    );
  }
}

class _ChallengeResultView extends StatefulWidget {
  final String? title;
  final String crtChlId;
  final String? solution;

  final String screenType;
  final String? pkId;
  final String? paperId;
  final SubmitMcqAnswerResponse? result;

  const _ChallengeResultView({
    this.title,
    required this.crtChlId,
    required this.screenType,
    this.solution,
    this.pkId,
    this.paperId,
    this.result
  });

  @override
  State<_ChallengeResultView> createState() => _ChallengeResultViewState();
}

class _ChallengeResultViewState extends State<_ChallengeResultView> {

  String selectedFilter = "Monthly";
  List<String> filters = ["Monthly", "Weekly", "Yearly"];

  late List<ChartData> graphData;

  @override
  void initState() {
    super.initState();

    print("Result Type: ${widget.screenType}");
    graphData = [
      ChartData("Jan", 8, 5),
      ChartData("Feb", 3, 1),
      ChartData("Mar", 6, 4),
      ChartData("Apr", 7, 3),
      ChartData("May", 5, 6),
      ChartData("Jun", 8, 6),
      ChartData("Jul", 7, 7),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildShimmerLoader() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              height: 20.h,
              width: 250.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              height: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError({required String message, required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.orange,
            size: 60.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.inter16Regular.copyWith(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 24.h),
          CustomGradientButton(
            text: 'Retry',
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ChallengeResultResponse data) {
    //final data = state.data!;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.screenType == "1" ? "See how you performed in this practice." : widget.screenType == "4" ? "See how you performed in this test series." : "See how you performed in this challenge.",
            style: AppTypography.inter16Regular.copyWith(
              color: AppColors.white.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 25.h),

          /// Score Card
          _glassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.subject ?? "${widget.screenType == "1" ? "Practice Result" : widget.screenType == "4" ? "Test series Result" : "Challenge Result"}",
                  style: AppTypography.inter16Medium,
                ),
                SizedBox(height: 4),
                Text(
                  widget.screenType == "1" ? "Practice Completed" :  widget.screenType == "4" ? "Test Series Completed" : "Challenge Completed",
                  style: AppTypography.inter12SemiBold.copyWith(
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: InfoRow(
                        title: "TOTAL",
                        value: data.total ?? "0",
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                Row(
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: InfoRow(
                        title: "ATTENDED",
                        value: data.attended ?? "0",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        title: "UNATTENDED",
                        value: data.unattended ?? "0",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                
                Row(
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: InfoRow(
                        title: "CORRECT",
                        value: data.correct ?? "0",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        title: "WRONG",
                        value: data.wrong ?? "0",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                
                Row(
                  spacing: 15.w,
                  children: [
                    Expanded(
                      child: InfoRow(
                        title: "MARKS",
                        value: data.marks ?? "0",
                      ),
                    ),
                    Expanded(
                      child: InfoRow(
                        title: "PERCENTAGE",
                        value: "${data.percentage ?? '0'}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          /// Graph Card (keeping the existing graph for now)
          Visibility(
            //visible: widget.title == "Challenge Result 🏆" || widget.screenType == "1" ? false : true,
            visible: false,
            child: _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Performance Overview",
                        style: AppTypography.inter16Medium,
                      ),
                      DropdownButton(
                        dropdownColor: Colors.black87,
                        value: selectedFilter,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        style: GoogleFonts.inter(color: Colors.white),
                        items: filters.map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(item, style: const TextStyle(color: Colors.white)),
                        )).toList(),
                        onChanged: (value) {
                          setState(() => selectedFilter = value!);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: [
                      _legendDot(Colors.pinkAccent),
                      const SizedBox(width: 6),
                      Text("This month", style: AppTypography.inter14Regular.copyWith(color: const Color(0xFF848A9C))),
                      const SizedBox(width: 16),
                      _legendDot(Colors.amberAccent),
                      const SizedBox(width: 6),
                      Text("Last month", style: AppTypography.inter14Regular.copyWith(color: const Color(0xFF848A9C))),
                    ],
                  ),

                  SizedBox(height: 16),

                  /// Syncfusion Bar Chart
                  SizedBox(
                    height: 240,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      primaryXAxis: const CategoryAxis(
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      primaryYAxis: const NumericAxis(isVisible: false),
                      legend: const Legend(isVisible: false),
                      series: <CartesianSeries>[
                        ColumnSeries<ChartData, String>(
                          color: Colors.pinkAccent,
                          width: 0.4,
                          dataSource: graphData,
                          xValueMapper: (data, _) => data.month,
                          yValueMapper: (data, _) => data.value1,
                        ),
                        ColumnSeries<ChartData, String>(
                          color: Colors.amberAccent,
                          width: 0.4,
                          dataSource: graphData,
                          xValueMapper: (data, _) => data.month,
                          yValueMapper: (data, _) => data.value2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 25.h),
          Row(
            spacing: 15.w,
            children: [
              Expanded(
                child: CustomGradientButton(
                  text: 'Download PDF',
                  onPressed: () {
                    if (data.pdfFile != null && data.pdfFile!.isNotEmpty) {
                      DownloadUtils.downloadFile(
                        context: context,
                        url: data.pdfFile!,
                        fileName: "Result_${widget.crtChlId}.pdf",
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("PDF file not available for download."),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  customDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                    color: const Color(0xFF464375),
                  ),
                ),
              ),

              Expanded(
                child: widget.screenType == "3" ? Container() : CustomGradientButton(
                  text: 'View Solutions',
                  onPressed: () {
                    print("View Solutions: ${widget.solution}");

                    if(widget.screenType == "2"){
                      _showSubjectDialog(context, widget.crtChlId, "", "expert");
                    }else if(widget.screenType == "4"){
                      _showSubjectDialog(context, "", widget.paperId ?? '', "test_series");
                    }
                    else {
                      if(widget.solution != null && widget.solution!.isNotEmpty){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              videoId: widget.solution ?? '',
                              videoTitle: "",
                            ),
                          ),
                        );
                      }else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => const VideoSolutionUnavailableDialog(from: "solution",),
                        );
                      }
                    }

                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 70.h),
        ],
      ),
    );
  }


  void _showSubjectDialog(BuildContext context, String chalId, String paperId, String type) {
    final subjects = SubjectService().subjects;

    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: const Color(0xFF1E1E2E),
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SignupFieldBox(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Subject',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  if (subjects.isEmpty)
                    const Center(
                      child: Text(
                        'No subjects available.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  else
                    SizedBox(
                      height: 300.h,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: subjects.length,
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.white.withOpacity(0.1)),
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              subject.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white70,
                              size: 16.sp,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SolutionVideosListScreen(
                                    from: type,
                                    chalId: chalId,
                                    subId: subject.subId,
                                    paperId: paperId,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.darkBlue,
        child: SafeArea(
          child: Stack(
            children: [
              // Background Decoration set

              Positioned.fill(
                child: Image.asset(
                  AssetsPath.signupBgImg,
                  fit: BoxFit.cover,
                ),
              ),

              // App Bar
              Positioned(
                  top: 20.h,
                  left: 15.w,
                  right: 5.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: widget.title ?? "${widget.screenType == "1" ? "Test series Result" : 'Challenge Result 🏆'}",
                  )),
              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: BlocBuilder<ChallengeResultBloc, ChallengeResultState>(
                  builder: (context, state) {
                    if(widget.screenType == "1" || widget.screenType == "4"){
                      var data = ChallengeResultResponse(
                        message: "",
                        status: true,
                        attended: widget.result?.attended ?? "0",
                        correct: widget.result?.correct ?? "0",
                        exam: widget.result?.exam ?? "0",
                        marks: widget.result?.marks ?? "0",
                        medium: widget.result?.medium ?? "0",
                        percentage: widget.result?.percentage ?? "0",
                        pkName: widget.result?.chpName ?? "",
                        standard: widget.result?.standard ?? "0",
                        subject: widget.result?.subject ?? "0",
                        total: widget.result?.total ?? "0",
                        unattended: widget.result?.unattended ?? "0",
                        wrong: widget.result?.wrong ?? "0",
                        pdfFile: widget.result?.pdfFile ?? ""
                      );
                      return _buildContent(data);
                    }else {
                      switch (state.status) {
                        case ChallengeResultStatus.loading:
                        case ChallengeResultStatus.initial:
                          return _buildShimmerLoader();
                        case ChallengeResultStatus.failure:
                          return _buildError(
                            message: state.errorMessage ?? 'Unable to load result.',
                            onRetry: () {
                              context.read<ChallengeResultBloc>().add(
                                ChallengeResultRequested(
                                    crtChlId: widget.crtChlId,
                                    apiType: widget.screenType,
                                    pkId: widget.pkId,
                                    paperId: widget.paperId
                                ),
                              );
                            },
                          );
                        case ChallengeResultStatus.success:
                          var data = state.data;
                          return _buildContent(data!);
                      }
                    }

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

}

class ChartData {
  ChartData(this.month, this.value1, this.value2);
  final String month;
  final double value1;
  final double value2;
}
