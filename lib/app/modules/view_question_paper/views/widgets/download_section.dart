import 'package:sikshana/app/modules/view_question_paper/controllers/view_question_paper_controller.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/docx_generator.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/pdf_generator.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A widget that provides options to download the question paper and its blueprint.
class DownloadSection extends GetView<ViewQuestionPaperController> {
  /// Constructs a [DownloadSection].
  const DownloadSection({super.key});

  @override
  /// Builds the UI for the download section.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` displaying download options.
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        '${LocaleKeys.download.tr} ${LocaleKeys.documents.tr}',
        style: AppTextStyle.lato(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
      16.verticalSpace,
      _buildDownloadItem(LocaleKeys.questionPaperKey.tr, () async {
        try {
          Loader.show();
          // await PdfGenerator.generateQuestionPaperPdf(
          //   controller.questionBankModel.value,
          // );

          Get.bottomSheet(
            SaveShareOptionsBottomSheet(
              fileName: 'question_paper.pdf',
              onSaveToDevice: () async {
                // await PdfGenerator.generateQuestionPaperPdf(
                //   controller.questionBankModel.value,
                //   saveToDevice: true,
                // );

                await DocxGenerator.generateQuestionPaperDocx(
                  controller.questionBankModel.value,
                  saveToDevice: true,
                );
              },

              onShare: () async {
                // await PdfGenerator.generateQuestionPaperPdf(
                //   controller.questionBankModel.value,
                //   saveToDevice: false,
                // );
                await DocxGenerator.generateQuestionPaperDocx(
                  controller.questionBankModel.value,
                  saveToDevice: false,
                );
              },
            ),
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            backgroundColor: Colors.white,
          );
        } finally {
          Loader.dismiss();
        }
      }),
      16.verticalSpace,
      _buildDownloadItem(LocaleKeys.bluePrint.tr, () async {
        try {
          Loader.show();
          // await PdfGenerator.generateBlueprintPdf(
          //   controller.questionBankModel.value,
          // );

          Get.bottomSheet(
            SaveShareOptionsBottomSheet(
              fileName: 'question_paper.pdf',
              onSaveToDevice: () async {
                // await PdfGenerator.generateBlueprintPdf(
                //   controller.questionBankModel.value,
                //   saveToDevice: true,
                // );

                await DocxGenerator.generateBlueprintDocx(
                  controller.questionBankModel.value,
                  saveToDevice: true,
                );
              },

              onShare: () async {
                // await PdfGenerator.generateBlueprintPdf(
                //   controller.questionBankModel.value,
                //   saveToDevice: false,
                // );

                await DocxGenerator.generateBlueprintDocx(
                  controller.questionBankModel.value,
                  saveToDevice: false,
                );
              },
            ),
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            backgroundColor: Colors.white,
          );
        } finally {
          Loader.dismiss();
        }
      }),
    ],
  );

  /// Builds a single download item card.
  ///
  /// Parameters:
  /// - `title`: The title of the document to download.
  /// - `onPressed`: The callback function to execute when the download button is pressed.
  ///
  /// Returns:
  /// A `Widget` representing a downloadable document item.
  Widget _buildDownloadItem(
    String title,
    void Function() onPressed,
  ) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: AppColors.k46A0F1.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: AppColors.k46A0F1,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.picture_as_pdf_rounded,
            size: 20.dg,
            color: AppColors.kFFFFFF,
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: AppTextStyle.lato(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${controller.questionBankModel.value?.data?.subject ?? '---'} |'
              ' ${LocaleKeys.classKey.tr} '
              '${controller.questionBankModel.value?.data?.grade ?? '---'} | '
              '${controller.questionBankModel.value?.data?.examinationName ?? '---'}',
              style: AppTextStyle.lato(
                fontSize: 12.sp,
                color: AppColors.kB0B0B0,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressed,
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.k46A0F1.withOpacity(0.1),
            ),
            padding: EdgeInsets.all(8.dg),
            child: Icon(
              Icons.share_rounded,
              size: 20.dg,
              color: AppColors.k46A0F1,
            ),
          ),
          padding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}

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
