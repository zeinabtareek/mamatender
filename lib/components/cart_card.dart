import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class CartIngrediantRow extends StatelessWidget {
  Widget? widget;
  String? textKey;

  CartIngrediantRow({Key? key, this.textKey, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget!,
          SizedBox(
            width: 1,
          ),
          Text(
            ': $textKey',
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}