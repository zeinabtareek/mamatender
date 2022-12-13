import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/bottom_nav_bar/screens/bottom_nav_bar_screen.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/cart/models/copoun_response_model.dart';
import 'package:arrows/modules/sign_up/models/user_model.dart';
import 'package:arrows/modules/sub_categories/models/SubCategories.dart';
import 'package:arrows/modules/where_to_deliver/models/branches_addresses_model.dart';
import 'package:arrows/modules/where_to_deliver/models/delivery_area_model.dart';
import 'package:arrows/modules/where_to_deliver/models/firebase_address_model.dart';
import 'package:arrows/modules/where_to_deliver/services/branches_addresses_service.dart';
import 'package:arrows/shared_object/posted_order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../shared_object/firebase_order_model.dart';


class WhereToController extends GetxController {
  RxBool showPickUpBranches = true.obs;
  Branch? branchDropDownValue;
  List<Branch> branches = <Branch>[Branch(name: "اختار الفرع")].obs;
  List<UserAddress> addresses = <UserAddress>[].obs;
  UserAddress selectedUserAddress = UserAddress();
  RxBool toggleButtons = true.obs;
  RxString radioValue = "".obs;
  RxString selectTypeRadioButton = "".obs;
  var selectedAddressRadioButton;
  var dbref;
  RxInt selectedPaymentType=(-1).obs;
  String? paymentReferenceId;
final isFramedValue=false.obs;
   //Text field controllers
  TextEditingController areaNumber = TextEditingController();
  TextEditingController buildNumber = TextEditingController();
  TextEditingController floorNumber = TextEditingController();
  TextEditingController landscape = TextEditingController();
  TextEditingController addressTextController = TextEditingController();

  CartController cartController = Get.find();
  isFramed(){
    !isFramedValue.value;

  }

  @override
  void dispose() {
    selectedDropDownValue;
    areaNumber.text;
    buildNumber.text;
    floorNumber.text;
    landscape.text;
    addressTextController.text;
  }

  @override
  void onClose() {
    selectedDropDownValue;
    areaNumber.text;
    buildNumber.text;
    floorNumber.text;
    landscape.text;
    addressTextController.text;
  }

  Future<void> getAllBranchAddresses() async {
    BranchesAddresses? response;
    try {
      response = await BranchesAddressesService.getBranchesAddresses();
    } catch (e) {
      print(e);
    }
    branches.addAll(response!.branches);
  }
/******i commented it maybe it's causing the issue*******/
  Future<void> getAllUserAddressees() async{
    dbref = FirebaseDatabase.instance
        .reference()
        .child("Users") .child(CacheHelper.getDataToSharedPrefrence('userID') )
        .child("user_address_list");
  }
  /******i commented it maybe it's cousing the issue*******/

  // Future<void> getAllUserAddressees() async{
  //   dbref = FirebaseDatabase.instance
  //       .reference()
  //       .child("DeliveryList")
  //       // child('branch1')
  //       // .child('-NCAoy4evO1S9m0g8hvh')
  //   .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
  //       // .child(CacheHelper.loginShared!.phone.toString())
  //   // .child("user_address_list");
  //
  //       // .child(CacheHelper.getDataToSharedPrefrence('userID') )
  //       .child("area");
  // }
   final selectedAreaPrice = ''.obs;





  RxList<DeliveryAreaModel>? deliveryAreaList = [
    DeliveryAreaModel(id: '0', area: 'neighbourhood'.tr  , price: '0'),].obs;
  DeliveryAreaModel? selectedDropDownValue;
  // DeliveryAreaModel? selectedDropDownValue;

