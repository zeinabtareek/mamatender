import 'dart:async';
import 'package:arrows/components/arrows_app_bar.dart';
import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/styles.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/main.dart';
import 'package:arrows/modules/add_address/screens/add_address_screen.dart';
import 'package:arrows/modules/reciept/screens/reciept_screen.dart';
import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:arrows/modules/where_to_deliver/models/firebase_address_model.dart';
import 'package:arrows/modules/where_to_deliver/screens/new_where_to_delivery.dart';
import 'package:arrows/shared_object/posted_order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../components/custom_button.dart';
import '../../../helpers/map_launch_helper.dart';
import '../controllers/map_controller.dart';

class WhereToDeliverScreen extends StatefulWidget {
  WhereToDeliverScreen({Key? key}) : super(key: key);

  @override
  State<WhereToDeliverScreen> createState() => _WhereToDeliverScreenState();
}

Future _mapFuture = Future.delayed(Duration(milliseconds: 250), () => true);

class _WhereToDeliverScreenState extends State<WhereToDeliverScreen> {
  final WhereToController whereToController = Get.put(WhereToController());
   Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    whereToController.getAllUserAddressees();

    return Scaffold(
      appBar: ArrowsAppBar(
        'checkOut_onOrder',
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
           Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  // Obx(() {
                  //   return
                  FutureBuilder(
                    future: whereToController.getAllBranchAddresses(),
                    builder: (context, snapShot) => Expanded(
                      child:    Button(
                        text: "  ${'receive_from'.tr} :",
                        size: 150,
                        fontSize: 14,
                        height:!landScape ? Get.height/20.h : 100.h,
                          isFramed: whereToController.showPickUpBranches.value
                              ? false
                              : true,
                          onPressed: () async {
                            PostedOrder.order.address =
                                null; //this is the cause of the crashing
                            PostedOrder.order.branch =
                                await whereToController.branches[1].name;
                            whereToController.showPickUpBranches.value = true;
                            print(
                                '%%%%%5${whereToController.showPickUpBranches.value}');

                          }),
                    ),
                  ),

                  SizedBox(
                    width: 10.w,
                  ),
                  FutureBuilder(
                      future: whereToController.getAllUserAddresseesv,
                      builder: (context, snapShot) => Expanded(
                            child:Button(
                            size: 150,
                        fontSize: 14,
                        height:!landScape ? Get.height/20.h : 100.h,
                              isFramed:
                                  whereToController.showPickUpBranches.value
                                      ? true
                                      : false,

                              text: "  ${'deliver_to'.tr} :",
                              onPressed: () async {
                                try {
                                  PostedOrder.order.branch = null;
                                  whereToController.showPickUpBranches.value =
                                      false;
                                  whereToController.showPickUpBranches.value=false;
                                  (whereToController.selectedUserAddress !=
                                              null &&
                                          whereToController.selectedUserAddress
                                              .address!.isNotEmpty)
                                      ? PostedOrder.order.address =
                                          whereToController.selectedUserAddress
                                      : printError(
                                          info: 'mnnnnnnnvnnnnnvvnvnvnvn');
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          )),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),

            // Obx(() {
            //   return
            Obx(
                  () => (whereToController.showPickUpBranches.value)
                  ?
            FutureBuilder(
                    future: whereToController.getAllBranchAddresses(),
                    builder: (context, snapShot) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "  ${'receive_from'.tr} :",
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
                                            InkWell(
                                            onTap: () {
                          MapUtils.openMap(
                          double.parse(
                           CacheHelper.getDataToSharedPrefrence('restaurantBranchLat') ??
                          ""),
                          double.parse(

                           CacheHelper.getDataToSharedPrefrence('restaurantBranchLng') ??
                          ""));
                          },
                            child:   Icon(
                              Icons.location_on_sharp,
                              size: 25.r,
                              color: kPrimaryColor,
                            ),
                          ),  Text('${'branch'.tr}  :',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,fontSize: 14.sp),
                                            ),
                                            Text(
                                                '${whereToController.branches[1].name}', style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 14.sp),
                                            ),
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
                                                  fontWeight: FontWeight.bold,fontSize: 14.sp),
                                            ),
                                            Container(
                                                // color: Colors.green,
                                                width:Get.width/1.5.w,
                                                child: Text(
                                                  '${CacheHelper.getDataToSharedPrefrence('restaurantBranchName')}',
                                                  style: TextStyle(
                                                      fontSize: 16.sp),overflow:TextOverflow.ellipsis ,
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
                  )
                : whereToController.dbref == null
                    ? SizedBox()
                    : GetBuilder<WhereToController>(
                        builder: (whereToController) =>
                            Container(
                              decoration: CommonStyles.customBoxDecoration,
                              // height: ScreenUtil().screenHeight,
                              margin: EdgeInsets.only(top: 20.h),
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
                                    return Obx(()=>RadioListTile(
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
                                        )));
                                  }),
                            )),),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Obx(
                    () => (whereToController.showPickUpBranches.value)
                        ? SizedBox()
                        : Button(
                            text: "add_new_address".tr,
                            size: 250,
                            height: Get.height/20.h,
                      fontSize: 14,

                      isFramed: true,
                            onPressed: () async {
                              Future.delayed(Duration(seconds:2), () {
                                // setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AddNewAddress()));
                              });
                              // });
                            },
                          ),
                  ),
                  Button(
                    text: "check_out".tr,
                    isFramed: false,
                      size: 250,
                    height: Get.height/20.h,
                    fontSize: 14,
                    onPressed: () {
                      if (whereToController.showPickUpBranches.value) {
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
      )),
    );
  }
}
