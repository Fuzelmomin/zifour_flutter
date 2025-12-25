import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/module_item.dart';
import '../../core/widgets/pdf_viewer_screen.dart';
import 'bloc/module_list_bloc.dart';
import 'bloc/module_list_event.dart';
import 'bloc/module_list_state.dart';
import 'repository/module_list_repository.dart';

class ModuleListScreen extends StatefulWidget {
  final String subId;
  final String chapterId;
  const ModuleListScreen({
    super.key,
    required this.subId,
    required this.chapterId
  });

  @override
  State<ModuleListScreen> createState() => _ModuleListScreenState();
}

class _ModuleListScreenState extends State<ModuleListScreen> {
  final ModuleListRepository _repository = ModuleListRepository();
  late ModuleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ModuleListBloc(repository: _repository);
    _fetchModules();
  }

  void _fetchModules() async {
    final userData = await UserPreference.getUserData();
    if (userData != null) {
      _bloc.add(FetchModuleList(
        stuId: userData.stuId.toString(),
        chapterId: widget.chapterId,
      ));
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.darkBlue,
          child: SafeArea(
            child: Stack(
              children: [
                // Background Decoration
                Positioned.fill(
                  child: Image.asset(
                    AssetsPath.signupBgImg,
                    fit: BoxFit.cover,
                  ),
                ),

                // App Bar
                Positioned(
                  top: 30.h,
                  left: 15.w,
                  right: 15.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: 'Module Items',
                    isActionWidget: false,
                  ),
                ),

                // Main Content with BLoC
                Positioned(
                  top: 100.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: BlocBuilder<ModuleListBloc, ModuleListState>(
                    builder: (context, state) {
                      if (state is ModuleListLoading) {
                        return _buildShimmerLoader();
                      } else if (state is ModuleListLoaded) {
                        if (state.modules.isEmpty) {
                          return const Center(
                            child: Text(
                              'No modules found',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.modules.length,
                          padding: const EdgeInsets.only(bottom: 20),
                          itemBuilder: (context, index) {
                            final module = state.modules[index];
                            return ModuleItem(
                              title: module.name,
                              author: module.author,
                              itemClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfViewerScreen(
                                      pdfUrl: module.pdfFile,
                                      title: module.name,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is ModuleListError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.errorMessage,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10.h),
                              ElevatedButton(
                                onPressed: _fetchModules,
                                child: const Text('Retry'),
                              ),
                            ],
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

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1B193D),
      highlightColor: Colors.white.withOpacity(0.1),
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.only(bottom: 20),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1B193D),
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
      ),
    );
  }
}
