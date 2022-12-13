import 'package:arrows/constants/colors.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/order_history/controllers/order_history_controller.dart';
import 'package:arrows/modules/order_history/screens/order_details_screen.dart';
 import 'package:arrows/modules/sub_categories/models/SubCategories.dart';
import 'package:arrows/shared_object/order_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../components/arrows_app_bar.dart';
import '../../../components/custom_button.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({Key? key}) : super(key: key);
  final OrderHistoryController orderHistoryController =
      Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    orderHistoryController.geHistoryData();
    orderHistoryController.dbRef == null
        ? orderHistoryController.hide.value = true
        : orderHistoryController.hide.value = false;
    final translateName =
        CacheHelper.getDataToSharedPrefrence("localeIsArabic");
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: ArrowsAppBar(
        "track_order".tr,
      ),
      body: SingleChildScrollView(
        child: (CacheHelper.loginShared == null)
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/ic_empty.png',
                    height: 500.h,
                    width: double.infinity,
                  ),
                  Center(
                      child: Text(
                    "no_orders".tr,
                    style: TextStyle(
                        fontSize: 25.sp,
                        color: mainColor,
                        fontWeight: FontWeight.bold),
                  )),
                ],
              )
            : Obx(() {
                return (orderHistoryController.hide.value)
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            'assets/images/ic_empty.png',
                            height: 500.h,
                            width: double.infinity,
                          ),
                          Center(
                              child: Text(
                            "no_orders".tr,
                            style: TextStyle(
                                fontSize: 25.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          ))
                        ],
                      )
                    : FutureBuilder(
                        future: orderHistoryController.geHistoryData(),
                        builder: (context, snapshot) {
                          return FirebaseAnimatedList(
                              reverse: true,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              query: orderHistoryController.dbRef,
                              itemBuilder: (
                                BuildContext context,
                                DataSnapshot snapshot,
                                Animation<double> animation,
                                int index,
                              ) {
                                if (!snapshot.exists) {
                                   return Center(
                                    child: Text(' no_orders'.tr),
                                  );
                                } else {
                                  final json =
                                      snapshot.value as Map<dynamic, dynamic>;
                                  Order order2 = Order.fromJson(json);
                                 final lista=<Products>[];
                                  lista.add(Products.fromJson(json));


                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 18.0),
                                      child: Directionality(
                                          textDirection: translateName
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          child: Card(
                                            elevation: 5,
                                            // color: mainColor,
                                            shadowColor: mainColor,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: mainColor, width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "order_time".tr,
                                                                style: TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        20.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                snapshot.value[
                                                                        "order_id"]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "total_price".tr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18.sp),
                                                              ),
                                                              Text(
                                                                double.parse(snapshot
                                                                            .value[
                                                                        "total_price"])
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "order_status".tr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18.sp),
                                                              ),
                                                              Text('${snapshot.value["order_status"]}'.tr,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18.sp),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: SizedBox(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    snapshot.value["order_status"].toString() !=
                                                                                "تم أرسال طلبك" &&
                                                                            snapshot.value["order_status"].toString() !=
                                                                                "قبول الطلب"
                                                                        ? SizedBox()
                                                                        : Button(
                                                                            isFramed:
                                                                                true,
                                                                            text:
                                                                                "cancel".tr,
                                                                            size:
                                                                                200,
                                                                            height:
                                                                                Get.height/20.h,
                                                                            fontSize: 14,
                                                                            onPressed:
                                                                                () async {
                                                                              FirebaseDatabase.instance.reference().child("Orders").
                                                                              child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
                                                                              .child(order2.orderId.toString()).remove();

                                                                              FirebaseDatabase.instance.reference().child("UserOrders")
                                                                                  .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
                                                                                  .child(CacheHelper.getDataToSharedPrefrence('userID'))
                                                                                  .child(order2.orderId.toString()).remove();
                                                                            },
                                                                          ),


                                                                    Button(
                                                                      isFramed:
                                                                      true,
                                                                      text:

                                                                        "order_details"
                                                                            .tr,
                                                                      size:
                                                                      200,
                                                                      height:
                                                                      Get.height/20.h,
                                                                      fontSize: 14,
                                                                      onPressed: ()   async {
                                                                        // print('${order.totalPrice}');
                                                                    Get.to(() =>

                                                                    OrderDetailsScreen(order: order2));
                                                                    },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          )));
                                }
                              });
                        });
              }),
      ),
    );
  }
}
