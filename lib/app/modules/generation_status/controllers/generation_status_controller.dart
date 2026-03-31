import 'package:sikshana/app/modules/generation_status/models/generation_status_model.dart'
    as gsm;
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/utils/exports.dart';

class GenerationStatusController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GenerationStatusApiRepo _apiRepo = GenerationStatusApiRepo();

  final RxList<String> boards = <String>[].obs;
  final RxList<String> mediums = <String>[].obs;
  final RxList<String> classes = <String>[].obs;
  final RxList<String> subjects = <String>[].obs;

  final RxnString selectedBoard = RxnString();
  final RxnString selectedMedium = RxnString();
  final RxnString selectedClass = RxnString();
  final RxnString selectedSubject = RxnString();

  final RxBool isLoading = false.obs;
  final RxList<gsm.Datum> generationStatusList = <gsm.Datum>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStatusData();
  }

  @override
  void onReady() {
    formKey.currentState?.patchValue(<String, dynamic>{
      'board': selectedBoard.value,
      'medium': selectedMedium.value,
      'class': selectedClass.value,
      'subject': selectedSubject.value,
    });
    super.onReady();
  }

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

  Future<void> fetchGenerationStatus() async {
    isLoading.value = true;
    Loader.show();
    generationStatusList.clear();
    try {
      final gsm.GenerationStatus? response = await _apiRepo.getGenerationStatus(
        board: selectedBoard.value,
        medium: selectedMedium.value,
        filterClass: selectedClass.value,
        subject: selectedSubject.value,
      );
      if (response != null && response.data != null) {
        generationStatusList.value = response.data!;
      }
    } finally {
      isLoading.value = false;
      Loader.dismiss();
    }
  }

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
            .map((ClassDetail e) => e.subject.value!)
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

  void onSubjectChanged(String? value) {
    selectedSubject.value = value;
    applyFilters();
  }

  void applyFilters() {
    formKey.currentState?.save();
    fetchGenerationStatus();
  }
}
