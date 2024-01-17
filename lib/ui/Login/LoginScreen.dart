import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_services/constraint/app_string.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:home_hub_services/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../constraint/app_assets.dart';
import '../../constraint/app_color.dart';
import 'logincontroller.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final _globel = GlobalKey<FormState>();
  final LoginController _controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _globel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.w.addHSpace(),
                  Center(
                    child: AspectRatio(
                        aspectRatio: 18 / 12,
                        child: assetLottieAnimation(path: "assets/lottie/BW9l4PezSJ.json")),
                  ),
                  AppString.loginString.mediumRoboto(
                    fontColor: Colors.black,
                    fontSize: 38,
                  ),
                  4.h.addHSpace(),
                  TextFormField(
                    validator: (value) {
                      if (value == null || !AppAssets.isvalidemail(value)) {
                        return "Enter the Valid Email";
                      } else {
                        return null;
                      }
                    },
                    controller: _controller.emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),

                  SizedBox(
                    height: 2.h,
                  ),
                  Obx(
                    () {
                      return TextFormField(
                        obscureText: _controller.isPasswordVisible.value,
                        controller: _controller.passwordController,
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
                              _controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              _controller.togglePasswordVisibility();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  appTextFormField(labelText: "Password",prefixIcon:Image.asset("assets/images/padlock.png",width: 10,height: 10,scale: 3,) ),
                  0.1.h.addHSpace(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: MaterialButton(
                      onPressed: () {
                        Get.toNamed(Routes.forgetPassword);
                      },
                      child: "Forget Password".mediumReadex(),
                    ),
                  ),
                  1.h.addHSpace(),
                  Obx(
                    () => _controller.isLoading.value
                        ? LoadingAnimationWidget.hexagonDots(
                            color: appColor, size: 5.h)
                        : appButton(
                            onTap: () async {
                              if (_globel.currentState!.validate()) {
                                var checkStatus = await _controller.signInWithEmailAndPassword();
                                if(checkStatus is UserCredential){
                                  Get.offAllNamed(Routes.navbarRoots);
                                }
                                else{
                                  print("Error");
                                }
                              } else {
                                print("Error");
                              }
                            },
                            text: "Sign up"),
                  ),
                  3.h.addHSpace(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                        2.w.addWSpace(),
                        // Adding space between the divider and text
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "or continue with",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16, // Adjust font size as needed
                              color: Colors
                                  .black, // Change text color if necessary
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // Adding space between the text and divider
                        const Expanded(
                          flex: 2,
                          child: Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  2.h.addHSpace(),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      "Don't have an account?"
                          .mediumRoboto(fontSize: 14, fontColor: Colors.grey),
                      SizedBox(
                        width: 1.w,
                      ),
                      InkWell(
                          onTap: () {
                            Get.toNamed(Routes.registerScreen);
                          },
                          child: "Sign up"
                              .boldRoboto(fontColor: lightBlue, fontSize: 15))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
