import 'package:arrows/constants/colors.dart';
import 'package:arrows/constants/more_info_constants.dart';
import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ArrowsAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;

  ArrowsAppBar(this.title, {Key? key,})
      : preferredSize =  Size.fromHeight(70.h),
        super(key: key);

  @override
  State<ArrowsAppBar> createState() => _ArrowsAppBarState();
}

class _ArrowsAppBarState extends State<ArrowsAppBar> {


  @override
  Widget build(BuildContext context) {
    return  AppBar(
      centerTitle: true,
        title: Text('${widget.title}'.tr,style: TextStyle(color: kPrimaryColor,fontSize: 25.sp,fontWeight: FontWeight.bold),),

        actions:[
          SizedBox(width: 5.w,),
          Image.asset(
      k.restLogo,
      height: 30.h,
      width: 50.w,
      fit: BoxFit.contain,
    ),
          SizedBox(width: 5.w,),
],leading:Text(''),
  );
  }
}
