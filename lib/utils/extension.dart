import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_color.dart';

extension SizedExtension on double {
  addHSpace() {
    return SizedBox(height: this);
  }

  addWSpace() {
    return SizedBox(width: this);
  }
}

extension AppDivider on double {
  Widget appDivider({Color? color}) {
    return Divider(
      thickness: this,
      color: color ?? Colors.white,
    );
  }
}
extension AppValidation on String {
  isValidEmail() {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}
hideKeyBoard(BuildContext context) {
  return FocusScope.of(context).unfocus();
}
printData({required dynamic tittle, dynamic val}) {
  debugPrint(tittle + ":-" + val.toString());
}
extension ReadexPro on String {
  Widget regularReadex({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w300,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
    );
  }

  Widget mediumReadex(
      {Color? fontColor,
        double? fontSize,
        TextDecoration? textDecoration,
        TextOverflow? textOverflow,
        TextAlign? textAlign,
        int? maxLine}) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
      maxLines: maxLine,
    );
  }

  Widget semiBoldReadex({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w600,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
    );
  }

  Widget boldReadex({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w700,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'ReadexPro'),
      textAlign: textAlign,
    );
  }
}

extension AlegreyaSC on String {
  Widget regularAlegreyaSC({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w300,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'AlegreyaSC'),
      textAlign: textAlign,
    );
  }

  Widget mediumAlegreyaSC({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w400,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'AlegreyaSC'),
      textAlign: textAlign,
    );
  }

  Widget boldAlegreyaSC({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
          color: fontColor ?? appColor,
          fontSize: fontSize ?? 16,
          fontWeight: FontWeight.w700,
          decoration: textDecoration ?? TextDecoration.none,
          fontFamily: 'AlegreyaSC'),
      textAlign: textAlign,
    );
  }
}

extension Roboto on String {
  Widget regularRoboto({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor ?? appColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w300,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget mediumRoboto({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor ?? appColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w400,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }

  Widget boldRoboto({
    Color? fontColor,
    double? fontSize,
    TextDecoration? textDecoration,
    TextOverflow? textOverflow,
    TextAlign? textAlign,
  }) {
    return Text(
      this,
      overflow: textOverflow,
      style: TextStyle(
        color: fontColor ?? appColor,
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w700,
        decoration: textDecoration ?? TextDecoration.none,
      ),
      textAlign: textAlign,
    );
  }
}


enum LoginType {
  Google,
  Facebook,
  App,
}

Widget createLoginButton(
    LoginType type, {
      required Function()? onPressed,
      required String text,
      required IconData icon,
      Color? color,
      required Color borderColor,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor, // Set the color of the border
          width: 2, // Set the width of the border
        ),
      ),
      height: 40,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          10.00.addWSpace(), // Adjust spacing as needed
          Text(text),
        ],
      ),
    ),
  );
}

Widget appButton(
    {double? height,
      double? width,
      required var onTap,
      Color? color,
      String? text,
      double? fontSize,
      Color? fontColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height ?? 6.5.h,
      width: width ?? 90.w,
      decoration: BoxDecoration(
          color: color ?? appColor, borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: (text ?? "").semiBoldReadex(
              fontColor: fontColor ?? whiteColor, fontSize: fontSize ?? 14.sp)),
    ),
  );
}


