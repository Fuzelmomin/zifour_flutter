import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/services/subject_service.dart';
import '../../core/utils/user_preference.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../l10n/app_localizations.dart';
import '../dashboard/video_player_screen.dart';
import '../practics_mcq/model/submit_mcq_answer_model.dart';
import '../practics_mcq/question_mcq_screen.dart';
import '../solution_videos/solution_videos_screen.dart';
import 'bloc/challenge_result_bloc.dart';
import 'model/challenge_result_model.dart';

class NewResultScreen extends StatelessWidget {
  final String? title;
  final String crtChlId;
  final String? solution;

  final String screenType;
  final String? pkId;
  final String? paperId;
  final SubmitMcqAnswerResponse? result;

  const NewResultScreen({
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
      child: _NewResultView(
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

class _NewResultView extends StatefulWidget {
  final String? title;
  final String crtChlId;
  final String? solution;

  final String screenType;
  final String? pkId;
  final String? paperId;
  final SubmitMcqAnswerResponse? result;

  const _NewResultView({
    this.title,
    required this.crtChlId,
    required this.screenType,
    this.solution,
    this.pkId,
    this.paperId,
    this.result
  });

  @override
  State<_NewResultView> createState() => _NewResultViewState();
}

class _NewResultViewState extends State<_NewResultView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _gaugeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _gaugeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ──────────────────────── Shimmer / Error ────────────────────────

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

  Widget _buildError(
      {required String message, required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.orange, size: 60.sp),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.inter16Regular
                .copyWith(color: AppColors.white.withOpacity(0.8)),
          ),
          SizedBox(height: 24.h),
          CustomGradientButton(text: 'Retry', onPressed: onRetry),
        ],
      ),
    );
  }

  // ──────────────────────── Main Content ────────────────────────

  /// Strips trailing non-numeric characters (%, /, etc.) before parsing.
  static double _parseNum(String? raw) {
    if (raw == null || raw.isEmpty) return 0;
    // Remove everything that isn't a digit, minus sign, or decimal point
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  Widget _buildContent(ChallengeResultResponse data) {
    final int total = int.tryParse(data.total ?? '0') ?? 0;
    final int correct = int.tryParse(data.correct ?? '0') ?? 0;
    final int wrong = int.tryParse(data.wrong ?? '0') ?? 0;
    final int skipped = int.tryParse(data.unattended ?? '0') ?? 0;
    final int attended = int.tryParse(data.attended ?? '0') ?? 0;
    final double percentage = _parseNum(data.percentage);
    final double marks = _parseNum(data.marks);

    // Computed metrics
    final int accuracyScore = percentage.round();
    final int speedScore =
        total > 0 ? ((marks / total) * 100).round().clamp(0, 100) : 0;
    final int timePressure =
        attended > 0 ? ((skipped / total) * 100).round().clamp(0, 100) : 0;
    final int consistentEffort =
        total > 0 ? ((attended / total) * 100).round().clamp(0, 100) : 0;

    // Determine screen-specific labels
    final String typeLabel = widget.screenType == "1"
        ? "Practice"
        : widget.screenType == "4"
            ? "Test Series"
            : "Challenge";

    final String topicName = data.pkName?.isNotEmpty == true
        ? data.pkName!
        : data.subject?.isNotEmpty == true
            ? data.subject!
            : typeLabel;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title ──
          RichText(
            text: TextSpan(
              style: AppTypography.inter16Regular
                  .copyWith(color: AppColors.white.withOpacity(0.6)),
              children: [
                TextSpan(text: 'You attempted '),
                TextSpan(
                  text: '$attended',
                  style: AppTypography.inter16Medium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                TextSpan(
                    text: ' questions in the topic of '),
                TextSpan(
                  text: topicName,
                  style: AppTypography.inter16Medium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25.h),

          // ── Accuracy Gauge Card ──
          _glassCard(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                AnimatedBuilder(
                  animation: _gaugeAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      height: 200.h,
                      width: 200.h,
                      child: CustomPaint(
                        painter: _AccuracyGaugePainter(
                          percentage: percentage * _gaugeAnimation.value,
                          correct: correct,
                          wrong: wrong,
                          skipped: skipped,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(percentage * _gaugeAnimation.value).round()}%',
                                style: AppTypography.inter24Bold.copyWith(
                                  fontSize: 36.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Accuracy',
                                style: AppTypography.inter14Regular.copyWith(
                                  color: AppColors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                // ── Correct / Incorrect / Skipped Row ──
                Row(
                  children: [
                    _statColumn('$correct', 'Correct',
                        const Color(0xFF4CAF50)),
                    _dividerVertical(),
                    _statColumn('$wrong', 'Incorrect',
                        const Color(0xFFFF6B6B)),
                    _dividerVertical(),
                    _statColumn('$skipped', 'Skipped',
                        AppColors.white.withOpacity(0.5)),
                  ],
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),

          SizedBox(height: 15.h),

          // ── Questions Wrong Banner ──
          if (wrong > 0)
            _glassCard(
              child: Row(
                children: [
                  Text('😤', style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '$wrong Questions Wrong',
                      style: AppTypography.inter14SemiBold.copyWith(
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onViewSolutions(),
                    child: Text(
                      'Review Mistakes',
                      style: AppTypography.inter14Medium.copyWith(
                        color: AppColors.skyColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.skyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (wrong > 0) SizedBox(height: 15.h),

          // ── 2×2 Metric Cards ──
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: _metricCard(
                  icon: Icons.speed_rounded,
                  iconColor: const Color(0xFFBB86FC),
                  label: 'Speed',
                  labelBold: 'Score',
                  value: '$speedScore / 100',
                ),
              ),
              Expanded(
                child: _metricCard(
                  icon: Icons.track_changes_rounded,
                  iconColor: const Color(0xFF4CAF50),
                  label: 'Accuracy',
                  labelBold: 'Score',
                  value: '$accuracyScore / 100',
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: _metricCard(
                  icon: Icons.timer_outlined,
                  iconColor: const Color(0xFFFF9800),
                  label: 'Time',
                  labelBold: 'Pressure',
                  value: '$timePressure%',
                ),
              ),
              Expanded(
                child: _metricCard(
                  icon: Icons.trending_up_rounded,
                  iconColor: const Color(0xFF29B6F6),
                  label: 'Consistent',
                  labelBold: 'Effort',
                  value: '$consistentEffort%',
                ),
              ),
            ],
          ),

          SizedBox(height: 25.h),

          // ── Action Button ──
          // if (widget.screenType != "3")
          //   CustomGradientButton(
          //     text:
          //         '⚡ Re-Practice This Topic Again ($total MCQs)',
          //     onPressed: () => _onViewSolutions(),
          //   ),

          widget.screenType == "3" ? Container() : CustomGradientButton(
            text: 'View Solutions',
            onPressed: () async{
              print("View Solutions: ${widget.solution}");
              final user = await UserPreference.getUserData();

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
                    builder: (context) => VideoSolutionUnavailableDialog(
                      from: "solution",
                      mcqType: widget.screenType,
                      medType: user?.stuMedId ?? '2',
                    ),
                  );
                }
              }

            },
          ),

          SizedBox(height: 70.h),
        ],
      ),
    );
  }

  // ──────────────────────── Helper Widgets ────────────────────────

  Widget _statColumn(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.inter20SemiBold.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.inter12Regular.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerVertical() {
    return Container(
      width: 1,
      height: 40.h,
      color: AppColors.white.withOpacity(0.15),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String labelBold,
    required String value,
  }) {
    return _glassCard(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$label ',
                        style: AppTypography.inter12Regular.copyWith(
                          color: AppColors.white.withOpacity(0.7),
                        ),
                      ),
                      TextSpan(
                        text: labelBold,
                        style: AppTypography.inter12Medium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTypography.inter16SemiBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onViewSolutions() async{
    final user = await UserPreference.getUserData();
    if (widget.screenType == "2") {
      _showSubjectDialog(context, widget.crtChlId, "", "expert");
    } else if (widget.screenType == "4") {
      _showSubjectDialog(context, "", widget.paperId ?? '', "test_series");
    } else {
      if (widget.solution != null && widget.solution!.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              videoId: widget.solution ?? '',
              videoTitle: "",
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => VideoSolutionUnavailableDialog(
            from: "solution",
            mcqType: widget.screenType,
            medType: user?.stuMedId ?? '2',
          ),
        );
      }
    }
  }

  // ──────────────────────── Subject Dialog ────────────────────────

  void _showSubjectDialog(
      BuildContext context, String chalId, String paperId, String type) {
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
                      child: Text('No subjects available.',
                          style: TextStyle(color: Colors.white70)),
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
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                color: Colors.white70, size: 16.sp),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SolutionVideosListScreen(
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
                      child: Text('Cancel',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 14.sp)),
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

  // ──────────────────────── Build ────────────────────────

  @override
  Widget build(BuildContext context) {
    // Determine title
    final String appBarTitle;
    if (widget.screenType == "1") {
      appBarTitle = 'Practice Completed Successfully! 🏆';
    } else if (widget.screenType == "4") {
      appBarTitle = 'Test Series Completed! 🏆';
    } else {
      appBarTitle = widget.title ?? 'Challenge Result 🏆';
    }

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
                  title: appBarTitle,
                ),
              ),

              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child:
                    BlocBuilder<ChallengeResultBloc, ChallengeResultState>(
                  builder: (context, state) {
                    // For Practice (1) / Test Series (4): prefer BLoC data if loaded,
                    // otherwise fall back to widget.result
                    if (widget.screenType == "1" ||
                        widget.screenType == "4") {
                      // If BLoC has loaded data from the API, use it
                      if (state.status == ChallengeResultStatus.success &&
                          state.data != null) {
                        return _buildContent(state.data!);
                      }
                      // Show shimmer while BLoC is loading
                      if (state.status == ChallengeResultStatus.loading ||
                          state.status == ChallengeResultStatus.initial) {
                        // If widget.result is available, use it immediately
                        if (widget.result != null) {
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
                            pdfFile: widget.result?.pdfFile ?? "",
                          );
                          return _buildContent(data);
                        }
                        return _buildShimmerLoader();
                      }
                      // If BLoC failed but widget.result exists, fall back
                      if (widget.result != null) {
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
                          pdfFile: widget.result?.pdfFile ?? "",
                        );
                        return _buildContent(data);
                      }
                      return _buildError(
                        message: state.errorMessage ?? 'Unable to load result.',
                        onRetry: () {
                          context.read<ChallengeResultBloc>().add(
                            ChallengeResultRequested(
                              crtChlId: widget.crtChlId,
                              apiType: widget.screenType,
                              pkId: widget.pkId,
                              paperId: widget.paperId,
                            ),
                          );
                        },
                      );
                    } else {
                      switch (state.status) {
                        case ChallengeResultStatus.loading:
                        case ChallengeResultStatus.initial:
                          return _buildShimmerLoader();
                        case ChallengeResultStatus.failure:
                          return _buildError(
                            message: state.errorMessage ??
                                'Unable to load result.',
                            onRetry: () {
                              context.read<ChallengeResultBloc>().add(
                                    ChallengeResultRequested(
                                      crtChlId: widget.crtChlId,
                                      apiType: widget.screenType,
                                      pkId: widget.pkId,
                                      paperId: widget.paperId,
                                    ),
                                  );
                            },
                          );
                        case ChallengeResultStatus.success:
                          return _buildContent(state.data!);
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

  // ──────────────────────── Glass Card ────────────────────────

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
}

// ════════════════════════════════════════════════════════════════
//  Circular Accuracy Gauge Painter
// ════════════════════════════════════════════════════════════════

class _AccuracyGaugePainter extends CustomPainter {
  final double percentage;
  final int correct;
  final int wrong;
  final int skipped;

  _AccuracyGaugePainter({
    required this.percentage,
    required this.correct,
    required this.wrong,
    required this.skipped,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 12;
    const strokeWidth = 14.0;
    const startAngle = 135.0; // start from bottom-left
    const totalSweep = 270.0; // 3/4 of circle

    final total = correct + wrong + skipped;

    // Draw background track
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _degToRad(startAngle),
      _degToRad(totalSweep),
      false,
      bgPaint,
    );

    if (total == 0) return;

    // Calculate sweep angles based on proportions
    final correctSweep = (correct / total) * totalSweep;
    final wrongSweep = (wrong / total) * totalSweep;
    final skippedSweep = (skipped / total) * totalSweep;

    // Segment colors
    const greenColor = Color(0xFF4CAF50);
    const yellowColor = Color(0xFFFFEB3B);
    const orangeColor = Color(0xFFFF9800);
    const redColor = Color(0xFFFF5252);
    const grayColor = Color(0xFF9E9E9E);

    // Draw segments: Correct (green), Wrong (red/orange), Skipped (gray)
    double currentAngle = startAngle;

    // Correct segment (green gradient feel)
    if (correctSweep > 0) {
      final correctPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Use gradient effect by drawing with a shader
      correctPaint.shader = SweepGradient(
        center: Alignment.center,
        startAngle: _degToRad(startAngle),
        endAngle: _degToRad(startAngle + correctSweep),
        colors: const [yellowColor, greenColor],
        transform: GradientRotation(_degToRad(startAngle)),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degToRad(currentAngle),
        _degToRad(correctSweep),
        false,
        correctPaint,
      );
      currentAngle += correctSweep;
    }

    // Wrong segment (red/orange)
    if (wrongSweep > 0) {
      final wrongPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      wrongPaint.shader = SweepGradient(
        center: Alignment.center,
        startAngle: _degToRad(currentAngle),
        endAngle: _degToRad(currentAngle + wrongSweep),
        colors: const [orangeColor, redColor],
        transform: GradientRotation(_degToRad(currentAngle)),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degToRad(currentAngle),
        _degToRad(wrongSweep),
        false,
        wrongPaint,
      );
      currentAngle += wrongSweep;
    }

    // Skipped segment (gray)
    if (skippedSweep > 0) {
      final skippedPaint = Paint()
        ..color = grayColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degToRad(currentAngle),
        _degToRad(skippedSweep),
        false,
        skippedPaint,
      );
    }

    // Draw subtle glow effect on the outer ring
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    if (correctSweep > 0) {
      glowPaint.color = greenColor.withOpacity(0.25);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degToRad(startAngle),
        _degToRad(correctSweep),
        false,
        glowPaint,
      );
    }
  }

  double _degToRad(double deg) => deg * (pi / 180);

  @override
  bool shouldRepaint(covariant _AccuracyGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.correct != correct ||
        oldDelegate.wrong != wrong ||
        oldDelegate.skipped != skipped;
  }
}
