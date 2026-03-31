import 'package:shimmer/shimmer.dart';
import 'package:sikshana/app/modules/generation_status/views/widgets/no_items_found.dart';
import 'package:sikshana/app/modules/question_paper_generation/models/question_bank_list_model.dart';
import 'package:sikshana/app/modules/question_paper_generation/views/widgets/generation_filters_widget.dart';
import 'package:sikshana/app/modules/question_paper_generation/views/widgets/question_bank_card.dart';
import 'package:sikshana/app/modules/question_paper_generation/views/widgets/question_paper_generation_card.dart';
import 'package:sikshana/app/utils/exports.dart';

import '../controllers/question_paper_generation_controller.dart';

/// A view for the Question Paper Generation feature.
class QuestionPaperGenerationView
    extends GetView<QuestionPaperGenerationController> {
  /// Constructs a [QuestionPaperGenerationView].
  const QuestionPaperGenerationView({super.key});
  @override
  /// Builds the UI for the question paper generation screen.
  ///
  /// Parameters:
  /// - `context`: The build context.
  ///
  /// Returns:
  /// A `Widget` representing the question paper generation interface.
  Widget build(BuildContext context) {
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>()..onReConnect = controller.onInit;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : Scaffold(
              key: scaffoldKey,
              appBar: CommonAppBar(
                scaffoldKey: scaffoldKey,
                leading: Leading.drawer,
              ),
              drawer: const AppDrawer(
                currentRoute: Routes.QUESTION_PAPER_GENERATION,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  controller.onInit();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        36.verticalSpace,
                        Text(
                          LocaleKeys.questionPapers.tr,
                          style: AppTextStyle.lato(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        30.verticalSpace,
                        const QuestionPaperGenerationCard(),
                        13.verticalSpace,
                        AppButton(
                          buttonText: LocaleKeys.generateQuestionPaper.tr,
                          onPressed: () {
                            Get.toNamed(Routes.QUESTION_PAPER)?.then((
                              dynamic value,
                            ) {
                              controller.onInit();
                            });
                          },
                          borderRadius: BorderRadius.circular(4).r,
                          style: AppTextStyle.lato(color: AppColors.kFFFFFF),
                          icon: SvgPicture.asset(
                            AppImages.editImageWhite, // Your SVG asset path
                            width: 20,
                            height: 20,
                          ),
                          rightIcon: false,
                        ),
                        14.verticalSpace,
                        GenerationFiltersWidget(),
                        14.verticalSpace,
                        Obx(() {
                          if (controller.isLoading.value) {
                            return Shimmer.fromColors(
                              baseColor: AppColors.kE0E0E0,
                              highlightColor: AppColors.kF5F5F5,
                              child: Column(
                                children: List.generate(
                                  3, // Number of shimmer items
                                  (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Container(
                                      height: 200
                                          .h, // Approximate height of a QuestionBankCard
                                      decoration: BoxDecoration(
                                        color: AppColors.kFFFFFF,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final List<ResultQB> results =
                                controller.questionBank.value.data?.results ??
                                      <ResultQB>[]
                                  // Sort safely by createdAt descending (latest first)
                                  ..sort((ResultQB a, ResultQB b) {
                                    final DateTime aDate =
                                        a.createdAt ??
                                        DateTime.fromMillisecondsSinceEpoch(0);
                                    final DateTime bDate =
                                        b.createdAt ??
                                        DateTime.fromMillisecondsSinceEpoch(0);
                                    return bDate.compareTo(
                                      aDate,
                                    ); // latest first
                                  });
                            if (results.isEmpty) {
                              return const NoItemsFoundWidget();
                            }
                            return Column(
                              children: results
                                  .map((ResultQB e) => QuestionBankCard(qb: e))
                                  .toList(),
                            );
                          }
                        }),
                        30.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
