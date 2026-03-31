import 'package:get_storage/get_storage.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/generate_lesson_response_model.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/add_media_url_bottom_sheet.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/chapter_details_tooltip_section.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/document_card.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/lesson_plan_feedback_section.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/media_card.dart';
import 'package:sikshana/app/ui/components/exit_confirmation_dialog.dart';
import 'package:sikshana/app/utils/exports.dart' hide Datum;
import 'package:url_launcher/url_launcher.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// The main screen for viewing a fully generated or saved lesson plan.
///
/// This widget has been refactored to use a [CustomScrollView] to provide a
/// single, unified scrolling experience.
///
/// This widget:
/// - Shows connectivity status (offline → NoInternetScreen)
/// - Displays lesson-level information (Chapter details) as a sliver
/// - Shows a sticky tab section (Lesson / Videos / Documents)
/// - Provides Chatbot and Export icons in the AppBar
///
/// It relies on:
/// - [LessonPlanGeneratedViewController] for lesson data
/// - [NoInternetScreenController] for connectivity
class LessonPlanGeneratedViewView
    extends GetView<LessonPlanGeneratedViewController> {
  /// Creates a new instance of [LessonPlanGeneratedViewView].
  const LessonPlanGeneratedViewView({super.key});

  @override
  Widget build(BuildContext context) {
    /// Connectivity controller to display No Internet screen dynamically.
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>();

    /// Key used for opening the drawer from the CommonAppBar.
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(
      () => !connectivityController.isConnected()
          /// If offline, show the No Internet Screen
          ? const NoInternetScreenView()
          /// Otherwise load lesson plan UI
          : PopScope(
              canPop: controller.canPop.value,
              onPopInvokedWithResult: (bool didPop, _) async {
                if (didPop) {
                  return;
                }
                final bool? shouldExit = await Get.dialog<bool>(
                  const ExitConfirmationDialog(),
                );
                if (shouldExit == true) {
                  Get.until(
                    (_) => Get.currentRoute == Routes.NAVIGATION_SCREEN,
                  );
                } else {
                  await controller.saveLessonPlan();
                  Get.until(
                    (_) => Get.currentRoute == Routes.NAVIGATION_SCREEN,
                  );
                }
              },
              child: Scaffold(
                backgroundColor: AppColors.kF6F8FA,
                key: scaffoldKey,

                /// Top AppBar with chatbot and export options
                appBar: CommonAppBar(
                  scaffoldKey: scaffoldKey,
                  title: LocaleKeys.lessonPlan.tr,

                  /// Chatbot
                  trailingWidget:
                      /// Chatbot Button
                      IconButton(
                        onPressed: () {
                          Get.toNamed(
                            Routes.LESSON_CHATBOT,
                            arguments: <String, String?>{
                              /// ID of the current lesson being viewed
                              'lessonId': controller.lessonPlan.value?.data.id,

                              /// ID of the chapter to give context to the chatbot
                              'chapterId': controller
                                  .lessonPlan
                                  .value
                                  ?.data
                                  .lesson
                                  .chapter
                                  .id,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.k46A0F1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.icChatbotWhite,
                          width: 20,
                          height: 20,
                        ),
                      ),
                ),

                /// Main body content is now a stateful widget to manage tab state
                /// and build the CustomScrollView.
                body: const LessonPlanGeneratedBody(),
                floatingActionButton: Obx(
                  () => Visibility(
                    visible: controller.mainTabIndex == 0,
                    child: FloatingActionButton.extended(
                      onPressed: controller.toggleFeedbackSection,
                      icon: Icon(
                        controller.showFeedbackSection.value
                            ? Icons.feedback_outlined
                            : Icons.feedback,
                        color: Colors.white,
                      ),
                      label: Text(
                        controller.showFeedbackSection.value
                            ? 'Hide Feedback'
                            : 'Show Feedback',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: controller.showFeedbackSection.value
                          ? Colors.green
                          : AppColors.k46A0F1,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

/// This widget contains the main `CustomScrollView` and manages the state
/// for both the main tabs and the nested lesson section tabs.
class LessonPlanGeneratedBody extends StatefulWidget {
  const LessonPlanGeneratedBody({super.key});

  @override
  _LessonPlanGeneratedBodyState createState() =>
      _LessonPlanGeneratedBodyState();
}

class _CoachBubble extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const _CoachBubble({
    required this.title,
    required this.description,
    required this.onNext,
    this.onSkip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.k000000,
          ),
        ),
        8.verticalSpace,
        Text(
          description,
          style: AppTextStyle.lato(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k000000,
          ),
        ),
        12.verticalSpace,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onNext,
            child: Text(
              LocaleKeys.next.tr,
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.k46A0F1,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _LessonPlanGeneratedBodyState extends State<LessonPlanGeneratedBody>
    with TickerProviderStateMixin {
  /// The controller for the nested tabs within the "Lesson Plan" tab.
  TabController? _lessonSectionTabController;

  /// GetX controller for lesson plan data and actions.
  final LessonPlanGeneratedViewController controller = Get.find();

  final GetStorage storage = GetStorage(); // Initialize GetStorage
  final String tutorialShownKey =
      'lesson_plan_view_shown'; // Key for tutorial flag

  /// Labels for the main tabs.
  List<String> get mainTabs {
    final baseTabs = <String>[
      LocaleKeys.lessonPlan.tr,
      LocaleKeys.lessonSummary.tr,
      LocaleKeys.videos.tr,
      LocaleKeys.documents.tr,
    ];

    // 👈 Remove specific tabs by condition
    return baseTabs.where((tab) {
      if (tab == LocaleKeys.lessonSummary.tr && !controller.hasChecklist)
        return false;

      return true; // Keep lessonPlan always
    }).toList();
  }

  final List<GlobalKey> mainTabKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  TutorialCoachMark? tutorialCoachMark;

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.8),
      textSkip: LocaleKeys.skip.tr,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        storage.write(tutorialShownKey, true); // Mark tutorial as shown
      },

      onSkip: () {
        storage.write(tutorialShownKey, true); // Mark tutorial as shown
        return true;
      },
      // finish: () => print("Tutorial finished"),
      // clickTarget: (target) => print("Clicked: ${target.identify}"),
      // clickSkip: () => print("Tutorial skipped"),
    )..show(context: this.context);
  }

  List<TargetFocus> _createTargets() {
    // 4 separate descriptions for each tab
    final List<String> descriptions = [
      "This is the Lesson Plan tab. Here you can view and edit the detailed lesson sections.",
      "This is the Lesson Summary tab. It shows a concise overview of the lesson plan, including key points and checklist items.",
      "This is the Videos tab. You can watch all lesson-related videos from here.",
      "This is the Documents tab. Download or share lesson plan documents and 5E tables.",
    ];

    return List.generate(mainTabKeys.length, (index) {
      return TargetFocus(
        identify: "MainTab$index",
        keyTarget: mainTabKeys[index],
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _CoachBubble(
              title: mainTabs[index],
              description: descriptions[index],
              onNext: controller.next,
              onSkip: null,
            ),
          ),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    // Add a listener to the TabController to rebuild when the tab changes.
    // This is necessary because we are not using a TabBarView.
    _addLessonSectionTabListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  void _checkAndShowTutorial() {
    if (storage.read(tutorialShownKey) == true) return;

    // 👈 NEW: Wait for API data AND keys ready
    if (!controller.hasApiLoaded || mainTabKeys.isEmpty) {
      // Retry after delay if not ready
      Future.delayed(const Duration(milliseconds: 300), _checkAndShowTutorial);
      return;
    }

    bool allKeysReady = mainTabKeys.every((key) => key.currentContext != null);
    if (allKeysReady) {
      showTutorial();
    } else {
      // Retry once more
      Future.delayed(const Duration(milliseconds: 1000), _checkAndShowTutorial);
    }
  }

  @override
  void dispose() {
    _lessonSectionTabController?.removeListener(_onLessonSectionTabChanged);
    _lessonSectionTabController?.dispose();
    super.dispose();
  }

  void _addLessonSectionTabListener() {
    if (_lessonSectionTabController != null) {
      _lessonSectionTabController!.addListener(_onLessonSectionTabChanged);
    }
  }

  void _onLessonSectionTabChanged() {
    if (_lessonSectionTabController != null &&
        _lessonSectionTabController!.indexIsChanging) {
      setState(() {
        // This rebuilds the UI to show the content of the new sub-tab.
      });
    }
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    try {
      // Logic from LessonPlanSectionTabs to get sections
      final FromPage fromPage =
          Get.arguments?['from_page'] as FromPage? ?? FromPage.view;
      LessonPlanGenerationDetailsController? generationDetailsController;
      if (fromPage == FromPage.generate) {
        generationDetailsController =
            Get.find<LessonPlanGenerationDetailsController>();
      }

      List<DatumSection> sections = <DatumSection>[];
      if (fromPage == FromPage.view) {
        sections =
            controller.lessonPlan.value?.data.sections ?? <DatumSection>[];
      } else if (fromPage == FromPage.generate &&
          generationDetailsController != null) {
        sections =
            generationDetailsController
                .generatedLessonResponse
                .value
                ?.data
                .first
                .sections ??
            <DatumSection>[];
      }

      final List<DatumSection> plainTextSections = sections
          .where((DatumSection s) => s.outputFormat == 'plain_text')
          .toList();

      // Sync main tab keys for dynamic tabs/tutorial
      //   _updateMainTabKeys();

      // Initialize or update TabController for lesson sections
      if (_lessonSectionTabController?.length != plainTextSections.length) {
        _lessonSectionTabController?.removeListener(_onLessonSectionTabChanged);
        _lessonSectionTabController?.dispose();
        if (plainTextSections.isNotEmpty) {
          _lessonSectionTabController = TabController(
            length: plainTextSections.length,
            vsync: this,
          );
          _addLessonSectionTabListener();
        } else {
          _lessonSectionTabController = null;
        }
      }

      // Initialize edit flags for each section
      if (controller.isSectionEdit.length != plainTextSections.length) {
        controller.isSectionEdit.value = List<bool>.filled(
          plainTextSections.length,
          false,
        );
      }

      return CustomScrollView(
        controller: controller.scrollController,
        slivers: <Widget>[
          /// Sliver 1: Chapter Details
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: ChapterDetailsTooltipSection()),
          ),

          /// Sliver 2: Main tab bar (dynamic)
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverMainTabBarDelegate(tabBar: _buildMainTabBar()),
          ),

          /// Sliver 3: Dynamic content based on mainTabIndex + hasChecklist
          if (controller.mainTabIndex == 0)
            ..._buildLessonPlanSlivers(
              plainTextSections,
              fromPage,
              generationDetailsController,
            ),

          // Dynamic mapping for tabs 1-3
          if (controller.mainTabIndex == 1)
            controller.hasChecklist
                ? _buildLessonSummarySlivers(
                    fromPage,
                    generationDetailsController,
                  )
                : _buildVideosSlivers(
                    fromPage,
                    generationDetailsController,
                    context,
                  ),

          if (controller.mainTabIndex == 2)
            controller.hasChecklist
                ? _buildVideosSlivers(
                    fromPage,
                    generationDetailsController,
                    context,
                  )
                : _buildDocumentsSlivers(fromPage, context),

          if (controller.mainTabIndex == (controller.hasChecklist ? 3 : 2))
            _buildDocumentsSlivers(fromPage, context),

          // Fallback empty state
          if (controller.mainTabIndex >= (controller.hasChecklist ? 4 : 3))
            SliverFillRemaining(
              child: Center(child: Text('Tab not available')),
            ),
        ],
      );
    } catch (e, stackTrace) {
      debugPrint('Build error: $e');
      debugPrint('Stack: $stackTrace');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              Text('Error: $e'),
              ElevatedButton(
                onPressed: () => controller.refresh?.call(),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
  });

  /// Builds the custom main tab bar widget.
  Widget _buildMainTabBar() => Container(
    color: AppColors.kF6F8FA,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      children: List.generate(mainTabs.length, (int index) {
        final bool selected = controller.mainTabIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              controller.setMainTabIndex(index);
            },
            child: Container(
              key: mainTabKeys[index], // <-- Add this
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: 40,
              decoration: BoxDecoration(
                color: selected ? AppColors.k46A0F1 : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  mainTabs[index],
                  style: TextStyle(
                    color: selected ? AppColors.kFFFFFF : AppColors.k6C7278,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );

  /// Builds the slivers for the "Lesson Plan" tab.
  List<Widget> _buildLessonPlanSlivers(
    List<DatumSection> plainTextSections,
    FromPage fromPage,
    LessonPlanGenerationDetailsController? generationDetailsController,
  ) {
    if (_lessonSectionTabController == null || plainTextSections.isEmpty) {
      return <Widget>[
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                24.verticalSpace,
                _learningOutcomeSection(fromPage, generationDetailsController),
                24.verticalSpace,
                const LessonPlanFeedbackSection(),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ];
    }

    return <Widget>[
      /// Sliver 1: Learning Outcomes section.
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              24.verticalSpace,
              _learningOutcomeSection(fromPage, generationDetailsController),
              24.verticalSpace,
            ],
          ),
        ),
      ),

      /// Sliver 2: The nested lesson section TabBar (e.g., Engage, Explore).
      /// This is also a persistent header that sticks below the main tab bar.
      SliverPersistentHeader(
        pinned: true,
        delegate: _SliverLessonSectionTabBarDelegate(
          TabBar(
            isScrollable: true,
            controller: _lessonSectionTabController,
            labelColor: AppColors.k46A0F1,
            labelStyle: AppTextStyle.lato(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
            dividerColor: AppColors.kEBEBEB,
            unselectedLabelColor: AppColors.k666970,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.k46A0F1, width: 2),
              ),
            ),
            indicatorColor: AppColors.k46A0F1,
            tabAlignment: TabAlignment.center,
            tabs: plainTextSections
                .map((DatumSection s) => Tab(text: s.title))
                .toList(),
          ),
        ),
      ),

      /// Sliver 3: Content of the selected lesson section.
      /// This is wrapped in a SliverToBoxAdapter to place it within the CustomScrollView.
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(
          child: _buildLessonSectionContent(
            fromPage,
            plainTextSections[_lessonSectionTabController!.index],
            _lessonSectionTabController!.index,
          ),
        ),
      ),

      /// Sliver 4: The feedback section at the bottom.
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              24.verticalSpace,
              const LessonPlanFeedbackSection(),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    ];
  }

  /// Builds the content widget for a single lesson section tab.
  Widget _buildLessonSectionContent(
    FromPage fromPage,
    DatumSection section,
    int index,
  ) {
    final bool isGenerated = fromPage == FromPage.generate;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kFFFFFF,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _sectionHeader(
            section.title,
            onEditTap: () {
              controller.isSectionEdit[index] =
                  !controller.isSectionEdit[index];
            },
          ),
          16.verticalSpace,
          Obx(
            () => controller.isSectionEdit[index]
                ? _TabContentEditable(
                    initialContent: section.content ?? '',
                    onChanged: (String val) => section.content = val,
                  )
                : MarkdownBody(
                    data: renderMath(section.content) ?? '',

                    styleSheet: MarkdownStyleSheet(
                      p: AppTextStyle.lato(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.k141522,
                      ),
                      strong: AppTextStyle.lato(fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          if (!isGenerated)
            if (section.media != null && (section.media?.isNotEmpty ?? false))
              ...section.media!.map<Widget>(
                (Media m) => MediaCard(
                  media: m,
                  onDelete: () async {
                    await controller.deleteMedia(
                      sectionId: section.id,
                      mediaId: m.id,
                    );
                  },
                ),
              ),
          24.verticalSpace,
          if (!isGenerated)
            _addMediaUrlButton(
              onPressed: () {
                final String? sectionId = section.id;
                if (sectionId != null) {
                  Get.bottomSheet(
                    AddMediaUrlBottomSheet(sectionId: sectionId),
                    isScrollControlled: true,
                    ignoreSafeArea: false,
                  );
                }
              },
            ),
          24.verticalSpace,
        ],
      ),
    );
  }

  String renderMath(String content) {
    // Remove LaTeX delimiters
    content = content.replaceAll(RegExp(r'\$+'), '');

    content = content.replaceAllMapped(
      RegExp(r'\\text\{([^}]+)\}'),
      (match) => match.group(1)!, // Extract inside {}
    );

    // Common math symbols → Unicode
    content = content
        .replaceAllMapped(RegExp(r'\\?pi\b', caseSensitive: false), (_) => 'π')
        .replaceAllMapped(
          RegExp(r'\\?theta\b', caseSensitive: false),
          (_) => 'θ',
        )
        .replaceAllMapped(RegExp(r'\^2\s*', caseSensitive: false), (_) => '²')
        .replaceAllMapped(RegExp(r'\^3\s*', caseSensitive: false), (_) => '³')
        .replaceAll('\\times', '×')
        .replaceAll('\\div', '÷')
        .replaceAll('×', '×')
        .replaceAll('÷', '÷')
        .replaceAll('\implies', '=>')
        .replaceAll('^{\\circ}', '∘');

    content = content.replaceAllMapped(
      RegExp(r'\\frac\{([^}]+)\}\{([^}]+)\}'),
      (match) => '${match.group(1)}/${match.group(2)}',
    );

    // Fix your specific cases from screenshot
    content = content
        .replaceAllMapped(RegExp(r'R\^2'), (_) => 'R²') // R^2
        .replaceAllMapped(RegExp(r'r\^2'), (_) => 'r²') // r^2
        .replaceAll('64×', '64×')
        .replaceAll('100-', '100−'); // Proper minus

    return content.trim();
  }

  /// Builds the slivers for the "Lesson Summary" tab.
  Widget _buildLessonSummarySlivers(
    FromPage fromPage,
    LessonPlanGenerationDetailsController? generationDetailsController,
  ) => SliverPadding(
    padding: const EdgeInsets.all(16),
    sliver: SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            LocaleKeys.lessonSummary.tr,
            style: AppTextStyle.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.k46A0F1,
            ),
          ),
          16.verticalSpace,
          Obx(() {
            Map<String, dynamic>? checklist;
            if (fromPage == FromPage.view) {
              final DatumSection? section = controller
                  .lessonPlan
                  .value
                  ?.data
                  .sections
                  .firstWhereOrNull(
                    (DatumSection s) => s.id == 'section_checklist',
                  );
              checklist = section?.content as Map<String, dynamic>?;
            } else if (fromPage == FromPage.generate) {
              final Datum? generatedData = generationDetailsController
                  ?.generatedLessonResponse
                  .value
                  ?.data
                  .first;
              final List<DatumSection>? sections = generatedData?.sections;
              if (sections != null) {
                final DatumSection? checklistSection = sections
                    .firstWhereOrNull(
                      (DatumSection s) => s.id == 'section_checklist',
                    );
                checklist = checklistSection?.content as Map<String, dynamic>?;
              }
            }

            if (checklist == null) {
              return const SizedBox.shrink();
            }
            return _buildChecklistTable(checklist);
          }),
        ],
      ),
    ),
  );

  /// Builds the slivers for the "Videos" tab.
  Widget _buildVideosSlivers(
    FromPage fromPage,
    LessonPlanGenerationDetailsController? generationDetailsController,
    BuildContext context,
  ) {
    List<dynamic> videoList = <dynamic>[];

    if (fromPage == FromPage.view) {
      videoList =
          controller.lessonPlan.value?.data.lesson.videos ?? <dynamic>[];
    } else if (fromPage == FromPage.generate &&
        generationDetailsController != null) {
      videoList =
          generationDetailsController
              .generatedLessonResponse
              .value
              ?.data
              .first
              .videos ??
          <dynamic>[];
    }

    if (videoList.isEmpty) {
      return SliverFillRemaining(
        child: noVideosSection(context),
        hasScrollBody: false,
      );
    }

    // The content was previously in VideosTabView. It's now a SliverList.
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final video = videoList[index];
          return Padding(
            padding: const EdgeInsets.only(top: 24),
            child: VideoCard(
              video: video,
              onPlay: () async {
                final Uri uri = Uri.parse(video.url as String);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open video link')),
                  );
                }
              },
            ),
          );
        }, childCount: videoList.length),
      ),
    );
  }

  /// Builds the slivers for the "Documents" tab.
  Widget _buildDocumentsSlivers(FromPage fromPage, BuildContext context) {
    final bool isGenerated = fromPage == FromPage.generate;

    return Obx(() {
      final bool show5E = controller.show5ETableFeature;

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            12.verticalSpace,
            // Lesson Plan DOCX - Always visible
            DocumentCard(
              title: 'Lesson Plan Docx',
              fileType: 'DOCX file',
              icon: AppImages.icDocs,
              disabled: isGenerated,
              onDownload: isGenerated
                  ? () {}
                  : () => showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      builder: (context) => SaveShareOptionsBottomSheet(
                        fileName: 'Lesson_Plan_Docx',
                        onSaveToDevice: () => controller.generateLessonPlanDocx(
                          saveToDevice: true,
                        ),
                        onShare: () => controller.generateLessonPlanDocx(
                          saveToDevice: false,
                        ),
                      ),
                    ),
            ),
            12.verticalSpace,

            // 5E Table DOCX - Conditional
            if (show5E)
              DocumentCard(
                title: '5E Table Docs',
                fileType: 'DOCX file',
                icon: AppImages.icDocs,
                disabled: isGenerated,
                onDownload: isGenerated
                    ? null
                    : () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (context) => SaveShareOptionsBottomSheet(
                          fileName: '5E_Table_Docs',
                          onSaveToDevice: () => controller.generate5ETableDocx(
                            saveToDevice: true,
                          ),
                          onShare: () => controller.generate5ETableDocx(
                            saveToDevice: false,
                          ),
                        ),
                      ),
              ),
            if (show5E) 12.verticalSpace,

            // 5E Table PDF - Conditional
            if (show5E)
              DocumentCard(
                title: '5E Table PDF',
                fileType: 'PDF file',
                icon: AppImages.icPdf,
                disabled: isGenerated,
                onDownload: isGenerated
                    ? null
                    : () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (context) => SaveShareOptionsBottomSheet(
                          fileName: '5E_Table_Pdf',
                          onSaveToDevice: () =>
                              controller.generate5ETablePdf(saveToDevice: true),
                          onShare: () => controller.generate5ETablePdf(
                            saveToDevice: false,
                          ),
                        ),
                      ),
              ),
          ]),
        ),
      );
    });
  }

  Widget _learningOutcomeSection(
    FromPage fromPage,
    LessonPlanGenerationDetailsController? generationDetailsController,
  ) => Container(
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: controller.toggleLearningOutcomeExpanded,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.kFFFFFF,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LocaleKeys.learningOutcomes.tr,
                  style: AppTextStyle.lato(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k171A1F,
                  ),
                ),
                Obx(
                  () => AnimatedRotation(
                    turns: controller.isLearningOutcomeExpanded.value
                        ? 0.5
                        : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.k171A1F,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          curve: Curves.easeIn,
          reverseDuration: const Duration(milliseconds: 200),
          child: Obx(
            () => controller.isLearningOutcomeExpanded.value
                ? Column(
                    children: <Widget>[
                      const Divider(
                        height: 1,
                        thickness: 1.2,
                        color: AppColors.kEBEBEB,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                        child: _buildOutcomesContent(
                          fromPage,
                          generationDetailsController,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );

  Widget _buildOutcomesContent(
    FromPage fromPage,
    LessonPlanGenerationDetailsController? generationDetailsController,
  ) {
    List<String> outcomes = <String>[];
    if (fromPage == FromPage.view) {
      outcomes = controller.learningOutcomes;
    } else if (fromPage == FromPage.generate) {
      outcomes =
          generationDetailsController
              ?.generatedLessonResponse
              .value
              ?.data
              .first
              .learningOutcomes ??
          <String>[];
    }
    if (outcomes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: outcomes
          .map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '• ',
                    style: TextStyle(fontSize: 16.sp, color: AppColors.k141522),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyle.lato(
                        fontSize: 16.sp,
                        color: AppColors.k141522,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildChecklistTable(Map<String, dynamic> checklist) {
    final List<String> phaseKeys = checklist.keys.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FixedColumnWidth(280),
          2: FixedColumnWidth(180),
          3: FixedColumnWidth(150),
        },
        border: TableBorder.all(color: AppColors.kDEE1E6),
        children: <TableRow>[
          TableRow(
            decoration: BoxDecoration(
              color: AppColors.kDEE1E6.withOpacity(0.2),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.phase.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.classroomProcess.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.tlm.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  LocaleKeys.cceToolsAndTechniques.tr,
                  style: AppTextStyle.lato(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          ...phaseKeys.where((String k) => checklist[k] != null).map((
            String phase,
          ) {
            final Map<String, dynamic> entry =
                checklist[phase] as Map<String, dynamic>;
            return TableRow(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(phase.toUpperCase()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(entry['activity'] ?? ''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(entry['materials'] ?? ''),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Observation.'),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onEditTap}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
        // ✅ Prevents overflow, allows multiline
        child: Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.k46A0F1,
          ),
          maxLines: 6, // ✅ Optional: limit to 2 lines
          overflow: TextOverflow.ellipsis, // ✅ Ellipsis if still too long
          textAlign: TextAlign.start,
        ),
      ),
      GestureDetector(
        onTap: onEditTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.kFFFFFF,
            border: Border.all(color: AppColors.kEBEBEB, width: 1.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // ✅ Keeps edit button compact
            children: <Widget>[
              Text(
                LocaleKeys.edit.tr,
                style: AppTextStyle.lato(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.k46A0F1,
                ),
              ),
              4.horizontalSpace,
              SvgPicture.asset(AppImages.icEditBlue, width: 12, height: 12),
            ],
          ),
        ),
      ),
    ],
  );
  Widget _addMediaUrlButton({required VoidCallback onPressed}) =>
      OutlinedButton.icon(
        icon: const Icon(Icons.link, color: AppColors.k46A0F1),
        label: Text(
          LocaleKeys.addImageVideoUrl.tr,
          style: AppTextStyle.lato(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.k46A0F1,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.k46A0F1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
          backgroundColor: AppColors.kFFFFFF,
        ),
        onPressed: onPressed,
      );
}

/// A delegate for creating a sticky main tab bar.
class _SliverMainTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverMainTabBarDelegate({required this.tabBar});
  final Widget tabBar;

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(color: AppColors.kF6F8FA, child: tabBar);

  @override
  bool shouldRebuild(_SliverMainTabBarDelegate oldDelegate) =>
      tabBar != oldDelegate.tabBar;
}

/// A delegate for creating a sticky lesson section tab bar.
class _SliverLessonSectionTabBarDelegate
    extends SliverPersistentHeaderDelegate {
  _SliverLessonSectionTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Center(
    child: Container(
      color: AppColors.kF6F8FA,
      child: _tabBar,
    ).paddingSymmetric(horizontal: 8),
  );

  @override
  bool shouldRebuild(_SliverLessonSectionTabBarDelegate oldDelegate) => false;
}

/// An editable text field for tab content.
class _TabContentEditable extends StatelessWidget {
  final String initialContent;
  final ValueChanged<String>? onChanged;

  const _TabContentEditable({required this.initialContent, this.onChanged});

  @override
  Widget build(BuildContext context) => TextFormField(
    initialValue: initialContent,
    maxLines: null,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
      hintText: 'Edit content here',
    ),
    onChanged: onChanged,
  );
}

Future<void> showDownloadOptionsBottomSheet({
  required BuildContext context,
  required VoidCallback onSaveToDevice,
  required VoidCallback onShare,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'What would you like to do?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.download_rounded, color: Colors.blue),
            title: const Text('Save to Device'),
            onTap: () {
              Navigator.pop(context); // Close bottom sheet
              onSaveToDevice();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_rounded, color: Colors.blue),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context); // Close bottom sheet
              onShare();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

/// Displays a placeholder UI when no videos are found.
Widget noVideosSection(BuildContext context) => Container(
  width: double.infinity,
  height: MediaQuery.of(context).size.height * 0.25,
  decoration: BoxDecoration(
    color: AppColors.kFFFFFF,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.kEBEBEB, width: 1.3),
  ),
  padding: const EdgeInsets.all(20),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: 88,
        height: 88,
        decoration: const BoxDecoration(
          color: AppColors.kEDF6FE,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            AppImages.videoNotFound,
            width: 40,
            height: 40,
          ),
        ),
      ),
      20.verticalSpace,
      Text(
        LocaleKeys.videosNotFound.tr,
        style: AppTextStyle.lato(
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.k5F6165,
        ),
      ),
    ],
  ),
);

// Reusable bottom sheet widget for Save/Share options
class SaveShareOptionsBottomSheet extends StatelessWidget {
  final String fileName;
  final VoidCallback onSaveToDevice;
  final VoidCallback onShare;

  const SaveShareOptionsBottomSheet({
    required this.fileName,
    required this.onSaveToDevice,
    required this.onShare,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'What would you like to do?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.download_rounded, color: Colors.blue),
          title: const Text('Save to Device'),
          onTap: () {
            Navigator.pop(context); // Close sheet
            onSaveToDevice();
          },
        ),
        ListTile(
          leading: const Icon(Icons.share_rounded, color: Colors.blue),
          title: const Text('Share'),
          onTap: () {
            Navigator.pop(context); // Close sheet
            onShare();
          },
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

/// A reusable card widget that displays a single lesson video.
class VideoCard extends StatelessWidget {
  const VideoCard({required this.video, required this.onPlay, super.key});

  final dynamic video;
  final VoidCallback onPlay;

  String getYoutubeThumbnail(String url) {
    final RegExp regExp = RegExp(r'(?<=v=)[^&]+');
    final RegExpMatch? match = regExp.firstMatch(url);

    if (match != null) {
      return 'https://img.youtube.com/vi/${match.group(0)}/0.jpg';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    decoration: BoxDecoration(
      color: AppColors.kF3F4F6,
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: const Color(0xFFE0E0E0)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  getYoutubeThumbnail(video.url as String),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  errorBuilder:
                      (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Container(
                        color: Colors.black12,
                        child: const Icon(Icons.video_library, size: 80),
                      ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(60),
                onTap: onPlay,
                child: Image.asset(AppImages.youtube),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            video.title as String,
            textAlign: TextAlign.center,
            style: AppTextStyle.lato(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.k171A1F,
            ),
          ),
        ),
      ],
    ),
  );
}
