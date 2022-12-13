import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class CustomCartButton extends StatelessWidget {
  String  ?text ;
  VoidCallback  ?onPressed ;
  Color color;
  Color textColor;
  bool isCart;
    CustomCartButton({
   required this.text,
   required this.onPressed,
   required this.textColor,
   required this.color,
  required this.isCart,

    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 50.w,
        height: Get.height/16.h,
        // Button(
        // text: 'continue_shopping'.tr,
        // size: 250,
        // height:Get.height/20.h,
        // onPressed: ()async {
        child: TextButton(
          onPressed:onPressed,
          style: TextButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r))),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 text!.tr,
                  style: TextStyle(color: textColor, fontSize: 14.sp),
                ),
               SizedBox(width: 5.w,),
               isCart? Icon(
                  Icons.shopping_cart_outlined,
                  color: textColor,size: 25.sp,
                ):SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}