import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a card for a lesson plan or a lesson resource.
///
/// This widget takes a [Plan] object and displays its details in a
/// beautifully designed card.
class LessonPlanResourceListCard extends StatelessWidget {
  /// Creates a new [LessonPlanResourceListCard].
  const LessonPlanResourceListCard({required this.model, super.key});

  /// The [Plan] object to display.
  final Plan model;

  @override
  Widget build(BuildContext context) {
    final bool isLesson = model.isLesson ?? true;
    final int sem = isLesson
        ? model.lesson?.subjects?.sem ?? 1
        : model.resource?.subjects?.sem ?? 1;
    final String subject = isLesson
        ? model.lesson?.subjects?.name ?? ''
        : model.resource?.subjects?.name ?? '';
    final String subjectDisplay = sem > 0 ? '$subject Sem $sem' : subject;
    // final String topic = isLesson
    //     ? model.lesson?.chapter?.topics ?? ''
    //     : model.resource?.chapter?.topics ?? '';

    final int classSelected = isLesson
        ? model.lesson?.lessonClass ?? 0
        : model.resource?.resourceClass ?? 0;

    final String chapter = isLesson
        ? '${model.lesson?.chapter?.orderNumber} ${model.lesson?.chapter?.topics}'
        : '${model.resource?.chapter?.orderNumber} ${model.resource?.chapter?.topics}';

    final String subTopic = () {
      final subs = isLesson
          ? model.lesson?.subTopics
          : model.resource?.subTopics;
      return subs?.isNotEmpty == true ? subs!.first.toString().trim() : '';
    }();

    final Color cardColor = isLesson ? AppColors.kA062F7 : AppColors.k70CF97;
    // final int count = isLesson ? lessonPlanCount : lessonResourceCount;
    final String buttonName = isLesson
        ? LocaleKeys.viewLessonPlan.tr
        : LocaleKeys.viewResourcePlan.tr;
    final String generatedAt = DateFormat(
      'MMM d, yyyy',
    ).format(model.createdAt ?? DateTime.now());
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.17),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.description_outlined, color: cardColor),
                ),
                Text(
                  '${LocaleKeys.generatedOn.tr}: $generatedAt',
                  style: AppTextStyle.lato(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '${LocaleKeys.subject.tr}: $subjectDisplay',
              style: AppTextStyle.lato(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: <Widget>[
                _LabelCapsule(
                  text: 'Class $classSelected',
                  background: Colors.blue[50]!,
                  textColor: Colors.blue[700]!,
                ),
                SizedBox(width: 8.w),
                _LabelCapsule(
                  text: isLesson ? 'Lesson Plan' : 'Lesson Resource',
                  background: Colors.pink[50]!,
                  textColor: Colors.pink[400]!,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              '${LocaleKeys.chapter.tr}: $chapter',
              style: AppTextStyle.lato(
                fontSize: 12.sp,
                color: AppColors.k54577A,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: <Widget>[
                Text(
                  '${LocaleKeys.subTopic.tr}: ',
                  style: AppTextStyle.lato(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.k54577A,
                  ),
                ),
                Flexible(
                  child: _LabelCapsule(
                    text: subTopic,
                    background: AppColors.kF1FDF3,
                    textColor: AppColors.k3D8248,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: <Widget>[
                if (model.status.toString().isNotEmpty)
                  Flexible(
                    child: AppButton(
                      buttonColor: cardColor,
                      buttonText: buttonName,
                      onPressed: () {
                        if (isLesson) {
                          // TODO: Navigation or action
                          final String? lessonId =
                              model.lesson?.id ??
                              model
                                  .resource
                                  ?.id; // Change as per your model structure

                          if (lessonId != null) {
                            Get.toNamed(
                              Routes.LESSON_PLAN_GENERATED_VIEW,
                              arguments: <String, Object>{
                                'lessonId': lessonId,
                                'from_page': FromPage.view, // passes "view"
                              },
                            );
                          }
                        } else {
                          // TODO: Navigation or action
                          final String? resourceId =
                              model.resource?.id ??
                              model
                                  .lesson
                                  ?.id; // Change as per your model structure

                          if (resourceId != null) {
                            Get.toNamed(
                              Routes.LESSON_RESOURCE_GENERATED_VIEW,
                              arguments: <String, Object>{
                                'lessonId': resourceId,
                                'from_page': FromPage.view, // passes "view"
                              },
                            );
                          }
                        }
                      },
                      //   buttonColor: model.buttonColor,
                      borderRadius: BorderRadius.circular(4.r),
                      height: 36.h,
                    ),
                  ),
                if (isLesson) ...<Widget>[
                  SizedBox(width: 10.w),
                  Flexible(
                    child: AppButton(
                      buttonText: LocaleKeys.chatbot.tr,
                      onPressed: () {
                        Get.toNamed(
                          Routes.LESSON_CHATBOT,
                          arguments: <String, String?>{
                            'lessonId': model.id,
                            'chapterId': model.lesson?.chapter?.id,
                          },
                        );
                      },
                      height: 36.h,
                      buttonColor: AppColors.kFFFFFF,
                      borderSide: BorderSide(color: cardColor),
                      buttonTextColor: cardColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A helper widget for displaying a pill-shaped label.
///
/// This widget displays a [Text] widget inside a [Container] with a rounded
/// border and a background color.
class _LabelCapsule extends StatelessWidget {
  /// Creates a new [_LabelCapsule].
  const _LabelCapsule({
    required this.text,
    required this.background,
    required this.textColor,
  });

  /// The text to display.
  final String text;

  /// The background color of the capsule.
  final Color background;

  /// The color of the text.
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Text(
      text,
      softWrap: true,
      overflow: TextOverflow.visible, // Allows wrapping instead of ...
      maxLines: 2, // Remove line limit
      style: AppTextStyle.lato(
        fontSize: 11.sp,
        color: textColor,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
