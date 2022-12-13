import 'package:arrows/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ClosedNowScreen extends StatelessWidget {
  const ClosedNowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
      Center(
      child:  Image.asset('assets/images/closed.jpeg',fit: BoxFit.contain,),
            // Image.asset('assets/icons/close.png',width: 200.w,height: 200.w,),
            // Text('closed_now'.tr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.sp),),

      ),
          ],      ),

    );
  }
}
