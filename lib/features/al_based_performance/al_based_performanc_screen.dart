import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar_plus/flutter_rating_bar_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../core/widgets/signup_field_box.dart';
import '../../core/widgets/text_field_container.dart';
import '../../l10n/app_localizations.dart';

class AiBasedPerformanceScreen extends StatefulWidget {
  const AiBasedPerformanceScreen({super.key});

  @override
  State<AiBasedPerformanceScreen> createState() => _AiBasedPerformanceScreenState();
}

class _AiBasedPerformanceScreenState extends State<AiBasedPerformanceScreen> {

  final BehaviorSubject<int?> _expandedIndex = BehaviorSubject<int?>.seeded(null);

  final List<Map<String, String>> faqs = [
    {
      "title": "How do I start a guided meditation session?",
      "desc": "You can start a guided meditation session from the main menu by selecting 'Meditation'. Choose your preferred guide and duration to begin."
    },
    {
      "title": "How do I join a support group?",
      "desc": "Go to the 'Community' tab, find a group that matches your interests, and click 'Join'."
    },
    {
      "title": "How do I manage my notifications?",
      "desc": "Navigate to Settings → Notifications to customize your preferences."
    },
    {
      "title": "How do I contact customer support?",
      "desc": "You can reach out to us through WhatsApp or email via the 'Contact Us' section above."
    },
  ];

  @override
  void dispose() {
    _expandedIndex.close();
    super.dispose();
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
                  top: 0.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '',
                  )),


            ],
          ),
        ),
      ),
    );
  }


}
