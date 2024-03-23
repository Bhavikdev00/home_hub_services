import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:home_hub_services/utils/app_routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:otp/otp.dart';

import '../../ModelClasses/servicesProvider.dart';
import '../../getstorage/StorageClass.dart';



class RegisterDetailsController extends GetxController{
  Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);
  CollectionReference ServiceProfile = FirebaseFirestore.instance.collection('service_provider_requests');
  CollectionReference otpService = FirebaseFirestore.instance.collection('otp');
  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final Reference _storageRef = FirebaseStorage.instance.ref();
  final TextEditingController contact = TextEditingController();
  final StorageService _storageService = StorageService();
  final TextEditingController contactOptional = TextEditingController();
  final TextEditingController address = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool loadAddData = false.obs;

  // ************************ Image user And Aadhare Pick ************************

  Rx<File?> imageFile = Rx<File?>(null);
  Rx<File?> aadharCard = Rx<File?>(null);
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }


  Future<void> pickImageaadhare() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
        aadharCard.value = File(pickedFile.path);
    }
  }

  @override
  void onClose() {
    fName.dispose();
    lName.dispose();
    address.dispose();
    contact.dispose();
    contactOptional.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.onClose();
  }
  @override
   void onInit() async {
    super.onInit();
    controllers = List.generate(6, (_) => TextEditingController());
    otpValues = List.generate(6, (_) => RxString(''));
    user.bindStream(_auth.authStateChanges());
    loadCategoryList();
    _bindControllers();
  }



  var selectedServices = Rx<String?>(null);
  void setSelectedService(String? service) {
    selectedServices.value = service;
  }
  RxList<String> selectServices = <String>[].obs;
  Future<void> loadCategoryList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("servicesInfo").get();

    try {
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
      in snapshot.docs) {
        // Change "fieldName" to the actual field name you want to extract
        String fieldValue = document['ServiceName'];

        // Add the field value to the list
        if (fieldValue != null) {
          selectServices.add(fieldValue);
        }
      }

    } catch (e) {
      print('Error loading category list: $e');
      // Handle the error if necessary
    }
  }

  Future<void> startResendTimer({required String email,String? password}) async {
    isLoading(true);
    canResend.value = false;
    resendTimeout.value = 30;
    await resendOtp(email);
    _timer.value = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimeout.value > 0) {
        resendTimeout.value--;
      } else {
        canResend.value = true;
        _timer.value?.cancel();
      }

    });
  }


  resendOtp(String email) async {
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
      isLoading(false);
      await sendOTPTOFirebase(email,otp);

    } on MailerException catch (e) {
      print('Failed to send the email: $e');
    }

  }
  Future<void> sendOTPTOFirebase(String email, String otp) async {
    try{
      await otpService.doc(email).set({
        'email' : email,
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(), // Store server timestamp
      });
    }catch(e){
      print('Error sending OTP data: $e');
    }
  }

  // *******************************vitrifyController*********************************
  late final List<TextEditingController> controllers;
  late final List<RxString> otpValues;
  RxBool canResend = true.obs;
  RxInt resendTimeout = 30.obs;
  late Rx<Timer?> _timer = Rx<Timer?>(null);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? get userId => user.value?.uid;

  Future<bool> checkOTPFromFirestore(String email, String password) async {
    try{
      loadAddData(true);
      DocumentSnapshot snapshot = await otpService.doc(email).get();
      if(snapshot.exists){
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String storedOTP = data['otp'];
        Timestamp timestamp = data['timestamp'];
        int currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        int storedTimeInSeconds = timestamp.seconds;
        int timeDifference = currentTimeInSeconds - storedTimeInSeconds;
        String otp =  otpValues.map((otpValue) => otpValue.value).join();
        if (otp == storedOTP && timeDifference <= 200) {
             await AddData(email,password);
             _storageService.RegisterStatusCheck(true);
             _storageService.loginStatusCheck(false);
           loadAddData(false);
          return true; // OTP matches and within the time limit
        }
        else{
          clearAllFields();
          Get.snackbar(
            "Email is Not Varify",
            "Try Again",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.notification_add),
          );
          loadAddData(false);
        }
      }
    }catch (e) {
      loadAddData(false);
      print('Error checking OTP: $e');
    }
    loadAddData(false);
    return false;
  }

  Future<void> createAccount(String email,String password) async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );


    }on FirebaseAuthException catch (e){
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }catch(e){
      print('Error occurred: $e');
    }
  }

  Future<void> AddData(String email, String password) async {
    try{
      await createAccount(email,password);
      var image = await uploadServicesUserImages(imageFile.value!);
      var userAdhareCard = await UploadAddhareCardUser(aadharCard.value!,email,aadharCard.value);
      ServicesData service = ServicesData(Uid: user.value!.uid, Images: image, email: user.value!.email!, contectnumber: contact.text, contectNumber2: contactOptional != null ? contactOptional.text : "", address: address.text.toString().trim(), services: selectedServices.value!,password: password,fname: fName.text.toString().trim(),lname: lName.text.toString().trim(),useraadharcard: userAdhareCard,status: "Pending");
      String Names = "${fName.text.toString().trim()} ${lName.text.toString().trim()}";
      user.value!.updateDisplayName(Names);
      DocumentReference documentReference = await ServiceProfile.add(service.tomap());
      String docId = documentReference.id;
      service.Did=docId;
      await ServiceProfile.doc(docId).update(service.tomap());

    }catch(e){
      print("Error Is $e");
    }
  }
  void clearAllFields() {
    for (final controller in controllers) {
      controller.clear();
    }
    for (final value in otpValues) {
      value.value = '';
    }
  }


  Future<String> uploadServicesUserImages(File imageFile) async {
    String url = "";
    String tempFile = basename(imageFile.path);
    var ex = extension(tempFile);
    String filename = tempFile;
    try{
      var image = await _storageRef.child("ServiceProfile").child(filename).putFile(imageFile);
      if(image != null){
        url = await _storageRef.child("ServiceProfile").child(filename).getDownloadURL();
      }
    }on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }

  UploadAddhareCardUser(File file, String email, File? imageFile) async {
    String url = "";
    String tempFile = basename(imageFile!.path);
    String filename = email;
    var ex = extension(tempFile);
    var filenames = "$filename$ex";
    try{
      var image = await _storageRef.child("aadhar_card").child(filenames).putFile(file);
      if(image != null){
        url = await _storageRef.child("aadhar_card").child(filenames).getDownloadURL();
      }
    }on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }
  void _bindControllers() {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        otpValues[i].value = controllers[i].text;
      });
    }
  }
}