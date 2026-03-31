import 'package:sikshana/app/utils/exports.dart';

/// A widget that provides options for generating lessons and resources.
///
/// This widget displays an expandable/collapsible info card with buttons always visible.
/// Info card is collapsed by default.
class GenerateLessonSection extends GetView<ContentGenerationController> {
  /// Creates a new [GenerateLessonSection].
  const GenerateLessonSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // Expandable Info Card (collapsed by default)
      Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          scrollbarTheme: const ScrollbarThemeData(
            thumbColor: WidgetStatePropertyAll<Color>(AppColors.k46A0F1),
          ),
          expansionTileTheme: ExpansionTileThemeData(
            backgroundColor: AppColors.kFFFFFF,
            iconColor: AppColors.k000000,
            collapsedIconColor: AppColors.k000000,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: const BorderSide(color: AppColors.kEBEBEB),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: const BorderSide(color: AppColors.kEBEBEB),
            ),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                AppImages.lessonContentInfo,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Lesson Content Info',
                  style: AppTextStyle.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k344767,
                  ),
                ),
              ),
            ],
          ),
          children: const [GenerateInfoCard()],
        ),
      ),
      26.verticalSpace,
      // Buttons (always visible)
      GenerateLessonButtons(),
    ],
  );

  /// Builds the buttons for generating lessons and resources.
  Column GenerateLessonButtons() => Column(
    children: <Widget>[
      generateLessonResourceButton(),
      14.verticalSpace,
      generateLessonPlanButton(),
    ],
  );

  /// Builds the "Generate Lesson Plan" button.
  Widget generateLessonPlanButton() => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      icon: SvgPicture.asset(AppImages.editImageBlue, width: 20, height: 20),
      label: Text(LocaleKeys.generateLessonPlan.tr),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.k46A0F1,
        side: const BorderSide(color: AppColors.k46A0F1, width: 1.5),
        textStyle: AppTextStyle.lato(fontSize: 14, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: () {
        Get.toNamed(Routes.LESSON_PLAN_GENERATION_DETAILS)?.then((
          dynamic value,
        ) {
          // Get.bottomSheet(
          //   const ReviewActivityBottomSheet(),
          //   isScrollControlled: true,
          //   ignoreSafeArea: false,
          // );
        });
      },
    ),
  );

  /// Builds the "Generate Lesson Resource" button.
  Widget generateLessonResourceButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: SvgPicture.asset(AppImages.editImageWhite, width: 20, height: 20),
      label: Text(
        LocaleKeys.generateLessonResource.tr,
        style: AppTextStyle.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.kFFFFFF,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.k46A0F1,
        textStyle: AppTextStyle.lato(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      onPressed: () {
        Get.toNamed(Routes.LESSON_RESOURCE_GENERATION_DETAILS);
      },
    ),
  );
}

/// A widget that displays an informational card.
///
/// This widget shows an icon and a text with a light blue background.
class GenerateInfoCard extends StatelessWidget {
  /// Creates a new [GenerateInfoCard].
  const GenerateInfoCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    decoration: BoxDecoration(
      color: AppColors.kEDF6FE, // light blue
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SvgPicture.asset(AppImages.lessonContentInfo, width: 36, height: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            LocaleKeys.lessonContentInfoContent.tr,
            style: AppTextStyle.lato(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.k344767,
              height: 1.9,
            ),
          ),
        ),
      ],
    ),
  );
}
