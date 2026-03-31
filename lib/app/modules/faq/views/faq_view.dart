import 'package:sikshana/app/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/faq_controller.dart';

/// A view that displays the FAQ page.
///
/// This view uses a [WebViewWidget] to render the FAQ page from a given URL.
/// It also handles scenarios where there is no internet connectivity by showing
/// a [NoInternetScreenView]. A loading indicator is displayed while the page
/// is being loaded.
class FaqView extends GetView<FaqController> {
  /// Creates a [FaqView].
  const FaqView({super.key});

  @override
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
              drawer: const AppDrawer(currentRoute: Routes.FAQ),
              body: Obx(
                () => controller.isLoading()
                    ? Center(
                        child: Lottie.asset(
                          AppImages.loader,
                          width: 120.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                        ),
                      )
                    : WebViewWidget(controller: controller.controller),
              ),
            ),
    );
  }
}
