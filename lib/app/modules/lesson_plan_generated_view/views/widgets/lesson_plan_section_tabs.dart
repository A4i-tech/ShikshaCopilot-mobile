import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/add_media_url_bottom_sheet.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/media_card.dart';
import 'package:sikshana/app/modules/lesson_plan_generation_details/models/generate_lesson_response_model.dart';
import 'package:sikshana/app/utils/exports.dart';

class LessonPlanSectionTabs extends GetView<LessonPlanGeneratedViewController> {
  const LessonPlanSectionTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;

    LessonPlanGenerationDetailsController? generationDetailsController;
    if (fromPage == FromPage.generate) {
      generationDetailsController =
          Get.find<LessonPlanGenerationDetailsController>();
    }

    return Obx(() {
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

      if (plainTextSections.isEmpty) {
        return const SizedBox.shrink();
      }

      if (controller.isSectionEdit.length != plainTextSections.length) {
        controller.isSectionEdit.value = List<bool>.filled(
          plainTextSections.length,
          false,
        );
      }

      return _LessonPlanDynamicTabsWidget(
        sections: plainTextSections,
        controller: controller,
      );
    });
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

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
  ) {
    return Container(color: AppColors.kFFFFFF, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}

class _LessonPlanDynamicTabsWidget extends StatefulWidget {
  final List<DatumSection> sections;
  final LessonPlanGeneratedViewController controller;

  const _LessonPlanDynamicTabsWidget({
    Key? key,
    required this.sections,
    required this.controller,
  }) : super(key: key);

  @override
  __LessonPlanDynamicTabsWidgetState createState() =>
      __LessonPlanDynamicTabsWidgetState();
}

class __LessonPlanDynamicTabsWidgetState
    extends State<_LessonPlanDynamicTabsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.sections.length, vsync: this);
  }

  @override
  void didUpdateWidget(covariant _LessonPlanDynamicTabsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.sections.length != oldWidget.sections.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.sections.length,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height * 0.7;

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: SizedBox(
        height: availableHeight,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            logD('innerBoxIsScrolled inner $innerBoxIsScrolled ');
            return <Widget>[
              SliverPersistentHeader(
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.k46A0F1,
                    unselectedLabelColor: AppColors.k6C7278,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: AppColors.k46A0F1,
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: AppColors.kD9D9D970,
                    labelStyle: AppTextStyle.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: AppTextStyle.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dragStartBehavior: DragStartBehavior.start,
                    tabs: widget.sections
                        .map<Widget>(
                          (DatumSection s) => Tab(text: s.title ?? ''),
                        )
                        .toList(),
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            physics: const ClampingScrollPhysics(),
            children: widget.sections.asMap().entries.map((
              MapEntry<int, DatumSection> entry,
            ) {
              final int i = entry.key;
              final DatumSection section = entry.value;

              return Scrollbar(
                thickness: 8,
                thumbVisibility: true,

                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.kFFFFFF,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(top: 24, bottom: 24),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        sectionHeader(
                          section.title ?? '',
                          onEditTap: () {
                            widget.controller.isSectionEdit[i] =
                                !widget.controller.isSectionEdit[i];
                          },
                        ),
                        16.verticalSpace,
                        Obx(
                          () => widget.controller.isSectionEdit[i]
                              ? TabContentEditable(
                                  initialContent: section.content ?? '',
                                  onChanged: (String val) =>
                                      section.content = val,
                                )
                              : MarkdownBody(
                                  data: section.content ?? '',
                                  styleSheet: MarkdownStyleSheet(
                                    p: AppTextStyle.lato(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.k141522,
                                    ),
                                    strong: AppTextStyle.lato(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        if (section.media != null &&
                            (section.media?.isNotEmpty ?? false))
                          ...section.media!.map<Widget>(
                            (Media m) => MediaCard(
                              media: m,
                              onDelete: () async {
                                await widget.controller.deleteMedia(
                                  sectionId: section.id,
                                  mediaId: m.id,
                                );
                              },
                            ),
                          ),
                        24.verticalSpace,
                        addMediaUrlButton(
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
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

Widget addMediaUrlButton({required VoidCallback onPressed}) =>
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

Widget sectionHeader(String title, {VoidCallback? onEditTap}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: <Widget>[
    Text(
      title,
      style: AppTextStyle.lato(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.k46A0F1,
      ),
    ),
    GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.kFFFFFF,
          border: Border.all(color: AppColors.kEBEBEB, width: 1.3),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
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

class TabContentEditable extends StatelessWidget {
  final String initialContent;
  final ValueChanged<String>? onChanged;

  const TabContentEditable({
    Key? key,
    required this.initialContent,
    this.onChanged,
  }) : super(key: key);

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
