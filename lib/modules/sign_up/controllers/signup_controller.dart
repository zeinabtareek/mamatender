import 'package:arrows/helpers/shared_prefrences.dart';
import 'package:arrows/modules/bottom_nav_bar/screens/bottom_nav_bar_screen.dart';
import 'package:arrows/modules/sign_up/models/user_model.dart' as user;
import 'package:arrows/modules/sign_up/screens/verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../cart/controllers/cart_controller.dart';

class SignUpController extends GetxController {
  //
  TextEditingController phoneTextEditingController = TextEditingController();
  String? userNameTextEditingController;
  String? passwordTextEditingController;
  TextEditingController pinTextEditingController = TextEditingController();
  String? fullPhoneNumber;
  final pin=''.obs;
  CartController cartController=Get.put(CartController());
  //form key
  final formKey = GlobalKey<FormState>();

  //code
  String? verification;
  var userId;
  Future<void> sendVerificationCode({phone, name}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '$phone' ?? "",
      // phoneNumber: '${pin.value}${fullPhoneNumber}' ?? "",
      verificationCompleted: (PhoneAuthCredential phoneAuthCredentials) async {
        await FirebaseAuth.instance
            .signInWithCredential(phoneAuthCredentials)
            .then((value) {
          if (value.user != null) {
            print("user verified");
          }
          else
          {
            print('failed');
          }
          // CacheHelper.loginShared!.phone=fullPhoneNumber;
        });

      },
      verificationFailed: (FirebaseAuthException e) {
        Get.back();
        Get.defaultDialog(
            content: Text("${e.code}".tr) ,title: 'تعذر الإتصال بالإنترنت'
          // content: Text(" حاول مدره اخري".tr) ,title: 'تعذر الإتصال بالإنترنت'
        );
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        verification = verificationId;
        Get.back();
        Get.to(() => VerificationScreen(verification:verification.toString(),name:name,phone:phone));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verification = verificationId;
      },
      timeout: Duration(minutes: 1),
    );

  }
  addUserToRealTime(name,phone1)async{
    var users = await user.User(
      name: '$name',
      // name: userNameTextEditingController??'',
      phone: '$phone1',
      // phone: fullPhoneNumber,
      password: passwordTextEditingController,
       userDeviceToken:await CacheHelper.getDataToSharedPrefrence("deviceToken"),
      points:cartController.totalPoints!=null?cartController.totalPoints.toString():0.toString(),
      id:FirebaseAuth.instance.currentUser!.uid,
    );
    CacheHelper.loginShared = users;
    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .set(users.toJson());
    CacheHelper.loginShared = users;
    CacheHelper.saveDataToSharedPrefrence("userID", FirebaseAuth.instance.currentUser!.uid);
    CacheHelper.saveDataToSharedPrefrence("userName", users.name.toString());

  }
  Future<void> verifyCode(verification,name,phone1) async {

    PhoneAuthCredential credential = await PhoneAuthProvider.credential(
        verificationId: verification ?? "",
        smsCode: pinTextEditingController.text);
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
      if (value.user != null) {
        print(value.user!.uid);
        print('##################');
        print(value.additionalUserInfo!.isNewUser);
        if(value.additionalUserInfo!.isNewUser==true){
          addUserToRealTime(name,phone1);
          Get.back();
          //   var users = await user.User(
          //       name: userNameTextEditingController,
          //       phone: fullPhoneNumber,
          //       password: passwordTextEditingController,
          //     userDeviceToken:await CacheHelper.getDataToSharedPrefrence("deviceToken"),
          //     points:cartController.totalPoints!=null?cartController.totalPoints.toString():0.toString(),
          //     id:FirebaseAuth.instance.currentUser!.uid,
          // );
          //   CacheHelper.saveDataToSharedPrefrence("user", users.toJson());
          //   CacheHelper.loginShared = users;
          //   FirebaseDatabase.instance
          //       .reference()
          //       .child("Users")
          //       .child(FirebaseAuth.instance.currentUser!.uid)
          //       .set(users.toJson());
          // CacheHelper.saveDataToSharedPrefrence("userID", FirebaseAuth.instance.currentUser!.uid);
          // CacheHelper.saveDataToSharedPrefrence("userName", users.name.toString());
          Get.offAll(() => BottomNavBarScreen());
        }
        else if(value.additionalUserInfo!.isNewUser==false){
          var users = await user.User(
            name: name,
            // name: userNameTextEditingController??'',
            phone: phone1,
            // phone: fullPhoneNumber,
            password: passwordTextEditingController,
            userDeviceToken:await CacheHelper.getDataToSharedPrefrence("deviceToken"),
            id:FirebaseAuth.instance.currentUser!.uid,
          );

          FirebaseDatabase.instance
              .reference()
              .child("Users")
              .child(FirebaseAuth.instance.currentUser!.uid).reference()
              .update({
            'name':  name,
            'phone':  phone1,
            // 'name':  userNameTextEditingController??'',
            'device_token' :CacheHelper.getDataToSharedPrefrence("deviceToken"),
          }).then((value) {
            CacheHelper.saveDataToSharedPrefrence("user", users.toJson());
            CacheHelper.loginShared = users;
            print('*****************${CacheHelper.loginShared}${CacheHelper.getDataToSharedPrefrence('user')}');
           });

          CacheHelper.saveDataToSharedPrefrence("userID", FirebaseAuth.instance.currentUser!.uid);
          CacheHelper.saveDataToSharedPrefrence("userName", users.name.toString());
          Get.offAll(() => BottomNavBarScreen());
        }
      }

    }).then((value) {
     print(CacheHelper.getDataToSharedPrefrence('user'));
    });



  }
}
//&&&
