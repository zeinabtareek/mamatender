import 'dart:io';

import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/MainBranches/screens/branches_screen.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'Translations/translations.dart';
import 'constants/colors.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
           final GoogleMapsFlutterPlatform mapsImplementation =
              GoogleMapsFlutterPlatform.instance;
          if (mapsImplementation is GoogleMapsFlutterAndroid) {
            mapsImplementation.useAndroidViewSurface = true;
          }
  await Firebase.initializeApp();
          if (defaultTargetPlatform == TargetPlatform.android) {
            AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
          }
  String userDeviceToken = await FirebaseMessaging.instance.getToken() ?? "";
  await CacheHelper.onInit();
  await CacheHelper.saveDataToSharedPrefrence("deviceToken", userDeviceToken);

  Locale? language;
  if (CacheHelper.getDataToSharedPrefrence("localeIsArabic") == null) {
    if (Get.deviceLocale == const Locale("ar_US")) {
      await CacheHelper.saveDataToSharedPrefrence("localeIsArabic", false);
    } else {
      await CacheHelper.saveDataToSharedPrefrence("localeIsArabic", true);
    }
    language = CacheHelper.getDataToSharedPrefrence("localeIsArabic")
        ? const Locale("ar")
        : const Locale("en");
  } else {
    language = CacheHelper.getDataToSharedPrefrence("localeIsArabic")
        ? const Locale("ar")
        : const Locale("en");
  }

  runApp(MyApp(
    language: language,
    isOpened: true,
  ));
}


class MyApp extends StatelessWidget {
  Locale? language;
  bool? isOpened;

  MyApp({this.language, this.isOpened});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(460, 847),
        builder: (BuildContext, Widget) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: language,
            fallbackLocale: Locale('ar'),
            title: 'Mama\'s Tender',
            theme: ThemeData(
              fontFamily: 'Cairo',
              scaffoldBackgroundColor: kPrimaryColor,
              iconTheme: IconThemeData(color: kPrimaryColor, size: 33),
              appBarTheme: AppBarTheme(
                color: mainColor,
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarColor: mainColor),
                shadowColor: mainColor,

                // iconTheme: IconThemeData(color: mainColor),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedIconTheme: IconThemeData(color: mainColor),
                selectedLabelStyle: TextStyle(color: mainColor),
                selectedItemColor: kBottomNavBarSelectedIconColor,
                unselectedIconTheme: IconThemeData(color: mainColor),
                unselectedItemColor: mainColor,
                showSelectedLabels: true,
                backgroundColor: mainColor,
                // type: BottomNavigationBarType.shifting,
              ),
            ),
            // home: SignUpScreen(),
            // home: WhereToDeliver2(),
            // home: ShScreen(),
            home: SplashScreen(),
          );
        });
  }
}
