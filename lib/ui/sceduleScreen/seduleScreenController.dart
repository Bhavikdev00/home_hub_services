import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';

import '../../ModelClasses/OrderResModel.dart';
import '../../ModelClasses/user.dart';
import '../../getstorage/StorageClass.dart';
import '../notification_services/notification_service.dart';

class SeduleScreen extends GetxController {
  List<OrderResModel> pending = [];
  List<OrderResModel> completed = [];
  List<OrderResModel> canceled = [];
  List<UserData> userdatas = [];
  final StorageService _storageService = StorageService();
  bool load = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSeduleScreen();
  }

  void loadSeduleScreen() {
    load = true;
    String uid = _storageService.getUserid();
    Stream<QuerySnapshot> allData = FirebaseFirestore.instance.collection("Orders").where("serviceProviderId", isEqualTo: uid).snapshots();
    allData.listen((event) {
      pending.clear();
      completed.clear();
      canceled.clear();
      event.docs.forEach((element) async {
        Map<String, dynamic> data = element.data() as Map<String, dynamic>;
        OrderResModel orderResModel = OrderResModel.fromJson(data);
        UserData userData = await GetUserData(orderResModel.userId);
        userdatas.add(userData);
        if(orderResModel.status == "Pending"){
            pending.add(orderResModel);
            update();
        }else if(orderResModel.status == "Accepted"){
            completed.add(orderResModel);
            update();
        }else{
          canceled.add(orderResModel);
          update();
        }
      });
      update();
    });
    load = false;
  }

   GetUserData(String? userId) async {
     CollectionReference serviceProviderUserCollection = FirebaseFirestore.instance.collection("User");
     QuerySnapshot userData = await serviceProviderUserCollection.where("uId", isEqualTo: userId).get();
     if (userData.docs.isNotEmpty) {
       return UserData.fromJson(userData.docs.first.data() as Map<String, dynamic>);
     }
  }


  Future<void> cancel(OrderResModel order) async {
    order.status = "Cancel";
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
  }


  Future<void> reConform(OrderResModel order) async{
    order.status = "Pending";
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
  }



  Future<void> deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection("Orders").doc(orderId).delete();
      print("remove");
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  Future<void> sendotp(String email) async {
    String secret = 'asdnasjdnasjdnasjdasdnasjdnajsdndnasdjnasd';
    String otp = OTP.generateTOTPCode(secret, DateTime.now().millisecondsSinceEpoch).toString();
    final smtpServer = gmail('zsp.bhavik@gmail.com', 'iwvu vtof svpj ubfc');
    // Create the email message
    final message = Message()
      ..from = Address('vyasparth451@gmail.com', 'Help Harbor')
      ..recipients.add(email)
      ..subject = 'Email Verification OTP'
      ..html = '''
     <!DOCTYPE html>
<html>

<head>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f4f4f4;
      color: #333;
      margin: 0;
      padding: 0;
      text-align: center;
    }

    .container {
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    h2 {
      color: #007bff;
    }

    .verification-code {
      color: #007bff;
      font-size: 36px;
      margin: 20px 0;
    }

    .expire-message {
      color: #dc3545;
      margin-top: 10px;
    }

    .notice {
      color: #28a745;
      margin-top: 10px;
    }

    .support-info {
      margin-top: 20px;
    }

    .contact-link {
      color: #007bff;
      text-decoration: none;
      font-weight: bold;
    }
  </style>
</head>

<body>
  <div class="container">
    <h2>Home Hub Services Email Verification</h2>
    <p>Dear User,</p>
    <p>Your verification code for Home Hub Services is:</p>
    <h1 class="verification-code">$otp</h1>
    <p class="expire-message">This code will expire in 5 minutes.</p>
    <p class="notice">Please do not share this code with anyone for security reasons.</p>
    <p>If you have any questions or need assistance, feel free to reach out to our support team.</p>
    <div class="support-info">
      <p>Contact us at: <a class="contact-link" href="mailto:support@homehub.com">support@homehub.com</a></p>
    </div>
    <p>Thank you for choosing Home Hub!</p>
  </div>
</body>

</html>

    ''';

    try {
      final sendReport = await send(message, smtpServer);

      print('Message sent: ${sendReport.toString()}');
      // isLoading(false);
      // store in GetStorage
       await _storageService.updateOtp(otp);
      // await sendOTPTOFirebase(email,otp);
    } on MailerException catch (e) {
      print('Failed to send the email: $e');
    }

  }

  Future<void> actupted(OrderResModel order, UserData userdata)
  async {
    String name = _storageService.getName();
    order.status = "Accepted";
    await FirebaseFirestore.instance.collection("Orders").doc(order.orderId).update(order.toJson());
    NotificationService.sendMessage(
      msg: "Order Accepted",
      title: "$name",
      receiverFcmToken: userdata.fcmToken,
    );
    // sendotp(userdata.email);
  }
}
