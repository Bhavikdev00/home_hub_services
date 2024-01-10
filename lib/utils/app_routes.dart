import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:home_hub_services/ui/HomeScreen/Homescreen.dart';
import 'package:home_hub_services/ui/Login/LoginScreen.dart';
import 'package:home_hub_services/ui/Forgetpassword/OtpToFormetPassword.dart';
import 'package:home_hub_services/ui/Register/RegisterDetails.dart';
import 'package:home_hub_services/ui/Register/register.dart';

import '../ui/Register/otpcheck.dart';
import '../ui/SplashScreen/splash_screen.dart';


class Routes{
  static String splashScreen = "/";
  static String loginScreen = "/login";
  static String registerScreen = "/register";
  static String registerDetails = '/registerDetails';
  static String otpProvide = '/otp';
  static String otpCheck = '/otpCheck';
  static String homeScreen = '/homeScreen';
  static final getPages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => Login(),),
    GetPage(name: registerScreen, page: () => Register(),),
    GetPage(name: registerDetails, page:() => RegisterDetails(),),
    GetPage(name: otpProvide, page: () => OtpVerify(),),
    GetPage(name: otpCheck, page: () => OtpCheck(),),
    GetPage(name: homeScreen, page: () => HomeScreen(),),
  ];
}