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

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {

  final List<Map<String, dynamic>> topUsers = [
    {
      "rank": 2,
      "name": "Micson Jhone",
      "img":
      "https://i.pravatar.cc/150?img=12",
      "stats": {"test": 1000, "chapters": 1000, "score": 1000}
    },
    {
      "rank": 1,
      "name": "Jenifer Lofen",
      "img":
      "https://i.pravatar.cc/150?img=48",
      "stats": {"test": 1000, "chapters": 1000, "score": 1000}
    },
    {
      "rank": 3,
      "name": "Rock Melts",
      "img":
      "https://i.pravatar.cc/150?img=25",
      "stats": {"test": 1000, "chapters": 1000, "score": 1000}
    },
  ];

  final List<Map<String, dynamic>> leaderboardList = List.generate(
    10,
        (i) => {
      "rank": i + 1,
      "name": "Jhone Doe",
      "img": "https://i.pravatar.cc/150?img=${i + 5}",
      "test": 1000,
      "chapters": 1000,
      "score": 1000,
    },
  );

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
                    title: 'Leaderboard',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 70.h,
                left: 12.w,
                right: 12.w,
                bottom: 0.h,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildTop3Podium(),
                    ),
                    Expanded(
                      flex: 6,
                      child: SignupFieldBox(
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: double.infinity,
                          child: ListView.separated(
                            itemCount: 5,
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemBuilder: (context, index) => Container(
                              child: _userCard(

                              ),
                            ), separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              width: double.infinity,
                              height: 0.80,
                              margin: EdgeInsets.symmetric(vertical: 10.h),
                              color: AppColors.white.withOpacity(0.1),
                            );
                          },
                          ),

                        ),
                      ),
                    )

                    // const SizedBox(height: 15),
                    // Expanded(child: _buildLeaderboardList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop3Podium() {
    return Row(
      spacing: 3.w,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: toper2And3Rank("https://i.pravatar.cc/150?img=12", "2nd", "Micson Jhone"),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: toper1Rank("https://i.pravatar.cc/150?img=48", "1st", "Jenifer Lofen"),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: toper2And3Rank("https://i.pravatar.cc/150?img=25", "3rd", "Rock Melts"),
          ),
        )
      ],
    );
  }

  Widget toper2And3Rank(String imgUrl, String rank, String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                width: 55.w,
                height: 55.h,
              ),
            ),
          ),
          SizedBox(height: 5.h,),
          Text(
            rank,
            style: AppTypography.inter14Bold,
          ),
          SizedBox(height: 5.h,),
          Text(
            name,
            style: AppTypography.inter12Medium.copyWith(
              color: Color(0xff90A2F8)
            ),
          ),
          SizedBox(height: 5.h,),
          _statChip("Test", 1000, Color(0xff3D50DF)),
          _statChip("Chapters", 1000, Color(0xff2AA939)),
          _statChip("Score", 1000, Color(0xffDF3DA1)),
          SizedBox(height: 5.h,),
        ],
      ),
    );
  }

  Widget toper1Rank(String imgUrl, String rank, String name) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xffDF3DA1).withOpacity(0.7), Color(0xffDF3DA1).withOpacity(0.2), Color(0xffDF3DA1).withOpacity(0.1), Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [

              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFE02FF), Color(0xFF2D6EF4)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.6), // white glow
                      blurRadius: 15,
                      spreadRadius: 4,
                      offset: Offset(0, 0), // glow evenly
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    fit: BoxFit.cover,
                    width: 65.w,
                    height: 65.h,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h,),
          Text(
            rank,
            style: AppTypography.inter18SemiBold.copyWith(
              fontSize: 30.sp
            ),
          ),
          SizedBox(height: 10.h,),
          Text(
            name,
            style: AppTypography.inter12Medium.copyWith(
              color: Color(0xff90A2F8)
            ),
          ),
          SizedBox(height: 5.h,),
          _statChip("Test", 1000, Color(0xff3D50DF)),
          _statChip("Chapters", 1000, Color(0xff2AA939)),
          _statChip("Score", 1000, Color(0xffDF3DA1)),
          SizedBox(height: 5.h,),
        ],
      ),
    );
  }


  Widget _statChip(String title, int value, Color valueBgColor) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.0).copyWith(bottom: 10.0),
      padding: EdgeInsets.only(left: 5.0),
      height: 30.h,
      decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.inter10SemiBold,
          ),
          Container(
            width: 40.w,
            height: 25.h,
            decoration: BoxDecoration(
              color: valueBgColor,
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: AppTypography.inter12SemiBold,
              ),
            ),
          )
        ],
      ),
    );
  }



  Widget _userCard() {
    return Container(
      margin: EdgeInsets.only(left: 15.0, top: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: "https://i.pravatar.cc/150?img=48",
                        width: 50.w,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  "Jhone Doe",
                  style: AppTypography.inter16Medium,
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF0D0B2F),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6.r),
                          bottomLeft: Radius.circular(6.r),
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.star,
                            size: 20.0,
                            color: AppColors.orange,
                          ),
                          SizedBox(width: 2.0,),
                          Text(
                            '#2',
                            style: AppTypography.inter14Bold,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.w,
            children: [
              Expanded(child: _statChip("Test", 1000, Color(0xff3D50DF))),
              Expanded(child: _statChip("Chapters", 1000, Color(0xff2AA939))),
              Expanded(child: _statChip("Score", 1000, Color(0xffDF3DA1))),
            ],
          )
        ],
      ),
    );
  }

}
