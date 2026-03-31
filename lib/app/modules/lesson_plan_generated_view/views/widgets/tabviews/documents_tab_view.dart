import 'package:sikshana/app/modules/lesson_plan_generated_view/views/widgets/document_card.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A tab in the Lesson Plan Generated View that displays different
/// downloadable document types related to the generated lesson.
///
/// This tab contains:
/// - Lesson Plan DOCX download
/// - 5E Table DOCX download
/// - 5E Table PDF download
///
/// Each item is displayed using a [DocumentCard] widget and triggers the
/// respective generation method defined inside the
/// [LessonPlanGeneratedViewController].
///
/// No scrolling issues occur because the entire content is wrapped inside
/// a [SingleChildScrollView].
class DocumentsTabView extends GetView<LessonPlanGeneratedViewController> {
  /// Creates a DocumentsTabView instance.
  ///
  /// This widget depends on an already registered
  /// [LessonPlanGeneratedViewController] in GetX.
  const DocumentsTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fromPage = Get.arguments?['from_page'] as FromPage? ?? FromPage.view;
    final bool isGenerated = fromPage == FromPage.generate;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          12.verticalSpace,
          DocumentCard(
            title: 'Lesson Plan Docx',
            fileType: 'DOCX file',
            icon: AppImages.icDocs,
            disabled: isGenerated,
            onDownload: isGenerated
                ? null
                : () {
                    showDownloadOptionsBottomSheet(
                      context: context,
                      onSaveToDevice: () async {
                        await controller.generateLessonPlanDocx(
                          saveToDevice: true,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to device!')),
                        );
                      },
                      onShare: () async {
                        await controller.generateLessonPlanDocx(
                          saveToDevice: false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Shared successfully!')),
                        );
                      },
                    );
                  },
          ),
          12.verticalSpace,
          DocumentCard(
            title: '5E Table Docs',
            fileType: 'DOCX file',
            icon: AppImages.icDocs,
            disabled: isGenerated,
            onDownload: isGenerated
                ? null
                : () async {
                    await controller.generate5ETableDocx();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('5E Table DOCX downloaded!'),
                      ),
                    );
                  },
          ),
          12.verticalSpace,
          DocumentCard(
            title: '5E Table PDF',
            fileType: 'PDF file',
            icon: AppImages.icPdf,
            disabled: isGenerated,
            onDownload: isGenerated ? null : controller.generate5ETablePdf,
          ),
        ],
      ),
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
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
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
        );
      },
    );
  }
}
