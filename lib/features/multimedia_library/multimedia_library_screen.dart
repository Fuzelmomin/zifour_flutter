import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/widgets/profile_option_widget.dart';
import 'package:zifour_sourcecode/features/mentor/mentors_videos_list_screen.dart';
import 'package:zifour_sourcecode/features/multimedia_library/bloc/multimedia_library_bloc.dart';
import 'package:zifour_sourcecode/features/multimedia_library/repository/multimedia_library_repository.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';
import 'multimedia_videos_screen.dart';

class MultimediaLibraryScreen extends StatefulWidget {
  const MultimediaLibraryScreen({super.key});

  @override
  State<MultimediaLibraryScreen> createState() => _MultimediaLibraryScreenState();
}

class _MultimediaLibraryScreenState extends State<MultimediaLibraryScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivityAndLoad();
  }

  Future<void> _checkConnectivityAndLoad() async {
    bool isConnected = await ConnectivityHelper.checkAndShowNoInternetScreen(context);
    if (isConnected) {
      // The BlocProvider will be created in the build method, so we can't access it here directly
      // unless we move the provider up. 
      // Instead, we can rely on the BlocProvider being created in the build method 
      // and trigger the event there or use a post-frame callback if needed.
      // However, a cleaner way is to wrap the Scaffold body with BlocProvider and trigger the event in the create callback.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = MultimediaLibraryBloc(MultimediaLibraryRepository());
        ConnectivityHelper.checkConnectivity().then((isConnected) {
          if (isConnected) {
            bloc.add(FetchMultimediaLibrary());
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
                    title: '${AppLocalizations.of(context)?.multimediaLibrary}',
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: BlocBuilder<MultimediaLibraryBloc, MultimediaLibraryState>(
                    builder: (context, state) {
                      if (state is MultimediaLibraryLoading) {
                        return _buildShimmerLoading();
                      } else if (state is MultimediaLibraryLoaded) {
                        final list = state.multimediaLibraryModel.multlibList ?? [];
                        if (list.isEmpty) {
                          return Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(color: Colors.white, fontSize: 16.sp),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: list.length,
                          padding: EdgeInsets.only(bottom: 20.h),
                          itemBuilder: (context, index) {
                            var item = list[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: ProfileOptionWidget(
                                title: item.name ?? "",
                                itemClick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultimediaVideosScreen(
                                        multiMediaName: item.name ?? "",
                                        multiMediaId: item.mulibId ?? "",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else if (state is MultimediaLibraryError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.red, fontSize: 16.sp),
                          ),
                        );
                      }
                      return Container(); // Initial state
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
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!.withOpacity(0.1),
            highlightColor: Colors.grey[100]!.withOpacity(0.3),
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
