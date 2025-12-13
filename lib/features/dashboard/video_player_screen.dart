import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.videoTitle,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Expanded(
              child: YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors.pinkColor,
                  progressColors: ProgressBarColors(
                    playedColor: AppColors.pinkColor,
                    handleColor: AppColors.pinkColor,
                  ),
                ),
                builder: (context, player) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: player,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 20.h,
              left: 10.w,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5)
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AssetsPath.svgBack,
                      width: 32.w,
                      height: 32.h,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

