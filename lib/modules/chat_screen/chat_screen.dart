import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/more_info_constants.dart';
import 'package:arrows/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../components/arrows_app_bar.dart';
import '../../helpers/shared_prefrences.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);
  final translateName = CacheHelper.getDataToSharedPrefrence("localeIsArabic");
  ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ArrowsAppBar('messages'.tr),

      body:
   GetBuilder<ChatController>(
     init: ChatController(),

       builder: (controller)=> controller.messegesList.isNotEmpty?
       ListView.builder(
        itemCount: controller.messegesList.length,
          shrinkWrap: true,
          padding:  EdgeInsets.only(top: 22.h,bottom: 22.h,right: 10.w,left: 10.w),
          itemBuilder: (BuildContext cont, index){
    return  Card(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5)),
        elevation: 3,
        color: mainColor,
        child:   Container(
            padding:  EdgeInsets.only(top: 10.h,bottom: 22.h, ),
            height: 150.h,
             child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(k.restLogo.tr,height: 50.h,width: 50.w,),
                    // SizedBox(width: 10.w,),
                    Text(k.restName.tr,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.sp),),
                    SizedBox(width: 10.w,),

                  ],
                ),

          Flexible(
          child: Container(
                       padding:  EdgeInsets.only(right: 10.w,left: 10.w, ),

                          child: Text(
                            '${controller.messegesList[index]}'.tr,
                            textDirection: translateName
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.sp),),
                          )

                  ),




              ],
            ),
          ),

    );
      })
           : Center(child:Column(
         mainAxisSize: MainAxisSize.max,
         children: [
           Image.asset(
             'assets/images/ic_empty.png',
             height: 500.h,
             width: double.infinity,
           ),
           Center(
               child: Text(
                 "no_messages".tr,
                 style: TextStyle(
                     fontSize: 25.sp,
                     color: mainColor,
                     fontWeight: FontWeight.bold),
               ))
         ],
       ))


    ));
  }
}
