import 'package:arrows/components/arrows_app_bar.dart';
import 'package:arrows/components/loading_spinner.dart';
import 'package:arrows/constants/colors.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/add_address/controllers/add_address_controller.dart';
import 'package:arrows/modules/bottom_nav_bar/screens/bottom_nav_bar_screen.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/cart/models/copoun_response_model.dart';
import 'package:arrows/modules/cart/models/coupon_used_model.dart';
import 'package:arrows/modules/cart/services/coupon_used_body.dart';
import 'package:arrows/modules/cart/services/coupon_used_service.dart';
import 'package:arrows/modules/more_info/controllers/more_info_controller.dart';
import 'package:arrows/modules/more_info/screens/more_info_screen.dart';
import 'package:arrows/modules/payment/payment_screens/payment_screen.dart';
import 'package:arrows/modules/product_details2/model/ProductDetailsModel.dart';
import 'package:arrows/modules/sub_categories/controllers/sub_categories_controller.dart';
import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:arrows/shared_object/order_model.dart';
import 'package:arrows/shared_object/posted_order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:arrows/modules/payment/payment_controllers/payment_controller.dart';

import '../../more_info/models/barcode_used.dart';
import '../../more_info/services/more_info_service.dart';



class ReceiptScreen extends StatelessWidget {
  dynamic selectedAreaPrice = 0.0;

   ReceiptScreen({Key? key, required this.selectedAreaPrice}) : super(key: key);
  final CartController cartController = Get.put(CartController());
  final WhereToController whereToController = Get.find();
  final AddAddressController addAddressController =
      Get.put(AddAddressController());
  final MoreInfoController moreInfoController=Get.put(MoreInfoController());
  final PaymentController paymentController = Get.put(PaymentController());

  Future<void> usedCoupon(BuildContext context) async {
    CouponUsedBody couponUsedBody = await CouponUsedBody(
      couponCode: cartController.discountCodeTextController.text,
      phoneNumber: CacheHelper.loginShared!.phone,
    );
    dio.Response? response;
    response = await CouponUsedService.registerCouponUsed(couponUsedBody);
  }

  Order order = Order();

