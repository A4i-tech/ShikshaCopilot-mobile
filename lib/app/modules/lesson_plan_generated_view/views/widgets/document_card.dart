import 'package:sikshana/app/utils/exports.dart';

/// A reusable card widget used to display downloadable document items
/// such as lesson plan DOCX, 5E table DOCX, or PDF files.
///
/// The card shows:
/// - An icon (SVG)
/// - A title describing the document
/// - A file type label (e.g., "DOCX file", "PDF file")
/// - A download button with an optional callback
///
/// This widget is typically used inside the *Documents* tab.
class DocumentCard extends StatelessWidget {
  /// Creates a [DocumentCard].
  ///
  /// - [title] — Display name of the document (e.g., "Lesson Plan Docx").
  /// - [fileType] — Short label of the file type (e.g., "PDF file").
  /// - [icon] — SVG asset path for the document icon.
  /// - [onDownload] — Optional callback triggered when the user taps
  ///   the download icon.
  const DocumentCard({
    required this.title,
    required this.fileType,
    required this.icon,
    Key? key,
    this.onDownload,
    this.disabled = false,
    this.isLessonResource = false,
  }) : super(key: key);

  /// Title of the document card (e.g., "Lesson Plan Docx").
  final String title;

  /// Type of file (e.g., "DOCX file", "PDF file").
  final String fileType;

  /// SVG path for the icon displayed at the beginning of the row.
  final String icon;

  /// Callback executed when the download button is tapped.
  ///
  /// If `null`, the download icon will be shown but tapping it will do nothing.
  final VoidCallback? onDownload;

  /// Is card Disabled or not
  final bool disabled;

  final bool isLessonResource;

  /// Builds the document card UI container with icon, title, file type,
  /// and the download button.
  ///
  /// The card layout:
  /// ```
  /// [ICON]  Title + FileType        [Download Button]
  /// ```
  @override
  Widget build(BuildContext context) {
    final Color titleColor = disabled ? AppColors.kAEAEAE : AppColors.k424955;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kFFFFFF,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: disabled ? AppColors.kD9D9D970 : AppColors.kDEE1E6,
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: <Widget>[
              SvgPicture.asset(icon, width: 20, height: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fileType,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      color: AppColors.kAEAEAE,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: disabled
                ? () {
                    final messageKey = isLessonResource
                        ? LocaleKeys.downloadLessonResourceMessage
                        : LocaleKeys.downloadLessonPlanMessage;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(messageKey.tr)));
                  }
                : onDownload,
            padding: EdgeInsets.zero,
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
          ),
        ],
      ),
    );
  }
}
