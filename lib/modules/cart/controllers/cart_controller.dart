import 'dart:convert';

import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/cart/models/copoun_response_model.dart';
import 'package:arrows/modules/cart/models/new_cart_model.dart';
import 'package:arrows/modules/cart/models/resteurant_fees_response_model.dart';
import 'package:arrows/modules/cart/services/cart_service.dart';
import 'package:arrows/modules/cart/services/coupon_body.dart';
import 'package:arrows/modules/cart/services/coupon_service.dart';
import 'package:arrows/modules/sub_categories/models/firebase_product_model.dart';
import 'package:arrows/modules/where_to_deliver/controllers/Where_to_controller.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart'as dio;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../product_details2/model/ProductDetailsModel.dart';
import '../../product_details2/model/firebase_model.dart';
import '../../sub_categories/models/SubCategories.dart';



class CartController extends GetxController {
  var quantity = 1.obs;
  int cartIndex = 0;
  RxDouble totalPrice = 0.0.obs;
  Rx<Fees?> fees = Fees().obs;
  List<Products> products = <Products>[];
  int forbuy = 0;
  int forsale = 0;
    dynamic totalPoints ;
  dynamic balance;
final checkBalanceAndTotalValue=0.0.obs;
bool   isAllowed=false;
bool   wallet=false;

  var dbRef;
  List<NewCartModel2> cartItemList2 = <NewCartModel2>[];
   // List<Products> cartItemList = <Products>[];
  RxBool hide = true.obs;
  RxBool isPercentage = false.obs;
  CouponResponse discountResponse = CouponResponse();
  final discountValue = 0.0.obs;

  TextEditingController messageTextController = TextEditingController();
  final discountCodeTextController = TextEditingController();


  @override
  Future<void> onInit() async {

    await getRestaurantFees();
    totalPrice.value;
    discountResponse;
    getUserPoints();
   await getSystemPoints();

    await  getDiscount();
    discountValue.value=0;


    if( balance>= checkBalanceAndTotalValue.value){
      isAllowed=true;
      isAllowed==true;
      update();
    }
    print('________________________${totalPoints}______________________________-${cartItemList2.length}');
     super.onInit();
  }




  Future<void> getDiscount() async
  {
    CouponBody discountBody = CouponBody(discountCode: discountCodeTextController.text ,
         phoneNumber: CacheHelper.loginShared!.phone);
       dio.Response? response;
    try
    {
      response = await CouponService.getDiscount(discountBody);
      if(jsonDecode(response!.data)['data'] == 0)
        {
          // Get.back();
          Get.defaultDialog(content: Text('${jsonDecode(response.data)['msg']}'),title: "خطا");

        }
      else{
        // Get.back();
        print('response.data${response.data}');
        discountResponse = CouponResponse.fromJson(jsonDecode(response.data));
        print('response.data${discountResponse.data!.value}${discountResponse.data!.type}');
        // Get.back();
      }    update();
    }
    catch(e)
    {  print(e); }
    update();
  }

