import 'dart:io';
import 'package:get/get.dart';
import 'package:sikshana/app/modules/home/models/lesson_plan_model.dart';
import 'package:sikshana/app/modules/home/repository/home_api_repo.dart';
import 'package:sikshana/app/ui/components/app_loader.dart';

/// The controller for the Home screen.
///
/// This controller manages the state and business logic for the home,
/// including user info, loading states, data fetching, calendar state,
/// and chart data.
class HomeController extends GetxController {
  final HomeApiRepo _homeApiRepo = HomeApiRepo();

  // --- User Info ---
  /// The user's profile image file.
  final Rx<File?> profileImage = Rx<File?>(null);

  // --- Loading States ---
  /// Indicates whether lesson plans are currently being loaded.
  final RxBool isLoadingLessonPlans = false.obs;

  // --- Data Holders ---
  /// Holds the fetched lesson plan data.
  final Rx<LessonPlan?> lessonPlan = Rx<LessonPlan?>(null);

  /// The number of lesson plans.
  int get lessonPlanCount =>
      lessonPlan.value?.data
          ?.where((Plan element) => element.isLesson == true)
          .toList()
          .length ??
      0;

  /// The number of lesson resources.
  int get lessonResourceCount =>
      lessonPlan.value?.data
          ?.where((Plan element) => element.isLesson == false)
          .toList()
          .length ??
      0;

  /// The count of resources.
  final RxInt resourcesCount = 0.obs;

  /// The count of plans.
  final RxInt plansCount = 0.obs;

  /// A list of indexes for the chart labels.
  final RxList<int> chartLabelIndexes = <int>[].obs;

  /// A list of strings for the chart timeline.
  final RxList<String> chartTimeline = <String>[].obs;

  /// The index of the selected legend item.
  final Rx<int?> selectedLegendIndex = Rx<int?>(null);

  // --- Recent Lesson Plans State ---
  /// A list of recent lesson plans.
  final RxList<Plan> recentLessonPlans = <Plan>[].obs;

  @override
  void onInit() {
    super.onInit();
    initController();
  }

  /// Initializes the controller by fetching all necessary data.
  Future<void> initController() async {
    Loader.show();
    await Future.wait(<Future<void>>[getLessonPlans()]);
    Loader.dismiss();
  }

  /// Fetches the lesson plans from the repository.
  Future<void> getLessonPlans() async {
    isLoadingLessonPlans(true);
    final LessonPlan? result = await _homeApiRepo.getLessonPlans();
    if (result != null) {
      lessonPlan.value = result;
      _prepareRecentLessonPlans();
    }
    isLoadingLessonPlans(false);
  }

  void _prepareRecentLessonPlans() {
    if (lessonPlan.value?.data == null) {
      return;
    }
    final Plan? lp = lessonPlan.value!.data!.firstWhereOrNull(
      (Plan e) => e.isLesson!,
    );
    final Plan? rp = lessonPlan.value!.data!.firstWhereOrNull(
      (Plan e) => !e.isLesson!,
    );
    recentLessonPlans(<Plan>[]);
    if (lp != null) {
      recentLessonPlans().add(lp);
    }
    if (rp != null) {
      recentLessonPlans().add(rp);
    }
    recentLessonPlans.refresh();
  }
}
