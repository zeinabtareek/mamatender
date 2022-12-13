import 'dart:async';

import 'package:arrows/api_base/dio_helper.dart';
import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/more_info_constants.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/MainBranches/controllers/main_branches_controller.dart';
import 'package:arrows/modules/bottom_nav_bar/screens/bottom_nav_bar_screen.dart';
import 'package:arrows/modules/home/screens/closed_now_screen.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/custom_button.dart';
 import '../../../components/loading_spinner.dart';
import '../../../helpers/connectivity.dart';

class BranchesScreen extends StatefulWidget {
  BranchesScreen({Key? key}) : super(key: key);

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  final MainBranchesController mainBranchesController =
      Get.put(MainBranchesController());
  final connection =Get.put(ConnectionStatusSingleton());
  bool? isOpened;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      connection.connectivity.value;
      connection.update();
    });
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return  Obx(() => connection.connectivity.value == 1
        ?  Scaffold(
      appBar:AppBar(
        actions: [
        Padding(
        padding:   EdgeInsets.all(8.0),
    child: Container(
      height: 100.h,
    padding: EdgeInsets.only(left: 10.0, right: 10.0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: mainColor.withOpacity(0),
    border: Border.all()),
    child: new Theme(
    data: Theme.of(context).copyWith(
    canvasColor: mainColor,
    ),
    child:DropdownButton(
        borderRadius:  BorderRadius.circular(12.0.sp),

        dropdownColor: mainColor,
              icon: Icon(Icons.language),
              iconSize: 25,
              underline: SizedBox(),
              items: [
                DropdownMenuItem(
                  child:   Text('en'.tr.toUpperCase(),style: TextStyle(fontSize:  12.sp),),
                  value: 'en',
                ),
                DropdownMenuItem(
                  child: Text('ar'.tr.toUpperCase(),style: TextStyle(fontSize:  12.sp),),
                  value: 'ar',
                ),
              ],
              value: mainBranchesController.selectedValue,
              onChanged: (value) {
                mainBranchesController.switchFunc(value);
                Get.updateLocale(Locale(mainBranchesController.selectedValue));
                if (mainBranchesController.selectedValue == 'ar') {
                  CacheHelper.saveDataToSharedPrefrence("localeIsArabic", true);
                } else {
                  CacheHelper.saveDataToSharedPrefrence(
                      "localeIsArabic", false);
                }
              }),))),
          SizedBox(width: 25),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: Obx(() => mainBranchesController.isLoading.value
          ? Center(
        child: Container(
            width: 40,
            height: 40,
            decoration:
            BoxDecoration(shape: BoxShape.circle, color: mainColor),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: kPrimaryColor,
                ),
              ),
            )),
      )
          :  SafeArea(
        child: Padding(
          padding:   EdgeInsets.only(left: 8.w, right: 8.w, top: 10.h, bottom: 0.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Image.asset(
                      k.restLogo,
                      height: 80.h,
                      // width: 100.w,
                      fit: BoxFit.contain,
                    ),


                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'please_choose_branch'.tr,
                      style: TextStyle(color: mainColor, fontSize: 20.sp),
                    ),
                  ],
                ),
                Obx(() => ListView.builder(
                      itemCount: mainBranchesController.firebaseBranches.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final translateName =
                            CacheHelper.getDataToSharedPrefrence(
                                "localeIsArabic"); //true

                        return index != 0
                            ? Button(
                          height: 60.h,fontSize: 20.sp,
                                size: !landScape
                                    ? ScreenUtil.defaultSize.width - 50.w
                                    : ScreenUtil.defaultSize.width,
                                text: translateName
                                    ? mainBranchesController
                                                .firebaseBranches[index].name_ar
                                                .toString() !=
                                            ''
                                        ? mainBranchesController
                                            .firebaseBranches[index].name_ar
                                            .toString()
                                        : ''
                                    : mainBranchesController
                                                .firebaseBranches[index].name_en
                                                .toString() !=
                                            ''
                                        ? mainBranchesController
                                            .firebaseBranches[index].name_en
                                            .toString()
                                        : '',
                                isFramed: false,
                                onPressed: () async {

                                  await CacheHelper.saveDataToSharedPrefrence(
                                      'restaurantBranchName',
                                      translateName
                                          ? mainBranchesController
                                              .firebaseBranches[index].name_ar
                                              .toString()
                                          : mainBranchesController
                                              .firebaseBranches[index].name_en
                                              .toString());
                                  print(CacheHelper.getDataToSharedPrefrence(
                                      'restaurantBranchName'));
                                  await CacheHelper.saveDataToSharedPrefrence('restaurantBranchID',
                                      mainBranchesController
                                          .firebaseBranches[index].id);
                                  await DioHelper.init(
                                      mainBranchesController
                                              .firebaseBranches[index].dataBase
                                              .toString()  ,
                                      translateName
                                          ? mainBranchesController
                                                  .firebaseBranches[index]
                                                  .name_ar
                                                  .toString()

                                          : mainBranchesController
                                                  .firebaseBranches[index]
                                                  .name_en
                                                  .toString() );
                                  // isOpened = await FirebaseDatabase.instance
                                  //     .reference()
                                  //     .child('availability')
                                  //     .child(CacheHelper.getDataToSharedPrefrence(
                                  //     'restaurantBranchName'))
                                  //     .once()
                                  //     .then((value) {
                                  //       print(value);
                                  //   return (value.value);
                                  // });
                                  await CacheHelper.saveDataToSharedPrefrence(
                                      'restaurantBranchID',mainBranchesController
                                      .firebaseBranches[index].id);
                                  await CacheHelper.saveDataToSharedPrefrence(
                                      'restaurantBranchAddress',translateName?mainBranchesController
                                      .firebaseBranches[index].address_ar:
                                  mainBranchesController
                                      .firebaseBranches[index].address_en);
                                  await CacheHelper.saveDataToSharedPrefrence(
                                      'restaurantBranchName',translateName?mainBranchesController
                                      .firebaseBranches[index].name_ar:
                                  mainBranchesController
                                      .firebaseBranches[index].name_en);
                             await CacheHelper.saveDataToSharedPrefrence(
                                      'restaurantBranchLat',mainBranchesController
                                      .firebaseBranches[index].lat );
                             await CacheHelper.saveDataToSharedPrefrence(
                                      'restaurantBranchLng',mainBranchesController
                                      .firebaseBranches[index].lng );

                                  isOpened = mainBranchesController
                                      .firebaseBranches[index].available;

                                  isOpened == true
                                      ? {
                                          showLoaderDialog(context),
                                          Get.off(BottomNavBarScreen())
                                          // Get.to(BottomNavBarScreen())
                                        }
                                      : Get.to(ClosedNowScreen());
                                },
                              )
                            : Container();
                      }),
                ),
              ],
            ),
          ),

      ),
    ),
    )) :Scaffold(body:Center(
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
    ))));
  }
}
// Get.defaultDialog(
//     title: 'sorry'.tr,
//     content: Text('please_choose_branch'.tr));
