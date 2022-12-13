import 'package:arrows/constants/colors.dart';
import 'package:arrows/modules/bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ArrowBottomNavBar extends StatelessWidget {
  final BottomNavBarController bottomNavBarController;

  const ArrowBottomNavBar({
    Key? key,
    required this.bottomNavBarController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        items: [



          // CartScreen(),
          // MainCategoryScreen(),
          // HomeScreen( ),
          // OrderHistoryScreen(),
          // MoreInfoScreen(),




          BottomNavigationBarItem(
              backgroundColor: mainColor,
              icon: ImageIcon(
                AssetImage("assets/icons/ic_menu.png"),
                color: kPrimaryColor,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/icons/ic_menu_filled.png"),
                color: kPrimaryColor,
              ),
              label: "menu".tr),

          BottomNavigationBarItem(
              backgroundColor: mainColor,
              icon: ImageIcon(
                AssetImage("assets/icons/track.png"),
                color: kPrimaryColor,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/icons/active_tracking.png"),
                color: kPrimaryColor,
              ),
              label: "track_order".tr),

          BottomNavigationBarItem(
              backgroundColor: mainColor,
              icon: ImageIcon(
                AssetImage("assets/icons/ic_home.png"),
                color: kPrimaryColor,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/icons/ic_home_filled.png"),
                color: kPrimaryColor,
              ),
              label: "home".tr),

          BottomNavigationBarItem(
              backgroundColor: mainColor,
              icon: ImageIcon(
                AssetImage("assets/icons/ic_cart.png"),
                color: kPrimaryColor,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/icons/ic_cart_filled.png"),
                color: kPrimaryColor,
              ),

              label: "cart".tr),

          BottomNavigationBarItem(
              backgroundColor: mainColor,
              icon: ImageIcon(
                AssetImage("assets/icons/ic_more.png"),
                color: kPrimaryColor,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/icons/ic_more_filled.png"),
                color: kPrimaryColor,
              ),
              label: "more_info".tr),
        ],
        currentIndex: bottomNavBarController.currentIndex.value,
        iconSize: 30.r,
        selectedFontSize: 15.sp,

        backgroundColor: mainColor,
        // unselectedFontSize: 12.sp,

        onTap: (index) {

          bottomNavBarController.changeTabIndex(index);
        },
      );
    });
  }
}
