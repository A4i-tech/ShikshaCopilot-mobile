import 'package:intl/intl.dart';
import 'package:sikshana/app/modules/question_paper_generation/models/question_bank_list_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that displays a single question bank card.
class QuestionBankCard extends StatelessWidget {
  /// Creates new [QuestionBankCard]
  const QuestionBankCard({required this.qb, super.key});

  /// The question bank data model.
  final ResultQB qb;

  @override
  /// Builds the UI for the question bank card.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing a question bank card.
  Widget build(BuildContext context) {
    final String generatedAt = DateFormat(
      'MMM d, yyyy',
    ).format(qb.createdAt ?? DateTime.now());
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.VIEW_QUESTION_PAPER,
          arguments: <String, String?>{'id': qb.id},
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(20.dg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 52.w,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: AppColors.kA062F7.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description_rounded,
                      color: AppColors.kA062F7,
                      size: 24.dg,
                    ),
                  ),
                  Text(
                    '${LocaleKeys.generatedOn.tr}: $generatedAt',
                    style: AppTextStyle.lato(
                      fontSize: 12.sp,
                      color: AppColors.k54577A,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Text(
                '${LocaleKeys.subject.tr}: ${qb.subject ?? '---'}',
                style: AppTextStyle.lato(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              17.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  bubbleContainer(
                    text: '${LocaleKeys.classKey.tr} ${qb.grade ?? '---'}',
                    textColor: AppColors.k4069E5,
                    color: AppColors.k4069E5.withOpacity(0.1),
                  ),
                  8.horizontalSpace,
                  bubbleContainer(
                    text: qb.examinationName ?? '---',
                    textColor: AppColors.kDE3B40,
                    color: AppColors.kDE3B40.withOpacity(0.1),
                  ),
                ],
              ),
              16.verticalSpace,
              Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    '${LocaleKeys.chapter.tr}: ',
                    style: AppTextStyle.lato(
                      fontSize: 12.sp,
                      color: AppColors.k54577A,
                    ),
                  ),
                  ...qb.topics
                          ?.map(
                            (String e) => bubbleContainer(
                              text: e,
                              textColor: AppColors.k3FBB53,
                              color: AppColors.k3FBB53.withOpacity(0.1),
                            ),
                          )
                          .toList() ??
                      <Widget>[
                        Text(
                          '---',
                          style: AppTextStyle.lato(
                            fontSize: 12.sp,
                            color: AppColors.k54577A,
                          ),
                        ),
                      ],
                ],
              ),
              24.verticalSpace,
              AbsorbPointer(
                child: AppButton(
                  buttonText: LocaleKeys.viewQuestionPaper.tr,
                  onPressed: () {},
                  buttonColor: AppColors.kA062F7,
                  height: 45.h,
                  borderRadius: BorderRadius.circular(4).r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a themed bubble container for text display.
  ///
  /// Parameters:
  /// - `text`: The text to display inside the bubble.
  /// - `textColor`: The color of the text.
  /// - `color`: The background color of the bubble.
  ///
  /// Returns:
  /// A `Widget` representing a themed bubble container.
  Widget bubbleContainer({
    required String text,
    required Color textColor,
    required Color color,
  }) => Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12).r,
    ),
    padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 12.w),
    child: Text(
      text,
      style: AppTextStyle.lato(fontSize: 12.sp, color: textColor),
    ),
  );
}
