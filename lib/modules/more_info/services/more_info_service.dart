import 'dart:convert';

import 'package:arrows/api_base/api_endpoints.dart';
import 'package:arrows/api_base/dio_helper.dart';
import 'package:arrows/modules/more_info/models/barcode_used.dart';
import 'package:arrows/modules/more_info/models/more_info_response_model.dart';
import 'package:dio/dio.dart';

import '../models/BarcodModel.dart';
import '../models/BarcodeUsed2.dart';

class MoreInfoService {
  static Future<MoreInfoResponse?> getRestaurantMoreInfo() async {
    try {
      Response? response = await DioHelper.getData(
        url: endpoint[Endpoint.getRestaurantMoreInfo],
      );
      return MoreInfoResponse.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }



  static Future <BarcodModel?> getBarcodes(  phone) async {
    try {
      Response? response = await DioHelper.getData(
          url: "${endpoint[Endpoint.getBarcodes]}${phone}");
      print(response.data);
      return BarcodModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
    }
    return null;
  }


  static Future<Response?>registerBarcodeUsed(BarCodeUsedBody barcodeUsed2)async{

    Response? response;
    response = await DioHelper.postData(url: endpoint[Endpoint.getBarcodesUsed] , query: barcodeUsed2.toJson());
    print(response.data);
    return response;
  }





}






