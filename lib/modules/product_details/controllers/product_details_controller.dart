import 'package:arrows/modules/product_details/models/drinks_model.dart';
import 'package:arrows/modules/product_details/services/get_all_drinks_service.dart';
import 'package:arrows/modules/sub_categories/controllers/sub_categories_controller.dart';
import 'package:get/get.dart';

import '../../product_details2/model/ProductDetailsModel.dart' as productDetails;
import '../../sub_categories/models/SubCategories.dart';

class ProductDetailsController extends GetxController {
  final SubCategoriesController subCategoriesController = Get.find();
  final otherAddition = <bool>[].obs;
  final suaces = <bool>[].obs;
  final component = <bool>[].obs;
  final addition = <bool>[].obs;

  RxInt orderCounter = 1.obs;
  List<Drink>? drinks = <Drink>[].obs;
  Drink? drinkDropDownValue;

  RxDouble productPrice = 0.0.obs;
  RxDouble orderPrice = 0.0.obs;
  Drink selectedDrink = Drink();
    Sizes selectedSize=Sizes() ;
   List<bool> selectedAdditions = <bool>[].obs;
  List<bool> selectedComponents = <bool>[].obs;

   final priceList = <String>[].obs;

  List<Products> products = <Products>[].obs;
  var value ;

  var addressesBox;
  var cartBox;
  String dropDownValue = '';
  List<productDetails.ProductDetailsModel> productDetailsModel = <productDetails.ProductDetailsModel>[].obs;
  bool? typeValue;


  void change(vlaue) {
   value =vlaue;
   update();
   }
  Future<void> getAllRestaurantDrinks() async {
    AllDrinksResponse? response;
    try {
      response = await AllDrinksService.getAllDrinks();
    } catch (e) {
      print(e);
    }
    drinks!.addAll(response!.drinks);
    print(response.drinks);
  }

  @override
  Future<void> onInit() async {
    await getAllRestaurantDrinks();
    otherAddition.value = List.filled(drinks!.length, false);
    // value=products.first.sizes?.first;
    super.onInit();
  }


  @override
  void dispose() {
     super.dispose();

   }

  selectType(newValue) {
    typeValue = newValue;
    update();
  }

  updatePriceList(String price) {
    priceList.add(price);
    print(priceList);
  }
}
