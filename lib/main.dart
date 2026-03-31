import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sikshana/app/data/config/app_themes.dart';
import 'package:sikshana/app/data/config/design_config.dart';
import 'package:sikshana/app/data/config/initialize_app.dart';
import 'package:sikshana/app/data/config/translation_api.dart';
import 'package:sikshana/app/data/local/store/local_store.dart';
import 'package:sikshana/app/modules/no_internet_screen/controllers/no_internet_screen_controller.dart';
import 'package:sikshana/app/routes/app_pages.dart';

import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get
    ..put(NoInternetScreenController())
    ..put(AppTranslations());
  await initializeCoreApp();

  // Set initial system nav bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(
        DesignConfig.kDesignWidth,
        DesignConfig.kDesignHeight,
      ),
      builder: (BuildContext context, Widget? w) => UpgradeAlert(
        showReleaseNotes: false,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shiksha copilot',
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          builder: EasyLoading.init(
            builder: (BuildContext context, Widget? child) =>
                AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    systemNavigationBarColor: Colors.black,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  ),
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: Platform.isAndroid,
                    child: ColoredBox(
                      color: Colors.black,
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
          ),
          translations: AppTranslations(),
          locale: Locale(LocalStore.currentLocale() ?? 'en'),
          fallbackLocale: const Locale('en'),
          defaultTransition: Transition.cupertino,
          theme: AppThemes.lightTheme,
        ),
      ),
    ),
  );

  // Restrict orientation to Portrait
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}
