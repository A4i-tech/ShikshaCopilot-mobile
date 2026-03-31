import 'package:sikshana/app/modules/view_question_paper/views/widgets/blueprint_section.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/download_section.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/feedback_section.dart';
import 'package:sikshana/app/modules/view_question_paper/views/widgets/question_section.dart';
import 'package:sikshana/app/utils/exports.dart';
import '../controllers/view_question_paper_controller.dart';

/// A view that displays generated question paper, take feedback, allow download
class ViewQuestionPaperView extends GetView<ViewQuestionPaperController> {
  /// Constructs a [ViewQuestionPaperView].
  const ViewQuestionPaperView({super.key});

  Widget _buildTabContent(Widget child) => RefreshIndicator(
    onRefresh: () async {
      unawaited(controller.getQuestionPaperDetails());
    },
    child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
        child: child,
      ),
    ),
  );
  @override
  /// Builds the UI for the view question paper screen.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the UI.
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()
          ..onReConnect = controller.getQuestionPaperDetails;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : DefaultTabController(
              length: 3,
              child: Scaffold(
                key: scaffoldKey,
                appBar: CommonAppBar(
                  scaffoldKey: scaffoldKey,
                  title: LocaleKeys.questionPaperKey.tr,
                ),
                body: Obx(() {
                  final data = controller.questionBankModel.value?.data;
                  if (data == null) {
                    return Center(child: Text(LocaleKeys.noDataAvailable.tr));
                  }
                  return NestedScrollView(
                    headerSliverBuilder:
                        (
                          BuildContext context,
                          bool innerBoxIsScrolled,
                        ) => <Widget>[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                children: <Widget>[
                                  14.verticalSpace,
                                  const BlueprintSection(),
                                  20.verticalSpace,
                                ],
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: SliverHeaderDelegate(
                              height: 50.h,
                              child: Material(
                                color: context.theme.scaffoldBackgroundColor,
                                child: TabBar(
                                  labelColor: AppColors.k46A0F1,
                                  labelStyle: AppTextStyle.lato(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  dividerColor: AppColors.kEBEBEB,
                                  unselectedLabelColor: AppColors.k666970,
                                  indicator: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.k46A0F1,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  indicatorColor: AppColors.k46A0F1,
                                  tabAlignment: TabAlignment.fill,
                                  tabs: <Widget>[
                                    Tab(text: LocaleKeys.question.tr),
                                    Tab(text: LocaleKeys.feedback.tr),
                                    Tab(text: LocaleKeys.download.tr),
                                  ],
                                ),
                              ),
                            ),
                            pinned: true,
                          ),
                        ],
                    body: TabBarView(
                      children: <Widget>[
                        _buildTabContent(
                          QuestionSection(
                            board: data.questionBank?.metadata?.schoolName,
                            examinationName: data.examinationName,
                            grade: data.grade,
                            subject: data.subject,
                            totalMarks: data.totalMarks,
                            questions: data.questionBank?.questions,
                          ),
                        ),
                        _buildTabContent(const FeedbackSection()),
                        _buildTabContent(const DownloadSection()),
                      ],
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
