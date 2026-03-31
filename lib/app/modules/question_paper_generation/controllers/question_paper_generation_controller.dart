import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/modules/question_paper_generation/models/question_bank_list_model.dart';
import 'package:sikshana/app/utils/exports.dart';

import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/utils/exports.dart';

/// Controller for the Question Paper Generation module.
class QuestionPaperGenerationController extends GetxController {
  /// Global key for the form builder.
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Repository for question paper generation API calls.
  final QuestionpaperGenerationApiRepo _apiRepo =
      QuestionpaperGenerationApiRepo();

  /// Reactive list of available boards.
  final RxList<String> boards = <String>[].obs;

  /// Reactive list of available mediums.
  final RxList<String> mediums = <String>[].obs;

  /// Reactive list of available classes.
  final RxList<String> classes = <String>[].obs;

  /// Reactive list of available subjects.
  final RxList<String> subjects = <String>[].obs;

  /// Reactive string for the selected board.
  final RxnString selectedBoard = RxnString();

  /// Reactive string for the selected medium.
  final RxnString selectedMedium = RxnString();

  /// Reactive string for the selected class.
  final RxnString selectedClass = RxnString();

  /// Reactive string for the selected subject.
  final RxnString selectedSubject = RxnString();

  /// Reactive boolean to indicate loading state.
  final RxBool isLoading = false.obs;

  /// Reactive object to hold the fetched question bank list model.
  final Rx<QuestionBankListModel> questionBank = QuestionBankListModel().obs;

  /// Debounce timer for search.
  Timer? _searchDebounceTimer;

  /// Reactive boolean to control the visibility of filters.
  final RxBool showFilters = false.obs;

  @override
  /// Called when the controller is initialized.
  /// Loads status data.
  void onInit() {
    super.onInit();
    loadStatusData();
  }

  @override
  /// Called after the widget is rendered.
  /// Patches form values with initial selections.
  void onReady() {
    formKey.currentState?.patchValue(<String, dynamic>{
      'board': selectedBoard.value,
      'medium': selectedMedium.value,
      'class': selectedClass.value,
      'subject': selectedSubject.value,
    });
    super.onReady();
  }

  /// Initiates a search for question banks with a debounce mechanism.
  ///
  /// Parameters:
  /// - `value`: The search query string.
  void searchQuestionBanksWithDebounce(String? value) {
    _searchDebounceTimer?.cancel();

    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchGenerationStatus();
    });
  }

  /// Loads class details data for populating dropdowns.
  void loadStatusData() {
    final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
    if (userClasses != null && userClasses.isNotEmpty) {
      boards.value = userClasses
          .map((ClassDetail e) => e.board.value!)
          .toSet()
          .toList();
      if (boards.length == 1) {
        onBoardChanged(boards.first);
      }
    }
  }

  /// Fetches the generation status of question papers based on current filters.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the data is fetched.
  Future<void> fetchGenerationStatus() async {
    formKey.currentState?.save();
    isLoading.value = true;
    Loader.show();
    questionBank(QuestionBankListModel());
    try {
      final QuestionBankListModel? response = await _apiRepo
          .getQuestionBankList(
            board: selectedBoard.value,
            medium: selectedMedium.value,
            grade: selectedClass.value,
            subject: selectedSubject.value,
            search: formKey.currentState?.value['search'],
          );
      if (response != null) {
        questionBank.value = response;
      }
    } finally {
      isLoading.value = false;
      Loader.dismiss();
    }
  }

  /// Called when the selected board changes.
  /// Updates available mediums, classes, and subjects based on the new board.
  ///
  /// Parameters:
  /// - `value`: The newly selected board.
  void onBoardChanged(String? value) {
    selectedBoard.value = value;
    selectedMedium.value = null;
    selectedClass.value = null;
    selectedSubject.value = null;
    mediums.clear();
    classes.clear();
    subjects.clear();
    if (value != null) {
      final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        mediums.value = userClasses
            .where((ClassDetail e) => e.board.value == value)
            .map((ClassDetail e) => e.medium.value!)
            .toSet()
            .toList();
        if (mediums.length == 1) {
          onMediumChanged(mediums.first);
          return;
        }
      }
    }
    applyFilters();
  }

  /// Called when the selected medium changes.
  /// Updates available classes and subjects based on the new medium.
  ///
  /// Parameters:
  /// - `value`: The newly selected medium.
  void onMediumChanged(String? value) {
    selectedMedium.value = value;
    selectedClass.value = null;
    selectedSubject.value = null;
    classes.clear();
    subjects.clear();
    if (value != null) {
      final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        classes.value = userClasses
            .where(
              (ClassDetail e) =>
                  e.board.value == selectedBoard.value &&
                  e.medium.value == value,
            )
            .map((ClassDetail e) => e.classClass.value!.toString())
            .toSet()
            .toList();
        if (classes.length == 1) {
          onClassChanged(classes.first);
          return;
        }
      }
    }
    applyFilters();
  }

  /// Called when the selected class changes.
  /// Updates available subjects based on the new class.
  ///
  /// Parameters:
  /// - `value`: The newly selected class.
  void onClassChanged(String? value) {
    selectedClass.value = value;
    selectedSubject.value = null;
    subjects.clear();
    if (value != null) {
      final List<ClassDetail>? userClasses = UserProvider.currentUser?.classes;
      if (userClasses != null && userClasses.isNotEmpty) {
        subjects.value = userClasses
            .where(
              (ClassDetail e) =>
                  e.board.value == selectedBoard.value &&
                  e.medium.value == selectedMedium.value &&
                  e.classClass.value!.toString() == value,
            )
            .map((ClassDetail e) => e.name.value!)
            .toSet()
            .toList();
        if (subjects.length == 1) {
          onSubjectChanged(subjects.first);
          return;
        }
      }
    }
    applyFilters();
  }

  /// Called when the selected subject changes.
  ///
  /// Parameters:
  /// - `value`: The newly selected subject.
  void onSubjectChanged(String? value) {
    selectedSubject.value = value;
    applyFilters();
  }

  /// Applies the current filter selections and fetches question banks.
  void applyFilters() {
    formKey.currentState?.save();
    fetchGenerationStatus();
  }
}
