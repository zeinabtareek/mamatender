import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/more_info_constants.dart';
import 'package:arrows/helpers/map_launch_helper.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/MainBranches/controllers/main_branches_controller.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/main_category/controllers/main_categories_controller.dart';
 import 'package:arrows/modules/more_info/controllers/more_info_controller.dart';
import 'package:arrows/modules/sign_up/controllers/signup_controller.dart';
import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:arrows/shared_object/firebase_order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;

 import '../../../components/arrows_app_bar.dart';
import '../../../components/custom_button.dart';
import '../../../components/loading_spinner.dart';
import '../../../constants/styles.dart';
import '../../chat_screen/chat_screen.dart';
import '../../sign_up/screens/sign_up_screen.dart';
import 'barcod_screen.dart';

class MoreInfoScreen extends StatefulWidget {
  MoreInfoScreen({Key? key}) : super(key: key);

  @override
  State<MoreInfoScreen> createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends State<MoreInfoScreen>  with TickerProviderStateMixin {
  final WhereToController whereToController = Get.put(WhereToController());
  ScrollController _scrollController = ScrollController();

  final MoreInfoController moreInfoController = Get.put(MoreInfoController());

  final CartController cartController = Get.put(CartController());

  final SignUpController signUpController = Get.put(SignUpController());

  bool isFABExtended = false;

   late AnimationController transitionAnimationController;
  MainBranchesController mainBranchesController=Get.put(MainBranchesController());
  @override
  void initState() {
    cartController.totalPoints;
    transitionAnimationController =
        BottomSheet.createAnimationController(this);
    transitionAnimationController.duration = Duration(seconds: 1);
    _scrollController.addListener(() {
      if(_scrollController.offset>10){
        setState(
                () {
          isFABExtended=true;
        });

      }
      else{
        setState((){
          isFABExtended=false;
        });
      }
    });
    super.initState();
  }


  Order? order;
  void dispose() {
    transitionAnimationController.dispose();

    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 1), () {
      CacheHelper.getDataToSharedPrefrence("localeIsArabic");
      cartController.update();
      cartController.getSystemPoints();
    });


