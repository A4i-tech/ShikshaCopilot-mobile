import 'package:sikshana/app/modules/faq/controllers/faq_controller.dart';
import 'package:sikshana/app/modules/help/controllers/help_controller.dart';
import 'package:sikshana/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';
import 'package:sikshana/app/modules/question_paper_generation/controllers/question_paper_generation_controller.dart';
import 'package:sikshana/app/utils/exports.dart';

///AppDrawer widget
class AppDrawer extends StatelessWidget {
  ///Creates [AppDrawer]
  const AppDrawer({super.key, this.currentRoute});

  ///current screen/root
  final String? currentRoute;

  void navigateToRoute(
    BuildContext context,
    String routeName, {
    required Type controller,
  }) {
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).closeDrawer();
    }
    if (currentRoute == routeName) {
      return;
    }

    if (Get.isRegistered(tag: controller.toString())) {
      // Controller exists, just navigate back
      Get.until((Route route) => Get.currentRoute == routeName);
    } else {
      // Controller doesn't exist, use offNamedUntil
      Get.offNamedUntil(
        routeName,
        (Route route) => route.settings.name == Routes.NAVIGATION_SCREEN,
      );
    }
  }

  void handleDrawerNavigation(BuildContext context, String route) {
    if (Get.isRegistered<NavigationScreenController>()) {
      final NavigationScreenController shellController =
          Get.find<NavigationScreenController>();
      if (shellController.isMainTab(route)) {
        final int index = shellController.routes.indexOf(route);
        shellController.changeTab(index);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Scaffold.of(context).isDrawerOpen) {
            Scaffold.of(context).closeDrawer();
          }
        });
        Get.until(
          (Route<dynamic> route) =>
              route.settings.name == Routes.NAVIGATION_SCREEN,
        );
      }
    } else {
      Get.offNamedUntil(
        Routes.NAVIGATION_SCREEN,
        (Route<dynamic> route) => false,
        arguments: <String, String>{'route': route},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DrawerItem> drawerItems = <DrawerItem>[
      DrawerItem(
        title: LocaleKeys.home.tr,
        icon: AppImages.homeIcon,
        route: Routes.DASHBOARD,
        onTap: () => handleDrawerNavigation(context, Routes.DASHBOARD),
      ),
      DrawerItem(
        title: LocaleKeys.profile.tr,
        icon: AppImages.profileIcon,
        route: Routes.PROFILE,
        onTap: () => handleDrawerNavigation(context, Routes.PROFILE),
      ),
      DrawerItem(
        title: LocaleKeys.contentGeneration.tr,
        icon: AppImages.contentGenerationIcon,
        route: Routes.CONTENT_GENERATION,
        onTap: () => handleDrawerNavigation(context, Routes.CONTENT_GENERATION),
      ),
      // DrawerItem(
      //   title: LocaleKeys.generationStatus.tr,
      //   icon: AppImages.generationStatusIcon,
      //   route: Routes.GENERATION_STATUS,
      //   onTap: () => navigateToRoute(
      //     context,
      //     Routes.GENERATION_STATUS,
      //     controller: GenerationStatusController,
      //   ),
      // ),
      DrawerItem(
        title: LocaleKeys.chatbot.tr,
        icon: AppImages.chatbotIcon,
        route: Routes.CHATBOT,
        onTap: () => handleDrawerNavigation(context, Routes.CHATBOT),
      ),
      DrawerItem(
        title: LocaleKeys.questionPaperGeneration.tr,
        icon: AppImages.qpGenerationIcon,
        route: Routes.QUESTION_PAPER_GENERATION,
        onTap: () => navigateToRoute(
          context,
          Routes.QUESTION_PAPER_GENERATION,
          controller: QuestionPaperGenerationController,
        ),
      ),
      DrawerItem(
        title: LocaleKeys.mySchedules.tr,
        icon: AppImages.myScheduleIcon,
        route: Routes.MY_SCHEDULES,
        onTap: () => navigateToRoute(
          context,
          Routes.MY_SCHEDULES,
          controller: MySchedulesController,
        ),
      ),
      DrawerItem(
        title: LocaleKeys.help.tr,
        icon: AppImages.helpIcon,
        route: '/help',
        onTap: () =>
            navigateToRoute(context, Routes.HELP, controller: HelpController),
      ),
      DrawerItem(
        title: LocaleKeys.faq.tr,
        icon: AppImages.faqIcon,
        route: Routes.FAQ,
        onTap: () =>
            navigateToRoute(context, Routes.FAQ, controller: FaqController),
      ),
    ];

    return Drawer(
      width: Get.width,
      shape: const BeveledRectangleBorder(),
      child: SafeArea(
        child: Container(
          color: AppColors.kFFFFFF,
          child: Column(
            children: <Widget>[
              _buildDrawerHeader(context),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: drawerItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DrawerItem item = drawerItems[index];
                    final bool isSelected = item.route == currentRoute;
                    return _buildDrawerItem(item, isSelected);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
    child: Row(
      children: <Widget>[
        SvgPicture.asset(AppImages.copilotLogo, height: 40),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Container(
            padding: EdgeInsets.all(8.dg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8).r,
              border: Border.all(color: AppColors.kDCDEE4),
            ),
            child: Icon(Icons.close, color: AppColors.k303030, size: 24.dg),
          ),
        ),
      ],
    ),
  );

  Widget _buildDrawerItem(DrawerItem item, bool isSelected) => Container(
    margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: isSelected ? AppThemes.drawerSelection : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      minTileHeight: 60.h,
      leading: SvgPicture.asset(
        item.icon,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(
          isSelected ? AppThemes.primary : AppColors.k84828A,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        item.title,
        style: AppTextStyle.lato(
          fontSize: 16.sp,
          color: isSelected ? AppThemes.primary : AppColors.k1A1A1A,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: item.onTap,
    ),
  );
}

///DawerItem model
class DrawerItem {
  ///Creates [DrawerItem]
  DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.onTap,
  });

  ///title string
  final String title;

  ///icon image string
  final String icon;

  ///drawer item redirect root
  final String route;

  ///to route controller name
  final void Function()? onTap;
}
