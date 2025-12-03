import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/constants/app_colors.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/custom_gradient_button.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/model/challenges_list_model.dart';

import '../../l10n/app_localizations.dart';

class ChallengesItemWidget extends StatelessWidget {
  final ChallengeListItem? challenge;
  final String? btnName;
  final Function() onTap;

  ChallengesItemWidget({
    super.key,
    this.challenge,
    this.btnName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SignupFieldBox(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challenge?.challengeName ?? 'Challenge',
            style: AppTypography.inter16Medium,
          ),
          SizedBox(height: 7.h,),
          Text(
            _formatDate(challenge?.createdAt),
            style: AppTypography.inter12SemiBold.copyWith(
              color: AppColors.orange
            ),
          ),
          SizedBox(height: 10.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.w,
            children: [
              if (challenge?.subjects != null && challenge!.subjects.isNotEmpty)
                Expanded(
                  flex: 3,
                  child: _customContainer(
                    '${AppLocalizations.of(context)?.subject}',
                    challenge!.subjects,
                  ),
                ),
              if (challenge?.chapters != null && challenge!.chapters.isNotEmpty)
                Expanded(
                  flex: 3,
                  child: _customContainer(
                    '${AppLocalizations.of(context)?.chapter}',
                    challenge!.chapters,
                  ),
                ),
            ],
          ),
          if (challenge?.topics != null && challenge!.topics.isNotEmpty) ...[
            SizedBox(height: 12.h,),
            _customContainer(
              '${AppLocalizations.of(context)?.topic}',
              challenge!.topics,
            ),
          ],
          SizedBox(height: 12.h,),
          CustomGradientArrowButton(
            text: btnName ?? '',
            onPressed: () {
              onTap();
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

Widget _customContainer(String title, String subTitle) {
  return Container(
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Color(0xFF0D0B2F).withOpacity(0.4),
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      border: BoxBorder.all(
        color: AppColors.white.withOpacity(0.1),
        width: 1.0
      ),
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 7.h,
      children: [
        Text(
          title,
          style: AppTypography.inter12Regular.copyWith(
            color: AppColors.white.withOpacity(0.5)
          ),
        ),

        Text(
          subTitle,
          style: AppTypography.inter14Medium,
        ),
      ],
    ),
  );
}
