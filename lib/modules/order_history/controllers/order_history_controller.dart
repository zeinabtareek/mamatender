import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/cart/models/new_cart_model.dart';
import 'package:arrows/modules/sub_categories/models/SubCategories.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../../../shared_object/firebase_order_model.dart';
import '../../product_details2/model/ProductDetailsModel.dart';

class OrderHistoryController extends GetxController {
  var dbRef;
  RxBool hide = true.obs;



    Future<void> geHistoryData() async {
      dbRef = FirebaseDatabase.instance
          .reference()
          .child("UserOrders")
          .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
          .child(CacheHelper.getDataToSharedPrefrence('userID'));

      DatabaseReference referenceData = FirebaseDatabase.instance
          .reference()
          .child("UserOrders")
          .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
          .child(CacheHelper.getDataToSharedPrefrence('userID'));

      referenceData.once().then((DataSnapshot snapshot) async {
        if (snapshot.exists) {
          hide.value = false;


          var keys = snapshot.value.keys;

          for (var key in keys) {
            print(key);
            var cartData = await FirebaseDatabase.instance
                .reference()
                .child("UserOrders")
                .child(
                CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
                .child(CacheHelper.getDataToSharedPrefrence('userID'))
                .get()
                .then((value) {
              if (value.exists) {
                // hide.value = true;
              } else {
                // hide.value = false;
              }


              return Map<String, dynamic>.from(value.value);
            });
            print(cartData);

          }
        }
        else {
          hide.value = true;
        }
      });
    }
  @override
  void onInit() {
    geHistoryData();

    super.onInit();
  }
}
