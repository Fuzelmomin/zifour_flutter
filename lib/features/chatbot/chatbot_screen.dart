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

class ChatboatScreen extends StatefulWidget {
  const ChatboatScreen({super.key});

  @override
  State<ChatboatScreen> createState() => _ChatboatScreenState();
}

class _ChatboatScreenState extends State<ChatboatScreen> {
  final List<String> questions = [
    "General Question",
    "Lorem Ipsum text edomen oheni",
    "Honeriee denielly hormn Iyod",
    "General Question",
  ];


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
                  top: 20.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '',
                  )),

              // Main Content with BLoC
              Positioned(
                top: 90.h,
                left: 12.w,
                right: 12.w,
                bottom: 0.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// Title
                    Container(
                      width: 300,
                      child: SignupFieldBox(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "how may i help you?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Glass card with suggestion buttons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(questions.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Color(0xff0C0A2E),
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(color: AppColors.white.withOpacity(0.3)),
                                    ),
                                    child: Text(
                                      questions[index],
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),


                    const SizedBox(height: 30),
                    // USER CHAT BUBBLE (BLUE)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF2D6EF4),
                              Color(0xFF5D8CFF),
                            ],
                          ),
                        ),
                        child: const Text(
                          "Lorem Ipsum text edomen oheni",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SYSTEM CHAT MESSAGE (GREY-PURPLE)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Lorem Ipsum text edomen oheni Ipsum text edomen oheni Lorem text edomen oheni Ipsum text edomen oheni",
                          style: TextStyle(color: Colors.white, height: 1.4),
                        ),
                      ),
                    ),
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
