import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zifour_sourcecode/core/widgets/profile_option_widget.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_list_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/my_course_item.dart';
import '../../l10n/app_localizations.dart';

class MultimediaLibraryScreen extends StatefulWidget {
  const MultimediaLibraryScreen({super.key});

  @override
  State<MultimediaLibraryScreen> createState() => _MultimediaLibraryScreenState();
}

class _MultimediaLibraryScreenState extends State<MultimediaLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> courses = [
      {
        'name': 'Sajiv Vishwa'
      },
      {
        'name': 'Prani Vanaspati'
      },
      {
        'name': 'Sajiv Vishwa'
      },
      {
        'name': 'Prani Vanaspati'
      },
      {
        'name': 'Sajiv Vishwa'
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
                    title: '${AppLocalizations.of(context)?.multimediaLibrary}',
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
                  itemCount: courses.length,
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemBuilder: (context, index) {
                    var item = courses[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: ProfileOptionWidget(
                        title: item['name'],
                        itemClick: (){

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MentorsListScreen(
                              mentorName: item['name'],
                            )),
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
