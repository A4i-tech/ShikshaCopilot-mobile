import 'package:sikshana/app/modules/profile/models/board_detail_model.dart';
import 'package:sikshana/app/modules/profile/models/facility_model.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';
import 'package:sikshana/app/modules/profile/models/resource_ui_model.dart';
import 'package:sikshana/app/utils/exports.dart';
import 'dart:io';

/// Controller for the user profile screen.
class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Tab controller for navigating between profile sections.
  late TabController tabController;

  // Profile Photo
  /// The selected profile image file.
  final Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // Personal Details
  /// Global key for the form builder.
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// List of available languages for the application.
  final List<DropdownMenuItem<String>> languages = <DropdownMenuItem<String>>[
    const DropdownMenuItem(child: Text('English'), value: 'en'),
    const DropdownMenuItem(child: Text('ಕನ್ನಡ'), value: 'kn'),
  ];

  // Class Details
  /// A reactive list of class details for the user.
  final RxList<ClassDetail> classDetails = <ClassDetail>[].obs;

  /// Reactive object to hold board details data.
  final Rx<BoardDetailModel?> boardDetailsData = Rx<BoardDetailModel?>(null);

  /// Reactive list of board options for dropdowns.
  final RxList<DropdownMenuItem<String>> boardOptions =
      <DropdownMenuItem<String>>[].obs;

  /// Repository for handling profile-related API calls.
  final ProfileApiRepo _profileApiRepo = ProfileApiRepo();

  /// Reactive object to hold the user's profile model.
  final Rx<ProfileModel> profile = ProfileModel().obs;

  /// Reactive object to hold the facility model.
  final Rx<FacilityModel> facilities = FacilityModel().obs;

  // --- Resources ---
  /// A reactive list of resource UI models.
  final RxList<ResourceUIModel> resources = <ResourceUIModel>[].obs;

  /// Reactive list of resource type options for dropdowns.
  final RxList<DropdownMenuItem<String>> resourceTypeOptions =
      <DropdownMenuItem<String>>[].obs;

  /// Reactive map of resource details options.
  final RxMap<String, List<String>> resourceDetailsOptions =
      <String, List<String>>{}.obs;

  /// Loading state for profile fetching.
  final RxBool isLoading = true.obs;

  /// Indicates if resources have been loaded for the first time.
  bool firstResourcesLoaded = false;

  @override
  /// Called when the controller is initialized.
  /// Initializes the tab controller and fetches initial data.
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this)
      ..addListener(tabListner);
    initController();
  }

  @override
  /// Called after the widget is rendered.
  /// Patches form values with the fetched profile data.
  void onReady() {
    super.onReady();
    patchFormValues();
  }

  /// Listens to tab changes to load resources when the resources tab is selected.
  void tabListner() {
    if (tabController.index == 2 && !firstResourcesLoaded) {
      firstResourcesLoaded = true;
      getProfile(isResources: true);
    }
  }

  /// Initializes the controller by fetching profile, board, and facility details.
  Future<void> initController() async {
    Loader.show();
    try {
      await Future.wait<void>(<Future<void>>[
        getProfile(),
        getBoardDetails(),
        getFacilities(),
      ]);
    } finally {
      Loader.dismiss();
    }
  }

  /// Patches the form with the user's profile data.
  void patchFormValues() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      formKey.currentState?.patchValue(<String, dynamic>{
        'name': profile.value.data?.name,
        'phone': profile.value.data?.phone,
        'school': profile.value.data?.school?.name,
        'state': profile.value.data?.state,
        'zone': profile.value.data?.zone,
        'district': profile.value.data?.district,
        'taluk': profile.value.data?.block,
        'language': profile.value.data?.preferredLanguage,
      });

      for (int i = 0; i < classDetails.length; i++) {
        final ClassDetail detail = classDetails[i];
        formKey.currentState?.patchValue(<String, dynamic>{
          'board_$i': detail.board.toString(),
          'medium_$i': detail.medium.toString(),
          'class_$i': detail.classClass.toString(),
          'subject_$i': detail.subject.toString(),
          'boys_$i': detail.boysStrength.toString(),
          'girls_$i': detail.girlsStrength.toString(),
        });
      }

      for (int i = 0; i < resources.length; i++) {
        final ResourceUIModel resource = resources[i];
        formKey.currentState?.patchValue(<String, dynamic>{
          'resourceType_$i': resource.type.value,
          'resourceDetails_$i': resource.detail.toList(),
          if (resource.otherType.value != null)
            'resourceOtherType_$i': resource.otherType.value,
        });
      }
      for (int i = 0; i < resources.length; i++) {
        print(
          '${formKey.currentState?.value['resourceType_$i']}:${resources[i].type.value}',
        );
        print(
          '${formKey.currentState?.value['resourceDetails_$i']}:${resources[i].detail.toList()}',
        );
        print(
          '${formKey.currentState?.value['resourceOtherType_$i']}:${resources[i].otherType.value}',
        );
      }
    });
  }

  bool get canSaveProfile =>
      !isLoading.value && profile.value.data?.classes?.length == 0;

  /// Fetches the user's profile data from the API.
  ///
  /// Parameters:
  /// - `isResources`: Whether to specifically fetch resources data.
  Future<void> getProfile({bool isResources = false}) async {
    logD('Get Profile Called');
    isLoading(true);
    try {
      if (isResources) {
        Loader.show();
      }
      final ProfileModel? res = await _profileApiRepo.getProfile(
        userId: UserProvider.currentUser?.id ?? '',
      );
      if (res != null && (res.success ?? false)) {
        //LocalStore.user(json.encode(res.data!.toJson()));
        _storeFlattenedUser(res);
        if (isResources) {
          if (res.data?.facilities?.isNotEmpty ?? false) {
            resources.assignAll(
              res.data!.facilities!.map((Facility f) {
                final List<String> uniqueDetails =
                    f.details?.toSet().toList() ?? <String>[];
                return ResourceUIModel(
                  type: f.type,
                  detail: uniqueDetails,
                  otherType: f.otherType,
                  typeChipSet: f.typeChipSet,
                  detailsChipSet: f.detailsChipSet,
                );
              }),
            );
            for (int i = 0; i < resources.length; i++) {
              final ResourceUIModel resource = resources[i];
              formKey.currentState?.patchValue(<String, dynamic>{
                'resourceType_$i': resource.type.value,
                'resourceDetails_$i': resource.detail.toList(),
                if (resource.otherType.value != null)
                  'resourceOtherType_$i': resource.otherType.value,
              });
            }
          } else {
            resources.assignAll(<ResourceUIModel>[ResourceUIModel()]);
          }
          resources.refresh();
          return;
        }
        profile(res);
        profile.refresh();
        profileImage.value = null;

        if (res.data?.facilities?.isNotEmpty ?? false) {
          resources.assignAll(
            res.data!.facilities!.map((Facility f) {
              final List<String> uniqueDetails =
                  f.details?.toSet().toList() ?? <String>[];
              return ResourceUIModel(
                type: f.type,
                detail: uniqueDetails,
                otherType: f.otherType,
                typeChipSet: f.typeChipSet,
                detailsChipSet: f.detailsChipSet,
              );
            }),
          );
        } else {
          resources.assignAll(<ResourceUIModel>[ResourceUIModel()]);
        }
        resources.refresh();
        logD('Classes:  ProfileAre ${jsonEncode(res.data?.classes)}');
        if (res.data?.classes?.isNotEmpty ?? false) {
          classDetails.assignAll(res.data!.classes!);
        } else {
          classDetails.assignAll(<ClassDetail>[ClassDetail()]);
        }

        logD('Get Profile Called Done');

        // temporary fix Akshay Start
        // if (res.data?.classes?.isNotEmpty ?? false) {
        //   // Flatten each subjectDetails into its own ClassDetail
        //   final List<ClassDetail> flattenedClasses = [];

        //   for (final classItem in res.data!.classes!) {
        //     final board = classItem.board;
        //     final klass = classItem.classClass; // adjust name
        //     final medium = classItem.medium;
        //     final className = classItem.subject ?? classItem.name;

        //     if (classItem.subjectDetails != null &&
        //         classItem.subjectDetails!.isNotEmpty) {
        //       for (final sub in classItem.subjectDetails!) {
        //         flattenedClasses.add(
        //           ClassDetail(
        //             board: board.value,
        //             classClass: klass.value,
        //             medium: medium.value,
        //             subject: sub.subjectName,
        //             name: className.value,
        //             sem: sub.sem,
        //           ),
        //         );
        //       }
        //     } else {
        //       // If no subjectDetails, keep the original class
        //       flattenedClasses.add(classItem);
        //     }
        //   }

        //   UserProvider.currentUser = UserProvider.currentUser!.copyWith(
        //     classes: flattenedClasses,
        //   );

        //   // temporary fix Akshay End

        //   // UserProvider.currentUser?.classes = flattenedClasses;

        //   //classDetails.assignAll(flattenedClasses);
        // } else {
        //   //classDetails.assignAll(<ClassDetail>[ClassDetail()]);
        // }

        patchFormValues();
      } else {
        appSnackBar(
          message: res?.message ?? 'Failed to fetch profile data.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } on Exception catch (_) {
      appSnackBar(
        message: 'An error occurred while fetching profile data.',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } finally {
      isLoading(false);
      if (isResources) {
        Loader.dismiss();
      }
    }
  }

  void _storeFlattenedUser(ProfileModel res) {
    // Create working copy of User
    final Map<String, dynamic> userJson = res.data!.toJson();
    final List<Map<String, dynamic>> flattenedClasses = [];

    // Flatten classes only
    final List<dynamic>? apiClasses = userJson['classes'];
    if (apiClasses != null && apiClasses.isNotEmpty) {
      for (final dynamic classItem in apiClasses) {
        final String board = classItem['board']?.toString() ?? '';
        final int classNum = classItem['class'] ?? 0;
        final String medium = classItem['medium']?.toString() ?? '';
        final String subjectName =
            classItem['subject']?.toString() ??
            classItem['name']?.toString() ??
            '';
        final int? boys = classItem['boysStrength'];
        final int? girls = classItem['girlsStrength'];

        final List<dynamic>? subjectDetails = classItem['subjectDetails'];

        if (subjectDetails != null && subjectDetails.isNotEmpty) {
          for (final dynamic sub in subjectDetails) {
            flattenedClasses.add(<String, dynamic>{
              'board': board,
              'class': classNum,
              'medium': medium,
              'subject': sub['subjectName']?.toString() ?? '',
              'name': subjectName,
              'sem': sub['sem'] ?? 1,
              if (boys != null) 'boysStrength': boys,
              if (girls != null) 'girlsStrength': girls,
            });
          }
        } else {
          flattenedClasses.add(<String, dynamic>{
            'board': board,
            'class': classNum,
            'medium': medium,
            'subject': subjectName,
            'name': subjectName,
            if (boys != null) 'boysStrength': boys,
            if (girls != null) 'girlsStrength': girls,
          });
        }
      }
      userJson['classes'] =
          flattenedClasses; // Replace with flattened List<Map>
    }

    // Store flattened User JSON directly
    LocalStore.user(json.encode(userJson));

    debugPrint('✅ Stored flattened user: ${flattenedClasses.length} classes');
    debugPrint('Flattened classes: ${jsonEncode(flattenedClasses)}');
  }

  /// Fetches board detail options from the API.
  Future<void> getBoardDetails() async {
    isLoading(true);

    try {
      final BoardDetailModel? res = await _profileApiRepo.getBoardDetails(
        boardId: UserProvider.currentUser?.school?.id ?? '',
      );
      if (res != null && (res.success ?? false) && res.data != null) {
        boardDetailsData(res);
        final List<String> boards = res.data!
            .map((Datum d) => d.id)
            .whereType<String>()
            .toList();
        boardOptions.assignAll(
          boards
              .toSet()
              .map((String b) => DropdownMenuItem(value: b, child: Text(b)))
              .toList(),
        );
      } else {
        appSnackBar(
          message: res?.message ?? 'Failed to fetch profile data.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } on Exception catch (_) {
      appSnackBar(
        message: 'An error occurred while fetching profile data.',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Fetches the list of available facilities from the API.
  Future<void> getFacilities() async {
    isLoading(true);

    try {
      final FacilityModel? res = await _profileApiRepo.getFacilities();
      if (res != null && (res.success ?? false)) {
        facilities(res);
        final Map<String, List<String>> detailsMap = <String, List<String>>{};
        final List<String> typeOptions = <String>[];

        for (final Result result in res.data?.results ?? <Result>[]) {
          if (result.type != null && result.facilities != null) {
            if (!typeOptions.contains(result.type)) {
              typeOptions.add(result.type!);
            }
            if (detailsMap.containsKey(result.type!)) {
              detailsMap[result.type!]!.addAll(result.facilities!);
            } else {
              detailsMap[result.type!] = result.facilities!;
            }
          }
        }

        resourceTypeOptions
          ..assignAll(
            typeOptions.toSet().toList().map(
              (String type) =>
                  DropdownMenuItem<String>(value: type, child: Text(type)),
            ),
          )
          ..add(
            const DropdownMenuItem<String>(
              child: Text('Others'),
              value: 'Others',
            ),
          );

        resourceDetailsOptions.assignAll(
          detailsMap.map(
            (String key, List<String> value) => MapEntry<String, List<String>>(
              key,
              value.toSet().map((String detail) => detail).toList(),
            ),
          ),
        );
        resourceTypeOptions.refresh();
        resourceDetailsOptions.refresh();
      } else {
        appSnackBar(
          message: res?.message ?? 'Failed to fetch facilities.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } on Exception catch (_) {
      appSnackBar(
        message: 'An error occurred while fetching facilities.',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } finally {
      isLoading(false);
      resources.refresh();
    }
  }

  /// Returns a list of medium options for the given board.
  List<DropdownMenuItem<String>> getMediumOptionsForBoard(String? boardId) {
    if (boardId == null || boardDetailsData.value == null) {
      return <DropdownMenuItem<String>>[];
    }
    final Datum? board = boardDetailsData.value!.data?.firstWhere(
      (Datum d) => d.id == boardId,
      orElse: () => Datum(),
    );
    if (board == null || board.medium == null) {
      return <DropdownMenuItem<String>>[];
    }
    return board.medium!
        .map((Medium m) => m.medium)
        .whereType<String>()
        .toSet()
        .map((String m) => DropdownMenuItem(value: m, child: Text(m)))
        .toList();
  }

  /// Returns a list of class options for the given board and medium.
  List<DropdownMenuItem<String>> getClassOptionsForMedium(
    String? boardId,
    String? mediumId,
  ) {
    if (boardId == null || mediumId == null || boardDetailsData.value == null) {
      return <DropdownMenuItem<String>>[];
    }
    final Datum? board = boardDetailsData.value!.data?.firstWhere(
      (Datum d) => d.id == boardId,
      orElse: () => Datum(),
    );
    if (board == null || board.medium == null) {
      return <DropdownMenuItem<String>>[];
    }
    final Medium medium = board.medium!.firstWhere(
      (Medium m) => m.medium == mediumId,
      orElse: () => Medium(),
    );
    if (medium.start == null || medium.end == null) {
      return <DropdownMenuItem<String>>[];
    }
    return medium.classDetails!
        .map((ClassDet m) => m.standard.toString())
        .whereType<String>()
        .toSet()
        .map((String m) => DropdownMenuItem(value: m, child: Text(m)))
        .toList();
  }

  /// Returns a list of subject options for the given class details.
  List<DropdownMenuItem<String>> getSubjectOptionsForClass(
    String? boardId,
    String? mediumId,
    String? classId,
    int index,
  ) {
    if (boardId == null || classId == null || boardDetailsData.value == null) {
      return <DropdownMenuItem<String>>[];
    }
    final Datum? board = boardDetailsData.value!.data?.firstWhere(
      (Datum d) => d.id == boardId,
      orElse: () => Datum(),
    );
    if (board == null) {
      return <DropdownMenuItem<String>>[];
    }

    // Update boys and girls strength
    if (mediumId != null) {
      final Medium? medium = board.medium?.firstWhere(
        (Medium m) => m.medium == mediumId,
        orElse: () => Medium(),
      );
      if (medium != null) {
        final int? classStandard = int.tryParse(classId);
        if (classStandard != null) {
          final ClassDet? classDet = medium.classDetails?.firstWhere(
            (ClassDet cd) => cd.standard == classStandard,
            orElse: () => ClassDet(),
          );
          if (classDet != null) {
            Future.microtask(() {
              formKey.currentState?.patchValue(<String, dynamic>{
                'boys_$index': classDet.boysStrength?.toString(),
                'girls_$index': classDet.girlsStrength?.toString(),
              });
            });
          }
        }
      }
    }

    if (board.subjects == null) {
      return <DropdownMenuItem<String>>[];
    }

    final int? currentClassId = int.tryParse(classId);
    if (currentClassId == null) {
      return <DropdownMenuItem<String>>[];
    }

    return board.subjects!
        .where(
          (DatumSubject datumSubject)
          // Check if any SubjectSubject within this DatumSubject is applicable to the currentClassId
          =>
              datumSubject.subjects?.any(
                (SubjectSubject subjectSubject) =>
                    subjectSubject.applicableClasses?.contains(
                      currentClassId,
                    ) ??
                    false,
              ) ??
              false,
        )
        .map(
          (DatumSubject s) =>
              DropdownMenuItem(value: s.id, child: Text(s.id ?? '')),
        )
        .toList();
  }

  /// Sets the subject details for a given class detail.
  List<SubjectDetail>? setSubjectDetail(ClassDetail classDetail) {
    if (classDetail.board.value == null ||
        classDetail.classClass.value == null ||
        classDetail.subject.value == null ||
        boardDetailsData.value == null) {
      return null;
    }
    final Datum? board = boardDetailsData.value!.data?.firstWhere(
      (Datum d) => d.id == classDetail.board.value,
      orElse: () => Datum(),
    );
    if (board == null) {
      return null;
    }

    if (board.subjects == null) {
      return null;
    }
    final List<DatumSubject> classSubjects = board.subjects!;
    final DatumSubject? subs = classSubjects.firstWhereOrNull(
      (DatumSubject subject) => subject.id == classDetail.subject.value,
    );
    if (subs != null) {
      return subs.subjects
          ?.map(
            (SubjectSubject e) =>
                SubjectDetail(sem: e.sem, subjectName: e.subjectName),
          )
          .toList();
    }
    return null;
  }

  /// Uploads the selected profile image.
  ///
  /// Parameters:
  /// - `filePath`: The path of the image file to upload.
  Future<void> uploadProfileImage(String filePath) async {
    Loader.show();
    isLoading(true);

    try {
      final User? user = await _profileApiRepo.uploadProfileImage(
        filePath: filePath,
      );
      if (user?.id != null) {
        UserProvider.currentUser = user!;
        appSnackBar(
          message: 'Image uploaded successfully.',
          type: SnackBarType.top,
          state: SnackBarState.success,
        );
        // Refresh profile to get the new image URL
        await getProfile();
      } else {
        // if it fails, we should probably clear the local image
        removeImage();
        appSnackBar(
          message: 'Failed to upload image.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } on Exception catch (_) {
      removeImage();
      appSnackBar(
        message: 'An error occurred while uploading the image.',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } finally {
      Loader.dismiss();
      isLoading(false);
    }
  }

  /// Removes the user's profile picture from the server.
  Future<void> removeProfilePicture() async {
    Loader.show();
    isLoading(true);

    try {
      final bool success = await _profileApiRepo.removeProfileImage();
      if (success) {
        removeImage(); // clear local image
        if (UserProvider.currentUser != null) {
          UserProvider.currentUser = UserProvider.currentUser!.copyWith(
            // ignore: avoid_redundant_argument_values
            profileImage: null,
          );
        }
        profile.update((ProfileModel? val) {
          val?.data?.profileImage = null;
        });
        appSnackBar(
          message: 'Profile image removed.',
          type: SnackBarType.top,
          state: SnackBarState.success,
        );
      } else {
        appSnackBar(
          message: 'Failed to remove profile image.',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      }
    } on Exception catch (_) {
      appSnackBar(
        message: 'An error occurred while removing the image.',
        type: SnackBarType.top,
        state: SnackBarState.danger,
      );
    } finally {
      Loader.dismiss();
      isLoading(false);
    }
  }

  /// Picks an image from the gallery.
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      await uploadProfileImage(pickedFile.path);
    }
  }

  /// Removes the locally selected profile image.
  void removeImage() {
    profileImage.value = null;
  }

  /// Adds a new class detail item.
  void addClassDetail() {
    classDetails.add(ClassDetail());
  }

  /// Removes a class detail item at the specified index.
  void removeClassDetail(int index) {
    if (classDetails.length > 1) {
      classDetails.removeAt(index);
    } else {
      Get.snackbar('Error', 'At least one class detail is required.');
    }
  }

  /// Adds a new resource item.
  void addResource() {
    resources.add(ResourceUIModel());
  }

  /// Removes a resource item at the specified index.
  void removeResource(int index) {
    resources.removeAt(index);
  }

  /// Saves the user's profile data.
  Future<void> saveProfile() async {
    if (formKey.currentState!.saveAndValidate()) {
      Loader.show();
      try {
        final Map<String, dynamic> formData = formKey.currentState!.value;
        final List<Map<String, dynamic>> classesData = <Map<String, dynamic>>[];

        logD('Subject is ${formData['subject_0']}');

        // FIXED: Classes loop with model fallbacks

        // NEW: check duplicates DIRECTLY from classDetails (before flattening)
        if (hasDuplicateClassesFromDetails(classDetails)) {
          appSnackBar(
            message: 'Duplicate class-subject mapping found. Please verify.',
            type: SnackBarType.top,
            state: SnackBarState.warning,
          );
          return;
        }

        for (int i = 0; i < classDetails.length; i++) {
          // Fallback: use model values if form fields are null
          final String? formSubject = formData['subject_$i'] as String?;
          final String? subjectValue =
              formSubject ?? classDetails[i].subject.value;

          final String? formBoard = formData['board_$i'] as String?;
          final String? boardValue = formBoard ?? classDetails[i].board.value;

          final String? formMedium = formData['medium_$i'] as String?;
          final String? mediumValue =
              formMedium ?? classDetails[i].medium.value;

          final String? formClass = formData['class_$i'] as String?;
          final int? classValue =
              int.tryParse(formClass ?? '') ?? classDetails[i].classClass.value;

          // Skip if no subject (form OR model)
          if (subjectValue == null || subjectValue.isEmpty) {
            continue;
          }

          // Use subjectDetails if available, otherwise create single entry
          if (classDetails[i].subjectDetails != null &&
              classDetails[i].subject.value == subjectValue) {
            for (final SubjectDetail sub in classDetails[i].subjectDetails!) {
              classesData.add(<String, dynamic>{
                'board': boardValue,
                'medium': mediumValue,
                'class': classValue,
                'subject': sub.subjectName,
                'sem': sub.sem,
                'name': subjectValue,
              });
            }
          } else {
            // Fallback: single class entry
            classesData.add(<String, dynamic>{
              'board': boardValue,
              'medium': mediumValue,
              'class': classValue,
              'subject': subjectValue,
              'name': subjectValue,
            });
          }
        }

        // Resources unchanged
        final List<Map<String, dynamic>> resourcesData =
            <Map<String, dynamic>>[];
        for (int i = 0; i < resources.length; i++) {
          if (formData['resourceType_$i'] == null ||
              formData['resourceDetails_$i'] == null) {
            continue;
          }
          resourcesData.add(<String, dynamic>{
            'type': formData['resourceType_$i'],
            'details': formData['resourceDetails_$i'],
            'otherType': formData['resourceOtherType_$i'],
            'typeChipSet': formData['resourceType_$i'] != 'Others',
            'detailsChipSet': formData['resourceType_$i'] != 'Others',
          });
        }

        // Fixed check: proper empty validation
        if (classesData.isEmpty) {
          appSnackBar(
            message: 'Please add at least one class with subject.',
            type: SnackBarType.top,
            state: SnackBarState.warning,
          );
          return;
        }

        final Map<String, dynamic> payload = <String, dynamic>{
          'classes': classesData,
          'facilities': resourcesData,
          'preferredLanguage': formData['language'],
        };

        debugPrint('Classes JSON Saving: ${jsonEncode(classesData)}');

        final User? user = await _profileApiRepo.setProfile(data: payload);

        if (user?.id != null) {
          UserProvider.currentUser = user!;
          await getProfile();
          appSnackBar(
            message: 'Profile saved successfully!',
            type: SnackBarType.top,
            state: SnackBarState.success,
          );
        } else {
          appSnackBar(
            message: 'Failed to save profile.',
            type: SnackBarType.top,
            state: SnackBarState.danger,
          );
        }
      } catch (e) {
        appSnackBar(
          message: 'An error occurred: $e',
          type: SnackBarType.top,
          state: SnackBarState.danger,
        );
      } finally {
        Loader.dismiss();
      }
    }
  }

  /// Check duplicates directly from classDetails (board, medium, classClass, subject)
  bool hasDuplicateClassesFromDetails(List<ClassDetail> classDetails) {
    final Set<String> seen = <String>{};
    for (final ClassDetail detail in classDetails) {
      if (detail.subject.value == null || detail.subject.value!.isEmpty)
        continue;

      final String key = jsonEncode({
        'board': detail.board.value,
        'medium': detail.medium.value,
        'class': detail.classClass.value,
        'subject': detail.subject.value,
      });

      if (seen.contains(key)) return true;
      seen.add(key);
    }
    return false;
  }

  /// Extracts initials from a given name.
  String extractInitials(String name) {
    final List<String> words = name.split(' ')
      ..removeWhere((String word) => word.isEmpty);

    if (words.length == 1) {
      return words.first.substring(0, 1);
    } else if (words.length >= 2) {
      return words.first.substring(0, 1) + words.last.substring(0, 1);
    }

    return '';
  }

  /// Changes the application language.
  Future<void> changeLanguage({
    required String newLocale,
    bool didChange = true,
  }) async {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    if (didChange) {
      await Get.updateLocale(Locale(newLocale));
      unawaited(updateLanguage(newLocale));
    } else {
      final String? originalLocale = Get.locale?.languageCode;
      formKey.currentState?.patchValue(<String, dynamic>{
        'language': originalLocale,
      });
    }
  }

  /// Updates the user's preferred language on the server.
  Future<void> updateLanguage(String locale) async {
    Loader.show();
    try {
      await _profileApiRepo.updateLanguage(languageCode: locale);
      LocalStore.currentLocale(locale);
    } finally {
      Loader.dismiss();
    }
  }

  @override
  void onClose() {
    tabController.removeListener(tabListner);
    tabController.dispose();
    for (final ClassDetail detail in classDetails) {
      detail.boysStrengthController.dispose();
      detail.girlsStrengthController.dispose();
    }
    super.onClose();
  }
}

// void changeClassesInUserProfile(List<ClassDetail> flattenedClassDetails) {
//   if (UserProvider.currentUser == null || flattenedClassDetails.isEmpty) return;

//   final List<ClassDetail> groupedClassesForUser = [];
//   final Map<String, List<ClassDetail>> grouped = <String, List<ClassDetail>>{};

//   for (final ClassDetail detail in flattenedClassDetails) {
//     final String groupKey =
//         '${detail.board.value}_${detail.classClass.value}_${detail.medium.value}_${detail.name.value}';
//     grouped.putIfAbsent(groupKey, () => []).add(detail);
//   }

//   for (final MapEntry<String, List<ClassDetail>> entry in grouped.entries) {
//     final List<ClassDetail> group = entry.value;
//     if (group.isNotEmpty) {
//       final ClassDetail first = group.first;
//       final List<SubjectDetail> subjectDetails = group.map((ClassDetail d) {
//         return SubjectDetail(
//           subjectName: d.subject.value ?? '',
//           sem: d.sem.value ?? 1,
//         );
//       }).toList();

//       final ClassDetail groupedClassDetail = ClassDetail(
//         board: first.board.value,
//         classClass: first.classClass.value,
//         medium: first.medium.value,
//         subject: first.name.value,
//         name: first.name.value,
//         subjectDetails: subjectDetails,
//         boysStrength: first.boysStrength.value,
//         girlsStrength: first.girlsStrength.value,
//       );

//       groupedClassesForUser.add(groupedClassDetail);
//     }
//   }

//   UserProvider.currentUser = UserProvider.currentUser!.copyWith(
//     classes: groupedClassesForUser,
//   );

//   debugPrint(
//     '✅ UserProvider classes grouped: ${groupedClassesForUser.length} groups',
//   );

//   // JSON print of classes in UserProvider
//   final List<Map<String, dynamic>> jsonClasses = groupedClassesForUser
//       .map((c) => c.toJson())
//       .toList();
//   debugPrint('Grouped classes JSON: ${jsonEncode(jsonClasses)}');
// }
