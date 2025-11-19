import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
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
        enableCaption: true,
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
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              isBack: true,
              title: widget.videoTitle,
            ),
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
          ],
        ),
      ),
    );
  }
}

