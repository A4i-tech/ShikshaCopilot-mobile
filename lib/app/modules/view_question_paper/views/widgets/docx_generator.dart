import 'dart:io';
import 'package:docx_creator/docx_creator.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:open_file_manager/open_file_manager.dart' as OpenFileManager;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sikshana/app/data/config/logger.dart';
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';

import 'package:sikshana/app/utils/exports.dart';

import '../../../lesson_resource_generated_view/models/view_resource_plan_model.dart'
    as viewResource;

class DocxGenerator {
  static Future<void> generateLessonPlanDocx(
    User? user,
    ViewLessonPlanModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No lesson data available to generate DOCX.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      // ===== LOAD FONTS FOR INDIC SCRIPTS =====
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      // ===== EXTRACT DATA =====
      final lesson = data.data?.lesson;
      final chapter = lesson?.chapter;
      final subjectMeta = lesson?.subjects;

      final String board = chapter?.board ?? '';
      final String medium = chapter?.medium ?? '';
      final String klass = (lesson?.lessonClass)?.toString() ?? '';
      final String subject = subjectMeta?.name ?? '';
      final String chapterTitle = chapter?.topics ?? '';
      final String subTopic =
          (lesson?.subTopics != null && lesson!.subTopics!.isNotEmpty)
          ? lesson.subTopics!.first
          : '';

      final List<String> learningOutcomes =
          lesson?.learningOutcomes?.cast<String>() ??
          data.data?.learningOutcomes?.cast<String>() ??
          <String>[];

      // Map sections
      final List<Map<String, dynamic>> sections =
          data.data?.sections
              ?.map(
                (section) => {
                  "id": section.id,
                  "title": section.title,
                  "content": section.content,
                  "outputFormat": section.outputFormat,
                },
              )
              .toList()
              .cast<Map<String, dynamic>>() ??
          [];

      // ===== CREATE DOCX BUILDER =====
      final builder = DocxDocumentBuilder();

      // ===== EMBED CUSTOM FONTS FOR INDIC SCRIPTS =====
      builder
        ..addFont('NotoSansKannada', kannadaData.buffer.asUint8List())
        ..addFont('NotoSansTelugu', teluguData.buffer.asUint8List());

      // ===== FONT SELECTION HELPER =====
      String selectFontFamily(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) {
          return 'NotoSansKannada'; // Kannada
        }
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
          return 'NotoSansTelugu'; // Telugu
        }
        return 'Calibri'; // Default font for English/Latin
      }

      // ===== HELPER: Clean Markdown/Special Characters =====
      String cleanContent(String input) {
        var cleaned = input.replaceAll('**', '');
        cleaned = cleaned.replaceAllMapped(
          RegExp(r'^#+\s*', multiLine: true),
          (_) => '',
        );
        cleaned = cleaned.split('\n').map((line) => line.trim()).join('\n');
        cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
        return cleaned.trim();
      }

      // ===== ADD TITLE =====
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              'Lesson Plan',
              fontWeight: DocxFontWeight.bold, // ✅ Bold
              fontSize: 22,
              color: DocxColor.fromHex('2563EB'), // ✅ Blue
            ),
          ],
          align: DocxAlign.center,
          spacingAfter: 200,
        ),
      );

      // ===== ADD HEADER INFORMATION TABLE =====
      final headerTable = [
        ['Board', board],
        ['Medium', medium],
        ['Class', klass],
        ['Subject', subject],
        ['Chapter', chapterTitle],
        ['Sub-Topic', subTopic],
      ];

      builder.table(
        headerTable,
        hasHeader: false,
        style: const DocxTableStyle(borderWidth: 1),
      );

      builder.pageBreak();

      // ===== ADD LEARNING OUTCOMES SECTION =====
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              'LEARNING OUTCOMES',
              fontWeight: DocxFontWeight.bold, // ✅ Bold
              fontSize: 18,
              color: DocxColor.fromHex('2563EB'), // ✅ Blue heading
            ),
          ],
          spacingAfter: 120,
        ),
      );
      builder.add(const DocxParagraph(children: [DocxText('')])); // Spacing

      for (final outcome in learningOutcomes) {
        final cleanedOutcome = cleanContent(outcome);
        final fontFamily = selectFontFamily(cleanedOutcome);

        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                '• $cleanedOutcome',
                fontFamily: fontFamily,
                fontSize: 11,
                color: DocxColor.black, // ✅ Black text
              ),
            ],
            align: DocxAlign.left,
            spacingAfter: 120,
          ),
        );
      }

      builder.pageBreak();

      // ===== ADD SECTION PAGES =====
      final List<Map<String, dynamic>> plainTextSections = sections
          .where((s) => s['outputFormat'] == 'plain_text')
          .toList();

      for (final sec in plainTextSections) {
        final String content = sec['content'] as String? ?? '';
        if (content.isEmpty) continue;

        logD(
          "Generating DOCX section: ${sec['title']} - content length ${content.length}",
        );

        final String cleanedContent = cleanContent(content);
        final String sectionTitle = (sec['title'] as String? ?? '')
            .toUpperCase();
        final fontFamily = selectFontFamily(cleanedContent);

        // Section title with color
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                sectionTitle,
                fontFamily: selectFontFamily(sectionTitle), // ✅ Font selection
                fontWeight: DocxFontWeight.bold, // ✅ Bold
                fontSize: 16,
                color: DocxColor.fromHex('2563EB'), // ✅ Blue heading
              ),
            ],
            spacingAfter: 120,
          ),
        );

        // Section content - split into paragraphs
        final paragraphs = cleanedContent.split('\n\n');
        for (final para in paragraphs) {
          if (para.trim().isEmpty) continue;

          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  para.trim(),
                  fontFamily: fontFamily,
                  fontSize: 11,
                  color: DocxColor.black, // ✅ Black text
                ),
              ],
              align: DocxAlign.left,
              spacingAfter: 200,
            ),
          );
        }

        builder.pageBreak();
      }

      // ===== BUILD DOCX =====
      final doc = builder.build();

      // ===== SAVE OR SHARE =====
      final String fileName =
          '${subject.replaceAll(' ', '-')}_${chapterTitle.replaceAll(' ', '-')}_LessonPlan';

      await _saveDocx(fileName, doc, saveToDevice: saveToDevice);
    } catch (e, stackTrace) {
      logD('DOCX Generation Error: $e\n$stackTrace');
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static Future<void> generate5ETableDocx(
    Map<String, dynamic>? checklist,
    User? user,
    ViewLessonPlanModel? data, {
    bool saveToDevice = false,
  }) async {
    if (checklist == null) {
      appSnackBar(
        message: 'Error: No data available to generate DOCX.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      // ---------- FROM lessonPlan RESPONSE ----------
      final lesson = data?.data?.lesson;
      final chapter = lesson?.chapter;
      final subjectMeta = lesson?.subjects;

      final String board = chapter?.board ?? '';
      final String medium = chapter?.medium ?? '';
      final String klass = (lesson?.lessonClass)?.toString() ?? '';
      final String subject = subjectMeta?.name ?? '';
      final String chapterTitle = chapter?.topics ?? '';
      final String subTopic =
          (lesson?.subTopics != null && lesson!.subTopics!.isNotEmpty)
          ? lesson.subTopics!.first
          : '';

      final List<String> learningOutcomes =
          lesson?.learningOutcomes?.cast<String>() ?? <String>[];

      // ---------- FROM USER ----------
      final String schoolName = user?.school?.name ?? '';
      final String teacherName = user?.name ?? '';

      final String reportDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

      // ===== LOAD FONTS FOR INDIC SCRIPTS =====
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      // ===== CREATE DOCX BUILDER =====
      final builder = DocxDocumentBuilder();

      // ===== EMBED CUSTOM FONTS =====
      builder
        ..addFont('NotoSansKannada', kannadaData.buffer.asUint8List())
        ..addFont('NotoSansTelugu', teluguData.buffer.asUint8List());

      // ===== FONT SELECTION HELPER =====
      String selectFontFamily(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) {
          return 'NotoSansKannada';
        }
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
          return 'NotoSansTelugu';
        }
        return 'Calibri';
      }

      // ===== ADD TITLE =====
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              '5E Lesson Plan Report',
              fontWeight: DocxFontWeight.bold, // ✅ Fixed: DocxFontWeight.bold
              fontSize: 18,
              color: DocxColor.fromHex('2563EB'),
            ),
          ],
          align: DocxAlign.center,
          spacingAfter: 200,
        ),
      );

      // -------- TOP HEADER TABLE --------
      final headerTable = [
        [
          'Board',
          'Medium',
          'Class',
          'Subject',
          'Chapter',
          'Sub-Topic',
          'School Name',
          'Teacher Name',
          'Report Generated Date',
        ],
        [
          board,
          medium.capitalizeFirst ?? medium,
          klass,
          subject,
          chapterTitle,
          subTopic,
          schoolName,
          teacherName,
          reportDate,
        ],
      ];

      builder.table(
        headerTable,
        hasHeader: true,
        style: const DocxTableStyle(borderWidth: 1),
      );

      builder.add(const DocxParagraph(children: [DocxText('')])); // Spacing

      // -------- LEARNING OUTCOMES --------
      if (learningOutcomes.isNotEmpty) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                'Learning Outcomes',
                fontWeight: DocxFontWeight.bold, // ✅ Fixed: DocxFontWeight.bold
                fontSize: 14,
                color: DocxColor.fromHex('2563EB'),
              ),
            ],
            spacingAfter: 120,
          ),
        );

        for (final outcome in learningOutcomes) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  '• $outcome',
                  fontFamily: selectFontFamily(outcome),
                  fontSize: 11,
                  color: DocxColor.black,
                ),
              ],
              align: DocxAlign.left,
              spacingAfter: 80,
            ),
          );
        }

        builder.add(
          const DocxParagraph(children: [DocxText('')], spacingAfter: 200),
        );
      }

      // -------- 5E CHECKLIST TABLE --------
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              '5E Lesson Plan Summary',
              fontWeight: DocxFontWeight.bold, // ✅ Fixed: DocxFontWeight.bold
              fontSize: 14,
              color: DocxColor.fromHex('2563EB'),
            ),
          ],
          spacingAfter: 120,
        ),
      );

      final List<String> phaseKeys = checklist!.keys.toList();

      // Build 5E table data
      final List<List<String>> fiveETableData = [
        // Header row
        ['PHASE', 'CLASSROOM PROCESS', 'TLM', 'CCE TOOLS & TECHNIQUES'],
      ];

      // Data rows
      for (final phase in phaseKeys) {
        if (checklist[phase] != null) {
          final Map<String, dynamic> entry =
              checklist[phase] as Map<String, dynamic>? ?? <String, dynamic>{};
          final String activity = entry['activity'] ?? '';
          final String materials = entry['materials'] ?? '';
          const String cce = 'Observation.';

          fiveETableData.add([phase.toUpperCase(), activity, materials, cce]);
        }
      }

      builder.table(
        fiveETableData,
        hasHeader: true,
        style: const DocxTableStyle(borderWidth: 1),
      );

      // ===== BUILD DOCX =====
      final doc = builder.build();

      // ===== SAVE OR SHARE =====
      final String fileName =
          '${subject.replaceAll(' ', '-')}_${chapterTitle.replaceAll(' ', '-')}_checklist';

      await _saveDocx(fileName, doc, saveToDevice: saveToDevice);
    } catch (e, stackTrace) {
      logD('DOCX Generation Error: $e\n$stackTrace');
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static Future<void> _saveDocx(
    String fileName,
    DocxBuiltDocument doc, {
    bool saveToDevice = false,
  }) async {
    try {
      if (saveToDevice) {
        // ===== SAVE TO DEVICE =====
        Directory dir;
        if (Platform.isAndroid) {
          final baseDir = await getExternalStorageDirectory();
          if (baseDir == null) {
            dir = await getApplicationDocumentsDirectory();
          } else {
            final match = RegExp(r'.+0/').stringMatch(baseDir.path);
            if (match != null) {
              dir = Directory('${match}Download');
            } else {
              dir = baseDir;
            }
          }
          if (!dir.existsSync()) dir.createSync(recursive: true);
        } else if (Platform.isIOS) {
          dir = await getApplicationDocumentsDirectory();
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final String filePath = '${dir.path}/$fileName.docx';

        // ✅ CORRECT USAGE: Create exporter instance first
        final exporter = DocxExporter();
        await exporter.exportToFile(doc, filePath);

        logD('DOCX saved to: $filePath');

        _showDocxSavedSnackbar(
          filePath: filePath,
          onOpenFolder: () async {
            try {
              await OpenFileManager.openFileManager(
                androidConfig: OpenFileManager.AndroidConfig(),
              );
            } catch (e) {
              logD('Failed to open folder: $e');
              appSnackBar(
                message: 'Could not open file manager',
                state: SnackBarState.danger,
              );
            }
          },
        );
      } else {
        // ===== SHARE DOCX =====
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/$fileName.docx';

        // ✅ CORRECT USAGE: Create exporter instance
        final exporter = DocxExporter();
        await exporter.exportToFile(doc, filePath);

        await Share.shareXFiles([
          XFile(
            filePath,
            mimeType:
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            name: '$fileName.docx',
          ),
        ], subject: 'Lesson Plan DOCX');
      }
    } catch (e, stackTrace) {
      logD('DOCX Saving Error: $e\n$stackTrace');
      appSnackBar(
        message: 'Error saving/sharing DOCX: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static void _showDocxSavedSnackbar({
    required String filePath,
    required VoidCallback onOpenFolder,
  }) {
    Get.rawSnackbar(
      borderColor: Colors.green.shade300, // Success border
      margin: REdgeInsets.all(16),
      padding: REdgeInsets.all(16),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade600,
            size: 24,
          ),
          12.horizontalSpace,
          Expanded(
            child: Padding(
              padding: REdgeInsets.only(top: 2.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DOCX saved successfully!', // ✅ Changed to DOCX
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColors.k46A0F1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    filePath,
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: AppColors.k46A0F1.withOpacity(0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          12.horizontalSpace,
          Row(
            children: [
              InkWell(
                onTap: () {
                  onOpenFolder();
                  Get.back(); // Dismiss immediately
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    'Open Folder',
                    style: AppTextStyle.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: AppColors.k46A0F1,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              8.horizontalSpace,
              // Close button
              InkWell(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.close,
                  color: AppColors.k46A0F1,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.green.shade50,
      borderRadius: 12.r,
      duration: const Duration(seconds: 30), // ✅ 30 seconds
      snackPosition: SnackPosition.TOP,
    );
  }

  static Future<void> generateLessonResourceDocx(
    User? user,
    viewResource.ViewResourcePlanModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No resource data available to generate DOCX.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      final resourcePlan = data.data;
      final lesson = resourcePlan?.resource;
      final chapter = lesson?.chapter;
      final subjectMeta = lesson?.subjects;

      final String board = chapter?.board ?? '';
      final String medium = chapter?.medium ?? '';
      final String klass = (lesson?.resourceClass)?.toString() ?? '';
      final String subject = subjectMeta?.name ?? '';
      final String chapterTitle = chapter?.topics ?? '';
      final String subTopic =
          (lesson?.subTopics != null && lesson!.subTopics!.isNotEmpty)
          ? lesson.subTopics!.first
          : '';

      final List<String> learningOutcomes =
          lesson?.learningOutcomes?.cast<String>() ??
          resourcePlan?.learningOutcomes?.cast<String>() ??
          <String>[];

      final List<viewResource.ResourceElement> resources =
          resourcePlan?.resources ?? <viewResource.ResourceElement>[];

      // ===== LOAD FONTS FOR INDIC SCRIPTS =====
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      // ===== CREATE DOCX BUILDER =====
      final builder = DocxDocumentBuilder();

      // ===== EMBED CUSTOM FONTS =====
      builder
        ..addFont('NotoSansKannada', kannadaData.buffer.asUint8List())
        ..addFont('NotoSansTelugu', teluguData.buffer.asUint8List());

      // ===== FONT SELECTION HELPER =====
      String selectFontFamily(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) {
          return 'NotoSansKannada';
        }
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
          return 'NotoSansTelugu';
        }
        return 'Calibri';
      }

      // ===== HELPER: Clean Content =====
      String cleanContent(String input) {
        var cleaned = input.replaceAll('**', '');
        cleaned = cleaned.replaceAllMapped(
          RegExp(r'^#+\s*', multiLine: true),
          (_) => '',
        );
        cleaned = cleaned.split('\n').map((line) => line.trim()).join('\n');
        cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
        return cleaned.trim();
      }

      // ===== ADD TITLE =====
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              'Lesson Resource Plan',
              fontWeight: DocxFontWeight.bold,
              fontSize: 22,
              color: DocxColor.fromHex('2563EB'), // Blue
            ),
          ],
          align: DocxAlign.center,
          spacingAfter: 200,
        ),
      );

      // ===== HEADER TABLE =====
      final headerTable = [
        ['Board', board],
        ['Medium', medium],
        ['Class', klass],
        ['Subject', subject],
        ['Chapter', chapterTitle],
        ['Sub-Topic', subTopic],
      ];

      builder.table(
        headerTable,
        hasHeader: false,
        style: const DocxTableStyle(borderWidth: 1),
      );

      builder.pageBreak();

      // ===== LEARNING OUTCOMES =====
      if (learningOutcomes.isNotEmpty) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                'LEARNING OUTCOMES',
                fontWeight: DocxFontWeight.bold,
                fontSize: 18,
                color: DocxColor.fromHex('2563EB'), // Blue
              ),
            ],
            spacingAfter: 120,
          ),
        );

        for (final outcome in learningOutcomes) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  '• $outcome',
                  fontFamily: selectFontFamily(outcome),
                  fontSize: 11,
                  color: DocxColor.black,
                ),
              ],
              align: DocxAlign.left,
              spacingAfter: 80,
            ),
          );
        }

        builder.pageBreak();
      }

      // ===== RESOURCE SECTIONS =====
      for (final viewResource.ResourceElement res in resources) {
        switch (res.outputFormat) {
          case 'json_1':
            _buildQuestionBankDocx(res, builder, selectFontFamily);
            break;
          case 'json_2':
            _buildRealWorldDocx(res, builder, selectFontFamily);
            break;
          case 'json_3':
            _buildActivitiesDocx(res, builder, selectFontFamily);
            break;
          default:
            break;
        }
      }

      // ===== BUILD DOCX =====
      final doc = builder.build();

      final String fileName =
          '${subject.replaceAll(' ', '-')}_${chapterTitle.replaceAll(' ', '-')}_LessonResource';

      await _saveDocx(fileName, doc, saveToDevice: saveToDevice);
    } catch (e, stackTrace) {
      logD('DOCX Generation Error: $e\n$stackTrace');
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  // ===== HELPER: QUESTION BANK (json_1) =====
  static void _buildQuestionBankDocx(
    viewResource.ResourceElement resource,
    DocxDocumentBuilder builder,
    String Function(String) selectFontFamily,
  ) {
    const Map<String, String> difficultyLabels = {
      'beginner': 'BEGINNER',
      'intermediate': 'INTERMEDIATE',
      'advanced': 'ADVANCED',
    };

    builder.add(
      DocxParagraph(
        children: [
          DocxText(
            'QUESTION BANK',
            fontWeight: DocxFontWeight.bold,
            fontSize: 20,
            color: DocxColor.fromHex('2563EB'), // Blue
          ),
        ],
        spacingAfter: 120,
      ),
    );

    if (resource.title.isNotEmpty) {
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              resource.title,
              fontFamily: selectFontFamily(resource.title),
              fontWeight: DocxFontWeight.bold,
              fontSize: 16,
              color: DocxColor.black,
            ),
          ],
          spacingAfter: 80,
        ),
      );
    }

    for (final viewResource.ResourceContent diffBlock in resource.content) {
      final String diffKey = diffBlock.difficulty ?? '';
      final String diffLabel =
          difficultyLabels[diffKey.toLowerCase()] ?? diffKey.toUpperCase();

      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              diffLabel,
              fontWeight: DocxFontWeight.bold,
              fontSize: 16,
              color: DocxColor.fromHex('2563EB'), // Blue
            ),
          ],
          spacingAfter: 80,
        ),
      );

      final List<viewResource.ContentContent> contents =
          diffBlock.content ?? <viewResource.ContentContent>[];

      // MCQs
      final viewResource.ContentContent? mcqContent = contents.firstWhere(
        (c) => c.type == 'MCQs',
        orElse: () => viewResource.ContentContent(),
      );
      final List<viewResource.Question> mcqQuestions =
          mcqContent?.questions ?? <viewResource.Question>[];

      if (mcqQuestions.isNotEmpty) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                'MCQS',
                fontWeight: DocxFontWeight.bold,
                fontSize: 14,
                color: DocxColor.fromHex('2563EB'), // Blue
              ),
            ],
            spacingAfter: 60,
          ),
        );

        int qNo = 1;
        for (final viewResource.Question q in mcqQuestions) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  '$qNo. ${q.question}',
                  fontFamily: selectFontFamily(q.question),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );

          if (q.options != null && q.options!.isNotEmpty) {
            for (final opt in q.options!) {
              builder.add(
                DocxParagraph(
                  children: [
                    DocxText(
                      '• $opt',
                      fontFamily: selectFontFamily(opt),
                      fontSize: 12,
                      color: DocxColor.black,
                    ),
                  ],
                  spacingAfter: 20,
                ),
              );
            }
          }
          qNo++;
        }
      }

      // Assessment
      final viewResource.ContentContent? assessmentContent = contents
          .firstWhere(
            (c) => c.type == 'assessment',
            orElse: () => viewResource.ContentContent(),
          );
      final List<viewResource.Question> assessmentQuestions =
          assessmentContent?.questions ?? <viewResource.Question>[];

      if (assessmentQuestions.isNotEmpty) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                'ASSESSMENT',
                fontWeight: DocxFontWeight.bold,
                fontSize: 14,
                color: DocxColor.fromHex('2563EB'), // Blue
              ),
            ],
            spacingAfter: 60,
          ),
        );

        int aNo = 1;
        for (final viewResource.Question q in assessmentQuestions) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  '$aNo. ${q.question}',
                  fontFamily: selectFontFamily(q.question),
                  fontSize: 13,
                  color: DocxColor.black, // ✅ Black text
                ),
              ],
              spacingAfter: 40,
            ),
          );
          aNo++;
        }
      }

      builder.pageBreak();
    }
  }

  static void _buildRealWorldDocx(
    viewResource.ResourceElement resource,
    DocxDocumentBuilder builder,
    String Function(String) selectFontFamily,
  ) {
    const Map<String, String> difficultyLabels = {
      'beginner': 'BEGINNER',
      'intermediate': 'INTERMEDIATE',
      'advanced': 'ADVANCED',
    };

    builder.add(
      DocxParagraph(
        children: [
          DocxText(
            'REAL WORLD SCENARIOS',
            fontWeight: DocxFontWeight.bold,
            fontSize: 20,
            color: DocxColor.fromHex('2563EB'), // Blue
          ),
        ],
        spacingAfter: 120,
      ),
    );

    for (final viewResource.ResourceContent diffBlock in resource.content) {
      final String diffKey = diffBlock.difficulty ?? '';
      final String diffLabel =
          difficultyLabels[diffKey.toLowerCase()] ?? diffKey.toUpperCase();

      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              diffLabel,
              fontWeight: DocxFontWeight.bold,
              fontSize: 14,
              color: DocxColor.black, // Black
            ),
          ],
          spacingAfter: 60,
        ),
      );

      final List<viewResource.ContentContent> scenarios =
          diffBlock.content ?? <viewResource.ContentContent>[];

      if (scenarios.isEmpty) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                'No data available',
                fontSize: 12,
                color: DocxColor.black,
              ),
            ],
            spacingAfter: 80,
          ),
        );
        builder.pageBreak();
        return;
      }

      for (final viewResource.ContentContent scenario in scenarios) {
        if ((scenario.title ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  scenario.title ?? '',
                  fontFamily: selectFontFamily(scenario.title ?? ''),
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 13,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );
        }

        if ((scenario.question ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  scenario.question ?? '',
                  fontFamily: selectFontFamily(scenario.question ?? ''),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );
        }

        if ((scenario.description ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  scenario.description ?? '',
                  fontFamily: selectFontFamily(scenario.description ?? ''),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 80,
            ),
          );
        }
      }
      builder.pageBreak();
    }
  }

  // ===== HELPER: ACTIVITIES (json_3) =====
  static void _buildActivitiesDocx(
    viewResource.ResourceElement resource,
    DocxDocumentBuilder builder,
    String Function(String) selectFontFamily,
  ) {
    const Map<String, String> difficultyLabels = {
      'beginner': 'BEGINNER',
      'intermediate': 'INTERMEDIATE',
      'advanced': 'ADVANCED',
    };

    builder.add(
      DocxParagraph(
        children: [
          DocxText(
            'ACTIVITIES',
            fontWeight: DocxFontWeight.bold,
            fontSize: 20,
            color: DocxColor.fromHex('2563EB'), // Blue
          ),
        ],
        spacingAfter: 120,
      ),
    );

    for (final viewResource.ResourceContent diffBlock in resource.content) {
      final String diffKey = diffBlock.difficulty ?? '';
      final String diffLabel =
          difficultyLabels[diffKey.toLowerCase()] ?? diffKey.toUpperCase();

      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              diffLabel,
              fontWeight: DocxFontWeight.bold,
              fontSize: 14,
              color: DocxColor.black, // Black
            ),
          ],
          spacingAfter: 60,
        ),
      );

      if ((diffBlock.title ?? '').isNotEmpty ||
          (diffBlock.preparation ?? '').isNotEmpty ||
          (diffBlock.requiredMaterials ?? '').isNotEmpty ||
          (diffBlock.obtainingMaterials ?? '').isNotEmpty ||
          (diffBlock.recap ?? '').isNotEmpty) {
        if ((diffBlock.title ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  diffBlock.title ?? '',
                  fontFamily: selectFontFamily(diffBlock.title ?? ''),
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 13,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );
        }

        if ((diffBlock.preparation ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  'Preparation:',
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 20,
            ),
          );
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  diffBlock.preparation ?? '',
                  fontFamily: selectFontFamily(diffBlock.preparation ?? ''),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );
        }

        if ((diffBlock.requiredMaterials ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  'Required Materials:',
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 20,
            ),
          );
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  diffBlock.requiredMaterials ?? '',
                  fontFamily: selectFontFamily(
                    diffBlock.requiredMaterials ?? '',
                  ),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );
        }

        if ((diffBlock.obtainingMaterials ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  'Obtaining Materials:',
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 20,
            ),
          );
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  diffBlock.obtainingMaterials ?? '',
                  fontFamily: selectFontFamily(
                    diffBlock.obtainingMaterials ?? '',
                  ),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 40,
            ),
          );
        }

        if ((diffBlock.recap ?? '').isNotEmpty) {
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  'Recap:',
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 20,
            ),
          );
          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  diffBlock.recap ?? '',
                  fontFamily: selectFontFamily(diffBlock.recap ?? ''),
                  fontSize: 12,
                  color: DocxColor.black,
                ),
              ],
              spacingAfter: 80,
            ),
          );
        }
      }

      builder.pageBreak();
    }
  }

  static Future<void> generateQuestionPaperDocx(
    QuestionBankModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No data available to generate DOCX.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      // Load fonts for multi-language support
      final ByteData latoData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      final builder = DocxDocumentBuilder();

      // Embed fonts
      builder.addFont('Lato', latoData.buffer.asUint8List());
      builder.addFont('NotoSansKannada', kannadaData.buffer.asUint8List());
      builder.addFont('NotoSansTelugu', teluguData.buffer.asUint8List());

      // Font selection helper
      String selectFontFamily(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) return 'NotoSansKannada';
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) return 'NotoSansTelugu';
        return 'Lato';
      }

      final QuestionBank? questionBank = data.data?.questionBank;
      final Metadata? metadata = questionBank?.metadata;

      // -------------------- HEADER --------------------
      // School Name
      if (metadata?.schoolName?.isNotEmpty ?? false) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                metadata!.schoolName!,
                fontFamily: selectFontFamily(metadata.schoolName!),
                fontWeight: DocxFontWeight.bold, // ✅ Fixed: bold → fontWeight
                fontSize: 18,
                color: DocxColor.fromHex('1F2121'), // Charcoal
              ),
            ],
            align: DocxAlign.center, // ✅ Fixed: alignment → align
            spacingAfter: 120,
          ),
        );
      }

      // Examination Name
      if (data.data?.examinationName?.isNotEmpty ?? false) {
        builder.add(
          DocxParagraph(
            children: [
              DocxText(
                data.data!.examinationName!,
                fontFamily: selectFontFamily(data.data!.examinationName!),
                fontWeight: DocxFontWeight.bold, // ✅ Correct property
                fontSize: 16,
                color: DocxColor.fromHex('1F2121'),
              ),
            ],
            align: DocxAlign.center, // ✅ Correct property
            spacingAfter: 120,
          ),
        );
      }

      // Subject, Class, Marks (single row)
      builder.add(
        DocxParagraph(
          children: [
            DocxText(
              'Subject : ${data.data?.subject ?? ''}     ',
              fontFamily: selectFontFamily(data.data?.subject ?? ''),
              fontSize: 14,
              color: DocxColor.fromHex('1F2121'),
            ),
            DocxText(
              'Class : ${data.data?.grade ?? ''}     ',
              fontFamily: 'Lato',
              fontSize: 14,
              color: DocxColor.fromHex('1F2121'),
            ),
            DocxText(
              'Marks : ${data.data?.totalMarks ?? ''}',
              fontFamily: 'Lato',
              fontSize: 14,
              color: DocxColor.fromHex('1F2121'),
            ),
          ],
          spacingAfter: 240,
        ),
      );

      // Divider (via empty paragraph with border)
      builder.add(DocxParagraph(children: [DocxText('')], spacingAfter: 120));

      // -------------------- SECTIONS & QUESTIONS --------------------
      if (questionBank?.questions != null &&
          questionBank!.questions!.isNotEmpty) {
        for (
          int sectionIndex = 0;
          sectionIndex < questionBank.questions!.length;
          sectionIndex++
        ) {
          final BluePrintTemplate section =
              questionBank.questions![sectionIndex];

          // Section Header (Roman numeral + type + marks calculation)
          final int totalSectionMarks =
              (section.numberOfQuestions ?? 0) *
              (section.marksPerQuestion ?? 0);

          builder.add(
            DocxParagraph(
              children: [
                DocxText(
                  '${_toRoman(sectionIndex + 1)}. ${section.type ?? ''}     ',
                  fontFamily: selectFontFamily(section.type ?? ''),
                  fontWeight: DocxFontWeight.bold,
                  fontSize: 15,
                  color: DocxColor.fromHex('2563EB'), // Blue
                ),
                DocxText(
                  '${section.numberOfQuestions ?? 0} × ${section.marksPerQuestion ?? 0} = $totalSectionMarks',
                  fontFamily: 'Lato',
                  fontSize: 14,
                  color: DocxColor.fromHex('1F2121'),
                ),
              ],
              spacingAfter: 120,
            ),
          );

          // Questions in section
          if (section.questions != null && section.questions!.isNotEmpty) {
            for (int qIndex = 0; qIndex < section.questions!.length; qIndex++) {
              final Question question = section.questions![qIndex];

              // Question text
              builder.add(
                DocxParagraph(
                  children: [
                    DocxText(
                      '${qIndex + 1}. ',
                      fontFamily: 'Lato',
                      fontWeight: DocxFontWeight.bold,
                      fontSize: 14,
                      color: DocxColor.fromHex('1F2121'),
                    ),
                    DocxText(
                      question.question ?? '',
                      fontFamily: selectFontFamily(question.question ?? ''),
                      fontSize: 14,
                      color: DocxColor.fromHex('1F2121'),
                    ),
                  ],
                  spacingAfter: 80,
                ),
              );

              // MCQ Options
              if (question.options != null && question.options!.isNotEmpty) {
                for (int opt = 0; opt < question.options!.length; opt++) {
                  builder.add(
                    DocxParagraph(
                      children: [
                        DocxText(
                          '        ${String.fromCharCode(65 + opt)}. ${question.options![opt]}',
                          fontFamily: selectFontFamily(question.options![opt]),
                          fontSize: 13,
                          color: DocxColor.fromHex('626C71'), // Slate-500
                        ),
                      ],
                      spacingAfter: 60,
                    ),
                  );
                }
              }

              builder.add(
                DocxParagraph(children: [DocxText('')], spacingAfter: 100),
              );
            }
          }

          // Extra spacing after section
          builder.add(
            DocxParagraph(children: [DocxText('')], spacingAfter: 160),
          );
        }
      }

      // Generate and save
      final DocxBuiltDocument bytes = builder.build();
      final String fileName = 'question_paper';

      await _saveDocx(fileName, bytes, saveToDevice: saveToDevice);
    } catch (e, stackTrace) {
      logD('DOCX Generation Error: $e\n$stackTrace');
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static String _toRoman(int number) {
    if (number < 1 || number > 3999) {
      throw ArgumentError('Value must be between 1 and 3999');
    }

    final Map<int, String> romanMap = <int, String>{
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    final StringBuffer result = StringBuffer();
    int remaining = number;

    romanMap.forEach((int value, String symbol) {
      while (remaining >= value) {
        result.write(symbol);
        remaining -= value;
      }
    });
    return result.toString();
  }

  static Future<void> generateBlueprintDocx(
    QuestionBankModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No data available to generate DOCX.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      // Load fonts
      final ByteData latoData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      final builder = DocxDocumentBuilder();
      builder.addFont('Lato', latoData.buffer.asUint8List());
      builder.addFont('NotoSansKannada', kannadaData.buffer.asUint8List());
      builder.addFont('NotoSansTelugu', teluguData.buffer.asUint8List());

      // Font selection helper
      String selectFontFamily(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) return 'NotoSansKannada';
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) return 'NotoSansTelugu';
        return 'Lato';
      }

      final QuestionBank? questionBank = data.data?.questionBank;
      final Metadata? metadata = questionBank?.metadata;

      // ---------------- HEADER TABLE ----------------
      final List<List<String>> headerData = [
        ['School Name:', metadata?.schoolName ?? ''],
        ['Medium:', data.data?.medium?.capitalizeFirst ?? ''],
        ['Class:', data.data?.grade?.toString() ?? ''],
        ['Subject:', data.data?.subject ?? ''],
        [
          'Examination Name:',
          data.data?.examinationName?.capitalizeFirst ?? '',
        ],
        ['Total Marks:', data.data?.totalMarks?.toString() ?? ''],
      ];

      builder.add(
        DocxTable.fromData(
          headerData,
          hasHeader: false,
          style: const DocxTableStyle(
            headerFill: 'F5F5F5',
            evenRowFill: 'FFFFFF',
            oddRowFill: 'FAFAFA',
          ),
        ),
      );

      builder.add(DocxParagraph(children: [DocxText('')], spacingAfter: 240));

      // ---------------- BLUEPRINT TABLE ----------------
      builder.add(_buildBlueprintContentDocx(data, selectFontFamily));

      // Generate and save
      final doc = builder.build();
      await _saveDocx('blueprint', doc, saveToDevice: saveToDevice);
    } catch (e, stackTrace) {
      logD('Blueprint DOCX Error: $e\n$stackTrace');
      appSnackBar(
        message: 'Error generating blueprint: $e',
        state: SnackBarState.danger,
      );
    }
  }

  // DOCX Blueprint Content Builder
  static DocxTable _buildBlueprintContentDocx(
    QuestionBankModel data,
    String Function(String) selectFontFamily,
  ) {
    final List<List<String>> tableData = [
      // Header row
      ['Topic', 'Question Type', 'Objectives', 'Marks'],
    ];

    // Data rows
    if (data.data?.bluePrintTemplate != null) {
      for (final BluePrintTemplate template in data.data!.bluePrintTemplate!) {
        if (template.questionDistribution != null) {
          for (final dist in template.questionDistribution!) {
            final String questionType =
                questionTypes.keys.toList().firstWhereOrNull(
                  (String element) => questionTypes[element] == template.type,
                ) ??
                template.type ??
                '';

            tableData.add([
              dist.unitName ?? '',
              questionType,
              dist.objective ?? '',
              template.marksPerQuestion.toString(),
            ]);
          }
        }
      }
    }

    return DocxTable.fromData(
      tableData,
      hasHeader: true, // First row = headers
      style: const DocxTableStyle(
        headerFill: 'E3F2FD', // Light blue header
        evenRowFill: 'FFFFFF', // White
        oddRowFill: 'F5F5F5', // Light gray
      ),
    );
  }
}
