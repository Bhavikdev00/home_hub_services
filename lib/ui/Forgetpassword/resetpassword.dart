import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/ui/Forgetpassword/resetpasswordreset.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_assets.dart';
import '../../constraint/app_color.dart';
import '../../constraint/app_string.dart';

class ResetPassword extends StatefulWidget {
   ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  ResetPasswordController _resetPasswordController = Get.put(ResetPasswordController());
  final _globel = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        child: Form(
          key: _globel,
          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.h.addHSpace(),
                AppString.resetPassword
                    .boldRoboto(fontColor: Colors.black, fontSize: 30),
                1.h.addHSpace(),
                AppString.resetPasswordTital.mediumRoboto(
                    fontSize: 15,
                    textOverflow: TextOverflow.ellipsis),
                5.h.addHSpace(),
            "New Password".mediumRoboto(fontColor: Colors.black),
                1.h.addHSpace(),
            Obx(
              () {
                return TextFormField(
                  obscureText: _resetPasswordController.isPasswordVisible.value,
                  controller: _resetPasswordController.passwordController,
                  validator: (value) {
                    if (value == null ||
                        !AppAssets.isvalidpassword(value)) {
                      return "Enter the validPassword";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: Icon(MdiIcons.formTextboxPassword),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _resetPasswordController.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        _resetPasswordController.togglePasswordVisibility();
                      },
                    ),
                  ),
                );
              },
            ),
                3.h.addHSpace(),
                "Conform new Password".mediumRoboto(fontColor: Colors.black),
                1.h.addHSpace(),
                Obx(
                  () {
                    return TextFormField(
                      obscureText: _resetPasswordController.cisPasswordVisible.value,
                      controller: _resetPasswordController.CpasswordController,
                      validator: (value) {
                        if (value == null || _resetPasswordController.CpasswordController.text != value){
                          return "Enter the validPassword";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Cpassword",
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(MdiIcons.formTextboxPassword),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _resetPasswordController.cisPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            _resetPasswordController.toggleCpasswordVisiblity();
                          },
                        ),
                      ),
                    );
                  },
                ),
                5.h.addHSpace(),
                Obx(
                  () {
                    return _resetPasswordController.isLoading.value ? LoadingAnimationWidget.hexagonDots(
                        color: appColor, size: 5.h) : appButton(onTap: () async {
                          if(_globel.currentState!.validate()){
                            var checkPasswordStatus = await _resetPasswordController.changePassword();
                            if(checkPasswordStatus){
                              Get.offAllNamed(Routes.loginScreen);
                            }else{
                              Get.snackbar("Password Change Error","Check The Network");
                            }
                          }else{
                            Get.snackbar("Conform Password MisMatch","MisMatch Password");
                          }
                    },
                      text: "Reset Password",
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
