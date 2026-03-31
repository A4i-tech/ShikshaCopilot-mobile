import 'package:get/get.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A controller for the FAQ screen that manages the state and logic for
/// displaying the FAQ page in a [WebViewWidget].
class FaqController extends GetxController {
  /// The controller for the WebView used to display the FAQ page.
  late final WebViewController controller;

  /// The URL of the FAQ page to be loaded.
  final String url = ApiConstants.faqUrl;

  /// A reactive boolean that indicates whether the web page is currently loading.
  ///
  /// This is used to show a loading indicator to the user while the page is
  /// being fetched and rendered.
  final RxBool isLoading = true.obs;

  /// Called when the controller is initialized.
  ///
  /// This method calls [initController] to set up the [WebViewController].
  @override
  void onInit() {
    super.onInit();
    initController();
  }

  /// Initializes the [WebViewController].
  ///
  /// This method creates a [WebViewController] instance, enables JavaScript,
  /// sets up navigation delegates to handle page loading events, and loads
  /// the FAQ page from the specified [url].
  Future<void> initController() async {
    controller = WebViewController();
    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          isLoading(true);
        },
        onPageFinished: (_) {
          isLoading(false);
        },
        onWebResourceError: (_) {
          isLoading(false);
        },
      ),
    );
    await controller.loadRequest(Uri.parse(url));
  }
}
