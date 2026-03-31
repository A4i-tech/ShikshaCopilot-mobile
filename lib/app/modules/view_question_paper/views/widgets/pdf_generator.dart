import 'dart:io';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:open_file_manager/open_file_manager.dart' as OpenFileManager;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart'
    hide Question, ResourceElement, ContentContent, ResourceContent;
import 'package:sikshana/app/modules/lesson_plan_generated_view/models/view_lesson_plan_model.dart';
import 'package:sikshana/app/modules/lesson_resource_generated_view/models/view_resource_plan_model.dart'
    as viewResource;

import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/modules/question_paper/controllers/question_paper_controller.dart';
import 'package:sikshana/app/modules/question_paper/models/question_bank_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// A utility class for generating PDF documents for question papers and blueprints.
class PdfGenerator {
  // ---------------------
  // A4 PDF STYLE CONSTANTS
  // ---------------------
  static const double kTitleFont = 18;
  static const double kHeaderFont = 16;
  static const double kSubHeaderFont = 14;
  static const double kBodyFont = 12;
  static const double kOptionFont = 11;

  static const double kHeaderSpacing = 16;
  static const double kLineSpacing = 12;
  static const double kSectionSpacing = 16;
  static const double kQuestionSpacing = 12;
  static const double kOptionIndent = 16;

  static const pw.EdgeInsets kTablePadding = pw.EdgeInsets.symmetric(
    vertical: 4,
    horizontal: 6,
  );

