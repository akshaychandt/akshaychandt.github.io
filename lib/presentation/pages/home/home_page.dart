import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/deferred_loader.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../core/utils/url_launcher_helper.dart';
import '../../bloc/navigation/navigation_bloc.dart';
import '../../bloc/navigation/navigation_event.dart';
import '../../bloc/projects/projects_bloc.dart';
import '../../bloc/projects/projects_event.dart';
import '../../sections/hero/hero_section.dart';
import '../../sections/about/about_section.dart';
import '../../sections/skills/skills_section.dart';
import '../../sections/experience/experience_section.dart';
import '../../sections/projects/projects_section.dart';
import '../../sections/contact/contact_section.dart';
import '../../widgets/common/back_to_top_button.dart';
import '../../widgets/navigation/keyboard_navigation.dart';
import '../../widgets/navigation/navbar.dart';
import '../../widgets/footer/footer.dart';
import '../../widgets/skeleton/skeleton_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load projects
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsBloc>().add(const LoadProjectsEvent());
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Determine which section is currently visible
    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final keyContext = key.currentContext;
      if (keyContext != null) {
        final renderBox = keyContext.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final offset = renderBox.localToGlobal(Offset.zero).dy;
          if (offset <= AppDimensions.navbarHeight + 100) {
            context.read<NavigationBloc>().add(UpdateCurrentSectionEvent(i));
            break;
          }
        }
      }
    }
  }

  void _scrollToSection(int index) {
    if (index < _sectionKeys.length) {
      final key = _sectionKeys[index];
      final keyContext = key.currentContext;
      if (keyContext != null) {
        // Capture navbar offset before async gap
        final navbarOffset = ResponsiveHelper.isMobile(context)
            ? AppDimensions.navbarMobileHeight
            : AppDimensions.navbarHeight;
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
          alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        ).then((_) {
          if (!mounted) return;
          // Adjust for navbar after scroll completes
          if (_scrollController.offset > navbarOffset) {
            _scrollController.animateTo(
              _scrollController.offset - navbarOffset,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }
  }

  void _downloadResume() {
    UrlLauncherHelper.downloadResume(AppStrings.resumeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardNavigationHandler(
      sectionCount: _sectionKeys.length,
      onNavigateToSection: _scrollToSection,
      child: Scaffold(
        body: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveHelper.isMobile(context)
                        ? AppDimensions.navbarMobileHeight
                        : AppDimensions.navbarHeight,
                  ),
                  // Hero and About load immediately (above the fold)
                  HeroSection(
                    key: _sectionKeys[0],
                    onViewWorkPressed: () => _scrollToSection(4), // Projects section
                    onDownloadResumePressed: _downloadResume,
                  ),
                  AboutSection(key: _sectionKeys[1]),
                  // Skills section - deferred on web
                  DeferredLoader(
                    key: _sectionKeys[2],
                    detectorKey: 'skills_section',
                    placeholderHeight: 600,
                    placeholder: const SkillsSectionSkeleton(height: 600),
                    child: const SkillsSection(),
                  ),
                  // Experience section - deferred on web
                  DeferredLoader(
                    key: _sectionKeys[3],
                    detectorKey: 'experience_section',
                    placeholderHeight: 800,
                    placeholder: const ExperienceSectionSkeleton(height: 800),
                    child: const ExperienceSection(),
                  ),
                  // Projects section - deferred on web
                  DeferredLoader(
                    key: _sectionKeys[4],
                    detectorKey: 'projects_section',
                    placeholderHeight: 700,
                    placeholder: const ProjectsSectionSkeleton(height: 700),
                    child: const ProjectsSection(),
                  ),
                  // Contact section - deferred on web
                  DeferredLoader(
                    key: _sectionKeys[5],
                    detectorKey: 'contact_section',
                    placeholderHeight: 500,
                    placeholder: const ContactSectionSkeletonWrapper(height: 500),
                    child: const ContactSection(),
                  ),
                  const Footer(),
                ],
              ),
            ),

            // Fixed Navbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Navbar(
                scrollController: _scrollController,
                sectionKeys: _sectionKeys,
              ),
            ),

            // Back to Top Button
            BackToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }
}
