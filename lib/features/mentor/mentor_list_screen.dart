import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/theme/app_typography.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_videos_list_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/mentor_item.dart';
import '../../core/widgets/mentors_videos_item.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class MentorsListScreen extends StatefulWidget {

  MentorsListScreen({
    super.key,
  });

  @override
  State<MentorsListScreen> createState() => _MentorsListScreenState();
}

class _MentorsListScreenState extends State<MentorsListScreen> {
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
                    title: '${AppLocalizations.of(context)?.mentors}',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 70.h,
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
                      child: MentorItem(
                        item: item,
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MentorsVideosListScreen(mentorName: item['name'],)),
                          );
                        },
                      ),
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
