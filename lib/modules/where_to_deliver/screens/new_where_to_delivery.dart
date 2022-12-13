import 'dart:async';

import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../components/arrows_app_bar.dart';
import '../../../components/custom_button.dart';
import '../../../constants/colors.dart';
import '../../../constants/styles.dart';
import '../../../helpers/shared_prefrences.dart';
import '../../../shared_object/posted_order.dart';
import '../../add_address/screens/add_address_screen.dart';
import '../../reciept/screens/reciept_screen.dart';
import '../controllers/map_controller.dart';
import '../models/firebase_address_model.dart';

class WhereToDeliver2 extends StatelessWidget {
  Set<Marker> markers = {};
  final WhereToController whereToController = Get.put(WhereToController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          extendBodyBehindAppBar: true,

          appBar: ArrowsAppBar(
            'checkOut_onOrder',
          ),
          body: SafeArea(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,

              children: [
                SizedBox(height: 20.h,),
                TabBar(
                  indicatorColor: mainColor,
                  labelColor: mainColor,padding:EdgeInsets.only(top: 20,bottom: 20),
                  labelPadding: EdgeInsets.all(2),
                  unselectedLabelColor: kPrimaryColor,
                  onTap: (v) {},
                  labelStyle:
                  TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(  child: Button(
                      height: 60.h,
                      isFramed: true,
                      size: 200,
                      text: "  ${'receive_from'.tr} :",

                    )
                    ),
                    Tab(   child: Button(
                      height: 60.h,
                      isFramed: true,
                      size: 200,
                      text: "add_new_address".tr,)


                    ),

                  ],
                ),
                SizedBox(),
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Text(
                          "checkOut_onOrder_title".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp, color: mainColor),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TabBarView(
                        dragStartBehavior: DragStartBehavior.down,
                        children: [

                          DeliverFromTheBranch(),
                          DeliverToUserAddress(),

                        ],
                      ),
                    ],
                  ),
                ),
              ],

            ),
          )),
    );
  }

  Widget DeliverToUserAddress() {
    return (whereToController.showPickUpBranches.value)
        ?
            FutureBuilder(
                future: whereToController.getAllUserAddressees(),
                builder: (context, snapShot) =>  SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                    decoration: CommonStyles.customBoxDecoration,
                    margin: EdgeInsets.all(20),
                    // height: ScreenUtil().screenHeight,
                    width: ScreenUtil().screenWidth,
                    child: FirebaseAnimatedList(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        query: whereToController.dbref,
                        itemBuilder: (
                            BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index,
                            ) {
                          return RadioListTile(
                              groupValue:
                              whereToController.radioValue.value,
                              value: snapshot.value.toString(),
                              onChanged: (onChanged) async {
                                whereToController.radioValue.value =
                                    snapshot.value.toString();
                                PostedOrder.order.address =
                                    UserAddress.fromJson(
                                        snapshot.value
                                        as Map<dynamic, dynamic>);
                                whereToController
                                    .selectedUserAddress =
                                    UserAddress.fromJson(
                                        snapshot.value
                                        as Map<dynamic, dynamic>);
                                // whereToController.selectedAreaPrice =snapshot.value!['branch1']['price'];
                                whereToController
                                    .selectedAreaPrice.value =
                                snapshot.value['user_area']
                                ['price'];
                                var x = await CacheHelper
                                    .saveDataToSharedPrefrence(
                                    'dropdownAreaPrice',
                                    snapshot.value['user_area']
                                    ['price']);
                                print(whereToController
                                    .selectedAreaPrice.value);
                              },
                              title: Text(
                                "${snapshot.value["address"]} - ${snapshot.value['user_area']['area'] ?? ""}",
                                style: TextStyle(fontSize: 14.sp),
                              ));
                        }),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                         Button(
                            text: "add_new_address".tr,
                            size: 250,
                            height: 50,
                            isFramed: true,
                            onPressed: () async {
                              Future.delayed(Duration(seconds: 2), () {

                                Get.to( AddNewAddress());
                              });
                              // });
                            },
                          ),


                        Button(
                          text: "check_out".tr,
                          size: 250,
                          isFramed: false,
                          height: 50,
                          onPressed: () {
                            if (whereToController.showPickUpBranches.value)
                            {
                              CacheHelper.saveDataToSharedPrefrence(
                                  'dropDownValuePrice',
                                  whereToController.selectedDropDownValue?.price);

                              /**************KK****/
                              if (whereToController.branchDropDownValue!.name ==
                                  "اختار الفرع") {
                                Get.defaultDialog(
                                    title: "",
                                    content: Text(
                                      "برجاء اختر الفرع",
                                      style: TextStyle(fontSize: 14.sp),
                                    ));
                              } else {
                                Get.to(() => ReceiptScreen(
                                    selectedAreaPrice: whereToController
                                        .selectedDropDownValue?.price));
                              }
                              /**************KK****/
                            } else {
                              if (whereToController.radioValue.value == "") {
                                Get.defaultDialog(
                                    title: "",
                                    content: Text(
                                      "please_choose_branch".tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ));
                              } else {
                                Get.to(() => ReceiptScreen(
                                    selectedAreaPrice: (whereToController
                                        .selectedAreaPrice.value !=
                                        null)
                                        ? '${whereToController.selectedAreaPrice.value}'
                                        : 0.0));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))

        : SizedBox();
  }


  Widget DeliverFromTheBranch() {
    return FutureBuilder(
      future: whereToController.getAllBranchAddresses(),
      builder: (context, snapShot) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "  ${'receive_dfrom'.tr} :",
                style: TextStyle(fontSize: 14.sp, color: mainColor),
              ),
              //الاستلام من الفرع
              Padding(
                padding: EdgeInsets.all(15.w),
                child: Container(
                  padding: EdgeInsets.only(top: 15.h),
                  width: ScreenUtil().screenWidth,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: mainColor,
                    ),
                  ),
                  child: (snapShot.connectionState ==
                      ConnectionState.waiting)
                      ? Center(
                    child: CupertinoActivityIndicator(
                      radius: 20,
                      color: kPrimaryColor,
                    ),
                  )
                      : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.sp),
                        child: Row(
                          children: [
                            Text(
                              '${'branch'.tr}  :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                                '${whereToController.branches[1].name}'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 8.0.h,
                            left: 8.w,
                            right: 8.w),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              '${'your_address'.tr}  :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width /
                                    2.w,
                                child: Text(
                                  '${CacheHelper.getDataToSharedPrefrence(
                                      'restaurantBranchAddress')}',
                                  style: TextStyle(
                                      fontSize: 16.sp),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
