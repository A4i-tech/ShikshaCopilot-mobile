import 'package:sikshana/app/utils/exports.dart';

/// A controller for the [NavigationScreenView] that manages the state of the
/// bottom navigation bar, including the current tab index and animations.
/// It also handles nested navigation for each tab.
class NavigationScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Provides a convenient way to access the [NavigationScreenController] instance
  /// from anywhere in the app using `NavigationScreenController.to`.
  static NavigationScreenController get to => Get.find();

  /// The observable integer representing the currently selected tab index.
  ///
  /// The UI reacts to changes in this value to update the displayed tab and
  /// the state of the bottom navigation bar.
  final RxInt currentIndex = 0.obs;

  /// The animation controller for handling tab transition animations.
  late final AnimationController animationController;

  /// The fade animation applied to the tab content during transitions.
  late final Animation<double> animation;

  /// A list of [GlobalKey<NavigatorState>] for each tab, enabling independent
  /// navigation stacks for each tab in the bottom navigation.
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  /// A list of route names corresponding to each tab in the navigation bar.
  final List<String> routes = <String>[
    Routes.DASHBOARD,
    Routes.CONTENT_GENERATION,
    Routes.CHATBOT,
    Routes.PROFILE,
  ];

  /// Checks if the given [route] is one of the main tabs.
  ///
  /// Returns `true` if the [route] is present in the [routes] list,
  /// otherwise `false`.
  bool isMainTab(String route) => routes.contains(route);

  /// Initializes the controller.
  ///
  /// This method is called when the controller is first created. It sets the
  /// initial tab index based on `Get.arguments`, initializes the animation
  /// controller, and sets up a listener to re-trigger animations when the
  /// `currentIndex` changes.
  @override
  void onInit() {
    if (Get.arguments != null) {
      final int tempIndex = routes.indexOf(Get.arguments['route']);
      currentIndex.value = tempIndex >= 0 ? tempIndex : 0;
    }
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward();

    currentIndex.listen((_) {
      animationController
        ..reset()
        ..forward();
    });
  }

  /// Cleans up the controller when it is removed from memory.
  ///
  /// This method disposes of the [animationController] to prevent memory leaks.
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  /// Changes the currently selected tab and optionally navigates to a new route.
  ///
  /// The [index] parameter specifies the new tab to be selected.
  ///
  /// If [redirectionRoute] is provided, it navigates to that route using `Get.toNamed`.
  /// Optional [args] can be passed to the new route.
  void changeTab(
    int index, {
    String? redirectionRoute,
    Map<String, dynamic>? args,
  }) {
    currentIndex.value = index;
    if (redirectionRoute != null) {
      Get.toNamed(redirectionRoute, arguments: args);
    }
  }
}
