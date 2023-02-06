import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../constant/text_styel.dart';

class CommonWidget {
  static SizedBox commonSizedBox({double? height, double? width}) {
    return SizedBox(height: height, width: width);
  }

  static Widget textFormField(
      {String? hintText,
      List<TextInputFormatter>? inpuFormator,
      required TextEditingController controller,
      int? maxLength,
      TextInputType? keyBoardType,
      bool isObscured = false,
      Widget? suffix}) {
    return SizedBox(
      height: 19.sp,
      width: 150.sp,
      child: TextFormField(
        obscureText: isObscured,
        inputFormatters: inpuFormator,
        maxLength: maxLength,
        controller: controller,
        keyboardType: keyBoardType,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: TextConst.fontFamily,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 7.sp, left: 6.sp),
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(
              fontFamily: TextConst.fontFamily,
              fontWeight: FontWeight.w500,
              color: CommonColor.hinTextColor),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(3),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: themColors309D9D),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  static getSnackBar(
      {required String title,
      required String message,
      Color color = themColors309D9D,
      Color colorText = Colors.white,
      int duration = 2}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: colorText,
        fontSize: 16.0);
    // Get.snackbar(
    //   title,
    //   message,
    //   snackPosition: SnackPosition.TOP,
    //   colorText: colorText,
    //   duration: Duration(seconds: duration),
    //   padding: EdgeInsets.only(left: 100),
    //   backgroundColor: color,
    // );
  }

  static commonButton(
      {required VoidCallback onTap, required String text, double radius = 10}) {
    return MaterialButton(
      onPressed: onTap,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      color: CommonColor.themColor309D9D,
      height: 10.sp,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CommonText.textBoldWight400(
              text: text, color: Colors.white, fontSize: 5.sp)
        ]),
      ),
    );
  }

  static Widget commonSvgPitcher(
      {required String image,
      required double height,
      required double width,
      Color? color}) {
    return SvgPicture.asset(
      image,
      color: color,
      height: height,
      width: width,
    );
  }
}
