import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/course_item.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/payment/payment_status_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  final BehaviorSubject<int?> _openIndex = BehaviorSubject<int?>.seeded(null);

  final List<Map<String, String>> faqList = [
    {
      "question": "What is Viral Pitch?",
      "answer":
      "At Viral Pitch we expect at a day’s start is you, better and happier than yesterday. We have got you covered share your concern or check"
    },
    {
      "question": "How to know status of a campaign?",
      "answer":
      "You can check campaign status from your dashboard under campaigns tab."
    },
    {
      "question": "How to apply for a campaign?",
      "answer": "Browse campaign list & submit your proposal easily."
    },
  ];

  @override
  void dispose() {
    _openIndex.close();
    super.dispose();
  }

  void toggleItem(int index) {
    if (_openIndex.value == index) {
      _openIndex.add(null); // collapse
    } else {
      _openIndex.add(index); // expand
    }
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
                    title: 'Frankly ask questions',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 20.w,
                right: 20.w,
                bottom: 50.h,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      StreamBuilder<int?>(
                          stream: _openIndex.stream,
                          builder: (context, snapshot) {
                            final selected = snapshot.data;
                            return Column(
                              children: List.generate(
                                faqList.length,
                                    (index) {
                                  final isOpen = selected == index;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () => toggleItem(index),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  faqList[index]["question"]!,
                                                  style: AppTypography.inter14Medium.copyWith(
                                                    color: isOpen ? Colors.white : Color(0xff90A2F8),
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                isOpen ? Icons.remove : Icons.add,
                                                color: isOpen ? Colors.white : Color(0xff90A2F8),
                                              )
                                            ],
                                          ),

                                          /// Answer
                                          if (isOpen) ...[
                                            const SizedBox(height: 10),
                                            Text(
                                              faqList[index]["answer"]!,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 14,
                                                height: 1.4,
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
