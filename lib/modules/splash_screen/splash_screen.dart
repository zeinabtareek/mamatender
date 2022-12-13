import 'dart:async';

import 'package:arrows/constants/colors.dart';
import 'package:arrows/modules/MainBranches/screens/branches_screen.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {


    Timer(
        Duration(seconds: 5),
            () =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => BranchesScreen())));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [

            CircleAvatar(
            backgroundColor: mainColor.withOpacity(.6),
            radius: 167.r,
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              radius: 165.r,
              child:CircleAvatar(radius: (140.r),
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius:BorderRadius.circular(50),
                    child: Image.asset("assets/images/logo1.png"),
                  )
              )
            ), //CircleAvatar
          ),
              SizedBox(height: 50),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color: mainColor,
                    backgroundColor: mainColor.withOpacity(0.5),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
