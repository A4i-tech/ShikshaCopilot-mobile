import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Controller for managing and monitoring internet connectivity status.
class NoInternetScreenController extends GetxController {
  /// Reactive variable to track connectivity status.
  RxBool isConnected = true.obs;

  /// Reactive variable to indicate if a connection check is in progress.
  RxBool isChecking = false.obs;

  /// Instance of `Connectivity` for network status monitoring.
  final Connectivity _connectivity = Connectivity();

  /// Callback function to be executed when the connection is restored.
  void Function()? onReConnect;

  @override
  /// Called when the controller is initialized.
  /// Starts monitoring connectivity changes.
  void onInit() {
    super.onInit();
    _monitorConnectivity();
  }

  /// Checks the current internet connection status.
  ///
  /// Sets `isChecking` to true while the check is in progress and updates
  /// `isConnected` with the result.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the connection check is done.
  Future<void> checkConnection() async {
    isChecking.value = true;
    final bool res = await InternetConnectionChecker.instance.hasConnection;
    isConnected.value = res;
    isChecking.value = false;
  }

  /// Monitors network connectivity changes and updates the `isConnected` status.
  ///
  /// If the connection is restored and `onReConnect` is provided, it will be called.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the initial connection check is done.
  Future<void> _monitorConnectivity() async {
    await checkConnection();

    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      await checkConnection();
      if (isConnected.value && onReConnect != null) {
        onReConnect!();
      }
    });
  }
}
