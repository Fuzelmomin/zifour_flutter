import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/utils/connectivity_helper.dart';
import '../../core/widgets/custom_app_bar.dart';
import 'bloc/lecture_view_bloc.dart';
import 'repository/lecture_view_repository.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final bool? isLive;
  final String? lecId;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.videoTitle,
    this.isLive,
    this.lecId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _hasMarkedAsViewed = false;
  late LectureViewBloc _lectureViewBloc;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        enableCaption: false,
        isLive: widget.isLive ?? false,
      ),
    );

    // Initialize bloc
    _lectureViewBloc = LectureViewBloc(repository: LectureViewRepository());

    // Call API silently in background
    if (widget.lecId != null && widget.lecId!.isNotEmpty) {
      _markLectureAsViewed();
    }
  }

  Future<void> _markLectureAsViewed() async {
    if (_hasMarkedAsViewed) return;

    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) return;

    // Use post frame callback to ensure everything is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.lecId != null && widget.lecId!.isNotEmpty) {
        _hasMarkedAsViewed = true;
        _lectureViewBloc.add(
          MarkLectureAsViewed(lecId: widget.lecId!),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _lectureViewBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _lectureViewBloc,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40.h,
                    height: 40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

