import 'package:sikshana/app/modules/content_generation/views/widgets/review_activity_bottom_sheet.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/activity_editable.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/activity_non_editable.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/add_activity_media_url_bottom_sheet.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/views/widgets/media_card.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a section for activities.
///
/// This widget can be in either an editable or non-editable state.
class ActivitiesSection extends GetView<LessonResourceGeneratedViewController> {
  /// The section data.
  final dynamic section;
  final FromPage fromPage;

  /// Creates an [ActivitiesSection].
  const ActivitiesSection({
    Key? key,
    required this.section,
    required this.fromPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = section?.content as List<dynamic>? ?? [];

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kFFFFFF,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.kDEE1E6, width: 1.3),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 18),
        child: Obx(() {
          final isEditable = controller.isActivitiesEdit.value == true;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader(
                LocaleKeys.activities.tr,
                onEditTap: () =>
                    controller.isActivitiesEdit.value = !isEditable,
              ),
              16.verticalSpace,
              ...content.asMap().entries.map((entry) {
                final activity = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isEditable
                          ? ActivityEditable(
                              title: activity?.title ?? '',
                              preparation: activity?.preparation ?? '',
                              requiredMaterials:
                                  activity?.requiredMaterials ?? '',
                              obtainingMaterials:
                                  activity?.obtainingMaterials ?? '',
                              recap: activity?.recap ?? '',
                              onTitleChanged: (val) => activity?.title = val,
                              onPreparationChanged: (val) =>
                                  activity?.preparation = val,
                              onRequiredMaterialsChanged: (val) =>
                                  activity?.requiredMaterials = val,
                              onObtainingMaterialsChanged: (val) =>
                                  activity?.obtainingMaterials = val,
                              onRecapChanged: (val) => activity?.recap = val,
                            )
                          : ActivityNonEditable(
                              title: activity?.title ?? '',
                              preparation: activity?.preparation ?? '',
                              requiredMaterials:
                                  activity?.requiredMaterials ?? '',
                              obtainingMaterials:
                                  activity?.obtainingMaterials ?? '',
                              recap: activity?.recap ?? '',
                            ),
                      if (fromPage == FromPage.view)
                        addMediaUrlButton(
                          onPressed: () {
                            // Show bottom sheet for this activity
                            final activityId = activity?.id ?? '';

                            logD('activity is ${activityId}');
                            if (activityId.isNotEmpty) {
                              Get.bottomSheet(
                                AddActivityMediaUrlBottomSheet(
                                  itemId: activityId,
                                ),
                                isScrollControlled: true,
                                ignoreSafeArea: false,
                              );
                            }
                          },
                        ),

                      //Show the list of media (videos/images) for this activity
                      if (activity?.media != null &&
                          activity.media?.isNotEmpty &&
                          fromPage == FromPage.view)
                        ...activity.media.map<Widget>(
                          (m) => MediaCard(
                            media: m,
                            onDelete: () async {
                              await controller.deleteMediaFromResourceActivity(
                                resourceId: 'activities',
                                itemId: activity?.id,
                                mediaId: m.id,
                              );
                            },
                          ),
                        ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ratings Row (Stars + Review Count Only)
                          Row(
                            children: [
                              // Individual Rating (if exists)
                              if (activity?.rating != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.k46A0F1.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.k46A0F1.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    'your Rating: ${activity!.rating?.stars}★',
                                    style: AppTextStyle.lato(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.k46A0F1,
                                    ),
                                  ),
                                ),

                              // Aggregate Rating (if exists)
                              if (activity?.aggregateRating != null) ...[
                                if (activity?.rating != null) 8.horizontalSpace,
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '${(activity!.aggregateRating?.averageStars ?? 0).toInt()}★ (${activity.aggregateRating?.totalReviews ?? 0})',
                                    style: AppTextStyle.lato(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.amber[700],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          12.verticalSpace,

                          if (fromPage == FromPage.view)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Icon(
                                  Icons.star,
                                  color: activity?.rating != null
                                      ? Colors.amber[600]
                                      : AppColors.k46A0F1,
                                  size: 18,
                                ),
                                label: Text(
                                  activity?.rating != null
                                      ? 'Update Rating'
                                      : 'Rate Activity',
                                  style: AppTextStyle.lato(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: activity?.rating != null
                                        ? Colors.amber[700]
                                        : AppColors.k46A0F1,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: activity?.rating != null
                                        ? Colors.amber[500]!
                                        : AppColors.k46A0F1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  if (activity?.id != null &&
                                      (activity!.id as String).isNotEmpty) {
                                    final result = await Get.bottomSheet(
                                      ReviewActivityBottomSheet(
                                        activityId: activity!.id as String,
                                      ),
                                      isScrollControlled: true,
                                      ignoreSafeArea: false,
                                    );
                                    controller.update();
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        }),
      ),
    );
  }
}

/// A widget that displays a section header with an optional edit button.
Widget sectionHeader(String title, {VoidCallback? onEditTap}) => Row(
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

/// A button for adding a media URL.
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
