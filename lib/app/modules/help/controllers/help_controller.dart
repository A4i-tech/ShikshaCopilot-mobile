import 'package:get/get.dart';
import 'package:sikshana/app/modules/help/models/help_video_model.dart';
import 'package:sikshana/app/modules/help/repository/help_api_repo.dart';

/// A controller for the Help screen.
///
/// This class manages the state of the Help screen, including fetching
/// help videos from the API and handling loading states.
class HelpController extends GetxController {
  final HelpApiRepo _apiRepo = HelpApiRepo();

  /// A boolean observable that indicates whether the help videos are currently
  /// being loaded.
  final RxBool isLoading = true.obs;

  /// An observable that holds the [HelpVideoModel] containing the list of
  /// help videos.
  final Rx<HelpVideoModel?> helpVideoModel = Rx<HelpVideoModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getHelpVideos();
  }

  /// Fetches the help videos from the API.
  ///
  /// This method sets the [isLoading] state to true, fetches the help videos
  /// from the API using the [_apiRepo], and then updates the [helpVideoModel]
  /// with the response. Finally, it sets the [isLoading] state to false.
  Future<void> getHelpVideos() async {
    isLoading.value = true;
    try {
      final HelpVideoModel? response = await _apiRepo.getHelpVideos();
      if (response != null && response.success == true) {
        helpVideoModel.value = response;
      }
    } finally {
      isLoading.value = false;
    }
  }
}
