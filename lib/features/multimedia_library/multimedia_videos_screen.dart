import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/features/dashboard/video_player_screen.dart';
import 'package:zifour_sourcecode/features/multimedia_library/bloc/multimedia_videos_bloc.dart';
import 'package:zifour_sourcecode/features/multimedia_library/repository/multimedia_videos_repository.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/mentors_videos_item.dart';
import '../../l10n/app_localizations.dart';

class MultimediaVideosScreen extends StatefulWidget {
  final String multiMediaId;
  final String? multiMediaName;

  const MultimediaVideosScreen({
    super.key,
    required this.multiMediaId,
    this.multiMediaName,
  });

  @override
  State<MultimediaVideosScreen> createState() => _MultimediaVideosScreenState();
}

class _MultimediaVideosScreenState extends State<MultimediaVideosScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivityAndLoad();
  }

  Future<void> _checkConnectivityAndLoad() async {
    await ConnectivityHelper.checkAndShowNoInternetScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = MultimediaVideosBloc(MultimediaVideosRepository());
        ConnectivityHelper.checkConnectivity().then((isConnected) {
          if (isConnected) {
            bloc.add(FetchMultimediaVideos(mulibId: widget.multiMediaId));
          } else {
             ConnectivityHelper.checkAndShowNoInternetScreen(context);
          }
        });
        return bloc;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AssetsPath.signupBgImg,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 20.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: widget.multiMediaName ??
                        '${AppLocalizations.of(context)?.mentors}',
                  ),
                ),
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: BlocBuilder<MultimediaVideosBloc, MultimediaVideosState>(
                    builder: (context, state) {
                      if (state is MultimediaVideosLoading) {
                        return _buildShimmerLoading();
                      }

                      if (state is MultimediaVideosError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: () {
                                  // Trigger reload via Bloc event if needed, 
                                  // but since we are inside BlocBuilder, we need access to the bloc.
                                  // We can use context.read<MultimediaVideosBloc>().add(...)
                                  context.read<MultimediaVideosBloc>().add(FetchMultimediaVideos(mulibId: widget.multiMediaId));
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is MultimediaVideosLoaded) {
                        final videos = state.multimediaVideosModel.multvidList ?? [];
                        if (videos.isEmpty) {
                          return const Center(
                            child: Text(
                              'No videos available',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return SizedBox(
                          height: 200.h,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              final video = videos[index];
                              return MentorVideosItem(
                                videoName: video.name,
                                // Assuming thumbnail URL is not in the response based on the provided JSON.
                                // If it is, map it here. Otherwise, use a placeholder or modify MentorVideosItem to handle null.
                                // Based on previous code, it was expecting thumbnailUrl.
                                // The new model has 'youtube_code', we can construct thumbnail from it if needed.
                                // https://img.youtube.com/vi/<insert-youtube-video-id-here>/0.jpg
                                thumbnailUrl: video.youtubeCode != null ? 'https://img.youtube.com/vi/${video.youtubeCode}/0.jpg' : '',
                                itemClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VideoPlayerScreen(
                                            videoId: video.youtubeCode ?? '',
                                            videoTitle: video.name ?? '',
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SizedBox(
      height: 200.h,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.08),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: MediaQuery.of(context).size.width - 100.w,
              margin: EdgeInsets.only(right: 15.w, bottom: 15.h), // Added bottom margin for vertical list
              height: 185.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
