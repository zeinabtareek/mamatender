import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/more_info/models/BarcodeUsed2.dart';
import 'package:arrows/modules/more_info/models/more_info_response_model.dart';
import 'package:arrows/modules/more_info/services/more_info_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../../cart/services/coupon_used_body.dart';
import '../models/BarcodModel.dart';
import '../models/barcode_used.dart';

class MoreInfoController extends GetxController {
  Info? restaurantMoreInfo = Info();
  List<String> restaurantPhoneNumbers = <String>[].obs;
  List<BarcodModel> barcods = [];
  final passwordVisible = true.obs;
  final isLoading = false.obs;

  TextEditingController barcodeController = TextEditingController();
  TextEditingController feedbackMessageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Map points = {};

  Future<void> getRestaurantMoreInfo() async {
    MoreInfoResponse? response = await MoreInfoService.getRestaurantMoreInfo();
    print(response!.data);
    restaurantMoreInfo = response.data!;
    if (response.data!.phone1 != "") {
      restaurantPhoneNumbers.add(response.data!.phone1 ?? "");
    }
    if (response.data!.phone2 != "") {
      restaurantPhoneNumbers.add(response.data!.phone2 ?? "");
    }
    if (response.data!.phone3 != "") {
      restaurantPhoneNumbers.add(response.data!.phone3 ?? "");
    }
  }




  BarcodModel? barcodModel;

  Future getBarcodes()  async {
    // isLoading.value=true;
    // barcodModel =  await MoreInfoService.getBarcodes('01111292') ;
    // barcodModel =  await MoreInfoService.getBarcodes(CacheHelper.loginShared!.phone!.substring(1)) ;
    barcodModel =  await MoreInfoService.getBarcodes(CacheHelper.loginShared!.phone!.substring(1)) ;
    print(barcodModel!.data);
    // isLoading.value=true;

update();
       return  barcodModel;

  }


  Future<void> usedBarcodes(BuildContext context,   id) async {
    BarCodeUsedBody barcodeUsed2 = await BarCodeUsedBody(
      barcode_id: id,
      // phone_number:'01111292',
      phone_number:CacheHelper.loginShared!.phone!.substring(1),

    );
    dio.Response? response;
    response = await MoreInfoService.registerBarcodeUsed(barcodeUsed2);

  }







  changevisibility() {
    passwordVisible.value = !passwordVisible.value;
    update();
  }

  @override
  Future<void> onInit() async {
    getRestaurantMoreInfo();

    print(')))))))))))))))))))))))))${CacheHelper.loginShared!.phone!.substring(1)}((((((((((((');
    await getBarcodes();
    isLoading.value = true;
    await getRestaurantMoreInfo();

    isLoading.value = false;

    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    barcodeController.clear();
    super.dispose();
  }
}
