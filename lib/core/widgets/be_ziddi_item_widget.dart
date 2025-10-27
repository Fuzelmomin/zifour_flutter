import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../constants/app_colors.dart';
import '../theme/app_typography.dart';
import '../utils/gradient_text.dart';

class BeZiddiItemWidget extends StatelessWidget {
  const BeZiddiItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('🔥'),
        GradientText(
          text: ' ${AppLocalizations.of(context)?.beZiddi}',
          gradient: const LinearGradient(
            colors: [AppColors.white, AppColors.pinkColor1],
          ),
          style: AppTypography.inter14SemiBold,
        ),
      ],
    );
  }
}