  @override
  Widget build(BuildContext context) {
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    cartController.discountValue.value = 0.0;
    cartController.isPercentage.value = false;
    cartController.getRestaurantFees();
    print(cartController.totalPrice.value);

      return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h), child: CustomAppBar(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: !landScape ? 350.h : 1300.h,
                  margin: EdgeInsets.only(top: 10.h, right: 10.w, left: 10.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: mainColor,
                        width: 3,
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: double.infinity,
                          color: mainColor,
                          child: Center(
                              child: Text(
                            'receipt'.tr.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.sp),
                          ))),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 15.h, right: 15.w, left: 15.w),
                            child: Column(
                              children: [
                                /*********priceRow******/
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'price'.tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    (cartController.fees.value!.tax != 'null' &&
                                            cartController.fees.value!.tax !=
                                                null)
                                        ? Text(
                                            '${((cartController.totalPrice.value / (((double.parse(cartController.fees.value!.tax.toString())) / 100) + 1))).toStringAsFixed(2)}    ',
                                            style: TextStyle(fontSize: 14.sp),
                                          )
                                        : Text('${cartController.totalPrice}'),
                                  ],
                                ),
                                /*********discountRow******/

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'discount'.tr,
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                        GetBuilder<CartController>(
                                            builder: (cartController) {
                                          return (cartController
                                                  .isPercentage.value)
                                              ? Text(
                                                  '( % ${cartController.discountResponse.data == null ? 0 : cartController.discountResponse.data!.value!.toString()} )',
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                )
                                              : SizedBox();
                                        }),
                                      ],
                                    ),
                                    GetBuilder<CartController>(
                                        builder: (cartController) {
                                      return Text(
                                        '${cartController.discountResponse.data == null ? 0 : cartController.discountValue.value.toString()} -  ',
                                        style: TextStyle(
                                            fontSize: 14.sp, color: Colors.red),
                                      );
                                    }),
                                  ],
                                ),
                                /*********FeesRow******/
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cartController.fees.value!.tax != 'null'
                                          ? '${'tax'.tr} ( % ${cartController.fees.value!.tax})'
                                          : '(${'tax'.tr} % 0)',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    (cartController.fees.value!.tax != 'null' ||
                                            cartController.fees.value!.tax !=
                                                null)
                                        ? Text(
                                            '${(cartController.totalPrice.value - //33.75

                                                // (cartController.totalPrice.value - (((cartController.fees.value!.tax != 'null' ? (cartController.totalPrice.value *double.parse(cartController.fees.value!.tax.toString())) : 0.0) / 100)      )))
                                                // .toStringAsFixed(2)
                                                (cartController.totalPrice.value / (((cartController.fees.value!.tax != 'null' ? (double.parse(cartController.fees.value!.tax.toString())) : 0.0) / 100) + 1))).toStringAsFixed(2)} + ',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.green),
                                          )
                                        :   Text('+ 0'  ,style: TextStyle(
                                        fontSize: 14.sp,
                                        color: kPrimaryColor),
                          )
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  endIndent: 5.w,
                                  indent: 5.w,
                                ),
                                /********TotalRow******/
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total'.tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Obx(() {
                                      return Text(
                                        '${((double.parse(cartController.totalPrice.value.toStringAsFixed(2))) - cartController.discountValue.value).toStringAsFixed(2)}    ',
                                        style: TextStyle(fontSize: 14.sp),
                                      );
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                /********deliveryRow******/

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'delivery'.tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    whereToController.showPickUpBranches == true
                                        ?   Text('   0   ' , style: TextStyle(
                                        fontSize: 14.sp,
                                        color: kPrimaryColor),
                          )
                                        : Text(
                                            '${selectedAreaPrice} + ',
                                            // '${(whereToController.selectedAreaPrice)} + ',
                                            // '${( whereToController.selectedAreaPrice)} + ',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.green),
                                          ),
                                  ],
                                ),
                                /*******service_feeRow******/
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cartController.fees.value!.feesValue !=
                                              'null'
                                          ? '${'service_fee'.tr} ( % ${cartController.fees.value!.feesValue})'
                                          : ' (الخدمة % 0.0)',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Text(
                                      '${(cartController.totalPrice.value * ((cartController.fees.value!.feesValue != 'null' ? double.parse(cartController.fees.value!.feesValue.toString()) : 0.0) / 100)).toStringAsFixed(2)} +  ',
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.green),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  endIndent: 5.w,
                                  indent: 5.w,
                                ),
                                /*******total_sumRow******/
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total_sum'.tr,
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    Obx(() {
                                      var x = selectedAreaPrice;


                                      return Text(
                                        '${(cartController.totalPrice.value + (whereToController.showPickUpBranches == true ? 0.0 : (num.tryParse(x)!)) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null' ? (double.parse(cartController.fees.value!.feesValue.toString()) / 100) : 0.0)) - cartController.discountValue.value).toStringAsFixed(2)} ',
                                        style: TextStyle(fontSize: 14.sp),
                                      );
                                    })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 3,
                          )),
                      child: Column(
                        children: [
                          Obx(() {
                            return Card(
                              child: RadioListTile(
                                activeColor: kPrimaryColor,
                                value: 2,
                                groupValue:
                                    whereToController.selectedPaymentType.value,
                                onChanged: (newValue) {
                                  whereToController.selectedPaymentType.value =
                                      newValue as int;
                                  cartController.wallet==false;
                                  cartController.wallet=false;
                                  print('the wallet is ${cartController.wallet}');

                                  print(newValue);
                                },
                                title: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/money.png',
                                      width: 25.r,
                                      height: 25.r,fit: BoxFit.fill,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text("cash_payment".tr , style: TextStyle(
                                        fontSize: 14.sp,
                                        color:kPrimaryColor),
                              ),
                                  ],
                                ),
                              ),
                              color: mainColor,
                            );
                          }),
                          FutureBuilder(
                              future: cartController.getUserPoints(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasError){
                                  return Text(' ');
                                  }
                                else if(cartController.totalPoints!=null&&cartController.totalPoints!=0&&cartController.totalPoints!=''&&cartController.totalPoints!='0'&&cartController.forsale!=0&&cartController.forsale!=null){

                                return Obx(() {
                                  return Card(
                                    child: RadioListTile(
                                      activeColor: kPrimaryColor,
                                      value:1,
                                      groupValue: whereToController
                                          .selectedPaymentType.value,
                                      onChanged: (value) {

                                     if ( cartController.balance<(cartController.totalPrice.value + (whereToController.showPickUpBranches == true ? 0.0 : (num.tryParse(selectedAreaPrice)!)) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null' ? (double.parse(cartController.fees.value!.feesValue.toString()) / 100) : 0.0)) - cartController.discountValue.value)) {
                                             value =null;
                                     }
                                     else{
                                       whereToController.selectedPaymentType
                                           .value = value as int;
                                       cartController.wallet==true;
                                       cartController.wallet=true;
                                       print('the wallet is ${cartController.wallet}');
                                      }

    },
                                      title: Row(
                                        children: [
                                          Image.asset(
                                             'assets/icons/wallet.png',
                                            width: 25.r,
                                            height: 25.r,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                        // selectedAreaPrice,
                                        ( cartController.balance<(cartController.totalPrice.value + (whereToController.showPickUpBranches == true ? 0.0 : (num.tryParse(selectedAreaPrice)!)) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null' ? (double.parse(cartController.fees.value!.feesValue.toString()) / 100) : 0.0)) - cartController.discountValue.value))?
                                   Container(
                                           child: Text("${"wallet_balance".tr}\n (${'You_cannot_pay_by_wallet_currently'.tr})",style: TextStyle(fontSize: 12.sp, decoration: TextDecoration.lineThrough,),))
                                    :  Text("wallet_balance".tr , style: TextStyle(
                                            fontSize: 14.sp,
                                            color:kPrimaryColor),
                                    )     ],
                                      ),
                                    ),
                                    color: mainColor,
                                  );
                                });
                              }else{
                                  return SizedBox();
                                }
                          }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.w),
                  child: TextField(
                    controller: cartController.messageTextController,
                    maxLines: 2,
                    style: TextStyle(color: mainColor),
                    decoration: InputDecoration(
                      hintText: 'leave_a_comment'.tr,
                      hintStyle: TextStyle(fontSize: 14.sp, color: mainColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: mainColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () async {
               if (whereToController.selectedPaymentType.value==-1||whereToController.selectedPaymentType.value==0) {

                        Get.snackbar('error'.tr, 'you_should_select_a_payment_method'.tr,
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: kPrimaryColor,
                            duration: Duration(seconds: 2),
                            dismissDirection: DismissDirection.startToEnd,
                            barBlur: 10,
                            colorText: mainColor);
                      }  else {

                      if (cartController.discountResponse.status == true) {
                        await usedCoupon(context).then((value) {
                          cartController.discountValue.value = 0.0;
                          // cartController.cartItemList.clear();
                          cartController.cartItemList2.clear();
                        });
                      }
                      else if (cartController.discountResponse.status ==
                          true) {
                        Get.snackbar('Error', 'This coupon is already Used ',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: kPrimaryColor,
                            duration: Duration(seconds: 2),
                            dismissDirection: DismissDirection.startToEnd,
                            barBlur: 10,
                            colorText: mainColor);
                      }
                       whereToController
                          .addOrderToFirebase()
                          .then((value) async {
                        print(
                            '(((((((((((${cartController.totalPoints})))))))))))');
                        await FirebaseDatabase.instance
                            .reference()
                            .child("Cart")
                            .child(CacheHelper.getDataToSharedPrefrence(
                                'restaurantBranchID'))
                            .child(
                                CacheHelper.getDataToSharedPrefrence('userID'))
                            .remove();

                        FirebaseDatabase.instance
                            .reference()
                            .child('Users')
                            .child(
                                CacheHelper.getDataToSharedPrefrence('userID'))
                            .child("points")
                            .get()
                            .then((snapshot) {
                          if (snapshot.exists) {
                          }
                        });


                        CacheHelper.loginShared!.points =
                            cartController.totalPoints.toString();
                         print(
                            'user points are${cartController.totalPoints}');
                      });}
                    },
                    child: Text(
                      "confirm".tr,
                      style: TextStyle(color: kPrimaryColor, fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomAppBar(context) {
    return Container(
      // width: 300,
      color: mainColor,
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Add Promo code if you have',
            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w600),
          ),
          GetBuilder<CartController>(
            init: CartController(),
            builder: (cartController) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 250.w,
                  height: 50.h,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    // controller:
                    // cartController.discountCodeTextController,
                    onChanged: (v) {
                      cartController.discountCodeTextController.text = v;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                      ),
                      contentPadding: EdgeInsets.all(8.r),
                      hintText: "voucher_code".tr,
                      hintStyle: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
                Container(
                  // width: 100.w,
                  height: 50.h,
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: GetBuilder<CartController>(
                    init: CartController(),
                    builder: (cartController) => TextButton(
                      onPressed: () async {
                        print(
                            'cartController.totalPrice ${cartController.totalPrice}');
                        await cartController.getDiscount();
                        if (cartController.discountResponse.data != null) {
                          if (cartController.discountResponse.data!.type ==
                              "نسبة") {
                            cartController.discountValue.value = (double.parse(
                                    cartController.discountResponse.data!.value
                                        .toString())) /
                                100 *
                                (cartController.totalPrice.value);
                            cartController.isPercentage.value = true;
                          } else {
                            if (num.tryParse(cartController
                                    .discountResponse.data!.value
                                    .toString())! >
                                num.tryParse(cartController.totalPrice.value
                                    .toString())!) {
                              cartController.discountValue.value = 0;
                              print(
                                  'cartController.discountValue.value)${cartController.discountValue.value}');
                              print(
                                  'cartController.total.value)${cartController.totalPrice.value}');
                              print(
                                  'cartController.total.value)${cartController.discountResponse.data!.value}');
                              print(
                                  'the discount is bigger than the total price');

                              cartController.isPercentage.value = false;
                              Get.snackbar(
                                  'error'.tr,
                                  'the_discount_is_bigger_than_the_total_price'
                                      .tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: kPrimaryColor,
                                  duration: Duration(seconds: 2),
                                  dismissDirection: DismissDirection.startToEnd,
                                  barBlur: 10,
                                  colorText: mainColor);
                            } else {
                              cartController.discountValue.value = double.parse(
                                  cartController.discountResponse.data!.value
                                      .toString());
                              cartController.isPercentage.value = false;
                              print(
                                  'cartController.discountValue.value)${cartController.discountValue.value}');
                              print(
                                  'cartController.total.value)${cartController.totalPrice.value}');
                              print(
                                  'cartController.total.value)${cartController.discountResponse.data!.value}');
                            }
                          }
                        } else {
                          Get.snackbar('sorry'.tr,
                              '${cartController.discountResponse.msg}'.tr,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: kPrimaryColor,
                              duration: Duration(seconds: 2),
                              dismissDirection: DismissDirection.startToEnd,
                              barBlur: 10,
                              colorText: mainColor);
                        }

                        cartController.update();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                      ),
                      child: Text(
                        "done".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
