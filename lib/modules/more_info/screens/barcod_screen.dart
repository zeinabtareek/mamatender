import 'package:arrows/main.dart';
import 'package:arrows/modules/more_info/models/barcode_used.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:arrows/constants/colors.dart';

import '../../../components/arrows_app_bar.dart';
import '../../../components/custom_address_text_field.dart';
import '../../../components/custom_button.dart';
import '../../../constants/styles.dart';
import '../../../helpers/shared_prefrences.dart';
import '../controllers/more_info_controller.dart';
import '../models/BarcodModel.dart';
import '../services/more_info_service.dart';
class BarcodeScreen extends StatefulWidget {
  BarcodeScreen({Key? key}) : super(key: key);

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  MoreInfoController controller = Get.put(MoreInfoController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final translateName =
        CacheHelper.getDataToSharedPrefrence("localeIsArabic");
    return Scaffold(
      appBar: ArrowsAppBar('barcodes'.tr),

      body: Column(

        children: [
          // TextButton(onPressed: ()async{
          //   var x=await FirebaseAuth.instance.currentUser!.phoneNumber;
          //   print(x);
          //   print(CacheHelper.getDataToSharedPrefrence('phone'));
          //   print(CacheHelper.loginShared!.phone);
          //   print(CacheHelper.loginShared!.password);
          //   controller.getBarcodes();
          //
          // }, child: Text('dddd')),
          FutureBuilder (
            future:  controller.getBarcodes(),
               builder: (context, AsyncSnapshot snapshot) {
               if(snapshot.hasData){
                 return
                   // controller.barcodModel!.data!.length!=0?
              GetBuilder<MoreInfoController>(init:MoreInfoController() ,
                  builder:(controller)=>  controller.isLoading.value==false?
                  GridView.builder(
                shrinkWrap: true,
                itemCount: controller.barcodModel!.data!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (orientation == Orientation.portrait)
                        ? 2
                        : 3),
                itemBuilder: (BuildContext context, int index) {
                  return
                    Container(
                      decoration: CommonStyles.customBoxDecoration,
                      margin: EdgeInsets.all(20.sp),
                      padding: EdgeInsets.all(10.sp),
                      width: 100.w,
                      height: 200.h,
                      child: InkWell(
                        child:    Image.network(
                          "${controller.barcodModel!.data?[index].imgLink}",
                          fit: BoxFit.fill,
                        ) ,
                        onTap: () {
                          print('%%%%%%%%%');
                          print(controller.barcodModel!.data?[index].id);
                          print(CacheHelper.loginShared!.phone);
                          showModalBottomSheet<void>(
                            barrierColor: kPrimaryColor.withOpacity(.49),
                            backgroundColor: mainColor,
                            isScrollControlled: false,
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                  heightFactor: 1.4,
                                  child: ListView(
                                    shrinkWrap: true,
                                      children: [
                                    Container(
                                      decoration: CommonStyles
                                          .customBoxDecoration,
                                      margin: EdgeInsets.only(
                                          bottom: 10.0.h,
                                          right: 20.w,
                                          left: 20.w),
                                      padding: EdgeInsets.all(10.sp),
                                      width: 150.w,
                                      height: 400.h,
                                      child: Image.network(
                                        "${controller.barcodModel!.data?[index]
                                            .imgLink}",
                                        fit: BoxFit.fill,
                                        width: 100,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10.0.h,
                                          right: 30.w,
                                          left: 30.w),
                                      child: Form(
                                        key: formKey,

                                        child: Obx(() =>
                                            Column(
                                              children: [
                                                TextFormField(
                                                  obscureText:
                                                  controller.passwordVisible
                                                      .value,
                                                  controller:
                                                  controller.barcodeController,
                                                  decoration: passwordInputDecoration(
                                                      controller.passwordVisible
                                                          .value,
                                                          () {
                                                        controller
                                                            .changevisibility();
                                                      }),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ), Button(
                                                  text: 'use_barcode'.tr,
                                                  size: 250,
                                                  height: Get.height/20.h,
                                                  onPressed: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {}
                                                    if (controller
                                                        .barcodeController
                                                        .text == '1010') {

                                                     controller.usedBarcodes(context,controller.barcodModel!.data![index].id ).then((value) {
                                                       print(')))))))))))');
                                                       setState(() {

                                                       controller.getBarcodes();
                                                       controller.update();
                                                       });
                                                      print('${controller.barcodModel!.data!.length}');
                                                       controller
                                                           .barcodeController
                                                           .clear();
                                                       Get.snackbar('user_barcode_inserted_successfully'.tr,
                                                           '',
                                                           snackPosition: SnackPosition
                                                               .TOP,
                                                           backgroundColor: kPrimaryColor,
                                                           duration: Duration(
                                                               seconds: 2),
                                                           dismissDirection: DismissDirection
                                                               .startToEnd,
                                                           barBlur: 10,
                                                           colorText: mainColor);
                                                       Navigator.pop(
                                                       context);



                                                      });/*************5***************/

    // MoreInfoService services = MoreInfoService();
    // print('okaaay');
    // // await controller.usedBarcode(context,controller.barcodModel!.data?[index].id).then((value) {
    // await controller
    //     .usedBarcode(
    //     context  ,
    //   //
    //   controller.barcodModel!.data?[index].id
    // ).then((
    // value) {
    // print(CacheHelper
    //     .loginShared!
    //     .password);
    // print(controller
    //     .barcodModel!
    //     .data?[index].id);
    // print(
    // '####################');
    // Get.snackbar(
    // 'done'.tr,
    // 'user_barcode_inserted_successfully'
    //     .tr,
    // snackPosition: SnackPosition
    //     .TOP,
    // backgroundColor: kPrimaryColor,
    // duration: Duration(
    // seconds: 2),
    // dismissDirection: DismissDirection
    //     .startToEnd,
    // barBlur: 10,
    // colorText: mainColor);
    //
    //
    // Navigator.pop(
    // context);
    // controller
    //     .barcodeController
    //     .clear();
    // });

                                                    }
                                                    else {
                                                      Get.snackbar('error'.tr,
                                                          '',
                                                          snackPosition: SnackPosition
                                                              .TOP,
                                                          backgroundColor: kPrimaryColor,
                                                          duration: Duration(
                                                              seconds: 2),
                                                          dismissDirection: DismissDirection
                                                              .startToEnd,
                                                          barBlur: 10,
                                                          colorText: mainColor);
                                                    }

                                                    controller.barcodeController
                                                        .clear();
                                                  },
                                                  isFramed: false,)
                                              ],
                                            ),
                                        ),
                                      ),
                                    ),

                                  ]));
                            },
                          );
                        },
                      ) );
                  })

              :Center(child: CircularProgressIndicator(color: mainColor,)));}else{
                 return
                 Column(
                   children: [
                     Image.asset(
                       'assets/images/scan-removebg-preview.png',
                       height: 300.h ,
                       color: mainColor,
                       width: double.infinity,
                     ),
                     Center(
                         child: Text(
                           "no_barcodes".tr,
                           style: TextStyle(
                               fontSize: 25.sp,
                               color: mainColor,
                               fontWeight: FontWeight.bold),
                         )),

                   ],
                 );

              }
              // else{
              //   return
              //   Center(child: CircularProgressIndicator(color: mainColor,),);
              //

              // }
              }

              )

        ],
      ),
    );
  }

  InputDecoration passwordInputDecoration(
          passwordVisible, VoidCallback onPressed) =>
      InputDecoration(
        hintText: 'enter_barcode'.tr,
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
        suffixIcon: IconButton(
            splashColor: Colors.transparent,
            icon: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: kPrimaryColor,
            ),
            onPressed: onPressed),
      );
}
