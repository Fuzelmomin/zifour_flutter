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

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {

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
                top: 40.h,
                left: 15.w,
                right: 20.w,
                child: CustomAppBar(
                  isBack: true,
                  title: '${AppLocalizations.of(context)?.helpSupport}',
                )),

            // Main Content with BLoC
            Positioned(
              top: 110.h,
              left: 20.w,
              right: 20.w,
              bottom: 0,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactUsSection(),
                    const SizedBox(height: 20),
                    _buildFAQSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactUsSection() {
    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)?.contactUs}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _contactItem(AssetsPath.svgWhatsApp, "WhatsApp"),
          _contactItem(AssetsPath.svgFacebook, "Facebook"),
          _contactItem(AssetsPath.svgInstagram, "Instagram"),
          _contactItem(AssetsPath.svgGlobe, "Website"),
        ],
      ),
    );
  }

  Widget _contactItem(String icon, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Color(0xFF1B193D),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1.0
        )
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 25.w,
            height: 25.h,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FAQ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder<int?>(
            stream: _expandedIndex.stream,
            builder: (context, snapshot) {
              final expanded = snapshot.data;
              return Column(
                children: List.generate(faqs.length, (index) {
                  final isExpanded = expanded == index;
                  final faq = faqs[index];
                  return GestureDetector(
                    onTap: () {
                      if (isExpanded) {
                        _expandedIndex.add(null);
                      } else {
                        _expandedIndex.add(index);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                          color: Color(0xFF1B193D),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color: AppColors.white.withOpacity(0.1),
                              width: 1.0
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  faq["title"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 10),
                            Text(
                              faq["desc"]!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

}
