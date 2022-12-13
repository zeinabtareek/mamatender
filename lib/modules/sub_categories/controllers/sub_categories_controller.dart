import 'package:arrows/constants/colors.dart';
import 'package:arrows/modules/cart/controllers/cart_controller.dart';
import 'package:arrows/modules/main_category/controllers/main_categories_controller.dart';
import 'package:arrows/modules/more_info/models/BarcodModel.dart';
import 'package:arrows/modules/sub_categories/models/SubCategories.dart';
import 'package:arrows/modules/sub_categories/services/sub_categories_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../helpers/shared_prefrences.dart';
import '../../cart/models/new_cart_model.dart';
import '../../product_details/controllers/product_details_controller.dart';
import '../../product_details/models/drinks_model.dart';

class SubCategoriesController extends GetxController {
  int mainCategoryId = 0;
  late final String restaurantName;
  // List<NewCartModel2> products = <NewCartModel2>[].obs;
  List<Products> products = <Products>[].obs;
  int page = 0;
  final isFirstLoadRunning = false.obs;
  final hasNextPage = true.obs;
  final messageController=TextEditingController();
  final isLoadMoreRunning = false.obs;
  final RefreshController refreshController = RefreshController();
  Sizes sizeDropDownValue = Sizes();
  final drinkRadioButtonSelectedValue = ''.obs;
  final typeRadioButtonSelectedValue = ''.obs;
  final valueGroupType = <int>[].obs;
  List<Sizes> sizesList = [];
  List<Drink> other_additional = [];
  SubCategories? subCategories;
 var  value;
  Future getSubCategories() async {
    isFirstLoadRunning.value = true;
    products.clear();
    subCategories =
        await SubCategoriesService.getSubCategories(mainCategoryId, page);
    products.assignAll(subCategories!.data!);
    isFirstLoadRunning.value = false;
  }


  loadMore() async {
    if (subCategories!.data!.isNotEmpty) {
      page++;
      subCategories =
          await SubCategoriesService.getSubCategories(mainCategoryId, page);
      products.addAll(subCategories!.data!);
      print("loading");
    } else {
      print("no subcategories");
    }
  }

  @override
  dispose() {
     // refreshController;
    // totalPrice.value=0;
    // orderCounter.value=1;
    // listOfPComponents;
    // productPrice.value;
    //   isFirstLoadRunning ;
    //   hasNextPage ;
    //   isLoadMoreRunning  ;
    //   drinkRadioButtonSelectedValue ;
    //   typeRadioButtonSelectedValue ;
    //   valueGroupType;
    //    sizesList;
    //   other_additional;
    //     subCategories;

    update();
  }

  void onClose() {
    increaseOrderCounter;
    // totalPrice.value=0;
    // orderCounter.value=1;
    // orderPrice.value;
     // refreshController;
    //   listOfPComponents;
    // isFirstLoadRunning ;
    // hasNextPage ;
    // isLoadMoreRunning  ;
    // sizeDropDownValue=Sizes();
    // drinkRadioButtonSelectedValue ;
    // typeRadioButtonSelectedValue ;
    // valueGroupType;
    // sizesList;
    // orderCounter.value=1;
    // other_additional;
    // subCategories;
    update();
  }


  @override
  Future<void> onInit() async {
    super.onInit();

    final MainCategoriesController mainCategoriesController =
        Get.put(MainCategoriesController());
    mainCategoryId = mainCategoriesController
            .categories[mainCategoriesController.index].id ??
        0;
    getSubCategories();

  } selectDrinkRadioButton(var v) {
    drinkRadioButtonSelectedValue.value = v;
    print('this is the value of the drinks radio button selected $v');

    update();
  }

  selectTypeRadioButton(var v) {
    typeRadioButtonSelectedValue.value = v;
    print('this is the value of the types radio button selected $v');
    update();
  }

  /********addToCart****/

  final totalPrice = 0.0.obs;

  RxDouble productPrice = 0.0.obs;
  RxDouble orderPrice = 0.0.obs;
  final priceList = <String>[].obs;
  RxInt orderCounter = 1.obs;
  final listOfSouces = <Sauces>[].obs;
  final listOfPublicAdditional = <Additional>[];
  List<Components> listOfPComponents = [];


  final listOfPSpices = <Spices>[];

