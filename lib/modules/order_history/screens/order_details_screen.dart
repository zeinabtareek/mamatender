import 'package:arrows/components/arrows_app_bar.dart';
import 'package:arrows/modules/order_history/controllers/order_history_controller.dart';
import 'package:arrows/modules/where_to_deliver/models/firebase_address_model.dart';
import 'package:arrows/shared_object/order_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/cart_card.dart';
import '../../../constants/colors.dart';
import '../../../helpers/shared_prefrences.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../where_to_deliver/controllers/Where_to_controller.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({Key? key, required this.order}) : super(key: key);
  late final Order order;
  final translateName = CacheHelper.getDataToSharedPrefrence("localeIsArabic");



   @override
  Widget build(BuildContext context) {


     final landScape =
         MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: ArrowsAppBar('orders'.tr),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenUtil().screenWidth,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // itemCount: con.list.length,
                    itemCount: order.listOfProduct!.length,
                    itemBuilder: (context, index) {



                      return Padding(
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
                                          "${order.listOfProduct![index].name}".tr
                                              .toUpperCase(),
                                          style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Directionality(
                                          textDirection: translateName
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                          child:
                                          Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: translateName ? BorderRadius.only(bottomRight: Radius.circular(15)) : BorderRadius.only(bottomLeft: Radius.circular(15))),
                                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                  CartIngrediantRow(
                                                      textKey: 'price'.tr,
                                                      widget: Text(
                                                          "${order.listOfProduct![index].price}".tr,
                                                        style: TextStyle(fontSize: 12.sp),
                                                      )),

                                                  Divider(
                                                    thickness: .7,
                                                    height: 2,
                                                    color: Colors.grey,
                                                  ),


                                                  CartIngrediantRow(
                                                    textKey: 'pick_size'.tr,
                                                    widget: Text(
                                                      '${"${order.listOfProduct![index].sizes}"}'.tr,
                                                      style: TextStyle(fontSize: 12.sp),
                                                    ),
                                                  ),
                                                  CartIngrediantRow(
                                                    textKey: 'spices'.tr,
                                                    widget: Text(
                                                      '${"${order.listOfProduct![index].spices}".tr}'.tr,
                                                      style: TextStyle(fontSize: 12.sp),
                                                    ),
                                                  ),

                                                  Divider(
                                                    thickness: .7,
                                                    height: 2,
                                                    color: Colors.grey,
                                                  ),
                                                  order
                                                      .listOfProduct![
                                                  index]
                                                      .components!
                                                      .length!=null? CartIngrediantRow(
                                                                               textKey: 'extras'.tr,
                                                                               widget: SizedBox(
                                                                                 height: 30.h,
                                                                                 // width:
                                                                                 // Get.width/1..w,
                                                                                 // fontSize: 14,
                                                                                 child: ListView.separated(
                                                                                     separatorBuilder:
                                                                                         (context,
                                                                                             sepIndex) {
                                                                                       return Text(" , ");
                                                                                     },
                                                                                     shrinkWrap: true,
                                                                                     scrollDirection:
                                                                                         Axis.horizontal,
                                                                                     physics:
                                                                                         NeverScrollableScrollPhysics(),
                                                                                     itemCount: order
                                                                                         .listOfProduct![
                                                                                             index]
                                                                                         .components!
                                                                                         .length,
                                                                                     itemBuilder: (context,
                                                                                         contentIndex) {
                                                                                       return SizedBox(

                                                                                         child: Text('${order.listOfProduct![index].components![contentIndex].name.toString()}'.tr??
                                                                                             "",style: TextStyle(fontSize: 10.sp),),
                                                                                       );
                                                                                     }),
                                                                               ),
                                                                             ):SizedBox(),
                                                  Divider(
                                                    thickness: .7,
                                                    height: 2,
                                                    color: Colors.grey,
                                                  ),order.listOfProduct![index]
                                                  .additional !=
                                                  null
                                                  ? CartIngrediantRow(
                                                        textKey: 'general_extras'.tr,
                                                                               widget:  SizedBox(
                                                                                 height: 25.h,
                                                                                 // width: ScreenUtil
                                                                                 //     .defaultSize
                                                                                 //     .width -
                                                                                 //     300.w,
                                                                                 child: ListView
                                                                                     .separated(
                                                                                     separatorBuilder:
                                                                                         (context,
                                                                                         sepIndex) {
                                                                                       return Text(
                                                                                           " , ");
                                                                                     },
                                                                                     shrinkWrap:
                                                                                     true,
                                                                                     scrollDirection:
                                                                                     Axis
                                                                                         .horizontal,
                                                                                     physics:
                                                                                     NeverScrollableScrollPhysics(),
                                                                                     itemCount:
                                                                                     order
                                                                                         .listOfProduct![
                                                                                     index]
                                                                                         .additional!
                                                                                         .length,
                                                                                     itemBuilder:
                                                                                         (context,
                                                                                         contentIndex) {
                                                                                       return SizedBox(
                                                                                         child:
                                                                                         Text(
                                                                                           '${order.listOfProduct![index].additional![contentIndex].addition}'.tr ??
                                                                                               "_",
                                                                                           style: TextStyle(
                                                                                               fontSize:
                                                                                               12.sp),
                                                                                           maxLines:
                                                                                           2,
                                                                                           overflow:
                                                                                           TextOverflow.visible,
                                                                                         ),
                                                                                       );
                                                                                     }),
                                                                               )
                                                                               )
                                                                                   : SizedBox(),
                                                                             // ),
                                                 order.listOfProduct![index]
                                                                                   .additional !=
                                                                                   null
                                                                                   ? Divider(
                                                    thickness: .7,
                                                    height: 2,
                                                    color: Colors.grey,
                                                  )
                                                :SizedBox(),

                                                  CartIngrediantRow(
                                                    textKey: 'total'.tr,
                                                    widget: Row(
                                                      children: [
                                                        Text(
                                                          "${order.listOfProduct![index].price}".tr,
                                                          style: TextStyle(fontSize: 12.sp),
                                                        ),
                                                        Text(
                                                          'coin_jordan'.tr,
                                                          style: TextStyle(fontSize: 12.sp),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Divider(
                                                    thickness: .7,
                                                    height: 2,
                                                    color: Colors.grey,
                                                  ),


                                                ]),
                                              ),

                                            ],
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
                                          "${order.listOfProduct![index].photo}" ?? "",
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
                          ));


                    }),
              ),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: mainColor,
                ),
                child: Padding(
                  padding:   EdgeInsets.only(left: 8.0.w,right: 8.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("${'total'.tr} : ",
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.bold)),
                          Text(order.totalPrice.toString(),
                              style: TextStyle(
                                  fontSize: 25.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${'user_name'.tr} :" ,style: TextStyle(fontSize: 14.sp),),
                          Text('${order.client!.name.toString()}',style: TextStyle(fontSize: 14.sp),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${'user_phone'.tr} :',style: TextStyle(fontSize: 14.sp),),
                          Text('${order.client!.phone.toString()}',style: TextStyle(fontSize: 14.sp),),
                        ],
                      ),
                      order.address != null
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${'deliver_to'.tr} :',style: TextStyle(fontSize: 14.sp),),
                                Text('${order.address!.address}',style: TextStyle(fontSize: 14.sp),),
                              ],
                            )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${'receive_from'.tr} :',style: TextStyle(fontSize: 14.sp),),
                                Text('${order.branch!}',style: TextStyle(fontSize: 14.sp),),
                              ],
                            ),


                    ],
                  ),
                ),
              ),

              /**********************************************the End********************************************************/
            ],

        ),
        ),
        ),

    );
  }
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
