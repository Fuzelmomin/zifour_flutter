import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/mentors_videos_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class MentorsVideosListScreen extends StatefulWidget {
  String? mentorName;

  MentorsVideosListScreen({
    super.key,
    this.mentorName
  });

  @override
  State<MentorsVideosListScreen> createState() => _MentorsVideosListScreenState();
}

class _MentorsVideosListScreenState extends State<MentorsVideosListScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mentors = [
      {
        'name': 'Jhone Doe',
        'desc': 'Video Description',
        'img': 'https://i.pravatar.cc/300?img=1',
        'time': '10:30',
      },
      {
        'name': 'Jhone Doe',
        'desc': 'Video Description',
        'img': 'https://i.pravatar.cc/300?img=2',
        'time': '10:30',
      },
      {
        'name': 'Jhone Doe',
        'desc': 'Video Description',
        'img': 'https://i.pravatar.cc/300?img=3',
        'time': '10:30',
      },
      {
        'name': 'Jhone Doe',
        'desc': 'Video Description',
        'img': 'https://i.pravatar.cc/300?img=4',
        'time': '10:30',
      },
    ];
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
                    title: widget.mentorName ?? '${AppLocalizations.of(context)?.mentors}',
                  )),
          
          
              widget.mentorName == null ? Positioned(
                  top: 70.h,
                  left: 20.w,
                  right: 20.w,
                  child: Text(
                    '${AppLocalizations.of(context)?.zMentors}',
                    style: AppTypography.inter18SemiBold,
                  )) : Container(),
          
              // Main Content with BLoC
              Positioned(
                top: 100.h,
                left: 20.w,
                right: 20.w,
                bottom: 0,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: mentors.length,
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemBuilder: (context, index) {
                    var item = mentors[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: MentorVideosItem(item: item,),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
