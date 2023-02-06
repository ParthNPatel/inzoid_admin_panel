import 'package:flutter/material.dart';
import 'package:inzoid_admin_panel/constant/text_const.dart';

class CommonText {
  static textBoldWight400(
      {required String text,
      double? fontSize,
      Color? color,
      FontWeight fontWeight = FontWeight.w400}) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          fontFamily: TextConst.fontFamily),
    );
  }

  static textBoldWight500(
      {required String text,
      double? fontSize,
      Color? color,
      FontWeight fontWeight = FontWeight.w500,
      TextDecoration textDecoration = TextDecoration.none}) {
    return Text(
      text,
      style: TextStyle(
          decoration: textDecoration,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
          fontFamily: TextConst.fontFamily),
    );
  }

  static textBoldWight700(
      {required String text,
      double? fontSize,
      Color? color,
      TextDecoration textDecoration = TextDecoration.none}) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
          decoration: textDecoration,
          color: color,
          fontFamily: TextConst.fontFamily),
    );
  }

  ///textStyle

}