  increaseOrderCounter(num limit) {
    //6.50
    if (orderCounter.value < 6) {
      if (totalPrice.value != productPrice.value * orderCounter.value) {
        var resetPrice = totalPrice.value;
        resetPrice -= (productPrice.value * orderCounter.value);
        print('###${resetPrice}');
        resetPrice = resetPrice / orderCounter.value;
        print('new rest price ${resetPrice / orderCounter.value}');
        print('totalPrice.value ${totalPrice.value}');
        print('productPrice.value ${productPrice.value}');
        print('orderCounter.value ${orderCounter.value}');
        print(
            'resetPrice* orderCounter.value ${resetPrice * orderCounter.value}');
        orderCounter.value++;
        totalPrice.value = 0.0;
        totalPrice.value = productPrice.value * orderCounter.value +
            resetPrice * orderCounter.value; //25.50
        print(totalPrice.value);
      } else {
        orderCounter.value++;
        totalPrice.value = productPrice.value * orderCounter.value;
        print(totalPrice.value);
      }
    } else {
      Get.snackbar('sorry'.tr, 'there_is_no_sufficient_quantity'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.startToEnd,
          barBlur: 10,
          colorText: mainColor);
    }
  }

  decreaseOrderCounter(index) {
    if (orderCounter.value > 1) {
      if (totalPrice.value != productPrice.value * orderCounter.value) {
        var resetPrice = totalPrice.value;
        resetPrice -= (productPrice.value * orderCounter.value);
        print('###${resetPrice}');
        resetPrice = resetPrice / orderCounter.value;
        print('new rest price ${resetPrice / orderCounter.value}');
        print('totalPrice.value ${totalPrice.value}');
        print('productPrice.value ${productPrice.value}');
        print('orderCounter.value ${orderCounter.value}');
        print(
            'resetPrice* orderCounter.value ${resetPrice * orderCounter.value}');
        orderCounter.value--;
        totalPrice.value = 0.0;
        totalPrice.value = productPrice.value * orderCounter.value +
            resetPrice * orderCounter.value; //25.50
        print(totalPrice.value);
      } else {
        orderCounter.value--;
        totalPrice.value = productPrice.value * orderCounter.value;
        print(totalPrice.value);
      }
    } else {
      Get.snackbar('sorry'.tr, 'you_can\'t_order_less_than_one'.tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 2),
          dismissDirection: DismissDirection.startToEnd,
          barBlur: 10,
          colorText: mainColor);
    }
  }



  addToSouces(bool value, Sauces item) {
    if (value == true) {
      listOfSouces.add(item);
    } else {
      listOfSouces.remove(item);
    }
  }

  addToDrinks(bool value, Drink item) {
    if (value == true) {
      // listOfAdditional.add(item);
      other_additional.add(item);
      totalPrice.value += num.parse(item.price!) * orderCounter.value;
      print(totalPrice.value);
      print('addToDrinks totalPrice.value');
      // listOfAdditional.forEach((element) {
      //   price += double.parse(element.price!);
      //   print(price);
      // });
    } else {
      other_additional.remove(item);
      totalPrice.value -= num.parse(item.price!) * orderCounter.value;
      print(totalPrice.value);
      // listOfAdditional.forEach((element) {
      //   price += double.parse(element.price!);
      //   print(price);
      // });
    }
    update();
    CartController().update();
  }

  addToPublicAddition(bool value, Additional item) {
    if (value == true) {
      listOfPublicAdditional.add(item);
      totalPrice.value += num.parse(item.price!) * orderCounter.value;
      print(totalPrice.value);
      print('addToPublicAdditiontotalPrice.value');
    } else {
      listOfPublicAdditional.remove(item);
      totalPrice.value -= num.parse(item.price!) * orderCounter.value;
      print(totalPrice.value);
    }
    update();
    CartController().update();
  }

  addToComponents(bool value, Components item) {
    if (value == true) {
      listOfPComponents.add(item);
      // listOfPComponents.remove(item);
      print(listOfPComponents.first.name);
    } else {
      listOfPComponents.remove(item);
      print('*****listOfPComponents ${listOfPComponents.length}');
    }
  }

  ///Radio button///
  addToSpices(num id, Spices item) {
    if (id == item.id) {
      listOfPSpices.add(item);
    } else {
      listOfPSpices.remove(item);
      print(listOfPComponents.length);
    }
  }

  validateForm(index) {
    try {
      if (products[index].spices!.isNotEmpty &&
          typeRadioButtonSelectedValue.value.isEmpty) {
        //
        Get.snackbar('error'.tr, 'you_should_select_a_type'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: kPrimaryColor,
            duration: Duration(seconds: 2),
            dismissDirection: DismissDirection.startToEnd,
            barBlur: 10,
            colorText: mainColor);
      }  else {
        validateForm2(index);
      }
    } catch (on) {
      printError(info: 'error');
    }
  }

  validateForm2(index) {
    try {
      if (products[index].drinks!.isNotEmpty &&
          drinkRadioButtonSelectedValue.value.isEmpty) {
        Get.snackbar('error'.tr, 'you_should_select_a_drink'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: kPrimaryColor,
            duration: Duration(seconds: 2),
            dismissDirection: DismissDirection.startToEnd,
            barBlur: 10,
            colorText: mainColor);
      } else {
        validateForm3(index);
      }
    } catch (on) {
      printError(info: 'error');
    }
  }

  validateForm3(index) async {
    try {
      if (products[index].sauces!.isNotEmpty && listOfSouces.isEmpty ) {

          Get.snackbar('error'.tr, 'you_should_select_some_sauces'.tr,
              snackPosition: SnackPosition.TOP,
              backgroundColor: kPrimaryColor,
              duration: Duration(seconds: 2),
              dismissDirection: DismissDirection.startToEnd,
              barBlur: 10,
              colorText: mainColor);
        }
        else if (products[index].sauces!.isNotEmpty &&listOfSouces.length > 4) {
          Get.snackbar('error'.tr, 'you_should_selectـonlyـ4ـtypes'.tr,
              snackPosition: SnackPosition.TOP,
              backgroundColor: kPrimaryColor,
              duration: Duration(seconds: 2),
              dismissDirection: DismissDirection.startToEnd,
              barBlur: 10,
              colorText: mainColor);
        }
        else {
        await  addToCart(index);
        }


    } catch (on) {
      printError(info: 'error');
    }
  }

  addToCart(index) async {
    DateFormat dateFormat =
    DateFormat("dd-MM-yyyy HH:mm:ss");
    String dateID = await dateFormat.format(DateTime.now());
    NewCartModel2 oneProduct = NewCartModel2();
    var x = CacheHelper.getDataToSharedPrefrence('selectedSize');

    CacheHelper.saveDataToSharedPrefrence('dateOfTheOrder', dateID);
    oneProduct = NewCartModel2(
      id: dateID ,
      additional: listOfPublicAdditional.isNotEmpty?listOfPublicAdditional:[],
      drinks: drinkRadioButtonSelectedValue.value.toString(),
      name: products[index].name,
      components: products[index].components!,
      price:productPrice.value.toString(),
      sizes: sizeDropDownValue.size.toString(),
      photo: products[index].photo,
      spices:   typeRadioButtonSelectedValue.value.isNotEmpty?typeRadioButtonSelectedValue.value:
          products[0].spices!.isNotEmpty?products[0].spices!.first.name.toString():'',
      sauces: listOfSouces.value.isNotEmpty?listOfSouces.value:[],
      quantity: orderCounter.value.toString(),
      category: products[index].categoryId.toString(),message: messageController.text,
      other_additional: other_additional,
      total_price: totalPrice.value.toStringAsFixed(2),
    );

    CacheHelper.getDataToSharedPrefrence('userID') != null
        ? FirebaseDatabase.instance
            .reference()
            .child('Cart')
            .child(CacheHelper.getDataToSharedPrefrence('restaurantBranchID'))
            .child(CacheHelper.getDataToSharedPrefrence('userID'))
            .child(dateID)
            .set(oneProduct.toJson())
            .then((value) {
            return Get.snackbar('done'.tr, 'one_item_added_successfully'.tr,
                snackPosition: SnackPosition.TOP,
                backgroundColor: kPrimaryColor,
                duration: Duration(seconds: 2),
                dismissDirection: DismissDirection.startToEnd,
                barBlur: 10,
                colorText: mainColor);
          })
        : printError(info: '___________________');
    CartController().update();
    Get.back();
  }
}