  Future<void> getRestaurantFees() async {
    RestaurantFeesResponse? restaurantFeesResponse;
    try {
      restaurantFeesResponse = await CartService.getRestaurantFees();
    } catch (e) {
      print(e);
    }
    fees.value = restaurantFeesResponse!.fee;
  }
 Future<void> getCartData() async {
    dbRef = FirebaseDatabase.instance
        .reference()
        .child("Cart").child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
        .child(CacheHelper.getDataToSharedPrefrence('userID') );


    DatabaseReference referenceData = FirebaseDatabase.instance
        .reference()
        .child("Cart") .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
        .child(CacheHelper.getDataToSharedPrefrence('userID') );

    referenceData.once().then((DataSnapshot snapshot) async {
      if (snapshot.exists) {
        hide.value = false;
        var keys = snapshot.value.keys;

        final json = snapshot.value as Map<dynamic, dynamic>;
        NewCartModel2 message = NewCartModel2.fromJson(json);
         cartItemList2.add(message);

        Map<dynamic, dynamic> values=snapshot.value;

        cartItemList2.add(NewCartModel2.fromJson(values));




        for (var key in keys) {
          print(key);
          var cartData = await FirebaseDatabase.instance
              .reference()
              .child("Cart")
              .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
              .child(CacheHelper.getDataToSharedPrefrence('userID') )
               .get()
              .then((value) {
            if (value.exists) {

            } else {       }

            return Map<dynamic, dynamic>.from(value.value);
          });
          print(cartData);
        }
      }
      else{
        hide.value = true;
      }
    });
  }
  Future<void> sendNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String dashboardToken = await FirebaseDatabase.instance
        .reference()
        .child("Dashboard_Token")
        .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
        .child("Token")
        .get().then((value){
      return value.value;
    });
    print(dashboardToken);
    final data = {
      "notification": {"body": "لديك طلب جديد", "title": "Mama\'s Tender"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to": "$dashboardToken"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAA4qTrRdw:APA91bHJ2eNaiK2okdfDhaO2XS2co-SGdove70hkqk1tATzCF4Vuv_Jm5ajfVel2MPJ33rz_hyX_IvkW_8XL6ihL1kzJy348CdNx5hH27x94EKttU8quLNy8baYEpiFYac63IcLMDX7G'
      // 'Authorization': 'key=AAAAQeyrMLI:APA91bGw-yEezVTItnAi0qMWXx6x83aY-eL8ECIuy2MFDYyupNs-LMKGomUZNl8Ak0wlnz-e3cmQjBTqV7cJMie4kFouuFUOriEEwgcUMd4MSZAToHUq0SRp9fwP8GF0SwDnW_pueHAj'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    final response = await Dio(options).post('https://fcm.googleapis.com/fcm/send',
        data: data);

  }
  getSystemPoints() async {
    await FirebaseDatabase.instance
        .reference()
        .child('point_system')
        .once()
        .then((DataSnapshot snapshot) {
          if(snapshot.exists) {
            forsale = int.parse(snapshot.value['for_sale']);
            forbuy = int.parse(snapshot.value['for_buy']);

            update();
          }
          update();
         
    });

    update();


  }

  Future<void>getUserPoints()async{
    await FirebaseDatabase.instance
      .reference()
      .child('Users')
       .child(CacheHelper.getDataToSharedPrefrence('userID') ).child('points')
       .once().then((DataSnapshot snapshot) {
        print(snapshot.value);
    if(snapshot.exists){
      print('value$totalPoints');
        totalPoints = snapshot.value;
        print('value$totalPoints');
        totalPoints=snapshot.value;
        print('value$totalPoints');
        CacheHelper.loginShared!.points=totalPoints;

      update();

    } print('$totalPoints');
        getSystemPoints();
        if(forsale!=0||forsale!=null) {
          balance = num.parse(totalPoints ) / num.parse(forsale.toString());
          print('the user balance is $balance');
        }
        getSystemPoints();
          update();


});}





  @override
  void dispose() {
    discountValue.value;

  }


  increaseQuantity(quantity1,String id)async{

    var x= await FirebaseDatabase.instance
        .reference()
        .child("Cart").child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
        .child(CacheHelper.getDataToSharedPrefrence('userID') )
       .once().then((DataSnapshot snapshot) async {
      quantity.value=quantity1;
     quantity.value ++;

     print(quantity.value);
     var keys = snapshot.value.keys;
     print(quantity.value);
    for(var i in keys){
      print(i);
      Map< String , dynamic> quantityUpadte={'quantity' :6};
      await FirebaseDatabase.instance
          .reference()
          .child("Cart").child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
          .child(CacheHelper.getDataToSharedPrefrence('userID') )
          .child('2022-11-03 16:21:18').child("quantity").set(quantity.value);
     }quantity.value ++;
    update();
  }
  );


}
  Product product=Product();
   funToCheckTheLimit({index,  counter}){

     if (counter <  products[0].availability) {
      Get.snackbar('sorry'.tr, 'there_is_no_sufficient_quantity'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.startToEnd,
          barBlur: 10,
          colorText: mainColor);
    }
    else{Get.snackbar('sorry'.tr, 'g,lmghmgm'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: kPrimaryColor,
        duration: Duration(seconds: 2),
        dismissDirection: DismissDirection.startToEnd,
        barBlur: 10,
        colorText: mainColor);

    }

  }
}
