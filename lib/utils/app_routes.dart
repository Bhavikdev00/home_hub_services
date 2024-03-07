import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:home_hub_services/drawerscreens/addservices/Addservices.dart';
import 'package:home_hub_services/ui/Forgetpassword/otpvarify.dart';
import 'package:home_hub_services/ui/HomeScreen/Homescreen.dart';
import 'package:home_hub_services/ui/Login/LoginScreen.dart';
import 'package:home_hub_services/ui/Forgetpassword/Forgetpassword.dart';
import 'package:home_hub_services/ui/Navbarroots/navbar_roots.dart';
import 'package:home_hub_services/ui/Register/RegisterDetails.dart';
import 'package:home_hub_services/ui/Register/register.dart';
import 'package:home_hub_services/ui/SettingScreen/updatepassword/update_password.dart';
import 'package:home_hub_services/ui/containercode/newordercode.dart';
import 'package:home_hub_services/ui/servicesInfo/servicesInfo.dart';

import '../ui/Forgetpassword/resetpassword.dart';
import '../ui/Register/otpcheck.dart';
import '../ui/SplashScreen/splash_screen.dart';


class Routes{
  static String splashScreen = "/";
  static String loginScreen = "/login";
  static String registerScreen = "/register";
  static String registerDetails = '/registerDetails';
  static String forgetPassword = '/otp';
  static String otpCheck = '/otpCheck';
  static String homeScreen = '/homeScreen';
  static String navbarRoots = '/navbarRoots';
  static String otpInForgetPassword = '/forgetOtp';
  static String password = '/Password';
  static String addServices = '/addServices';
  static String servicesInfo = '/ServicesInfo';
  static String orderHistory = '/orderHistory';
  static String updatePasseword = '/UpdatePassword';
  static final getPages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => Login(),),
    GetPage(name: registerScreen, page: () => Register(),),
    GetPage(name: registerDetails, page:() => RegisterDetails(),),
    GetPage(name: forgetPassword, page: () => ForgetPassword(),),
    GetPage(name: otpCheck, page: () => OtpCheck(),),
    GetPage(name: homeScreen, page: () => HomeScreen(),),
    GetPage(name: otpInForgetPassword, page:() => OtpVarify()),
    GetPage(name: password, page: () => ResetPassword(),),
    GetPage(name: navbarRoots, page: () => NavBarRoot(),),
    GetPage(name: addServices, page: () => AddServices()),
    GetPage(name: servicesInfo, page: () => ServicesInfo(),),
    GetPage(name: orderHistory, page: () => OrderHistory(),),
    GetPage(name: updatePasseword, page: () => UpdatePassword(),)
  ];
}