  // ---------------------
  // GENERATE QUESTION PAPER PDF
  // ---------------------
  /// Generates a PDF document for the given question paper data.
  ///
  /// Parameters:
  /// - `data`: The [QuestionBankModel] containing the question paper data.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the PDF is generated and saved.
  static Future<void> generateQuestionPaperPdf(
    QuestionBankModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No data available to generate PDF.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      final pw.Document pdf = pw.Document();
      final ByteData fontData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final pw.Font ttf = pw.Font.ttf(fontData);
      final QuestionBank? questionBank = data.data?.questionBank;
      final Metadata? metadata = questionBank?.metadata;
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            final List<pw.Widget> content = <pw.Widget>[]
              // --------------------- HEADER ---------------------
              ..add(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    // School Name
                    if (metadata?.schoolName?.isNotEmpty ?? false)
                      pw.Align(
                        alignment: pw.Alignment.topCenter,
                        child: pw.Text(
                          metadata!.schoolName!,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: kTitleFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    if (metadata?.schoolName?.isNotEmpty ?? false)
                      pw.SizedBox(height: kHeaderSpacing),
                    // Exam Name
                    if (data.data?.examinationName?.isNotEmpty ?? false)
                      pw.Align(
                        alignment: pw.Alignment.topCenter,
                        child: pw.Text(
                          data.data!.examinationName!,
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: kHeaderFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    if (data.data?.examinationName?.isNotEmpty ?? false)
                      pw.SizedBox(height: kHeaderSpacing),
                    // Subject, Class, Marks
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Text(
                          'Subject : ${data.data?.subject ?? ''}',
                          style: pw.TextStyle(font: ttf, fontSize: kBodyFont),
                        ),
                        pw.Text(
                          'Class : ${data.data?.grade ?? ''}',
                          style: pw.TextStyle(font: ttf, fontSize: kBodyFont),
                        ),
                        pw.Text(
                          'Marks : ${data.data?.totalMarks ?? ''}',
                          style: pw.TextStyle(font: ttf, fontSize: kBodyFont),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: kLineSpacing),
                    pw.Divider(color: PdfColors.grey400),
                    pw.SizedBox(height: kHeaderSpacing),
                  ],
                ),
              );
            // --------------------- QUESTIONS ---------------------
            if (questionBank?.questions != null &&
                questionBank!.questions!.isNotEmpty) {
              for (
                int sectionIndex = 0;
                sectionIndex < questionBank.questions!.length;
                sectionIndex++
              ) {
                final BluePrintTemplate section =
                    questionBank.questions![sectionIndex];
                // Section Header
                content
                  ..add(
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: <pw.Widget>[
                        pw.Text(
                          '${_toRoman(sectionIndex + 1)}. ',
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: kSubHeaderFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            '${section.type ?? ''}',
                            style: pw.TextStyle(
                              font: ttf,
                              fontSize: kSubHeaderFont,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(width: kLineSpacing),
                        pw.Text(
                          '${section.numberOfQuestions ?? 0} × ${section.marksPerQuestion ?? 0} = ${(section.numberOfQuestions ?? 0) * (section.marksPerQuestion ?? 0)}',
                          style: pw.TextStyle(font: ttf, fontSize: kBodyFont),
                        ),
                      ],
                    ),
                  )
                  ..add(pw.SizedBox(height: kSectionSpacing));
                // Questions inside section
                if (section.questions != null &&
                    section.questions!.isNotEmpty) {
                  for (
                    int qIndex = 0;
                    qIndex < section.questions!.length;
                    qIndex++
                  ) {
                    final Question question = section.questions![qIndex];
                    // Hanging indent format
                    content.add(
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // fixed width number box so multi-line question text aligns correctly
                            pw.Container(
                              alignment: pw.Alignment.topLeft,
                              child: pw.Text(
                                '${qIndex + 1}.',
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: kBodyFont,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.SizedBox(width: 6),
                            // Expanded ensures the text wraps and lines align under the question text
                            pw.Expanded(
                              child: pw.Text(
                                question.question ?? '',
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontSize: kBodyFont,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    // MCQ Options
                    if (question.options != null &&
                        question.options!.isNotEmpty) {
                      for (int opt = 0; opt < question.options!.length; opt++) {
                        content.add(
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              left: kOptionIndent,
                              top: 4,
                            ),
                            child: pw.Text(
                              '${String.fromCharCode(65 + opt)}. ${question.options![opt]}',
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: kOptionFont,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    content.add(pw.SizedBox(height: kQuestionSpacing));
                  }
                }
              }
            }
            return content;
          },
        ),
      );
      await _savePdf('question_paper', pdf, saveToDevice: saveToDevice);
    } catch (e) {
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  // ---------------------
  // GENERATE BLUEPRINT PDF
  // ---------------------
  /// Generates a PDF document for the given question paper blueprint data.
  ///
  /// Parameters:
  /// - `data`: The [QuestionBankModel] containing the blueprint data.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the PDF is generated and saved.
  static Future<void> generateBlueprintPdf(
    QuestionBankModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No data available to generate PDF.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      final pw.Document pdf = pw.Document();
      final ByteData fontData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final pw.Font ttf = pw.Font.ttf(fontData);
      final QuestionBank? questionBank = data.data?.questionBank;
      final Metadata? metadata = questionBank?.metadata;
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => <pw.Widget>[
            // ---------------- HEADER TABLE ----------------
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: const <int, pw.TableColumnWidth>{
                0: pw.FlexColumnWidth(),
                1: pw.FlexColumnWidth(2),
              },
              children: <pw.TableRow>[
                _headerRow('School Name:', metadata?.schoolName ?? '', ttf),
                _headerRow(
                  'Medium:',
                  data.data?.medium?.capitalizeFirst ?? '',
                  ttf,
                ),
                _headerRow('Class:', data.data?.grade?.toString() ?? '', ttf),
                _headerRow('Subject:', data.data?.subject ?? '', ttf),
                _headerRow(
                  'Examination Name:',
                  data.data?.examinationName?.capitalizeFirst ?? '',
                  ttf,
                ),
                _headerRow(
                  'Total Marks:',
                  data.data?.totalMarks?.toString() ?? '',
                  ttf,
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            // ---------------- BLUEPRINT TABLE ----------------
            _buildBlueprintContent(data, ttf),
          ],
        ),
      );
      await _savePdf('blueprint', pdf, saveToDevice: saveToDevice);
    } catch (e) {
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  // ---------------------
  // HEADER ROW BUILDER
  // ---------------------
  /// Builds a table row for the header section of the PDF.
  ///
  /// Parameters:
  /// - `key`: The key/label for the row.
  /// - `value`: The corresponding value for the key.
  /// - `ttf`: The TrueType Font to use for styling.
  ///
  /// Returns:
  /// A `pw.TableRow` widget.
  static pw.TableRow _headerRow(String key, String value, pw.Font ttf) =>
      pw.TableRow(
        children: <pw.Widget>[
          pw.Padding(
            padding: kTablePadding,
            child: pw.Text(
              key,
              style: pw.TextStyle(
                font: ttf,
                fontSize: kBodyFont,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Padding(
            padding: kTablePadding,
            child: pw.Text(
              value,
              style: pw.TextStyle(font: ttf, fontSize: kBodyFont),
            ),
          ),
        ],
      );

  // ---------------------
  // ROMAN NUMBER CONVERTER
  // ---------------------
  /// Converts an integer to its Roman numeral representation.
  ///
  /// Parameters:
  /// - `number`: The integer to convert (must be between 1 and 3999).
  ///
  /// Returns:
  /// A `String` representing the Roman numeral.
  ///
  /// Throws:
  /// `ArgumentError` if the number is out of the valid range.
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

  // ---------------------
  // BLUEPRINT CONTENT TABLE
  // ---------------------
  /// Builds the content table for the blueprint PDF.
  ///
  /// Parameters:
  /// - `data`: The [QuestionBankModel] containing the blueprint data.
  /// - `ttf`: The TrueType Font to use for styling.
  ///
  /// Returns:
  /// A `pw.Widget` representing the blueprint table.
  static pw.Widget _buildBlueprintContent(QuestionBankModel data, pw.Font ttf) {
    final List<pw.TableRow> rows = <pw.TableRow>[];
    if (data.data?.bluePrintTemplate != null) {
      for (final BluePrintTemplate template in data.data!.bluePrintTemplate!) {
        if (template.questionDistribution != null) {
          for (final dist in template.questionDistribution!) {
            rows.add(
              pw.TableRow(
                children: <pw.Widget>[
                  pw.Padding(
                    padding: kTablePadding,
                    child: pw.Text(
                      dist.unitName ?? '',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: ttf, fontSize: kOptionFont),
                    ),
                  ),
                  pw.Padding(
                    padding: kTablePadding,
                    child: pw.Text(
                      questionTypes.keys.toList().firstWhereOrNull(
                            (String element) =>
                                questionTypes[element] == template.type,
                          ) ??
                          template.type ??
                          '',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: ttf, fontSize: kOptionFont),
                    ),
                  ),
                  pw.Padding(
                    padding: kTablePadding,
                    child: pw.Text(
                      dist.objective ?? '',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: ttf, fontSize: kOptionFont),
                    ),
                  ),
                  pw.Padding(
                    padding: kTablePadding,
                    child: pw.Text(
                      template.marksPerQuestion.toString(),
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: ttf, fontSize: kOptionFont),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      }
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: <pw.TableRow>[
        pw.TableRow(
          children: <pw.Widget>[
            _tableHeaderCell('Topic', ttf),
            _tableHeaderCell('Question Type', ttf),
            _tableHeaderCell('Objectives', ttf),
            _tableHeaderCell('Marks', ttf),
          ],
        ),
        ...rows,
      ],
    );
  }

  /// Builds a header cell for a table in the PDF.
  ///
  /// Parameters:
  /// - `title`: The title text for the cell.
  /// - `ttf`: The TrueType Font to use for styling.
  ///
  /// Returns:
  /// A `pw.Widget` representing the table header cell.
  static pw.Widget _tableHeaderCell(String title, pw.Font ttf) => pw.Padding(
    padding: kTablePadding,
    child: pw.Text(
      title,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        font: ttf,
        fontSize: kSubHeaderFont,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  // ---------------------
  // SAVE + SHARE PDF
  // ---------------------
  /// Saves the generated PDF to a file and provides a sharing option.
  ///
  /// Parameters:
  /// - `fileName`: The name of the file to save the PDF as (without extension).
  /// - `pdf`: The `pw.Document` instance to save.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the PDF is saved and shared.
  static Future<void> _savePdf(
    String fileName,
    pw.Document pdf, {
    bool saveToDevice = false,
  }) async {
    try {
      final bytes = await pdf.save();

      if (saveToDevice) {
        Directory dir;

        if (Platform.isAndroid) {
          var status = await Permission.manageExternalStorage.status;
          if (!status.isGranted) {
            status = await Permission.manageExternalStorage.request();
            if (!status.isGranted) {
              // Fallback to app-specific dir or prompt settings
              if (status.isPermanentlyDenied) {
                await openAppSettings();
              }
              dir =
                  await getExternalStorageDirectory() ??
                  await getApplicationDocumentsDirectory();
            } else {
              // Permission granted: use public Downloads
              dir = Directory('/storage/emulated/0/Download');
              if (!dir.existsSync()) dir.createSync(recursive: true);
            }
          } else {
            dir = Directory('/storage/emulated/0/Download');
          }
        } else if (Platform.isIOS) {
          // On iOS, save to app documents directory (sandboxed)
          dir = await getApplicationDocumentsDirectory();
        } else {
          // Fallback for other platforms or web
          dir = await getApplicationDocumentsDirectory();
        }

        final File file = File('${dir.path}/$fileName.pdf');
        await file.writeAsBytes(bytes);

        final String filePath = file.path;

        _showPdfSavedSnackbar(
          filePath: filePath,
          onOpenFolder: () async {
            try {
              // Add open_file_manager: ^2.0.1 to pubspec.yaml
              await OpenFileManager.openFileManager(
                androidConfig: OpenFileManager.AndroidConfig(),
              );
            } catch (e) {
              logD('Failed to open folder: $e');
              // Fallback snackbar
              appSnackBar(
                message: 'Could not open Downloads',
                state: SnackBarState.danger,
              );
            }
          },
        );
      } else {
        // Share PDF (works for Android/iOS)
        //await Printing.sharePdf(bytes: bytes, filename: '$fileName.pdf');
        // Share PDF (works for Android/iOS) with proper MIME filtering
        final Directory tempDir = await getTemporaryDirectory();
        final File file = File('${tempDir.path}/$fileName.pdf');

        // Write PDF bytes to temp file
        await file.writeAsBytes(bytes);

        // Share using MIME-aware API (filters irrelevant apps)
        await Share.shareXFiles([
          XFile(file.path, mimeType: 'application/pdf', name: '$fileName.pdf'),
        ], subject: 'Lesson Plan PDF');
      }
    } catch (e) {
      logD('Saving Error is $e');
      appSnackBar(
        message: 'Error saving/sharing PDF: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static void _showPdfSavedSnackbar({
    required String filePath,
    required VoidCallback onOpenFolder,
  }) {
    Get.rawSnackbar(
      borderColor: Colors
          .green
          .shade300, // Success border (match your _topSnackBarBorderColor)
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
                    'PDF saved successfully!',
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
      backgroundColor: Colors.green.shade50, // Light success bg (customize)
      borderRadius: 12.r,
      duration: const Duration(seconds: 30), // ✅ 30 seconds
      snackPosition: SnackPosition.TOP,
    );
  }

  static pw.Widget _cellHeader(String text, pw.Font ttf) => pw.Padding(
    padding: kTablePadding,
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        font: ttf,
        fontSize: kBodyFont,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );

  static pw.Widget _cellBody(String text, pw.Font ttf) => pw.Padding(
    padding: kTablePadding,
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(font: ttf, fontSize: kBodyFont),
    ),
  );

  // ---------------------
  // Generate PDF 5E Table
  // ---------------------
  static Future<void> generate5ETable(
    Map<String, dynamic>? checklist,
    User? user,
    ViewLessonPlanModel? data, {
    bool saveToDevice = false,
  }) async {
    if (checklist == null) {
      appSnackBar(
        message: 'Error: No data available to generate PDF.',
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

      // ===== LOAD ALL THREE FONTS =====
      final ByteData latoData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      final pw.Font lato = pw.Font.ttf(latoData);
      final pw.Font kannadaFont = pw.Font.ttf(kannadaData);
      final pw.Font teluguFont = pw.Font.ttf(teluguData);

      // ===== FONT SELECTION FUNCTION =====
      pw.Font selectFont(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) {
          return kannadaFont;
        }
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
          return teluguFont;
        }
        return lato;
      }

      final pw.Document pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            final List<pw.Widget> content = <pw.Widget>[];

            // -------- TOP HEADER TABLE --------
            content.add(
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                columnWidths: const <int, pw.TableColumnWidth>{
                  0: pw.FlexColumnWidth(),
                  1: pw.FlexColumnWidth(),
                  2: pw.FlexColumnWidth(0.7),
                  3: pw.FlexColumnWidth(1.2),
                  4: pw.FlexColumnWidth(2.2),
                  5: pw.FlexColumnWidth(1.6),
                  6: pw.FlexColumnWidth(2.2),
                  7: pw.FlexColumnWidth(1.6),
                  8: pw.FlexColumnWidth(1.6),
                },
                children: <pw.TableRow>[
                  pw.TableRow(
                    children: <pw.Widget>[
                      _cellHeader('Board', lato),
                      _cellHeader('Medium', lato),
                      _cellHeader('Class', lato),
                      _cellHeader('Subject', lato),
                      _cellHeader('Chapter', lato),
                      _cellHeader('Sub-Topic', lato),
                      _cellHeader('School Name', lato),
                      _cellHeader('Teacher Name', lato),
                      _cellHeader('Report Generated Date', lato),
                    ],
                  ),
                  pw.TableRow(
                    children: <pw.Widget>[
                      _cellBody(board, selectFont(board)),
                      _cellBody(
                        medium.capitalizeFirst ?? medium,
                        selectFont(medium),
                      ),
                      _cellBody(klass, lato),
                      _cellBody(subject, selectFont(subject)),
                      _cellBody(chapterTitle, selectFont(chapterTitle)),
                      _cellBody(subTopic, selectFont(subTopic)),
                      _cellBody(schoolName, selectFont(schoolName)),
                      _cellBody(teacherName, selectFont(teacherName)),
                      _cellBody(reportDate, lato),
                    ],
                  ),
                ],
              ),
            );

            content.add(pw.SizedBox(height: kHeaderSpacing));

            // -------- LEARNING OUTCOMES --------
            if (learningOutcomes.isNotEmpty) {
              content.add(
                pw.Text(
                  'Learning Outcomes',
                  style: pw.TextStyle(
                    font: lato,
                    fontSize: kHeaderFont,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              );
              content.add(pw.SizedBox(height: 8));

              content.add(
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: learningOutcomes
                      .map(
                        (o) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 4),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: <pw.Widget>[
                              pw.Text(
                                '• ',
                                style: pw.TextStyle(
                                  font: lato,
                                  fontSize: kBodyFont,
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Text(
                                  o,
                                  style: pw.TextStyle(
                                    font: selectFont(o),
                                    fontSize: kBodyFont,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              );

              content.add(pw.SizedBox(height: kSectionSpacing));
            }

            // -------- 5E CHECKLIST TABLE --------
            content.add(
              pw.Text(
                '5E Lesson Plan Summary',
                style: pw.TextStyle(
                  font: lato,
                  fontSize: kHeaderFont,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            );
            content.add(pw.SizedBox(height: 8));

            final List<String> phaseKeys = checklist!.keys.toList();

            content.add(
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                columnWidths: const <int, pw.TableColumnWidth>{
                  0: pw.IntrinsicColumnWidth(),
                  1: pw.FixedColumnWidth(220),
                  2: pw.FixedColumnWidth(160),
                  3: pw.FixedColumnWidth(130),
                },
                children: <pw.TableRow>[
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: <pw.Widget>[
                      pw.Padding(
                        padding: kTablePadding,
                        child: pw.Text(
                          'PHASE',
                          style: pw.TextStyle(
                            font: lato,
                            fontSize: kBodyFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: kTablePadding,
                        child: pw.Text(
                          'CLASSROOM PROCESS',
                          style: pw.TextStyle(
                            font: lato,
                            fontSize: kBodyFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: kTablePadding,
                        child: pw.Text(
                          'TLM',
                          style: pw.TextStyle(
                            font: lato,
                            fontSize: kBodyFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: kTablePadding,
                        child: pw.Text(
                          'CCE TOOLS & TECHNIQUES',
                          style: pw.TextStyle(
                            font: lato,
                            fontSize: kBodyFont,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ...phaseKeys.where((k) => checklist[k] != null).map((
                    String phase,
                  ) {
                    final Map<String, dynamic> entry =
                        checklist[phase] as Map<String, dynamic>? ??
                        <String, dynamic>{};
                    final String activity = entry['activity'] ?? '';
                    final String materials = entry['materials'] ?? '';
                    const String cce = 'Observation.';

                    return pw.TableRow(
                      children: <pw.Widget>[
                        pw.Padding(
                          padding: kTablePadding,
                          child: pw.Text(
                            phase.toUpperCase(),
                            style: pw.TextStyle(
                              font: lato,
                              fontSize: kBodyFont,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: kTablePadding,
                          child: pw.Text(
                            activity,
                            style: pw.TextStyle(
                              font: selectFont(activity),
                              fontSize: kBodyFont,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: kTablePadding,
                          child: pw.Text(
                            materials,
                            style: pw.TextStyle(
                              font: selectFont(materials),
                              fontSize: kBodyFont,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: kTablePadding,
                          child: pw.Text(
                            cce,
                            style: pw.TextStyle(
                              font: lato,
                              fontSize: kBodyFont,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );

            return content;
          },
        ),
      );

      final String fileName =
          '${subject.replaceAll(' ', '-')}_${chapterTitle.replaceAll(' ', '-')}_checklist';

      await _savePdf(fileName, pdf, saveToDevice: saveToDevice);
    } catch (e) {
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  // ---------------------
  // Generate Lesson Plan PDF (header + learning outcomes)
  // ---------------------
  static Future<void> generateLessonPlanPdf(
    User? user,
    ViewLessonPlanModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No lesson data available to generate PDF.',
        state: SnackBarState.danger,
      );
      return;
    }

    try {
      // ===== LOAD ALL THREE FONTS ONCE =====
      final ByteData latoData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      final pw.Font lato = pw.Font.ttf(latoData);

      final pw.Font kannadaFont = pw.Font.ttf(kannadaData);

      final pw.Font teluguFont = pw.Font.ttf(
        teluguData,
      ); // ✅ Better Indic support

      // ===== FONT SELECTION FUNCTION =====
      pw.Font selectFont(String text) {
        print('🔤 Font detection for: "$text"'); // Debug input

        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) {
          print('✅ SELECTED: Kannada font (U+0C80–U+0CFF)');
          return kannadaFont;
        }
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
          print('✅ SELECTED: Telugu font (U+0C00–U+0C7F)');
          return teluguFont;
        }
        print('✅ SELECTED: Lato (Latin/English)');
        return lato;
      }

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
      List<Map<String, dynamic>> sections = [];
      sections =
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

      final pw.Document pdf = pw.Document();

      // ===== HELPER: Clean Markdown/Special Characters =====
      String cleanContent(String input) {
        // Remove ** (bold markers)
        var cleaned = input.replaceAll('**', '');

        // Remove # at line start (heading markers)
        cleaned = cleaned.replaceAllMapped(
          RegExp(r'^#+\s*', multiLine: true),
          (_) => '',
        );

        // Remove leading/trailing whitespace from each line
        cleaned = cleaned.split('\n').map((line) => line.trim()).join('\n');

        // Collapse multiple blank lines to single blank line
        cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');

        return cleaned.trim();
      }

      // ===== HEADER WIDGET (reusable with language-aware fonts) =====
      pw.Widget headerWidget() => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text('Board', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text('Class', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text('Chapter', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.SizedBox(height: 4),
              pw.Text(
                board,
                style: pw.TextStyle(
                  font: selectFont(board),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                klass,
                style: pw.TextStyle(
                  font: lato,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                chapterTitle,
                style: pw.TextStyle(
                  font: selectFont(chapterTitle),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('Medium', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text('Subject', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text(
                'Sub-Topic',
                style: pw.TextStyle(font: lato, fontSize: 16),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                medium.capitalizeFirst ?? medium,
                style: pw.TextStyle(
                  font: selectFont(medium),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                subject,
                style: pw.TextStyle(
                  font: selectFont(subject),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                subTopic,
                style: pw.TextStyle(
                  font: selectFont(subTopic),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );

      // ===== PAGE 1: Learning Outcomes =====
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => [
            headerWidget(),
            pw.SizedBox(height: 24),
            pw.Text(
              'LEARNING OUTCOMES',
              style: pw.TextStyle(
                font: lato,
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue600,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: learningOutcomes.map((o) {
                final cleanedOutcome = cleanContent(o);
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: <pw.Widget>[
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2, right: 6),
                        child: pw.Text(
                          '•',
                          style: pw.TextStyle(font: lato, fontSize: 14),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          cleanedOutcome,
                          style: pw.TextStyle(
                            font: selectFont(cleanedOutcome),
                            fontSize: 14,
                          ),
                          maxLines: 0,
                          textAlign: pw.TextAlign.left,
                          textDirection: pw
                              .TextDirection
                              .ltr, // Force LTR for mixed scripts
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );

      // ===== SECTION PAGES: Dynamic (like LessonPlanSectionTabs) =====
      final List<Map<String, dynamic>> plainTextSections = sections
          .where((s) => s['outputFormat'] == 'plain_text')
          .toList();

      for (final sec in plainTextSections) {
        final String content = sec['content'] as String? ?? '';
        if (content.isEmpty) continue;

        logD(
          "Generating now is ${sec['title']} - content length ${content.length}",
        );

        final String cleanedContent = cleanContent(content);
        final String sectionTitle = (sec['title'] as String? ?? '')
            .toUpperCase();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) => [
              headerWidget(),
              pw.SizedBox(height: 24),
              pw.Text(
                sectionTitle,
                style: pw.TextStyle(
                  font: selectFont(sectionTitle),
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Paragraph(
                text: cleanedContent,
                style: pw.TextStyle(
                  font: selectFont(cleanedContent),
                  fontSize: 14,
                  lineSpacing: 1.5,
                ),
              ),
            ],
          ),
        );
      }

      final String fileName =
          '${subject.replaceAll(' ', '-')}_${chapterTitle.replaceAll(' ', '-')}_LessonPlan';

      await _savePdf(fileName, pdf, saveToDevice: saveToDevice);
    } catch (e) {
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static Future<void> generateLessonResourcePdf(
    User? user,
    viewResource.ViewResourcePlanModel? data, {
    bool saveToDevice = false,
  }) async {
    if (data == null) {
      appSnackBar(
        message: 'Error: No resource data available to generate PDF.',
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

      // ===== LOAD ALL THREE FONTS =====
      final ByteData latoData = await rootBundle.load(
        'assets/fonts/Lato-Regular.ttf',
      );
      final ByteData kannadaData = await rootBundle.load(
        'assets/fonts/NotoSansKannada-Regular.ttf',
      );
      final ByteData teluguData = await rootBundle.load(
        'assets/fonts/NotoSansTelugu-Regular.ttf',
      );

      final pw.Font lato = pw.Font.ttf(latoData);
      final pw.Font kannadaFont = pw.Font.ttf(kannadaData);
      final pw.Font teluguFont = pw.Font.ttf(teluguData);

      // ===== FONT SELECTION FUNCTION =====
      pw.Font selectFont(String text) {
        if (RegExp(r'[\u0C80-\u0CFF]').hasMatch(text)) {
          return kannadaFont;
        }
        if (RegExp(r'[\u0C00-\u0C7F]').hasMatch(text)) {
          return teluguFont;
        }
        return lato;
      }

      final pw.Document pdf = pw.Document();

      // ----- reusable header -----
      pw.Widget headerWidget() => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text('Board', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text('Class', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text('Chapter', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.SizedBox(height: 4),
              pw.Text(
                board,
                style: pw.TextStyle(
                  font: selectFont(board),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                klass,
                style: pw.TextStyle(
                  font: lato,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                chapterTitle,
                style: pw.TextStyle(
                  font: selectFont(chapterTitle),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: <pw.Widget>[
              pw.Text('Medium', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text('Subject', style: pw.TextStyle(font: lato, fontSize: 16)),
              pw.Text(
                'Sub-Topic',
                style: pw.TextStyle(font: lato, fontSize: 16),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                medium.capitalizeFirst ?? medium,
                style: pw.TextStyle(
                  font: selectFont(medium),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                subject,
                style: pw.TextStyle(
                  font: selectFont(subject),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                subTopic,
                style: pw.TextStyle(
                  font: selectFont(subTopic),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );

      // ----- PAGE 1: Learning Outcomes -----
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => <pw.Widget>[
            headerWidget(),
            pw.SizedBox(height: 24),
            pw.Text(
              'LEARNING OUTCOMES',
              style: pw.TextStyle(
                font: lato,
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue600,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: learningOutcomes
                  .map(
                    (o) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2, right: 6),
                            child: pw.Text(
                              '•',
                              style: pw.TextStyle(font: lato, fontSize: 14),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              o,
                              style: pw.TextStyle(
                                font: selectFont(o),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );

      // ----- RESOURCE SECTIONS (json_1, json_2, json_3) -----
      for (final viewResource.ResourceElement res in resources) {
        switch (res.outputFormat) {
          case 'json_1':
            pdf.addPage(
              _buildQuestionBankSection(res, lato, selectFont, headerWidget),
            );
            break;
          case 'json_2':
            pdf.addPage(
              _buildRealWorldSection(res, lato, selectFont, headerWidget),
            );
            break;
          case 'json_3':
            pdf.addPage(
              _buildActivitiesSection(res, lato, selectFont, headerWidget),
            );
            break;
          default:
            break;
        }
      }

      final String fileName =
          '${subject.replaceAll(' ', '-')}_${chapterTitle.replaceAll(' ', '-')}_LessonResource';

      await _savePdf(fileName, pdf, saveToDevice: saveToDevice);
    } catch (e) {
      appSnackBar(
        message: 'An unexpected error occurred: $e',
        state: SnackBarState.danger,
      );
    }
  }

  static pw.MultiPage _buildQuestionBankSection(
    viewResource.ResourceElement resource,
    pw.Font lato,
    pw.Font Function(String) selectFont,
    pw.Widget Function() headerWidget,
  ) {
    const Map<String, String> difficultyLabels = {
      'beginner': 'BEGINNER',
      'intermediate': 'INTERMEDIATE',
      'advanced': 'ADVANCED',
    };

    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        final widgets = <pw.Widget>[];

        widgets.add(headerWidget());
        widgets.add(pw.SizedBox(height: 24));

        widgets.add(
          pw.Text(
            'QUESTION BANK',
            style: pw.TextStyle(
              font: lato,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue600,
            ),
          ),
        );
        if (resource.title.isNotEmpty) {
          widgets.add(pw.SizedBox(height: 8));
          widgets.add(
            pw.Text(
              resource.title,
              style: pw.TextStyle(
                font: selectFont(resource.title),
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
        }
        widgets.add(pw.SizedBox(height: 16));

        for (final viewResource.ResourceContent diffBlock in resource.content) {
          final String diffKey = diffBlock.difficulty ?? '';
          final String diffLabel =
              difficultyLabels[diffKey.toLowerCase()] ?? diffKey.toUpperCase();

          widgets.add(
            pw.Text(
              diffLabel,
              style: pw.TextStyle(
                font: lato,
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue600,
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 8));

          final List<viewResource.ContentContent> contents =
              diffBlock.content ?? <viewResource.ContentContent>[];

          // MCQs ✅ Already has selectFont
          final viewResource.ContentContent? mcqContent = contents.firstWhere(
            (c) => c.type == 'MCQs',
            orElse: () => viewResource.ContentContent(),
          );
          final List<viewResource.Question> mcqQuestions =
              mcqContent?.questions ?? <viewResource.Question>[];

          if (mcqQuestions.isNotEmpty) {
            widgets.add(
              pw.Text(
                'MCQS',
                style: pw.TextStyle(
                  font: lato,
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600,
                ),
              ),
            );
            widgets.add(pw.SizedBox(height: 6));

            int qNo = 1;
            for (final viewResource.Question q in mcqQuestions) {
              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '$qNo. ${q.question}',
                        style: pw.TextStyle(
                          font: selectFont(q.question),
                          fontSize: 12,
                        ),
                      ),
                      if (q.options != null && q.options!.isNotEmpty)
                        ...q.options!.map(
                          (opt) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 16, top: 2),
                            child: pw.Text(
                              '• $opt',
                              style: pw.TextStyle(
                                font: selectFont(opt),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
              qNo++;
            }
            widgets.add(pw.SizedBox(height: 12));
          }

          // Assessment ✅ Already has selectFont
          final viewResource.ContentContent? assessmentContent = contents
              .firstWhere(
                (c) => c.type == 'assessment',
                orElse: () => viewResource.ContentContent(),
              );
          final List<viewResource.Question> assessmentQuestions =
              assessmentContent?.questions ?? <viewResource.Question>[];

          if (assessmentQuestions.isNotEmpty) {
            widgets.add(
              pw.Text(
                'ASSESSMENT',
                style: pw.TextStyle(
                  font: lato,
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue600,
                ),
              ),
            );
            widgets.add(pw.SizedBox(height: 6));

            int aNo = 1;
            for (final viewResource.Question q in assessmentQuestions) {
              widgets.add(
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6, left: 8),
                  child: pw.Text(
                    '$aNo. ${q.question}',
                    style: pw.TextStyle(
                      font: selectFont(q.question),
                      fontSize: 13,
                    ),
                  ),
                ),
              );
              aNo++;
            }
            widgets.add(pw.SizedBox(height: 16));
          }

          widgets.add(pw.SizedBox(height: 16));
        }

        return widgets;
      },
    );
  }

  static pw.MultiPage _buildRealWorldSection(
    viewResource.ResourceElement resource,
    pw.Font lato,
    pw.Font Function(String) selectFont,
    pw.Widget Function() headerWidget,
  ) {
    const Map<String, String> difficultyLabels = {
      'beginner': 'BEGINNER',
      'intermediate': 'INTERMEDIATE',
      'advanced': 'ADVANCED',
    };

    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        final widgets = <pw.Widget>[];

        widgets.add(headerWidget());
        widgets.add(pw.SizedBox(height: 24));

        widgets.add(
          pw.Text(
            'REAL WORLD SCENARIOS',
            style: pw.TextStyle(
              font: lato,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue600,
            ),
          ),
        );
        widgets.add(pw.SizedBox(height: 12));

        for (final viewResource.ResourceContent diffBlock in resource.content) {
          final String diffKey = diffBlock.difficulty ?? '';
          final String diffLabel =
              difficultyLabels[diffKey.toLowerCase()] ?? diffKey.toUpperCase();

          widgets.add(
            pw.Text(
              diffLabel,
              style: pw.TextStyle(
                font: lato,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 6));

          final List<viewResource.ContentContent> scenarios =
              diffBlock.content ?? <viewResource.ContentContent>[];

          if (scenarios.isEmpty) {
            widgets.add(
              pw.Text(
                'No data available',
                style: pw.TextStyle(font: lato, fontSize: 12),
              ),
            );
            widgets.add(pw.SizedBox(height: 10));
            continue;
          }

          for (final viewResource.ContentContent scenario in scenarios) {
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 9),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if ((scenario.title ?? '').isNotEmpty)
                      pw.Text(
                        scenario.title ?? '',
                        style: pw.TextStyle(
                          font: selectFont(scenario.title ?? ''),
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if ((scenario.question ?? '').isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        scenario.question ?? '',
                        style: pw.TextStyle(
                          font: selectFont(scenario.question ?? ''),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if ((scenario.description ?? '').isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Paragraph(
                        text: scenario.description ?? '',
                        style: pw.TextStyle(
                          font: selectFont(scenario.description ?? ''),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          widgets.add(pw.SizedBox(height: 12));
        }

        return widgets;
      },
    );
  }

  static pw.MultiPage _buildActivitiesSection(
    viewResource.ResourceElement resource,
    pw.Font lato,
    pw.Font Function(String) selectFont,
    pw.Widget Function() headerWidget,
  ) {
    const Map<String, String> difficultyLabels = {
      'beginner': 'BEGINNER',
      'intermediate': 'INTERMEDIATE',
      'advanced': 'ADVANCED',
    };

    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        final widgets = <pw.Widget>[];

        widgets.add(headerWidget());
        widgets.add(pw.SizedBox(height: 24));

        widgets.add(
          pw.Text(
            'ACTIVITIES',
            style: pw.TextStyle(
              font: lato,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue600,
            ),
          ),
        );
        widgets.add(pw.SizedBox(height: 12));

        for (final viewResource.ResourceContent diffBlock in resource.content) {
          final String diffKey = diffBlock.difficulty ?? '';
          final String diffLabel =
              difficultyLabels[diffKey.toLowerCase()] ?? diffKey.toUpperCase();

          widgets.add(
            pw.Text(
              diffLabel,
              style: pw.TextStyle(
                font: lato,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          );
          widgets.add(pw.SizedBox(height: 6));

          final List<viewResource.ContentContent> acts =
              diffBlock.content ?? <viewResource.ContentContent>[];

          if (acts.isEmpty && diffBlock.title == null) {
            widgets.add(
              pw.Text(
                'No data available',
                style: pw.TextStyle(font: lato, fontSize: 12),
              ),
            );
            widgets.add(pw.SizedBox(height: 10));
            continue;
          }

          // Activity details directly on ResourceContent ✅ All with selectFont
          if ((diffBlock.title ?? '').isNotEmpty ||
              (diffBlock.preparation ?? '').isNotEmpty ||
              (diffBlock.requiredMaterials ?? '').isNotEmpty ||
              (diffBlock.obtainingMaterials ?? '').isNotEmpty ||
              (diffBlock.recap ?? '').isNotEmpty) {
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if ((diffBlock.title ?? '').isNotEmpty)
                      pw.Text(
                        diffBlock.title ?? '',
                        style: pw.TextStyle(
                          font: selectFont(diffBlock.title ?? ''),
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    if ((diffBlock.preparation ?? '').isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Preparation:',
                        style: pw.TextStyle(
                          font: lato,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Paragraph(
                        text: diffBlock.preparation ?? '',
                        style: pw.TextStyle(
                          font: selectFont(diffBlock.preparation ?? ''),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if ((diffBlock.requiredMaterials ?? '').isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Required Materials:',
                        style: pw.TextStyle(
                          font: lato,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Paragraph(
                        text: diffBlock.requiredMaterials ?? '',
                        style: pw.TextStyle(
                          font: selectFont(diffBlock.requiredMaterials ?? ''),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if ((diffBlock.obtainingMaterials ?? '').isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Obtaining Materials:',
                        style: pw.TextStyle(
                          font: lato,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Paragraph(
                        text: diffBlock.obtainingMaterials ?? '',
                        style: pw.TextStyle(
                          font: selectFont(diffBlock.obtainingMaterials ?? ''),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if ((diffBlock.recap ?? '').isNotEmpty) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Recap:',
                        style: pw.TextStyle(
                          font: lato,
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Paragraph(
                        text: diffBlock.recap ?? '',
                        style: pw.TextStyle(
                          font: selectFont(diffBlock.recap ?? ''),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }

          widgets.add(pw.SizedBox(height: 12));
        }

        return widgets;
      },
    );
  }
}