    return  Obx(() => moreInfoController.isLoading.value
        ? Center(
      child: Container(
          width: 40,
          height: 40,
          decoration:
          BoxDecoration(shape: BoxShape.circle,  ),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: mainColor,
              ),
            ),
          )),
    )
        : Scaffold(
      appBar: ArrowsAppBar(
          '${k.restName}'.tr
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.only(top: 15.h,right: 10.w,left: 10.w),
                child: GetBuilder<CartController>(
          init: CartController(),
                builder:(cartController){return
                  ListView(
                  shrinkWrap: true,
                  controller:_scrollController,
                  children: [
    FutureBuilder(
    future: cartController.getUserPoints() ,
    builder: (BuildContext context,
    AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.hasError){
    return SizedBox();
    }
    else if( cartController.totalPoints!=0&& cartController.totalPoints!='0'&&cartController.forsale!=null&& cartController.totalPoints!=null){
    return GetBuilder<MoreInfoController>(
    init: MoreInfoController(),
    builder: (controller){
    return ( cartController.totalPoints!=0&& cartController.totalPoints!='0'&&cartController.forsale!=null&& cartController.totalPoints!=null)?
                    SizedBox(
                      height: Get.height/5.h,
                    ):SizedBox();
                    });}
    else{
      return SizedBox();
    }}),

                  Obx(() {
                      return (whereToController.branches.length == 1)
                          ? SizedBox()
                          : Text(
                              "branches".tr,
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            );
                    }),
                    Obx(() {
                      return ListView.builder(
                          shrinkWrap: true,
                          // padding: EdgeInsets.only(top: 15.h,right: 10.w,left: 10.w),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: whereToController.branches.toSet().length,
                          itemBuilder: (context, index) {
                            if (whereToController.branches.length == 1) {
                              print("empty");
                              return const SizedBox();
                            } else {
                              if (index == 0) {
                                return const SizedBox();
                              } else {
                                return InkWell(
                                  onTap: () {
                                    MapUtils.openMap(
                                        double.parse(
                                            whereToController.branches[index].lat ??
                                                ""),
                                        double.parse(
                                            whereToController.branches[index].lng ??
                                                ""));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15.h),
                                    margin: EdgeInsets.only(top: 15.h),
                                    width: ScreenUtil().screenWidth,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: mainColor,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_sharp,
                                          size: 30.r,
                                          color: kPrimaryColor,
                                        ),
                                        SizedBox(
                                          width:
                                              ScreenUtil.defaultSize.width - 50.w,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                             // Obx(()=>
                                                 Text(
                                                   '${CacheHelper.getDataToSharedPrefrence('restaurantBranchID')}'.tr,

                                                   style: TextStyle(fontSize: 16.sp),
                                                   overflow: TextOverflow.visible,
                                                 // )
                                              //    Text('${
                                              //     whereToController
                                              //         .branches[index].name}'.tr,
                                              //   style: TextStyle(fontSize: 16.sp),
                                              //   overflow: TextOverflow.visible,
                                              // ),
                                              ),
                                              CacheHelper.getDataToSharedPrefrence('restaurantBranchName').toString()!=null?
                                              Text(
                                                '${CacheHelper.getDataToSharedPrefrence('restaurantBranchName')}'.tr,

                                                style: TextStyle(fontSize: 16.sp),
                                                overflow: TextOverflow.visible,
                                              ):SizedBox(),
                                              // CacheHelper.getDataToSharedPrefrence('restaurantBranchAddress').toString()!=null?
                                              // Text(
                                              //   '${CacheHelper.getDataToSharedPrefrence('restaurantBranchAddress')}'.tr,
                                              //
                                              //   style: TextStyle(fontSize: 16.sp),
                                              //   overflow: TextOverflow.visible,
                                              // ):SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                          });
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return (moreInfoController.restaurantPhoneNumbers.isEmpty)
                          ? const SizedBox()
                          : Text(
                              "contact_us".tr,
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            );
                    }),
                    Obx(() {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              moreInfoController.restaurantPhoneNumbers.toSet().length,
                              // moreInfoController.restaurantPhoneNumbers.length,
                          itemBuilder: (context, index) {
                            return (moreInfoController
                                        .restaurantPhoneNumbers[index] !=
                                    'null')
                                ? InkWell(
                                    onTap: () {
                                      MapUtils.makePhoneCall(moreInfoController
                                          .restaurantPhoneNumbers[index]
                                          .toString());
                                    },
                                    child: Card(
                                      shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      elevation: 3,
                                      color: mainColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 30.r,
                                              color: kPrimaryColor,
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Text(
                                              moreInfoController
                                                  .restaurantPhoneNumbers[index]
                                                  .toString(),
                                              style: TextStyle(fontSize: 16.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                          });
                    }),

                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "socials".tr,
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        MapUtils.launchInBrowser(moreInfoController
                            .restaurantMoreInfo!.facebook
                            .toString());
                        // moreInfoController.getRestaurantMoreInfo();
                      },
                      child: Card(
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        color: mainColor,
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.facebook_sharp,
                                size: 30.r,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                "facebook".tr,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        MapUtils.launchInBrowser(moreInfoController
                            .restaurantMoreInfo!.instagram
                            .toString());
                      },
                      child: Card(
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        color: mainColor,
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Row(
                            children: [
                              // Image.asset("assets/images/instagram.svg",
                              //     width: 30.w, height: 30.w),
                              FaIcon(FontAwesomeIcons.instagram,
                                  size: 30.r, color: Colors.blue),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                "instagram".tr,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        MapUtils.launchInBrowser(moreInfoController
                            .restaurantMoreInfo!.website
                            .toString());
                      },
                      child: Card(
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 3,
                        color: mainColor,
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FaIcon(FontAwesomeIcons.globe,
                                  size: 30.r, color: Colors.blue),
                              SizedBox(
                                width: 20.w,
                              ),
                              Text(
                                k.restWebSite.tr,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),



                    /***********************v***/
                    // Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Container(
                    //         padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10.0),
                    //             color: mainColor,
                    //             border: Border.all()),
                    //         child: new Theme(
                    //           data: Theme.of(context).copyWith(
                    //             canvasColor: mainColor,
                    //           ),
                    //           child:DropdownButton(
                    //               dropdownColor: mainColor,
                    //               icon: Icon(Icons.language),
                    //               iconSize: 25,
                    //               underline: SizedBox(),
                    //               items: [
                    //                 DropdownMenuItem(
                    //                   child: Text('en'.tr.toUpperCase()),
                    //                   value: 'en',
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   child: Text('ar'.tr.toUpperCase()),
                    //                   value: 'ar',
                    //                 ),
                    //               ],
                    //               value: mainBranchesController.selectedValue,
                    //               onChanged: (value) {
                    //                 mainBranchesController.switchFunc(value);
                    //                 Get.updateLocale(Locale(mainBranchesController.selectedValue));
                    //                 if (mainBranchesController.selectedValue == 'ar') {
                    //                   CacheHelper.saveDataToSharedPrefrence("localeIsArabic", true);
                    //                 } else {
                    //                   CacheHelper.saveDataToSharedPrefrence(
                    //                       "localeIsArabic", false);
                    //                 }
                    //               }),))),
                    // /***********************v***/
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () async {
                    //         if (CacheHelper.getDataToSharedPrefrence(
                    //                 "localeIsArabic") ==
                    //             true) {
                    //           Get.updateLocale(const Locale("en"));
                    //           await CacheHelper.saveDataToSharedPrefrence(
                    //               "localeIsArabic", false);
                    //         }
                    //
                    //         /**************m*******/
                    //
                    //         // CacheHelper.saveDataToSharedPrefrence("localeIsArabic", false);
                    //         // Get.updateLocale( Locale("en"));
                    //
                    //
                    //       },
                    //       child: Text(
                    //         'English',
                    //         style: TextStyle(
                    //             fontSize: 20,
                    //             color: (CacheHelper.getDataToSharedPrefrence(
                    //                         "localeIsArabic") ==
                    //                     true)
                    //                 ? mainColor
                    //                 : Colors.grey),
                    //       ),
                    //     ),
                    //
                    //     const Spacer(),
                    //     InkWell(
                    //         onTap: () async {
                    //           if (CacheHelper.getDataToSharedPrefrence(
                    //                   "localeIsArabic") ==
                    //               false) {
                    //             Get.updateLocale(const Locale("ar"));
                    //             await CacheHelper.saveDataToSharedPrefrence(
                    //                 "localeIsArabic", true);
                    //           }
                    //
                    //           // Get.reset();
                    //           // categoriesController.getCategories();
                    //         },
                    //         child: Text(
                    //           'arabic'.tr,
                    //           style: TextStyle(
                    //               fontSize: 20,
                    //               color: !(CacheHelper.getDataToSharedPrefrence(
                    //                           "localeIsArabic") ==
                    //                       true)
                    //                   ? mainColor
                    //                   : Colors.grey),
                    //         )),
                    //   ],
                    // ),
                    SizedBox(
                      height: 20.h,
                    ),
                    /***********************v***/


    Center(
      child: Button(
        isFramed: false,
      text: 'delete_account'.tr,
          fontSize: 14,
          // size: 50,
          size: Get.width/3,
          height:Get.height/20.h,

      onPressed: ()async {
        if (CacheHelper.loginShared == null) {
          Get.defaultDialog(
              title: 'error'.tr,
              content: Text('no_account'.tr));
        } else {
          Get.defaultDialog(
            title: 'delete_account_alert'.tr,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child: Text(
                      'yes'.tr,
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    onPressed: () async {
                      await FirebaseDatabase.instance
                          .reference()
                          .child('Cart')
                          .child(CacheHelper
                          .getDataToSharedPrefrence(
                          'restaurantBranchID'))
                      // .child(CacheHelper.loginShared!.phone
                          .child(CacheHelper
                          .getDataToSharedPrefrence(
                          'userID'))
                      // .child(CacheHelper
                      // .getDataToSharedPrefrence(
                      //     'dateOfTheOrder'))
                      // .child(CacheHelper.loginShared!.phone
                      //     .toString())
                          .remove()
                          .then((_) async {
                        await FirebaseDatabase.instance
                            .reference()
                            .child('Orders')
                            .child(CacheHelper
                            .getDataToSharedPrefrence(
                            'restaurantBranchID'))
                        // .child(CacheHelper.loginShared!.phone
                        //     .toString())
                            .remove()
                            .then((_) async {
                          await FirebaseDatabase.instance
                              .reference()
                              .child('User_Orders')
                              .child(CacheHelper
                              .getDataToSharedPrefrence(
                              'restaurantBranchID'))
                              .child(CacheHelper
                              .getDataToSharedPrefrence(
                              'userID'))
                          // .child(CacheHelper
                          //     .getDataToSharedPrefrence(
                          //         'dateOfTheOrder'))
                          // .child(CacheHelper
                          //     .loginShared!.phone
                          //     .toString())
                              .remove()
                              .then((_) async {
                            await FirebaseDatabase.instance
                                .reference()
                                .child('Users')
                                .child(CacheHelper
                                .getDataToSharedPrefrence(
                                'userID'))
                            // .child(CacheHelper
                            //     .loginShared!.phone
                            //     .toString())
                                .remove();
                            await FirebaseAuth.instance.currentUser!.delete()

                                .then((_) async {
                            setState(() {
                            cartController.update();
                            whereToController.update();
                            });
                              await CacheHelper
                                  .saveDataToSharedPrefrence(
                                  "user", null);
                              final user = await FirebaseAuth.instance;
                              user.currentUser!.delete();
                               setState(() {
                                CacheHelper.loginShared = null;
                                cartController.cartItemList2
                                    .clear();

                                order != null
                                    ? order!.list_of_product
                                    .clear()
                                    : null;
                                signUpController
                                    .fullPhoneNumber = '';
                                signUpController
                                    .pinTextEditingController
                                    .clear();
                                signUpController
                                    .phoneTextEditingController
                                    .clear();
                              });
                            });
                          });
                        });
                      });
                      Get.back();
                      Get.snackbar(
                          '', 'deletion_successful'.tr);
                    }),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'no'.tr,
                      style: TextStyle(color: kPrimaryColor),
                    )),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          );
        }
      }),
    ),
                    SizedBox(height: 20.h,),
                    // Center(
                    //   child: TextButton(
                    //       style: ButtonStyle(
                    //         foregroundColor:
                    //             MaterialStateProperty.all(kSecondaryColor),
                    //         backgroundColor: MaterialStateProperty.all(mainColor),
                    //       ),
                    //       onPressed: () {
                    //         if (CacheHelper.loginShared == null) {
                    //           Get.defaultDialog(
                    //               title: 'error'.tr,
                    //               content: Text('no_account'.tr));
                    //         } else {
                    //           Get.defaultDialog(
                    //             title: 'delete_account_alert'.tr,
                    //             content: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 TextButton(
                    //                     child: Text(
                    //                       'yes'.tr,
                    //                       style: TextStyle(color: kPrimaryColor),
                    //                     ),
                    //                     onPressed: () async {
                    //                       await FirebaseDatabase.instance
                    //                           .reference()
                    //                           .child('Cart')
                    //                           .child(CacheHelper
                    //                               .getDataToSharedPrefrence(
                    //                                   'restaurantBranchID'))
                    //                           // .child(CacheHelper.loginShared!.phone
                    //                           .child(CacheHelper
                    //                               .getDataToSharedPrefrence(
                    //                                   'userID'))
                    //                           // .child(CacheHelper
                    //                               // .getDataToSharedPrefrence(
                    //                               //     'dateOfTheOrder'))
                    //                           // .child(CacheHelper.loginShared!.phone
                    //                           //     .toString())
                    //                           .remove()
                    //                           .then((_) async {
                    //                         await FirebaseDatabase.instance
                    //                             .reference()
                    //                             .child('Orders')
                    //                             .child(CacheHelper
                    //                                 .getDataToSharedPrefrence(
                    //                                     'restaurantBranchID'))
                    //                             // .child(CacheHelper.loginShared!.phone
                    //                             //     .toString())
                    //                             .remove()
                    //                             .then((_) async {
                    //                           await FirebaseDatabase.instance
                    //                               .reference()
                    //                               .child('User_Orders')
                    //                               .child(CacheHelper
                    //                                   .getDataToSharedPrefrence(
                    //                                       'restaurantBranchID'))
                    //                               .child(CacheHelper
                    //                                   .getDataToSharedPrefrence(
                    //                                       'userID'))
                    //                               // .child(CacheHelper
                    //                               //     .getDataToSharedPrefrence(
                    //                               //         'dateOfTheOrder'))
                    //                               // .child(CacheHelper
                    //                               //     .loginShared!.phone
                    //                               //     .toString())
                    //                               .remove()
                    //                               .then((_) async {
                    //                             await FirebaseDatabase.instance
                    //                                 .reference()
                    //                                 .child('Users')
                    //                                 .child(CacheHelper
                    //                                     .getDataToSharedPrefrence(
                    //                                         'userID'))
                    //                                 // .child(CacheHelper
                    //                                 //     .loginShared!.phone
                    //                                 //     .toString())
                    //                                 .remove()
                    //                                 .then((_) async {
                    //                               await CacheHelper
                    //                                   .saveDataToSharedPrefrence(
                    //                                       "user", null);
                    //                               final user = await FirebaseAuth.instance;
                    //                               user.currentUser!.delete();
                    //                               setState(() {
                    //                                 CacheHelper.loginShared = null;
                    //                                 cartController.cartItemList2
                    //                                     .clear();
                    //
                    //                                 order != null
                    //                                     ? order!.list_of_product
                    //                                         .clear()
                    //                                     : null;
                    //                                 signUpController
                    //                                     .fullPhoneNumber = '';
                    //                                 signUpController
                    //                                     .pinTextEditingController
                    //                                     .clear();
                    //                                 signUpController
                    //                                     .phoneTextEditingController
                    //                                     .clear();
                    //                               });
                    //                             });
                    //                           });
                    //                         });
                    //                       });
                    //                       Get.back();
                    //                       Get.snackbar(
                    //                           '', 'deletion_successful'.tr);
                    //                     }),
                    //                 TextButton(
                    //                     onPressed: () {},
                    //                     child: Text(
                    //                       'no'.tr,
                    //                       style: TextStyle(color: kPrimaryColor),
                    //                     )),
                    //                 SizedBox(
                    //                   height: 50.h,
                    //                 ),
                    //               ],
                    //             ),
                    //           );
                    //         }
                    //       },
                    //       child: Text(
                    //         'delete_account'.tr,
                    //         style: TextStyle(color: kPrimaryColor),
                    //       )),
                    // ),
                  ],
                );})
              ),
            ),
            /******points******/

            FutureBuilder(
            future: cartController.getUserPoints() ,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError){
               return SizedBox();
                }
                else if( cartController.totalPoints!=0&& cartController.totalPoints!='0'&&cartController.forsale!=null&& cartController.totalPoints!=null){
                  return GetBuilder<MoreInfoController>(
            init: MoreInfoController(),
            builder: (controller){
                 return Positioned(
                  child: new Container(
                    height: Get.height/4.5.h,
                    color: kPrimaryColor,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10.h,
                          right: 50.w,
                          left: 30.w,
                          child: Column(
                            children: [
                              // SizedBox(height: 5.h,),
                              Card(
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r))),
                                  elevation: 3,
                                  color: mainColor,
                                  child:      Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: [

                                   Text('balance'.tr,style: TextStyle(fontSize: 14.sp),),
                                      cartController.balance!=null?
                                      Text('${cartController.balance.toStringAsFixed(2)}',style: TextStyle(height: 2, fontSize: 14.sp),):Text('0'),
                                    ],
                                  )),
                              Card(
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15))),
                                  elevation: 3,
                                  color: mainColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: [
                                Text('your_points'.tr,style: TextStyle(fontSize: 14.sp),),
                                      cartController.balance!=null?
                                      Text('${cartController.totalPoints}',style: TextStyle(height: 2, fontSize: 14.sp)):Text('0'),
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: mainColor,
                                    radius: 20.w,
                                    child: IconButton(
                                      onPressed: () {


                                        Get.to(BarcodeScreen());
                                      },
                                      icon: ImageIcon(
                                        AssetImage("assets/icons/gift.png"),
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: mainColor,
                                    radius: 20.w,
                                    child: IconButton(
                                        onPressed: () {
                                          Get.to(ChatScreen());
                                        },
                                        icon: Icon(
                                          Icons.chat,
                                          size: 20.sp,
                                          color: kPrimaryColor,
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: InkWell(
                            onTap: (){
                              print('helo');
                              print(CacheHelper.loginShared!.phone);
                              // print(CacheHelper.getDataToSharedPrefrence('phone2'));
                              print('*******${FirebaseAuth.instance.currentUser!.phoneNumber}');
                            },
                            child: CircleAvatar(
                              backgroundColor: kSecondaryColor,
                              backgroundImage: AssetImage(
                                  'assets/images/point.png'),
                              radius: 45.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ); }else{
               return   SizedBox();
                }


                },),
        ])
      ),

        floatingActionButton:   Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),child: ScrollingFabAnimated(
          icon: Icon(
            Icons.contact_support_outlined,
            color: Colors.white,
            semanticLabel: ' Feedback',
            size: 25.sp,
          ),
          text: Text(
            'Feedback',
            style: TextStyle(color: Colors.white, fontSize: 18.0.sp, fontWeight: FontWeight.w400),
          ),
          onPress: () {
            showModalBottomSheet<void>(
                      barrierColor: kPrimaryColor.withOpacity(.49),
                      backgroundColor: mainColor,
                      isScrollControlled: true,
                      context: context,
                       transitionAnimationController: transitionAnimationController,
                       builder: (BuildContext context) {
                        return  AnimatedContainer(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                // color: Colors.white,

                                borderRadius: BorderRadius.circular(30)),
                            duration: Duration(milliseconds: 400),
                            child:  Padding(
                                padding:
                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child:AnimatedCrossFade(
                            firstChild:  Form(
                                  key: moreInfoController.formKey,
                                  child: GetBuilder<MoreInfoController>(
                                    init: MoreInfoController(),
                                    builder: (controller) => Padding(
                                      padding:   EdgeInsets.all(10.0.sp),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            autofocus: true,
                                            // controller.passwordVisible.value,
                                            maxLines: 4,
                                            controller:
                                            controller.feedbackMessageController,
                                            decoration:  InputDecoration(
                                              hintText: 'send_feedback'.tr,
                                              labelStyle: TextStyle(color: kPrimaryColor),
                                              isDense: true,
                                              // Added this
                                              contentPadding: EdgeInsets.all(13.w),
                                              hintStyle: TextStyle(color: kPrimaryColor),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(

                                                  color: Colors.red,
                                                ),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(width: 2.w,
                                                  color: kPrimaryColor,
                                                ),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: kPrimaryColor,
                                                ),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: kPrimaryColor,
                                                ),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              filled: true,

                                            ),

                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please enter some text';
                                              }
                                              return null;
                                            },
                                          ),
                                          Button(
                                            text: 'send_feedback'.tr,
                                            size: 250,
                                            height:Get.height/20.h,
                                            onPressed: ()async {
                                              if (moreInfoController.formKey.currentState!.validate()) {
                                                if (CacheHelper.loginShared == null) {
                                                showLoaderDialog(context);
                                                Get.offAll(SignUpScreen());
                                              }else{
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("FeedbackMessages")
                                                  .push()
                                                  .set({'feedbackMessage':moreInfoController.feedbackMessageController.text,
                                                  'userName' :CacheHelper.loginShared!.name,
                                                  'userPhone':CacheHelper.loginShared!.phone,
                                              }).then((value) {
                                                Navigator.of(context).pop();
                                              });
                                                }
                                              }
                                              else{
                                                Get.snackbar('error'.tr, '',
                                                    snackPosition: SnackPosition.TOP,
                                                    backgroundColor: kPrimaryColor,
                                                    duration: Duration(seconds: 2),
                                                    dismissDirection: DismissDirection.startToEnd,
                                                    barBlur: 10,
                                                    colorText: mainColor);
                                              }
                                                  moreInfoController.feedbackMessageController.clear();
                                            },

                                            isFramed: false,)
                                        ],
                                      ),
                                    ),
                                    )
                        ),   duration: Duration(milliseconds: 400),
                              secondChild: SizedBox(),
                              crossFadeState: CrossFadeState.showFirst,

                        )));});


          },
          scrollController: _scrollController,
          animateIcon: true,
          inverted: false,width: Get.width/3,
          // radius: 30.0,

        )
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: (){
      //      showModalBottomSheet<void>(
      //       barrierColor: kPrimaryColor.withOpacity(.49),
      //       backgroundColor: mainColor,
      //       isScrollControlled: false,
      //       context: context,
      //        transitionAnimationController: transitionAnimationController,
      //        builder: (BuildContext context) {
      //         return  AnimatedContainer(
      //             margin: EdgeInsets.all(20),
      //             decoration: BoxDecoration(
      //                 // color: Colors.white,
      //                 borderRadius: BorderRadius.circular(30)),
      //             duration: Duration(milliseconds: 400),
      //             child: AnimatedCrossFade(
      //             firstChild:  Form(
      //                   key: moreInfoController.formKey,
      //                   child: GetBuilder<MoreInfoController>(
      //                     init: MoreInfoController(),
      //                     builder: (controller) => Padding(
      //                       padding:   EdgeInsets.all(10.0.sp),
      //                       child: Column(
      //                         mainAxisSize: MainAxisSize.min,
      //                         children: [
      //                           TextFormField(
      //                             // obscureText:
      //                             // controller.passwordVisible.value,
      //                             maxLines: 4,
      //                             controller:
      //                             controller.feedbackMessageController,
      //                             decoration:  InputDecoration(
      //                               hintText: 'send_feedback'.tr,
      //                               labelStyle: TextStyle(color: kPrimaryColor),
      //                               isDense: true,
      //                               // Added this
      //                               contentPadding: EdgeInsets.all(13.w),
      //                               hintStyle: TextStyle(color: kPrimaryColor),
      //                               border: OutlineInputBorder(
      //                                 borderSide: BorderSide(
      //
      //                                   color: Colors.red,
      //                                 ),
      //                                 borderRadius: BorderRadius.circular(8.r),
      //                               ),
      //                               focusedBorder: OutlineInputBorder(
      //                                 borderSide: BorderSide(width: 2.w,
      //                                   color: kPrimaryColor,
      //                                 ),
      //                                 borderRadius: BorderRadius.circular(8.r),
      //                               ),
      //                               enabledBorder: OutlineInputBorder(
      //                                 borderSide: BorderSide(
      //                                   color: kPrimaryColor,
      //                                 ),
      //                                 borderRadius: BorderRadius.circular(8.r),
      //                               ),
      //                               disabledBorder: OutlineInputBorder(
      //                                 borderSide: BorderSide(
      //                                   color: kPrimaryColor,
      //                                 ),
      //                                 borderRadius: BorderRadius.circular(8.r),
      //                               ),
      //                               filled: true,
      //
      //                             ),
      //
      //                             validator: (value) {
      //                               if (value == null || value.isEmpty) {
      //                                 return 'Please enter some text';
      //                               }
      //                               return null;
      //                             },
      //                           ),
      //                           Button(
      //                             text: 'send_feedback'.tr,
      //                             size: 250,
      //                             height:Get.height/20.h,
      //                             onPressed: ()async {
      //                               if (moreInfoController.formKey.currentState!.validate()) {
      //                                 if (CacheHelper.loginShared == null) {
      //                                 showLoaderDialog(context);
      //                                 Get.offAll(SignUpScreen());
      //                               }else{
      //                               FirebaseDatabase.instance
      //                                   .reference()
      //                                   .child("FeedbackMessages")
      //                                   .push()
      //                                   .set({'feedbackMessage':moreInfoController.feedbackMessageController.text,
      //                                   'userName' :CacheHelper.loginShared!.name,
      //                                   'userPhone':CacheHelper.loginShared!.phone,
      //                               }).then((value) {
      //                                 Navigator.of(context).pop();
      //                               });
      //                                 }
      //                               }
      //                               else{
      //                                 Get.snackbar('error'.tr, '',
      //                                     snackPosition: SnackPosition.TOP,
      //                                     backgroundColor: kPrimaryColor,
      //                                     duration: Duration(seconds: 2),
      //                                     dismissDirection: DismissDirection.startToEnd,
      //                                     barBlur: 10,
      //                                     colorText: mainColor);
      //                               }
      //                                   moreInfoController.feedbackMessageController.clear();
      //                             },
      //
      //                             isFramed: false,)
      //                         ],
      //                       ),
      //                     ),
      //                     )
      //         ),   duration: Duration(milliseconds: 400),
      //               secondChild: SizedBox(),
      //               crossFadeState: CrossFadeState.showFirst,
      //
      //         ));
      //
      //
      //       },
      //     );
      //     /************ttt****************/
      //
      //
      //   },
      //   label: AnimatedSwitcher(
      //     duration: Duration(seconds: 1),
      //     transitionBuilder: (Widget child, Animation<double> animation) =>
      //         FadeTransition(
      //           opacity: animation,
      //           child: SizeTransition(
      //             child: child,
      //             sizeFactor: animation,
      //             axis: Axis.horizontal,
      //           ),
      //         ),
      //     child:  isFABExtended
      //         ?   Image.asset('assets/icons/like-10442.png',width: 35.w,height: 100.h,color: Colors.white,)
      //       : Row(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(right: .0),
      //           child: Image.asset('assets/icons/like-10442.png',width: 25.w,height: 70.h,color: Colors.white,)
      //           // child: Icon(Icons.check),
      //         ),
      //         Text(" Feedback",style: TextStyle(fontSize: 16.sp),)
      //       ],
      //     ),
      //   ),
      ),

    ));

  }


}