  Future<void> getDeliveryList()async{
    // deliveryAreaList!.clear();
    var ref =  await FirebaseDatabase.instance.reference().child('DeliveryList')
    // .child('branch1')
    // .child('-NCAoy4evO1S9m0g8hvh')
        .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'));
      ref.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      print(snapshot.key);
      snapshot.value.forEach((key,values) {
        // final json = snapShot.value as Map<dynamic, dynamic>;
        DeliveryAreaModel dv=DeliveryAreaModel.fromJson(values);
        deliveryAreaList!.add(dv);
        print(values);
      });
    });   selectedDropDownValue = deliveryAreaList![0];
  }


  Future<void> addOrderToFirebase()
  async {

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    String dateID = dateFormat.format(DateTime.now());

    (cartController.discountCodeTextController.text.isNotEmpty&&cartController.discountResponse.data == null )?
    cartController.discountResponse.data!.value= int.tryParse(cartController.discountValue.value.toString()) :0.0;
    var x=CacheHelper.getDataToSharedPrefrence('dropDownValuePrice');




     PostedOrder.order
      ..branch = branches[1].name
      ..price = cartController.totalPrice.toString()
      ..totalPrice =(cartController.wallet)? (cartController.balance>=(cartController.totalPrice.value + (showPickUpBranches.value == false ?
          (num.parse(x)) : 0.0) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null'
                  ? (double.parse(cartController
                  .fees.value!.feesValue
                  .toString()) /
                  100)
                  : 0.0)) -
          cartController.discountValue.value))?//لو المحقظه اكبر من الاوردو
      ( (cartController.totalPrice.value + (showPickUpBranches.value == false ?
      (num.parse(x)) : 0.0) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null'
          ? (double.parse(cartController
          .fees.value!.feesValue
          .toString()) /
          100)
          : 0.0)) -
          cartController.discountValue.value)*0).toStringAsFixed(2)

          ://لو مش اكبر
      ((cartController.totalPrice.value +
          (showPickUpBranches.value == false ?
          (num.parse(x))
              : 0.0) +
          (cartController.totalPrice.value *
              (cartController.fees.value!.feesValue !=
                  'null'
                  ? (double.parse(cartController
                  .fees.value!.feesValue
                  .toString()) /
                  100)
                  : 0.0)) -
          cartController.discountValue.value)
          .toStringAsFixed(2)):((cartController.totalPrice.value +
          (showPickUpBranches.value == false ?
          (num.parse(x)) : 0.0) +
          (cartController.totalPrice.value *
              (cartController.fees.value!.feesValue !=
                  'null'
                  ? (double.parse(cartController
                  .fees.value!.feesValue
                  .toString()) /
                  100)
                  : 0.0)) -
          cartController.discountValue.value)
          .toStringAsFixed(2))

        ..delivery = CacheHelper.getDataToSharedPrefrence('dropDownValuePrice')
      ..discount =(cartController.discountCodeTextController.text != 'null' &&
          cartController.discountCodeTextController.text != null && cartController.discountCodeTextController.text.isNotEmpty)
          ?  cartController.discountResponse.data!.value.toString():' '
      /*****i change this****/
      ..extra = (cartController.fees.value!.feesValue != 'null' || cartController.fees.value!.feesValue != null)
          ? (cartController.totalPrice.value * (  double.parse(cartController.fees.value!.feesValue.toString()) / 100)).toStringAsFixed(2)
          : '0.0'
      ..orderId = dateID
      ..orderStatus = "تم أرسال طلبك"
      ..client = CacheHelper.loginShared
      ..tax =(cartController.fees.value!.tax != 'null' ||
          cartController.fees.value!.tax != null)
          ? (cartController.totalPrice.value -
          (cartController.totalPrice.value / (((cartController.fees.value!.tax != 'null' ? (double.parse(cartController.fees.value!.tax.toString())) : 0.0) / 100) + 1)))
          .toStringAsFixed(2): '0.0'

      ..referenceId = paymentReferenceId ??"cash"
      ..message = cartController.messageTextController.text
       ..listOfProduct = cartController.cartItemList2??[];


print('*******this id totalprice in Order*********************${PostedOrder.order.totalPrice}');


    FirebaseDatabase.instance
        .reference()
        .child("UserOrders")
        .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
         .child(CacheHelper.getDataToSharedPrefrence('userID') )
        .child(dateID)
        .set(PostedOrder.order.toJson());

    FirebaseDatabase.instance
        .reference()
        .child("Orders")
        .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
        .child(dateID)
        .set(PostedOrder.order.toJson());



var tmp= ((num.parse(PostedOrder.order.totalPrice.toString())*cartController.forbuy)+(cartController.totalPoints!=null? num.parse(cartController.totalPoints.toString()):0));
    FirebaseDatabase.instance
        .reference()
        .child("Cart")
    .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
        .child(CacheHelper.loginShared!.phone.toString())
        .child(CacheHelper.getDataToSharedPrefrence('userID') )
        .set(null);
    await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(
        CacheHelper.getDataToSharedPrefrence('userID'))
    // .set(user.toJson())
        .update({
      'points': tmp.floor().toString()



    });

    if(cartController.wallet==true&&cartController.balance>=(cartController.totalPrice.value + (showPickUpBranches.value == false ?
    (num.parse(x)) : 0.0) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null'
        ? (double.parse(cartController
        .fees.value!.feesValue
        .toString()) /
        100)
        : 0.0)) -
        cartController.discountValue.value)) {


      print('********${cartController.balance}');

      cartController.balance-=(cartController.totalPrice.value + (showPickUpBranches.value == false ?
      (num.parse(x)) : 0.0) + (cartController.totalPrice.value * (cartController.fees.value!.feesValue != 'null'
          ? (double.parse(cartController
          .fees.value!.feesValue
          .toString()) /
          100)
          : 0.0)) -
          cartController.discountValue.value);
      print('********${cartController.balance}');


      cartController.totalPoints=cartController.balance*cartController.forsale;
      print('***cartController.totalPoints*****${cartController.totalPoints}');
      // ....
      FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(
    CacheHelper.getDataToSharedPrefrence('userID'))
    // .set(user.toJson())
        .update({
    'points': cartController.totalPoints.floor().toString()

    });

cartController.update();
    }



    cartController.cartItemList2.clear();
     cartController.hide.value = true;
    cartController.update();

    cartController.sendNotification();
    cartController.discountValue.value = 0.0;
    cartController.discountResponse = CouponResponse();
    cartController.discountCodeTextController.clear();
    cartController.messageTextController.clear();

    Get.snackbar('done'.tr, '${'your_order_sent_successfully'.tr}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.startToEnd,
          barBlur: 10,
          colorText: mainColor);
// cartController.totalPrice.value=0.0;
    cartController.update();
     Get.offAll(() => BottomNavBarScreen());
  }
  late Future  getAllUserAddresseesv;
  onInit() async {
    getAllUserAddresseesv= Future.delayed(Duration(milliseconds: 250), () => true);
     selectedAreaPrice;
    print(')))))))))))))))))))${selectedDropDownValue?.price}');
    await getAllBranchAddresses();
    await getDeliveryList();
    await getAllUserAddressees();
    branchDropDownValue = branches[1];
    // PostedOrder.order.address = Address

    super.onInit();
  }

}
