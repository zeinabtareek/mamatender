import 'package:arrows/constants/colors.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/bottom_nav_bar/controllers/bottom_nav_bar_controller.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/product_details2/model/ProductDetailsModel.dart';
import 'package:arrows/modules/product_details2/model/firebase_model.dart';
import 'package:arrows/modules/sub_categories/controllers/sub_categories_controller.dart';
import 'package:arrows/modules/sub_categories/models/firebase_product_model.dart';
import 'package:arrows/modules/where_to_deliver/screens/where_to_deliver_screem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/arrows_app_bar.dart';
import '../../../components/cart_card.dart';
import '../../../components/custom_button.dart';
import '../../sub_categories/models/SubCategories.dart';
import '../models/new_cart_model.dart';

class CartScreen extends StatefulWidget {
  CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());
  final BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());
  SubCategoriesController subCategoriesController = SubCategoriesController();

  String replaceFarsiNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < farsi.length; i++) {
      input = input.replaceAll(farsi[i], english[i]);
    }

    return input;
  }

  @override
  Widget build(BuildContext context) {
    final translateName =
        CacheHelper.getDataToSharedPrefrence("localeIsArabic");
    final landScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        cartController.update();
      });
      print("Car updated");
    });

    print(cartController.hide.value);
    cartController.getCartData();
    return Scaffold(
      appBar: ArrowsAppBar(
        "cart".tr,
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          child:  Column(
              children: [
                (CacheHelper.loginShared == null)
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
                            "no_products_cart".tr,
                            style: TextStyle(
                                fontSize: 25.sp,
                                color: mainColor,
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      )
                    : GetX<CartController>(builder: (cartController) {
                        return (cartController.hide.value)
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
                                    "no_products_cart".tr,
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color: mainColor,
                                        fontWeight: FontWeight.bold),
                                  ))
                                ],
                              )
                            :  Column(
                                children: [
                                  SizedBox(
                                      child: FutureBuilder(
                                          future: cartController.getCartData(),
                                          builder: (context, snapshot) {
                                            cartController.totalPrice.value = 0.0;

                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return CircularProgressIndicator(
                                                color: kPrimaryColor,
                                              );
                                            /*********************************************this is our list******************************************************/
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(10.w),
                                                  child:    FirebaseAnimatedList(
                                                    query: cartController.dbRef,
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemBuilder: (
                                                      BuildContext context,
                                                      DataSnapshot snapshot,
                                                      Animation<double> animation,
                                                      int index,
                                                    ) {
                                                      if (index == 0) {
                                                        cartController.totalPrice
                                                            .value = 0.0;
                                                        //
                                                        (snapshot.value as Map ).forEach((key,value){
                                                             cartController.cartItemList2.add(NewCartModel2.fromJson(snapshot.value));
                                                        });
                                                      }
                                                      if (!snapshot.exists) {
                                                        return SizedBox();
                                                      } else {
                                                        if (index == 0) {
                                                          cartController
                                                              .cartItemList2 = [];
                                                        }
                                                        final json= snapshot.value as Map<dynamic, dynamic>;
                                                        cartController.cartItemList2.add(NewCartModel2.fromJson(json));


                                                        var additionalPrice = 0.0;
                                                        for (var gAdds in snapshot
                                                                    .value[
                                                                'additional'] ??
                                                            []) {
                                                          additionalPrice +=
                                                              num.tryParse(gAdds[
                                                                  "price"])!;
                                                        }
                                                        var otherAdditionalPrice =
                                                            0.0;
                                                        for (var gAdds in snapshot
                                                                    .value[
                                                                'other_additional'] ??
                                                            []) {
                                                          otherAdditionalPrice +=
                                                              num.tryParse(gAdds[
                                                                  "price"])!;
                                                        }

                                                        var sum = ((double.parse(snapshot.value["price"]) +
                                                            double.parse(additionalPrice.toString() ?? '') +
                                                                    double.parse(
                                                                        otherAdditionalPrice
                                                                                .toString() ??
                                                                            '')) *
                                                                (double.parse(snapshot
                                                                        .value[
                                                                    "quantity"])))
                                                            .toStringAsFixed(2);
                                                        cartController.totalPrice
                                                                .value =
                                                            cartController
                                                                    .totalPrice
                                                                    .value +
                                                                num.parse(sum);

                                                        return Stack(
                                                            children :[

                                                              Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 18.0),
                                                            child: Directionality(
                                                              textDirection:
                                                                  translateName
                                                                      ? TextDirection
                                                                          .ltr
                                                                      : TextDirection
                                                                          .rtl,
                                                              child: Card(
                                                                elevation: 5,
                                                                color: mainColor,
                                                                shadowColor:
                                                                    mainColor,
                                                                shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color:
                                                                            mainColor,
                                                                        width: 3),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                15)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        children: [
                                                                          Text(
                                                                            "${snapshot.value['name']}"
                                                                                .toUpperCase(),
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Directionality(
                                                                            textDirection: translateName
                                                                                ? TextDirection.ltr
                                                                                : TextDirection.rtl,
                                                                            child:

                                                                                Container(
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: translateName ? BorderRadius.only(bottomRight: Radius.circular(15)) : BorderRadius.only(bottomLeft: Radius.circular(15))),
                                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                    CartIngrediantRow(
                                                                                        textKey: 'price'.tr,
                                                                                        widget: Text(
                                                                                          '${snapshot.value['price']}',
                                                                                          style: TextStyle(fontSize: 12.sp),
                                                                                        )),

                                                                                    Divider(
                                                                                      thickness: .7,
                                                                                      height: 2,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    CartIngrediantRow(
                                                                                      textKey: 'order_content'.tr,
                                                                                      widget: getGeneralContentText(snapshot),
                                                                                    ),

                                                                                    Divider(
                                                                                      thickness: .7,
                                                                                      height: 2,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    CartIngrediantRow(
                                                                                      textKey: 'pick_size'.tr,
                                                                                      widget: Text(
                                                                                        '${snapshot.value['sizes']}'.tr,
                                                                                        style: TextStyle(fontSize: 12.sp),
                                                                                      ),
                                                                                    ),
                                                                                    // getSizeText(snapshot),
                                                                                    Divider(
                                                                                      thickness: .7,
                                                                                      height: 2,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    // getOther_additional(snapshot),
                                                                                    CartIngrediantRow(
                                                                                      textKey: 'extras'.tr,
                                                                                      widget: getOther_additional(snapshot),
                                                                                      // Text('${snapshot.value['other_additional']}'.tr,style: TextStyle(fontSize: 12),),
                                                                                    ),
                                                                                    Divider(
                                                                                      thickness: .7,
                                                                                      height: 2,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    CartIngrediantRow(
                                                                                      textKey: 'total'.tr,
                                                                                      widget: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            ' ${sum}'.tr,
                                                                                            style: TextStyle(fontSize:12.sp),
                                                                                          ),
                                                                                          Text(
                                                                                            ' : ',
                                                                                            style: TextStyle(fontSize: 12.sp),
                                                                                          ),Text(
                                                                                            '${'coin_jordan'.tr} ',
                                                                                            style: TextStyle(fontSize: 11.sp),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Divider(
                                                                                      thickness: .7,
                                                                                      height: 2,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                    GetBuilder<CartController>(builder: (cartController) {
                                                                                      return CartIngrediantRow(
                                                                                        textKey: 'quantity'.tr,
                                                                                        widget: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                          children: [
                                                                                            CircleAvatar(
                                                                                              backgroundColor: mainColor,
                                                                                              radius: 13.r,
                                                                                              child: IconButton(
                                                                                                  padding:  EdgeInsets.only(bottom: 5),

                                                                                                  onPressed: () async {
                                                                                                    //  String newNumber = (int.parse(snapshot.value['quantity']) + 1).toString();
                                                                                                    // // await cartController.funToCheckTheLimit(counter: int.parse(newNumber),);
                                                                                                    //  print(snapshot.value['id']);

                                                                                                    /*************tmm**********/

                                                                                                    String newNumber = (int.parse(snapshot.value['quantity']) + 1).toString();
                                                                                                    print(newNumber);
                                                                                                    await FirebaseDatabase.instance.reference().child("Cart").child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID')).child(CacheHelper.getDataToSharedPrefrence('userID'))
                                                                                                        .child(snapshot.key!).child('quantity').set(newNumber);
                                                                                                    await FirebaseDatabase.instance.reference().child("Cart").child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID')).child(CacheHelper.getDataToSharedPrefrence('userID'))
                                                                                                        .child(snapshot.key!).child('total_price').set(cartController.totalPrice.value.toStringAsFixed(2));

                                                                                                    cartController.quantity.value = (int.parse(snapshot.value['quantity']) + 1).toInt();

                                                                                                    cartController.update();

                                                                                                    // print( cartController.cartItemList[index].id);
                                                                                                    // print(cartController.cartItemList[index]);

                                                                                                    // } else {
                                                                                                    //   Get.snackbar('sorry'.tr, 'there_is_no_sufficient_quantity'.tr, snackPosition: SnackPosition.TOP, backgroundColor: kPrimaryColor, duration: Duration(seconds: 2), dismissDirection: DismissDirection.startToEnd, barBlur: 10, colorText: mainColor);
                                                                                                    // }
                                                                                                  },
                                                                                                  icon: Icon(
                                                                                                    Icons.add,
                                                                                                    size: 13.sp,
                                                                                                    color: Colors.white,
                                                                                                  )),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 15,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              child: Text('${snapshot.value['quantity']}'.tr,style: TextStyle(fontSize: 12.sp),),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 15,
                                                                                            ),
                                                                                            CircleAvatar(
                                                                                              backgroundColor: mainColor,
                                                                                              radius: 13.r,

                                                                                              child: IconButton(
                                                                                                padding:  EdgeInsets.only(bottom: 5),

                                                                                                onPressed: () async {
                                                                                                  if ((int.parse(snapshot.value['quantity']) > 1)) {
                                                                                                    String newNumber = (int.parse(snapshot.value['quantity']) - 1).toString();
                                                                                                    print(newNumber);
                                                                                                    await FirebaseDatabase.instance.reference().child("Cart")
                                                                                                        .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
                                                                                                        .child(CacheHelper.getDataToSharedPrefrence('userID')).child(snapshot.key!)
                                                                                                        .child('quantity').set(newNumber);
                                                                                                    await FirebaseDatabase.instance.reference().child("Cart").child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID')).child(CacheHelper.getDataToSharedPrefrence('userID'))
                                                                                                        .child(snapshot.key!).child('total_price').set(cartController.totalPrice.value.toStringAsFixed(2));

                                                                                                  //cartController  .totalPrice.value .toStringAsFixed(2)
                                                                                                    cartController.quantity.value = (int.parse(snapshot.value['quantity']) - 1).toInt();
                                                                                                    cartController.update();
                                                                                                  }
                                                                                                  // print(cartController.cartList[index]);
                                                                                                  print(cartController.cartItemList2[index]);
                                                                                                },
                                                                                                icon: Icon(
                                                                                                  Icons.minimize,
                                                                                                  size: 10.sp,weight: 3,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    }),
                                                                                    Divider(
                                                                                      thickness: .7,
                                                                                      height: 2,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ]),
                                                                                ),

                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft:
                                                                                  Radius.circular(15),
                                                                              bottomLeft: Radius.circular(15)),
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            height:
                                                                                120.h,
                                                                            width:
                                                                                150.w,
                                                                            imageUrl:
                                                                                snapshot.value['image'] ?? "",
                                                                            fit: BoxFit
                                                                                .cover,
                                                                            errorWidget: (context, url, error) =>
                                                                                Icon(
                                                                              Icons.image_not_supported_sharp,
                                                                              size:
                                                                                  60,
                                                                              color:
                                                                                  kPrimaryColor.withOpacity(0.6),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(    child: Text(
                                                                              'No Massages'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                              Positioned(
                                                                top: 0,
                                                                left:0,
                                                                child: CircleAvatar(
                                                                    radius: 19.r,
                                                                    backgroundColor: mainColor,
                                                                    child: CircleAvatar(
                                                                      backgroundColor: Colors.white,
                                                                      radius: 18.r,
                                                                      child: IconButton(
                                                                        icon: Icon(
                                                                          Icons.delete,
                                                                          size: !landScape ? 22.r : 50.r,
                                                                        ),
                                                                        onPressed: () async {
                                                                          setState(() {
                                                                            cartController.totalPrice.value -= ((double.parse(snapshot.value["total_price"])) * (double.parse(snapshot.value["quantity"])));
                                                                          });
                                                                          cartController.update();
                                                                          await FirebaseDatabase.instance
                                                                              .reference()
                                                                              .child("Cart")
                                                                              .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
                                                                              .child(CacheHelper.getDataToSharedPrefrence('userID'))
                                                                          // .child(CacheHelper
                                                                          //     .loginShared!
                                                                          //     .phone
                                                                          //     .toString())
                                                                          // .child(CacheHelper.getDataToSharedPrefrence('dateOfTheOrder'))

                                                                              .child(snapshot.key!)
                                                                              .remove()
                                                                              .then((_) => cartController.getCartData())
                                                                              .then((_) => cartController.update());
                                                                        },
                                                                        color: Colors.red,
                                                                      ),
                                                                    )),
                                                              )



                                                            ]);
                                                      }
                                                    }),),


                                              ],
                                            );
                                          })),
                                  /**********************************************************total***********************************************************/
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      // SizedBox(
                                      //   width: 150.w,
                                      //   height: !landScape ? 50.h : 100.h,
                                      //   child: TextButton(
                                      //     onPressed: () {
                                      //       bottomNavBarController
                                      //           .currentIndex.value = 0;
                                      //     },
                                      //     style: TextButton.styleFrom(
                                      //       backgroundColor: mainColor,
                                      //     ),
                                      //     child: FittedBox(
                                      //       child: Text(
                                      //         "continue_shopping".tr,
                                      //         style: TextStyle(
                                      //             color: Colors.black,
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16.sp),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ), // afterBuild(),

                                      Expanded(child:


                                      Button(
                                        text: 'continue_shopping'.tr,
                                        size: 150,
                                        fontSize: 14,
                                        height:!landScape ? Get.height/20.h : 100.h,
                                        onPressed: (){
                                          bottomNavBarController
                                              .currentIndex.value = 0;
                                        },
                                        isFramed: true,

                                      )
                                      ),
                                      SizedBox(width: 10.w,),


                                      Expanded(child:  Button(
                                        text: 'proceed_check_out'.tr,
                                        size: 150,
                                        fontSize: 14,

                                        height:!landScape ?  Get.height/19.h: 100.h,
                                        onPressed: (){
                                          Get.to(() => WhereToDeliverScreen());
                                        },
                                        isFramed: false,

                                      )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GetBuilder<CartController>(
                                        init: CartController(),
                                        builder: (controller)=> Card(
                                          // padding: EdgeInsets.all(8.r),
                                          // decoration: BoxDecoration(
                                          //   borderRadius:
                                          //       BorderRadius.circular(4.r),
                                          elevation: 1.5,
                                          shadowColor: Colors.white,
                                          color: mainColor,
                                          // ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text("${'total'.tr} : ",
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                          FontWeight.w600)),
                                                  GetBuilder<CartController>(
                                                      init: CartController(),
                                                      builder: (cartController) {
                                                        return Text(
                                                            cartController
                                                                .totalPrice.value
                                                                .toStringAsFixed(2),
                                                            style: TextStyle(
                                                                fontSize: 25.sp,
                                                                color: Colors.red,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold));
                                                      }),


                                                  Text("${'coin_jordan'.tr}  ",
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                          FontWeight.w600)),
                                                ],
                                              ),
                                              Text(
                                                "(${'with_tax'.tr})",
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),

                                        ),),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      /**********************************************the End********************************************************/

                                    ],
                                  ),


                                ],

                              );
                      }),

              ],
            ),
          ),
        ),

    );
  }

  Widget getSizeText(snapshot) {
    if (snapshot.value['sizes'] != null) {
      for (var size in snapshot.value['sizes'] ?? '') {
        if (size["is_need"] == true) {
          return Text(
            size["size"] ?? "",
            style: TextStyle(fontSize: 12.sp),
          );
        }
      }
    }
    return SizedBox();
  }

  Widget getGeneralAdditionsText(dynamic snapshot) {
    List generalAdds = [];
    if (snapshot.value['addsList'] != null) {
      for (var gAdds in snapshot.value['addsList'] ?? []) {
        if (gAdds["is_need"] == true) {
          generalAdds.add(gAdds["adds"]);
        }
      }
      return Text(
        generalAdds.toString().replaceAll("[", "").replaceAll("]", ""),
        style: TextStyle(fontSize: 12.sp),
      );
    }
    return SizedBox();
  }

  Widget getOther_additional(dynamic snapshot) {
    List generalAdds = [];
    if (snapshot.value['other_additional'] != null) {
      for (var gAdds in snapshot.value['other_additional'] ?? []) {
        generalAdds.add(gAdds["name"]);
      }
      return Text(
        generalAdds.toString().replaceAll("[", "").replaceAll("]", ""),
        style: TextStyle(fontSize: 12.sp, color: Colors.black),
      );
    }
    return SizedBox();
  }

  Widget getGeneralContentText(dynamic snapshot) {
    List<Widget> contentAds = [];
    if (snapshot.value['components'] != null) {
      for (var gAdds in snapshot.value['components'] ?? []) {
        // if (gAdds["need"] == true) {
        contentAds.add(Text(
          gAdds["name"],
          style: TextStyle(fontSize: 12.sp),
        ));
        contentAds.add(Text(" ,"));
        // }
      }
      return Container(
        width: 170.w,
        child: Wrap(
          children: contentAds,
        ),
      );
    }
    return SizedBox();
  }

  Widget getAddDrinkText(dynamic snapshot) {
    List drinkAds = [];
    if (snapshot.value['list_of_drinks'] != null) {
      for (var gAdds in snapshot.value['list_of_drinks'] ?? []) {
        if (gAdds["is_need"] == true) {
          drinkAds.add(gAdds["name"]);
        }
      }
      return Text(
        drinkAds.toString().replaceAll("[", "").replaceAll("]", ""),
        style: TextStyle(fontSize: 12.sp),
      );
    }
    return SizedBox();
  }
}
