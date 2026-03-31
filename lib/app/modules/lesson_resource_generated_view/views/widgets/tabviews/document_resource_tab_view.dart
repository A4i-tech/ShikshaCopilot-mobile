import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/document_card.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A tab view widget that displays a list of document resources.
class DocumentResourceTabView
    extends GetView<LessonResourceGeneratedViewController> {
  /// Creates a [DocumentResourceTabView].
  const DocumentResourceTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FromPage fromPage =
        Get.arguments?['from_page'] as FromPage? ?? FromPage.view;
    final bool isGenerated = fromPage == FromPage.generate;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          8.verticalSpace,
          DocumentCard(
            isLessonResource: true,
            title: 'Lesson Resource Docx',
            fileType: 'DOCX file',
            disabled: isGenerated,
            icon: AppImages.icDocs,
            onDownload: () async {
              // Show bottom sheet with Save/Share options
              showSaveOrShareBottomSheet(
                context: context,
                onSaveToDevice: () async {
                  await controller.generateLessonResourcePdf(
                    saveToDevice: true,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lesson Resource DOCX saved to device!'),
                    ),
                  );
                },
                onShare: () async {
                  await controller.generateLessonResourcePdf(
                    saveToDevice: false,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Lesson Resource DOCX shared successfully!',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          8.verticalSpace,
        ],
      ).paddingSymmetric(horizontal: 24),
    );
  }

  /// Reusable method to show the Save or Share options in a bottom sheet.
  void showSaveOrShareBottomSheet({
    required BuildContext context,
    required VoidCallback onSaveToDevice,
    required VoidCallback onShare,
  }) {
    showModalBottomSheet(
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
}
