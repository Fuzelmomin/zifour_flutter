import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/core/widgets/challenge_option_box.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:zifour_sourcecode/features/challenger_zone/create_own_challenger_screen.dart';
import 'package:zifour_sourcecode/features/challenger_zone/expert_challenge_screen.dart';
import 'package:zifour_sourcecode/features/doubts/my_doubts_list_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/bookmark_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_gradient_button.dart';
import '../../core/widgets/text_field_container.dart';
import '../../core/widgets/upload_box_widget.dart';
import '../../l10n/app_localizations.dart';

class ChallengerZoneScreen extends StatefulWidget {
  const ChallengerZoneScreen({super.key});

  @override
  State<ChallengerZoneScreen> createState() => _ChallengerZoneScreenState();
}

class _ChallengerZoneScreenState extends State<ChallengerZoneScreen> {

  @override
  void dispose() {

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
                right: 5.w,
                child: CustomAppBar(
                  isBack: true,
                  title: '${AppLocalizations.of(context)?.challengerZone}',
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
                    Text(
                      '${AppLocalizations.of(context)?.chooseChallenge}',
                      style: AppTypography.inter16Regular.copyWith(
                          color: AppColors.white.withOpacity(0.6)
                      ),
                    ),
                    SizedBox(height: 25.h),
                    ChallengeOptionBox(
                      title: '${AppLocalizations.of(context)?.createOwnChallenge}',
                      subtitle: '${AppLocalizations.of(context)?.selectYourSubject}',
                      iconPath: AssetsPath.svgOwnChallenger,
                      buttonText: '${AppLocalizations.of(context)?.createOwnChallenge}',
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateOwnChallengerScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 25.h,),
                    ChallengeOptionBox(
                      title: '${AppLocalizations.of(context)?.expertsChallenge}',
                      subtitle: '${AppLocalizations.of(context)?.selectYourSubject}',
                      iconPath: AssetsPath.svgExpertChallenger,
                      buttonText: '${AppLocalizations.of(context)?.expertChallenge}',
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExpertChallengeScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _standerAndSubject(BehaviorSubject<String> _stdController, List<String> stdItems, BehaviorSubject<String> _subController, List<String> subItems) {
    return Row(
      spacing: 15.w,
      children: [
        Expanded(
          child: _buildDropdown(_stdController, stdItems),
        ),
        Expanded(
          child: _buildDropdown(_subController, subItems),
        ),

      ],
    );
  }

  Widget _buildDropdown(BehaviorSubject<String> controller, List<String> items) {
    return StreamBuilder<String>(
      stream: controller.stream,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.white.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: const Color(0xFF2A2663),
              value: snapshot.data,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Colors.white),
              style: const TextStyle(color: Colors.white),
              items: items
                  .map((cls) => DropdownMenuItem(
                value: cls,
                child: Text(cls),
              ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.add(val);
                }
              },
            ),
          ),
        );
      },
    );
  }

}
