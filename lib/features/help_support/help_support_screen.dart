import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zifour_sourcecode/core/widgets/signup_field_box.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/assets_path.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../l10n/app_localizations.dart';
import 'bloc/help_support_bloc.dart';
import 'model/help_support_model.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  late HelpSupportBloc _helpSupportBloc;
  final BehaviorSubject<int?> _expandedIndex = BehaviorSubject<int?>.seeded(null);

  @override
  void initState() {
    super.initState();
    _helpSupportBloc = HelpSupportBloc();
    _helpSupportBloc.add(const HelpSupportRequested());
  }

  @override
  void dispose() {
    _helpSupportBloc.close();
    _expandedIndex.close();
    super.dispose();
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _helpSupportBloc,
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
                  top: 20.h,
                  left: 15.w,
                  right: 20.w,
                  child: CustomAppBar(
                    isBack: true,
                    title: '${AppLocalizations.of(context)?.helpSupport}',
                  ),
                ),

                // Main Content
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 0,
                  child: BlocBuilder<HelpSupportBloc, HelpSupportState>(
                    builder: (context, state) {
                      if (state.status == HelpSupportStatus.loading ||
                          state.status == HelpSupportStatus.initial) {
                        return _buildShimmerLoading();
                      }

                      if (state.status == HelpSupportStatus.failure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                'https://lottie.host/b60fe9e0-8c77-4ece-b056-4d5aa54e53fa/KLlnG0PoUp.json',
                                width: 180.w,
                                height: 180.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                state.errorMessage ?? 'Unable to load details.',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () => _helpSupportBloc.add(const HelpSupportRequested()),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state.status == HelpSupportStatus.success && state.data != null) {
                        final data = state.data!;
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildContactUsSection(data),
                              const SizedBox(height: 20),
                              _buildFAQSection(data.faqList),
                              const SizedBox(height: 20),
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

  Widget _buildContactUsSection(HelpSupportResponse data) {
    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)?.contactUs}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _contactItem(AssetsPath.svgWhatsApp, "WhatsApp", data.whatsapp),
          _contactItem(AssetsPath.svgFacebook, "Facebook", data.facebook),
          _contactItem(AssetsPath.svgInstagram, "Instagram", data.instagram),
          _contactItem(AssetsPath.svgGlobe, "Website", data.website),
        ],
      ),
    );
  }

  Widget _contactItem(String icon, String title, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1B193D),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 25.w,
              height: 25.h,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(List<FaqModel> faqs) {
    if (faqs.isEmpty) return const SizedBox.shrink();

    return SignupFieldBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FAQ",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder<int?>(
            stream: _expandedIndex.stream,
            builder: (context, snapshot) {
              final expanded = snapshot.data;
              return Column(
                children: List.generate(faqs.length, (index) {
                  final isExpanded = expanded == index;
                  final faq = faqs[index];
                  return GestureDetector(
                    onTap: () {
                      _expandedIndex.add(isExpanded ? null : index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B193D),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.1),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  faq.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ],
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 10),
                            Text(
                              "Chapters: ${faq.totalChapter ?? 'N/A'}\nLectures: ${faq.totalLectures ?? 'N/A'}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SignupFieldBox(
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.08),
              highlightColor: Colors.white.withOpacity(0.2),
              child: Column(
                children: List.generate(4, (index) => Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h),
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SignupFieldBox(
            child: Shimmer.fromColors(
              baseColor: Colors.white.withOpacity(0.08),
              highlightColor: Colors.white.withOpacity(0.2),
              child: Column(
                children: List.generate(4, (index) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
