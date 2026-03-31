import 'package:get_storage/get_storage.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/lesson_resource_feedback_section.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/lesson_resource_section_tabs.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/tabviews/document_resource_tab_view.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/tabviews/video_resource_tab_view.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/chapter_resource_details_tooltip_section.dart';
import 'package:sikshana/app/ui/components/exit_confirmation_dialog.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// The main view for displaying a generated lesson resource.
class LessonResourceGeneratedViewView extends StatefulWidget {
  const LessonResourceGeneratedViewView({super.key});

  @override
  State<LessonResourceGeneratedViewView> createState() =>
      _LessonResourceGeneratedViewViewState();
}

class _LessonResourceGeneratedViewViewState
    extends State<LessonResourceGeneratedViewView>
    with TickerProviderStateMixin {
  final LessonResourceGeneratedViewController controller =
      Get.find<LessonResourceGeneratedViewController>();

  int _selectedIndex = 0;
  TabController? _innerTabController;

  final List<String> tabs = <String>['Lesson Resource', 'Videos', 'Documents'];

  final GlobalKey lessonResourceTabKey = GlobalKey();
  final GlobalKey videosTabKey = GlobalKey();
  final GlobalKey documentsTabKey = GlobalKey();

  final GetStorage storage = GetStorage();
  final String tutorialShownKey = 'lesson_resource_view_shown';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (storage.read(tutorialShownKey) != true) {
        // Show tutorial only if it hasn't been shown before
        _showTutorial();
      }
    });
  }

  @override
  void dispose() {
    _innerTabController?.dispose();
    super.dispose();
  }

  /// Bubble widget for tutorial steps
  Widget _buildBubble(
    String title,
    String description,
    VoidCallback onNext, {
    VoidCallback? onSkip,
  }) => _LessonSectionBubble(
    title: title,
    description: description,
    onNext: onNext,
    onSkip: null,
  );

  List<TargetFocus> _createTargets() => [
    TargetFocus(
      identify: "LessonResourceTab",
      keyTarget: lessonResourceTabKey,
      shape: ShapeLightFocus.RRect,
      radius: 8,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, tutorialController) => _buildBubble(
            LocaleKeys.lessonResources.tr,
            LocaleKeys.lessonResourcesDescription.tr, // ✅ Localized
            tutorialController.next,
            onSkip: null,
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "VideosTab",
      keyTarget: videosTabKey,
      shape: ShapeLightFocus.RRect,
      radius: 8,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, tutorialController) => _buildBubble(
            LocaleKeys.videos.tr,
            LocaleKeys.videosDescription.tr, // ✅ Localized
            tutorialController.next,
            onSkip: null,
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "DocumentsTab",
      keyTarget: documentsTabKey,
      shape: ShapeLightFocus.RRect,
      radius: 8,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, tutorialController) => _buildBubble(
            LocaleKeys.documents.tr,
            LocaleKeys.documentsDescription.tr, // ✅ Localized
            tutorialController.next, // Fixed: was skip
            onSkip: null,
          ),
        ),
      ],
    ),
  ];

  void _showTutorial() {
    TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.8),
      textSkip: LocaleKeys.skip.tr,
      paddingFocus: 10,
      onFinish: () {
        storage.write(tutorialShownKey, true);
      },
      onSkip: () {
        storage.write(tutorialShownKey, true);
        return true;
      },
    ).show(context: this.context);
  }

  @override
  Widget build(BuildContext context) {
    final connectivityController = Get.find<NoInternetScreenController>();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : PopScope(
              canPop: controller.canPop.value,
              onPopInvokedWithResult: (didPop, _) async {
                if (didPop) return;

                final shouldExit = await Get.dialog<bool>(
                  const ExitConfirmationDialog(),
                );

                if (shouldExit == true) {
                  Get.until(
                    (_) => Get.currentRoute == Routes.NAVIGATION_SCREEN,
                  );
                } else {
                  await controller.saveResourcePlan();
                  Get.until(
                    (_) => Get.currentRoute == Routes.NAVIGATION_SCREEN,
                  );
                }
              },
              child: Scaffold(
                key: scaffoldKey,
                appBar: CommonAppBar(
                  scaffoldKey: scaffoldKey,
                  title: LocaleKeys.lessonResources.tr,
                ),
                floatingActionButton: _selectedIndex == 0
                    ? Obx(
                        () => FloatingActionButton.extended(
                          onPressed: controller.toggleResourceFeedbackSection,
                          heroTag: 'resource_feedback_fab',
                          elevation: 6,
                          icon: Icon(
                            controller.showResourceFeedbackSection.value
                                ? Icons.close
                                : Icons.rate_review_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          label: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              controller.showResourceFeedbackSection.value
                                  ? 'Hide Feedback'
                                  : 'Feedback',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          backgroundColor:
                              controller.showResourceFeedbackSection.value
                              ? Colors.green.shade600
                              : AppColors.k46A0F1,
                        ),
                      )
                    : null,
                body: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: ChapterResourceDetailsTooltipSection(),
                    ),
                    _buildTabsHeader(context),
                    ..._buildContentSlivers(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTabsHeader(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: SliverHeaderDelegate(
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final selected = _selectedIndex == index;
            final key = index == 0
                ? lessonResourceTabKey
                : index == 1
                ? videosTabKey
                : documentsTabKey;

            return Expanded(
              child: GestureDetector(
                key: key,
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.k46A0F1 : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
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
      ),
    ),
  );

  List<Widget> _buildContentSlivers(BuildContext context) {
    final fromPage = Get.arguments?['from_page'] as FromPage? ?? FromPage.view;
    final generationController = fromPage == FromPage.generate
        ? Get.find<LessonResourceGenerationDetailsController>()
        : null;

    if (_selectedIndex == 0) {
      List<dynamic> sections = fromPage == FromPage.view
          ? controller.lessonResource.value?.data.resources ?? []
          : generationController
                    ?.generatedResourceResponse
                    .value
                    ?.data
                    .first
                    .resources ??
                [];

      // Init inner TabController
      if (_innerTabController == null ||
          _innerTabController!.length != sections.length) {
        _innerTabController?.dispose();
        _innerTabController =
            TabController(length: sections.length, vsync: this)
              ..addListener(() {
                if (!_innerTabController!.indexIsChanging) setState(() {});
              });
      }

      return [
        if (sections.isNotEmpty)
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate(
              height: 50,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: TabBar(
                    controller: _innerTabController,
                    labelColor: AppColors.k46A0F1,
                    unselectedLabelColor: AppColors.k666970,
                    labelStyle: AppTextStyle.lato(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    dividerColor: AppColors.kEBEBEB,
                    indicator: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.k46A0F1, width: 2),
                      ),
                    ),
                    tabs: sections
                        .map<Widget>((s) => Tab(text: s?.title ?? ''))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              if (sections.isNotEmpty)
                LessonResourceTabContent(
                  section: sections[_innerTabController!.index],
                  fromPage: fromPage,
                ),
              32.verticalSpace,
              const LessonResourceFeedbackSection().paddingSymmetric(
                horizontal: 24,
              ),
              32.verticalSpace,
            ],
          ),
        ),
      ];
    }

    if (_selectedIndex == 1)
      return [const SliverToBoxAdapter(child: VideoResourceTabView())];
    if (_selectedIndex == 2)
      return [const SliverToBoxAdapter(child: DocumentResourceTabView())];

    return [const SliverToBoxAdapter(child: SizedBox.shrink())];
  }
}

/// Custom bubble used in tutorial overlays
class _LessonSectionBubble extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  const _LessonSectionBubble({
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
