import 'package:arrows/components/arrows_app_bar.dart';
import 'package:arrows/components/arrows_bottom_nav_bar.dart';
import 'package:arrows/constants/colors.dart';
import 'package:arrows/modules/bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/cart/screens/cart_screen.dart';
import 'package:arrows/modules/home/screens/home_screen.dart';
import 'package:arrows/modules/main_category/screens/main_categories_screen.dart';
import 'package:arrows/modules/more_info/screens/more_info_screen.dart';
import 'package:arrows/modules/order_history/screens/order_history_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:arrows/constants/more_info_constants.dart';

import '../../../helpers/connectivity.dart';


class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({Key? key}) : super(key: key);

  static BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());
  final CartController cartController = Get.put(CartController());

  final List _bodyScreens = [


    MainCategoryScreen(),
    OrderHistoryScreen(),
    HomeScreen( ),
    CartScreen(),
    MoreInfoScreen(),
  ].obs;

  final List <String>title = <String>[
    'menu'.tr,
    'track_order'.tr,
    'home'.tr,
    'cart'.tr,
    '${k.restName}'.tr
  ].obs;

  @override
  Widget build(BuildContext context) {
      final connection =Get.put(ConnectionStatusSingleton());

      return Scaffold(
      key: bottomNavBarController.scaffoldKey,
       // appBar:  Obx(()=>ArrowsAppBar('${title[bottomNavBarController.currentIndex.value]}'.tr)),
      body: Obx(()=> connection.connectivity.value == 1
          ?   _bodyScreens[bottomNavBarController.currentIndex.value]:
      Scaffold(body:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/ic_no_connection.png',height: 300.h,width: 300.w,color: mainColor,),
          Text('no_connection'.tr, style: TextStyle(
              fontSize: 25.sp,
              color: mainColor,
              fontWeight: FontWeight.bold),
          ),

        ],
      )))),

      bottomNavigationBar: ArrowBottomNavBar(
        bottomNavBarController: bottomNavBarController,
      ),
    );
  }
}
