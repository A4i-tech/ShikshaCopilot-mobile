import 'package:sikshana/app/utils/exports.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/navigation_screen_controller.dart';

class NavigationScreenView extends StatefulWidget {
  const NavigationScreenView({super.key});

  @override
  State<NavigationScreenView> createState() => _NavigationScreenViewState();
}

class _NavigationScreenViewState extends State<NavigationScreenView> {
  late TutorialCoachMark tutorialCoachMark;
  final GetStorage storage = GetStorage(); // Initialize GetStorage
  final String tutorialShownKey = 'tutorialShown'; // Key for tutorial flag

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey contentKey = GlobalKey();
  final GlobalKey chatbotKey = GlobalKey();
  final GlobalKey profileKey = GlobalKey();

  List<TargetFocus> _createTargets() => <TargetFocus>[
    TargetFocus(
      identify: 'home',
      keyTarget: homeKey,
      shape: ShapeLightFocus.RRect,
      contents: <TargetContent>[
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) => _CoachBubble(
            title: LocaleKeys.home.tr,
            description: LocaleKeys.homeDescription.tr, // ✅ Uses JSON key
            onNext: controller.next,
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: 'content',
      keyTarget: contentKey,
      shape: ShapeLightFocus.RRect,
      contents: <TargetContent>[
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) => _CoachBubble(
            title: LocaleKeys.contentGeneration.tr,
            description: LocaleKeys.contentGenerationDescription.tr,
            onNext: controller.next,
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: 'chatbot',
      keyTarget: chatbotKey,
      shape: ShapeLightFocus.RRect,
      contents: <TargetContent>[
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) => _CoachBubble(
            title: LocaleKeys.chatbot.tr,
            description: LocaleKeys.chatbotDescription.tr,
            onNext: controller.next,
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: 'profile',
      keyTarget: profileKey,
      shape: ShapeLightFocus.RRect,
      contents: <TargetContent>[
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) => _CoachBubble(
            title: LocaleKeys.profile.tr,
            description: LocaleKeys.profileDescription.tr,
            onNext: controller.next,
          ),
        ),
      ],
    ),
  ];
  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.8),
      textSkip: LocaleKeys.skip.tr,
      paddingFocus: 8,

      onFinish: () {
        storage.write(tutorialShownKey, true); // Mark tutorial as shown
      },
      onSkip: () {
        storage.write(tutorialShownKey, true); // Mark tutorial as shown
        return true;
      },
    );

    tutorialCoachMark.show(context: this.context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (storage.read(tutorialShownKey) != true) {
        // Show tutorial only if it hasn't been shown before
        _showTutorial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationScreenController>();
    final NoInternetScreenController connectivityController =
        Get.find<NoInternetScreenController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Obx(
      () => !connectivityController.isConnected()
          ? const NoInternetScreenView()
          : PopScope(
              canPop: false,
              onPopInvokedWithResult: (bool didPop, Object? _) {
                if (didPop) {
                  return;
                }
                final NavigatorState? navigator = controller
                    .navigatorKeys[controller.currentIndex.value]
                    .currentState;
                if (navigator?.canPop() == true) {
                  navigator?.pop();
                } else if (controller.currentIndex.value != 0) {
                  controller.changeTab(0);
                } else {
                  SystemNavigator.pop();
                }
              },
              child: Scaffold(
                key: scaffoldKey,
                appBar: CommonAppBar(
                  scaffoldKey: scaffoldKey,
                  leading: Leading.drawer,
                  title: controller.currentIndex.value == 1
                      ? LocaleKeys.lessonContent.tr
                      : controller.currentIndex.value == 2
                      ? LocaleKeys.chatbot.tr
                      : controller.currentIndex.value == 3
                      ? LocaleKeys.profile.tr
                      : '',
                  trailingWidget: controller.currentIndex.value == 0
                      ? Hero(
                          tag: 'profileImage',
                          child: ProfileImageCircle(
                            userInitials: UserProvider.getUserInitials(),
                            imagePath: UserProvider.currentUser?.profileImage,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                drawer: AppDrawer(
                  currentRoute:
                      controller.routes[controller.currentIndex.value],
                ),
                body: FadeTransition(
                  opacity: controller.animation,
                  child: IndexedStack(
                    index: controller.currentIndex.value,
                    children: <Widget>[
                      Navigator(
                        key: controller.navigatorKeys[0],
                        onGenerateRoute: (_) => GetPageRoute(
                          page: () => const HomeView(),
                          binding: HomeBinding(),
                        ),
                      ),
                      Navigator(
                        key: controller.navigatorKeys[1],
                        onGenerateRoute: (_) => GetPageRoute(
                          page: () => const ContentGenerationView(),
                          binding: ContentGenerationBinding(),
                        ),
                      ),
                      Navigator(
                        key: controller.navigatorKeys[2],
                        onGenerateRoute: (_) => GetPageRoute(
                          page: () => const ChatbotView(),
                          binding: ChatbotBinding(),
                        ),
                      ),
                      Navigator(
                        key: controller.navigatorKeys[3],
                        onGenerateRoute: (_) => GetPageRoute(
                          page: () => const ProfileView(),
                          binding: ProfileBinding(),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: AppBottomNavigation(
                  currentRoute:
                      controller.routes[controller.currentIndex.value],
                  onItemSelected: (int value) {
                    controller.changeTab(value);
                  },
                  homeKey: homeKey,
                  contentKey: contentKey,
                  chatbotKey: chatbotKey,
                  profileKey: profileKey,
                ),
              ),
            ),
    );
  }
}

class _CoachBubble extends StatelessWidget {
  const _CoachBubble({
    required this.title,
    required this.description,
    required this.onNext,
  });

  final String title;
  final String description;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: AppColors.kFFFFFF,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTextStyle.lato(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.k000000,
          ),
        ),
        8.verticalSpace,
        Text(
          description,
          style: AppTextStyle.lato(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.k000000,
          ),
        ),
        12.verticalSpace,
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onNext,
            child: Text(
              LocaleKeys.next.tr,
              style: AppTextStyle.lato(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.k46A0F1,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
